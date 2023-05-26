import '../_shared/shared.js'; // not required, our example styling etc.
import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import '../../lib/Scheduler/column/ResourceInfoColumn.js';
import '../../lib/Scheduler/feature/NonWorkingTime.js';
import DateHelper from '../../lib/Core/helper/DateHelper.js';
import StringHelper from '../../lib/Core/helper/StringHelper.js';

const scheduler = new Scheduler({
    appendTo          : 'container',
    startDate         : new Date(2018, 4, 13),
    endDate           : new Date(2018, 4, 20),
    viewPreset        : 'dayAndWeek',
    rowHeight         : 60,
    barMargin         : 5,
    fillTicks         : true,
    eventStyle        : 'colored',
    resourceImagePath : '../_shared/images/users/',

    features : {
        nonWorkingTime : true,

        // Not yet compatible with the event styles which center their content
        stickyEvents : false
    },

    columns : [
        { type : 'resourceInfo', text : 'Name', field : 'name', width : 130 }
    ],

    eventStore : {
        readUrl  : 'data/events.json',
        autoLoad : true
    },

    resourceStore : {
        readUrl  : 'data/resources.json',
        autoLoad : true
    },

    eventRenderer({ eventRecord }) {
        return [{
            html : DateHelper.format(eventRecord.startDate, 'LT')
        }, {
            html : StringHelper.encodeHtml(eventRecord.name)
        }];
    },

    tbar : [
        {
            type     : 'checkbox',
            label    : 'Fill ticks',
            checked  : true,
            onChange : ({ checked }) => {
                scheduler.fillTicks = checked;
            }
        }
    ]
});
