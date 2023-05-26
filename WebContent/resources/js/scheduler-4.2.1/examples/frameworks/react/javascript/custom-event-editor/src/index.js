/**
 * React index file
 */
// polyfills (only required for IE11. If you don't use IE, delete them)
import 'core-js/stable';

// This import is used for IE11 compatibility
import 'core-js/stable';

import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

ReactDOM.render(<App />, document.getElementById('container'));
