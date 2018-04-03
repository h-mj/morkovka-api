const router = require("express").Router();

const controller = require("../../../controllers/stat");
const validator = require("../../../validators/stat");

router.get(
  "/user/stats/consumption",
  validator.getConsumptionData,
  controller.getConsumptionData
);

module.exports = router;
