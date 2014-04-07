###
Module dependencies.
###
mongoose = require 'mongoose'
Schema = mongoose.Schema

CourseSchema = new Schema(
  created:
    type: Date
    'default': Date.now

  creator:
    type: Schema.ObjectId
    ref: "User"
    required: true

  school:
    type: Schema.ObjectId
    ref: "School"
    required: true

  name:
    type: String
    'default': ""
    trim: true
    required: true

  code:
    type: String
    'default': ""
    trim: true
    required: true

  syllabus:
    type: String
    'default': ""
    trim: true

  details:
    type: String
    'default': ""
    trim: true

  subjects: [
    type: Schema.ObjectId
    ref: "Subject"
  ]
)

CourseSchema.statics = load: (id, cb) ->
  @findOne(_id: id)
    .populate("creator")
    .populate("subjects")
    .exec cb

mongoose.model "Course", CourseSchema