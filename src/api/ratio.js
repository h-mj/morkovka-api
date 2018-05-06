const router = require("express").Router();

const controller = require("../controllers/ratio");
const validator = require("../validators/ratio");

router.post("/user/ratios", validator.create, controller.create);

module.exports = router;
