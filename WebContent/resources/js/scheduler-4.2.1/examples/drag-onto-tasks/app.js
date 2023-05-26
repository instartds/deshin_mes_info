/* eslint-disable no-unused-vars */
import '../_shared/shared.js'; // not required, our example styling etc.
import EquipmentGrid from './lib/EquipmentGrid.js';
import Schedule from './lib/Schedule.js';
import Task from './lib/Task.js';
import Drag from './lib/Drag.js';
import AjaxStore from '../../lib/Core/data/AjaxStore.js';

const equipmentStore = new AjaxStore({
    modelClass : Task,
    readUrl    : 'data/equipment.json',
    sorters    : [
        { field : 'name', ascending : true }
    ]
});

const schedule = new Schedule({
    ref            : 'schedule',
    appendTo       : 'bodycontainer',
    startDate      : new Date(2017, 11, 1, 8),
    endDate        : new Date(2017, 11, 1, 18),
    equipmentStore : equipmentStore,
    crudManager    : {
        autoLoad   : true,
        eventStore : {
            modelClass : Task
        },
        transport : {
            load : {
                url : 'data/data.json'
            }
        }
    }
});

equipmentStore.load();

// Create our list of equipment
const equipmentGrid = new EquipmentGrid({
    ref        : 'equipment',
    appendTo   : 'bodycontainer',
    eventStore : schedule.eventStore,
    // Use a chained Store to avoid its filtering to interfere with Scheduler's rendering
    store      : equipmentStore.makeChained(() => true)
});

const drag = new Drag({
    grid         : equipmentGrid,
    schedule     : schedule,
    outerElement : equipmentGrid.element
});
