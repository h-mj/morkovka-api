const server = require("express")();
const compression = require("compression")();

const api = require("./api");

server.use(compression);
server.use("/api", api);

server.listen(3001);
