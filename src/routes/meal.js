const router = require("express").Router();
const { check, validationResult } = require("express-validator/check");

const Meal = require("../models/Meal");

router.get("/meals", [check("date").exists()], (request, response, next) => {
  if (!request.user) {
    return response.error(401, "Unauthorized");
  }

  const errors = validationResult(request);

  if (!errors.isEmpty()) {
    return response.error(422, "Unprocessable Entity", {
      invalid: Object.keys(errors.mapped())
    });
  }

  const { id } = request.user;
  const { date } = request.query;

  Meal.getAll(date, id)
    .then(data => {
      response.json({ data });
    })
    .catch(error => {
      console.error(error);
      response.error(500, "Internal Server Error");
    });
});

router.post(
  "/meal",
  [
    check("name")
      .trim()
      .isLength({ min: 1 }),

    check("date").exists()
  ],
  (request, response, next) => {
    if (!request.user) {
      return response.error(401, "Unauthorized");
    }

    const errors = validationResult(request);

    if (!errors.isEmpty()) {
      return response.error(422, "Unprocessable Entity", {
        invalid: Object.keys(errors.mapped())
      });
    }

    const { id } = request.user;
    const { name, date } = request.body;

    Meal.exists(name, date, id)
      .then(data => {
        if (data.exists) {
          return response.error(409, "Conflict");
        }

        return Meal.create(name, date, id).then(data => {
          response.send();
        });
      })
      .catch(error => {
        console.log(error);
        response.error(500, "Internal Server Error");
      });
  }
);

module.exports = router;
