_ = require 'underscore'
ts = require 'gulp-typescript'
gulp = require 'gulp'
jade = require 'gulp-jade'
through2 = require 'through2'
stylus = require 'gulp-stylus'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
changed = require 'gulp-changed'
imagemin = require 'gulp-imagemin'
browserify = require 'browserify'
browserSync = require 'browser-sync'
spritesmith = require 'gulp.spritesmith'
plumber = require 'gulp-plumber'
watchify = require 'watchify'
babelify = require 'babelify'
pngcrush = require 'imagemin-pngcrush'
pngquant = require 'imagemin-pngquant'

expand = (ext)-> rename (path) -> _.tap path, (p) -> p.extname = ".#{ext}"
notify = (filename) -> console.log(filename)
reload = _.debounce (-> browserSync.reload once:true, reloadDebounce:100 ), 2000

DEST = "./dist"
SRC = "./src"

# ファイルタイプごとに無視するファイルなどを設定
paths =
  ts: [
    "#{SRC}/**/*.ts"
    "#{SRC}/**/*.tsx"
  ]
  js: [
    "#{SRC}/**/*.js"
    "#{SRC}/**/*.jsx"
    "!#{SRC}/**/_**/*.jsx"
    "!#{SRC}/**/_*.jsx"
    "!#{SRC}/**/_**/*.js"
    "!#{SRC}/**/_**/**/*.js"
    "!#{SRC}/**/_*.js" ]
  css: ["#{SRC}/**/*.styl", "!#{SRC}/**/sprite*.styl", "!#{SRC}/**/_**/*.styl", "!#{SRC}/**/_*.styl"]
  img: ["#{SRC}/**/*.{png, jpg, gif}", "!#{SRC}/**/sprite/**/*.png"]
  html: ["#{SRC}/**/*.jade", "!#{SRC}/**/_**/*.jade", "!#{SRC}/**/_*.jade"]
  reload: ["#{DEST}/**/*", "!#{DEST}/**/*.css"]
  sprite: "#{SRC}/**/sprite/**/*.png"

tsbundle = null
tsProject = ts.createProject './tsconfig.json',
  typescript: require 'typescript'

gulp.task 'ts', ->

  gulp.src paths.ts
    .pipe plumber()
    .pipe ts tsProject
    .js
    .pipe gulp.dest SRC

bundleBabel = (watch = true)->
  gulp.src paths.js
    .pipe plumber()
    #.pipe bundler()
    .pipe through2.obj (file, enc, next) ->
      bd = browserify _.extend {}, watchify.args, fullPaths: false
      if watch then bd = watchify bd
      bd.add file.path
      bd.on 'bundle', (e)->
        notify 'Bundle target: '+file.path.split("/src/").slice(-1).join("/")
      .on 'log', (e)->
        notify( "    "+e )
        notify ""
      bd.bundle (err, res) ->
        #assumes file.contents is a Buffer
        file.contents = res if res
        next null, file
      .on 'error', (e)->
        notify e.name
        notify e.message
        notify ""

    .pipe expand "js"
    .pipe uglify()
    .pipe gulp.dest DEST


gulp.task "babel", -> bundleBabel()
gulp.task "ts-babel", ['ts'], -> bundleBabel()

gulp.task "buildjs", ['ts'], -> bundleBabel( false )

# FW for Stylus
nib = require 'nib'

gulp.task "stylus", ["sprite"], ->
  gulp.src paths.css
    .pipe plumber()
    .pipe changed DEST
    .pipe stylus use: nib(), errors: true
    .pipe expand "css"
    .pipe gulp.dest DEST
    .pipe browserSync.reload stream:true

gulp.task "jade", ->
  gulp.src paths.html
    .pipe plumber()
    .pipe jade pretty: true
    .pipe expand "html"
    .pipe gulp.dest DEST

gulp.task "imagemin", ->
  gulp.src paths.img
    .pipe imagemin
      use: [pngcrush(), pngquant()]
    .pipe gulp.dest DEST

gulp.task "browser-sync", ->
  browserSync
    server: baseDir: DEST
    #startPath: 'a.html'

gulp.task "sprite", ->
  a = gulp.src paths.sprite
    .pipe plumber()
    .pipe spritesmith
      imgName: 'images/sprite.png'
      cssName: 'images/sprite.styl'
      imgPath: 'images/sprite.png'
      algorithm: 'binary-tree'
      cssFormat: 'stylus'
      padding: 4

  a.img.pipe gulp.dest SRC
  a.img.pipe gulp.dest DEST
  a.css.pipe gulp.dest SRC

gulp.task 'watch', ->
  gulp.watch paths.ts, debounceDelay: 100, ['ts']
  gulp.watch paths.js.slice(0,2),readDelay:300,debounceDelay:100,['babel']
  gulp.watch paths.css , ['stylus']
  gulp.watch paths.html, ['jade']
  gulp.watch paths.reload, debounceDelay:100, reload 

gulp.task "default",['jade','stylus','ts-babel','browser-sync','watch']
gulp.task "build",['jade','stylus','buildjs']
