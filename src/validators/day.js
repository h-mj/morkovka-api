const { check } = require("express-validator/check");
const { auth, hasAccess, validate } = require("./validators");

const get = [
  auth,
  check("user_id").isInt(),
  check("date").isBefore(),
  validate,
  hasAccess
];

module.exports = {
  get
};
