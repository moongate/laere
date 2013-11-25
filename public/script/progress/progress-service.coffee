#Progress service used for progress REST endpoint
angular.module("laere.progress").factory "Progress", ($resource) ->
  $resource "progress/:progressId",
    progressId: "@_id"
  ,
    update:
      method: "PUT"
    seen:
      method: "PUT"
      params:
        seen: true
      url: "progress/:progressId/seen"