###
Module dependencies.
###
should = require("should")
app = require("../../app")
mongoose = require("mongoose")
User = mongoose.model("User")
Course = mongoose.model("Course")

#Globals
user = undefined
course = undefined

#The tests
describe "Courses", ->
  beforeEach (done) ->
    user = new User(
      name: "Full name"
      email: "test@test.com"
      username: "user"
      password: "password"
    )
    user.save (err) ->
      course = new Course(
        name: "Course Name"
        code: "c0123"
        creator: user
      )
      done()

  describe "Method Save", ->
    it "should save", (done) ->
      course.save (err) ->
        should.not.exist err
        done()

    it "should not save without name", (done) ->
      course.name = ""
      course.save (err) ->
        should.exist err
        done()

    it "should not save without code", (done) ->
      course.code = ""
      course.save (err) ->
        should.exist err
        done()

    it "should save with contents", (done) ->
      course.contents = []
      course.contents.push
        created: new Date()
        creator: user
        tags: ['test']
        type: 'video'
        name: 'test video'
        description: 'test video description'
        url: 'http://test.com'

      course.save (err, savedCourse) ->
        should.not.exist err
        should.exist savedCourse.contents
        savedCourse.contents[0].creator.should.equal user._id
        savedCourse.contents[0].name.should.equal 'test video'
        done()