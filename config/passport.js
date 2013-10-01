(function() {
  var FacebookStrategy, GitHubStrategy, GoogleStrategy, LocalStrategy, TwitterStrategy, User, config, mongoose;

  mongoose = require("mongoose");

  LocalStrategy = require("passport-local").Strategy;

  TwitterStrategy = require("passport-twitter").Strategy;

  FacebookStrategy = require("passport-facebook").Strategy;

  GitHubStrategy = require("passport-github").Strategy;

  GoogleStrategy = require("passport-google-oauth").Strategy;

  User = mongoose.model("User");

  config = require("./config");

  module.exports = function(passport) {
    passport.serializeUser(function(user, done) {
      return done(null, user.id);
    });
    passport.deserializeUser(function(id, done) {
      return User.findOne({
        _id: id
      }, function(err, user) {
        return done(err, user);
      });
    });
    passport.use(new LocalStrategy({
      usernameField: "email",
      passwordField: "password"
    }, function(email, password, done) {
      return User.findOne({
        email: email
      }, function(err, user) {
        if (err) {
          return done(err);
        }
        if (!user) {
          return done(null, false, {
            message: "Unknown user"
          });
        }
        if (!user.authenticate(password)) {
          return done(null, false, {
            message: "Invalid password"
          });
        }
        return done(null, user);
      });
    }));
    passport.use(new TwitterStrategy({
      consumerKey: config.twitter.clientID,
      consumerSecret: config.twitter.clientSecret,
      callbackURL: config.twitter.callbackURL
    }, function(token, tokenSecret, profile, done) {
      return User.findOne({
        "twitter.id_str": profile.id
      }, function(err, user) {
        if (err) {
          return done(err);
        }
        if (!user) {
          user = new User({
            name: profile.displayName,
            username: profile.username,
            provider: "twitter",
            twitter: profile._json
          });
          return user.save(function(err) {
            if (err) {
              console.log(err);
            }
            return done(err, user);
          });
        } else {
          return done(err, user);
        }
      });
    }));
    passport.use(new FacebookStrategy({
      clientID: config.facebook.clientID,
      clientSecret: config.facebook.clientSecret,
      callbackURL: config.facebook.callbackURL
    }, function(accessToken, refreshToken, profile, done) {
      return User.findOne({
        "facebook.id": profile.id
      }, function(err, user) {
        if (err) {
          return done(err);
        }
        if (!user) {
          user = new User({
            name: profile.displayName,
            email: profile.emails[0].value,
            username: profile.username,
            provider: "facebook",
            facebook: profile._json
          });
          return user.save(function(err) {
            if (err) {
              console.log(err);
            }
            return done(err, user);
          });
        } else {
          return done(err, user);
        }
      });
    }));
    passport.use(new GitHubStrategy({
      clientID: config.github.clientID,
      clientSecret: config.github.clientSecret,
      callbackURL: config.github.callbackURL
    }, function(accessToken, refreshToken, profile, done) {
      return User.findOne({
        "github.id": profile.id
      }, function(err, user) {
        if (!user) {
          user = new User({
            name: profile.displayName,
            email: profile.emails[0].value,
            username: profile.username,
            provider: "github",
            github: profile._json
          });
          return user.save(function(err) {
            if (err) {
              console.log(err);
            }
            return done(err, user);
          });
        } else {
          return done(err, user);
        }
      });
    }));
    return passport.use(new GoogleStrategy({
      consumerKey: config.google.clientID,
      consumerSecret: config.google.clientSecret,
      callbackURL: config.google.callbackURL
    }, function(accessToken, refreshToken, profile, done) {
      return User.findOne({
        "google.id": profile.id
      }, function(err, user) {
        if (!user) {
          user = new User({
            name: profile.displayName,
            email: profile.emails[0].value,
            username: profile.username,
            provider: "google",
            google: profile._json
          });
          return user.save(function(err) {
            if (err) {
              console.log(err);
            }
            return done(err, user);
          });
        } else {
          return done(err, user);
        }
      });
    }));
  };

}).call(this);
