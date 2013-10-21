angular.module("laere.schools").controller "SchoolsController", ($scope, $routeParams, $location, Global, Schools) ->
  $scope.global = Global

  $scope.createOrUpdate = ->
    if $scope.school._id
      $scope.update()
    else
      $scope.create()

  $scope.create = ->
    school = new Schools(
      name: $scope.school.name
      label: $scope.school.label
    )
    school.$save (response) ->
      $location.path "schools/" + response._id

    @name = ""
    @label = ""

  $scope.remove = (school) ->
    school.$remove()
    for i of $scope.schools
      $scope.schools.splice i, 1  if $scope.schools[i] is school

  $scope.update = ->
    school = $scope.school
    school.updated or= []
    school.updated.push new Date().getTime()
    school.$update ->
      $location.path "schools/" + school._id

  $scope.find = (query) ->
    Schools.query query, (schools) ->
      $scope.schools = schools

  $scope.findOne = ->
    Schools.get
      schoolId: $routeParams.schoolId
    , (school) ->
      $scope.school = school

  if $routeParams.schoolId
    $scope.findOne()
  else
    $scope.find()