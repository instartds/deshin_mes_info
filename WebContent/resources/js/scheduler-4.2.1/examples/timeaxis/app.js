/* eslint-disable no-unused-vars */
import '../_shared/shared.js'; // not required, our example styling etc.
import TabPanel from '../../lib/Core/widget/TabPanel.js';
import './view/SchedulerCustomTimeAxis.js';
import './view/SchedulerCustomTimeAxis2.js';
import './view/SchedulerCustomTimeAxis3.js';
import './view/SchedulerFilterableTimeAxis.js';
import './view/SchedulerCompressedTimeAxis.js';

const tabPanel = new TabPanel({
    appendTo : 'container',
    items    : [
        {
            title     : 'Custom timeaxis #1',
            ref       : 'custom1',
            type      : 'schedulercustomtimeaxis',
            startDate : new Date(2019, 1, 11),
            endDate   : new Date(2019, 1, 16)
        },
        {
            title     : 'Custom timeaxis #2',
            ref       : 'custom2',
            type      : 'schedulercustomtimeaxis2',
            startDate : new Date(2019, 1, 11),
            endDate   : new Date(2019, 1, 16)
        },
        {
            title     : 'Filterable timeaxis',
            ref       : 'filterable',
            type      : 'schedulerfilterabletimeaxis',
            startDate : new Date(2019, 1, 10),
            endDate   : new Date(2019, 1, 17)
        },
        {
            title     : 'Custom header tick spans',
            ref       : 'custom3',
            type      : 'schedulercustomtimeaxis3',
            startDate : new Date(2020, 9, 1),
            endDate   : new Date(2021, 9, 1)
        },
        {
            title     : 'Compressed non-working time',
            ref       : 'compressed',
            type      : 'schedulercompressedtimeaxis',
            startDate : new Date(2020, 1, 20),
            endDate   : new Date(2020, 1, 21)
        }
    ]
});
