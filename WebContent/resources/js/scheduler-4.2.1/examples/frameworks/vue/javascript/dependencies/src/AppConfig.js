/**
 * Configuration for the scheduler
 */
const schedulerConfig = {
    eventStyle: null,
    eventColor: null,
    rowHeight: 50,
    barMargin: 8,
    startDate: new Date(2017, 11, 1),
    endDate: new Date(2017, 11, 3),

    resourceImagePath: 'users/',

    viewPreset: {
        base: 'hourAndDay',
        tickWidth: 25,
        columnLinesFor: 0,
        headers: [
            {
                unit: 'd',
                align: 'center',
                dateFormat: 'ddd DD MMM'
            },
            {
                unit: 'h',
                align: 'center',
                dateFormat: 'HH'
            }
        ]
    },

    columns: [
        {
            text: 'Production line',
            width: 150,
            field: 'name'
        }
    ],

    timeRangesFeature: true,
    stripeFeature: true,
    dependenciesFeature: true,
    eventDragFeature: {
        constrainDragToResource: true
    },

    crudManager: {
        autoLoad: true,
        transport: {
            load: {
                url: 'data/data.json'
            }
        }
    },

    eventRenderer({ eventRecord, resourceRecord, renderData }) {
        const bgColor = resourceRecord.bg || '';

        renderData.style = `background:${bgColor};border-color:${bgColor};color:${
            resourceRecord.textColor
        }`;
        renderData.iconCls.add('b-fa', `b-fa-${resourceRecord.icon}`);

        return eventRecord.name;
    }
};

export { schedulerConfig };
