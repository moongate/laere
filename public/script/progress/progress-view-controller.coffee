angular.module("laere.progress").controller "ProgressViewController", ($scope, $routeParams, $location, Global, Progress) ->
  $scope.global = Global

  $scope.$watch 'data.selectedContentIndex', (index, oldIndex) ->
    return if index is oldIndex
    $scope.data.content = $scope.course.contents[index]

  $scope.backward = ->
    $scope.data.selectedContentIndex-- if $scope.data.selectedContentIndex > 0

  $scope.forward = ->
    $scope.data.selectedContentIndex++ if $scope.data.selectedContentIndex < $scope.course.contents.length - 1