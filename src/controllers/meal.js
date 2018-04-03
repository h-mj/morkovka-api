const Meal = require("../models/Meal");
const Food = require("../models/Food");

function get(request, response) {
  const { id } = request.user;
  const { date } = request.query;

  Meal.getAll(id, date)
    .then(data => response.json({ data }))
    .catch(error => {
      console.error(error);
      response.error(500, "Internal Server Error");
    });
}

function create(request, response) {
  const { id } = request.user;
  const { type, date } = request.body;

  Meal.exists(type, id, date)
    .then(data => {
      if (data) {
        return response.error(409, "Conflict");
      }

      return Meal.add(type, id, date).then(data => response.json({ data }));
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function add(request, response) {
  const { id } = request.user;
  const { foodstuff_id, meal_id, quantity } = request.body;

  Meal.isOwner(meal_id, id)
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
  const { id } = request.user;
  const { food_id } = request.body;

  Food.isOwner(food_id, id)
    .then(data => {
      if (!data) {
        return response.error(400, "Bad Request");
      }

      return Food.delete(food_id).then(data => {
        response.json({ data: true });
      });
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

module.exports = {
  get,
  create,
  add,
  remove
};
