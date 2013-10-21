async = require("async")
module.exports = (app, passport) ->

  users = require("../app/user/user-controller")
  schools = require("../app/school/school-controller")
  courses = require("../app/course/course-controller")
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

  # School Routes
  app.get "/schools", schools.all
  app.post "/schools", passport.auth.requiresLogin, schools.create
  app.get "/schools/:schoolId", schools.show
  app.put "/schools/:schoolId", passport.auth.requiresLogin, passport.auth.school.hasAuthorization, schools.update
  app.del "/schools/:schoolId", passport.auth.requiresLogin, passport.auth.school.hasAuthorization, schools.destroy
  app.param "schoolId", schools.school

  # Course Routes
  app.get "/courses", courses.all
  app.post "/courses", passport.auth.requiresLogin, courses.create
  app.get "/courses/:courseId", courses.show
  app.put "/courses/:courseId", passport.auth.requiresLogin, passport.auth.course.hasAuthorization, courses.update
  app.del "/courses/:courseId", passport.auth.requiresLogin, passport.auth.course.hasAuthorization, courses.destroy
  app.param "courseId", courses.course

  # Home route
  app.get "/", index.render
