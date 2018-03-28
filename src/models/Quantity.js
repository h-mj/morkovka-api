const { any } = require("../database");

module.exports = {
  getAll: user_id => {
    return any("SELECT * FROM get_quantities_f(${user_id});", {
      user_id
    });
  }
};
