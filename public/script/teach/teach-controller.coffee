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
      $scope.findStudents()

  $scope.findStudents = ->
    Progress.query {classroom: $scope.classroom._id}, (progressArray) ->
      $scope.progresses = progressArray
      if $routeParams.progressId
        $scope.progress = _.find $scope.progresses, (p) -> p._id is $routeParams.progressId

  $scope.selectContent = (content) ->
    $scope.data.content = content

  if $routeParams.classroomId
    $scope.findClassroom()
  else
    $scope.find(teachers: Global.user._id)