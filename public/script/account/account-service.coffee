#Accounts service used for accounts REST endpoint
angular.module("laere.accounts").factory "Accounts", ["$resource", ($resource) ->
  $resource "accounts/:accountId",
    accountId: "@_id"
  ,
    update:
      method: "PUT"

]
