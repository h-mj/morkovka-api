const { one, oneOrNone, any } = require("../database");

module.exports = {
  create: (user_id, delta, carbs, proteins, fats) => {
    return one(
      "SELECT * FROM add_ratio_f(${user_id}, ${delta}::smallint, ${carbs}::smallint, ${proteins}::smallint, ${fats}::smallint);",
      { user_id, delta, carbs, proteins, fats }
    );
  }
};
