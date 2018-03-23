const router = require("express").Router();
const jwt = require("jsonwebtoken");
const { secret } = require("../config");
const { hash, compare } = require("bcryptjs");
const { check } = require("express-validator/check");
const { sanitize } = require("express-validator/filter");
const { auth, validate } = require("../utils/authValidate");

const User = require("../models/User");

const createToken = data => {
  return jwt.sign({ id: data.id }, secret, { expiresIn: "2 days" });
};

router.get("/user", auth, (request, response) => {
  User.get("id", request.user.id)
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

    check("date_of_birth").isBefore(),

    check("email")
      .trim()
      .isEmail(),

    check("password").isLength({ min: 8 }),

    sanitize("email").normalizeEmail(),

    validate
  ],
  (request, response) => {
    const { name, sex, date_of_birth, email, password } = request.body;

    User.existsByEmail(email)
      .then(data => {
        if (data) {
          return response.error(409, "Conflict");
        }

        return hash(password, 8)
          .then(hash => User.add(name, sex, date_of_birth, email, hash))
          .then(data => createToken(data))
          .then(data => response.json({ data }));
      })
      .catch(error => {
        console.log(error);
        response.error(500, "Internal Server Error");
      });
  }
);

router.post(
  "/user/token",
  [
    check("email")
      .trim()
      .isLength({ min: 1 }),

    check("password").isLength({ min: 1 }),

    sanitize("email").normalizeEmail(),

    validate
  ],
  (request, response) => {
    const { email, password } = request.body;

    User.getHashByEmail(email)
      .then(data => {
        if (!data) {
          return response.error(400, "Bad Request");
        }

        return compare(password, data.hash).then(result => {
          if (!result) {
            return response.error(400, "Bad Request");
          }

          return User.getByEmail(email)
            .then(data => createToken(data))
            .then(data => response.json({ data }));
        });
      })
      .catch(error => {
        console.log(error);
        response.error(500, "Internal Server Error");
      });
  }
);

module.exports = router;
