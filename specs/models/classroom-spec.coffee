###
Module dependencies.
###
should = require 'should'
app = require '../../app'
mongoose = require 'mongoose'
Classroom = mongoose.model 'Classroom'

describe "Classroom", ->

  it "should exist", (done) ->
    Classroom.should.exist
    done()