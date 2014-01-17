async = require("async")
module.exports = (app, passport) ->

  users = require("../app/user/user-controller")
  schools = require("../app/school/school-controller")
  courses = require("../app/course/course-controller")
  classrooms = require("../app/classroom/classroom-controller")
  progress = require("../app/progress/progress-controller")
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

  # Classroom Routes
  app.get "/classrooms", classrooms.all
  app.post "/classrooms", passport.auth.requiresLogin, classrooms.create
  app.get "/classrooms/:classroomId", classrooms.show
  app.put "/classrooms/:classroomId", passport.auth.requiresLogin, passport.auth.classroom.hasAuthorization, classrooms.update
  app.del "/classrooms/:classroomId", passport.auth.requiresLogin, passport.auth.classroom.hasAuthorization, classrooms.destroy
  app.param "classroomId", classrooms.classroom

  # Progress Routes
  app.get "/progress", progress.all
  app.post "/progress", passport.auth.requiresLogin, progress.create
  app.get "/progress/:progressId", progress.show
  app.put "/progress/:progressId", passport.auth.requiresLogin, passport.auth.progress.hasAuthorization, progress.update
  app.del "/progress/:progressId", passport.auth.requiresLogin, passport.auth.progress.hasAuthorization, progress.destroy
  app.put "/progress/:progressId/seen", progress.seen
  app.param "progressId", progress.progress

  # Home route
  app.get "/", index.render
  app.get "/context.js", index.context
