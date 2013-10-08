###
Module dependencies.
###
express = require "express"
fs = require "fs"
passport = require "passport"
logger = require "mean-logger"
path = require "path"
mongoose = require "mongoose"
_ = require "underscore"

###
Main application entry file.
Please note that the order of loading is important.
###

#Load configurations
#if test env, load example file
defaultConfig =
  root: path.normalize "."
  port: if process.env.NODE_ENV is 'production' then 80 else 3000
  db: process.env.MONGOHQ_URL
  secret: process.env.SECRET or "CLEAN"
  env: process.env.NODE_ENV or "development"

config = _.extend(defaultConfig, require("./config/env/#{defaultConfig.env}.json") or {})
app = express()

#Bootstrap db connection
db = mongoose.connect(config.db)

#Bootstrap models
fs.readdirSync("./app/models").forEach (file) ->
  require "./app/models/" + file

#Bootstrap passport config and auth rules
require("./config/auth") app, passport, config

#express settings
require("./config/express") app, passport, config

#Bootstrap routes
require("./config/routes") app, passport

#Start the app by listening on <port>
app.listen config.port
console.log "Express app started on port #{config.port} with environment #{config.env}"

#Initializing logger
logger.init app, passport, mongoose

#expose app
exports = module.exports = app
