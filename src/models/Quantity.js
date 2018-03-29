const { any, one, oneOrNone } = require("../database");

module.exports = {
  getAll: user_id => {
    return any("SELECT * FROM get_quantities_f(${user_id});", {
      user_id
    });
  },

  isOwner: (id, user_id) => {
    return oneOrNone(
      "SELECT 1 FROM quantities_t WHERE id = ${id} AND user_id = ${user_id} LIMIT 1;",
      { id, user_id }
    );
  },

  addMeasurement: (id, value) => {
    return one("SELECT * FROM add_measurement_f(${id}, ${value});", {
      id,
      value
    });
  }
};
