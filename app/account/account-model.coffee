###
Module dependencies.
###
mongoose = require("mongoose")
Schema = mongoose.Schema

###
Account Schema
###
AccountSchema = new Schema(
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
AccountSchema.path("name").validate ((name) ->
  name.length
), "Name cannot be blank"

AccountSchema.path("label").validate ((label) ->
  label.length
), "Label cannot be blank"

###
Statics
###
AccountSchema.statics = load: (id, cb) ->
  @findOne(_id: id).populate("creator").exec cb

mongoose.model "Account", AccountSchema
