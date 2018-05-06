const { check } = require("express-validator/check");
const { auth, validate, hasAccess } = require("./validators");

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
  create
};
