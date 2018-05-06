const router = require("express").Router();

const controller = require("../controllers/quantity");
const validator = require("../validators/quantity");

router.get("/user/quantities", validator.get, controller.get);
router.post("/user/quantity", validator.create, controller.create);
router.delete("/user/quantity", validator.remove, controller.remove);

router.post(
  "/user/quantity/measurement",
  validator.createMeasurement,
  controller.createMeasurement
);

router.delete(
  "/user/quantity/measurement",
  validator.deleteMeasurement,
  controller.deleteMeasurement
);

module.exports = router;
