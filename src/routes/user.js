const router = require("express").Router();
const { check, validationResult } = require("express-validator/check");
const User = require("../models/User");

router.post(
  "/",
  [
    check("name")
      .trim()
      .isLength({ min: 1 }),

    check("sex").isIn(["f", "m"]),

    check("email")
      .isEmail()
      .trim()
      .normalizeEmail(),

    check("password").isLength({ min: 8 })
  ],
  (request, response, next) => {
    const errors = validationResult(request);

    if (!errors.isEmpty()) {
      return response.sendStatus(422);
    }

    User.create(request.body, error => {
      if (error) {
        return response.sendStatus(500);
      }

      return response.sendStatus(200);
    });
  }
);

router.get("/", (request, response, next) => {
  User.get({ id: 1 }, (error, rows) => {
    if (error) {
      return response.sendStatus(500);
    }

    return response.status(200).json({ data: rows });
  });
});

module.exports = router;
