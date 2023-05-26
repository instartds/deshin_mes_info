/**
 * Bryntum Scheduler
 */
import React, { useEffect, useRef } from 'react';
import { BryntumScheduler } from '@bryntum/scheduler-react';
import { schedulerConfig } from '../AppConfig.js';
import { connect } from 'react-redux';

const SchedulerComponent = props => {
    const schedulerRef = useRef();
    const firstRun = useRef(true);
    const { data, zoomLevel } = props;

    // handles zoom level change
    useEffect(() => {
        const scheduler = schedulerRef.current.instance;
        if (!firstRun.current) {
            const method = zoomLevel >= scheduler.zoomLevel ? 'zoomIn' : 'zoomOut';
            scheduler[method]();
        } else {
            firstRun.current = false;
        }
    }, [zoomLevel]);

    // handles data change
    useEffect(() => {
        schedulerRef.current.instance.eventStore.data = data?.events?.rows ?? [];
    }, [data]);

    return <BryntumScheduler ref={schedulerRef} {...schedulerConfig} />;
};

// maps Redux state to this component props
const mapStateToProps = state => {
    return {
        locale: state.locale,
        zoomLevel: state.zoomLevel,
        data: state.data
    };
};

// connects to Redux and exports the component
export default connect(mapStateToProps)(SchedulerComponent);
