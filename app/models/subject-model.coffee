###
Module dependencies.
###
mongoose = require("mongoose")
Schema = mongoose.Schema

###
Subject Schema
###
SubjectSchema = new Schema(
  created:
    type: Date
    'default': Date.now

  name:
    type: String
    'default': ""
    trim: true

  label:
    type: String
    'default': ""
    trim: true

  creator:
    type: Schema.ObjectId
    ref: "User"
)

###
Validations
###
SubjectSchema.path("name").validate ((name) ->
  name.length
), "Name cannot be blank"

SubjectSchema.path("label").validate ((label) ->
  label.length
), "Label cannot be blank"

###
Statics
###
SubjectSchema.statics = load: (id, cb) ->
  @findOne(_id: id).populate("creator").exec cb

mongoose.model "Subject", SubjectSchema
