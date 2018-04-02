const { none, oneOrNone } = require("../database");

module.exports = {
  isOwner: (food_id, user_id) => {
    return oneOrNone(
      "SELECT 1 FROM foods_t, meals_t WHERE foods_t.id = ${food_id} AND foods_t.meal_id = meals_t.id AND meals_t.user_id = ${user_id} LIMIT 1;",
      { food_id, user_id }
    );
  },

  delete: food_id => {
    return none("DELETE FROM foods_t WHERE id = ${food_id};", { food_id });
  }
};
