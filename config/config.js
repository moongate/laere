(function() {
  var _;

  _ = require("underscore");

  module.exports = _.extend(require(__dirname + "/../config/env/all.js"), require(__dirname + "/../config/env/" + process.env.NODE_ENV + ".json") || {});

}).call(this);
