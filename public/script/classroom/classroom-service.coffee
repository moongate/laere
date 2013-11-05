#Classrooms service used for classrooms REST endpoint
angular.module("laere.classrooms").factory "Classrooms", ($resource) ->
  $resource "classrooms/:classroomId",
    classroomId: "@_id"
  ,
    update:
      method: "PUT"