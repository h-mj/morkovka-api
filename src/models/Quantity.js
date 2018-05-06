const { any, none, one, oneOrNone } = require("../database");

module.exports = {
  getAll: user_id => {
    return any("SELECT * FROM get_quantities_f(${user_id});", {
      user_id
    });
  },

  isOwner: (quantity_id, user_id) => {
    return oneOrNone(
      "SELECT 1 FROM quantities_t WHERE id = ${quantity_id} AND user_id = ${user_id} LIMIT 1;",
      { quantity_id, user_id }
    );
  },

  isMeasurementOwner: (measurement_id, user_id) => {
    return oneOrNone(
      "SELECT 1 FROM measurements_t, quantities_t WHERE measurements_t.id = ${measurement_id} AND measurements_t.quantity_id = quantities_t.id AND quantities_t.user_id = ${user_id} LIMIT 1;",
      { measurement_id, user_id }
    );
  },

  add: (user_id, name, unit) => {
    return one("SELECT * FROM add_quantity_f(${user_id}, ${name}, ${unit});", {
      user_id,
      name,
      unit
    });
  },

  addMeasurement: (quantity_id, value) => {
    return one("SELECT * FROM add_measurement_f(${quantity_id}, ${value});", {
      quantity_id,
      value
    });
  },

  deleteMeasurement: measurement_id => {
    return none(
      "DELETE FROM measurements_t WHERE measurements_t.id = ${measurement_id};",
      { measurement_id }
    );
  },

  exists: (user_id, name) => {
    return oneOrNone(
      "SELECT 1 FROM quantities_t WHERE user_id = ${user_id} AND name = ${name} LIMIT 1;",
      { user_id, name }
    );
  },

  delete: quantity_id => {
    return none("DELETE FROM quantities_t WHERE id = ${quantity_id};", {
      quantity_id
    });
  }
};
