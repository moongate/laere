#Courses service used for courses REST endpoint
angular.module("laere.courses").factory "Courses", ($resource) ->
  $resource "courses/:courseId",
    courseId: "@_id"
  ,
    update:
      method: "PUT"