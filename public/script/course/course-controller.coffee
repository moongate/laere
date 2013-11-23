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
    course.$save (response) ->
      $location.path "courses/" + response._id + "/edit"

    @name = ""
    @code = ""

  $scope.remove = (course) ->
    course.$remove()
    for i of $scope.courses
      $scope.courses.splice i, 1  if $scope.courses[i] is course

  $scope.update = ->
    course = $scope.data.course
    course.updated or= []
    course.updated.push new Date().getTime()
    course.$update()

  $scope.find = (query) ->
    Courses.query query, (courses) ->
      $scope.courses = courses

  $scope.findOne = ->
    Courses.get(courseId: $routeParams.courseId).$promise
    .then (course) ->
      $scope.data.course = course
      Classrooms.query('course': course._id).$promise
    .then (classrooms) ->
      $scope.data.course.classrooms = classrooms

  $scope.editContent = (index) ->
    $scope.data.content = angular.copy($scope.data.course.contents[index])
    $scope.data.content.index = index

  $scope.removeContent = (index) ->
    $scope.data.course.contents.splice(index, 1)
    $scope.update()

  $scope.createOrUpdateContent = ->
    if $scope.data.content.index?
      $scope.data.course.contents[$scope.data.content.index] = angular.copy($scope.data.content)
    else
      $scope.data.content.creator = Global.user._id
      $scope.data.course.contents.push angular.copy($scope.data.content)
    $scope.data.content = undefined
    $scope.update()
    return false

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
