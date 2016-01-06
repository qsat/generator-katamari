'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var mkdirp = require('mkdirp');


var KatamariGenerator = yeoman.Base.extend({
  init: function () {
    this.pkg = require('../package.json');

    this.on('end', () => {

      if (!this.options['skip-install']) {

        this.log("exec dtsm install...");
        this.spawnCommandSync("dtsm", ["install"]);
        this.log("exec npm install...");
        this.spawnCommandSync("npm", ["install"]);
        // this.installDependencies();

      }

      this.log("\n To run server, execute 'npm start'");

    });
  },

  askFor: function () {
    var done = this.async();

    // replace it with a short and sweet description of your generator
    this.log('You\'re using the Katamari generator.');

    var prompts = [{
      name: 'projectName',
      message: "Please enter your project's name.",
    }];

    this.prompt(prompts, function (props) {
      this.projectName = props.projectName;

      done();
    }.bind(this));
  },

  app: function () {
    mkdirp('dist');
    mkdirp('src');
    mkdirp('src/images');

    this.template('package.json', 'package.json');
    this.template('gulpfile.coffee', 'gulpfile.coffee');
    this.template('tsconfig.json', 'tsconfig.json');
    this.template('dtsm.json', 'dtsm.json');

    this.template('src/index.jade', 'src/index.jade');

    this.copy('src/index.tsx', 'src/index.tsx');

    this.copy('src/images/sprite.styl', 'src/images/sprite.styl');
    this.copy('src/images/sprite.png', 'src/images/sprite.png');
    this.copy('src/index.styl', 'src/index.styl');

    this.copy('src/_import.d.ts', 'src/_import.d.ts');
    this.copy('src/_import.js', 'src/_import.js');

    this.copy('gitignore', '.gitignore');
  },

  projectfiles: function () {
    this.copy('editorconfig', '.editorconfig');
  }
});

module.exports = KatamariGenerator;
