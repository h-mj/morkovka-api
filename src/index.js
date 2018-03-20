const express = require("express");

const app = express();

app.get("/", (request, response) => {
  response.send("Hello there");
});

app.listen(3001);
