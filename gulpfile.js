const gulp = require('gulp');
const config = require('./tasks/config');

gulp.task('dist', function() {
  const expath = require('path');
  const abe = require('amp-by-example');

  abe.generatePreview({
    src: expath.join(__dirname, 'samples/src'),       // root folder containing the samples
    destRoot: expath.join(__dirname, config.destDir), // target folder for generated embeds 
    destDir: `/${config.repoName}/samples`,           // optional sub dir
    host: config.host,                                // from where the embeds are to be served
  });

  gulp.src('samples/src/images/*')
    .pipe(gulp.dest(`./${config.destDir}/${config.repoName}/samples/images/`));
});

gulp.task('lint-css', function lintCssTask() {
  const gulpStylelint = require('gulp-stylelint');

  return gulp
    .src('samples/src/**/*.css')
    .pipe(gulpStylelint({
      reporters: [
        {formatter: 'string', console: true}
      ]
    }));
});
