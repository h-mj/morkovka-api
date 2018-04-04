const { check } = require("express-validator/check");
const { auth, validate, hasAccess } = require("./validators");

getConsumptionData = [auth, check("user_id").isInt(), validate, hasAccess];

module.exports = {
  getConsumptionData
};
