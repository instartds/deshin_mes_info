import { Scheduler, CrudManager, StringHelper } from '../../build/scheduler.module.js';
import shared from '../_shared/shared.module.js';

//TODO: tree filtering

const crudManager = new CrudManager({
    autoLoad  : true,
    transport : {
        load : {
            url : 'data/data.json'
        }
    }
});

const scheduler = new Scheduler({
    appendTo          : 'container',
    resourceImagePath : '../_shared/images/users/',

    features : {
        stripe : true,
        group  : 'category',
        sort   : 'name'
    },

    columns : [
        {
            text   : 'Category',
            width  : 100,
            field  : 'category',
            hidden : true
        },
        {
            type  : 'resourceInfo',
            text  : 'Staff',
            width : 160
        },
        {
            text  : 'Employment type',
            width : 130,
            field : 'type'
        }
    ],

    rowHeight : 55,
    barMargin : 5,
    startDate : new Date(2017, 0, 1),
    endDate   : new Date(2017, 0, 14),
    crudManager,

    // Customize preset
    viewPreset : {
        base              : 'dayAndWeek',
        displayDateFormat : 'YYYY-MM-DD',
        timeResolution    : {
            unit      : 'day',
            increment : 1
        }
    },

    eventRenderer({ eventRecord, resourceRecord, renderData }) {
        const colors = {
            Consultants : 'orange',
            Research    : 'pink',
            Sales       : 'lime',
            Testars     : 'cyan'
        };

        renderData.eventColor = colors[resourceRecord.category];

        return StringHelper.encodeHtml(eventRecord.name);
    },

    tbar : [
        {
            type         : 'combo',
            width        : 300,
            label        : 'Scroll to resource',
            store        : crudManager.resourceStore,
            valueField   : 'id',
            displayField : 'name',
            onSelect({ record }) {
                scheduler.scrollRowIntoView(record, { animate : true, highlight : true });
            }
        }
    ]
});

window.scheduler = scheduler;
