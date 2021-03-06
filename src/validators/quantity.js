const { check } = require("express-validator/check");
const { auth, validate, hasAccess } = require("./validators");

const get = [auth, check("user_id").isInt(), validate, hasAccess];

const create = [
  auth,
  check("user_id").isInt(),
  check("name")
    .trim()
    .isLength({ min: 1 }),
  check("unit")
    .trim()
    .isLength({ min: 1, max: 16 }),
  validate,
  hasAccess
];

const remove = [
  auth,
  check("user_id").isInt(),
  check("quantity_id").isInt(),
  validate,
  hasAccess
];

const createMeasurement = [
  auth,
  check("user_id").isInt(),
  check("quantity_id").isInt(),
  check("value")
    .customSanitizer(value => value.replace(",", "."))
    .isFloat(),
  validate,
  hasAccess
];

const deleteMeasurement = [
  auth,
  check("user_id").isInt(),
  check("measurement_id").isInt(),
  validate,
  hasAccess
];

module.exports = {
  get,
  create,
  remove,
  createMeasurement,
  deleteMeasurement
};
