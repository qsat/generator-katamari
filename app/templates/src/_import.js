var $ = require( 'jquery' );
var Promise = require( 'bluebird' );

window.$ = window.jQuery = $;
window.Promise = Promise;

require("jquery.easing");

var Import = (function () {
  function Import() {
    // console.log( window.jQuery );
  }
  return Import;
})();

exports.Import = Import;
