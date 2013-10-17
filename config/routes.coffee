async = require("async")
module.exports = (app, passport) ->

  users = require("../app/user/user-controller")
  articles = require("../app/article/article-controller")
  accounts = require("../app/account/account-controller")
  index = require("../app/controllers/index")

  # User Routes
  app.get "/signin", users.signin
  app.get "/signup", users.signup
  app.get "/signout", users.signout

  # Users API
  app.post "/users", users.create
  app.post "/users/session", passport.authenticate("local",
    failureRedirect: "/signin"
    failureFlash: "Invalid email or password."
  ), users.session
  app.get "/users/me", users.me
  app.get "/users/:userId", users.show
  app.param "userId", users.user

  # Article Routes
  app.get "/articles", articles.all
  app.post "/articles", passport.auth.requiresLogin, articles.create
  app.get "/articles/:articleId", articles.show
  app.put "/articles/:articleId", passport.auth.requiresLogin, passport.auth.article.hasAuthorization, articles.update
  app.del "/articles/:articleId", passport.auth.requiresLogin, passport.auth.article.hasAuthorization, articles.destroy
  app.param "articleId", articles.article

  # Account Routes
  app.get "/accounts", accounts.all
  app.post "/accounts", passport.auth.requiresLogin, accounts.create
  app.get "/accounts/:accountId", accounts.show
  app.put "/accounts/:accountId", passport.auth.requiresLogin, passport.auth.account.hasAuthorization, accounts.update
  app.del "/accounts/:accountId", passport.auth.requiresLogin, passport.auth.account.hasAuthorization, accounts.destroy
  app.param "accountId", accounts.account

  # Home route
  app.get "/", index.render
