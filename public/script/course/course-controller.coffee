angular.module("laere.courses").controller "CoursesController", ($scope, $routeParams, $location, Global, Courses) ->
  $scope.global = Global
  $scope.edit = {}

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

  $scope.editContent = (index) ->
    $scope.edit.content = angular.copy($scope.course.contents[index])
    $scope.edit.content.index = index

  $scope.createOrUpdateContent = ->
    if $scope.edit.content.index?
      $scope.course.contents[$scope.edit.content.index] = angular.copy($scope.edit.content)
    else
      $scope.edit.content.creator = Global.user._id
      $scope.course.contents.push angular.copy($scope.edit.content)
    $scope.edit.content = undefined
    return false

  $scope.editClassroom = (index) ->
    $scope.edit.classroom = angular.copy($scope.course.classrooms[index])
    $scope.edit.classroom.index = index

  $scope.createOrUpdateClassroom = ->
    if $scope.edit.classroom.index?
      $scope.course.classrooms[$scope.edit.classroom.index] = angular.copy($scope.edit.classroom)
    else
      $scope.edit.classroom.creator = Global.user._id
      $scope.course.classrooms.push angular.copy($scope.edit.classroom)
    $scope.edit.classroom = undefined
    return false

  if $routeParams.courseId
    $scope.findOne()
  else
    $scope.find()