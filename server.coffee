###
Module dependencies.
###
express = require("express")
fs = require("fs")
passport = require("passport")
logger = require("mean-logger")

###
Main application entry file.
Please note that the order of loading is important.
###

#Load configurations
#if test env, load example file
env = process.env.NODE_ENV = process.env.NODE_ENV or "development"
config = require("./config/config")
auth = require("./config/middlewares/authorization")
mongoose = require("mongoose")

#Bootstrap db connection
db = mongoose.connect(config.db)

#Bootstrap models
models_path = __dirname + "/app/models"
fs.readdirSync(models_path).forEach (file) ->
  return if file.indexOf('.coffee') > 0
  require models_path + "/" + file


#bootstrap passport config
require("./config/passport") passport
app = express()

#express settings
require("./config/express") app, passport

#Bootstrap routes
require("./config/routes") app, passport, auth

#Start the app by listening on <port>
port = config.port
app.listen port
console.log "Express app started on port #{port} with environment #{env}"

#Initializing logger 
logger.init app, passport, mongoose

#expose app
exports = module.exports = app
