const { validationResult } = require("express-validator/check");

const User = require("../models/User");

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

const hasAccess = (request, response, next) => {
  const { id } = request.user;

  let user_id;

  if (request.method === "GET") {
    user_id = request.query.user_id;
  } else {
    user_id = request.body.user_id;
  }

  if (id === parseInt(user_id)) {
    return next();
  }

  User.isTrainer(id, user_id).then(data => {
    if (data) {
      return next();
    }

    return response.error(403, "Forbidden");
  });
};

module.exports = {
  auth,
  validate,
  hasAccess
};
