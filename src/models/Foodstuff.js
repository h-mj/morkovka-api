const { one, any } = require("../database");

module.exports = {
  find: query => {
    return any("SELECT * FROM find_foodstuffs_f(${query});", { query });
  },

  add: (quantity, unit, name, calories, carbs, proteins, fats) => {
    return one(
      "SELECT * FROM add_foodstuff_f(${quantity}, ${unit}, ${name}, ${calories}, ${carbs}, ${proteins}, ${fats});",
      { quantity, unit, name, calories, carbs, proteins, fats }
    );
  }
};
