const router = require("express").Router();
const { check, validationResult } = require("express-validator/check");
const { auth, validate } = require("../utils/authValidate");

const Quantity = require("../models/Quantity");

router.get("/quantities", auth, (request, response) => {
  const { id } = request.user;

  Quantity.getAll(id)
    .then(data => {
      response.json({ data });
    })
    .catch(error => {
      console.error(error);
      response.error(500, "Internal Server Error");
    });
});

router.post(
  "/quantity",
  auth,
  [
    check("name")
      .trim()
      .isLength({ min: 1 }),

    check("unit")
      .trim()
      .isLength({ min: 1, max: 16 }),

    validate
  ],
  (request, response) => {
    const { id } = request.user;
    const { name, unit } = request.body;

    Quantity.exists(id, name)
      .then(data => {
        if (data) {
          return response.error(409, "Conflict");
        }

        return Quantity.add(id, name, unit).then(data =>
          response.json({ data })
        );
      })
      .catch(error => {
        console.log(error);
        response.error(500, "Internal Server Error");
      });
  }
);

router.delete(
  "/quantity",
  auth,
  [check("quantity_id").isInt({ min: 0 }), validate],
  (request, response) => {
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
);

router.get(
  "/quantity/measurements",
  auth,
  [check("quantity_id").isInt({ min: 0 }), validate],
  (request, response) => {
    const { id } = request.user;
    const { quantity_id } = request.query;

    Quantity.isOwner(quantity_id, id)
      .then(data => {
        if (!data) {
          return response.error(400, "Bad Request");
        }

        return Quantity.getMeasurements(quantity_id).then(data => {
          return response.json({ data });
        });
      })
      .catch(error => {
        console.log(error);
        response.error(500, "Internal Server Error");
      });
  }
);

router.post(
  "/quantity/measurement",
  auth,
  [check("quantity_id").isInt({ min: 0 }), check("value").isFloat(), validate],
  (request, response) => {
    const { id } = request.user;
    const { quantity_id, value } = request.body;

    Quantity.isOwner(quantity_id, id)
      .then(data => {
        if (!data) {
          return response.error(400, "Bad Request");
        }

        return Quantity.addMeasurement(quantity_id, value).then(data => {
          return response.json({ data });
        });
      })
      .catch(error => {
        console.log(error);
        response.error(500, "Internal Server Error");
      });
  }
);

module.exports = router;
