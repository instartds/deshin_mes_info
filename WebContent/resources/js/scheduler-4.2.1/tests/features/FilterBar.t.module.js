import { Scheduler, EventStore, ResourceStore } from '../../build/scheduler.module.js';

StartTest(t => {
    Object.assign(window, {
        Scheduler,
        EventStore,
        ResourceStore
    });

    let scheduler;

    t.beforeEach(t => {
        scheduler && scheduler.destroy();
    });

    // Events disappear after vertical scroll
    // https://github.com/bryntum/support/issues/1087
    t.it('Should keep events visible after filter and vertical scroll', t => {
        const
            events = [],
            resources = [];

        for (let i = 1; i <= 50; i++) {
            resources.push({
                id   : i,
                name : `Resource ${i}`
            });

            events.push({
                resourceId   : i,
                name         : `Event ${i}`,
                startDate    : `2020-06-29 ${i % 2 ? '01:00:00' : '02:00'}`,
                duration     : 4,
                durationUnit : 'h'
            });
        }

        scheduler = t.getScheduler({
            viewPreset : 'hourAndDay',
            height     : 300,
            features   : {
                filterBar : true,
                stripe    : true
            },

            startDate : new Date(2020, 5, 29),
            endDate   : new Date(2020, 5, 29, 8),

            columns : [
                {
                    text  : 'Name',
                    field : 'name',
                    width : 210 // Width value is picked up to have no horizontal scroll
                }
            ],

            resources,
            events
        });

        t.chain(
            { waitForSelector : scheduler.unreleasedEventSelector },
            async() => {
                await Promise.all([
                    t.type('.b-filter-bar-field input', 'resource'),
                    scheduler.resourceStore.await('filter', { checkLog : false })
                ]);

                scheduler.scrollTop = 50;

                await scheduler.scrollable.await('scrollEnd', { checkLog : false });

                // When horizontal scrollbar appears, one row from the buffer is not rendered,
                // so there are 9 events when scroll bar appears, or 10 events when there is no horizontal scroll
                await t.waitFor({
                    method      : () => t.query(scheduler.unreleasedEventSelector).length >= 9,
                    description : 'Correct amount of events rendered'
                });
            }
        );
    });

    // https://github.com/bryntum/support/issues/2120
    t.it('Should have field name property available on filterable function parameter', t => {
        let propName;

        scheduler = t.getScheduler({
            features : {
                filterBar : true
            },
            columns : [
                {
                    text       : 'Name',
                    field      : 'name',
                    filterable : ({ property }) => {
                        propName = property;
                        return true;
                    }
                }
            ]
        });

        scheduler.store.filter({
            property : 'name',
            value    : 'Mike'
        });

        t.is(propName, 'name', 'Field name property is available with correct value');
    });
});
