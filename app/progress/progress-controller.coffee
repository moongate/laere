###
Module dependencies.
###
mongoose = require("mongoose")
async = require("async")
Progress = mongoose.model("Progress")
Course = mongoose.model("Course")
_ = require("underscore")

###
Find progress by id
###
exports.progress = (req, res, next, id) ->
  Progress.findById(id)
  .populate("classroom")
  .exec (err, progress) ->
      return next(err)  if err
      return next(new Error("Failed to load progress " + id)) unless progress
      Progress.populate(progress, {
        path: 'classroom.course'
        select: '_id code contents suggestedTrack details syllabus name created'
        model: Course
      }, (err, pop) ->
        req.progress = pop
        next())

###
Create a progress
###
exports.create = (req, res) ->
  progress = new Progress(req.body)
  progress.creator = req.user
  progress.save (err) ->
    if err
      res.send "progress/create",
        errors: err.errors
        progress: progress

    else
      res.jsonp progress

###
Update a progress
###
exports.update = (req, res) ->
  progress = req.progress
  progress = _.extend(progress, req.body)
  progress.save (err) ->
    res.jsonp progress

###
Delete an progress
###
exports.destroy = (req, res) ->
  progress = req.progress
  progress.remove (err) ->
    if err
      res.render "error",
        status: 500

    else
      res.jsonp progress

###
Show an progress
###
exports.show = (req, res) ->
  res.jsonp req.progress

###
Marks content as seen or not seen
###
exports.seen = (req, res) ->
  contentIndex = req.query.content
  seen = if req.query.seen then new Date() else null
  if contentIndex < 0
    return res.send 500
  solution = _.find req.progress.solutions, (s) -> s.content is contentIndex
  if solution
    solution.seen = seen
  else
    req.progress.solutions.push {content: contentIndex, seen: seen}
  req.progress.save (err, progress) ->
    if err
      res.send 500
    res.jsonp progress

###
List of Progress
###
exports.all = (req, res) ->
  if req.query.student
    Progress.find(req.query)
    .sort("-created")
    .populate("classroom")
    .exec (err, progress) ->
        if err
          res.render "error",
            status: 500
        else
          Progress.populate(progress, {
            path: 'classroom.course'
            select: 'code name contents'
            model: Course
          }, (err, pop) -> res.jsonp pop)
  else if req.query.classroom
    Progress.find(req.query)
    .sort("-created")
    .populate("student")
    .exec (err, progress) ->
        if err
          res.render "error",
            status: 500
        else
          res.jsonp progress
  else
    Progress.find(req.query)
      .sort("-created")
      .exec (err, progress) ->
        if err
          res.render "error",
            status: 500
        else
          res.jsonp progress
