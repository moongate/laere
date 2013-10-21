angular.module("laere.courses").controller "CoursesController", ($scope, $routeParams, $location, Global, Courses) ->
  $scope.global = Global

  $scope.createOrUpdate = ->
    if $scope.course._id
      $scope.update()
    else
      $scope.create()

  $scope.create = ->
    course = new Courses(
      name: $scope.course.name
      code: $scope.course.code
    )
    course.$save (response) ->
      $location.path "courses/" + response._id

    @name = ""
    @code = ""

  $scope.remove = (course) ->
    course.$remove()
    for i of $scope.courses
      $scope.courses.splice i, 1  if $scope.courses[i] is course

  $scope.update = ->
    course = $scope.course
    course.updated or= []
    course.updated.push new Date().getTime()
    course.$update ->
      $location.path "courses/" + course._id

  $scope.find = (query) ->
    Courses.query query, (courses) ->
      $scope.courses = courses

  $scope.findOne = ->
    Courses.get
      courseId: $routeParams.courseId
    , (course) ->
      $scope.course = course

  if $routeParams.courseId
    $scope.findOne()
  else
    $scope.find()