###
Module dependencies.
###
express = require 'express'
fs = require 'fs'
passport = require 'passport'
path = require 'path'
mongoose = require 'mongoose'
_ = require 'underscore'
glob = require 'glob'
pkg = require './package.json'
http = require 'q-io/http'

###
Main application entry file.
Please note that the order of loading is important.
###

# Default configurations, extended by options provided in config/env files
config =
  root: path.normalize '.'
  port: process.env.PORT or 5000
  db: process.env.MONGOLAB_URI or 'mongodb://localhost/laere-dev'
  secret: process.env.SECRET or 'CLEAN'
  env: process.env.NODE_ENV or 'development'
  version: pkg.version

app = express() # Create your express app
db = mongoose.connect(config.db) # Bootstrap db connection
mongoose.connection.on 'error', ->
  console.error('✗ MongoDB Connection Error. Please make sure MongoDB is running.')

# Bootstrap models
require(file) for file in glob.sync './app/**/*-model.coffee'
require('./config/auth') app, passport, config # Bootstrap passport config and auth rules
require('./config/express') app, passport, config # Express settings
require('./config/routes') app, passport # Bootstrap routes

# Start the app
app.listen config.port, ->
  console.log "App started on port #{config.port} with environment #{config.env}"
  # Reload app on restart
  http.request('http://localhost:35729/changed?files=any') if config.env is 'development'

exports = module.exports = app
