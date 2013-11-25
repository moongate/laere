angular.module("laere.progress").controller "TeachController", ($scope, $routeParams, $location, Global, Progress, Classrooms) ->
  $scope.global = Global

  $scope.find = (query) ->
    Classrooms.query query, (classrooms) ->
      $scope.classrooms = classrooms

  $scope.findClassroom = ->
    Classrooms.get
      classroomId: $routeParams.classroomId
    , (classroom) ->
      $scope.classroom = classroom
      $scope.course = classroom.course

  $scope.findProgress = ->
    Progress.get
      progressId: $routeParams.progressId
    , (progress) ->
      $scope.progress = progress

  if $routeParams.classroomId
    $scope.findClassroom()
    if $routeParams.progressId
      $scope.findProgress()
  else
    $scope.find(teachers: Global.user._id)