mongoose = require 'mongoose'
baucis = require 'baucis'

module.exports = (app, passport) ->

  baucis.rest 'Classroom'
  baucis.rest 'Content'
  baucis.rest 'Course'
  baucis.rest 'Interaction'
  baucis.rest 'School'
  baucis.rest 'Subject'
  baucis.rest 'User'

  app.use('/api/1', baucis())
