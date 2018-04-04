const { check } = require("express-validator/check");
const { sanitize } = require("express-validator/filter");
const { auth, validate, hasAccess } = require("./validators");

const getMe = [auth];

const create = [
  check("name")
    .trim()
    .isLength({ min: 1 }),
  check("sex").isIn(["f", "m"]),
  check("date_of_birth").isBefore(),
  check("email")
    .trim()
    .isEmail()
    .normalizeEmail(),
  check("password").isLength({ min: 8 }),
  validate
];

const login = [
  check("email")
    .trim()
    .isLength({ min: 1 })
    .normalizeEmail(),
  check("password").isLength({ min: 1 }),
  validate
];

const getClients = [auth, check("user_id").isInt(), validate, hasAccess];

module.exports = {
  getMe,
  create,
  login,
  getClients
};
