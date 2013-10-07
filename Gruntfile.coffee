module.exports = (grunt) ->

  pkg = grunt.file.readJSON('package.json')

  # Project Configuration
  grunt.initConfig
    coffee:
      main:
        expand: true,
        src: ['**/*.coffee', '!Gruntfile.coffee', '!node_modules/**/*']
        ext: '.js'

    less:
      main:
        files:
          "public/style/main.css": "public/style/main.less"

  #Load NPM tasks
  grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-'

  grunt.registerTask "dist", ["coffee", "less"]
