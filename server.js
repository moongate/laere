/*
Module dependencies.
*/


(function() {
  var app, auth, config, db, env, exports, express, fs, logger, models_path, mongoose, passport, port;

  express = require("express");

  fs = require("fs");

  passport = require("passport");

  logger = require("mean-logger");

  /*
  Main application entry file.
  Please note that the order of loading is important.
  */


  env = process.env.NODE_ENV = process.env.NODE_ENV || "development";

  config = require("./config/config");

  auth = require("./config/middlewares/authorization");

  mongoose = require("mongoose");

  db = mongoose.connect(config.db);

  models_path = __dirname + "/app/models";

  fs.readdirSync(models_path).forEach(function(file) {
    if (file.indexOf('.coffee') > 0) {
      return;
    }
    return require(models_path + "/" + file);
  });

  require("./config/passport")(passport);

  app = express();

  require("./config/express")(app, passport);

  require("./config/routes")(app, passport, auth);

  port = config.port;

  app.listen(port);

  console.log("Express app started on port " + port);

  logger.init(app, passport, mongoose);

  exports = module.exports = app;

}).call(this);
