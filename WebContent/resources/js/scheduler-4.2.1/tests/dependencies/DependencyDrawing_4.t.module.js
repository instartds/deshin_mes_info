import { Rectangle } from '../../build/scheduler.module.js';

StartTest(t => {
    let scheduler, startVerticalMargin, /*startArrowMargin, */horizontalMargin;

    t.beforeEach(t => {
        if (scheduler) {
            scheduler.destroy();
            scheduler = null;
        }
    });

    async function getScheduler(config = {}) {
        scheduler = await t.getSchedulerAsync(Object.assign({
            startDate : '2011-01-03',
            endDate   : '2011-01-09',
            features  : {
                dependencies : true
            },
            // should be divisible by 3
            tickSize : 180,

            rowHeight : 60,
            barMargin : 14,

            columns : []
        }, config));

        startVerticalMargin = scheduler.barMargin / 2;

        ({ /*startArrowMargin, */horizontalMargin } = scheduler.features.dependencies.pathFinder);
    }

    function getPointFromSide(side, box) {
        switch (side) {
            case 'top':
                return [box.x + box.width / 2, box.top];
            case 'right':
                return [box.right, box.top + box.height / 2];
            case 'bottom':
                return [box.x + box.width / 2, box.bottom];
            case 'left':
                return [box.left, box.top + box.height / 2];
        }
    }

    function convertPathToPoints(dependency, path) {
        const
            startSide    = scheduler.features.dependencies.getDependencyStartSide(dependency),
            endSide      = scheduler.features.dependencies.getDependencyEndSide(dependency),
            sourceBox    = Rectangle.from(scheduler.getElementFromEventRecord(dependency.fromEvent, undefined, true), scheduler.foregroundCanvas),
            targetBox    = Rectangle.from(scheduler.getElementFromEventRecord(dependency.toEvent, undefined, true), scheduler.foregroundCanvas),
            startPoint   = getPointFromSide(startSide, sourceBox),
            endPoint     = getPointFromSide(endSide, targetBox),
            points       = [startPoint];

        path = path.slice();

        path.forEach((step, i) => {
            let [x, y] = points[points.length - 1],
                direction, length;

            // If array passed, take some steps
            if (Array.isArray(step)) {
                [direction, length] = step;

                switch (direction) {
                    case 'l':
                        x -= length;
                        break;
                    case 'r':
                        x += length;
                        break;
                    case 'u':
                        y -= length;
                        break;
                    case 'd':
                        y += length;
                        break;
                }
            }
            // otherwise just take coordinate from end point
            else {
                switch (step) {
                    case 'l':
                        x = endPoint[0];
                        break;
                    case 'r':
                        x = endPoint[0];
                        break;
                    case 'u':
                        y = endPoint[1];
                        break;
                    case 'd':
                        y = endPoint[1];
                        break;
                }
            }

            points.push([x, y]);
        });

        return points.map(point => point.join(',')).join(' ');
    }

    /**
     * Idea is to generate array of points which should match dependency line points. Points are provided by the user.
     * e.g.: walkDependency(1, [
     *  ['r', 12],  // First segment should move right 12 px
     *  ['d', 100], // next one should move down 100px
     *  ['l', 300], // then left 300px, moving to the left of start point, no negative coordinates needed
     *  'u',        // short for *move up to the end point vertical coordinate*
     *  'r'         // short for *move right to the end point horizontal coordinate*
     * ])
     *
     * @param {*} t Test instance
     * @param {Scheduler.model.DependencyModel|String|Number} dependencyOrId Model or its id
     * @param {[direction, length][]} path Dependency path. Two dimensional array, first value is direction: u,d,l,r
     * second value is length of the segment in pixels
     */
    function walkDependency(t, dependencyOrId, path) {
        const
            dependency   = dependencyOrId.isModel ? dependencyOrId : scheduler.dependencyStore.getById(dependencyOrId),
            dependencyEl = scheduler.getElementForDependency(dependency),
            points       = dependencyEl.getAttribute('points'),
            expected     = convertPathToPoints(dependency, path);

        t.is(points, expected, `Dependency ${dependency.id} path is ok`);
    }

    t.it('in-row dependency lines are drawn correctly (from bottom)', async t => {
        await getScheduler({
            events : [
                {
                    id         : 1,
                    resourceId : 'r1',
                    name       : 'Event 1',
                    startDate  : '2011-01-04',
                    duration   : 1
                },
                {
                    id         : '1-1',
                    resourceId : 'r1',
                    name       : 'Event 1-1',
                    startDate  : '2011-01-03 04:00',
                    duration   : 2
                },
                {
                    id         : '1-2',
                    resourceId : 'r1',
                    name       : 'Event 1-2',
                    startDate  : '2011-01-03 16:00',
                    duration   : 2
                },
                {
                    id         : '1-3',
                    resourceId : 'r1',
                    name       : 'Event 1-3',
                    startDate  : '2011-01-04',
                    duration   : 1
                },
                {
                    id         : '1-4',
                    resourceId : 'r1',
                    name       : 'Event 1-4',
                    startDate  : '2011-01-04 12:00',
                    duration   : 2
                },
                {
                    id         : '1-5',
                    resourceId : 'r1',
                    name       : 'Event 1-5',
                    startDate  : '2011-01-04 20:00',
                    duration   : 2
                },
                {
                    id         : '1-6',
                    resourceId : 'r1',
                    name       : 'Event 1-6',
                    startDate  : '2011-01-06',
                    duration   : 2
                }
            ],

            dependencies : [
                { id : '1:1-1', from : '1', to : '1-1', fromSide : 'bottom' },
                { id : '1:1-2', from : '1', to : '1-2', fromSide : 'bottom' },
                { id : '1:1-3', from : '1', to : '1-3', fromSide : 'bottom' },
                { id : '1:1-4', from : '1', to : '1-4', fromSide : 'bottom' },
                { id : '1:1-5', from : '1', to : '1-5', fromSide : 'bottom' },
                { id : '1:1-6', from : '1', to : '1-6', fromSide : 'bottom' }
            ]
        });

        const { endArrowMargin } = scheduler.features.dependencies.pathFinder;

        function assertDependencies() {
            const pxPerHour = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60);

            walkDependency(t, '1:1-1', [
                ['d', startVerticalMargin],                   // first line down should be to half bar margin, to be between two vertical events
                ['l', 32 * pxPerHour + endArrowMargin], // next point is 32 hours prior to source start, add arrow margin too
                'u',
                'r'
            ]);

            walkDependency(t, '1:1-2', [
                ['d', startVerticalMargin],
                ['l', 20 * pxPerHour + endArrowMargin],
                'u',
                'r'
            ]);

            walkDependency(t, '1:1-3', [
                ['d', startVerticalMargin],
                ['l', 12 * pxPerHour + endArrowMargin],
                'd',
                'r'
            ]);

            walkDependency(t, '1:1-4', [
                ['d', startVerticalMargin],
                ['l', endArrowMargin],
                'd',
                'r'
            ]);

            walkDependency(t, '1:1-5', [
                'd',
                'r'
            ]);

            walkDependency(t, '1:1-6', [
                ['d', startVerticalMargin],
                ['r', 12 * pxPerHour + horizontalMargin],
                'u',
                'r'
            ]);
        }

        t.chain(
            { waitForSelector : '.b-sch-dependency' },

            async() => {
                assertDependencies();

                t.diag('Change row height');

                scheduler.rowHeight -= 10;

                await scheduler.await('dependenciesdrawn');

                assertDependencies();

                t.diag('Change bar margin');

                startVerticalMargin = 4;
                scheduler.barMargin = 8;

                await scheduler.await('dependenciesdrawn');

                assertDependencies();

                t.diag('Make all deps bidirectional, start arrow margin should return back');

                scheduler.dependencies.forEach(d => d.bidirectional = true);

                await scheduler.await('dependenciesdrawn');

                startVerticalMargin = endArrowMargin;
                scheduler.barMargin = 20;

                await scheduler.await('dependenciesdrawn');

                assertDependencies();
            }
        );
    });

    t.it('in-row dependency lines are drawn correctly (from top)', async t => {
        await getScheduler({
            events : [
                {
                    id         : 1,
                    resourceId : 'r1',
                    name       : 'Event 1',
                    startDate  : '2011-01-04',
                    duration   : 1
                },
                {
                    id         : '1-1',
                    resourceId : 'r1',
                    name       : 'Event 1-1',
                    startDate  : '2011-01-03 04:00',
                    duration   : 2
                },
                {
                    id         : '1-2',
                    resourceId : 'r1',
                    name       : 'Event 1-2',
                    startDate  : '2011-01-03 16:00',
                    duration   : 2
                },
                {
                    id         : '1-3',
                    resourceId : 'r1',
                    name       : 'Event 1-3',
                    startDate  : '2011-01-04',
                    duration   : 1
                },
                {
                    id         : '1-4',
                    resourceId : 'r1',
                    name       : 'Event 1-4',
                    startDate  : '2011-01-04 12:00',
                    duration   : 2
                },
                {
                    id         : '1-5',
                    resourceId : 'r1',
                    name       : 'Event 1-5',
                    startDate  : '2011-01-04 20:00',
                    duration   : 2
                },
                {
                    id         : '1-6',
                    resourceId : 'r1',
                    name       : 'Event 1-6',
                    startDate  : '2011-01-06',
                    duration   : 2
                }
            ],

            dependencies : [
                { id : '1:1-1', from : '1', to : '1-1', fromSide : 'top' },
                { id : '1:1-2', from : '1', to : '1-2', fromSide : 'top' },
                { id : '1:1-3', from : '1', to : '1-3', fromSide : 'top' },
                { id : '1:1-4', from : '1', to : '1-4', fromSide : 'top' },
                { id : '1:1-5', from : '1', to : '1-5', fromSide : 'top' },
                { id : '1:1-6', from : '1', to : '1-6', fromSide : 'top' }
            ]
        });

        const { endArrowMargin } = scheduler.features.dependencies.pathFinder;

        function assertDependencies() {
            const pxPerHour = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60);

            walkDependency(t, '1:1-1', [
                ['u', startVerticalMargin],
                ['l', 32 * pxPerHour + endArrowMargin],
                'u',
                'r'
            ]);

            walkDependency(t, '1:1-2', [
                ['u', startVerticalMargin],
                ['l', 20 * pxPerHour + endArrowMargin],
                'u',
                'r'
            ]);

            walkDependency(t, '1:1-3', [
                ['u', startVerticalMargin],
                ['l', 12 * pxPerHour + endArrowMargin],
                'd',
                'r'
            ]);

            walkDependency(t, '1:1-4', [
                ['u', startVerticalMargin],
                ['l', 12 * pxPerHour + horizontalMargin],
                'd',
                'r'
            ]);

            walkDependency(t, '1:1-5', [
                ['u', startVerticalMargin],
                ['l', 12 * pxPerHour + horizontalMargin],
                'd',
                'r'
            ]);

            walkDependency(t, '1:1-6', [
                'u',
                'r'
            ]);
        }

        t.chain(
            { waitForSelector : '.b-sch-dependency' },

            async() => {
                assertDependencies();

                t.diag('Change row height');

                scheduler.rowHeight -= 10;

                await scheduler.await('dependenciesdrawn');

                assertDependencies();

                t.diag('Change bar margin');

                startVerticalMargin = 4;
                scheduler.barMargin = 8;

                await scheduler.await('dependenciesdrawn');

                assertDependencies();
            }
        );
    });

    t.it('in-row dependency lines are drawn correctly (from left)', async t => {
        await getScheduler({
            events : [
                {
                    id         : 1,
                    resourceId : 'r1',
                    name       : 'Event 1',
                    startDate  : '2011-01-04',
                    duration   : 1
                },
                {
                    id         : '1-1',
                    resourceId : 'r1',
                    name       : 'Event 1-1',
                    startDate  : '2011-01-03 04:00',
                    duration   : 2
                },
                {
                    id         : '1-2',
                    resourceId : 'r1',
                    name       : 'Event 1-2',
                    startDate  : '2011-01-03 16:00',
                    duration   : 2
                },
                {
                    id         : '1-3',
                    resourceId : 'r1',
                    name       : 'Event 1-3',
                    startDate  : '2011-01-04',
                    duration   : 1
                },
                {
                    id         : '1-4',
                    resourceId : 'r1',
                    name       : 'Event 1-4',
                    startDate  : '2011-01-04 12:00',
                    duration   : 2
                },
                {
                    id         : '1-5',
                    resourceId : 'r1',
                    name       : 'Event 1-5',
                    startDate  : '2011-01-04 20:00',
                    duration   : 2
                },
                {
                    id         : '1-6',
                    resourceId : 'r1',
                    name       : 'Event 1-6',
                    startDate  : '2011-01-06',
                    duration   : 2
                }
            ],

            dependencies : [
                { id : '1:1-1', from : '1', to : '1-1', fromSide : 'left' },
                { id : '1:1-2', from : '1', to : '1-2', fromSide : 'left' },
                { id : '1:1-3', from : '1', to : '1-3', fromSide : 'left' },
                { id : '1:1-4', from : '1', to : '1-4', fromSide : 'left' },
                { id : '1:1-5', from : '1', to : '1-5', fromSide : 'left' },
                { id : '1:1-6', from : '1', to : '1-6', fromSide : 'left' }
            ]
        });

        const { endArrowMargin } = scheduler.features.dependencies.pathFinder;

        function assertDependencies() {
            const pxPerHour = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60);

            walkDependency(t, '1:1-1', [
                ['l', 20 * pxPerHour + endArrowMargin],
                'u',
                'r'
            ]);

            walkDependency(t, '1:1-2', [
                ['l', 8 * pxPerHour + endArrowMargin],
                'u',
                'r'
            ]);

            walkDependency(t, '1:1-3', [
                ['l', endArrowMargin],
                'd',
                'r'
            ]);

            walkDependency(t, '1:1-4', [
                ['l', endArrowMargin],
                'd',
                'r'
            ]);

            walkDependency(t, '1:1-5', [
                ['l', endArrowMargin],
                'd',
                'r'
            ]);

            walkDependency(t, '1:1-6', [
                ['l', endArrowMargin],
                'u',
                'r'
            ]);
        }

        t.chain(
            { waitForSelector : '.b-sch-dependency' },

            async() => {
                assertDependencies();

                t.diag('Change row height');

                scheduler.rowHeight -= 10;

                await scheduler.await('dependenciesdrawn');

                assertDependencies();

                t.diag('Change bar margin');

                startVerticalMargin = 4;
                scheduler.barMargin = 8;

                await scheduler.await('dependenciesdrawn');

                assertDependencies();
            }
        );
    });

    t.it('in-row dependency lines are drawn correctly (from right)', async t => {
        await getScheduler({
            events : [
                {
                    id         : 1,
                    resourceId : 'r1',
                    name       : 'Event 1',
                    startDate  : '2011-01-04',
                    duration   : 1
                },
                {
                    id         : '1-1',
                    resourceId : 'r1',
                    name       : 'Event 1-1',
                    startDate  : '2011-01-03 04:00',
                    duration   : 2
                },
                {
                    id         : '1-2',
                    resourceId : 'r1',
                    name       : 'Event 1-2',
                    startDate  : '2011-01-03 16:00',
                    duration   : 2
                },
                {
                    id         : '1-3',
                    resourceId : 'r1',
                    name       : 'Event 1-3',
                    startDate  : '2011-01-04',
                    duration   : 1
                },
                {
                    id         : '1-4',
                    resourceId : 'r1',
                    name       : 'Event 1-4',
                    startDate  : '2011-01-04 12:00',
                    duration   : 2
                },
                {
                    id         : '1-5',
                    resourceId : 'r1',
                    name       : 'Event 1-5',
                    startDate  : '2011-01-04 20:00',
                    duration   : 2
                },
                {
                    id         : '1-6',
                    resourceId : 'r1',
                    name       : 'Event 1-6',
                    startDate  : '2011-01-06',
                    duration   : 2
                }
            ],

            dependencies : [
                { id : '1:1-1', from : '1', to : '1-1', fromSide : 'right' },
                { id : '1:1-2', from : '1', to : '1-2', fromSide : 'right' },
                { id : '1:1-3', from : '1', to : '1-3', fromSide : 'right' },
                { id : '1:1-4', from : '1', to : '1-4', fromSide : 'right' },
                { id : '1:1-5', from : '1', to : '1-5', fromSide : 'right' },
                { id : '1:1-6', from : '1', to : '1-6', fromSide : 'right' }
            ]
        });

        const { endArrowMargin } = scheduler.features.dependencies.pathFinder;

        function assertDependencies() {
            const
                pxPerHour   = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60),
                eventHeight = document.querySelector(scheduler.unreleasedEventSelector).offsetHeight;

            walkDependency(t, '1:1-1', [
                ['r', endArrowMargin],
                ['u', eventHeight / 2 + startVerticalMargin],
                ['l', 44 * pxPerHour + endArrowMargin * 2],
                'u',
                'r'
            ]);

            walkDependency(t, '1:1-2', [
                ['r', endArrowMargin],
                ['u', eventHeight / 2 + startVerticalMargin],
                ['l', 32 * pxPerHour + endArrowMargin * 2],
                'u',
                'r'
            ]);

            walkDependency(t, '1:1-3', [
                ['r', endArrowMargin],
                ['d', eventHeight / 2 + startVerticalMargin],
                ['l', 24 * pxPerHour + endArrowMargin * 2],
                'd',
                'r'
            ]);

            walkDependency(t, '1:1-4', [
                ['r', endArrowMargin],
                ['d', eventHeight / 2 + startVerticalMargin],
                ['l', 12 * pxPerHour + endArrowMargin * 2],
                'd',
                'r'
            ]);

            walkDependency(t, '1:1-5', [
                ['r', endArrowMargin],
                ['d', eventHeight / 2 + startVerticalMargin],
                ['l', 4 * pxPerHour + endArrowMargin * 2],
                'd',
                'r'
            ]);

            walkDependency(t, '1:1-6', [
                ['r', endArrowMargin],
                'u',
                'r'
            ]);
        }

        t.chain(
            { waitForSelector : '.b-sch-dependency' },

            async() => {
                assertDependencies();

                t.diag('Change row height');

                scheduler.rowHeight -= 10;

                await scheduler.await('dependenciesdrawn');

                assertDependencies();

                t.diag('Change bar margin');

                startVerticalMargin = 4;
                scheduler.barMargin = 8;

                await scheduler.await('dependenciesdrawn');

                assertDependencies();
            }
        );
    });

    t.it('out-row dependency lines are drawn correctly (from right)', async t => {
        await getScheduler({
            events : [
                {
                    id         : 1,
                    resourceId : 'r1',
                    name       : 'Event 1',
                    startDate  : '2011-01-04',
                    duration   : 2
                },
                {
                    id         : '1-1',
                    resourceId : 'r1',
                    name       : 'Event 1-1',
                    startDate  : '2011-01-04 04:00',
                    duration   : 0.5
                },
                {
                    id         : '1-2',
                    resourceId : 'r1',
                    name       : 'Event 1-2',
                    startDate  : '2011-01-05',
                    duration   : 2
                },
                {
                    id         : '2-1',
                    resourceId : 'r2',
                    name       : 'Event 2-1',
                    startDate  : '2011-01-04 04:00',
                    duration   : 0.5
                },
                {
                    id         : '2-2',
                    resourceId : 'r2',
                    name       : 'Event 2-2',
                    startDate  : '2011-01-05',
                    duration   : 2
                }
            ],

            dependencies : [
                { id : '1:1-1', from : 1, to : '1-1', type : 0 },
                { id : '1:1-2', from : 1, to : '1-2' },
                { id : '1:2-1', from : 1, to : '2-1', type : 0 },
                { id : '1:2-2', from : 1, to : '2-2' }
            ]
        });

        t.chain(
            { waitForSelector : '.b-sch-dependency' },

            async() => {
                const
                    { endArrowMargin } = scheduler.features.dependencies.pathFinder,
                    pxPerHour          = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60),
                    eventHeight        = document.querySelector(scheduler.unreleasedEventSelector).offsetHeight;

                walkDependency(t, '1:1-1', [
                    ['l', endArrowMargin],
                    'd',
                    'r'
                ]);

                walkDependency(t, '1:1-2', [
                    ['r', endArrowMargin],
                    ['d', startVerticalMargin + eventHeight / 2],
                    ['l', 24 * pxPerHour + endArrowMargin * 2],
                    'd',
                    'r'
                ]);

                walkDependency(t, '1:2-1', [
                    ['l', endArrowMargin],
                    'd',
                    'r'
                ]);

                walkDependency(t, '1:2-2', [
                    ['r', endArrowMargin],
                    // half event, full event, two bar margins, row border
                    ['d', startVerticalMargin * 4 + eventHeight * 1.5 + 1],
                    ['l', 24 * pxPerHour + endArrowMargin * 2],
                    'd',
                    'r'
                ]);
            }
        );
    });

    t.it('out-row dependency lines are drawn correctly (from top)', async t => {
        await getScheduler({
            events : [
                {
                    id         : 1,
                    resourceId : 'r1',
                    name       : 'Event 1',
                    startDate  : '2011-01-04',
                    duration   : 2
                },
                {
                    id         : '1-1',
                    resourceId : 'r1',
                    name       : 'Event 1-1',
                    startDate  : '2011-01-04 04:00',
                    duration   : 0.5
                },
                {
                    id         : '1-2',
                    resourceId : 'r1',
                    name       : 'Event 1-2',
                    startDate  : '2011-01-05',
                    duration   : 2
                },
                {
                    id         : '2-1',
                    resourceId : 'r2',
                    name       : 'Event 2-1',
                    startDate  : '2011-01-04 04:00',
                    duration   : 0.5
                },
                {
                    id         : '2-2',
                    resourceId : 'r2',
                    name       : 'Event 2-2',
                    startDate  : '2011-01-05',
                    duration   : 2
                }
            ],

            dependencies : [
                { id : '1:1-1', from : 1, to : '1-1', fromSide : 'top' },
                { id : '1:1-2', from : 1, to : '1-2', fromSide : 'top', toSide : 'right' },
                { id : '1:2-1', from : 1, to : '2-1', fromSide : 'top' },
                { id : '1:2-2', from : 1, to : '2-2', fromSide : 'top', toSide : 'right' }
            ]
        });

        t.chain(
            { waitForSelector : '.b-sch-dependency' },

            async() => {
                const
                    { endArrowMargin } = scheduler.features.dependencies.pathFinder,
                    pxPerHour          = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60);

                walkDependency(t, '1:1-1', [
                    ['u', startVerticalMargin],
                    ['l', 24 * pxPerHour + horizontalMargin],
                    'd',
                    'r'
                ]);

                walkDependency(t, '1:1-2', [
                    ['u', startVerticalMargin],
                    ['r', 48 * pxPerHour + endArrowMargin],
                    'd',
                    'r'
                ]);

                walkDependency(t, '1:2-1', [
                    ['u', startVerticalMargin * 2],
                    ['l', 24 * pxPerHour + endArrowMargin],
                    'd',
                    'r'
                ]);

                walkDependency(t, '1:2-2', [
                    ['u', startVerticalMargin * 2],
                    ['r', 48 * pxPerHour + endArrowMargin],
                    'd',
                    'r'
                ]);
            }
        );
    });

    t.it('out-row dependency lines are drawn correctly (from bottom)', async t => {
        await getScheduler({
            events : [
                {
                    id         : 1,
                    resourceId : 'r1',
                    name       : 'Event 1',
                    startDate  : '2011-01-04',
                    duration   : 2
                },
                {
                    id         : '1-1',
                    resourceId : 'r1',
                    name       : 'Event 1-1',
                    startDate  : '2011-01-04 04:00',
                    duration   : 0.5
                },
                {
                    id         : '1-2',
                    resourceId : 'r1',
                    name       : 'Event 1-2',
                    startDate  : '2011-01-05',
                    duration   : 2
                },
                {
                    id         : '2-1',
                    resourceId : 'r2',
                    name       : 'Event 2-1',
                    startDate  : '2011-01-04 04:00',
                    duration   : 0.5
                },
                {
                    id         : '2-2',
                    resourceId : 'r2',
                    name       : 'Event 2-2',
                    startDate  : '2011-01-05',
                    duration   : 2
                }
            ],

            dependencies : [
                { id : '1:1-1', from : 1, to : '1-1', fromSide : 'bottom' },
                { id : '1:1-2', from : 1, to : '1-2', fromSide : 'bottom', toSide : 'right' },
                { id : '1:2-1', from : 1, to : '2-1', fromSide : 'bottom' },
                { id : '1:2-2', from : 1, to : '2-2', fromSide : 'bottom', toSide : 'right' }
            ]
        });

        t.chain(
            { waitForSelector : '.b-sch-dependency' },

            async() => {
                const
                    { endArrowMargin } = scheduler.features.dependencies.pathFinder,
                    pxPerHour          = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60),
                    eventHeight        = document.querySelector(scheduler.unreleasedEventSelector).offsetHeight;

                walkDependency(t, '1:1-1', [
                    ['d', startVerticalMargin],
                    ['l', 20 * pxPerHour + endArrowMargin],
                    'd',
                    'r'
                ]);

                walkDependency(t, '1:1-2', [
                    ['d', startVerticalMargin],
                    ['r', 48 * pxPerHour + endArrowMargin],
                    'd',
                    'r'
                ]);

                walkDependency(t, '1:2-1', [
                    // two bar margins, full event, row border
                    ['d', startVerticalMargin * 4 + eventHeight + 1],
                    ['l', 20 * pxPerHour + endArrowMargin],
                    'd',
                    'r'
                ]);

                walkDependency(t, '1:2-2', [
                    // two bar margins, full event, row border
                    ['d', startVerticalMargin * 4 + eventHeight + 1],
                    ['r', 48 * pxPerHour + endArrowMargin],
                    'd',
                    'r'
                ]);
            }
        );
    });
});
