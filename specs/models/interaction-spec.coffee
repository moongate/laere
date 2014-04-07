###
Module dependencies.
###
should = require 'should'
app = require '../../app'
mongoose = require 'mongoose'
Interaction = mongoose.model 'Interaction'

describe "Interaction", ->

  it "should exist", (done) ->
    Interaction.should.exist
    done()