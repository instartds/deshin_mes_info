import '../_shared/shared.js'; // not required, our example styling etc.

import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import '../../lib/Scheduler/column/ResourceInfoColumn.js';
import StringHelper from '../../lib/Core/helper/StringHelper.js';

// eslint-disable-next-line no-unused-vars
const scheduler = new Scheduler({

    appendTo          : 'container',
    resourceImagePath : '../_shared/images/users/',

    features : {
        eventDragCreate : false,
        eventResize     : false,
        eventTooltip    : false,
        stickyEvents    : false,
        eventDrag       : {
            constrainDragToResource : true
        }
    },

    columns : [
        {
            type           : 'resourceInfo',
            text           : 'Staff',
            field          : 'name',
            width          : '13em',
            showEventCount : false,
            showRole       : true
        }
    ],

    rowHeight          : 80,
    startDate          : new Date(2017, 5, 1),
    endDate            : new Date(2017, 5, 11),
    viewPreset         : 'dayAndWeek',
    eventLayout        : 'none',
    managedEventSizing : false,

    crudManager : {
        autoLoad   : true,
        eventStore : {
            fields : [
                'startInfo',
                'startInfoIcon',
                'endInfo',
                'endInfoIcon'
            ]
        },
        transport : {
            load : {
                url : 'data/data.json'
            }
        }
    },

    eventRenderer({ eventRecord, resourceRecord, renderData }) {
        let startEndMarkers = '';

        // Add a custom CSS classes to the template element data by setting a property name
        renderData.cls.milestone          = eventRecord.isMilestone;
        renderData.cls.normalEvent        = !eventRecord.isMilestone;
        renderData.cls[resourceRecord.id] = 1;

        if (eventRecord.startInfo) {
            startEndMarkers = `<i class="b-start-marker ${eventRecord.startInfoIcon}" data-btip="${eventRecord.startInfo}"></i>`;
        }
        if (eventRecord.endInfo) {
            startEndMarkers += `<i class="b-end-marker ${eventRecord.endInfoIcon}" data-btip="${eventRecord.endInfo}"></i>`;
        }

        return startEndMarkers + StringHelper.encodeHtml(eventRecord.name);
    }
});
