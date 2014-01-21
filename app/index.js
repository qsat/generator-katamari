'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');


var KatamariGenerator = module.exports = function KatamariGenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    this.installDependencies({ skipInstall: options['skip-install'] });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(KatamariGenerator, yeoman.generators.Base);

KatamariGenerator.prototype.askFor = function askFor() {
  var cb = this.async();

  // have Yeoman greet the user.
  console.log(this.yeoman);

  var prompts = [{
    name: 'projectName',
    message: "Please enter your project's name.",
  }];

  this.prompt(prompts, function (props) {
    this.projectName = props.projectName;

    cb();
  }.bind(this));
};

KatamariGenerator.prototype.app = function app() {
  this.mkdir('htdocs');
  this.mkdir('src');
  this.mkdir('src/shared');
  this.mkdir('src/shared/styles');
  this.mkdir('src/shared/scripts');
  this.mkdir('src/shared/scripts/lib');

  this.template('Gruntfile.coffee', 'Gruntfile.coffee');

  this.template('_package.json', 'package.json');
  this.template('_bower.json', 'bower.json');
  this.template('htdocs/index.html', 'htdocs/index.html');
  this.copy('src/shared/styles/style.scss');
  this.copy('src/shared/styles/_mixin.scss');
  this.copy('src/shared/styles/_reset.scss');
  this.copy('src/shared/styles/_utils.sass');
  this.copy('bowerrc', '.bowerrc');
  this.copy('gitignore', '.gitignore');
  this.copy('ftppass', '.ftppass');
};

KatamariGenerator.prototype.projectfiles = function projectfiles() {
  this.copy('editorconfig', '.editorconfig');
  this.copy('jshintrc', '.jshintrc');
};
