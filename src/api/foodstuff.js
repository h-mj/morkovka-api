const router = require("express").Router();

const controller = require("../controllers/foodstuff");
const validator = require("../validators/foodstuff");

router.get("/foodstuffs", validator.find, controller.find);
router.post("/foodstuffs", validator.create, controller.create);
router.delete("/foodstuff", validator.remove, controller.remove);

module.exports = router;
