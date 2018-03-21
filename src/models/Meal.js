const { none, one, any } = require("../database");

const create = (name, date, user_id) => {
  return one("select create_meal($1, $2, $3);", [name, date, user_id]);
};

const exists = (name, date, user_id) => {
  return one(
    "select exists(select * from meals where name = $1 and date = $2 and user_id = $3) as exists;",
    [name, date, user_id]
  );
};

const getAll = (user_id, date) => {
  return any(
    "select * from meals where meals.user_id = $1 and meals.date = $2;",
    [user_id, date]
  );
};

module.exports = {
  create,
  exists,
  getAll
};
