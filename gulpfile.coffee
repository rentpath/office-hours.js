
gulp = require("gulp")
coffee = require("gulp-coffee")
gutil = require("gulp-util")
sourcemaps = require("gulp-sourcemaps")
del = require("del")

gulp.task "clean-dist", (cb) ->
  del "dist/", cb

gulp.task "build", ["clean-dist"], ->
  gulp.src(["src/coffeescript/**/*.coffee"])
      .pipe(coffee(bare: true).on("error", gutil.log))
      .pipe(gulp.dest("build/"))

gulp.task "default", ->
  gulp.run "build"

  gulp.watch "src/coffeescript/**/*.coffee", (event) ->
    gulp.run "build"
