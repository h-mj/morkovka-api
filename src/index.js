const express = require("express");
const compression = require("compression");

const api = require("./api");

const server = express();

server.use(compression());
server.use("/api", api);

server.use(express.static("build"));
server.get("*", (request, response) =>
  response.sendFile("index.html", { root: "build" })
);

server.listen(3001);
