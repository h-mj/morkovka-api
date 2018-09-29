const { check } = require("express-validator/check");
const { auth, validate } = require("./validators");

const find = [
  auth,
  check("query")
    .trim()
    .isLength({ min: 1 }),
  validate
];

const create = [
  auth,
  check("quantity")
    .customSanitizer(value => value.replace(",", "."))
    .isFloat({ gt: 0 }),
  check("unit").isIn(["g", "pc", "ml"]),
  check("name")
    .trim()
    .isLength({ min: 1 }),
  check("calories")
    .customSanitizer(value => value.replace(",", "."))
    .isFloat({ min: 0 }),
  check("carbs")
    .customSanitizer(value => value.replace(",", "."))
    .isFloat({ min: 0 }),
  check("proteins")
    .customSanitizer(value => value.replace(",", "."))
    .isFloat({ min: 0 }),
  check("fats")
    .customSanitizer(value => value.replace(",", "."))
    .isFloat({ min: 0 }),
  check("sugars")
    .optional({ checkFalsy: true })
    .customSanitizer(value => value.replace(",", "."))
    .isFloat({ min: 0 }),
  check("salt")
    .optional({ checkFalsy: true })
    .customSanitizer(value => value.replace(",", "."))
    .isFloat({ min: 0 }),
  check("saturates")
    .optional({ checkFalsy: true })
    .customSanitizer(value => value.replace(",", "."))
    .isFloat({ min: 0 }),
  validate
];

const remove = [
  auth,
  check("foodstuff_id").isInt(),
  validate
];

module.exports = {
  find,
  create,
  remove
};
