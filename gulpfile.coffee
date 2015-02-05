gulp = require("gulp")
sourcemaps = require("gulp-sourcemaps")
rename = require("gulp-rename")
sass = require("gulp-sass")
autoprefixer = require("gulp-autoprefixer")
minify_css = require("gulp-minify-css")
browserify = require("gulp-browserify")
uglify = require("gulp-uglify")
concat = require("gulp-concat")
image_min = require("gulp-imagemin")
cache = require("gulp-cache")
svg_min = require "gulp-svgmin"
# livereload = require("gulp-livereload")

# Styles
gulp.task "styles", ->
  gulp.src "src/stylesheets/main.scss"
    .pipe sass()
    .pipe autoprefixer("last 2 version", "safari 5", "ie 8", "ie 9", "opera 12.1", "ios 6", "android 4")
    .pipe gulp.dest("assets/css")
    .pipe rename(suffix: ".min")
    .pipe minify_css()
    # .pipe(livereload(server))
    .pipe gulp.dest("assets/css")
    .pipe notify(message: "Styles task complete")

# Scripts
gulp.task "scripts", ->
  gulp.src "src/javascripts/index.coffee", { read: false }
    .pipe browserify(
      transform: ["coffeeify"]
      extensions: [".coffee"])
    .pipe concat("index.js")
    .pipe rename(suffix: ".min")
    .pipe uglify()
    # .pipe(livereload(server)) #necessary?
    .pipe gulp.dest("assets/js")
    .pipe notify(message: "Scripts task complete")

# Images
gulp.task "images", ->
  gulp.src "src/images/**/*"
    .pipe cache( image_min(optimizationLevel: 3, progressive: true, interlaced: true) )
    .pipe gulp.dest("assets/images")
    .pipe notify(message: "Images task complete")

# Minify your SVG.
gulp.task "svg", ->
  gulp.src "src/vectors/*.svg"
    .pipe svg_min()
    .pipe gulp.dest "assets/vectors"

gulp.task 'default', ['styles', 'scripts', 'images', 'svg']
