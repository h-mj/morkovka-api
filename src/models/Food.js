const { none, oneOrNone } = require("../database");

module.exports = {
  isOwner: (id, user_id) => {
    return oneOrNone(
      "SELECT 1 FROM foods_t, meals_t WHERE foods_t.id = ${id} AND foods_t.meal_id = meals_t.id AND meals_t.user_id = ${user_id} LIMIT 1;",
      { id, user_id }
    );
  },

  delete: id => {
    return none("DELETE FROM foods_t WHERE id = ${id};", { id });
  }
};
