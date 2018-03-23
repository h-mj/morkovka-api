const { any } = require("../database");

module.exports = {
  find: query => {
    return any("SELECT * FROM find_foodstuffs_f(${query});", { query });
  }
};
