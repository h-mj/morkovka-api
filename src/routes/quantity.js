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

module.exports = router;
