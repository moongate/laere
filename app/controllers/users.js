/*
Module dependencies.
*/


(function() {
  var User, mongoose;

  mongoose = require("mongoose");

  User = mongoose.model("User");

  /*
  Auth callback
  */


  exports.authCallback = function(req, res, next) {
    return res.redirect("/");
  };

  /*
  Show login form
  */


  exports.signin = function(req, res) {
    return res.render("users/signin", {
      title: "Signin",
      message: req.flash("error")
    });
  };

  /*
  Show sign up form
  */


  exports.signup = function(req, res) {
    return res.render("users/signup", {
      title: "Sign up",
      user: new User()
    });
  };

  /*
  Logout
  */


  exports.signout = function(req, res) {
    req.logout();
    return res.redirect("/");
  };

  /*
  Session
  */


  exports.session = function(req, res) {
    return res.redirect("/");
  };

  /*
  Create user
  */


  exports.create = function(req, res) {
    var user;
    user = new User(req.body);
    user.provider = "local";
    return user.save(function(err) {
      if (err) {
        return res.render("users/signup", {
          errors: err.errors,
          user: user
        });
      }
      return req.logIn(user, function(err) {
        if (err) {
          return next(err);
        }
        return res.redirect("/");
      });
    });
  };

  /*
  Show profile
  */


  exports.show = function(req, res) {
    var user;
    user = req.profile;
    return res.render("users/show", {
      title: user.name,
      user: user
    });
  };

  /*
  Send User
  */


  exports.me = function(req, res) {
    return res.jsonp(req.user || null);
  };

  /*
  Find user by id
  */


  exports.user = function(req, res, next, id) {
    return User.findOne({
      _id: id
    }).exec(function(err, user) {
      if (err) {
        return next(err);
      }
      if (!user) {
        return next(new Error("Failed to load User " + id));
      }
      req.profile = user;
      return next();
    });
  };

}).call(this);
