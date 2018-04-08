const router = require("express").Router();

const controller = require("../controllers/quantity");
const validator = require("../validators/quantity");

router.get("/user/quantities", validator.get, controller.get);
router.post("/user/quantity", validator.create, controller.create);
router.delete("/user/quantity", validator.remove, controller.remove);

router.get(
  "/user/measurements",
  validator.getDayMeasurements,
  controller.getDayMeasurements
);

router.get(
  "/user/quantity/measurements",
  validator.getMeasurements,
  controller.getMeasurements
);

router.post(
  "/user/quantity/measurement",
  validator.createMeasurement,
  controller.createMeasurement
);

module.exports = router;
