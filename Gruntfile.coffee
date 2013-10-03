module.exports = (grunt) ->

  pkg = grunt.file.readJSON('package.json')

  # Project Configuration
  grunt.initConfig
    watch:
      coffee:
        files: ["public/script/**/*.coffee", "app/**/*.coffee"]
        tasks: ["coffee"]

      less:
        files: ["public/style/**/*.less"]
        tasks: ["less"]

      jade:
        files: ["app/views/**"]
        options:
          livereload: true

      js:
        files: ["public/script/**/*.js", "app/**/*.js"]
        options:
          livereload: true

      html:
        files: ["public/views/**"]
        options:
          livereload: true

      css:
        files: ["public/style/**/*.css"]
        options:
          livereload: true

    coffee:
      main:
        expand: true,
        src: ['**/*.coffee', '!Gruntfile.coffee', '!node_modules/**/*']
        ext: '.js'

    less:
      main:
        files:
          "public/style/main.css": "public/style/main.less"

    nodemon:
      dev:
        options:
          file: "server.js"
          args: []
          ignoredFiles: ["README.md", "node_modules/**", ".DS_Store"]
          watchedExtensions: ["js"]
          watchedFolders: ["app", "config"]
          debug: true
          delayTime: 1
          env:
            PORT: 3000

          cwd: __dirname

    concurrent:
      tasks: ["nodemon", "watch"]
      options:
        logConcurrentOutput: true

    mochaTest:
      options:
        reporter: "spec"

      src: ["test/**/*.js"]

  #Load NPM tasks
  grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-'

  #Making grunt default to force in order not to break the project.
  grunt.option "force", true

  grunt.registerTask "dist", ["coffee", "less"]
  	
  #Default task(s).
  grunt.registerTask "default", ["coffee", "less", "concurrent"]

  #Test task.
  grunt.registerTask "test", ["mochaTest"]