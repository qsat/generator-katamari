'use strict'

module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-autoprefixer'
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
  grunt.loadNpmTasks 'grunt-copy-changed'
  grunt.loadNpmTasks 'grunt-este-watch'
  grunt.loadNpmTasks 'grunt-requirejs'
  grunt.loadNpmTasks 'grunt-ftp-deploy'
  grunt.loadNpmTasks 'grunt-styleguide'
 
  grunt.initConfig
 
    pkg:
      grunt.file.readJSON 'package.json'

    copyChanged:
      options:
        watchTask: true
        checksum: true
        dirs: ['htdocs/**/']

    'ftp-deploy':
      dev:
        auth:
          host: "example.com"
          port: 21
          authKey: "key1" ## SEE .ftppass
        src: "_modified/htdocs"
        dest: "/test_dir"
        server_sep: '/'
        exclusions: ["_modified/htdocs/**/.DS_Store"]

    esteWatch:
      options:
        dirs: ["src/**"]
        livereload:
          enabled: false
          port: 35729
          extensions: ['js', 'css']

      coffee: (filepath) -> 'coffee'
      scss:   (filepath) -> 'compass'
      sass:   (filepath) -> 'compass'
      jade:   (filepath) -> 'jade'

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
        cwd: 'bower_components/'
        src: ['*/*.js', '*/*min.js', '*/*-min.js', '*/*.map']
        dest: 'htdocs/shared/scripts/lib/'

    coffee:
      compile:
        expand: true
        flatten: false
        cwd: 'src'
        src: '**/*.coffee'
        dest: 'htdocs/'
        ext: '.js'

    imagemin:
      compile:
        expand: true
        dest: 'htdocs'
        src: [ "**/*.png", "**/*.jpg", "**/*.gif" ]
        cwd: "src"
        options:
          optimazationLevel: 3

    autoprefixer:
      options:
        browsers: ['ios >= 5', 'android >= 2.3', 'ie 8', 'ie 9', 'firefox 17', 'opera 12.1']
      dist:
        src: 'htdocs/shared/styles/**/*'

    compass:
      src:
        options:
          outputStyle: 'expanded'
          noLineComments: true
          debugInfo: false
          sassDir: 'src/'
          cssDir: 'htdocs/'

    testem:
      set1:
        src:[
          'test/**/*.js'
        ]
        options:
          parallel: 4
          framework: 'mocha'
          #launch_in_ci: ['Safari', 'Chrome', 'Firefox', 'PhantomJS']
          launch_in_ci: ['Safari']
          test_page: 'test/runner.mustache'
          src_files: ['test/js/**/*.js']
          routes:
            "/vendor": "bower_components"
            "/src"   : "htdocs/shared/scripts"

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


  grunt.registerTask 'default', ['copy:bower', 'browser_sync', 'copyChanged', 'esteWatch']
  grunt.registerTask 'dev_deploy', ['ftp-deploy:dev']
