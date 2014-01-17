'use strict'

module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-browser-sync'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-testem'
  grunt.loadNpmTasks 'grunt-este-watch'
  grunt.loadNpmTasks 'grunt-requirejs'
  grunt.loadNpmTasks 'grunt-styleguide'
 
  grunt.initConfig
 
    pkg:
      grunt.file.readJSON 'package.json'

    esteWatch:
      options:
        #dirs: ["src/**", "htdocs/**"]
        dirs: ["src/**"]
        livereload:
          enabled: false
          port: 35729
          extensions: ['js', 'css']

      coffee: (filepath) -> 'coffee'
      scss:   (filepath) -> 'compass'
      sass:   (filepath) -> 'compass'

    browser_sync:
      dev: 
        bsFiles: 
          src : ["htdocs/**/*"]
        options:
          watchTask: true
          ghostMode:
            clicks: true
            scroll: true
            links: true
            forms: true
          server:
            baseDir: "htdocs"

    connect:
      server:
        options:
          port: 8008
          hostname: '0.0.0.0'
          base: 'htdocs'
          livereload: true
          open: true

      styleguide:
        options:
          port: 8009
          hostname: '0.0.0.0'
          base: 'styleguide'

    styleguide:
      options:
        framework:
          name: 'styledocco'
      proj:
        options:
          name: 'Style Guide'
        files:
          'styleguide': ['src/**/*.scss', 'src/**/.*.sass']

    copy:
      bower:
        expand: true
        flatten: true
        cwd: 'bower_components/' # srcの固定。destは固定されない
        src: ['*/*min.js', '*/*-min.js', '*/*.map']
        dest: 'htdocs/shared/scripts/lib/'

    coffee:
      compile:
        expand: true
        flatten: false #src内のディレクトリをキープして出力
        cwd: 'src'
        src: '**/*.coffee'
        dest: 'htdocs/'
        ext: '.js'

    imagemin:
      compile:
        expand: true
        dest: '../images'
        src: [ "**/*.png", "**/*.jpg", "**/*.gif" ]
        cwd: "src/images/"
        options:
          optimazationLevel: 3

    compass:
      src:
        options:
          outputStyle: 'expanded'
          noLineComments: true
          debugInfo: false
          sassDir: 'src/'
          cssDir: 'htdocs/'
          importPath: 'config/scss'

    testem:
      set1:
        src:[
          'test/**/*.js'
        ]
        options:
          parallel: 4
          framework: 'mocha'
          launch_in_ci: ['Safari', 'Chrome', 'Firefox', 'PhantomJS']
          test_page: 'test/runner.mustache'
          src_files: ['test/js/**/*.js']
          routes:
            "/test"  : "../test"
            "/vendor": "../bower_components"
            "/src"   : "../htdocs/shared/scripts"

    requirejs:
      compile:
        options:
          almond: true
          baseUrl: 'htdocs/shared/scripts/'
          mainConfigFile: 'htdocs/shared/scripts/bootstrap.js'
          out: 'htdocs/shared/scripts/application.js'
          include: ['bootstrap_build']
          optimize: "uglify2"
          generateSourceMaps: true
          preserveLicenseComments: false
          useSourceUrl:true


  grunt.registerTask 'default', ['copy:bower', 'connect', 'esteWatch']
  grunt.registerTask 'sync', ['browser_sync', 'esteWatch']
