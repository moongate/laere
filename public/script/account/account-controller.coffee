angular.module("laere.accounts").controller "AccountsController", ($scope, $routeParams, $location, Global, Accounts) ->
  $scope.global = Global

  $scope.createOrUpdate = ->
    if $scope.account._id
      $scope.update()
    else
      $scope.create()

  $scope.create = ->
    account = new Accounts(
      name: $scope.account.name
      label: $scope.account.label
    )
    account.$save (response) ->
      $location.path "accounts/" + response._id

    @name = ""
    @label = ""

  $scope.remove = (account) ->
    account.$remove()
    for i of $scope.accounts
      $scope.accounts.splice i, 1  if $scope.accounts[i] is account

  $scope.update = ->
    account = $scope.account
    account.updated or= []
    account.updated.push new Date().getTime()
    account.$update ->
      $location.path "accounts/" + account._id

  $scope.find = (query) ->
    Accounts.query query, (accounts) ->
      $scope.accounts = accounts

  $scope.findOne = ->
    Accounts.get
      accountId: $routeParams.accountId
    , (account) ->
      $scope.account = account

  if $routeParams.accountId
    $scope.findOne()
  else
    $scope.find()