const { none, one, any } = require("../database");

module.exports = {
  getAll: (user_id, date) => {
    return any("SELECT * FROM get_meal_f(${user_id}, ${date});", {
      user_id,
      date
    });
  },

  add: (name, user_id, date) => {
    return one("select add_meal_f(${name}, ${user_id}, ${date});", {
      name,
      user_id,
      date
    });
  },

  notExists: (name, user_id, date) => {
    return none(
      "SELECT 1 FROM meals_t WHERE name = ${name} AND user_id = ${user_id} AND date = ${date} LIMIT 1;",
      { name, user_id, date }
    );
  },

  addFood: (id, foodstuff_id, quantity) => {
    return one(
      "SELECT * FROM add_food_f(${foodstuff_id}, ${id}, ${quantity});",
      { foodstuff_id, id, quantity }
    );
  },

  isOwner: (id, user_id) => {
    return one(
      "SELECT 1 FROM meals_t WHERE id = ${id} AND user_id = ${user_id} LIMIT 1;",
      { id, user_id }
    );
  }
};
