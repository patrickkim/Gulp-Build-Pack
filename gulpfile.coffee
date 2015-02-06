gulp = require("gulp")
notify= require("gulp-notify")
sourcemaps = require("gulp-sourcemaps")
rename = require("gulp-rename")
sass = require("gulp-sass")
autoprefixer = require("gulp-autoprefixer")
minify_css = require("gulp-minify-css")
browserify = require("gulp-browserify")
uglify = require("gulp-uglify")
define_module = require("gulp-define-module")
concat = require("gulp-concat")
image_min = require("gulp-imagemin")
cache = require("gulp-cache")
svg_min = require("gulp-svgmin")
rimraf = require "gulp-rimraf"
# watch = require("gulp-watch")
# server = require("live-server")

# Refresh everything
gulp.task "clean_styles", ->
  gulp.src "dev/assets/css", { read: false }
    .pipe rimraf("dev/assets/css")
    .pipe notify(message: "Clean up css")

gulp.task "clean_scripts", ->
  gulp.src "dev/assets/js", { read: false }
    .pipe rimraf("dev/assets/js")
    .pipe notify(message: "Clean up js")

#HTML
gulp.task "prep_html", ->
  gulp.src "src/html/*.html"
    .pipe gulp.dest("dev")


# Styles
gulp.task "styles", ["clean_styles"],  ->
  gulp.src "src/stylesheets/development.scss"
    .pipe sourcemaps.init()
    .pipe sass()
    .pipe sourcemaps.write()
    .pipe autoprefixer("last 2 version", "safari 5", "ie 8", "ie 9", "opera 12.1", "ios 6", "android 4")
    .pipe rename("main.css")
    .pipe gulp.dest("dev/assets/css")
    .pipe notify(message: "Styles task complete")


#vendor scripts
gulp.task "vendor_scripts", ->
  gulp.src "src/javascripts/vendor/*.js"
    .pipe(concat("vendor.js"))
    .pipe gulp.dest("dev/assets/js")

# Scripts
gulp.task "scripts", ["clean_scripts"], ->
  gulp.src "src/javascripts/index.coffee", { read: false }
    .pipe browserify(
      # debug: true
      transform: ["coffeeify", "hbsfy"]
      extensions: [".coffee", ".hbs"]
      requires: ["backbone", "underscore"])
    .pipe concat("bundle.js")
    .pipe gulp.dest("dev/assets/js")
    .pipe notify(message: "Scripts task complete")

# Images
gulp.task "images", ->
  gulp.src "src/images/**/*"
    .pipe cache( image_min(optimizationLevel: 3, progressive: true, interlaced: true) )
    .pipe gulp.dest("dev/assets/images")
    .pipe notify(message: "Images smushed!")

# Minify your SVG.
gulp.task "svg", ->
  gulp.src "src/vectors/*.svg"
    .pipe svg_min()
    .pipe gulp.dest "dev/assets/vectors"
    .pipe notify(message: "SVG smushed!")

# Build everything and smush it!
gulp.task "build", ->
  gulp.src "src/stylesheets/production.scss"
    .pipe sass()
    .pipe autoprefixer("last 2 version", "safari 5", "ie 8", "ie 9", "opera 12.1", "ios 6", "android 4")
    .pipe rename("main.min.css")
    .pipe minify_css()
    .pipe gulp.dest("release/assets")
    .pipe notify(message: "Styles build complete")

  gulp.src "src/html/*.html"
    .pipe gulp.dest("release")

  gulp.src "src/javascripts/index.coffee", { read: false }
    .pipe browserify(
      transform: ["coffeeify", "hbsfy"]
      extensions: [".coffee", ".hbs"])
    .pipe concat("bundle.js")
    .pipe rename(suffix: ".min")
    .pipe uglify()
    .pipe gulp.dest("release/assets")
    .pipe notify(message: "JS smushed!")

  gulp.src "src/vectors/*.svg"
    .pipe svg_min()
    .pipe gulp.dest "release/assets"
    .pipe notify(message: "SVG smush complete")

  gulp.src "src/images/**/*"
    .pipe cache( image_min(optimizationLevel: 3, progressive: true, interlaced: true) )
    .pipe gulp.dest("release/assets")
    .pipe notify(message: "Images smushed!")

# Watch
gulp.task 'watch', ->

  server.start 8080, "./dev", true

  # Watch .scss files
  # watch 'src/styles/**/*.scss', (event) ->
  #   console.log 'File ' + event.path + ' was ' + event.type + ', running tasks...'
  #   gulp.run 'styles'

  # # Watch image files
  # gulp.watch 'src/images/**/*', (event) ->
  #   console.log 'File ' + event.path + ' was ' + event.type + ', running tasks...'
  #   gulp.run 'images'


gulp.task 'default', ['prep_html', 'styles', 'scripts', 'images', 'svg']
