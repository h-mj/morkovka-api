const Ratio = require("../models/Ratio");

function get(request, response) {
  const { user_id, date } = request.query;

  Ratio.get(user_id, date)
    .then(data => response.json({ data }))
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function getAll(request, response) {
  const { user_id } = request.query;

  Ratio.getAll(user_id)
    .then(data => response.json({ data }))
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function create(request, response) {
  const { user_id, delta, carbs, proteins, fats } = request.body;

  Ratio.create(user_id, delta, carbs, proteins, fats)
    .then(data => response.json({ data }))
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

module.exports = {
  get,
  getAll,
  create
};
