/**
 * Application config file
 */

// Bryntum umd lite bundle comes without polyfills to support Angular's zone.js
import { Scheduler, StringHelper } from '@bryntum/scheduler/scheduler.lite.umd.js';
import AppEventModel from './lib/AppEventModel';

export const schedulerConfig = {
    eventColor : null,
    columns    : [
        { type : 'resourceInfo', text : 'Staff', field : 'name', width : 150 },
        {
            text       : 'Event color',
            field      : 'eventColor',
            width      : 90,
            htmlEncode : false,
            renderer   : ({ record }) => `<div class="color-box b-sch-${record.eventColor}">
</div>${StringHelper.capitalize(record.eventColor)}`,
            editor : {
                type        : 'combo',
                items       : Scheduler.eventColors,
                editable    : false,
                listItemTpl : (item: any) => `<div class="color-box b-sch-${item.value}"></div><div>${item.value}</div>`
            }
        }
    ],

    timeRangesFeature : true,

    resourceImagePath : 'assets/users/',

    crudManager : {
        autoLoad   : true,
        eventStore : {
            modelClass : AppEventModel
        },
        transport : {
            load : {
                url : 'assets/data/data.json'
            }
        }
    },

    barMargin : 1,
    rowHeight : 50,

    startDate  : new Date(2017, 1, 7, 8),
    endDate    : new Date(2017, 1, 7, 18),
    viewPreset : 'hourAndDay',

    useInitialAnimation : 'slide-from-left'

};
