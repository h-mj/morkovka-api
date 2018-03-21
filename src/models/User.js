const jwt = require("jsonwebtoken");
const { secret } = require("../config");
const { none, one, any } = require("../database");

const create = (name, sex, date_of_birth, email, hash) => {
  return one("select create_user($1, $2, $3, $4, $5);", [
    name,
    sex,
    date_of_birth,
    email,
    hash
  ]);
};

const exists = email => {
  return one(
    "select exists(select * from v_user where email = $1) as exists;",
    email
  );
};

const get = id => {
  return one("select * from v_user where id = $1;", id);
};

const getBy = (by, value) => {
  return one("select * from v_user where $1:name = $2;", [by, value]);
};

const getHash = email => {
  return one("select hash from users where email = $1;", email);
};

const createJwt = email => {
  return getBy("email", email).then(data => {
    return jwt.sign({ id: data.id }, secret, { expiresIn: "2 days" });
  });
};

module.exports = {
  create,
  exists,
  get,
  getBy,
  getHash,
  createJwt
};
