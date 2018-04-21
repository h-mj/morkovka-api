const { one, any, oneOrNone } = require("../database");

module.exports = {
  find: query => {
    return any("SELECT * FROM find_foodstuffs_f(${query});", { query });
  },

  exists: (unit, name) => {
    return oneOrNone(
      "SELECT * FROM foodstuffs_t WHERE unit = ${unit} AND name = ${name} LIMIT 1;",
      { unit, name }
    );
  },

  add: (
    quantity,
    unit,
    name,
    calories,
    carbs,
    proteins,
    fats,
    sugars,
    salt,
    saturates
  ) => {
    return one(
      "SELECT * FROM add_foodstuff_f(${quantity}, ${unit}, ${name}, ${calories}, ${carbs}, ${proteins}, ${fats}, ${sugars}, ${salt}, ${saturates});",
      {
        quantity,
        unit,
        name,
        calories,
        carbs,
        proteins,
        fats,
        sugars,
        salt,
        saturates
      }
    );
  }
};
