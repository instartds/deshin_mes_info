/**
 * Application index file – the app execution starts here
 *
 * auto-generated by create-react-app script
 */
// polyfills (only required for IE11. If you don't use IE, delete them)
import 'core-js/stable';

// react
import React, { Suspense } from 'react';
import ReactDOM from 'react-dom';

// redux
import { createStore, applyMiddleware, compose } from 'redux';
import { Provider } from 'react-redux';
import createSagaMiddleware from 'redux-saga';

// for bundling
import './i18n';

// our stuff
import Loading from './components/Loading'
import App from './App';
import reducer from './redux/reducers/reducer';
import logger from './middleware/logger';
import { watchSagas } from './redux/sagas/index';

// get redux dev tool in development mode
const devTool = process.env.NODE_ENV === 'development' ? window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ : null;
const composeEnhancers = devTool || compose;

const sagaMiddleware = createSagaMiddleware();

const store = createStore(reducer, composeEnhancers(applyMiddleware(logger, sagaMiddleware)));
// const store = createStore(reducer, applyMiddleware(logger, window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()));

sagaMiddleware.run(watchSagas);

ReactDOM.render(
    <Suspense fallback={<Loading />}>
        <Provider store={store}>
            <App />
        </Provider>
    </Suspense>,
    document.getElementById('container')
);
