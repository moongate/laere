###
Module dependencies.
###
mongoose = require("mongoose")
Schema = mongoose.Schema

###
Classroom Schema
###
ClassroomSchema = new Schema(
  name:
    type: String
    'default': ""
    trim: true

  created:
    type: Date
    'default': Date.now

  startDate: Date

  endDate: Date

  creator:
    type: Schema.ObjectId
    ref: "User"

  course:
    type: Schema.ObjectId
    ref: "Course"

  teachers: [
    type: Schema.ObjectId
    ref: "User"
  ]

  # An array of object Ids of Contents from parent course
  track: [String]
)

###
Validations
###
ClassroomSchema.path("name").validate ((name) ->
  name.length
), "Name cannot be blank"
ClassroomSchema.path("course").validate ((course) ->
  course.length
), "Course cannot be blank"

###
Statics
###
ClassroomSchema.statics = load: (id, cb) ->
  @findOne(_id: id)
    .populate("creator")
    .populate("course")
    .populate("teachers")
    .exec cb

mongoose.model "Classroom", ClassroomSchema