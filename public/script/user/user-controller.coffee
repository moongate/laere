angular.module("laere.users").controller "UsersController", ($scope, $routeParams, $location, Global, Users, Schools) ->
  $scope.global = Global

  $scope.createOrUpdate = ->
    if $scope.user._id
      $scope.update()
    else
      $scope.create()

  $scope.create = ->
    user = new Users(
      name: $scope.user.name
      email: $scope.user.email
      username: $scope.user.username
      school: $scope.user.school
    )
    user.$save (response) ->
      $location.path "users/" + response._id

    @name = ""
    @email = ""
    @username = ""
    @school = ""

  $scope.remove = (user) ->
    user.$remove()
    for i of $scope.users
      $scope.users.splice i, 1  if $scope.users[i] is user

  $scope.update = ->
    user = $scope.user
    user.updated or= []
    user.updated.push new Date().getTime()
    user.$update ->
      $location.path "users/" + user._id

  $scope.find = (query) ->
    Users.query query, (users) ->
      $scope.users = users

  $scope.findOne = ->
    Users.get
      userId: $routeParams.userId
    , (user) ->
      $scope.user = user

  $scope.findSchools = ->
    Schools.query (schools) ->
      $scope.schools = schools

  if $routeParams.userId
    $scope.findOne()
    # If we are editing, we need to show all available schools
    if $location.path().indexOf('edit') isnt -1
      $scope.findSchools()
  else
    $scope.find()
