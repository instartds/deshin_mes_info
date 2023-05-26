/**
 * React index file
 */

// polyfills (only required for IE11. If you don't use IE, delete them)
import 'core-js/stable';

// libraries
import React, { Suspense } from 'react';
import ReactDOM from 'react-dom';
import App from './App.js';

// for bundling
import './i18n.js';

import Loading from './components/Loading';

ReactDOM.render(
    <Suspense fallback={<Loading/>}>
        <App/>
    </Suspense>,
    document.getElementById('container')
);
