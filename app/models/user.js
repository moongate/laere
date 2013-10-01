/*
Module dependencies.
*/


(function() {
  var Schema, UserSchema, authTypes, crypto, mongoose, validatePresenceOf, _;

  mongoose = require("mongoose");

  Schema = mongoose.Schema;

  crypto = require("crypto");

  _ = require("underscore");

  authTypes = ["github", "twitter", "facebook", "google"];

  /*
  User Schema
  */


  UserSchema = new Schema({
    name: String,
    email: String,
    username: String,
    provider: String,
    hashed_password: String,
    salt: String,
    facebook: {},
    twitter: {},
    github: {},
    google: {}
  });

  /*
  Virtuals
  */


  UserSchema.virtual("password").set(function(password) {
    this._password = password;
    this.salt = this.makeSalt();
    return this.hashed_password = this.encryptPassword(password);
  }).get(function() {
    return this._password;
  });

  /*
  Validations
  */


  validatePresenceOf = function(value) {
    return value && value.length;
  };

  UserSchema.path("name").validate((function(name) {
    if (authTypes.indexOf(this.provider) !== -1) {
      return true;
    }
    return name.length;
  }), "Name cannot be blank");

  UserSchema.path("email").validate((function(email) {
    if (authTypes.indexOf(this.provider) !== -1) {
      return true;
    }
    return email.length;
  }), "Email cannot be blank");

  UserSchema.path("username").validate((function(username) {
    if (authTypes.indexOf(this.provider) !== -1) {
      return true;
    }
    return username.length;
  }), "Username cannot be blank");

  UserSchema.path("hashed_password").validate((function(hashed_password) {
    if (authTypes.indexOf(this.provider) !== -1) {
      return true;
    }
    return hashed_password.length;
  }), "Password cannot be blank");

  /*
  Pre-save hook
  */


  UserSchema.pre("save", function(next) {
    if (!this.isNew) {
      return next();
    }
    if (!validatePresenceOf(this.password) && authTypes.indexOf(this.provider) === -1) {
      return next(new Error("Invalid password"));
    } else {
      return next();
    }
  });

  /*
  Methods
  */


  UserSchema.methods = {
    /*
    Authenticate - check if the passwords are the same
    
    @param {String} plainText
    @return {Boolean}
    @api public
    */

    authenticate: function(plainText) {
      return this.encryptPassword(plainText) === this.hashed_password;
    },
    /*
    Make salt
    
    @return {String}
    @api public
    */

    makeSalt: function() {
      return Math.round(new Date().valueOf() * Math.random()) + "";
    },
    /*
    Encrypt password
    
    @param {String} password
    @return {String}
    @api public
    */

    encryptPassword: function(password) {
      if (!password) {
        return "";
      }
      return crypto.createHmac("sha1", this.salt).update(password).digest("hex");
    }
  };

  mongoose.model("User", UserSchema);

}).call(this);
