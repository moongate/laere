###
Module dependencies.
###
should = require 'should'
app = require '../../app'
mongoose = require 'mongoose'
Content = mongoose.model 'Content'

describe "Content", ->

  it "should exist", (done) ->
    Content.should.exist
    done()