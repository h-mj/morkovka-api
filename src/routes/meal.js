const router = require("express").Router();
const { check, validationResult } = require("express-validator/check");
const { auth, validate } = require("../utils/authValidate");

const Meal = require("../models/Meal");
const Food = require("../models/Food");

router.get(
  "/meals",
  auth,
  [check("date").isBefore(), validate],
  (request, response) => {
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
  auth,
  [
    check("name")
      .trim()
      .isLength({ min: 1 }),

    check("date").exists(),

    validate
  ],
  (request, response) => {
    const { id } = request.user;
    const { name, date } = request.body;

    Meal.exists(name, id, date)
      .then(data => {
        if (data) {
          return response.error(409, "Conflict");
        }

        return Meal.add(name, id, date).then(data => response.json({ data }));
      })
      .catch(error => {
        console.log(error);
        response.error(500, "Internal Server Error");
      });
  }
);

router.post(
  "/meal/food",
  auth,
  [
    check("foodstuff_id").isNumeric(),
    check("meal_id").isNumeric(),
    check("quantity").isFloat({ gt: 0 }),
    validate
  ],
  (request, response) => {
    const { id } = request.user;
    const { foodstuff_id, meal_id, quantity } = request.body;

    Meal.isOwner(meal_id, id)
      .then(data => {
        if (!data) {
          return response.error(400, "Bad Request");
        }

        return Meal.addFood(meal_id, foodstuff_id, quantity).then(data =>
          response.json({ data })
        );
      })
      .catch(error => {
        console.log(error);
        response.error(500, "Internal Server Error");
      });
  }
);

router.delete(
  "/meal/food",
  auth,
  [check("food_id").isNumeric(), validate],
  (request, response) => {
    const { id } = request.user;
    const { food_id } = request.body;

    Food.isOwner(food_id, id)
      .then(data => {
        if (!data) {
          return response.error(400, "Bad Request");
        }

        return Food.delete(food_id).then(data => {
          response.json({ data: true });
        });
      })
      .catch(error => {
        console.log(error);
        response.error(500, "Internal Server Error");
      });
  }
);

module.exports = router;
