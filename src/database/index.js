const pgPromise = require("pg-promise");
const config = require("../config");

module.exports = pgPromise()(config.database);
