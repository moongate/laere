###
Module dependencies.
###
mongoose = require("mongoose")
async = require("async")
_ = require("underscore")
exports.render = (req, res) ->
  res.render("./public/index.html")

exports.context = (req, res) ->
  res.header("Content-Type", "application/javascript").send("""
    window.laere = window.laere || {};
    window.laere.user = #{JSON.stringify(req.user)};
    window.laere.school = #{JSON.stringify(req.currentSchool)};
    window.laere.env = "#{JSON.stringify(process.env.NODE_ENV) or 'development'}";
    window.laere.host = "#{(if process.env.NODE_ENV is 'production' then 'laere.co' else 'laeredev.co:3000')}";
  """)