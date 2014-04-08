###
Module dependencies.
###
mongoose = require("mongoose")
Schema = mongoose.Schema
_ = require 'underscore'
ContentLevel = require '../enums/content-level.coffee'
ContentType = require '../enums/content-type.coffee'

ContentSchema = new Schema(
  created:
    type: Date
    'default': Date.now

  name:
    type: String
    'default': ""
    trim: true
    required: true

  description:
    type: String
    'default': ""
    trim: true

  creator:
    type: Schema.ObjectId
    ref: "User"
    required: true

  url:
    type: String

  level:
    type: String
    enum: _.values ContentLevel

  type:
    type: String
    enum: _.values ContentType

  upvotes:
    type: Number
    min: 0

  downvotes:
    type: Number
    min: 0

  subjects: [
    type: Schema.ObjectId
    ref: "Subject"
  ]
)

ContentSchema.statics = load: (id, cb) ->
  @findOne(_id: id).populate("creator").exec cb

mongoose.model "Content", ContentSchema
