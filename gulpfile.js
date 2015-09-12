var gulp = require("gulp");
var run = require("gulp-run");
var zip = require("gulp-zip");
var del = require("del");
var runSequence = require('run-sequence');

gulp.task('clean',function(cb) {
    del('dist',cb);
});

gulp.task('neko', function(cb) {
   run('haxe resources/hxml/neko.hxml').exec("",cb);
});

gulp.task('js', function(cb) {
   run('haxe resources/hxml/js.hxml').exec("",cb);
});

gulp.task('test', function(cb){
  return runSequence(['js','neko'],cb);
});

gulp.task('docs', function(cb) {
      del('dist', function(){
        run('mkdir dist').exec(function(){
          run('haxe resources/hxml/doc.hxml').exec(function(){
            run('haxelib run dox -i build -in iv247 -o dist/doc').exec(cb)
          });
      });
  });
});

gulp.task('archive', function(){
	return gulp.src('src/**/*')
		.pipe(zip('archive.zip'))
		.pipe(gulp.dest('dist'));
});

gulp.task('build',function(cb) {
	return runSequence(
		'clean',
		['js','neko'],
		['archive','docs'],
		cb
    );
});

gulp.task('local-install',['build'], function(cb){
    run('haxelib local dist/archive.zip').exec("",cb);
});
