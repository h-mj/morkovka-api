const { check, validationResult } = require("express-validator/check");
const { auth, validate } = require("../utils/validations");

const get = [auth, check("date").isBefore(), validate];

const create = [
  auth,
  check("type").isInt({ min: 0, max: 3 }),
  check("date").exists(),
  validate
];

const add = [
  auth,
  check("foodstuff_id").isNumeric(),
  check("meal_id").isNumeric(),
  check("quantity").isFloat({ gt: 0 }),
  validate
];

const remove = [auth, check("food_id").isNumeric(), validate];

module.exports = {
  get,
  create,
  add,
  remove
};
