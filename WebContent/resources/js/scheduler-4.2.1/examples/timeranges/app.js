import '../_shared/shared.js'; // not required, our example styling etc.
import DateHelper from '../../lib/Core/helper/DateHelper.js';
import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import '../../lib/Scheduler/feature/TimeRanges.js';
import '../../lib/Scheduler/column/ResourceInfoColumn.js';
import StringHelper from '../../lib/Core/helper/StringHelper.js';

const scheduler = new Scheduler({
    appendTo          : 'container',
    eventStyle        : 'colored',
    resourceImagePath : '../_shared/images/users/',
    barMargin         : 5,

    features : {
        stripe     : true,
        timeRanges : {
            enableResizing      : true,
            showCurrentTimeLine : true,
            showHeaderElements  : true
        }
    },

    columns : [
        { type : 'resourceInfo', text : 'Staff', field : 'name', width : '10em' }
    ],

    crudManager : {
        autoLoad  : true,
        transport : {
            load : {
                url : 'data/data.json'
            }
        }
    },

    startDate  : new Date(2019, 1, 7, 8),
    endDate    : new Date(2019, 1, 7, 18),
    viewPreset : 'hourAndDay',

    // Specialized body template with header and footer
    eventBodyTemplate : data => StringHelper.xss`
        <div class="b-sch-event-header">${data.headerText}</div>
        <div class="b-sch-event-footer">${data.footerText}</div>
    `,

    eventRenderer({ eventRecord })  {
        return {
            headerText : DateHelper.format(eventRecord.startDate, this.displayDateFormat),
            footerText : eventRecord.name || ''
        };
    },

    tbar : [
        {
            type : 'button',
            icon : 'b-icon-add',
            text : 'Add range',
            onAction({ source : button }) {
                scheduler.project.timeRangeStore.add({
                    name         : 'New time range',
                    startDate    : DateHelper.add(scheduler.startDate, 8, 'h'),
                    duration     : 1,
                    durationUnit : 'h'
                });

                button.disable();
            }
        },
        {
            type : 'button',
            text : 'Move lunch to 12pm',
            onAction() {
                scheduler.features.timeRanges.store.getById('lunch').setStartDate(new Date(2019, 1, 7, 12), true);
            }
        },
        '->',
        {
            type  : 'buttongroup',
            items : [
                {
                    type    : 'button',
                    icon    : 'b-fa-angle-left',
                    tooltip : 'View previous day',
                    onAction() {
                        scheduler.shiftPrevious();
                    }
                },
                {
                    type    : 'button',
                    ref     : 'todayButton',
                    text    : 'Today',
                    tooltip : 'View today, to see the current time line',
                    onAction() {
                        const today = DateHelper.clearTime(new Date());
                        today.setHours(5);
                        scheduler.setTimeSpan(today, DateHelper.add(today, 18, 'hour'));
                    }
                },
                {
                    type    : 'button',
                    icon    : 'b-fa-angle-right',
                    tooltip : 'View next day',
                    onAction() {
                        scheduler.shiftNext();
                    }
                }
            ]
        },
        {
            type    : 'button',
            text    : 'Start',
            tooltip : 'Return to initial view',
            onAction() {
                scheduler.setTimeSpan(new Date(2019, 1, 7, 8), new Date(2019, 1, 7, 18));
            }
        }
    ]
});
