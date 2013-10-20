angular.module("laere").controller "IndexController", ($scope, Global, Accounts) ->
  $scope.global = Global
  $scope.accounts = Accounts.query()