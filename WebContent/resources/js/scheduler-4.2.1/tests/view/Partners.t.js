import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import TimeAxisViewModel from '../../lib/Scheduler/view/model/TimeAxisViewModel.js';
import TimeAxis from '../../lib/Scheduler/data/TimeAxis.js';

StartTest(t => {
    const
        resources     = [
            { id : 1, name : 'Arcady' }
        ],
        timeAxisSpy   = t.spyOn(TimeAxis.prototype, 'construct').callThrough(),
        timeAxisVMSpy = t.spyOn(TimeAxisViewModel.prototype, 'construct').callThrough();

    let firstScheduler, secondScheduler, thirdScheduler;

    async function setup() {
        timeAxisSpy.reset();
        timeAxisVMSpy.reset();

        firstScheduler = await t.getSchedulerAsync({
            id       : 'top-scheduler',
            appendTo : document.body,
            height   : 200,

            columns : [{
                text  : 'Staff',
                width : '10em',
                field : 'name'
            }],

            resources : resources,

            startDate  : new Date(2018, 0, 1, 6),
            endDate    : new Date(2018, 0, 1, 20),
            viewPreset : 'minuteAndHour',
            style      : 'margin-bottom:20px'
        });

        secondScheduler = new Scheduler({
            id          : 'bottom-scheduler',
            appendTo    : document.body,
            height      : 200,
            partner     : firstScheduler,
            hideHeaders : true,

            columns : [{
                text  : 'Staff',
                width : '10em',
                field : 'name'
            }],

            resourceStore : firstScheduler.resourceStore
        });

        // Wait for resize listeners which happen on layout
        await t.waitForAnimationFrame();
    }

    t.beforeEach(() => {
        firstScheduler && !firstScheduler.isDestroyed && firstScheduler.destroy();
        secondScheduler && !secondScheduler.isDestroyed && secondScheduler.destroy();
        thirdScheduler && !thirdScheduler.isDestroyed && thirdScheduler.destroy();
    });

    t.it('Scroll should be synced', async t => {
        await setup();

        t.chain(
            async() => {
                firstScheduler.subGrids.normal.scrollable.x = 100;

                await secondScheduler.subGrids.normal.scrollable.await('scrollEnd', { checkLog : false });
            },

            {
                waitFor : () => t.samePx(secondScheduler.subGrids.normal.scrollable.x, 100),
                desc    : 'Bottom partner scroll is ok'
            },

            async() => {
                secondScheduler.subGrids.normal.scrollable.x = 50;

                await firstScheduler.subGrids.normal.header.scrollable.await('scrollEnd', { checkLog : false });
            },

            {
                waitFor : () => t.samePx(firstScheduler.subGrids.normal.scrollable.x, 50),
                desc    : 'Top partner scroll is ok'
            },

            async() => {
                // Should be able to destroy a partner with no errors
                secondScheduler.destroy();

                firstScheduler.subGrids.normal.scrollable.x = 100;

                // Wait for the scroll event to fire. Nothing should happen
                // if the link has been broken property upon destruction
                await firstScheduler.subGrids.normal.scrollable.await('scroll', { checkLog : false });
            }
        );
    });

    t.it('Width + collapsed state should be synced', async t => {
        await setup();

        t.chain(
            next => {
                // All these events must occur before we can proceed to the next phase of the test
                t.waitForGridEvents([
                    [firstScheduler.subGrids.locked, 'resize'],
                    [firstScheduler.subGrids.normal, 'resize'],
                    [secondScheduler.subGrids.locked, 'resize'],
                    [secondScheduler.subGrids.normal, 'resize']
                ], next);

                firstScheduler.subGrids.locked.width += 20;
            },

            next => {
                t.is(secondScheduler.subGrids.locked.width, firstScheduler.subGrids.locked.width, 'Width sync #1');

                // All these events must occur before we can proceed to the next phase of the test
                t.waitForGridEvents([
                    [firstScheduler.subGrids.locked, 'resize'],
                    [firstScheduler.subGrids.normal, 'resize'],
                    [secondScheduler.subGrids.locked, 'resize'],
                    [secondScheduler.subGrids.normal, 'resize']
                ], next);

                secondScheduler.subGrids.locked.width += 20;
            },

            next => {
                t.is(secondScheduler.subGrids.locked.width, firstScheduler.subGrids.locked.width, 'Width sync #2');

                // All these events must occur before we can proceed to the next phase of the test
                t.waitForGridEvents([
                    [firstScheduler.subGrids.locked, 'resize'],
                    [firstScheduler.subGrids.normal, 'resize'],
                    [secondScheduler.subGrids.locked, 'resize'],
                    [secondScheduler.subGrids.normal, 'resize']
                ], next);

                secondScheduler.subGrids.locked.collapse();
            },

            // Check that collapse has happened in both grids.
            // Then check that we can destroy a partner with no errors
            () => {
                t.is(secondScheduler.subGrids.locked.collapsed, firstScheduler.subGrids.locked.collapsed, 'Collapse sync');

                t.ok(firstScheduler.subGrids.locked.collapsed, 'Top scheduler has collapsed the locked part');
                t.ok(secondScheduler.subGrids.locked.collapsed, 'Bottom scheduler has collapsed the locked part in synchrony');

                // Should be able to destroy a partner with no errors
                secondScheduler.destroy();
            }
        );
    });

    t.it('Should support changing partnerships at runtime', async t => {
        await setup();

        t.ok(firstScheduler.isPartneredWith(secondScheduler), 'Partnered');
        t.ok(secondScheduler.isPartneredWith(firstScheduler), 'Partnered');

        firstScheduler.removePartner(secondScheduler);

        t.notOk(firstScheduler.isPartneredWith(secondScheduler), 'Not Partnered');
        t.notOk(secondScheduler.isPartneredWith(firstScheduler), 'Not Partnered');

        firstScheduler.subGrids.normal.scrollable.x += 100;

        // wait some small amount to ensure no scrolling happens
        await t.waitFor(100);

        t.is(secondScheduler.subGrids.normal.scrollable.x, 0, 'Bottom scroll not affected');

        firstScheduler.addPartner(secondScheduler);

        await t.waitFor(() => secondScheduler.subGrids.normal.scrollable.x === 100);

        t.ok(firstScheduler.isPartneredWith(secondScheduler), 'Partnered');
        t.ok(secondScheduler.isPartneredWith(firstScheduler), 'Partnered');

        t.pass('Re-partnered, scroll is synced');

        firstScheduler.removePartner(secondScheduler);

        // Now let's pair second to another scheduler
        thirdScheduler = new Scheduler({
            id          : 'thirdScheduler',
            appendTo    : document.body,
            height      : 200,
            hideHeaders : true,

            columns : [{
                text  : 'Staff',
                width : '10em',
                field : 'name'
            }],

            resources : [
                {
                    name : 'Bengt'
                }
            ]
        });

        thirdScheduler.addPartner(secondScheduler);

        t.notOk(firstScheduler.isPartneredWith(secondScheduler), '1st not partnered with 2nd');
        t.ok(thirdScheduler.isPartneredWith(secondScheduler), '3rd partnered with 2nd');

        secondScheduler.subGrids.normal.scrollable.x = 200;
        await t.waitFor(() => thirdScheduler.subGrids.normal.scrollable.x === 200);

        t.is(firstScheduler.subGrids.normal.scrollable.x, 100, 'First scheduler did not react');
    });

    t.it('Should sync all state after zoom', async t => {
        await setup();

        function assertViewPresets() {
            // Delete reference to scheduler from event to avoid traversing every property of scheduler
            delete firstScheduler.viewPreset.options.event.source;
            delete secondScheduler.viewPreset.options.event.source;

            t.is(firstScheduler.viewPreset, secondScheduler.viewPreset);
            t.is(firstScheduler.startDate, secondScheduler.startDate);
            t.is(firstScheduler.endDate, secondScheduler.endDate);
            // not using t.is here, because in IE11 it will start traversing every property and eventually result in error
            t.ok(firstScheduler.timeAxisViewModel === secondScheduler.timeAxisViewModel);
        }

        assertViewPresets();
        t.is(firstScheduler.subGrids.normal.scrollable.x, secondScheduler.subGrids.normal.scrollable.x);

        t.chain(
            async() => {
                firstScheduler.zoomOut();
                assertViewPresets();
            },

            { waitFor : () => firstScheduler.subGrids.normal.scrollable.x = secondScheduler.subGrids.normal.scrollable.x },

            async() => {
                secondScheduler.zoomIn();
                assertViewPresets();
            },

            { waitFor : () => firstScheduler.subGrids.normal.scrollable.x = secondScheduler.subGrids.normal.scrollable.x },

            () => {
                t.expect(timeAxisSpy).toHaveBeenCalled(1);
                t.expect(timeAxisVMSpy).toHaveBeenCalled(1);
            }
        );
    });

    t.it('Should properly update timeAxisViewModel when adding partner at runtime', async t => {
        const config = {
            appendTo : document.body,
            height   : 200,

            columns : [{
                text  : 'Staff',
                width : '10em',
                field : 'name'
            }],

            resources : resources,

            startDate  : new Date(2018, 0, 1, 6),
            endDate    : new Date(2018, 0, 1, 20),
            viewPreset : 'minuteAndHour',
            style      : 'margin-bottom:20px'
        };

        firstScheduler = new Scheduler(Object.assign({
            id : 'firstScheduler'
        }, config));

        secondScheduler = new Scheduler(Object.assign({
            id : 'secondScheduler'
        }, config));

        secondScheduler.partner = firstScheduler;

        await t.click('#secondScheduler .b-sch-header-timeaxis-cell');

        firstScheduler.zoomOut();

        t.is(secondScheduler.timeAxisColumn.width, firstScheduler.timeAxisColumn.width, 'Time axis column width is ok');
    });
});
