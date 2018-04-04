const jwt = require("jsonwebtoken");
const { hash, compare } = require("bcryptjs");
const { secret } = require("../config");

const User = require("../models/User");

function createToken(data) {
  return jwt.sign({ id: data.id, type: data.type }, secret, {
    expiresIn: "7 days"
  });
}

function getMe(request, response) {
  const { id } = request.user;

  User.getBy("id", id)
    .then(data => {
      response.json({ data: { token: createToken(data), ...data } });
    })
    .catch(error => {
      console.error(error);
      response.error(500, "Internal Server Error");
    });
}

function create(request, response) {
  const { name, sex, date_of_birth, email, password } = request.body;

  User.existsByEmail(email)
    .then(data => {
      if (data) {
        return response.error(409, "Conflict");
      }

      return hash(password, 8)
        .then(hash => User.add(name, sex, date_of_birth, email, hash))
        .then(data =>
          response.json({ data: { token: createToken(data), ...data } })
        );
    })
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

function login(request, response) {
  const { email, password } = request.body;

  User.getHashByEmail(email)
    .then(data => {
      if (!data) {
        return response.error(400, "Bad Request");
      }

      return compare(password, data.hash).then(result => {
        if (!result) {
          return response.error(400, "Bad Request");
        }

        return User.getByEmail(email).then(data =>
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

module.exports = {
  getMe,
  create,
  login,
  getClients
};