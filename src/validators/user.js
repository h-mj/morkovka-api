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
  check("language").isIn(["ru", "ee"]),
  check("email")
    .trim()
    .isEmail()
    .normalizeEmail(),
  check("password").isLength({ min: 1 }),
  check("code").isLength({ min: 16, max: 16 }),
  validate
];

const update = [
  auth,
  check("user_id").isInt(),
  check("language")
    .optional({ checkFalsy: true })
    .isIn(["ru", "ee"]),
  check("email")
    .optional({ checkFalsy: true })
    .trim()
    .isEmail()
    .normalizeEmail(),
  check("new_password")
    .optional({ checkFalsy: true })
    .isLength({ gt: 0 }),
  check("password").isLength({ gt: 0 }),
  validate,
  hasAccess
];

const remove = [
  auth,
  check("user_id").isInt(),
  check("password").isLength({ gt: 0 }),
  validate,
  hasAccess
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

const generateCode = [auth, check("user_id").isInt(), validate, hasAccess];

module.exports = {
  getMe,
  create,
  update,
  remove,
  login,
  getClients,
  generateCode
};
