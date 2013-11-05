###
Module dependencies.
###
mongoose = require("mongoose")
async = require("async")
Course = mongoose.model("Course")
_ = require("underscore")

###
Find course by id
###
exports.course = (req, res, next, id) ->
  Course.load id, (err, course) ->
    return next(err)  if err
    return next(new Error("Failed to load course " + id))  unless course
    req.course = course
    next()

###
Create a course
###
exports.create = (req, res) ->
  course = new Course(req.body)
  course.creator = req.user
  course.save (err) ->
    if err
      res.send "courses/create",
        errors: err.errors
        course: course

    else
      res.jsonp course

###
Update a course
###
exports.update = (req, res) ->
  course = req.course
  course = _.extend(course, req.body)
  course.save (err) ->
    res.jsonp course

###
Delete an course
###
exports.destroy = (req, res) ->
  course = req.course
  course.remove (err) ->
    if err
      res.render "error",
        status: 500

    else
      res.jsonp course

###
Show an course
###
exports.show = (req, res) ->
  res.jsonp req.course

###
List of Courses
###
exports.all = (req, res) ->
  Course.find(req.query)
    .sort("-created")
    .populate("creator")
    .exec (err, courses) ->
      if err
        res.render "error",
          status: 500
      else
        res.jsonp courses
