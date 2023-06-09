/**
 * Scheduler config
 */
import { DateHelper, SchedulerConfig } from '@bryntum/scheduler/scheduler.umd.js';

const schedulerConfig: Partial<SchedulerConfig> = {
    eventStyle: 'colored',
    //@ts-ignore
    eventColor: null,
    resourceImagePath: 'users/',
    columns: [
        {
            type: 'resourceInfo',
            text: 'Staff',
            width: 170
        },
        {
            text: 'Role',
            field: 'role',
            width: 140,
            editor: {
                type: 'combo',
                items: ['Sales', 'Developer', 'Marketing', 'Product manager'],
                editable: false,
                pickerWidth: 140
            }
        }
    ],
    filterBarFeature: true,
    stripeFeature: true,
    timeRangesFeature: true,
    eventEditFeature: {
        items: {
            locationField: {
                type: 'text',
                name: 'location',
                label: 'Location',
                dataset: { eventType: 'Meeting' },
                weight: 200
            }
        }
    },

    displayDateFormat: 'HH:mm',

    barMargin: 5,
    rowHeight: 55,

    startDate: new Date(2017, 1, 7, 8),
    endDate: new Date(2017, 1, 7, 18),
    viewPreset: 'hourAndDay',

    crudManager: {
        autoLoad: true,
        transport: {
            load: {
                url: 'data/data.json'
            }
        }
    },

    // Specialized body template with header and footer
    eventBodyTemplate: (data: any) => `
        <div class="b-sch-event-header">${data.headerText}</div>
        <div class="b-sch-event-footer">${data.footerText}</div>
    `,

    eventRenderer({
        eventRecord,
        resourceRecord,
        renderData
    }: {
        eventRecord: any;
        resourceRecord: any;
        renderData: any;
    }): object {
        renderData.style = 'background-color:' + resourceRecord.color;

        return {
            headerText: DateHelper.format(eventRecord.startDate, this.displayDateFormat as string),
            footerText: eventRecord.name || ''
        };
    }
};

const findConfig = {
    placeholder: 'Find tasks by name',
    keyStrokeChangeDelay: 80,
    clearable: true,
    width: '12.5em',
    triggers: {
        filter: {
            align: 'start',
            cls: 'b-fa b-fa-filter'
        }
    }
};

const highlightConfig = {
    placeholder: 'Highlight tasks',
    keyStrokeChangeDelay: 80,
    clearable: true,
    width: '12.5em',
    triggers: {
        filter: {
            align: 'start',
            cls: 'b-fa b-fa-search'
        }
    }
};

export { schedulerConfig, findConfig, highlightConfig };
