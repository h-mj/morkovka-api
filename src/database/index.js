const config = require("../config");
const pgp = require("pg-promise")();

pgp.pg.types.setTypeParser(1082, "text", function(value) {
  return value;
});

const db = pgp(config.database);

module.exports = db;
