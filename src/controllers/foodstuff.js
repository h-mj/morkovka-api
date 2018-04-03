const Foodstuff = require("../models/Foodstuff");

function find(request, response) {
  Foodstuff.find(request.query.query)
    .then(data => {
      response.json({ data });
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function create(request, response) {
  const {
    quantity,
    unit,
    name,
    calories,
    carbs,
    proteins,
    fats
  } = request.body;

  Foodstuff.exists(unit, name)
    .then(data => {
      if (data) {
        return response.error(409, "Conflict");
      }

      return Foodstuff.add(
        quantity,
        unit,
        name,
        calories,
        carbs,
        proteins,
        fats
      ).then(data => {
        response.json({ data });
      });
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

module.exports = {
  find,
  create
};
