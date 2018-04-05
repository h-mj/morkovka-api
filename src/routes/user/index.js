const router = require("express").Router();

const User = require("../../models/User");
const controller = require("../../controllers/user");
const validator = require("../../validators/user");

const mealRoute = require("./meal");
const quantityRoute = require("./quantity");
const ratioRoute = require("./ratio");
const statRoute = require("./stat");

router.use(mealRoute);
router.use(quantityRoute);
router.use(ratioRoute);
router.use(statRoute);

router.get("/user/me", validator.getMe, controller.getMe);
router.post("/user", validator.create, controller.create);
router.post("/user/token", validator.login, controller.login);
router.get("/user/clients", validator.getClients, controller.getClients);

module.exports = router;
