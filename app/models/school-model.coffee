###
Module dependencies.
###
mongoose = require("mongoose")
Schema = mongoose.Schema

SchoolSchema = new Schema(
  created:
    type: Date
    'default': Date.now

  name:
    type: String
    trim: true
    required: true

  code:
    type: String
    trim: true
    required: true

  creator:
    type: Schema.ObjectId
    ref: "User"
    required: true
)

SchoolSchema.statics = load: (id, cb) ->
  @findOne(_id: id).populate("creator").exec cb

mongoose.model "School", SchoolSchema
