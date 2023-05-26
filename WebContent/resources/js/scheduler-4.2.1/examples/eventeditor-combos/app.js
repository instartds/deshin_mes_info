import '../_shared/shared.js'; // not required, our example styling etc.
import DateHelper from '../../lib/Core/helper/DateHelper.js';
import AjaxStore from '../../lib/Core/data/AjaxStore.js';
import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import EventModel from '../../lib/Scheduler/model/EventModel.js';
import '../../lib/Grid/column/TemplateColumn.js';
import '../../lib/Scheduler/feature/TimeRanges.js';
import '../../lib/Scheduler/column/ResourceInfoColumn.js';
import Toast from '../../lib/Core/widget/Toast.js';
import StringHelper from '../../lib/Core/helper/StringHelper.js';

class Task extends EventModel {
    static get fields() {
        return [
            'floor',
            'room',
            { name : 'eventType', defaultValue : 'Meeting' }
        ];
    }
}

let scheduler;

// CrudManager is responsible for the data
const floors = new AjaxStore({
    storeId : 'floors'
});

const rooms = new AjaxStore({
    storeId : 'rooms'
});

scheduler = new Scheduler({
    appendTo          : 'container',
    eventStyle        : 'border',
    resourceImagePath : '../_shared/images/users/',

    features : {
        stripe     : true,
        timeRanges : true,
        eventEdit  : {
            // Add extra widgets to the event editor
            items : {
                eventType : {
                    type      : 'combo',
                    name      : 'eventType',
                    label     : 'Type',
                    weight    : 110,
                    items     : ['Appointment', 'Internal', 'Meeting'],
                    listeners : {
                        // TODO move this code to the event editor
                        // #7809 - eventType field should update visibility of the other EventEditor fields
                        change : ({ source : combo, value }) => {
                            // toggle visibility of widgets belonging to eventTypes
                            combo.owner.items.forEach(widget => {
                                if (widget.dataset && widget.dataset.eventType) {
                                    widget.hidden = widget.dataset.eventType !== value;
                                }
                            });
                        }
                    }
                },
                floor : {
                    type        : 'combo',
                    store       : floors,
                    name        : 'floor',
                    label       : 'Floor',
                    placeholder : 'Select floor...',
                    weight      : 120,
                    editable    : false,
                    clearable   : true,
                    dataset     : { eventType : 'Meeting' }, // This field is only displayed for meetings
                    listeners   : {
                        change : ({ source : combo, value }) => {
                            const roomCombo = combo.owner.widgetMap.roomCombo;

                            if (combo.record) {
                                roomCombo.store.filter('floorId', value);
                                roomCombo.disabled = false;

                                // if the selected record has been filtered out need to reset value
                                const index = roomCombo.store.indexOf(roomCombo.record);
                                // check both undefined and -1 until https://app.assembla.com/spaces/bryntum/tickets/8890 is resolved
                                if (index === -1 || index == null) {
                                    roomCombo.value = null;
                                }
                            }
                            else {
                                roomCombo.value = null;
                                roomCombo.disabled = true;
                            }
                        }
                    }
                },
                roomCombo : {
                    type        : 'combo',
                    ref         : 'roomCombo',
                    store       : rooms,
                    name        : 'room',
                    label       : 'Room',
                    placeholder : 'Select room...',
                    weight      : 130,
                    editable    : false,
                    clearable   : true,
                    disabled    : true,
                    dataset     : { eventType : 'Meeting' } // This field is only displayed for meetings
                }
            }
        }
    },

    subGridConfigs : {
        locked : { width : 400 }
    },

    columns : [
        {
            type : 'resourceInfo',
            text : 'Staff',
            flex : 1
        },
        {
            text   : 'Type',
            field  : 'role',
            width  : 150,
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
        stores    : [floors, rooms],
        transport : {
            load : {
                url : 'data/data.json'
            }
        },
        eventStore : {
            modelClass : Task
        }
    },

    eventColor : null, // disable default color for events (colors are set in scss file depending on its type)
    barMargin  : 2,
    rowHeight  : 50,
    startDate  : new Date(2019, 1, 7, 8),
    endDate    : new Date(2019, 1, 7, 22),
    viewPreset : {
        base      : 'hourAndDay',
        tickWidth : 100
    },

    // Specialized body template with header and footer
    eventBodyTemplate : data => StringHelper.xss`
        <i class="${data.iconCls || ''}"></i>
        <section>
        <div class="b-sch-event-header">${data.headerText}</div>
        <div class="b-sch-event-footer">${data.footerText}</div>
        </section>`,

    eventRenderer({ eventRecord, resourceRecord, renderData }) {
        renderData.cls.add(`b-sch-eventtype-${eventRecord.eventType}`);

        let headerText = DateHelper.format(eventRecord.startDate, 'LT');

        if (eventRecord.eventType === 'Meeting') {
            if (eventRecord.floor) {
                headerText += ` | Floor #${eventRecord.floor}`;
            }
            if (eventRecord.room) {
                headerText += ` | Room #${eventRecord.room}`;
            }
        }

        return {
            headerText,
            footerText : eventRecord.name || '',
            iconCls    : eventRecord.iconCls
        };
    },

    listeners : {
        beforeEventEditShow({ eventRecord, editor }) {
            editor.title = eventRecord.eventStore ? `Edit ${eventRecord.eventType || ''}` : 'Add new event';
        }
    },

    tbar : [
        {
            type     : 'button',
            icon     : 'b-icon-add',
            text     : 'Add new event',
            onAction : () => {
                const resource  = scheduler.resourceStore.first;

                if (!resource) {
                    Toast.show('There is no resource available');
                    return;
                }

                const event = new Task({
                    resourceId   : resource.id,
                    startDate    : scheduler.startDate,
                    duration     : 1,
                    durationUnit : 'h',
                    name         : 'New task'
                });

                scheduler.editEvent(event);
            }
        },
        {
            type     : 'button',
            icon     : 'b-icon-trash',
            color    : 'b-red',
            text     : 'Clear all events',
            onAction : () => scheduler.eventStore.removeAll()
        }
    ]
});
