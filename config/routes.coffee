module.exports = (app, passport) ->

  users = require("../app/controllers/user/user-controller")
  index = require("../app/controllers/index")

  # User Routes
  app.get "/signout", users.signout

  # Users API
  app.post "/signup", users.createSignUp
  app.post "/users", users.create
  app.post "/users/session", (req, res, next) ->
    # TODO encapsulate this logic in users controller.
    auth = passport.authenticate "local", (err, user, info) ->
      req.returnUrl = "/#/login"
      return next(err) if err
      unless user
        req.friendlyError = info.message
        return next(new Error("Authentication Error"))

      req.logIn user, (err) ->
        return next(err) if err
        req.flash('success', 'welcome')
        res.redirect '/'
    auth(req, res, next)

  app.get "/users/me", users.me
  app.get "/users", users.all
  app.get "/users/:userId", users.show
  app.put "/users/:userId", passport.auth.requiresLogin, passport.auth.user.hasAuthorization, users.update
  app.del "/users/:userId", passport.auth.requiresLogin, passport.auth.user.hasAuthorization, users.destroy
  app.param "userId", users.user

  # Home route
  app.get "/", index.render
  app.get "/context.js", index.context
