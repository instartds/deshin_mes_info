import DateHelper from '../../../lib/Core/helper/DateHelper.js';
import DomHelper from '../../../lib/Core/helper/DomHelper.js';
import Rectangle from '../../../lib/Core/helper/util/Rectangle.js';
import Override from '../../../lib/Core/mixin/Override.js';
import DataGenerator from '../../../lib/Core/helper/util/DataGenerator.js';
import RandomGenerator from '../../../lib/Core/helper/util/RandomGenerator.js';
import { PaperFormat, RowsRange } from '../../../lib/Grid/feature/export/Utils.js';
import '../../../lib/Scheduler/feature/export/PdfExport.js';
import '../../../lib/Scheduler/feature/Dependencies.js';
import '../../../lib/Grid/column/RowNumberColumn.js';
import { ScheduleRange } from '../../../lib/Scheduler/feature/export/Utils.js';

StartTest(t => {
    let scheduler, paperHeight, rowsPerPage;

    Object.assign(window, {
        DateHelper,
        DomHelper,
        Override,
        DataGenerator,
        RandomGenerator,
        PaperFormat,
        Rectangle
    });

    t.overrideAjaxHelper();

    window.DEBUG = true;

    t.beforeEach(() => {
        scheduler && scheduler.destroy();
    });

    t.it('Should export scheduler to multiple pages', async t => {
        const
            verticalPages = 3,
            horizontalPages = 2,
            totalPages = verticalPages * horizontalPages;

        ({ scheduler, paperHeight, rowsPerPage } = await t.createSchedulerForExport({
            startDate : new Date(2019, 10, 4),
            endDate   : new Date(2019, 11, 9),
            verticalPages,
            horizontalPages
        }));

        t.chain(
            async() => {
                const html = await t.getExportHtml(scheduler, {
                    columns       : scheduler.columns.visibleColumns.map(c => c.id),
                    exporterType  : 'multipage',
                    scheduleRange : 'completeview'
                });

                t.is(html.length, totalPages, `${totalPages} pages are exported`);

                for (let i = 0; i < html.length; i++) {
                    const { document : doc, iframe } = await t.setIframeAsync({
                        height : paperHeight,
                        html   : html[i].html
                    });

                    t.ok(t.assertRowsExportedWithoutGaps(doc, i % verticalPages !== 0, true), `Rows exported without gaps on page ${i}`);

                    if (i % verticalPages === 0) {
                        t.ok(t.assertTicksExportedWithoutGaps(doc), `Ticks exported without gaps on page ${i}`);
                    }

                    const
                        { startDate, endDate } = t.getDateRangeFromExportedPage(doc),
                        events = scheduler.eventStore.query(record => {
                            return DateHelper.intersectSpans(record.startDate, record.endDate, startDate, endDate) &&
                                record.resourceId > rowsPerPage * (i % verticalPages) - 1 &&
                                record.resourceId < rowsPerPage * (i % verticalPages + 1) - 1;
                        });

                    t.ok(t.assertExportedEventsList(doc, events), `All required events found on the page ${i}`);

                    iframe.remove();
                }
            }
        );
    });

    t.it('Should export specific range of dates', async t => {
        const
            horizontalPages = 3,
            verticalPages   = 1,
            // expected to export only 2 pages with given range
            totalPages      = 2,
            rangeStart      = new Date(2019, 10, 11),
            rangeEnd        = new Date(2019, 10, 25);

        ({ scheduler, paperHeight } = await t.createSchedulerForExport({
            horizontalPages,
            verticalPages,
            startDate : new Date(2019, 10, 4),
            endDate   : new Date(2019, 11, 9)
        }));

        t.chain(
            async() => {
                const html = await t.getExportHtml(scheduler, {
                    columns       : scheduler.columns.visibleColumns.map(c => c.id),
                    exporterType  : 'multipage',
                    scheduleRange : 'daterange',
                    rangeStart    : rangeStart,
                    rangeEnd      : rangeEnd
                });

                t.is(html.length, totalPages, `${totalPages} page exported`);

                for (let i = 0; i < totalPages; i++) {
                    const { document : doc, iframe } = await t.setIframeAsync({
                        height : paperHeight,
                        html   : html[i].html
                    });

                    t.ok(t.assertRowsExportedWithoutGaps(doc, false, true), 'Rows exported without gaps');
                    t.ok(t.assertTicksExportedWithoutGaps(doc), 'Ticks exported without gaps');

                    const
                        { startDate, endDate }  = t.getDateRangeFromExportedPage(doc),
                        tickCount               = 7 * 2,
                        tickWidth               = scheduler.tickSize,
                        lockedGridWidth         = scheduler.subGrids.locked.scrollable.scrollWidth,
                        normalGridWidth         = tickCount * tickWidth,
                        splitterWidth           = scheduler.resolveSplitter('locked').offsetWidth,
                        schedulerEl             = doc.querySelector('.b-scheduler'),
                        normalGridEl            = doc.querySelector('.b-grid-subgrid-normal'),
                        normalGridBox           = Rectangle.from(normalGridEl),
                        normalHeaderEl          = doc.querySelector('.b-grid-headers-normal'),
                        { firstTick, lastTick } = t.getFirstLastVisibleTicks(doc);

                    t.is(schedulerEl.offsetWidth, lockedGridWidth + normalGridWidth + splitterWidth, 'Scheduler width is ok');
                    t.is(normalGridEl.offsetWidth, normalGridWidth, 'Normal grid width is ok');
                    t.is(normalHeaderEl.offsetWidth, normalGridWidth, 'Normal header width is ok');

                    if (i === 0) {
                        t.is(firstTick.dataset.tickIndex, '0', 'First visible tick index is ok');
                        t.is(lastTick.dataset.tickIndex, '3', 'Last visible tick index is ok');
                    }
                    else {
                        t.is(firstTick.dataset.tickIndex, '3', 'First visible tick index is ok');
                        t.is(lastTick.dataset.tickIndex, '13', 'Last visible tick index is ok');
                    }

                    // find first event which is fit completely into the exported range
                    const event = scheduler.eventStore.find(r => DateHelper.intersectSpans(startDate, endDate, r.startDate, r.endDate));

                    if (event) {
                        const
                            exportedEventEl    = doc.querySelector(`[data-event-id="${event.id}"]`),
                            exportedEventBox   = exportedEventEl.getBoundingClientRect(),
                            scale              = exportedEventBox.width / exportedEventEl.offsetWidth,
                            eventStartCoord    = DateHelper.getDurationInUnit(rangeStart, event.startDate, 'd') * tickWidth * scale,
                            expectedStartCoord = normalGridBox.left + eventStartCoord;

                        t.is(Math.round(exportedEventBox.left), Math.round(expectedStartCoord - (event.isMilestone ? exportedEventBox.height : 0) / 2), 'Event is positioned properly horizontally');
                    }

                    iframe.remove();
                }
            }
        );
    });

    t.it('Should export dependencies to multiple pages', async t => {
        const
            verticalPages = 3,
            horizontalPages = 2,
            totalPages = verticalPages * horizontalPages;

        ({ scheduler, paperHeight, rowsPerPage } = await t.createSchedulerForExport({
            verticalPages,
            horizontalPages,
            featuresConfig : {
                dependencies : true
            }
        }));

        t.chain(
            next => {
                scheduler.dependencyStore.filter(r => !(r.toOutside || r.fromOutside));
                scheduler.on({
                    dependenciesDrawn : next,
                    once              : true
                });
            },
            async() => {
                const html = await t.getExportHtml(scheduler, {
                    columns       : scheduler.columns.visibleColumns.map(c => c.id),
                    exporterType  : 'multipage',
                    scheduleRange : 'completeview'
                });

                t.is(html.length, totalPages, `${totalPages} pages are exported`);

                for (let i = 0; i < html.length; i++) {
                    const { document : doc, iframe } = await t.setIframeAsync({
                        height : paperHeight,
                        html   : html[i].html
                    });

                    const
                        { startDate, endDate } = t.getDateRangeFromExportedPage(doc),
                        events = scheduler.eventStore.query(record => {
                            return DateHelper.intersectSpans(record.startDate, record.endDate, startDate, endDate) &&
                                record.resourceId > rowsPerPage * (i % verticalPages) - 1 &&
                                record.resourceId < rowsPerPage * (i % verticalPages + 1) - 1;
                        }),
                        dependencies = scheduler.dependencyStore.query(r => {
                            return events.includes(r.fromEvent) || events.includes(r.toEvent);
                        });

                    t.ok(events.length, `Some events found on page ${i}`);
                    t.ok(dependencies.length, `Some dependencies found on page ${i}`);

                    t.ok(t.assertExportedEventDependenciesList(doc, dependencies), `Dependencies exported correctly on page ${i}`);

                    iframe.remove();
                }
            }
        );
    });

    t.it('Should export visible rows', async t => {
        ({ scheduler, paperHeight } = await t.createSchedulerForExport({
            verticalPages   : 2,
            horizontalPages : 2,
            rowsPerPage     : 20,
            height          : 800
        }));

        // Add more events to change average row height
        const lastVisibleRowIndex = scheduler.rowManager.rows.findIndex(row => row.top >= scheduler.bodyHeight);

        scheduler.resourceStore.forEach((resource, index) => {
            if (index >= lastVisibleRowIndex && scheduler.getRow(index)) {
                scheduler.eventStore.add(resource.events[1].copy());
                scheduler.eventStore.add(resource.events[1].copy());
            }
        });

        let pages = await t.getExportHtml(scheduler, {
            exporterType : 'multipage',
            rowsRange    : RowsRange.visible
        });

        t.is(pages.length, 2, '2 pages exported');

        for (let i = 0; i < pages.length; i++) {
            const { document, iframe } = await t.setIframeAsync({
                html   : pages[i].html,
                height : paperHeight
            });

            t.is(document.querySelectorAll('.b-timeline-subgrid .b-grid-row').length, lastVisibleRowIndex, 'Correct amount of exported rows');

            iframe.remove();
        }

        pages = await t.getExportHtml(scheduler, {
            exporterType  : 'multipagevertical',
            rowsRange     : RowsRange.visible,
            scheduleRange : ScheduleRange.currentview
        });

        t.is(pages.length, 1, '1 pages exported');

        for (let i = 0; i < pages.length; i++) {
            const { document, iframe } = await t.setIframeAsync({
                html   : pages[i].html,
                height : paperHeight
            });

            t.is(document.querySelectorAll('.b-timeline-subgrid .b-grid-row').length, lastVisibleRowIndex, 'Correct amount of exported rows');

            iframe.remove();
        }
    });
});
