const jwt = require("express-jwt");
const { secret } = require("../config");

module.exports = jwt({ secret, credentialsRequired: false });
