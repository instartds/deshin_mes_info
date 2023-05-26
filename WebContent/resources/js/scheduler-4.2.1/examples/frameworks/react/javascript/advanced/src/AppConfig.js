/**
 * Bryntum Scheduler configuration
 */
import { Scheduler, StringHelper } from '@bryntum/scheduler/scheduler.umd';

const schedulerConfig = {
    eventColor: null,
    timeRangesFeature: {
        narrowThreshold: 10
    },

    barMargin: 1,
    rowHeight: 50,

    startDate: new Date(2017, 1, 7, 8),
    endDate: new Date(2017, 1, 7, 18),

    viewPreset: 'hourAndDay',
    useInitialAnimation: 'slide-from-left',

    zoomKeepsOriginalTimespan: false,
    resourceImagePath: 'users/',

    // initially loads resources and events
    crudManager: {
        autoLoad: true,
        transport: {
            load: {
                url: 'data/data.json'
            }
        }
    },

    // Columns in scheduler
    columns: [
        { type: 'resourceInfo', text: 'Staff', field: 'name', width: 150 },
        {
            text: 'Task color',
            field: 'eventColor',
            width: 120,
            htmlEncode: false,
            renderer: ({ record }) =>
                `<div class="color-box b-sch-${
                    record.eventColor
                }"></div>${StringHelper.capitalize(record.eventColor)}`,
            editor: {
                type: 'combo',
                items: Scheduler.eventColors,
                editable: false,
                listItemTpl: item =>
                    `<div class="color-box b-sch-${item.value}"></div><div>${item.value}</div>`
            }
        }
    ]
};

export { schedulerConfig };
