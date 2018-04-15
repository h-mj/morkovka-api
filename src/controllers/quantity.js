const Quantity = require("../models/Quantity");

function get(request, response) {
  const { user_id } = request.query;

  Quantity.getAll(user_id)
    .then(data => response.json({ data }))
    .catch(error => {
      console.error(error);
      response.error(500, "Internal Server Error");
    });
}

function create(request, response) {
  const { user_id, name, unit } = request.body;

  Quantity.exists(user_id, name)
    .then(data => {
      if (data) {
        return response.error(409, "Conflict");
      }

      return Quantity.add(user_id, name, unit).then(data =>
        response.json({ data })
      );
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function remove(request, response) {
  const { user_id, quantity_id } = request.body;

  Quantity.isOwner(quantity_id, user_id)
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

function getDayMeasurements(request, response) {
  const { user_id, date } = request.query;

  Quantity.getDayMeasurements(user_id, date)
    .then(data => response.json({ data }))
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function getMeasurements(request, response) {
  const { user_id, quantity_id } = request.query;

  Quantity.isOwner(quantity_id, user_id)
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
  const { user_id, quantity_id, value } = request.body;

  Quantity.isOwner(quantity_id, user_id)
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

function deleteMeasurement(request, response) {
  const { user_id, measurement_id } = request.body;

  Quantity.isMeasurementOwner(measurement_id, user_id)
    .then(data => {
      if (!data) {
        return response.error(400, "Bad Request");
      }

      return Quantity.deleteMeasurement(measurement_id).then(data =>
        response.json({ data: true })
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
  getDayMeasurements,
  getMeasurements,
  createMeasurement,
  deleteMeasurement
};
