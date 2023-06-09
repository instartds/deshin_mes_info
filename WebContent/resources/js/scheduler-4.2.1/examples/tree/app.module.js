import { Scheduler, ResourceModel, StringHelper } from '../../build/scheduler.module.js';
import shared from '../_shared/shared.module.js';

//TODO: tree filtering

class Gate extends ResourceModel {
    static get fields() {
        return [{
            name : 'capacity',
            type : 'number'
        }];
    }
}
Gate.exposeProperties();

new Scheduler({
    appendTo   : 'container',
    eventColor : null,
    eventStyle : null,

    features : {
        timeRanges : {
            showHeaderElements : false
        },
        tree         : true,
        regionResize : true
    },

    rowHeight : 45,
    barMargin : 5,

    columns : [
        {
            type  : 'tree',
            text  : 'Name',
            width : 220,
            field : 'name'
        }, {
            type  : 'aggregate',
            text  : 'Capacity',
            width : 90,
            field : 'capacity'
        }
    ],

    startDate  : new Date(2017, 11, 2, 8),
    //endDate   : new Date(2017, 11, 3),
    viewPreset : 'hourAndDay',

    crudManager : {
        autoLoad      : true,
        resourceStore : {
            modelClass : Gate
        },
        transport : {
            load : {
                url : 'data/data.json'
            }
        }
    },

    eventRenderer({ eventRecord, resourceRecord, renderData }) {
        const { isLeaf } = resourceRecord;

        // Custom icon
        renderData.iconCls = 'b-fa b-fa-plane';

        // Add custom CSS classes to the template element data by setting property names
        renderData.cls.leaf = isLeaf;
        renderData.cls.group = !isLeaf;

        return isLeaf ? StringHelper.encodeHtml(eventRecord.name) : '\xa0';
    }
});
