angular.module("laere.courses").controller "CoursesController", ($scope, $routeParams, $location, Global, Courses, Users, Classrooms) ->
  $scope.global = Global
  $scope.data = {}

  $scope.createOrUpdate = ->
    if $scope.data.course._id
      $scope.update()
    else
      $scope.create()

  $scope.create = ->
    course = new Courses(
      name: $scope.data.course.name
      code: $scope.data.course.code
    )
    course.$save ->
      $location.path 'courses/' + course._id + '/edit'

    @name = ""
    @code = ""

  $scope.remove = (course) ->
    course.$remove()
    $location.path 'courses/'

  $scope.update = ->
    course = $scope.data.course
    delete course.creator
    course.updated or= []
    course.updated.push new Date().getTime()
    classrooms = $scope.data.course.classrooms
    course.$update ->
      $scope.showEdit = false
      $scope.data.course.classrooms = classrooms

  $scope.findClassrooms = ->
    Classrooms.query('course': $scope.data.course._id).$promise
    .then (classrooms) ->
      $scope.data.course.classrooms = classrooms

  $scope.find = (query) ->
    Courses.query query, (courses) ->
      $scope.courses = courses

  $scope.findOne = ->
    Courses.get(courseId: $routeParams.courseId).$promise
    .then (course) ->
      $scope.data.course = course
      $scope.findClassrooms()

  $scope.findTeachers = ->
    Users.query {'permissions.teach': true}, (teachers) ->
      $scope.data.teachers = teachers

  $scope.findStudents = ->
    Users.query {'permissions.study': true}, (students) ->
      $scope.data.students = students

  if $routeParams.courseId
    $scope.findOne()
  else
    $scope.find()

  # If we are editing, we need to show all users
  if /(edit)|(create)/.test($location.path()) and Global.user.permissions.manage
    $scope.findTeachers()
    $scope.findStudents()
