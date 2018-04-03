const Stats = require("../models/Stats");

function getConsumptionData(request, response) {
  const { id } = request.user;

  Stats.getConsumptionData(id)
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
