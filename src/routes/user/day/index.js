const router = require("express").Router();

const controller = require("../../../controllers/day");
const validator = require("../../../validators/day");

router.get("/user/day", validator.get, controller.get);

module.exports = router;
