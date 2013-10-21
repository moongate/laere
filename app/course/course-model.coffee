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

  name:
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
  created:
    type: Date
    'default': Date.now

  startDate:
    type: Date
    'default': Date.now

  endDate:
    type: Date
    'default': Date.now

  creator:
    type: Schema.ObjectId
    ref: "User"

  teachers:
    type: [Schema.ObjectId]
    ref: "User"

  students:
    type: [Schema.ObjectId]
    ref: "User"

  contentTrack:
    type: [Schema.ObjectId]
    ref: "Content"
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

  contentTrack:
    type: [Schema.ObjectId]
    ref: "Content"
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
  @findOne(_id: id).populate("creator").exec cb

mongoose.model "Course", CourseSchema
mongoose.model "Classroom", ClassroomSchema
mongoose.model "Content", ContentSchema
