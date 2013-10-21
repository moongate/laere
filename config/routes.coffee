async = require("async")
module.exports = (app, passport) ->

  users = require("../app/user/user-controller")
  articles = require("../app/article/article-controller")
  schools = require("../app/school/school-controller")
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
  app.get "/users", users.all
  app.get "/users/:userId", users.show
  app.put "/users/:userId", passport.auth.requiresLogin, passport.auth.user.hasAuthorization, users.update
  app.del "/users/:userId", passport.auth.requiresLogin, passport.auth.user.hasAuthorization, users.destroy
  app.param "userId", users.user

  # Article Routes
  app.get "/articles", articles.all
  app.post "/articles", passport.auth.requiresLogin, articles.create
  app.get "/articles/:articleId", articles.show
  app.put "/articles/:articleId", passport.auth.requiresLogin, passport.auth.article.hasAuthorization, articles.update
  app.del "/articles/:articleId", passport.auth.requiresLogin, passport.auth.article.hasAuthorization, articles.destroy
  app.param "articleId", articles.article

  # School Routes
  app.get "/schools", schools.all
  app.post "/schools", passport.auth.requiresLogin, schools.create
  app.get "/schools/:schoolId", schools.show
  app.put "/schools/:schoolId", passport.auth.requiresLogin, passport.auth.school.hasAuthorization, schools.update
  app.del "/schools/:schoolId", passport.auth.requiresLogin, passport.auth.school.hasAuthorization, schools.destroy
  app.param "schoolId", schools.school

  # Home route
  app.get "/", index.render
