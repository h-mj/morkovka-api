const router = require("express").Router();
const { check, validationResult } = require("express-validator/check");
const { auth, validate } = require("../utils/validations");

const Stats = require("../models/Stats");

router.get("/stats/consumed", auth, (request, response) => {
  const { id } = request.user;

  Stats.getConsumedData(id)
    .then(data => {
      response.json({ data });
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
});

module.exports = router;
