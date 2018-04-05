const { check } = require("express-validator/check");
const { auth, validate, hasAccess } = require("./validators");

const get = [
  auth,
  check("user_id").isInt(),
  check("date").isBefore(),
  hasAccess,
  validate
];

const getAll = [auth, check("user_id").isInt(), hasAccess, validate];

const create = [
  auth,
  check("user_id").isInt(),
  check("delta").isInt(),
  check("carbs").isInt({ min: 0 }),
  check("proteins").isInt({ min: 0 }),
  check("fats").isInt({ min: 0 }),
  hasAccess,
  validate
];

module.exports = {
  get,
  getAll,
  create
};
