#Articles service used for articles REST endpoint
angular.module("laere.articles").factory "Articles", ["$resource", ($resource) ->
  $resource "articles/:articleId",
    articleId: "@_id"
  ,
    update:
      method: "PUT"

]
