const router = require("express").Router();
const { check, validationResult } = require("express-validator/check");
const { auth, validate } = require("../utils/authValidate");

const Foodstuff = require("../models/Foodstuff");

router.get(
  "/foodstuffs",
  auth,
  [check("query").isLength({ min: 1 }), validate],
  (request, response) => {
    Foodstuff.find(request.query.query)
      .then(data => {
        response.json({ data });
      })
      .catch(error => {
        console.log(error);
        response.error(500, "Internal Server Error");
      });
  }
);

router.post(
  "/foodstuffs",
  auth,
  [
    check("quantity").isFloat({ gt: 0 }),
    check("unit").isIn(["g", "tk", "ml"]),
    check("name")
      .trim()
      .isLength({ min: 1 }),
    check("calories").isFloat({ min: 0 }),
    check("carbs").isFloat({ min: 0 }),
    check("proteins").isFloat({ min: 0 }),
    check("fats").isFloat({ min: 0 }),
    validate
  ],
  (request, response) => {
    const {
      quantity,
      unit,
      name,
      calories,
      carbs,
      proteins,
      fats
    } = request.body;

    Foodstuff.add(quantity, unit, name, calories, carbs, proteins, fats)
      .then(data => {
        response.json({ data });
      })
      .catch(error => {
        console.log(error);
        response.error(500, "Internal Server Error");
      });
  }
);

module.exports = router;
