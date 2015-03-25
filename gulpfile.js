var gulp = require("gulp");
var run = require("gulp-run");
var zip = require("gulp-zip");
var del = require("del");
var runSequence = require('run-sequence');

gulp.task('neko', function(cb) {
   run('haxe build/neko.hxml').exec("",cb);    
});

gulp.task('js', function(cb) {
   run('haxe build/js.hxml').exec();    
   run('phantomjs build/tests.phantom.js').exec("",cb);
});

gulp.task('archive', function(){
	return gulp.src('src/**/*')
		.pipe(zip('archive.zip'))
		.pipe(gulp.dest('dist'));
});

gulp.task('test-archive', function(cb){		        
	 run('haxelib local dist/archive.zip').exec("",cb); 
});

gulp.task('build',function(cb) {
	return runSequence(
		'clean',
		['js','neko'],
		'archive',
		'test-archive',
		cb);
});

gulp.task('clean',function(cb) {
	del('dist',cb);
});