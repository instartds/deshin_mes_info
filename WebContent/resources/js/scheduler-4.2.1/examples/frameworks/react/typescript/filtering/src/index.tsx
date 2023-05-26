// core-js polyfills are required for IE11 compatibility. If you don't use IE then delete them
import "core-js/stable";

import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

ReactDOM.render(<App />, document.getElementById('container'));

