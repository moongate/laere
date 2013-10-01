/*
Module dependencies.
*/


(function() {
  var ArticleSchema, Schema, config, mongoose;

  mongoose = require("mongoose");

  config = require("../../config/config");

  Schema = mongoose.Schema;

  /*
  Article Schema
  */


  ArticleSchema = new Schema({
    created: {
      type: Date,
      "default": Date.now
    },
    title: {
      type: String,
      "default": "",
      trim: true
    },
    content: {
      type: String,
      "default": "",
      trim: true
    },
    user: {
      type: Schema.ObjectId,
      ref: "User"
    }
  });

  /*
  Validations
  */


  ArticleSchema.path("title").validate((function(title) {
    return title.length;
  }), "Title cannot be blank");

  /*
  Statics
  */


  ArticleSchema.statics = {
    load: function(id, cb) {
      return this.findOne({
        _id: id
      }).populate("user").exec(cb);
    }
  };

  mongoose.model("Article", ArticleSchema);

}).call(this);
