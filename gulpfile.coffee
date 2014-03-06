gulp = require 'gulp'
nodemon = require 'gulp-nodemon'
mocha = require 'gulp-mocha'
watch = require 'gulp-watch'
livereload = require 'gulp-livereload'
server = livereload()

nodemonIgnore = ["gulpfile.coffee", "public/*", "test/*", ".git/*", ".idea/*", "node_modules/*"]

gulp.task "test", ->
  watch {glob: "test/**/*.coffee"}, (files) ->
    files.pipe(mocha(reporter: 'spec', compilers: "coffee:coffee-script/register").on('error', -> @emit 'end'))

gulp.task "nodemon", ["watch"], ->
  nodemon script: "app.coffee", ext: "coffee dust", ignore: nodemonIgnore

gulp.task "watch", ->
  gulp.watch("public/**").on "change", (file) ->
    server.changed file.path

gulp.task "default", ["nodemon"]