const { check, validationResult } = require("express-validator/check");
const { auth, validate } = require("../utils/validations");

const get = [auth];

const create = [
  auth,

  check("name")
    .trim()
    .isLength({ min: 1 }),

  check("unit")
    .trim()
    .isLength({ min: 1, max: 16 }),

  validate
];

const remove = [auth, check("quantity_id").isInt({ min: 0 }), validate];

const getMeasurements = [
  auth,
  check("quantity_id").isInt({ min: 0 }),
  validate
];

const createMeasurement = [
  auth,
  check("quantity_id").isInt({ min: 0 }),
  check("value").isFloat(),
  validate
];

module.exports = {
  get,
  create,
  remove,
  getMeasurements,
  createMeasurement
};
