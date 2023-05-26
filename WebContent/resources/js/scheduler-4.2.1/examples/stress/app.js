import '../../examples/_shared/shared.js'; // not required, our example styling etc.
import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import '../../lib/Scheduler/feature/Dependencies.js';
import '../../lib/Scheduler/column/ResourceInfoColumn.js';
import ColleagueSimulator from './ColleagueSimulator.js';
import DateHelper from '../../lib/Core/helper/DateHelper.js';
import StringHelper from '../../lib/Core/helper/StringHelper.js';

const scheduler = new Scheduler({
    appendTo   : 'container',
    eventColor : null,
    rowHeight  : 60,
    barMargin  : 7,
    startDate  : new Date(2021, 2, 7, 8),
    endDate    : new Date(2021, 2, 7, 18),
    viewPreset : 'hourAndDay',

    eventBodyTemplate : data => StringHelper.xss`
        <div class="b-sch-event-header">${data.headerText}</div>
        <div class="b-sch-event-footer">${data.footerText}</div>
    `,

    eventRenderer({ eventRecord, resourceRecord, renderData }) {
        renderData.style = 'background-color:' + resourceRecord.color;

        return {
            headerText : DateHelper.format(eventRecord.startDate, 'HH:mm'),
            footerText : StringHelper.encodeHtml(eventRecord.name || '')
        };
    },

    columns : [
        { type : 'resourceInfo', text : 'Staff', field : 'name', width : 200, useNameAsImageName : false }
    ],

    crudManager : {
        autoLoad  : true,
        transport : {
            load : {
                url : 'data/data.json'
            }
        },
        onLoad() {
            colleagueSimulator.start();
        }
    },

    features : {
        dependencies : true
    },

    tbar : [
        {
            type        : 'slider',
            ref         : 'nbrOfColleagues',
            text        : 'Number of colleagues',
            width       : 200,
            min         : 1,
            max         : 100,
            value       : 3,
            step        : 1,
            showValue   : true,
            showTooltip : true,
            onChange    : 'up.onSliderChange'
        },
        {
            type     : 'button',
            text     : 'Stop the madness',
            tooltip  : 'Stops the external changes',
            onAction : () => colleagueSimulator.stop()
        }
    ],

    onSliderChange({ source, value }) {
        colleagueSimulator.nbrOfColleagues = value;
    }
});

const colleagueSimulator = new ColleagueSimulator({
    scheduler,
    eventStore      : scheduler.eventStore,
    resourceStore   : scheduler.resourceStore,
    startDate       : scheduler.startDate,
    nbrOfColleagues : scheduler.widgetMap.nbrOfColleagues.value
});
