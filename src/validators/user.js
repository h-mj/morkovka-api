const { check } = require("express-validator/check");
const { sanitize } = require("express-validator/filter");
const { auth, validate, trainer } = require("../utils/validations");

const get = [auth];

const create = [
  check("name")
    .trim()
    .isLength({ min: 1 }),

  check("sex").isIn(["f", "m"]),

  check("date_of_birth").isBefore(),

  check("email")
    .trim()
    .isEmail(),

  check("password").isLength({ min: 8 }),

  sanitize("email").normalizeEmail(),

  validate
];

const login = [
  check("email")
    .trim()
    .isLength({ min: 1 }),

  check("password").isLength({ min: 1 }),

  sanitize("email").normalizeEmail(),

  validate
];

const getClients = [auth, trainer];

module.exports = {
  get,
  create,
  login,
  getClients
};
