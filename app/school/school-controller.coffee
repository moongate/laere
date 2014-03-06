###
Module dependencies.
###
mongoose = require("mongoose")
School = mongoose.model("School")
_ = require("underscore")

###
Find school by id
###
exports.school = (req, res, next, id) ->
  School.load id, (err, school) ->
    return next(err)  if err
    return next(new Error("Failed to load school " + id))  unless school
    req.school = school
    next()

###
Create a school
###
exports.create = (req, res) ->
  school = new School(req.body)
  school.creator = req.user
  school.save (err) ->
    if err
      res.send "schools/create",
        errors: err.errors
        school: school

    else
      res.jsonp school

###
Update a school
###
exports.update = (req, res) ->
  school = req.school
  school = _.extend(school, req.body)
  school.save (err) ->
    res.jsonp school

###
Delete an school
###
exports.destroy = (req, res) ->
  school = req.school
  school.remove (err) ->
    if err
      res.render "error",
        status: 500

    else
      res.jsonp school

###
Show an school
###
exports.show = (req, res) ->
  res.jsonp req.school

###
List of Schools
###
exports.all = (req, res) ->
  School.find(req.query).sort("-created").populate("creator").exec (err, schools) ->
    if err
      res.render "error",
        status: 500

    else
      res.jsonp schools

###
School verification interceptor
###
exports.verify = (req, res, next) ->
  school = /(.*).laere(dev)?.co/.exec(req.headers.host)?[1]
  return next() unless school?
  console.log 'searching for', school
  School.findOne {name: school}, (err, school) ->
    if err
      next(new Error("Error while trying to find school"))
    else if school
      console.log 'found', school
      req.currentSchool = school if school
      next()
    else
      next(new Error("School not found"))

