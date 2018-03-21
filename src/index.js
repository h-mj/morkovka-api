const express = require("express");
const bodyParser = require("body-parser");
const jwt = require("express-jwt");
const { secret } = require("./config");

const usersRoute = require("./routes/user");

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

server.use("/user", usersRoute);

server.use((request, response, next) => {
  response.sendStatus(404);
});

server.listen(3001);
