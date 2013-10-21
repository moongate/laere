angular.module("laere").controller "HeaderController", ["$scope", "Global", ($scope, Global) ->
  $scope.global = Global
  $scope.menu = [
    title: "Articles"
    link: "articles"
  ,
    title: "Schools"
    link: "schools"
  ,
    title: "Users"
    link: "users"
  ,
    title: "Courses"
    link: "courses"
  ,
    title: "Classrooms"
    link: "classrooms"
  ]
]
