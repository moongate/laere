(function() {
  var path, rootPath;

  path = require("path");

  rootPath = path.normalize(__dirname + "/../..");

  module.exports = {
    root: rootPath,
    port: process.env.PORT || 80,
    db: process.env.MONGOHQ_URL
  };

}).call(this);
