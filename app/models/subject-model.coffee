###
Module dependencies.
###
mongoose = require 'mongoose'
Schema = mongoose.Schema

SubjectSchema = new Schema(
  created:
    type: Date
    'default': Date.now

  name:
    type: String
    trim: true
    required: true

  parent:
    type: Schema.ObjectId
    ref: 'Subject'
)

SubjectSchema.statics = load: (id, cb) ->
  @findOne(_id: id).exec cb

mongoose.model 'Subject', SubjectSchema
