const router = require("express").Router();

const controller = require("../controllers/meal");
const validator = require("../validators/meal");

router.get("/user/meals", validator.get, controller.get);
router.post("/user/meal", validator.create, controller.create);
router.post("/user/meal/food", validator.add, controller.add);
router.delete("/user/meal/food", validator.remove, controller.remove);

module.exports = router;
