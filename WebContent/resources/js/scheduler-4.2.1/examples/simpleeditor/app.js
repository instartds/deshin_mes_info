/* eslint-disable no-unused-vars */
import '../_shared/shared.js'; // not required, our example styling etc.
import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import '../../lib/Scheduler/feature/SimpleEventEdit.js';

//region Data

const resources = [
        { id : 'r1', name : 'Mike' },
        { id : 'r2', name : 'Linda' },
        { id : 'r3', name : 'Don' },
        { id : 'r4', name : 'Karen' },
        { id : 'r5', name : 'Doug' },
        { id : 'r6', name : 'Peter' },
        { id : 'r7', name : 'Sam' },
        { id : 'r8', name : 'Melissa' },
        { id : 'r9', name : 'John' },
        { id : 'r10', name : 'Ellen' }
    ],
    events = [
        {
            id         : 1,
            resourceId : 'r1',
            startDate  : new Date(2017, 0, 1, 10),
            endDate    : new Date(2017, 0, 1, 12),
            name       : 'Click me',
            iconCls    : 'b-fa b-fa-mouse-pointer'
        },
        {
            id         : 2,
            resourceId : 'r2',
            startDate  : new Date(2017, 0, 1, 12),
            endDate    : new Date(2017, 0, 1, 13, 30),
            name       : 'Drag me',
            iconCls    : 'b-fa b-fa-arrows-alt'
        },
        {
            id         : 3,
            resourceId : 'r3',
            startDate  : new Date(2017, 0, 1, 14),
            endDate    : new Date(2017, 0, 1, 16),
            name       : 'Double click me',
            eventColor : 'purple',
            iconCls    : 'b-fa b-fa-mouse-pointer'
        },
        {
            id         : 4,
            resourceId : 'r4',
            startDate  : new Date(2017, 0, 1, 8),
            endDate    : new Date(2017, 0, 1, 11),
            name       : 'Right click me',
            iconCls    : 'b-fa b-fa-mouse-pointer'
        },
        {
            id         : 5,
            resourceId : 'r5',
            startDate  : new Date(2017, 0, 1, 15),
            endDate    : new Date(2017, 0, 1, 17),
            name       : 'Resize me',
            iconCls    : 'b-fa b-fa-arrows-alt-h'
        },
        {
            id         : 6,
            resourceId : 'r6',
            startDate  : new Date(2017, 0, 1, 16),
            endDate    : new Date(2017, 0, 1, 19),
            name       : 'Important meeting',
            iconCls    : 'b-fa b-fa-exclamation-triangle',
            eventColor : 'red'
        },
        {
            id         : 7,
            resourceId : 'r6',
            startDate  : new Date(2017, 0, 1, 6),
            endDate    : new Date(2017, 0, 1, 8),
            name       : 'Sports event',
            iconCls    : 'b-fa b-fa-basketball-ball'
        },
        {
            id         : 8,
            resourceId : 'r7',
            startDate  : new Date(2017, 0, 1, 9),
            endDate    : new Date(2017, 0, 1, 11, 30),
            name       : 'Dad\'s birthday!',
            iconCls    : 'b-fa b-fa-birthday-cake',
            style      : 'background-color : teal; font-size: 18px'
        }
    ];

//endregion

const scheduler = new Scheduler({
    appendTo         : 'container',
    resources        : resources,
    events           : events,
    startDate        : new Date(2017, 0, 1, 6),
    endDate          : new Date(2017, 0, 1, 20),
    viewPreset       : 'hourAndDay',
    rowHeight        : 50,
    barMargin        : 5,
    multiEventSelect : true,

    columns : [
        { text : 'Name', field : 'name', width : 130 }
    ],

    features : {
        eventEdit       : false,
        simpleEventEdit : true
    }
});
