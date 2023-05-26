import '../../lib/Scheduler/feature/SimpleEventEdit.js';

StartTest(t => {
    let scheduler;

    t.beforeEach(t => {
        scheduler && scheduler.destroy();
        scheduler = null;
    });

    t.it('Should show editor on event dblclick', async t => {
        scheduler = await t.getSchedulerAsync({
            features : {
                eventEdit       : false,
                simpleEventEdit : true
            },
            events : [
                {
                    resourceId : 'r1'
                }
            ]
        });

        scheduler.eventStore.first.startDate = scheduler.startDate;
        scheduler.eventStore.first.duration = 1;

        t.firesOnce(scheduler.features.simpleEventEdit, 'beforestart');
        t.firesOnce(scheduler.features.simpleEventEdit, 'start');
        t.firesOnce(scheduler.features.simpleEventEdit, 'beforecomplete');
        t.firesOnce(scheduler.features.simpleEventEdit, 'complete');

        t.chain(
            { dblclick : '.b-sch-event' },

            // This is a test for a bug which was masked by turbo mode.
            // Focus would bounce out of the editor due to the Navigator mistaking
            // focusing the editor for a TAB out.  Give it a chance to exhibit bad behaviour.
            // Focus should remain in the editor.
            { waitFor : 500 },

            { waitFor : () => scheduler.features.simpleEventEdit.editor?.containsFocus },

            { type : 'Foo[ENTER]' },

            () => {
                t.is(scheduler.eventStore.first.name, 'Foo', 'Name set');
            }
        );
    });

    t.it('Should start edit on Enter', async t => {
        scheduler = await t.getSchedulerAsync({
            features : {
                eventEdit       : false,
                simpleEventEdit : true
            },
            events : [
                {
                    resourceId : 'r1'
                }
            ]
        });

        scheduler.eventStore.first.startDate = scheduler.startDate;
        scheduler.eventStore.first.duration = 1;

        t.willFireNTimes(scheduler.features.simpleEventEdit, 'beforestart', 2);
        t.willFireNTimes(scheduler.features.simpleEventEdit, 'start', 2);
        t.willFireNTimes(scheduler.features.simpleEventEdit, 'beforecomplete', 2);
        t.willFireNTimes(scheduler.features.simpleEventEdit, 'complete', 2);

        t.chain(
            { click : '.b-sch-event' },
            { type : '[ENTER]' },

            // This is a test for a bug which was masked by turbo mode.
            // Focus would bounce out of the editor due to the Navigator mistaking
            // focusing the editor for a TAB out.  Give it a chance to exhibit bad behaviour.
            // Focus should remain in the editor.
            { waitFor : 500 },

            { waitForSelector : '.b-editor input:focus' },

            { type : 'foo[ENTER]' },

            (next) => {
                t.selectorNotExists('.b-sch-dragcreator-proxy');
                t.is(scheduler.eventStore.first.name, 'foo', 'Name set');

                next();
            },

            { type : '[ENTER]' },
            { waitForSelector : '.b-editor input:focus' },
            { type : 'bar[ENTER]' },

            () => {
                t.selectorNotExists('.b-sch-dragcreator-proxy');
                t.is(scheduler.eventStore.first.name, 'foobar', 'Name updated');
            }
        );
    });

    t.it('Should edit name on dblclick', async t => {
        scheduler = await t.getSchedulerAsync({
            features : {
                eventEdit       : false,
                simpleEventEdit : true
            },
            events : []
        });

        t.firesOnce(scheduler.features.simpleEventEdit, 'beforestart');
        t.firesOnce(scheduler.features.simpleEventEdit, 'start');
        t.firesOnce(scheduler.features.simpleEventEdit, 'beforecomplete');
        t.firesOnce(scheduler.features.simpleEventEdit, 'complete');

        t.chain(
            { dblclick : '.b-sch-timeaxis-cell' },

            // This is a test for a bug which was masked by turbo mode.
            // Focus would bounce out of the editor due to the Navigator mistaking
            // focusing the editor for a TAB out.  Give it a chance to exhibit bad behaviour.
            // Focus should remain in the editor.
            { waitFor : 500 },

            { type : 'Foo[ENTER]' },
            () => {
                t.selectorNotExists('.b-sch-dragcreator-proxy');
                t.is(scheduler.eventStore.count, 1);
                t.is(scheduler.eventStore.first.name, 'Foo');
            }
        );
    });

    t.it('Should not edit name on dblclick if readOnly', async t => {
        scheduler = await t.getSchedulerAsync({
            readOnly : true,
            features : {
                eventEdit       : false,
                simpleEventEdit : true
            },
            events : []
        });

        t.chain(
            { dblclick : '.b-sch-timeaxis-cell' },

            // Nothing should happen so we cannot wait for an event
            { waitFor : 300 },

            () => {
                t.selectorNotExists('.b-editor', 'Editor correctly not started');
            }
        );
    });

    t.it('Should edit name on drag create', async t => {
        scheduler = await t.getSchedulerAsync({
            features : {
                eventEdit       : false,
                simpleEventEdit : true
            },
            events : []
        });

        t.firesOnce(scheduler.features.simpleEventEdit, 'beforestart');
        t.firesOnce(scheduler.features.simpleEventEdit, 'start');
        t.firesOnce(scheduler.features.simpleEventEdit, 'beforecomplete');
        t.firesOnce(scheduler.features.simpleEventEdit, 'complete');

        t.chain(
            { drag : '.b-sch-timeaxis-cell', by : [100, 0] },
            { waitForSelector : '.b-editor input:focus' },
            { type : 'bar[ENTER]' },

            () => {
                t.selectorNotExists('.b-sch-dragcreator-proxy');
                t.is(scheduler.eventStore.count, 1);
                t.is(scheduler.eventStore.first.name, 'bar');
            }
        );
    });

    t.it('Should cancel on Escape', async t => {
        scheduler = await t.getSchedulerAsync({
            features : {
                eventEdit       : false,
                simpleEventEdit : true
            },
            events : []
        });

        t.firesOnce(scheduler.features.simpleEventEdit, 'beforestart');
        t.firesOnce(scheduler.features.simpleEventEdit, 'start');
        t.firesOnce(scheduler.features.simpleEventEdit, 'beforecancel');
        t.firesOnce(scheduler.features.simpleEventEdit, 'cancel');

        t.chain(
            { dblclick : '.b-sch-timeaxis-cell' },
            { type : 'Foo[ESCAPE]' },
            () => {
                t.selectorNotExists('.b-sch-dragcreator-proxy');
            }
        );
    });

    t.it('Should support disabling', async t => {
        scheduler = await t.getSchedulerAsync({
            features : {
                eventEdit       : false,
                simpleEventEdit : true
            }
        });

        scheduler.features.simpleEventEdit.disabled = true;

        t.chain(
            { dblClick : '.b-sch-event' },

            next => {
                t.selectorNotExists('input', 'Not editing');

                scheduler.features.simpleEventEdit.disabled = false;

                next();
            },

            { dblClick : '.b-sch-event' },

            // https://github.com/bryntum/support/issues/292
            { type : '[RIGHT]', target : 'input:focus' },

            () => {
                t.selectorExists('input', 'Editing');
            }
        );
    });

    t.it('Event should be removed upon cancel', async t => {
        scheduler = await t.getSchedulerAsync({
            viewPreset : 'hourAndDay',
            features   : {
                eventEdit       : false,
                simpleEventEdit : true
            },
            events : []
        });

        t.chain(
            { drag : '.b-sch-timeaxis-cell', offset : [100, '50%'], by : [60, 0] },
            { waitForSelector : '.b-editor input:focus', desc : 'Editor is visible' },
            { type : '[ESCAPE]' },
            { waitForSelectorNotFound : '.b-sch-event-wrap:not(.b-released)' },
            () => {
                t.notOk(scheduler.eventStore.count, 'Event not finally added');
            }
        );
    });
});
