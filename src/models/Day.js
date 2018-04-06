const { one } = require("../database");

module.exports = {
  get: (user_id, date) =>
    one("SELECT * FROM get_day_f(${user_id}, ${date});", { user_id, date })
};
