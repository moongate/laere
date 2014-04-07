###
Module dependencies.
###
mongoose = require("mongoose")
Schema = mongoose.Schema

ClassroomSchema = new Schema(
  name:
    type: String
    'default': ""
    trim: true
    required: true

  created:
    type: Date
    'default': Date.now

  startDate: Date

  endDate: Date

  creator:
    type: Schema.ObjectId
    ref: "User"
    required: true

  course:
    type: Schema.ObjectId
    ref: "Course"
    required: true

  teachers: [
    type: Schema.ObjectId
    ref: "User"
  ]

  students: [
    type: Schema.ObjectId
    ref: "User"
  ]

  lessons: [
    type: Schema.ObjectId
    ref: "Content"
  ]

  relatedContent: [
    type: Schema.ObjectId
    ref: "Content"
  ]
)

ClassroomSchema.statics = load: (id, cb) ->
  @findOne(_id: id)
    .populate("creator")
    .populate("course")
    .populate("teachers")
    .populate("students")
    .exec cb

mongoose.model "Classroom", ClassroomSchema