###
Module dependencies.
###
mongoose = require("mongoose")
Schema = mongoose.Schema

###
Interaction Schema
###
InteractionSchema = new Schema(
  user:
    type: Schema.ObjectId
    ref: "User"
  classroom:
    type: Schema.ObjectId
    ref: "Classroom"
  content:
    type: Schema.ObjectId
    ref: "Content"
  date: Date
  message: String
  score: Number
)

###
Validations
###
InteractionSchema.path("user").validate ((user) ->
  user.length
), "User cannot be blank"
InteractionSchema.path("classroom").validate ((classroom) ->
  classroom.length
), "Classroom cannot be blank"
InteractionSchema.path("content").validate ((content) ->
  content.length
), "Content cannot be blank"

###
Statics
###
InteractionSchema.statics = load: (id, cb) ->
  @findOne(_id: id)
    .exec cb

mongoose.model "Interaction", InteractionSchema