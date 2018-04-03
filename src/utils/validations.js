const { validationResult } = require("express-validator/check");

const auth = (request, response, next) => {
  if (!request.user) {
    return response.error(401, "Unauthorized");
  }

  next();
};

const validate = (request, response, next) => {
  const errors = validationResult(request);

  if (!errors.isEmpty()) {
    return response.error(422, "Unprocessable Entity", {
      invalid: Object.keys(errors.mapped())
    });
  }

  next();
};

const trainer = (request, response, next) => {
  if (request.user.type === 0) {
    return response.error(403, "Forbidden");
  }

  next();
};

module.exports = {
  auth,
  validate,
  trainer
};
