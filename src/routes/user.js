const router = require("express").Router();
const { hash, compare } = require("bcryptjs");
const { check, validationResult } = require("express-validator/check");
const { QueryResultError } = require("pg-promise").errors;

const User = require("../models/User");

router.post(
  "/",
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
      return response.error(422, "Unprocessable Entity");
    }

    const { name, sex, date_of_birth, email, password } = request.body;

    User.emailExists(email)
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
  "/token",
  [check("email").trim(), check("password").exists()],
  (request, response, next) => {
    const errors = validationResult(request);

    if (!errors.isEmpty()) {
      return response.error(422, "Unprocessable Entity");
    }

    const { email, password } = request.body;

    User.getHash(email)
      .then(row => {
        return compare(password, row.hash).then(result => {
          if (!result) {
            return response.error(400, "Bad Request");
          }

          return User.createJwt(email).then(result => {
            response.json(result);
          });
        });
      })
      .catch(error => {
        console.log(error);

        if (error instanceof QueryResultError) {
          response.error(400, "Bad Request");
        } else {
          response.error(500, "Internal Server Error");
        }
      });
  }
);

router.get("/", (request, response, next) => {
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

module.exports = router;
