module.exports = (error, request, response, next) => {
  if (error.name === "UnauthorizedError") {
    return response.error(401, "Unauthorized");
  }

  next();
}
