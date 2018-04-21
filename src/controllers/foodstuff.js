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
  let {
    quantity,
    unit,
    name,
    calories,
    carbs,
    proteins,
    fats,
    sugars,
    salt,
    saturates
  } = request.body;

  sugars = sugars ? sugars : null;
  salt = salt ? salt : null;
  saturates = saturates ? saturates : null;

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
        fats,
        sugars,
        salt,
        saturates
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
