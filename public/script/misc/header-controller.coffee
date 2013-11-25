angular.module("laere").controller "HeaderController", ($scope, Global) ->
  $scope.global = Global
  $scope.menu = [
    title: "Schools"
    link: "schools"
  ,
    title: "Users"
    link: "users"
  ,
    title: "My Classrooms"
    link: "classrooms"
  ,
    title: "Courses"
    link: "courses"
  ]