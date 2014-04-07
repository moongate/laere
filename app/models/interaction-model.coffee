###
Module dependencies.
###
mongoose = require("mongoose")
Schema = mongoose.Schema

InteractionSchema = new Schema(
  user:
    type: Schema.ObjectId
    ref: "User"
    required: true

  classroom:
    type: Schema.ObjectId
    ref: "Classroom"
    required: true

  content:
    type: Schema.ObjectId
    ref: "Content"
    required: true

  parent:
    type: Schema.ObjectId
    ref: "Interaction"

  date:
    type: Date
    required: true

  message:
    type: String
    required: true

  score: Number
)

InteractionSchema.statics = load: (id, cb) ->
  @findOne(_id: id)
    .exec cb

mongoose.model "Interaction", InteractionSchema