angular.module("laere").controller "HeaderController", ["$scope", "Global", ($scope, Global) ->
  $scope.global = Global
  $scope.menu = [
    title: "Articles"
    link: "articles"
  ,
    title: "Accounts"
    link: "accounts"
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
