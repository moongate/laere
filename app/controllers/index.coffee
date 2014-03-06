###
Module dependencies.
###
mongoose = require("mongoose")
_ = require("underscore")

exports.render = (req, res) ->
  res.render("./public/index.html")

exports.context = (req, res) ->
  res.header("Content-Type", "application/javascript").send("""
    window.laere = window.laere || {};
    window.laere.user = #{JSON.stringify(req.user)};
    window.laere.school = #{JSON.stringify(req.currentSchool)};
    window.laere.env = "#{process.env.NODE_ENV or 'development'}";
    window.laere.host = "#{(if process.env.NODE_ENV is 'production' then 'laere.co' else 'laeredev.co:3000')}";
    window.laere.error = "#{req.flash("error")}";
    window.laere.warning = "#{req.flash("warning")}";
    window.laere.success = "#{req.flash("success")}";
  """)