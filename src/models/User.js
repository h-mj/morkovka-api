const { any, one, oneOrNone } = require("../database");

module.exports = {
  getBy: (column, value) => {
    return one("SELECT * FROM users_v WHERE ${column:name} = ${value};", {
      column,
      value
    });
  },

  getById: user_id => {
    return one("SELECT * FROM users_v WHERE id = ${user_id} LIMIT 1;", {
      user_id
    });
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
  },

  isTrainer: user_id => {
    return oneOrNone(
      "SELECT 1 FROM users_t WHERE users_t.id = ${user_id} AND user_t.type = 1 LIMIT 1;",
      { user_id }
    );
  },

  getClients: user_id => {
    return any("SELECT * FROM users_v WHERE users_v.trainer_id = ${user_id};", {
      user_id
    });
  }
};
