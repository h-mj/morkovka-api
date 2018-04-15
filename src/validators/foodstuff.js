const { check } = require("express-validator/check");
const { auth, validate } = require("./validators");

const find = [
  auth,
  check("query")
    .trim()
    .isLength({ min: 1 }),
  validate
];

const create = [
  auth,
  check("quantity").isFloat({ gt: 0 }),
  check("unit").isIn(["g", "pc", "ml"]),
  check("name")
    .trim()
    .isLength({ min: 1 }),
  check("calories").isFloat({ min: 0 }),
  check("carbs").isFloat({ min: 0 }),
  check("proteins").isFloat({ min: 0 }),
  check("fats").isFloat({ min: 0 }),
  validate
];

module.exports = {
  find,
  create
};
