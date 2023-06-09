/**
 * Configuration for the scheduler
 */
import { Popup, Tooltip, StringHelper } from '@bryntum/scheduler';

const colors = [
    'Cyan',
    'Blue',
    'Green',
    'Light-green',
    'Lime',
    'Orange',
    'Purple',
    'Red',
    'Teal'
];

// Tooltip for add client buttons (plain divs)
new Tooltip({
    forSelector : '.add',
    html        : 'Add client',
    hideDelay   : 100
});

const schedulerConfig = {
    startDate  : new Date(2018, 4, 7),
    endDate    : new Date(2018, 4, 26),
    barMargin  : 7,
    rowHeight  : 45,
    eventColor : null,
    eventStyle : null,

    viewPreset: {
        base              : 'weekAndDay',
        displayDateFormat : 'll'
    },

    // Disable cell editing, this demo has its own custom row editor
    cellEditFeature : false,
    // Drag only within clients/employees, snap to days
    eventDragFeature: {
        constrainDragToResource : true,
        showExactDropPosition   : true
    },
    // Event editor with two custom fields, location for clients and color for employees
    eventEditFeature: {
        typeField : 'type',

        items: {
            location: {
                type    : 'text',
                name    : 'location',
                label   : 'Location',
                weight  : 110,
                dataset : { eventType: 'client' }
            },
            color: {
                type  : 'combo',
                name  : 'color',
                label : 'Color',
                items : colors.map(color => [
                    color.toLowerCase(),
                    color
                ]),
                listItemTpl : data =>
                    StringHelper.xss`<div class="color-item ${
                        data.value
                    }"></div>${data.text}`,
                weight  : 120,
                dataset : { eventType: 'employee' }
            }
        }
    },
    // Resize snapping to days
    eventResizeFeature: {
        showExactResizePosition : true
    },
    // Shade weekends
    nonWorkingTimeFeature : true,
    // Uses a tree where parent nodes are employees and child nodes are clients
    treeFeature : true,

    columns: [
        {
            type  : 'tree',
            text  : 'Employees',
            field : 'name',
            width : '15em',
            // Hide default tree icons
            expandedFolderIconCls  : null,
            collapsedFolderIconCls : null,
            leafIconCls            : null,
            // Set to `false` to render our custom markup
            htmlEncode : false,
            // Custom renderer display employee info or client color + name
            renderer({ record, value, size }) {
                // Parent rows are employees
                if (record.isParent) {
                    const image = record.image
                        ? StringHelper.xss`<img class="profile-img" src="resources/images/${record.name.toLowerCase()}.jpg" />`
                         :  '';
                    // Make employee row higher
                    size.height = 60;
                    // Employee template
                    return (
                        StringHelper.xss`
                        <div class = "info">
                        <div class = "name">${value}</div>
                        <div class = "title">${record.title}</div>
                        </div>
                        <div class = "add"><i class = "b-fa b-fa-plus"></i></div>
                    ` + image
                    );
                }
                // Other rows are clients
                else {
                    // Client template
                    return StringHelper.xss`<div class="client-color ${
                        record.color
                    }"></div>${value}`;
                }
            }
        }
    ],

    // CrudManager loads all data from a single source
    crudManager: {
        autoLoad : true,

        transport: {
            load: {
                url : './data/data.json'
            }
        },

        resourceStore: {
            fields : ['color', 'title'],
            tree   : true
        },

        eventStore: {
            fields : ['color', 'location']
        }
    },

    // Custom event renderer that applies colors and display events location
    eventRenderer({ renderData, resourceRecord, eventRecord }) {
        if (resourceRecord.isParent) {
            renderData.wrapperCls.add('employee');
        }

        if (eventRecord.color) {
            renderData.wrapperCls.add(eventRecord.color);
        } else if (resourceRecord.color) {
            renderData.wrapperCls.add(resourceRecord.color);
        }

        return (
            StringHelper.encodeHtml(eventRecord.name) +
            (eventRecord.location
                ? `<span>, ${StringHelper.encodeHtml(
                      eventRecord.location
                  )}</span>`
                : '')
        );
    },

    listeners: {
        cellClick({ record, event }) {
            // Add a new client when clicking plus icon
            if (event.target.closest('.add')) {
                record.appendChild({
                    name : 'New client',
                    // New client gets a random color
                    color: colors[
                        Math.floor(Math.random() * colors.length)
                    ].toLowerCase()
                });
            }
        },

        dragCreateEnd({ newEventRecord, resourceRecord }) {
            // Make new event have correct type, to show correct fields in event editor
            newEventRecord.type = resourceRecord.isLeaf
                ? 'client'
                 :  'employee';
        },

        cellDblClick({ record, cellElement, column }) {
            // Show a custom editor when dbl clicking a client cell
            if (column.field === 'name' && record.isLeaf) {
                new Popup({
                    autoShow     : true,
                    autoClose    : true,
                    closeAction  : 'destroy',
                    scrollAction : 'realign',
                    forElement   : cellElement,
                    anchor       : true,
                    width        : '20em',
                    cls          : 'client-editor',
                    items        : [
                        {
                            type       : 'text',
                            name       : 'name',
                            label      : 'Client',
                            labelWidth : '4em',
                            value      : record.name,
                            onChange   : ({ value }) => {
                                record.name = value;
                            }
                        },
                        {
                            type       : 'combo',
                            cls        : 'b-last-row',
                            name       : 'color',
                            label      : 'Color',
                            labelWidth : '4em',
                            items      : colors.map(color => [
                                color.toLowerCase(),
                                color
                            ]),
                            listItemTpl : data =>
                                `<div class="color-item ${
                                    data.value
                                }"></div>${data.text}`,
                            value    : record.color,
                            onChange : ({ value }) => {
                                record.color = value;
                            }
                        }
                    ]
                });
            }
        },

        prio : 1
    }
};

export { colors, schedulerConfig };
