import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import '../../lib/Grid/column/TreeColumn.js';
import '../../lib/Grid/feature/Tree.js';

StartTest(t => {
    let scheduler;

    t.beforeEach(t => scheduler?.destroy());

    async function createScheduler() {
        scheduler = new Scheduler({
            appendTo              : document.body,
            useInitialAnimation   : false,
            enableEventAnimations : false,
            features              : {
                tree : true
            },
            columns : [
                {
                    type  : 'tree',
                    text  : 'Name',
                    width : 220,
                    field : 'name'
                }
            ],
            resources : [
                {
                    id       : 1,
                    name     : 'A',
                    expanded : true,
                    children : [
                        { id : 11, name : 'AA' },
                        { id : 12, name : 'AB' },
                        { id : 13, name : 'AC' }
                    ]
                },
                {
                    id       : 2,
                    name     : 'B',
                    expanded : false,
                    children : [
                        { id : 21, name : 'BA' },
                        { id : 22, name : 'BB' }
                    ]
                }
            ],
            startDate : new Date(2018, 5, 1),
            endDate   : new Date(2018, 5, 8),
            events    : [
                { id : 1, resourceId : 1, startDate : new Date(2018, 5, 1), duration : 1 },
                { id : 2, resourceId : 11, startDate : new Date(2018, 5, 1), duration : 2 },
                { id : 3, resourceId : 12, startDate : new Date(2018, 5, 1), duration : 3 },
                { id : 4, resourceId : 2, startDate : new Date(2018, 5, 1), duration : 4 },
                { id : 5, resourceId : 22, startDate : new Date(2018, 5, 1), duration : 5 },
                { id : 6, resourceId : 22, startDate : new Date(2018, 5, 1), duration : 6 },
                { id : 7, resourceId : 22, startDate : new Date(2018, 5, 1), duration : 7 }
            ]
        });

        await t.waitForProjectReady();
    }

    t.it('Expand/collapse should work', async t => {
        await createScheduler();

        const spy = t.spyOn(scheduler, 'runWithTransition');

        t.selectorCountIs(scheduler.unreleasedEventSelector, 4, 'Correct number of events initially');

        await scheduler.collapse(1);

        t.selectorCountIs(scheduler.unreleasedEventSelector, 2, 'Correct number of events after collapse');

        await scheduler.expand(1);

        t.selectorCountIs(scheduler.unreleasedEventSelector, 4, 'Correct number of events after expand');

        await scheduler.collapseAll();

        t.selectorCountIs(scheduler.unreleasedEventSelector, 2, 'Correct number of events after collapse all');

        await scheduler.expandAll();

        t.selectorCountIs(scheduler.unreleasedEventSelector, 7, 'Correct number of events after expand all');

        await scheduler.collapseAll();

        t.selectorCountIs(scheduler.unreleasedEventSelector, 2, 'Correct number of events after collapse all');

        t.ok(spy.calls.allArgs().every(a => a[1] === false), 'No transition triggered');
    });

    // https://app.assembla.com/spaces/bryntum/tickets/7770
    t.it('Removing parent should remove events', async t => {
        await createScheduler();

        scheduler.resourceStore.first.remove();

        await t.waitForProjectReady();

        t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Correct number of events rendered after remove');
    });

    t.it('Converting a leaf node to a parent should only rerender the affected row', async t => {
        await createScheduler();

        const aa = scheduler.resourceStore.getAt(1);

        // Converting a resource to a parent only renders that row
        t.willFireNTimes(scheduler.rowManager, 'renderRow', 1);

        t.ok(aa.isLeaf);

        aa.appendChild({
            name : 'AAA'
        });

        await t.waitForProjectReady();

        t.notOk(aa.isLeaf);
    });

    // https://app.assembla.com/spaces/bryntum/tickets/9110
    t.it('Should be possible to change events which are not available (inside collapsed resource when there is no rows below)', async t => {
        scheduler = new Scheduler({
            appendTo : document.body,
            features : {
                tree : true
            },
            columns : [
                {
                    type  : 'tree',
                    text  : 'Name',
                    field : 'name',
                    width : 220
                }
            ],
            resources : [
                {
                    id       : 1,
                    name     : 'Parent',
                    expanded : true,
                    children : [
                        { id : 2, name : 'Child' }
                    ]
                }
            ],
            startDate : new Date(2018, 5, 1),
            endDate   : new Date(2018, 5, 8),
            events    : [
                { id : 1, resourceId : 2, startDate : new Date(2018, 5, 1), duration : 2 }
            ]
        });

        await t.waitForProjectReady();

        const record = scheduler.eventStore.first;

        await scheduler.collapse(1);

        record.name = 'test';

        await scheduler.expand(1);

        t.selectorExists('.b-sch-event:textEquals(test)', 'Event name is updated');
    });

    // https://github.com/bryntum/support/issues/243
    t.it('Should be possible to load rows on demand', t => {
        t.mockUrl('load', {
            responseText : JSON.stringify({
                success : true,
                data    : [{
                    id       : 1,
                    name     : 'foo',
                    children : true
                }]
            })
        });

        scheduler = new Scheduler({
            appendTo : document.body,
            features : {
                tree : true
            },
            columns : [
                {
                    type  : 'tree',
                    text  : 'Name',
                    field : 'name',
                    width : 220
                }
            ],
            resourceStore : {
                tree     : true,
                autoLoad : true,
                fields   : ['model', 'color', 'year', 'rating'],

                readUrl : 'load'
            },
            startDate : new Date(2018, 5, 1),
            endDate   : new Date(2018, 5, 8),
            events    : [
                { id : 1, resourceId : 1, name : 'event 1', startDate : new Date(2018, 5, 1), duration : 2 },
                { id : 2, resourceId : 2, name : 'event 2', startDate : new Date(2018, 5, 1), duration : 2 }
            ]
        });

        t.chain(
            { waitForSelector : '.b-sch-event:contains(event 1)' },

            next => {
                t.mockUrl('load', {
                    responseText : JSON.stringify({
                        success : true,
                        data    : [{
                            id   : 2,
                            name : 'bar'
                        }]
                    })
                });

                next();
            },

            () => scheduler.expand(1),

            { waitForSelector : '.b-grid-cell:contains(bar)' },
            { waitForSelector : '.b-sch-event:contains(event 2)' }
        );
    });
});
