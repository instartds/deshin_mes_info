import { ArrayHelper, DomHelper } from '../../../build/scheduler.module.js';

StartTest(t => {
    let scheduler;

    t.beforeEach(t => scheduler && scheduler.destroy());

    t.it('Removing a resource should translate other events to correct positions', async t => {
        scheduler = await t.getSchedulerAsync();

        const
            targetY = DomHelper.getTranslateY(document.querySelector('.event2')), // will be moved up here
            targetX = DomHelper.getTranslateX(document.querySelector('.event3')); // should still have this x

        scheduler.resourceStore.getAt(1).remove();

        t.chain(
            {
                waitFor : () => DomHelper.getTranslateY(document.querySelector('.event3')) === targetY,
                desc    : 'Event moved to correct y'
            },

            () => {
                t.is(DomHelper.getTranslateX(document.querySelector('.event3')), targetX, 'Also at correct x');
            }
        );
    });

    // https://app.assembla.com/spaces/bryntum/tickets/7421
    t.it('Adding an event should not use another events element', async t => {
        scheduler = await t.getSchedulerAsync({
            events : [
                { id : 'e1', resourceId : 'r1', startDate : new Date(2011, 0, 6), duration : 1 }
            ]
        });

        const firstEventElement = document.querySelector(scheduler.eventSelector);

        scheduler.eventStore.add({ id : 'e2', resourceId : 'r1', startDate : new Date(2011, 0, 4), duration : 1 });

        await t.waitForProjectReady();

        t.is(firstEventElement.dataset.eventId, 'e1', 'Element still used for same event');
    });

    // https://app.assembla.com/spaces/bryntum/tickets/7263
    t.it('Assigning an unassigned event should not use another events element', async t => {
        scheduler = await t.getSchedulerAsync({
            events : [
                { id : 'e1', resourceId : 'r1', startDate : new Date(2011, 0, 6), duration : 1 }
            ]
        });

        const firstEventElement = document.querySelector(scheduler.eventSelector);

        const [e2]    = scheduler.eventStore.add({ id : 'e2', startDate : new Date(2011, 0, 4), duration : 1 });
        e2.resourceId = 'r1';

        await t.waitForProjectReady();

        t.is(firstEventElement.dataset.eventId, 'e1', 'Element still used for same event');
    });

    // https://app.assembla.com/spaces/bryntum/tickets/8365
    t.it('Style should be cleared on element reusage', async t => {
        scheduler = await t.getSchedulerAsync({
            startDate : new Date(2011, 0, 1),
            endDate   : new Date(2011, 1, 31),

            events : [
                {
                    id         : 'e1',
                    resourceId : 'r1',
                    startDate  : new Date(2011, 0, 6),
                    duration   : 1,
                    style      : 'background-color : red'
                },
                { id : 'e2', resourceId : 'r1', startDate : new Date(2011, 1, 20), duration : 1 }
            ]
        });

        t.chain(
            { waitForSelector : scheduler.unreleasedEventSelector },
            () => {
                const async = t.beginAsync();

                // Cannot jump there directly, does not reproduce the bug
                function scroll() {
                    scheduler.subGrids.normal.scrollable.x += 400;

                    if (scheduler.subGrids.normal.scrollable.x < 4800) {
                        requestAnimationFrame(scroll);
                    }
                    else {
                        t.notOk(document.querySelector('.b-sch-event').style.backgroundColor, 'Style not set');

                        t.endAsync(async);
                    }
                }

                requestAnimationFrame(scroll);
            }
        );

    });

    t.it('Should derender horizontally early when not using labels or milestones', async t => {
        scheduler = await t.getSchedulerAsync({
            width : 400
        });

        scheduler.scrollLeft = 330;

        await t.waitForAnimationFrame();

        t.selectorNotExists('$event=1', 'Event derendered early');
    });

    // https://github.com/bryntum/support/issues/1873
    t.it('Should not derender horizontally too eagerly when using labels', async t => {
        scheduler = await t.getSchedulerAsync({
            features : {
                labels : {
                    right : 'name'
                }
            },
            width : 400
        });

        scheduler.scrollLeft = 330;

        await t.waitForAnimationFrame();

        t.selectorExists('$event=1 .b-sch-label-right', 'Label still rendered when event is scrolled out of view');

        scheduler.scrollLeft = 480;

        await t.waitForAnimationFrame();

        t.selectorNotExists('$event=1 .b-sch-label-right', 'Now it is properly gone');
    });

    // https://github.com/bryntum/support/issues/1873
    t.it('Should not derender horizontally too eagerly when using milestones', async t => {
        scheduler = await t.getSchedulerAsync({
            width : 400
        });

        scheduler.eventStore.first.duration = 0;

        await scheduler.project.commitAsync();

        scheduler.scrollLeft = 110;

        await t.waitForAnimationFrame();

        t.selectorExists('$event=1', 'Milestone still rendered');

        scheduler.scrollLeft = 260;

        await t.waitForAnimationFrame();

        t.selectorNotExists('$event=1', 'Now it is properly gone');
    });

    t.it('Should refresh UI correctly when setting empty array as assignments', async t => {
        scheduler = t.getScheduler({
            startDate : new Date(2017, 0, 1),
            endDate   : new Date(2017, 0, 2),
            resources : [
                { id : 'r1', name : 'Celia', city : 'Barcelona' },
                { id : 'r2', name : 'Lee', city : 'London' }
            ],
            events : [
                {
                    id        : 1,
                    startDate : new Date(2017, 0, 1, 10),
                    endDate   : new Date(2017, 0, 1, 12),
                    name      : 'Multi assigned',
                    iconCls   : 'b-fa b-fa-users'
                }
            ],
            assignments : [
                { id : 1, resourceId : 'r1', eventId : 1 },
                { id : 2, resourceId : 'r2', eventId : 1 }
            ]
        });

        await t.waitForSelector(scheduler.unreleasedEventSelector);

        scheduler.assignments = [];

        await t.waitForSelectorNotFound(scheduler.unreleasedEventSelector);

        t.pass('Events derendered');
    });

    t.it('Should enable stickyHeader by default', async t => {
        scheduler = t.getScheduler({
            startDate : new Date(2021, 0, 1),
            endDate   : new Date(2021, 2, 1)
        });

        await t.waitForSelector('.b-sch-header-text.b-sticky-header');
        await scheduler.scrollToDate(new Date(2021, 0, 8), { block : 'start' });

        const textNode = t.query('.b-sch-header-text.b-sticky-header')[0];

        t.is(window.getComputedStyle(textNode).position, 'sticky', 'Sticky header enabled');

        t.elementIsTopElement('.b-sch-header-text.b-sticky-header:contains(w.01 Jan 2021)', 'Header cell is sticky');
    });

    t.it('Should support disabling stickyHeader', async t => {
        scheduler = t.getScheduler({
            startDate     : new Date(2021, 0, 1),
            endDate       : new Date(2021, 2, 1),
            stickyHeaders : false
        });

        await t.waitForSelector('.b-sch-header-text');
        await scheduler.scrollToDate(new Date(2021, 0, 8), { block : 'start' });

        t.selectorNotExists('.b-sticky-header');

        const textNode = t.query('.b-sch-header-text')[0];

        t.is(window.getComputedStyle(textNode).position, 'static', 'Sticky header disabled');

        t.elementIsNotTopElement('.b-sch-header-text:contains(w.01 Jan 2021)', 'Header cell is not sticky');
    });

    t.it('Should return visible resources', async t => {
        scheduler = await t.getSchedulerAsync({
            minHeight : null
        });

        t.isDeeply(scheduler.visibleResources, {
            first : scheduler.resourceStore.first,
            last  : scheduler.resourceStore.last
        }, 'All resources visible');

        scheduler.height = 80;

        await t.waitFor(() => scheduler.visibleResources.first === scheduler.visibleResources.last);

        t.isDeeply(scheduler.visibleResources, {
            first : scheduler.resourceStore.first,
            last  : scheduler.resourceStore.first
        }, 'First resource visible only');

        scheduler.scrollTop = 500;

        await t.waitFor(() => scheduler.visibleResources.first === scheduler.resourceStore.last);

        t.isDeeply(scheduler.visibleResources, {
            first : scheduler.resourceStore.last,
            last  : scheduler.resourceStore.last
        }, 'Last resource visible only');
    });

    t.it('Should not render events for rows far out of view', async t => {
        scheduler = await t.getSchedulerAsync({
            events : ArrayHelper.populate(100, i => ({
                id         : i + 1,
                resourceId : i % 20 + 1,
                name       : `Event ${i + 1}`,
                startDate  : '2021-05-03',
                duration   : 48
            })),

            resources : ArrayHelper.populate(20, i => ({
                id   : i + 1,
                name : `Resource ${i + 1}`
            })),

            startDate : '2021-05-03'
        });

        const event = scheduler.unreleasedEventSelector;

        t.selectorNotExists(`${event}[data-resource-id="6"]`, 'No events rendered for resource 6');

        await scheduler.scrollRowIntoView(6);

        await t.waitForAnimationFrame();

        t.selectorExists(`${event}[data-resource-id="6"]`, 'Events rendered for resource 6 after scroll');
        t.selectorExists(`${event}[data-resource-id="7"]`, 'Events rendered for resource 7');
        t.selectorNotExists(`${event}[data-resource-id="8"]`, 'No events rendered for resource 8');
        t.selectorNotExists(`${event}[data-resource-id="1"]`, 'No events rendered for resource 1');
    });
});
