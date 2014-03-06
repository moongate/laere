mongoose = require("mongoose")
LocalStrategy = require("passport-local").Strategy
FacebookStrategy = require("passport-facebook").Strategy
User = mongoose.model("User")
users = require("../app/user/user-controller")
index = require("../app/controllers/index")

module.exports = (app, passport, config) ->
  passport.auth =
    #	Generic require login routing middleware
    requiresLogin: (req, res, next) ->
      unless req.isAuthenticated()
        return res.send(401, "User is not authorized")
      next()

    #	User authorizations routing middleware
    user:
      hasAuthorization: (req, res, next) ->
        unless (req.profile.id is req.user.id) or
        (req.user.permissions.manage)
          return res.send(401, "User is not authorized")
        next()

    #	Course authorizations routing middleware
    course:
      hasAuthorization: (req, res, next) ->
        unless req.course.creator.id is req.user.id or
        (req.user.permissions.course)
          return res.send(401, "User is not authorized")
        next()

    #	Classroom authorizations routing middleware
    classroom:
      hasAuthorization: (req, res, next) ->
        unless req.classroom.creator.id is req.user.id or
        (req.user.permissions.classroom)
          return res.send(401, "User is not authorized")
        next()

    #	Progress authorizations routing middleware
    progress:
      hasAuthorization: (req, res, next) ->
        unless req.progress.student.id is req.user.id or
        (req.user.permissions.manage)
          return res.send(401, "User is not authorized")
        next()

    #	School authorizations routing middleware
    school:
      hasAuthorization: (req, res, next) ->
        unless req.school.creator.id is req.user.id or
        (req.user.permissions.manage)
          return res.send(401, "User is not authorized")
        next()

  #Serialize sessions
  passport.serializeUser (user, done) ->
    done null, user.id

  passport.deserializeUser (id, done) ->
    User.findOne
      _id: id
    , (err, user) ->
      done err, user

  ###
  Passport Strategies initialization
  ###

  #Use local strategy
  localStrategy = (req, email, password, done) ->
    User.findOne {email: email}, (err, user) ->
      return done(err) if err
      return done(null, false, {message: "auth.noSuchUser"}) unless user
      return done(null, false, {message: "auth.noSuchUserOnSchool"}) unless user.school is req.currentSchool?.name
      return done(null, false, {message: "auth.invalidCredentials"}) unless user.authenticate(password)
      return done(null, user)

  passport.use new LocalStrategy(
    usernameField: "email"
    passwordField: "password"
    passReqToCallback: true
  ,
    localStrategy
  )

  #Use facebook strategy
  passport.use new FacebookStrategy(
    clientID: config.facebook.clientID
    clientSecret: config.facebook.clientSecret
    callbackURL: config.facebook.callbackURL
  , (accessToken, refreshToken, profile, done) ->
    User.findOne
      "facebook.id": profile.id
    , (err, user) ->
      return done(err)  if err
      unless user
        user = new User(
          name: profile.displayName
          email: profile.emails[0].value
          username: profile.username
          provider: "facebook"
          facebook: profile._json
        )
        user.save (err) ->
          console.log err  if err
          done err, user

      else
        done err, user
  )

  ###
  Authentication Routes
  ###

  passport.setupRoutes = ->
    #Setting the facebook oauth routes
    app.get "/auth/facebook", passport.authenticate("facebook",
      scope: ["email", "user_about_me"]
      failureRedirect: "/#/login"
    ), index.render
    app.get "/auth/facebook/callback", passport.authenticate("facebook",
      failureRedirect: "/#/login"
    ), users.authCallback
