const { any } = require("../database");

module.exports = {
  getConsumedData: user_id => {
    return any("SELECT * FROM get_consumed_data_f(${user_id});", {
      user_id
    });
  }
};
