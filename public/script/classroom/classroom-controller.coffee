angular.module("laere.classrooms").controller "ClassroomsController", ($scope, $routeParams, $location, Global, Classrooms, Progress) ->
  $scope.global = Global

  $scope.newClassroom = ->
    $scope.data.classroom = {}

  $scope.editClassroom = (classroom) ->
    $scope.data.classroom = classroom
    Progress.query {classroom: $scope.data.classroom._id}, (progressList) ->
      console.log progressList
      $scope.data.classroom.progresses = progressList

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
      teachers: _.map $scope.data.classroom.teachers, (t) -> t._id
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
    delete classroom.creator
    classroom.updated or= []
    classroom.updated.push new Date().getTime()
    classroom.teachers = _.map classroom.teachers, (t) -> t._id
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

  $scope.addStudent = (student) ->
    console.log student
    progress = new Progress(
      classroom: $scope.data.classroom._id
      student: student._id
    )
    progress.$save ->
      Progress.query {classroom: $scope.data.classroom._id}, (progressList) ->
        console.log progressList
        $scope.data.classroom.progresses = progressList
        $scope.data.classroom.studentUsername = ''

  $scope.removeStudent = (progress) ->
    progress.$remove()
    for i of $scope.data.classroom.progresses
      $scope.data.classroom.progresses.splice i, 1 if $scope.data.classroom.progresses[i] is progress

  $scope.existingStudent = (added) ->
    not _.find $scope.data.classroom.progresses, (existing) -> existing.student._id is added._id
