/* eslint-disable no-unused-vars */
import '../_shared/shared.js'; // not required, our example styling etc.
import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import '../../lib/Scheduler/feature/GroupSummary.js';
import '../../lib/Scheduler/column/ResourceInfoColumn.js';
import StringHelper from '../../lib/Core/helper/StringHelper.js';

const maxValue = 10;

const scheduler = new Scheduler({
    appendTo          : 'container',
    eventStyle        : 'border',
    resourceImagePath : '../_shared/images/users/',

    features : {
        //stripe       : true,
        group        : 'category',
        sort         : 'name',
        groupSummary : {
            collapseToHeader : true,
            summaries        : [
                {
                    label : 'Full time',

                    renderer : ({ events }) => {
                        // Only count events for resources that are "Full time"
                        return events.filter(event => event.resource.type === 'Full time').length;
                    }
                },
                {
                    label : 'Part time',

                    renderer : ({ events }) => {
                        return events.reduce((result, event) => {
                            // Only count events for resources that are "Part time"
                            return result + (event.resource.type === 'Part time' ? 1 : 0);
                        }, 0);
                    }
                },
                {
                    label : 'Total',

                    height : 40, // needed to make summary row grow correctly

                    renderer({ events }) {
                        const value = Math.min(1, events.length / maxValue),
                            height = (100 * value) + '%';

                        return `
                           <div class="bar-outer">
                               <div class="bar-inner" style="height: ${height}"><label class="${value > 0.5 ? 'b-summarybar-label-inside' : ''}">${events.length || ''}</label></div>
                           </div>
                        `;
                    }
                }

            ]
        }
    },

    columns : [
        {
            text   : 'Category',
            width  : 100,
            field  : 'category',
            hidden : true
        },
        {
            type      : 'resourceInfo',
            text      : 'Staff',
            width     : 170,
            summaries : [{ sum : 'count', label : 'Employees' }]
        },
        {
            text      : 'Employment type',
            width     : 130,
            field     : 'type',
            summaries : [
                {
                    sum   : (result, record) => result + (record.type === 'Part time' ? 1 : 0),
                    label : 'Part time'
                }
            ]
        }
    ],

    rowHeight : 55,
    barMargin : 10,
    startDate : new Date(2017, 0, 1),
    endDate   : new Date(2017, 0, 14),

    // Customize preset
    viewPreset : {
        base              : 'dayAndWeek',
        displayDateFormat : 'YYYY-MM-DD',
        timeResolution    : {
            unit      : 'day',
            increment : 1
        }
    },

    crudManager : {
        autoLoad  : true,
        transport : {
            load : {
                url : 'data/data.json'
            }
        }
    },

    eventRenderer({ eventRecord, resourceRecord, renderData }) {
        const colors = {
            Consultants : 'orange',
            Research    : 'purple',
            Sales       : 'lime',
            Testers     : 'cyan'
        };

        if (!eventRecord.eventColor) {
            renderData.eventColor = colors[resourceRecord.category];
        }

        // Add a custom CSS classes to the template element data by setting a property name
        renderData.cls.full = resourceRecord.type === 'Full time';
        renderData.cls.part = !renderData.cls.full;

        // Add data to be applied to the event template
        return StringHelper.encodeHtml(eventRecord.name);
    }
});
