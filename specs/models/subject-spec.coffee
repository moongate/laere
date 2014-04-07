###
Module dependencies.
###
should = require 'should'
app = require '../../app'
mongoose = require 'mongoose'
Subject = mongoose.model 'Subject'

describe "Subject", ->

  it "should exist", (done) ->
    Subject.should.exist
    done()