window.app = angular.module("laere", ["ngCookies", "ngResource",
                                      "ui.bootstrap", "ui.route",
                                      "laere.schools", "laere.users", "laere.courses"])
angular.module "laere.schools", []
angular.module "laere.users", []
angular.module "laere.courses", []

window.app.factory "Global", [=>
  @_data =
    user: window.user
    authenticated: !!window.user
    school: window.school
    env: window.env
    host: window.laereHost

  @_data
]

#Setting up route
window.app.config ["$routeProvider", ($routeProvider) ->
  $routeProvider
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
  .when "/courses",
    templateUrl: "views/courses/list.html"
  .when "/courses/create",
    templateUrl: "views/courses/edit.html"
  .when "/courses/:courseId/edit",
    templateUrl: "views/courses/edit.html"
  .when "/courses/:courseId",
    templateUrl: "views/courses/view.html"
  .when "/",
    templateUrl: "views/index.html"
  .otherwise redirectTo: "/"
]

app.run ($rootScope) ->
  $rootScope.school = window.school

angular.element(document).ready ->
  window.location.hash = ""  if window.location.hash is "#_=_" # Fixing facebook bug with redirect
  angular.bootstrap document, ["laere"] # Initialize the app
