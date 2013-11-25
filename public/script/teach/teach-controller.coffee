angular.module("laere.progress").controller "TeachController", ($scope, $routeParams, $location, Global, Progress, Classrooms) ->
  $scope.global = Global
  $scope.data = {}

  $scope.find = (query) ->
    Classrooms.query query, (classrooms) ->
      $scope.classrooms = classrooms

  $scope.findClassroom = ->
    Classrooms.get
      classroomId: $routeParams.classroomId
    , (classroom) ->
      $scope.classroom = classroom
      $scope.course = classroom.course
      $scope.data.selectedContentIndex = $routeParams.contentIndex or 0

  $scope.findProgress = ->
    Progress.get
      progressId: $routeParams.progressId
    , (progress) ->
      $scope.progress = progress

  $scope.selectContent = (content) ->
    $scope.data.content = content

  if $routeParams.classroomId
    $scope.findClassroom()
    if $routeParams.progressId
      $scope.findProgress()
  else
    $scope.find(teachers: Global.user._id)