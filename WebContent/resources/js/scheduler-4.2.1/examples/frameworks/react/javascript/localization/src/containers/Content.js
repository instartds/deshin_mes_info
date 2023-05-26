/**
 * Content component
 */
// libraries
import React, { useEffect } from 'react';
// we import scheduler.umd for IE11 compatibility only. If you don't use IE import:
// import { Scheduler } from '@bryntum/scheduler';
import { Scheduler } from '@bryntum/scheduler/scheduler.umd';
import schedulerConfig from '../components/schedulerConfig.js';

const Content = props => {

    useEffect(() => {
        new Scheduler({
            ...schedulerConfig,
            appendTo : 'content'
        });
    }, []);

    return (
        <div id='content'></div>
    );

};

export default Content;
