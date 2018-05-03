const { any, one, oneOrNone } = require("../database");

module.exports = {
  get: user_id => {
    return one("SELECT * FROM get_user_f(${user_id});", {
      user_id
    });
  },

  getIdAndHashByEmail: email => {
    return oneOrNone(
      "SELECT id, hash FROM users_t WHERE email = ${email} LIMIT 1;",
      {
        email
      }
    );
  },

  add: (name, sex, date_of_birth, language, email, hash, trainer_id) => {
    return one("SELECT * FROM add_user_f(${arguments:csv});", {
      arguments: [name, sex, date_of_birth, language, email, hash, trainer_id]
    });
  },

  existsByEmail: email => {
    return oneOrNone("SELECT 1 FROM users_t WHERE email = ${email} LIMIT 1;", {
      email
    });
  },

  isTrainer: (trainer_id, user_id) => {
    if (trainer_id && user_id) {
      return oneOrNone(
        "SELECT 1 FROM users_t WHERE users_t.id = ${user_id} AND users_t.trainer_id = ${trainer_id} LIMIT 1;",
        { trainer_id, user_id }
      );
    }

    return oneOrNone(
      "SELECT 1 FROM users_t WHERE users_t.id = ${trainer_id} AND users_t.type = 1 LIMIT 1;",
      { trainer_id }
    );
  },

  getClients: user_id => {
    return any("SELECT * FROM get_clients_f(${user_id});", {
      user_id
    });
  },

  generateCode: user_id => {
    return one("SELECT * FROM generate_registration_code_f(${user_id})", {
      user_id
    });
  }
};
