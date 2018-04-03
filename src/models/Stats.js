const { any } = require("../database");

module.exports = {
  getConsumptionData: user_id => {
    return any("SELECT * FROM get_consumption_data_f(${user_id});", {
      user_id
    });
  }
};
