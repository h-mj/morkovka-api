const Meal = require("../models/Meal");
const Food = require("../models/Food");

function create(request, response) {
  const { user_id, type, date } = request.body;

  Meal.exists(type, user_id, date)
    .then(data => {
      if (data) {
        return response.error(409, "Conflict");
      }

      return Meal.add(type, user_id, date).then(data =>
        response.json({ data })
      );
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function add(request, response) {
  const { user_id, foodstuff_id, meal_id, quantity } = request.body;

  Meal.isOwner(meal_id, user_id)
    .then(data => {
      if (!data) {
        return response.error(400, "Bad Request");
      }

      return Meal.addFood(meal_id, foodstuff_id, quantity).then(data =>
        response.json({ data })
      );
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function remove(request, response) {
  const { user_id, food_id } = request.body;

  Food.isOwner(food_id, user_id)
    .then(data => {
      if (!data) {
        return response.error(400, "Bad Request");
      }

      return Food.delete(food_id).then(data => response.json({ data: true }));
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

module.exports = {
  create,
  add,
  remove
};
