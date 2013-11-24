angular.module("laere.courses").controller "ContentsController", ($scope, $routeParams, $location, Global) ->
  $scope.global = Global

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