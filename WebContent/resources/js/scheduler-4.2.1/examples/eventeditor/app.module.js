import { DateHelper, StringHelper, Scheduler, Toast } from '../../build/scheduler.module.js';
import shared from '../_shared/shared.module.js';

const scheduler = new Scheduler({

    appendTo          : 'container',
    eventStyle        : 'border',
    resourceImagePath : '../_shared/images/users/',

    features : {
        stripe     : true,
        timeRanges : true,
        headerZoom : true,
        eventEdit  : {
            // Uncomment to make event editor readonly from the start
            // readOnly : true,
            // Add items to the event editor
            items : {
                // Using this ref hooks dynamic toggling of fields per eventType up
                eventTypeField : {
                    type   : 'combo',
                    name   : 'eventType',
                    label  : 'Type',
                    // Provided items start at 100, and go up in 100s, so insert after first one
                    weight : 110,
                    items  : ['Appointment', 'Internal', 'Meeting']
                },
                locationField : {
                    type    : 'text',
                    name    : 'location',
                    label   : 'Location',
                    weight  : 120,
                    // This field is only displayed for meetings
                    dataset : { eventType : 'Meeting' }
                },
                eventColorField : {
                    type        : 'combo',
                    label       : 'Color',
                    name        : 'eventColor',
                    editable    : false,
                    weight      : 130,
                    listItemTpl : item => StringHelper.xss`<div class="color-box b-sch-${item.value}"></div><div>${item.text}</div>`,
                    items       : Scheduler.eventColors.map(color => [color, StringHelper.capitalize(color)])
                }
            }
        }
    },

    subGridConfigs : {
        locked : { width : 300 }
    },

    columns : [
        {
            type : 'resourceInfo',
            flex : 1,
            text : 'Staff'
        },
        {
            text   : 'Type',
            field  : 'role',
            flex   : 1,
            editor : {
                type        : 'combo',
                items       : ['Sales', 'Developer', 'Marketing', 'Product manager', 'CEO', 'CTO'],
                editable    : false,
                pickerWidth : 140
            }
        }
    ],

    crudManager : {
        autoLoad  : true,
        transport : {
            load : {
                url : 'data/data.json'
            }
        },
        eventStore : {
            // Extra fields used on EventModels. Store tries to be smart about it and extracts these from the first
            // record it reads, but it is good practice to define them anyway to be certain they are included.
            fields : [
                'location',
                { name : 'eventType', defaultValue : 'Appointment' }
            ]
        }
    },

    barMargin  : 2,
    rowHeight  : 50,
    startDate  : new Date(2017, 1, 7, 8),
    endDate    : new Date(2017, 1, 7, 22),
    viewPreset : {
        base      : 'hourAndDay',
        tickWidth : 100
    },

    // Specialized body template with header and footer
    eventBodyTemplate : data => StringHelper.xss`<i class="${data.iconCls || ''}"></i><section><div class="b-sch-event-header">${data.headerText}</div><div class="b-sch-event-footer">${data.footerText}</div></section>`,

    eventRenderer({ eventRecord, resourceRecord, renderData }) {
        renderData.style = 'background-color:' + resourceRecord.color;

        return {
            headerText : DateHelper.format(eventRecord.startDate, 'LT'),
            footerText : eventRecord.name || '',
            iconCls    : eventRecord.iconCls
        };
    },

    listeners : {
        eventEditBeforeSetRecord({ source : editor, record : eventRecord }) {
            editor.title = `Edit ${eventRecord.eventType || ''}`;

            // Only CEO and CTO roles are allowed to play golf...
            if (eventRecord.name === 'Golf') {
                editor.widgetMap.resourceField.store.filter({
                    filterBy : resource => resource.role.startsWith('C'),
                    id       : 'golfFilter'
                });
            }
            else {
                // Clear our golf filter before editing starts
                editor.widgetMap.resourceField.store.removeFilter('golfFilter');
            }
        }
    },

    tbar : [
        {
            type    : 'checkbox',
            label   : 'Read only editor',
            tooltip : 'Toggle read only mode for the event editor',
            onChange({ checked }) {
                scheduler.features.eventEdit.readOnly = checked;
            }
        },
        {
            type     : 'button',
            icon     : 'b-icon b-icon-add',
            text     : 'Add new event',
            onAction : () => {
                const resource  = scheduler.resourceStore.first;

                if (!resource) {
                    Toast.show('There is no resource available');
                    return;
                }

                const event = new scheduler.eventStore.modelClass({
                    resourceId   : resource.id,
                    startDate    : scheduler.startDate,
                    duration     : 1,
                    durationUnit : 'h',
                    name         : 'New task'
                });

                scheduler.editEvent(event);
            }
        }, {
            type     : 'button',
            icon     : 'b-icon b-icon-trash',
            color    : 'b-red',
            text     : 'Clear all events',
            onAction : () => scheduler.eventStore.removeAll()
        },
        '->',
        {
            type       : 'datefield',
            label      : 'View date',
            inputWidth : '8em',
            value      : new Date(2017, 1, 7),
            editable   : false,
            listeners  : {
                change : ({ value }) => scheduler.setTimeSpan(DateHelper.add(value, 8, 'hour'), DateHelper.add(value, 22, 'hour'))
            }
        }
    ]
});
