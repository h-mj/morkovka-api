const jwt = require("jsonwebtoken");
const { secret } = require("../config");
const { none, one, any } = require("../database");

exports.create = (name, sex, date_of_birth, email, hash) => {
  return one("select create_user($1, $2, $3, $4, $5);", [
    name,
    sex,
    date_of_birth,
    email,
    hash
  ]);
};

exports.get = id => {
  return one("select * from v_user where id = $1;", id);
};

exports.getBy = (by, value) => {
  return one("select * from v_user where $1:name = $2;", [by, value]);
};

exports.getHash = email => {
  return one("select hash from users where email = $1;", email);
};

exports.emailExists = email => {
  return one(
    "select exists(select * from v_user where email = $1) as exists;",
    email
  );
};

exports.createJwt = email => {
  return exports.getBy("email", email).then(data => {
    return jwt.sign({ id: data.id }, secret, { expiresIn: "2 days" });
  });
};
