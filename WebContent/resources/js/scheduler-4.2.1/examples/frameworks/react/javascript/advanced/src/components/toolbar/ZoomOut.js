/**
 * ZoomOut button. Dispatches Redux action ZOOM_OU
 */
// libraries
import React, { useRef, useEffect } from 'react';
// we import scheduler.umd for IE11 compatibility only. If you don't use IE import:
// import { WidgetHelper } from '@bryntum/scheduler';
import { WidgetHelper } from '@bryntum/scheduler/scheduler.umd';
import { connect } from 'react-redux';
import { useTranslation } from 'react-i18next';

// our stuff
import { zoomOut } from '../../redux/actions/actions.js';

const Button = props => {
    // refs and t function
    const elRef = useRef(),
        buttonRef = useRef(),
        { t } = useTranslation();

    // Bryntum button instance
    const button = (buttonRef.current =
        buttonRef.current ||
        WidgetHelper.createWidget({
            type: 'button',
            icon: 'b-icon-search-minus',
            tooltip: t('zoomOut'),
            onAction: props.onZoomOut
        }));

    // runs on mounting, renders the button
    useEffect(() => {
        button.appendTo = props.container || elRef.current;
        button.render();

        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    // runs on locale change
    useEffect(() => {
        button.tooltip = t('zoomOut');

        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [props.locale]);

    return props.container ? null : <div ref={elRef}></div>;
};

// maps Redux state to this button props
const mapStateToProps = state => {
    return {
        locale: state.locale
    };
};

// maps Redux dispatch method to props
const mapDispatchToProps = (dispatch, props) => {
    return {
        onZoomOut: () => {
            dispatch(zoomOut());
        }
    };
};

// connects to Redux and exports the button
export default connect(mapStateToProps, mapDispatchToProps)(Button);
