/**
 * Application toolbar
 *
 * It is implemented as a functional component using React hooks that
 * were introduced in React 16.8.0. If you cannot upgrade to that or
 * later version of React then you must convert this component to class.
 */
// libraries
import React from 'react';
import { connect } from 'react-redux';

// our stuff (buttons)
import LocaleCombo from './LocaleCombo.js';
import Reload from './Reload.js';
import ZoomIn from './ZoomIn.js';
import ZoomOut from './ZoomOut.js';

const Toolbar = props => {
    return (
        <div className="demo-toolbar align-right">
            <LocaleCombo />
            <Reload />
            <ZoomOut />
            <ZoomIn />
        </div>
    );
};

// maps Redux state to this button props
const mapStateToProps = state => {
    return {
        locale: state.locale
    };
};

// connects to Redux and exports the button
export default connect(mapStateToProps)(Toolbar);
