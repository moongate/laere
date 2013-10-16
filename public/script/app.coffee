window.app = angular.module("laere", ["ngCookies", "ngResource", "ui.bootstrap", "ui.route", "laere.articles"])
angular.module "laere.articles", []

window.app.factory "Global", [=>
  @_data =
    user: window.user
    authenticated: !!window.user

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
  .when "/",
    templateUrl: "views/index.html"
  .otherwise redirectTo: "/"
]

app.run ($rootScope) ->
  $rootScope.account = window.account

angular.element(document).ready ->
  window.location.hash = ""  if window.location.hash is "#_=_" # Fixing facebook bug with redirect
  angular.bootstrap document, ["laere"] # Initialize the app
