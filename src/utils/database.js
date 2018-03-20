const { Pool } = require("pg");

const pool = new Pool({
  user: "postgres",
  host: "localhost",
  database: "db",
  password: "1234",
  port: 5432
});

module.exports = {
  query: (query, parameters, callback) => {
    return pool.query(query, parameters, (error, response) => {
      callback(error, response);
    });
  }
};
