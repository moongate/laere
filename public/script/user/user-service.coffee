#Users service used for users REST endpoint
angular.module("laere.users").factory "Users", ($resource) ->
  $resource "users/:userId",
    userId: "@_id"
  ,
    update:
      method: "PUT"

angular.module("laere.users").value "UserPermissions",
  study: true
  teach: false
  manage: false
  classroom: false
  course: false