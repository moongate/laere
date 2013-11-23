###
Module dependencies.
###
should = require("should")
app = require("../../server")
mongoose = require("mongoose")
User = mongoose.model("User")
School = mongoose.model("School")

#Globals
user = undefined
school = undefined

#The tests
describe "Schools", ->
  beforeEach (done) ->
    user = new User(
      name: "Full name"
      email: "test@test.com"
      username: "user"
      password: "password"
    )
    user.save (err) ->
      school = new School(
        name: "School Name"
        label: "School Label"
        creator: user
      )
      done()

  describe "Method Save", ->
    it "should save", (done) ->
      school.save (err) ->
        should.not.exist err
        done()

    it "should not save without name", (done) ->
      school.name = ""
      school.save (err) ->
        should.exist err
        done()

    it "should not save without label", (done) ->
      school.label = ""
      school.save (err) ->
        should.exist err
        done()