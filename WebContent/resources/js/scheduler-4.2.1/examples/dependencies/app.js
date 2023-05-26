/* eslint-disable no-unused-vars */
import '../_shared/shared.js'; // not required, our example styling etc.
import '../../lib/Grid/feature/Stripe.js';
import '../../lib/Grid/feature/Sort.js';
import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import '../../lib/Scheduler/feature/Dependencies.js';
import '../../lib/Scheduler/feature/DependencyEdit.js';
import '../../lib/Scheduler/feature/TimeRanges.js';
import '../../lib/Scheduler/feature/EventDrag.js';
import '../../lib/Scheduler/feature/EventDragCreate.js';
import '../../lib/Scheduler/feature/EventResize.js';

import StringHelper from '../../lib/Core/helper/StringHelper.js';

const scheduler = new Scheduler({
    appendTo   : 'container',
    eventStyle : null,
    eventColor : null,

    features : {
        stripe         : true,
        dependencies   : true,
        dependencyEdit : {
            showLagField : false
        },

        timeRanges : true,
        eventDrag  : {
            constrainDragToResource : true
        }
    },

    rowHeight : 50,
    barMargin : 8,

    columns : [
        {
            text  : 'Production line',
            width : 150,
            field : 'name'
        }
    ],

    startDate : new Date(2017, 11, 1),
    endDate   : new Date(2017, 11, 3),

    crudManager : {
        autoLoad  : true,
        transport : {
            load : {
                url : 'data/data.json'
            }
        }
    },

    viewPreset : {
        base           : 'hourAndDay',
        tickWidth      : 25,
        columnLinesFor : 0,
        headers        : [
            {
                unit       : 'd',
                align      : 'center',
                dateFormat : 'ddd DD MMM'
            },
            {
                unit       : 'h',
                align      : 'center',
                dateFormat : 'HH'
            }
        ]
    },

    eventRenderer({ eventRecord, resourceRecord, renderData }) {
        const bgColor = resourceRecord.bg || '';

        renderData.style = `background:${bgColor};border-color:${bgColor};color:${resourceRecord.textColor}`;
        renderData.iconCls.add('b-fa', `b-fa-${resourceRecord.icon}`);

        return StringHelper.encodeHtml(eventRecord.name);
    },

    tbar : [
        {
            type    : 'checkbox',
            text    : 'Allow mouse up anywhere on target task',
            checked : true,
            tooltip : `Uncheck to require a drop on a target event bar side circle to define the dependency type.
                       If dropped on the event bar, the defaultValue of the DependencyModel <code>type</code> field will be used to
                       determine the target task side.`,
            onAction({ checked }) {
                scheduler.features.dependencies.allowDropOnEventBar = checked;
            }
        }
    ]
});
