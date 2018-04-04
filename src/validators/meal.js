const { check } = require("express-validator/check");
const { auth, validate, hasAccess } = require("./validators");

const get = [
  auth,
  check("user_id").isInt(),
  check("date").isBefore(),
  validate,
  hasAccess
];

const create = [
  auth,
  check("user_id").isInt(),
  check("type").isInt({ min: 0, max: 3 }),
  check("date").isBefore(),
  validate,
  hasAccess
];

const add = [
  auth,
  check("user_id").isInt(),
  check("foodstuff_id").isInt(),
  check("meal_id").isInt(),
  check("quantity").isFloat({ gt: 0 }),
  validate,
  hasAccess
];

const remove = [
  auth,
  check("user_id").isInt(),
  check("food_id").isInt(),
  validate,
  hasAccess
];

module.exports = {
  get,
  create,
  add,
  remove
};
