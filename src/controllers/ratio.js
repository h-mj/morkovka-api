const Ratio = require("../models/Ratio");

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
  create
};
