const express = require("express");
const bodyParser = require("body-parser");
const jwt = require("express-jwt");
const { secret } = require("./config");

const userRoute = require("./routes/user");
const mealRoute = require("./routes/meal");

const server = express();

server.use(bodyParser.urlencoded({ extended: true }));
server.use(bodyParser.json());
server.use(jwt({ secret, credentialsRequired: false }));

server.use((request, response, next) => {
  response.error = (code, message, description) => {
    return response
      .status(code)
      .json({ error: { code, message, description } });
  };

  next();
});

server.use(userRoute);
server.use(mealRoute);

server.use((request, response, next) => {
  response.error(404, "Not Found");
});

server.listen(3001);
