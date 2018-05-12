const jwt = require("jsonwebtoken");
const { hash, compare } = require("bcryptjs");
const { secret } = require("../config");

const User = require("../models/User");

function createToken(data) {
  return jwt.sign({ id: data.id }, secret, {
    expiresIn: "7 days"
  });
}

function getMe(request, response) {
  const { id } = request.user;

  User.get(id)
    .then(data => {
      response.json({ data: { token: createToken(data), ...data } });
    })
    .catch(error => {
      console.error(error);
      response.error(500, "Internal Server Error");
    });
}

function create(request, response) {
  const {
    name,
    sex,
    date_of_birth,
    language,
    email,
    password,
    code
  } = request.body;

  User.existsByEmail(email)
    .then(data => {
      if (data) {
        return response.error(409, "Conflict");
      }

      return hash(password, 8)
        .then(hash =>
          User.add(name, sex, date_of_birth, language, email, hash, code)
        )
        .then(data => {
          if (!data) {
            return response.error(422, "Unprocessable Entity", {
              invalid: "code"
            });
          }

          return response.json({ data: { token: createToken(data), ...data } });
        });
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function update(request, response) {
  const { user_id, language, email, password, new_password } = request.body;

  User.getIdAndHashByEmail(email)
    .then(data => {
      if (data && data.id !== user_id) {
        return response.error(409, "Conflict");
      }

      return User.getHashById(user_id).then(data => {
        if (!data) {
          return response.error(400, "Bad Request");
        }

        const passwordHash = data.hash;

        return compare(password, passwordHash).then(result => {
          if (!result) {
            return response.error(400, "Bad Request");
          }

          return new Promise((resolve, reject) => {
            resolve(new_password ? hash(new_password, 8) : null);
          })
            .then(hash => User.update(user_id, language, email, hash))
            .then(data => response.json({ data: true }));
        });
      });
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function remove(request, response) {
  const { user_id } = request.body;

  User.remove(user_id)
    .then(data => response.json({ data: true }))
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function login(request, response) {
  const { email, password } = request.body;

  User.getIdAndHashByEmail(email)
    .then(data => {
      if (!data) {
        return response.error(400, "Bad Request");
      }

      const { id, hash } = data;

      return compare(password, hash).then(result => {
        if (!result) {
          return response.error(400, "Bad Request");
        }

        return User.get(id).then(data =>
          response.json({ data: { token: createToken(data), ...data } })
        );
      });
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function getClients(request, response) {
  const { user_id } = request.query;

  User.getClients(user_id)
    .then(data => response.json({ data }))
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function generateCode(request, response) {
  const { user_id } = request.body;

  User.isTrainer(user_id)
    .then(data => {
      if (!data) {
        return response.error(403, "Forbidden");
      }

      return User.generateCode(user_id).then(data =>
        response.json({ data: data.code })
      );
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

module.exports = {
  getMe,
  create,
  update,
  remove,
  login,
  getClients,
  generateCode
};
