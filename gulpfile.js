var gulp = require("gulp");
var run = require("gulp-run");
var zip = require("gulp-zip");

gulp.task('test', function() {
  	run('haxe build.hxml').exec();
});

gulp.task('build',function() {
	return gulp.src('src/**/*')
			.pipe(zip('archive.zip'))
			.pipe(gulp.dest('dist'));
});