#Schools service used for schools REST endpoint
angular.module("laere.schools").factory "Schools", ($resource) ->
  $resource "schools/:schoolId",
    schoolId: "@_id"
  ,
    update:
      method: "PUT"