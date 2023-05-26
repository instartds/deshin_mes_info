import '../../lib/Scheduler/feature/EventDragCreate.js';

StartTest(t => {
    let scheduler;

    t.beforeEach(() => scheduler && scheduler.destroy());

    t.it('Should not be possible to drag create if one is in progress', async t => {
        let dragCreateContext;

        scheduler = await t.getScheduler({
            events : []
        });

        scheduler.on({
            beforedragcreatefinalize({ context }) {
                context.async = true;
                dragCreateContext = context;
            },
            once : true
        });

        t.firesOk({
            observable : scheduler,
            events     : {
                beforedragcreate         : 3,
                dragcreatestart          : 3,
                dragcreateend            : 3,
                afterdragcreate          : 3,
                beforedragcreatefinalize : 3
            }
        });

        t.chain(
            // Kick off a drag create. It will be converted to async, and finalized later
            { drag : '.b-sch-timeaxis-cell', offset : [200, 50], by : [100, 0] },

            // Attempt another drag create while one is in progress - this should not work
            { drag : '.b-sch-timeaxis-cell', offset : [200, 100], by : [100, 0] },

            next => {
                t.is(scheduler.eventStore.count, 1, 'Second attempt to drag create failed');

                // Finish that first dragcreate
                dragCreateContext.finalize(true);

                t.is(scheduler.eventStore.count, 1, 'Only 1 event created');
                next();
            },

            next => {
                scheduler.on({
                    beforedragcreatefinalize({ context }) {
                        context.async = true;
                        dragCreateContext = context;
                    },
                    once : true
                });
                next();
            },

            // This one will also delay completing and creating the second event
            { drag : '.b-sch-timeaxis-cell', offset : [200, 100], by : [100, 0] },

            // These should not create a third event.
            { click : '.b-sch-timeaxis-cell', offset : [200, 150] },
            { drag : '.b-sch-timeaxis-cell', offset : [200, 150], by : [100, 0] },

            // Finish the second delayed dragcreate
            async() => {
                dragCreateContext.finalize(true);

                await t.waitForProjectReady();

                t.is(scheduler.eventStore.count, 2, '2nd event created');
            },

            { drag : '.b-sch-timeaxis-cell', offset : [200, 250], by : [100, 0] },

            () => {
                t.is(scheduler.eventStore.count, 3, '3rd event created');
            }
        );
    });
});
