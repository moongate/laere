window.app = angular.module("laere", ["ngCookies", "ngResource",
                                      "ui.bootstrap", "ui.route",
                                      "laere.articles", "laere.schools", "laere.users", "laere.courses"])
angular.module "laere.articles", []
angular.module "laere.schools", []
angular.module "laere.users", []
angular.module "laere.courses", []

window.app.factory "Global", [=>
  @_data =
    user: window.user
    authenticated: !!window.user
    school: window.school

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
  .when "/schools",
    templateUrl: "views/schools/list.html"
  .when "/schools/create",
    templateUrl: "views/schools/edit.html"
  .when "/schools/:schoolId/edit",
    templateUrl: "views/schools/edit.html"
  .when "/schools/:schoolId",
    templateUrl: "views/schools/view.html"
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
  $rootScope.school = window.school

angular.element(document).ready ->
  window.location.hash = ""  if window.location.hash is "#_=_" # Fixing facebook bug with redirect
  angular.bootstrap document, ["laere"] # Initialize the app
