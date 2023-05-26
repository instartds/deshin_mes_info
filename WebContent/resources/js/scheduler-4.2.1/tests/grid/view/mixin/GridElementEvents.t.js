import Scheduler from '../../../../lib/Scheduler/view/Scheduler.js';
import EventStore from '../../../../lib/Scheduler/data/EventStore.js';
import ResourceStore from '../../../../lib/Scheduler/data/ResourceStore.js';
import PresetManager from '../../../../lib/Scheduler/preset/PresetManager.js';

// Had to port this test to get imports right

StartTest(t => {
    Object.assign(window, {
        Scheduler,
        EventStore,
        ResourceStore,
        PresetManager
    });

    let grid;

    t.beforeEach(t => grid && grid.destroy());

    t.it('Should trigger cell events', t => {
        grid = t.getGrid({
            features : {
                cellEdit : false
            }
        });

        t.firesOk({
            observable : grid,
            events     : {
                cellClick       : 3,
                cellDblClick    : 1,
                cellContextMenu : 1,
                cellMouseOver   : '>=1',
                cellMouseOut    : '>=1'
            }
        });

        t.chain(
            { click : '.b-grid-cell' },
            { dblclick : '.b-grid-cell' },
            { contextmenu : '.b-grid-cell' },
            { moveMouseTo : '.b-grid-header' }
        );
    });
});
