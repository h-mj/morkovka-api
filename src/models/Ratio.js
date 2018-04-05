const { oneOrNone, any } = require("../database");

module.exports = {
  get: (user_id, date) => {
    return oneOrNone("SELECT * FROM get_ratios_f(${user_id}, ${date});", {
      user_id,
      date
    });
  },

  getAll: user_id => {
    return any(
      "SELECT * FROM ratios_t WHERE user_id = ${user_id} ORDER BY date DESC;",
      { user_id }
    );
  },

  create: (user_id, delta, carbs, proteins, fats) => {
    return one(
      "SELECT * FROM add_ratio_f(${user_id}, ${delta}::smallint, ${carbs}::smallint, ${proteins}::smallint, ${fats}::smallint);",
      { user_id, delta, carbs, proteins, fats }
    );
  }
};
