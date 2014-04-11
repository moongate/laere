mongoose = require("mongoose")
LocalStrategy = require("passport-local").Strategy
User = mongoose.model("User")

module.exports = (app, passport) ->

  app.get "/signout", (req, res) ->
    req.logout()
    res.redirect "/"

  app.post "/login", (req, res, next) ->
    authCallback = (err, user) ->
      req.returnUrl = "/#/login"
      return next(err) if err
      req.logIn user, (err) ->
        return next(err) if err
        req.flash('success', 'welcome')
        res.redirect '/'

    passport.authenticate("local", authCallback)(req, res, next)

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

  passport.use new LocalStrategy
    usernameField: "email"
    passwordField: "password"
    passReqToCallback: true
    (req, email, password, done) ->
      User.findOne {email: email}, (err, user) ->
        return done(err) if err
        if not user
          req.friendlyError = "auth.noSuchUser"
          done(new Error("Authentication Error"))
        else if not (user.school is req.currentSchool?.name)
          req.friendlyError = "auth.noSuchUserOnSchool"
          done(new Error("Authentication Error"))
        else if not user.authenticate(password)
          req.friendlyError = "auth.invalidCredentials"
          done(new Error("Authentication Error"))
        else
          done(null, user)
