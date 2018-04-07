const router = require("express").Router();

const controller = require("../../../controllers/ratio");
const validator = require("../../../validators/ratio");

router.get("/user/ratios", validator.get, controller.get);
router.get("/user/ratios/all", validator.getAll, controller.getAll);
router.post("/user/ratios", validator.create, controller.create);

module.exports = router;
