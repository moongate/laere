###
Module dependencies.
###
mongoose = require("mongoose")
User = mongoose.model("User")
_ = require('underscore')

module.exports = (app) ->
  app.post "/signup", (req, res, next) ->
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
