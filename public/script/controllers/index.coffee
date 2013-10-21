angular.module("laere").controller "IndexController", ($scope, Global, Schools) ->
  $scope.global = Global
  $scope.schools = Schools.query()