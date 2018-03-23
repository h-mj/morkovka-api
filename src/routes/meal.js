const router = require("express").Router();
const { check, validationResult } = require("express-validator/check");
const { QueryResultError } = require("pg-promise").errors;
const { auth, validate } = require("../utils/authValidate");

const Meal = require("../models/Meal");

router.get(
  "/meals",
  [check("date").isBefore(), validate],
  auth,
  (request, response, next) => {
    const { id } = request.user;
    const { date } = request.query;

    Meal.getAll(id, date)
      .then(data => response.json({ data }))
      .catch(error => {
        console.error(error);
        response.error(500, "Internal Server Error");
      });
  }
);

router.post(
  "/meal",
  [
    check("name")
      .trim()
      .isLength({ min: 1 }),

    check("date").exists(),

    validate
  ],
  auth,
  (request, response, next) => {
    const { id } = request.user;
    const { name, date } = request.body;

    Meal.notExists(name, date, id)
      .then(data => Meal.create(name, date, id))
      .then(data => response.send())
      .catch(error => {
        console.log(error);
        response.error(500, "Internal Server Error");
      });
  }
);

router.post(
  "/meal/food",
  [
    check("foodstuff_id").isNumeric(),
    check("meal_id").isNumeric(),
    check("quantity").isNumeric(),
    validate
  ],
  auth,
  (request, response, next) => {
    const { id } = request.user;
    const { foodstuff_id, meal_id, quantity } = request.body;

    Meal.isOwner(meal_id, id)
      .then(data => Meal.addFood(meal_id, foodstuff_id, quantity))
      .then(data => response.json({ data }))
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
