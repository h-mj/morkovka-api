const router = require("express").Router();
const { check, validationResult } = require("express-validator/check");
const { auth, validate } = require("../utils/authValidate");

const Foodstuff = require("../models/Foodstuff");

router.get(
  "/foodstuffs",
  auth,
  [check("query").isLength({ min: 1 }), validate],
  (request, response) => {
    Foodstuff.find(request.query.query)
      .then(data => {
        response.json({ data });
      })
      .catch(error => {
        console.log(error);
        response.error(500, "Internal Server Error");
      });
  }
);

module.exports = router;
