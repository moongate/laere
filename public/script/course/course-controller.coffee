angular.module("laere.courses").controller "CoursesController", ($scope, $routeParams, $location, Global, Courses, Users) ->
  $scope.global = Global
  $scope.edit = {}

  $scope.createOrUpdate = ->
    if $scope.course._id
      $scope.update()
    else
      $scope.create()

  $scope.create = ->
    course = new Courses(
      name: $scope.course.name
      code: $scope.course.code
    )
    course.$save (response) ->
      $location.path "courses/" + response._id

    @name = ""
    @code = ""

  $scope.remove = (course) ->
    course.$remove()
    for i of $scope.courses
      $scope.courses.splice i, 1  if $scope.courses[i] is course

  $scope.update = ->
    course = $scope.course
    for classroom in course.classrooms
      for teacher, index in classroom.teachers
        classroom.teachers[index] = teacher._id
    course.updated or= []
    course.updated.push new Date().getTime()
    course.$update ->
      $location.path "courses/" + course._id

  $scope.find = (query) ->
    Courses.query query, (courses) ->
      $scope.courses = courses

  $scope.findOne = ->
    Courses.get
      courseId: $routeParams.courseId
    , (course) ->
      for classroom, index in course.classrooms
        course.classrooms[index].startDate = new Date(classroom.startDate)
        course.classrooms[index].endDate = new Date(classroom.endDate)
      $scope.course = course

  $scope.editContent = (index) ->
    $scope.edit.content = angular.copy($scope.course.contents[index])
    $scope.edit.content.index = index

  $scope.createOrUpdateContent = ->
    if $scope.edit.content.index?
      $scope.course.contents[$scope.edit.content.index] = angular.copy($scope.edit.content)
    else
      $scope.edit.content.creator = Global.user._id
      $scope.course.contents.push angular.copy($scope.edit.content)
    $scope.edit.content = undefined
    return false

  $scope.editClassroom = (index) ->
    $scope.edit.classroom = angular.copy($scope.course.classrooms[index])
    $scope.edit.classroom.index = index

  $scope.createOrUpdateClassroom = ->
    if $scope.edit.classroom.index?
      $scope.course.classrooms[$scope.edit.classroom.index] = angular.copy($scope.edit.classroom)
    else
      $scope.edit.classroom.creator = Global.user._id
      $scope.course.classrooms.push angular.copy($scope.edit.classroom)
    $scope.edit.classroom = undefined
    return false

  $scope.findTeachers = ->
    Users.query {'permissions.teach': true}, (teachers) ->
      $scope.teachers = teachers

  $scope.findStudents = ->
    Users.query {'permissions.study': true}, (students) ->
      $scope.students = students

  $scope.addTeacher = (teacher) ->
    console.log teacher
    $scope.edit.classroom.teachers or= []
    $scope.edit.classroom.teachers.push teacher
    $scope.edit.classroom.teacherUsername = ''

  $scope.existingTeacher = (added) ->
    not _.find $scope.edit.classroom.teachers, (existing) -> existing._id is added._id

  $scope.addStudent = (student) ->
    console.log student
    $scope.edit.classroom.students or= []
    $scope.edit.classroom.students.push student
    $scope.edit.classroom.studentUsername = ''

  $scope.existingStudent = (added) ->
    not (_.find $scope.edit.classroom.students, (existing) -> existing._id is added._id) and
      not (_.find $scope.edit.classroom.teachers, (existing) -> existing._id is added._id)

  if $routeParams.courseId
    $scope.findOne()
  else
    $scope.find()

  # If we are editing, we need to show all users
  if /(edit)|(create)/.test($location.path()) and Global.user.permissions.manage
    $scope.findTeachers()
    $scope.findStudents()