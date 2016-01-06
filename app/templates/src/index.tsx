/// <reference path="../typings/bundle.d.ts" />
/// <reference path="./_import.d.ts" />

interface Window {
  THREE:any; T:any; $:any;
  addEventListener:any;
}

declare var window: Window;

import * as _ from 'lodash';

import * as React from 'react';
import * as ReactDOM from 'react-dom';
import * as ReactCSSTransitionGroup from 'react-addons-css-transition-group'
import * as thunk from 'redux-thunk';
import * as createLogger from 'redux-logger';


import * as Import from './_import'

Import;

export class Main {
  constructor(){
    console.log("Hello Katamari");
  }
}

new Main();
