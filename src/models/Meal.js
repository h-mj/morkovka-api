const { one, any, oneOrNone } = require("../database");

module.exports = {
  add: (type, user_id, date) => {
    return one(
      "SELECT * FROM add_meal_f(${type}::smallint, ${user_id}, ${date});",
      {
        type,
        user_id,
        date
      }
    );
  },

  exists: (type, user_id, date) => {
    return oneOrNone(
      "SELECT 1 FROM meals_t WHERE type = ${type} AND user_id = ${user_id} AND date = ${date} LIMIT 1;",
      { type, user_id, date }
    );
  },

  addFood: (meal_id, foodstuff_id, quantity) => {
    return one(
      "SELECT * FROM add_food_f(${foodstuff_id}, ${meal_id}, ${quantity});",
      { meal_id, foodstuff_id, quantity }
    );
  },

  isOwner: (meal_id, user_id) => {
    return oneOrNone(
      "SELECT 1 FROM meals_t WHERE id = ${meal_id} AND user_id = ${user_id} LIMIT 1;",
      { meal_id, user_id }
    );
  }
};
