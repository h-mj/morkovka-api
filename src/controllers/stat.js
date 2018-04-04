const Stats = require("../models/Stats");

function getConsumptionData(request, response) {
  const { user_id } = request.query;

  Stats.getConsumptionData(user_id)
    .then(data => {
      response.json({ data });
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

module.exports = {
  getConsumptionData
};
