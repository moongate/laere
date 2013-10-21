#Users service used for users REST endpoint
angular.module("laere.users").factory "Users", ($resource) ->
  $resource "users/:userId",
    userId: "@_id"
  ,
    update:
      method: "PUT"