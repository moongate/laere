window.app = angular.module("laere", ["ngCookies", "ngResource",
                                      "ui.bootstrap", "ui.route",
                                      "laere.articles", "laere.accounts", "laere.users", "laere.courses"])
angular.module "laere.articles", []
angular.module "laere.accounts", []
angular.module "laere.users", []
angular.module "laere.courses", []

window.app.factory "Global", [=>
  @_data =
    user: window.user
    authenticated: !!window.user
    account: window.account

  @_data
]

#Setting up route
window.app.config ["$routeProvider", ($routeProvider) ->
  $routeProvider
  .when "/articles",
    templateUrl: "views/articles/list.html"
  .when "/articles/create",
    templateUrl: "views/articles/create.html"
  .when "/articles/:articleId/edit",
    templateUrl: "views/articles/edit.html"
  .when "/articles/:articleId",
    templateUrl: "views/articles/view.html"
  .when "/accounts",
    templateUrl: "views/accounts/list.html"
  .when "/accounts/create",
    templateUrl: "views/accounts/edit.html"
  .when "/accounts/:accountId/edit",
    templateUrl: "views/accounts/edit.html"
  .when "/accounts/:accountId",
    templateUrl: "views/accounts/view.html"
  .when "/users",
    templateUrl: "views/users/list.html"
  .when "/users/create",
    templateUrl: "views/users/edit.html"
  .when "/users/:userId/edit",
    templateUrl: "views/users/edit.html"
  .when "/users/:userId",
    templateUrl: "views/users/view.html"
  .when "/",
    templateUrl: "views/index.html"
  .otherwise redirectTo: "/"
]

app.run ($rootScope) ->
  $rootScope.account = window.account

angular.element(document).ready ->
  window.location.hash = ""  if window.location.hash is "#_=_" # Fixing facebook bug with redirect
  angular.bootstrap document, ["laere"] # Initialize the app
