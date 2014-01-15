module.exports = (grunt) ->

  pkg = grunt.file.readJSON('package.json')

  # Project Configuration
  grunt.initConfig

    watch:
      test:
        files: ['test/**', 'app/**']
        tasks: ['mochaTest']

    mochaTest:
      main:
        options:
          reporter: 'spec'
        src: ['test/**/*.coffee']

    nodemon:
      main:
        options:
          file: 'server.coffee'
          ignoredFiles: ['node_modules/**', '.idea/**', 'public/**', '.git/**']
          watchedFolders: ['app', 'config']
          debug: true
          delayTime: 1

  #Load NPM tasks
  grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-'

  grunt.registerTask "test-env", -> process.env.NODE_ENV = 'test'
  grunt.registerTask "default", ["nodemon"]
  grunt.registerTask "test", ["test-env", "mochaTest", "watch:test"]