const router = require("express").Router();

const bodyParser = require("body-parser");
const error = require("../middlewares/error");
const jwt = require("../middlewares/jwt");
const unauthorized = require("../middlewares/unauthorized");

const userRoute = require("./user");
const mealRoute = require("./meal");
const quantityRoute = require("./quantity");
const ratioRoute = require("./ratio");
const statRoute = require("./stat");
const dayRoute = require("./day");
const foodstuffRoute = require("./foodstuff");

router.use(bodyParser.json());
router.use(error);
router.use(jwt);
router.use(unauthorized);

router.use(userRoute);
router.use(mealRoute);
router.use(quantityRoute);
router.use(ratioRoute);
router.use(statRoute);
router.use(dayRoute);
router.use(foodstuffRoute);

router.use((request, response, next) => {
  return response.error(404, "Not Found");
});

module.exports = router;
