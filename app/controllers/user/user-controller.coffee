###
Module dependencies.
###
mongoose = require("mongoose")
User = mongoose.model("User")
_ = require('underscore')

###
Auth callback
###
exports.authCallback = (req, res, next) ->
  res.redirect "/"

###
Logout
###
exports.signout = (req, res) ->
  req.logout()
  res.redirect "/"


###
Create user via signup page
###
exports.createSignUp = (req, res, next) ->
  user = new User(req.body)
  # Add the current school to this user.
  user.school = req.currentSchool?.name
  user.provider = "local"
  user.save (err) ->
    req.returnUrl = "/#/signup"
    if err
      req.friendlyError = "auth.existingUser" if err.message.indexOf('duplicate key') isnt -1
      return next(err)

    req.logIn user, (err) ->
      return next(err) if err
      req.flash('success', 'welcome')
      res.redirect '/'

###
Create user via API
###
exports.create = (req, res) ->
  user = new User(req.body)
  # Add the current school to this user.
  user.school = req.currentSchool?.name
  user.provider = "local"
  user.save (err) ->
    if err
      res.render "error",
        status: 500
    else
      res.jsonp user

###
Update a user
###
exports.update = (req, res) ->
  user = req.profile
  user = _.extend(user, req.body)
  user.save (err) ->
    if err
      res.render "error",
        status: 500
    else
      res.jsonp user

###
Delete an school
###
exports.destroy = (req, res) ->
  user = req.profile
  user.remove (err) ->
    if err
      res.render "error",
        status: 500
    else
      res.jsonp user

###
Show profile
###
exports.show = (req, res) ->
  res.jsonp _.pick(req.profile, '_id', 'username', 'email', 'name', 'school','provider', 'permissions')

###
Send User
###
exports.me = (req, res) ->
  res.jsonp req.user or null

###
Find user by id
###
exports.user = (req, res, next, id) ->
  User.findOne(_id: id).exec (err, user) ->
    return next(err)  if err
    return next(new Error("Failed to load User " + id))  unless user
    req.profile = user
    next()

###
List of Users
###
exports.all = (req, res) ->
  User.find(req.query).sort("-username").exec (err, users) ->
    if err
      res.render "error",
        status: 500
    else
      res.jsonp _.map users, (u) -> _.pick(u, '_id', 'username', 'email', 'name', 'school','provider', 'permissions')