import '../_shared/shared.js'; // not required, our example styling etc.
import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import '../../lib/Scheduler/column/ResourceInfoColumn.js';

//region Data

const
    resources = [
        { id : 'r1', name : 'Arcady', role : 'Core developer' },
        { id : 'r2', name : 'Dave', role : 'Tech Sales' },
        { id : 'r3', name : 'Henrik', role : 'Sales' },
        { id : 'r4', name : 'Linda', role : 'Core developer' },
        { id : 'r5', name : 'Celia', role : 'Developer & UX' },
        { id : 'r6', name : 'Lisa', role : 'CEO' },
        { id : 'r7', name : 'Angelo', role : 'CTO' }
    ],
    events    = [
        {
            id         : 1,
            resourceId : 'r1',
            name       : 'Coding session',
            startDate  : new Date(2017, 0, 1, 10),
            endDate    : new Date(2017, 0, 1, 12),
            eventColor : 'orange',
            iconCls    : 'b-fa b-fa-code'
        },
        {
            id         : 2,
            resourceId : 'r2',
            name       : 'Conference call',
            startDate  : new Date(2017, 0, 1, 12),
            endDate    : new Date(2017, 0, 1, 15),
            eventColor : 'lime',
            iconCls    : 'b-fa b-fa-phone'
        },
        {
            id         : 3,
            resourceId : 'r3',
            name       : 'Meeting',
            startDate  : new Date(2017, 0, 1, 14),
            endDate    : new Date(2017, 0, 1, 17),
            eventColor : 'teal',
            iconCls    : 'b-fa b-fa-calendar'
        },
        {
            id         : 4,
            resourceId : 'r4',
            name       : 'Scrum',
            startDate  : new Date(2017, 0, 1, 8),
            endDate    : new Date(2017, 0, 1, 11),
            eventColor : 'blue',
            iconCls    : 'b-fa b-fa-comments'
        },
        {
            id         : 5,
            resourceId : 'r5',
            name       : 'Use cases',
            startDate  : new Date(2017, 0, 1, 15),
            endDate    : new Date(2017, 0, 1, 17),
            eventColor : 'violet',
            iconCls    : 'b-fa b-fa-users'
        },
        {
            id         : 6,
            resourceId : 'r6',
            name       : 'Golf',
            startDate  : new Date(2017, 0, 1, 16),
            endDate    : new Date(2017, 0, 1, 18),
            eventColor : 'pink',
            iconCls    : 'b-fa b-fa-golf-ball'
        }
    ];

//endregion

new Scheduler({
    appendTo          : 'container',
    rowHeight         : 60,
    barMargin         : 10,
    resourceImagePath : '../_shared/images/users/',

    columns : [
        {
            type           : 'resourceInfo',
            text           : 'Name',
            showRole       : true,
            showEventCount : false,
            width          : '15em'
        }
    ],

    resources : resources,

    events : events,

    startDate  : new Date(2017, 0, 1, 8),
    endDate    : new Date(2017, 0, 1, 19),
    viewPreset : 'hourAndDay'
});
