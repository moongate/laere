###
Module dependencies.
###
mongoose = require("mongoose")
Schema = mongoose.Schema

###
Content Schema
###
ContentSchema = new Schema(
  created:
    type: Date
    'default': Date.now

  creator:
    type: Schema.ObjectId
    ref: "User"

  tags: [String]

  type:
    type: String
    'default': ""
    trim: true

  name:
    type: String
    'default': ""
    trim: true

  description:
    type: String
    'default': ""
    trim: true

  url:
    type: String
    'default': ""
    trim: true
)

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

  teachers: [
    type: Schema.ObjectId
    ref: "User"
  ]

  students: [
    type: Schema.ObjectId
    ref: "User"
  ]

  # An array of object Ids of Contents from parent course
  track: [String]
)

###
Course Schema
###
CourseSchema = new Schema(
  created:
    type: Date
    'default': Date.now

  creator:
    type: Schema.ObjectId
    ref: "User"

  name:
    type: String
    'default': ""
    trim: true

  code:
    type: String
    'default': ""
    trim: true

  syllabus:
    type: String
    'default': ""
    trim: true

  details:
    type: String
    'default': ""
    trim: true

  contents: [ContentSchema]

  classrooms: [ClassroomSchema]

  # An array of object Ids of Contents
  suggestedTrack: [String]
)

###
Validations
###
CourseSchema.path("name").validate ((name) ->
  name.length
), "Name cannot be blank"

CourseSchema.path("code").validate ((label) ->
  label.length
), "Code cannot be blank"

###
Statics
###
CourseSchema.statics = load: (id, cb) ->
  @findOne(_id: id)
    .populate("creator")
    .populate("classrooms.teachers")
    .populate("classrooms.students")
    .exec cb

mongoose.model "Course", CourseSchema