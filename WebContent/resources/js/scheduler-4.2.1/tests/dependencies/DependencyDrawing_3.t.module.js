import { Scheduler } from '../../build/scheduler.module.js';

StartTest(t => {
    let scheduler;

    t.beforeEach(t => {
        if (scheduler) {
            scheduler.destroy();
            scheduler = null;
        }
    });

    async function getScheduler(config = {}) {
        return await t.getSchedulerAsync(Object.assign({
            startDate : '2011-01-03',
            endDate   : '2011-01-09',
            features  : {
                dependencies : true
            },

            columns : [],

            events : [
                {
                    id        : 1,
                    name      : 'Event 1',
                    startDate : '2011-01-04',
                    duration  : 2
                },
                {
                    id        : 2,
                    name      : 'Event 2',
                    startDate : '2011-01-05 23:00:00',
                    duration  : 2
                },
                {
                    id        : 3,
                    name      : 'Event 3',
                    startDate : '2011-01-04',
                    duration  : 2
                },
                {
                    id        : 4,
                    name      : 'Event 4',
                    startDate : '2011-01-05',
                    duration  : 2
                }
            ],

            assignments : [
                { id : 1, event : 1, resource : 'r2' },
                { id : 2, event : 2, resource : 'r2' },
                { id : 3, event : 3, resource : 'r4' },
                { id : 4, event : 4, resource : 'r4' },
                { id : 5, event : 1, resource : 'r6' }
            ],

            dependencies : [
                { id : 1, from : 1, to : 4 }
            ]
        }, config));
    }

    t.it('Scheduler should draw dependencies loaded via CRUD-manager', t => {

        let depsDrawn = 0;

        scheduler = new Scheduler({
            appendTo : document.body,
            width    : 615,
            height   : 400,

            columns : [
                { field : 'name', text : 'Name' }
            ],

            features : {
                dependencies : true
            },

            viewPreset : {
                base           : 'hourAndDay',
                tickWidth      : 25,
                columnLinesFor : 0,
                headers        : [
                    {
                        unit       : 'd',
                        align      : 'center',
                        dateFormat : 'ddd DD MMM'
                    },
                    {
                        unit       : 'h',
                        align      : 'center',
                        dateFormat : 'HH'
                    }
                ]
            },

            startDate : new Date(2017, 11, 1),
            endDate   : new Date(2017, 11, 3),

            crudManager : {
                autoLoad  : true,
                transport : {
                    load : {
                        url : 'dependencies/data/227_dependency_drawing_3.json'
                    }
                }
            },

            listeners : {
                dependenciesDrawn() {
                    depsDrawn++;
                }
            }
        });

        t.chain(
            { waitForEventsToRender : null },
            { waitFor : () => depsDrawn > 0 },
            { waitForSelector : '.b-sch-dependency' }
        );
    });

    t.it('Should clear dependency from cache when assignment is removed (w/o CrudManager)', async t => {
        scheduler = await t.getSchedulerAsync({
            events : [
                {
                    id        : 1,
                    startDate : '2011-01-04',
                    endDate   : '2011-01-05',
                    name      : 'Multi assigned A'
                },
                {
                    id        : 2,
                    startDate : '2011-01-06',
                    endDate   : '2011-01-07',
                    name      : 'Multi assigned B'
                }
            ],
            assignments : [
                {
                    id         : 1,
                    resourceId : 'r1',
                    eventId    : 1
                },
                {
                    id         : 2,
                    resourceId : 'r3',
                    eventId    : 1
                },
                {
                    id         : 3,
                    resourceId : 'r5',
                    eventId    : 1
                },
                {
                    id         : 4,
                    resourceId : 'r2',
                    eventId    : 2
                },
                {
                    id         : 5,
                    resourceId : 'r4',
                    eventId    : 2
                }
            ],
            dependencies : [
                {
                    id   : 1,
                    from : 1,
                    to   : 2
                }
            ]
        });

        await t.waitForSelector('.b-sch-dependency');

        scheduler.assignments[0].remove();

        scheduler.features.dependencies.scheduleDraw();

        await scheduler.await('dependenciesdrawn');

        t.selectorCountIs('.b-sch-dependency', 4, 'Correct amount of dependency lines drawn');
    });

    t.it('Should clear dependency from cache when assignment is removed (w/ CrudManager)', async t => {
        t.mockUrl('load', {
            responseText : JSON.stringify({
                success   : true,
                resources : {
                    rows : [
                        { id : 'r1', name : 'Resource 1' },
                        { id : 'r2', name : 'Resource 2' },
                        { id : 'r3', name : 'Resource 3' },
                        { id : 'r4', name : 'Resource 4' },
                        { id : 'r5', name : 'Resource 5' }
                    ]
                },
                events : {
                    rows : [
                        {
                            id        : 1,
                            startDate : '2011-01-04',
                            endDate   : '2011-01-05',
                            name      : 'Multi assigned A'
                        },
                        {
                            id        : 2,
                            startDate : '2011-01-06',
                            endDate   : '2011-01-07',
                            name      : 'Multi assigned B'
                        }
                    ]
                },
                assignments : {
                    rows : [
                        {
                            id         : 1,
                            resourceId : 'r1',
                            eventId    : 1
                        },
                        {
                            id         : 2,
                            resourceId : 'r3',
                            eventId    : 1
                        },
                        {
                            id         : 3,
                            resourceId : 'r5',
                            eventId    : 1
                        },
                        {
                            id         : 4,
                            resourceId : 'r2',
                            eventId    : 2
                        },
                        {
                            id         : 5,
                            resourceId : 'r4',
                            eventId    : 2
                        }
                    ]
                },
                dependencies : {
                    rows : [
                        {
                            id   : 1,
                            from : 1,
                            to   : 2
                        }
                    ]
                }
            })
        });

        scheduler = new Scheduler({
            appendTo  : document.body,
            width     : 600,
            height    : 400,
            startDate : '2011-01-02',
            endDate   : '2011-01-07',

            features : {
                dependencies : true
            },

            crudManager : {
                autoLoad  : true,
                transport : {
                    load : {
                        url : 'load'
                    }
                }
            }
        });

        await t.waitForProjectReady(scheduler);

        await t.waitForSelector('.b-sch-dependency');

        scheduler.assignments[0].remove();

        scheduler.features.dependencies.scheduleDraw();

        await scheduler.await('dependenciesdrawn');

        t.selectorCountIs('.b-sch-dependency', 4, 'Correct amount of dependency lines drawn');
    });

    t.it('Should align dependency line with row boundary during dragdrop', async t => {
        scheduler = await getScheduler();

        t.chain(
            { waitForSelector : '.b-sch-dependency' },

            async() => {
                t.assertHorizontalBreakOnRowBorder(scheduler, {
                    dependencyId   : 1,
                    rowId          : 'r2',
                    assignmentData : {
                        from : { id : 1 },
                        to   : { id : 4 }
                    }
                });

                t.assertHorizontalBreakOnRowBorder(scheduler, {
                    dependencyId   : 1,
                    rowId          : 'r5',
                    assignmentData : {
                        from : { id : 5 },
                        to   : { id : 4 }
                    }
                });
            },

            {
                drag     : '[data-assignment-id="1"]',
                by       : [-100, 0],
                dragOnly : true,
                desc     : 'Drag event in a same row'
            },

            async() => {
                t.assertHorizontalBreakOnRowBorder(scheduler, {
                    dependencyId   : 1,
                    rowId          : 'r2',
                    assignmentData : {
                        from : { id : 1 },
                        to   : { id : 4 }
                    }
                });
            },

            { moveMouseBy : [0, 80], desc : 'Drag event to new row' },

            async() => {
                t.assertHorizontalBreakOnRowBorder(scheduler, {
                    dependencyId   : 1,
                    rowId          : 'r3',
                    assignmentData : {
                        from : { id : 1 },
                        to   : { id : 4 }
                    }
                });
            },

            { moveMouseBy : [-80, 0], desc : 'Drag event to the left, it should not have extra segments' },

            async() => {
                t.assertHorizontalBreakOnRowBorder(scheduler, {
                    dependencyId   : 1,
                    rowId          : 'r3',
                    assignmentData : {
                        from : { id : 1 },
                        to   : { id : 4 }
                    }
                });
            },

            { mouseUp : null },

            async() => {
                t.assertHorizontalBreakOnRowBorder(scheduler, {
                    dependencyId   : 1,
                    rowId          : 'r3',
                    assignmentData : {
                        from : { id : 1 },
                        to   : { id : 4 }
                    }
                });
            }
        );
    });

    t.it('Should draw line correctly on row height change', async t => {
        scheduler = await getScheduler();

        async function assertDependencies() {
            t.assertHorizontalBreakOnRowBorder(scheduler, {
                dependencyId   : 1,
                rowId          : 'r2',
                assignmentData : {
                    from : { id : 1 },
                    to   : { id : 4 }
                }
            });

            t.assertHorizontalBreakOnRowBorder(scheduler, {
                dependencyId   : 1,
                rowId          : 'r5',
                assignmentData : {
                    from : { id : 5 },
                    to   : { id : 4 }
                }
            });
        }

        t.chain(
            { waitForSelector : '.b-sch-dependency' },

            async() => {
                await assertDependencies();

                scheduler.rowHeight += 20;

                await scheduler.await('dependenciesdrawn');

                await assertDependencies();

                scheduler.rowHeight -= 35;

                await scheduler.await('dependenciesdrawn');

                await assertDependencies();
            }
        );
    });
});
