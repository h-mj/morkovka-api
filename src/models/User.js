const { one, oneOrNone } = require("../database");

module.exports = {
  getBy: (column, value) => {
    return one("SELECT * FROM users_v WHERE ${column:name} = ${value};", {
      column,
      value
    });
  },

  getById: id => {
    return one("SELECT * FROM users_v WHERE id = ${id} LIMIT 1;", { id });
  },

  getByEmail: email => {
    return one("SELECT * FROM users_v WHERE email = ${email} LIMIT 1;", {
      email
    });
  },

  getHashByEmail: email => {
    return oneOrNone(
      "SELECT hash FROM users_t WHERE email = ${email} LIMIT 1;",
      {
        email
      }
    );
  },

  add: (name, sex, date_of_birth, email, hash) => {
    return one("SELECT * FROM add_user_f(${arguments:csv});", {
      arguments: [name, sex, date_of_birth, email, hash]
    });
  },

  existsByEmail: email => {
    return oneOrNone("SELECT 1 FROM users_t WHERE email = ${email} LIMIT 1;", {
      email
    });
  }
};
