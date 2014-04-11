express = require("express")
mongoStore = require("connect-mongo")(express)
flash = require("connect-flash")
dustjs = require("adaro")
_ = require("underscore")
mongoose = require("mongoose")
School = mongoose.model("School")
harp = require("harp")

module.exports = (app, passport, config) ->
  # express/mongo session storage
  session =
    secret: config.secret
    store: new mongoStore(
      url: config.db
      collection: "sessions"
    )

  compressOptions =
    filter: (req, res) ->
      (/json|text|javascript|css/).test res.getHeader("Content-Type")
    level: 9

  versionHeaderHandler = (req, res, next) ->
    res.setHeader('X-Laere-Version', config.version)
    next()

  cacheHandler = (req, res, next) ->
    if /\.js|\.css|\.woff/.test(req.url) and not req.url is '/context.js'
      res.header "Cache-Control", "public"
      res.header "Expires", new Date(Date.now() + 31536000000).toUTCString()
    next()

  booleanQueryParser = (req, res, next) ->
    req.query[key] = (value is 'true') for key, value of req.query when value in ['true', 'false']
    next()

  localsHandler = (req, res, next) ->
    res.locals.version = config.version
    res.locals.user = if req.user then JSON.stringify(_.pick(req.user, "provider", "name", "email", "_id")) else JSON.stringify(null)
    res.locals.development = (process.env.NODE_ENV isnt 'production')
    res.locals.production = (process.env.NODE_ENV is 'production')
    next()

  #School verification interceptor
  schoolHandler = (req, res, next) ->
    school = /(.*).laere(dev)?.co/.exec(req.headers.host)?[1]
    return next() if school is undefined or school is 'www'
    console.log 'searching for', school
    School.findOne {name: school}, (err, school) ->
      if err
        next(new Error("Error while trying to find school"))
      else if school
        console.log 'found', school
        req.currentSchool = school if school
        next()
      else
        next(new Error("School not found"))


  errorHandler = (err, req, res, next) ->
    #Log it
    console.error err.stack

    if req.returnUrl
      req.flash 'error', req.friendlyError ? JSON.stringify(err.message ? err.name)
      return res.redirect req.returnUrl

    #Error page
    res.status(500).render "error",
      error: err.stack
      httpStatus: "500"
      layout: false

  notFoundHandler = (req, res) ->
    res.status(404).render "error",
      url: req.originalUrl
      error: "Not found"
      httpStatus: "404"
      layout: false

  app.enable "jsonp callback" # Enable jsonp
  app.set "showStackError", true
  app.set "views", "app/views" # Set views path
  app.engine "dust", dustjs.dust(layout: "layout")
  app.set "view engine", "dust" # Set template engine
  app.use versionHeaderHandler # Send Laere version on every request
  app.use cacheHandler # Enable cache for 1 year
  app.use express.compress compressOptions # Should be before express.static
  app.use express.favicon() # Setting the fav icon
  app.use express.static(config.root + "/public")
  app.use harp.mount(config.root + "/node_modules/laere-ui/src") # Add angular front end application
  app.use express.logger("dev") if process.env.NODE_ENV isnt "test"
  app.use booleanQueryParser # Parse Booleans in req.query
  app.use schoolHandler
  app.use express.cookieParser() # cookieParser should be above session
  app.use express.bodyParser() # bodyParser should be above methodOverride
  app.use express.methodOverride()
  app.use express.session session
  app.use flash() # connect flash for flash messages
  app.use passport.initialize()
  app.use passport.session() # use passport session
  app.use localsHandler
  app.use app.router # routes should be the last
  app.use errorHandler # Treat errors thrown by any middleware
  app.use notFoundHandler # Assume 404 since no middleware responded
