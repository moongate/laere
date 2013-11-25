angular.module("laere.progress").controller "ProgressController", ($scope, $routeParams, $location, Global, Progress) ->
  $scope.global = Global

  $scope.createOrUpdate = ->
    if $scope.progress._id
      $scope.update()
    else
      $scope.create()

  $scope.create = ->
    progress = new Progress(
      name: $scope.progress.name
      label: $scope.progress.label
    )
    progress.$save (response) ->
      $location.path "progress/" + response._id

    @name = ""
    @label = ""

  $scope.remove = (progress) ->
    progress.$remove()
    for i of $scope.progressArray
      $scope.progressArray.splice i, 1  if $scope.progressArray[i] is progress

  $scope.update = ->
    progress = $scope.progress
    progress.updated or= []
    progress.updated.push new Date().getTime()
    progress.$update ->
      $location.path "progress/" + progress._id

  $scope.find = (query) ->
    Progress.query query, (progressArray) ->
      $scope.progresses = progressArray

  $scope.findOne = ->
    Progress.get
      progressId: $routeParams.progressId
    , (progress) ->
      $scope.progress = progress
      $scope.classroom = progress.classroom
      $scope.course = progress.classroom.course

  if $routeParams.progressId
    $scope.findOne()
  else
    $scope.find(student: Global.user._id)