const { any, none, one, oneOrNone } = require("../database");

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

  add: (user_id, name, unit) => {
    return one("SELECT * FROM add_quantity_f(${user_id}, ${name}, ${unit});", {
      user_id,
      name,
      unit
    });
  },

  addMeasurement: (id, value) => {
    return one("SELECT * FROM add_measurement_f(${id}, ${value});", {
      id,
      value
    });
  },

  exists: (user_id, name) => {
    return oneOrNone(
      "SELECT 1 FROM quantities_t WHERE user_id = ${user_id} AND name = ${name} LIMIT 1;",
      { user_id, name }
    );
  },

  delete: id => {
    return none("DELETE FROM quantities_t WHERE id = ${id};", { id });
  }
};
