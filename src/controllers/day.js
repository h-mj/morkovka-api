const Day = require("../models/Day");

function get(request, response) {
  const { user_id, date } = request.query;

  Day.get(user_id, date)
    .then(data => response.json({ data }))
    .catch(error => {
      console.log(error);
      response.error(500, "Internal Server Error");
    });
}

module.exports = {
  get
};
