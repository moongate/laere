###
Module dependencies.
###
mongoose = require("mongoose")
async = require("async")
_ = require("underscore")
exports.render = (req, res) ->
  res.render "index",
    user: (if req.user then JSON.stringify(req.user) else "null")
    school: (if req.currentSchool then JSON.stringify(req.currentSchool) else "null")
    env: (if process.env.NODE_ENV then JSON.stringify(process.env.NODE_ENV) else "'development'")
    host: (if process.env.NODE_ENV is 'production' then "'laere.co'" else "'laeredev.co:3000'")