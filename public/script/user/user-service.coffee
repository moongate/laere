#Users service used for users REST endpoint
angular.module("laere.users").factory "Users", ($resource) ->
  $resource "users/:userId",
    userId: "@_id"
  ,
    update:
      method: "PUT"

angular.module("laere.users").value "UserPermissions",
  study: undefined
  teach: undefined
  createContent: undefined
  manageClassroomTrack: undefined
  manageCourseTrack: undefined
  createClassroom: undefined
  createCourse: undefined