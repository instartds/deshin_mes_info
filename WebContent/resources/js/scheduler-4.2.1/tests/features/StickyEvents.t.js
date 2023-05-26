import DomHelper from '../../lib/Core/helper/DomHelper.js';
import Rectangle from '../../lib/Core/helper/util/Rectangle.js';

StartTest(t => {
    let scheduler;

    t.beforeEach(t => scheduler?.destroy());

    t.it('horizontal', async t => {
        scheduler = t.getScheduler({
            startDate     : '2011-01-03',
            endDate       : '2011-01-23',
            resourceStore : t.getResourceStore2({}, 25)
        }, 200);

        const
            { timeAxisSubGrid } = scheduler,
            { scrollable }      = timeAxisSubGrid;

        const timeAxisViewport = timeAxisSubGrid.element.getBoundingClientRect();

        scheduler.eventStore.add({ startDate : '2011-01-13', endDate : '2011-01-18', name : 'Check vertical scroll', resourceId : 'r20' });

        const checkElementsContent = () => {
            t.query(`${scheduler.unreleasedEventSelector}`, timeAxisSubGrid.element).forEach(e => {
                const
                    ebox = e.getBoundingClientRect(),
                    c    = e.querySelector('.b-sch-event-content'),
                    cbox = c.getBoundingClientRect(),
                    cmargins = DomHelper.getEdgeSize(c, 'margin');

                // If the event bar is showing enough, check that the content is fully visible
                if (ebox.right - (cbox.width + cmargins.width) > timeAxisViewport.left + 2) {
                    t.isGreaterOrEqual(c.getBoundingClientRect().left - cmargins.left, timeAxisViewport.left);
                }
            });
        };

        scrollable.on({ scroll : checkElementsContent });

        await scrollable.scrollTo(scrollable.maxX, null, {
            animate : {
                duration : 2000
            }
        });

        await scrollable.scrollTo(null, scrollable.maxY, {
            animate : {
                duration : 2000
            }
        });
        // check 'Check vertical scroll' event after scroll down
        // https://github.com/bryntum/support/issues/2666
        checkElementsContent();

        await scrollable.scrollTo(0, 0);

        // Waot for render engine to catch up.
        await t.waitForAnimationFrame();

        // After scrolling back, the elements must be in place
        t.query(`${scheduler.unreleasedEventSelector} > * > .b-sch-event-content`, timeAxisSubGrid.element).forEach(e => {
            t.isGreater(e.getBoundingClientRect().left, e.parentNode.parentNode.getBoundingClientRect().left);
        });

        await t.dragBy('.b-sch-event-wrap:contains(Assignment 1)', [-200, 0], null, null, null, true);

        // After dragging, the elements must be in place
        t.query(`${scheduler.unreleasedEventSelector} > * > .b-sch-event-content`, timeAxisSubGrid.element).forEach(e => {
            t.isGreater(e.getBoundingClientRect().left, e.parentNode.parentNode.getBoundingClientRect().left);
        });
    });

    t.it('vertical', async t => {
        scheduler = t.getScheduler({
            mode          : 'vertical',
            startDate     : '2011-01-03',
            endDate       : '2011-01-23',
            resourceStore : t.getResourceStore2({}, 10)
        }, 200);

        const
            { timeAxisSubGrid } = scheduler,
            { scrollable }      = timeAxisSubGrid;

        const timeAxisViewport = timeAxisSubGrid.element.getBoundingClientRect();

        scrollable.on({
            scroll() {
                t.query(`${scheduler.unreleasedEventSelector}`, timeAxisSubGrid.element).forEach(e => {
                    const
                        ebox = e.getBoundingClientRect(),
                        c    = e.querySelector('.b-sch-event-content'),
                        cbox = c.getBoundingClientRect(),
                        cmargins = DomHelper.getEdgeSize(c, 'margin');

                    // If the event bar is showing enough, check that the content is fully visible
                    if (ebox.right - (cbox.height + cmargins.height) > timeAxisViewport.top + 2) {
                        t.isGreaterOrEqual(c.getBoundingClientRect().top - cmargins.top, timeAxisViewport.top);
                    }
                });
            }
        });

        await scrollable.scrollTo(null, scrollable.maxY, {
            animate : {
                duration : 2000
            }
        });

        await scrollable.scrollTo(null, 0);

        // After scrolling back, the elements must be in place
        t.query(`${scheduler.unreleasedEventSelector} > * > .b-sch-event-content`, timeAxisSubGrid.element).forEach(e => {
            t.isGreater(e.getBoundingClientRect().top, e.parentNode.parentNode.getBoundingClientRect().top);
        });
    });

    t.it('Should not crash if events have no content', async t => {
        scheduler = t.getScheduler({
            eventRenderer() {}
        }, 1);

        const
            { timeAxisSubGrid } = scheduler,
            { scrollable }      = timeAxisSubGrid;

        t.waitForEvent(scrollable, 'scrollEnd');
        await scrollable.scrollTo(scrollable.maxX, null);

        t.pass('No crash');
    });

    t.it('Content should be shifted on initial render', async t => {
        scheduler = t.getScheduler({
            startDate     : '2011-01-03',
            endDate       : '2011-01-23',
            resourceStore : t.getResourceStore2({}, 250),
            height        : 700,
            width         : 1000,
            events        : (() => {
                const result = [];

                for (let i = 0; i < 250; i++) {
                    result.push({
                        id         : i,
                        name       : `This is event ${i + 1}`,
                        resourceId : `r${i + 1}`,
                        startDate  : '2010-12-01',
                        endDate    : '2011-12-31'
                    });
                }

                return result;
            })()
        });

        const
            {
                timeAxisSubGrid,
                scrollable
            } = scheduler;

        const timeAxisViewport = Rectangle.from(timeAxisSubGrid.element).intersect(Rectangle.from(scheduler.scrollable.element));

        scrollable.on({
            scroll() {
                t.query(`${scheduler.unreleasedEventSelector}`, timeAxisSubGrid.element).forEach(e => {
                    const
                        ebox     = e.getBoundingClientRect(),
                        c        = e.querySelector('.b-sch-event-content'),
                        cbox     = c.getBoundingClientRect(),
                        cmargins = DomHelper.getEdgeSize(c, 'margin');

                    // If the event bar is showing enough, check that the content is fully visible
                    if (ebox.right - (cbox.width + cmargins.width) > timeAxisViewport.left + 2) {
                        if (c.getBoundingClientRect().left - cmargins.left < timeAxisViewport.left) {
                            t.isGreaterOrEqual(c.getBoundingClientRect().left - cmargins.left, timeAxisViewport.left, `Content visible for #${e.textContent}`);
                        }
                    }
                });
            }
        });

        await scrollable.scrollTo(null, scrollable.maxY, {
            animate : {
                duration : 3500
            }
        });

        await scrollable.scrollTo(0);

        // After scrolling back, the elements must be in place
        t.query(`${scheduler.unreleasedEventSelector} > * > .b-sch-event-content`, timeAxisSubGrid.element).forEach(e => {
            t.isGreater(e.getBoundingClientRect().left, e.parentNode.parentNode.getBoundingClientRect().left, `Content visible for #${e.textContent}`);
        });
    });

    t.it('Should support opt out of stickiness', async t => {
        scheduler = t.getScheduler({
            startDate   : new Date(2011, 0, 5),
            endDate     : new Date(2011, 0, 26),
            visibleDate : {
                date  : new Date(2011, 0, 10),
                block : 'start'
            },
            events : [
                {
                    id             : 1,
                    resourceId     : 'r1',
                    stickyContents : false,
                    startDate      : new Date(2011, 0, 6, 10),
                    duration       : 5,
                    name           : 'non sticky'
                }
            ]
        }, 1);

        await t.waitForSelector(scheduler.unreleasedEventSelector);

        t.isLess(t.query('.b-sch-event-content')[0].getBoundingClientRect().left,
            scheduler.timeAxisSubGridElement.getBoundingClientRect().left, 'Event content out of view');
    });
});
