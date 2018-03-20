const { query } = require("../utils/database");

exports.create = ({ name, sex, date_of_birth, email, password }, callback) => {
  query(
    "select create_user($1, $2, $3, $4, $5)",
    [name, sex, date_of_birth, email, password],
    callback
  );
};

exports.get = ({ id }, callback) => {
  query("select * from users where id = $1", [id], callback);
};
