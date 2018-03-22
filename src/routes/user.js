const router = require("express").Router();
const { hash, compare } = require("bcryptjs");
const { check, validationResult } = require("express-validator/check");
const { QueryResultError } = require("pg-promise").errors;

const User = require("../models/User");

router.get("/user", (request, response, next) => {
  if (!request.user) {
    return response.error(401, "Unauthorized");
  }

  User.get(request.user.id)
    .then(data => {
      response.json({ data });
    })
    .catch(error => {
      console.error(error);
      response.error(500, "Internal Server Error");
    });
});

router.post(
  "/user",
  [
    check("name")
      .trim()
      .isLength({ min: 1 }),

    check("sex").isIn(["f", "m"]),

    check("date_of_birth").exists(),

    check("email")
      .isEmail()
      .trim()
      .normalizeEmail(),

    check("password").isLength({ min: 8 })
  ],
  (request, response, next) => {
    const errors = validationResult(request);

    if (!errors.isEmpty()) {
      return response.error(422, "Unprocessable Entity", {
        invalid: Object.keys(errors.mapped())
      });
    }

    const { name, sex, date_of_birth, email, password } = request.body;

    User.exists(email)
      .then(data => {
        if (data.exists) {
          return response.error(409, "Conflict");
        }

        return hash(password, 8)
          .then(hash => {
            return User.create(name, sex, date_of_birth, email, hash);
          })
          .then(data => {
            return response.send();
          });
      })
      .catch(error => {
        console.error(error);
        response.error(500, "Internal Server Error");
      });
  }
);

router.post(
  "/user/token",
  [
    check("email")
      .trim()
      .normalizeEmail()
      .isLength({ min: 1 }),

    check("password").isLength({ min: 1 })
  ],
  (request, response, next) => {
    const errors = validationResult(request);

    if (!errors.isEmpty()) {
      return response.error(422, "Unprocessable Entity", {
        invalid: Object.keys(errors.mapped())
      });
    }

    const { email, password } = request.body;

    User.getHash(email)
      .then(row => {
        return compare(password, row.hash).then(result => {
          if (!result) {
            return response.error(400, "Bad Request");
          }

          return User.createJwt(email).then(data => {
            response.json({ data });
          });
        });
      })
      .catch(error => {
        if (error instanceof QueryResultError) {
          response.error(400, "Bad Request");
        } else {
          console.log(error);
          response.error(500, "Internal Server Error");
        }
      });
  }
);

module.exports = router;
