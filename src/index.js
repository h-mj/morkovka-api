const express = require("express");
const bodyParser = require("body-parser");

const usersRoute = require("./routes/user");

const server = express();

server.use(bodyParser.urlencoded({ extended: true }));
server.use(bodyParser.json());

server.use("/user", usersRoute);

server.use((request, response, next) => {
  response.sendStatus(404);
});

server.use((error, request, response, next) => {
  response.sendStatus(500);
});

server.listen(3001);
