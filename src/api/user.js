const router = require("express").Router();

const controller = require("../controllers/user");
const validator = require("../validators/user");

router.get("/user/me", validator.getMe, controller.getMe);
router.post("/user", validator.create, controller.create);
router.post("/user/token", validator.login, controller.login);
router.get("/user/clients", validator.getClients, controller.getClients);
router.post("/user/client/code", validator.generateCode, controller.generateCode);

module.exports = router;
