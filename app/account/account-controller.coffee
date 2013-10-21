###
Module dependencies.
###
mongoose = require("mongoose")
async = require("async")
Account = mongoose.model("Account")
_ = require("underscore")

###
Find account by id
###
exports.account = (req, res, next, id) ->
  Account.load id, (err, account) ->
    return next(err)  if err
    return next(new Error("Failed to load account " + id))  unless account
    req.account = account
    next()

###
Create a account
###
exports.create = (req, res) ->
  account = new Account(req.body)
  account.creator = req.user
  account.save (err) ->
    if err
      res.send "accounts/create",
        errors: err.errors
        account: account

    else
      res.jsonp account

###
Update a account
###
exports.update = (req, res) ->
  account = req.account
  account = _.extend(account, req.body)
  account.save (err) ->
    res.jsonp account

###
Delete an account
###
exports.destroy = (req, res) ->
  account = req.account
  account.remove (err) ->
    if err
      res.render "error",
        status: 500

    else
      res.jsonp account

###
Show an account
###
exports.show = (req, res) ->
  res.jsonp req.account

###
List of Accounts
###
exports.all = (req, res) ->
  Account.find().sort("-created").populate("creator").exec (err, accounts) ->
    if err
      res.render "error",
        status: 500

    else
      res.jsonp accounts

###
Account verification interceptor
###
exports.verify = (req, res, next) ->
  account = /(.*).laere(dev)?.co/.exec(req.headers.host)?[1]
  console.log account
  req.currentAccount = account if account
  next()