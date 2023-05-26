import EventModel from '../../lib/Scheduler/model/EventModel.js';
import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import '../../lib/Scheduler/feature/EventDragCreate.js';

// https://app.assembla.com/spaces/bryntum/tickets/8750
StartTest(t => {
    let scheduler;

    t.beforeEach(() => {
        scheduler && scheduler.destroy();
        scheduler = null;
    });

    const beforeEventAddHandler = function({ source, eventRecord, resourceRecords }) {
        this.ok(source instanceof Scheduler &&
            eventRecord instanceof EventModel &&
            resourceRecords instanceof Array,
        'Correct event signature of `beforeeventadd`');
    };

    t.it('Event edit feature should fire beforeEventAdd event when Save button is clicked', t => {
        scheduler = t.getScheduler({
            features : {
                eventEdit : true
            }
        });

        scheduler.on({
            beforeeventadd : beforeEventAddHandler,
            thisObj        : t
        });

        t.firesOnce(scheduler, 'beforeeventadd', 'beforeeventadd is fired once');

        const resource = scheduler.resourceStore.first;

        const event = new EventModel({
            name       : 'Foo',
            startDate  : new Date(2011, 0, 4),
            endDate    : new Date(2011, 0, 5),
            resourceId : resource.id
        });

        t.chain(
            {
                waitForEvent : [scheduler, 'beforeeventadd'],
                trigger      : () => scheduler.editEvent(event, resource)
            },
            { waitForSelector : '.b-eventeditor:not(.b-hidden)' },
            next => {
                t.click('button:contains(Save)');
                next();
            },
            { diag : 'Done!' }
        );
    });

    t.it('Scheduler should not fire beforeEventAdd event on scheduledblclick if event edit feature exists before Save button is clicked', t => {
        scheduler = t.getScheduler({
            createEventOnDblClick : true,
            features              : {
                eventEdit : true
            }
        });

        scheduler.on({
            beforeeventadd : beforeEventAddHandler,
            thisObj        : t
        });

        t.isCalledOnce('onEventCreated', scheduler, 'onEventCreated hook is called once');
        t.firesOnce(scheduler, 'beforeeventadd', 'beforeeventadd is fired once');

        t.chain(
            { waitForEventsToRender : null },
            {
                waitForEvent : [scheduler, 'beforeeventadd'],
                trigger      : { dblclick : '.b-sch-timeaxis-cell' }
            },
            { waitFor : () => scheduler.features.eventEdit.editor?.containsFocus },
            { type : 'New test event' },
            next => {
                t.click('button:contains(Save)');
                next();
            },
            { diag : 'Done!' }
        );
    });

    t.it('Scheduler should fire beforeEventAdd event on scheduledblclick if event edit feature does not exist', t => {
        scheduler = t.getScheduler({
            appendTo              : document.body,
            onEventCreated        : ev => ev.name = 'foo',
            createEventOnDblClick : true,
            features              : {
                eventEdit : false
            }
        });

        scheduler.on({
            beforeeventadd : beforeEventAddHandler,
            thisObj        : t
        });

        t.isCalledOnce('onEventCreated', scheduler, 'onEventCreated hook is called once');
        t.firesOnce(scheduler, 'beforeeventadd', 'beforeeventadd is fired once');

        t.chain(
            { dblclick : '.b-sch-timeaxis-cell' },
            { waitForSelector : '.b-sch-event:textEquals(foo)' }
        );
    });

    t.it('Scheduler should not fire beforeEventAdd event on dragcreate if event edit feature exists before Save button is clicked', t => {
        scheduler = t.getScheduler({
            appendTo : document.body,
            features : {
                eventEdit       : true,
                eventDragCreate : true
            }
        });

        scheduler.on({
            beforeeventadd : beforeEventAddHandler,
            thisObj        : t
        });

        t.isCalledOnce('onEventCreated', scheduler, 'onEventCreated hook is called once');
        t.firesOnce(scheduler, 'beforeeventadd', 'beforeeventadd is fired once');

        t.chain(
            {
                waitForEvent : [scheduler, 'beforeeventadd'],
                trigger      : { drag : '.b-sch-timeaxis-cell', fromOffset : [2, 2], by : [100, 0] }
            },
            { waitFor : () => scheduler.features.eventEdit.editor?.containsFocus },
            { type : 'New test event' },
            next => {
                t.click('button:contains(Save)');
                next();
            },
            { diag : 'Done!' }
        );
    });

    t.it('Scheduler should fire beforeEventAdd event on dragcreate if event edit feature does not exist', t => {
        scheduler = t.getScheduler({
            appendTo       : document.body,
            onEventCreated : ev => ev.name = 'foo',
            features       : {
                eventEdit       : false,
                eventDragCreate : true
            }
        });

        scheduler.on({
            beforeeventadd : beforeEventAddHandler,
            thisObj        : t
        });

        t.isCalledOnce('onEventCreated', scheduler, 'onEventCreated hook is called once');
        t.firesOnce(scheduler, 'beforeeventadd', 'beforeeventadd is fired once');

        t.chain(
            { drag : '.b-sch-timeaxis-cell', fromOffset : [2, 2], by : [100, 0] },
            { waitForSelector : '.b-sch-event:textEquals(foo)' }
        );
    });
});
