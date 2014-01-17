'use strict'

module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-styleguide'
  grunt.loadNpmTasks 'grunt-este-watch'
  grunt.loadNpmTasks 'grunt-browserify'
 
  grunt.initConfig
 
    pkg:
      grunt.file.readJSON 'package.json'

    esteWatch:
      options:
        dirs: ["src/**"]

      coffee: (filepath) -> 'coffee'
      scss:   (filepath) -> 'compass'
      sass:   (filepath) -> 'compass'
      css:    (filepath) -> 'styleguide'
      html:   (filepath) -> 'copy:src'

    connect:
      server:
        options:
          port: 8008
          hostname: '0.0.0.0'
          base: 'htdocs'

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
        filter: 'isFile'
      src:
        expand: true
        flatten: false
        cwd: 'src'
        src: ['**/*', '!**/*.coffee', '!**/*.scss']
        dest: 'htdocs/'

    coffee:
      compile:
        expand: true
        flatten: false #src内のディレクトリをキープして出力
        cwd: 'src'
        src: '**/*.coffee'
        dest: 'htdocs/'
        ext: '.js'

    jshint:
      htdocs: [
        'htdocs/**/*.js',
        '!htdocs/**/*.min.js'
      ]

    uglify:
      options:
        mangle: true # true にすると難読化がかかる。false だと関数や変数の名前はそのまま
      shared:
        options: # sourcemap : https://github.com/gruntjs/grunt-contrib-uglify/issues/71
          banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - */' 
        files:
          'htdocs/shared/js/script.min.js': [
            'htdocs/shared/js/libs/jquery.js'
            'htdocs/shared/js/observer.js'
          ]

    # https://github.com/gruntjs/grunt-contrib-compass
    compass:
      src:
        options:
          outputStyle: 'expanded'
          noLineComments: true
          debugInfo: false
          sassDir: 'src/'
          cssDir: 'htdocs/'
          importPath: 'config/scss'

    cssmin:
      src:
        expand: true
        flatten: false
        cwd: 'htodcs/'
        src: ['**/*.css', '!**/*.min.css']
        dest: 'htodcs/'
        ext: '.css'
    
    browserify:
      dist:
        src: 'htdocs/shared/scripts/app.js'
        dest: 'htdocs/shared/scripts/build.js'
        options:
          shim:
            jquery:
              path: 'htdocs/shared/scripts/lib/jquery.min.js'
              exports: '$'
            underscore:
              path: 'htdocs/shared/scripts/lib/underscore-min.js'
              exports: '_'
            backbone:
              path: 'htdocs/shared/scripts/lib/backbone-min.js'
              exports: 'Backbone'

    # concat:
    #   dist:
    #     files:
    #       'htodcs/shared/css/style.css': [
    #         'htodcs/shared/css/all.css',
    #         'htodcs/shared/css/module.css',
    #         'htodcs/shared/css/theme-responsive.css',
    #         'htodcs/shared/css/theme.css'
    #       ]

    # clean:
    #   dist: [
    #         'htodcs/shared/css/all.css',
    #         'htodcs/shared/css/module.css',
    #         'htodcs/shared/css/theme-responsive.css',
    #         'htodcs/shared/css/theme.css'
    #       ]

  grunt.registerTask 'init', ['copy:bower']
  grunt.registerTask 'default', ['esteWatch']
  grunt.registerTask 'lint', ['jshint']
  grunt.registerTask 'build', ['uglify', 'cssmin']
  grunt.registerTask 'test', ['browserify']
