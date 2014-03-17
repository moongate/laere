###
Module dependencies.
###
mongoose = require("mongoose")
Schema = mongoose.Schema

###
Progress Schema
###
ProgressSchema = new Schema(
  student:
    type: Schema.ObjectId
    ref: "User"
  classroom:
    type: Schema.ObjectId
    ref: "Classroom"
  solutions: [
    content: String
    seen: Date
    interactions: [
      author: String
      message: String
      date: Date
      score: Number
    ]
  ]
)

###
Validations
###
ProgressSchema.path("student").validate ((student) ->
  student.length
), "Student cannot be blank"
ProgressSchema.path("classroom").validate ((classroom) ->
  classroom.length
), "Classroom cannot be blank"

###
Statics
###
ProgressSchema.statics = load: (id, cb) ->
  @findOne(_id: id)
    .populate("classroom")
    .exec cb

mongoose.model "Progress", ProgressSchema