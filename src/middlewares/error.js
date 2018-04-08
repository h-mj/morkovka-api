module.exports = (request, response, next) => {
  response.error = (code, message, details) => {
    return response.status(code).json({ error: { code, message, details } });
  };

  next();
};
