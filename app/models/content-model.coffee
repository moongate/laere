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
ContentSchema.path("name").validate ((name) ->
  name.length
), "Name cannot be blank"

ContentSchema.path("label").validate ((label) ->
  label.length
), "Label cannot be blank"

###
Statics
###
ContentSchema.statics = load: (id, cb) ->
  @findOne(_id: id).populate("creator").exec cb

mongoose.model "Content", ContentSchema
