angular.module("laere.classrooms").controller "ClassroomsController", ($scope, $routeParams, $location, Global, Classrooms) ->
  $scope.global = Global

  $scope.newClassroom = ->
    $scope.data.classroom = {}

  $scope.editClassroom = (classroom) ->
    $scope.data.classroom = classroom

  $scope.cancelClassroomEdit = ->
    $scope.data.classroom = undefined

  $scope.removeClassroom = (classroom) ->
    classroom.$remove().then ->
      Classrooms.query {'course': $scope.data.course._id}, (classrooms) ->
        $scope.data.course.classrooms = classrooms
        $scope.data.classroom = undefined

  $scope.createOrUpdate = ->
    if $scope.data.classroom._id
      $scope.update()
    else
      $scope.create()

  $scope.create = ->
    classroom = new Classrooms(
      name: $scope.data.classroom.name
      startDate: $scope.data.classroom.startDate
      endDate: $scope.data.classroom.endDate
      creator: $scope.global.user._id
      course: $scope.data.course._id
      teachers: $scope.data.classroom.teachers
    )
    classroom.$save ->
      Classrooms.query {'course': $scope.data.course._id}, (classrooms) ->
        $scope.data.course.classrooms = classrooms
        $scope.data.classroom = undefined

    @name = ""
    @endDate = ""
    @startDate = ""
    @creator = ""
    @course = ""
    @teachers = ""

  $scope.update = ->
    classroom = $scope.data.classroom
    classroom.updated or= []
    classroom.updated.push new Date().getTime()
    classroom.$update ->
      Classrooms.query {'course': $scope.data.course._id}, (classrooms) ->
        $scope.data.course.classrooms = classrooms
        $scope.data.classroom = undefined

  $scope.addTeacher = (teacher) ->
    console.log teacher
    $scope.data.classroom.teachers or= []
    $scope.data.classroom.teachers.push teacher
    $scope.data.classroom.teacherUsername = ''

  $scope.existingTeacher = (added) ->
    not _.find $scope.data.classroom.teachers, (existing) -> existing._id is added._id
