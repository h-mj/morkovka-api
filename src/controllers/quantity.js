const Quantity = require("../models/Quantity");

function get(request, response) {
  const { id } = request.user;

  Quantity.getAll(id)
    .then(data => response.json({ data }))
    .catch(error => {
      console.error(error);
      response.error(500, "Internal Server Error");
    });
}

function create(request, response) {
  const { id } = request.user;
  const { name, unit } = request.body;

  Quantity.exists(id, name)
    .then(data => {
      if (data) {
        return response.error(409, "Conflict");
      }

      return Quantity.add(id, name, unit).then(data => response.json({ data }));
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function remove(request, response) {
  const { id } = request.user;
  const { quantity_id } = request.body;

  Quantity.isOwner(quantity_id, id)
    .then(data => {
      if (!data) {
        return response.error(400, "Bad Request");
      }

      return Quantity.delete(quantity_id).then(() =>
        response.json({ data: true })
      );
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function getMeasurements(request, response) {
  const { id } = request.user;
  const { quantity_id } = request.query;

  Quantity.isOwner(quantity_id, id)
    .then(data => {
      if (!data) {
        return response.error(400, "Bad Request");
      }

      return Quantity.getMeasurements(quantity_id).then(data =>
        response.json({ data })
      );
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function createMeasurement(request, response) {
  const { id } = request.user;
  const { quantity_id, value } = request.body;

  Quantity.isOwner(quantity_id, id)
    .then(data => {
      if (!data) {
        return response.error(400, "Bad Request");
      }

      return Quantity.addMeasurement(quantity_id, value).then(data =>
        response.json({ data })
      );
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

module.exports = {
  get,
  create,
  remove,
  getMeasurements,
  createMeasurement
};
