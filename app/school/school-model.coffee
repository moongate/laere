###
Module dependencies.
###
mongoose = require("mongoose")
Schema = mongoose.Schema

###
School Schema
###
SchoolSchema = new Schema(
  created:
    type: Date
    'default': Date.now

  name:
    type: String
    'default': ""
    trim: true

  label:
    type: String
    'default': ""
    trim: true

  creator:
    type: Schema.ObjectId
    ref: "User"
)

###
Validations
###
SchoolSchema.path("name").validate ((name) ->
  name.length
), "Name cannot be blank"

SchoolSchema.path("label").validate ((label) ->
  label.length
), "Label cannot be blank"

###
Statics
###
SchoolSchema.statics = load: (id, cb) ->
  @findOne(_id: id).populate("creator").exec cb

mongoose.model "School", SchoolSchema
