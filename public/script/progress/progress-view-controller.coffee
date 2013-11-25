angular.module("laere.progress").controller "ProgressViewController", ($scope, $routeParams, $location, Global, Progress) ->
  $scope.global = Global

  $scope.$watch 'data.selectedContentIndex', (index, oldIndex) ->
    return if index is oldIndex
    $scope.data.content = $scope.course.contents[index]

  $scope.$watch 'progress', (progress, oldProgress) ->
    return if not progress?

    content.solution = null for content in $scope.course.contents

    for solution in progress.solutions when solution.content
      content = $scope.course.contents[parseInt(solution.content, 10)]
      content?.solution = solution

    seen = _.reduce $scope.course.contents, ((memo, content) -> if content.solution?.seen then memo + 1 else memo ), 0
    $scope.data.seenProgressStyle = {width: (seen / $scope.course.contents.length)*100 + '%'}

  $scope.backward = ->
    $scope.data.selectedContentIndex-- if $scope.data.selectedContentIndex > 0

  $scope.forward = ->
    $scope.data.selectedContentIndex++ if $scope.data.selectedContentIndex < $scope.course.contents.length - 1