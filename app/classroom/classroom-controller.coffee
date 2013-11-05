###
Module dependencies.
###
mongoose = require("mongoose")
async = require("async")
Classroom = mongoose.model("Classroom")
_ = require("underscore")

###
Find classroom by id
###
exports.classroom = (req, res, next, id) ->
  Classroom.load id, (err, classroom) ->
    return next(err)  if err
    return next(new Error("Failed to load classroom " + id))  unless classroom
    req.classroom = classroom
    next()

###
Create a classroom
###
exports.create = (req, res) ->
  classroom = new Classroom(req.body)
  classroom.creator = req.user
  classroom.save (err) ->
    if err
      res.send "classrooms/create",
        errors: err.errors
        classroom: classroom

    else
      res.jsonp classroom

###
Update a classroom
###
exports.update = (req, res) ->
  classroom = req.classroom
  classroom = _.extend(classroom, req.body)
  classroom.save (err) ->
    res.jsonp classroom

###
Delete an classroom
###
exports.destroy = (req, res) ->
  classroom = req.classroom
  classroom.remove (err) ->
    if err
      res.render "error",
        status: 500

    else
      res.jsonp classroom

###
Show an classroom
###
exports.show = (req, res) ->
  res.jsonp req.classroom

###
List of Classrooms
###
exports.all = (req, res) ->
  Classroom.find(req.query)
    .sort("-created")
    .populate("creator")
    .populate("teachers")
    .exec (err, classrooms) ->
      if err
        res.render "error",
          status: 500
      else
        res.jsonp classrooms
