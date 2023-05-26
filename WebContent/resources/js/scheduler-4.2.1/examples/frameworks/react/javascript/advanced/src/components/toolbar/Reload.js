/**
 * Reload button. Dispatches Redux action ZOOM_IN
 */
// libraries
import React, { useRef, useEffect } from 'react';
// we import scheduler.umd for IE11 compatibility only. If you don't use IE import:
// import { WidgetHelper } from '@bryntum/scheduler';
import { WidgetHelper } from '@bryntum/scheduler/scheduler.umd';
import { connect } from 'react-redux';
import { useTranslation } from 'react-i18next';

// our stuff (action creator)
import { reloadData } from '../../redux/actions/actions.js';

const Button = props => {
    // refs and t function
    const elRef = useRef(),
        buttonRef = useRef(),
        { t } = useTranslation();

    const button = (buttonRef.current =
        buttonRef.current ||
        WidgetHelper.createWidget({
            type: 'button',
            id: 'reloadButton',
            icon: 'b-fa-sync',
            tooltip: t('reload'),
            dataUrl: null,
            onAction: () => {
                props.onReload(button.dataUrl);
            }
        }));

    // runs on mounting, renders the button
    useEffect(() => {
        button.appendTo = props.container || elRef.current;
        button.render();

        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    // runs on locale or dataUrl change
    useEffect(() => {
        // update tooltip
        button.tooltip = t('reload');

        // toggle dataUrl
        button.dataUrl =
            props.dataUrl === 'data/data.json' ? 'data/data1.json' : 'data/data.json';

        // generate invalid url from time to time
        if (Math.random() > 0.6) {
            button.dataUrl = 'invalid/url/index.html';
        }

        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [props.locale, props.dataUrl]);

    return props.container ? null : <div ref={elRef}></div>;
};

// maps Redux state to this button props
const mapStateToProps = state => {
    return {
        locale: state.locale,
        dataUrl: state.dataUrl
    };
};

// maps Redux dispatch method to props
const mapDispatchToProps = (dispatch, props) => {
    return {
        onReload: dataUrl => {
            dispatch(reloadData(dataUrl));
        }
    };
};

// connects to Redux and exports the button
export default connect(mapStateToProps, mapDispatchToProps)(Button);
