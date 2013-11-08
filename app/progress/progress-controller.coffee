###
Module dependencies.
###
mongoose = require("mongoose")
async = require("async")
Progress = mongoose.model("Progress")
_ = require("underscore")

###
Find progress by id
###
exports.progress = (req, res, next, id) ->
  Progress.load id, (err, progress) ->
    return next(err)  if err
    return next(new Error("Failed to load progress " + id))  unless progress
    req.progress = progress
    next()

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
List of Progress
###
exports.all = (req, res) ->
  Progress.find(req.query)
    .sort("-created")
    .populate("classroom")
    .populate("student")
    .exec (err, progress) ->
      if err
        res.render "error",
          status: 500
      else
        res.jsonp progress