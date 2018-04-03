const { check, validationResult } = require("express-validator/check");
const { auth, validate } = require("../utils/validations");

getConsumptionData = [auth];

module.exports = {
  getConsumptionData
};
