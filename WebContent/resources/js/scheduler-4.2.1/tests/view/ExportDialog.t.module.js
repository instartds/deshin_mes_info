import { Scheduler, EventStore, ResourceStore, DependencyStore, PresetManager } from '../../build/scheduler.module.js';

StartTest(t => {
    let scheduler;

    t.beforeEach(() => {
        scheduler && scheduler.destroy();
    });

    Object.assign(window, {
        Scheduler,
        EventStore,
        ResourceStore,
        DependencyStore,
        PresetManager
    });

    t.it('Should validate time range in dialog', async t => {
        scheduler = t.getScheduler({
            startDate : new Date(2020, 6, 19),
            endDate   : new Date(2020, 6, 26),
            features  : {
                pdfExport : {
                    exportServer : '/export'
                }
            }
        });

        await scheduler.features.pdfExport.showExportDialog();

        t.chain(
            { click : '.b-schedulerangecombo' },
            { click : 'div:contains(Date range)' },

            { waitForSelector : '[data-ref="rangeStartField"]' },
            async() => {
                const
                    startDateField = document.querySelector('[data-ref="rangeStartField"] .b-field-inner'),
                    endDateField   = document.querySelector('[data-ref="rangeEndField"] .b-field-inner');

                t.isGreaterOrEqual(startDateField.offsetWidth, 80, 'Start date field has some width');
                t.isGreaterOrEqual(endDateField.offsetWidth, 80, 'End date field has some width');
            },

            { click : '[data-ref="rangeStartField"] .b-icon-calendar', desc : 'Expand first picker' },
            { waitForSelector : '.b-calendar-cell.b-out-of-range:contains(26)', desc : 'Max value is set' },

            { click : '[data-ref="rangeEndField"] .b-icon-calendar', desc : 'Expand second picker' },
            { waitForSelector : '.b-calendar-cell.b-out-of-range:contains(17)', desc : 'Min value is set' },

            { click : '.b-calendar-cell:contains(23)', desc : 'Change end date, this should set new max' },
            { click : '[data-ref="rangeStartField"] .b-icon-calendar' },
            { waitForSelector : '.b-calendar-cell.b-out-of-range:contains(23)', desc : 'Max value is updated' },

            { click : '.b-calendar-cell:contains(21)', desc : 'Change start date, this should set new min' },
            { click : '[data-ref="rangeEndField"] .b-icon-calendar' },
            { waitForSelector : '.b-calendar-cell.b-out-of-range:contains(21)', desc : 'Min value is updated' }
        );
    });

    t.it('Hidden columns should not be selected', async t => {
        scheduler = t.getScheduler({
            startDate : new Date(2020, 6, 19),
            endDate   : new Date(2020, 6, 26),
            features  : {
                pdfExport : {
                    exportServer : '/export'
                }
            },
            columns : [
                { field : 'name', id : 'name', text : 'name' },
                { field : 'color', id : 'color', text : 'color' },
                { field : 'age', id : 'age', text : 'age', hidden : true }
            ]
        });

        await scheduler.features.pdfExport.showExportDialog();

        await t.waitForSelector('.b-chip');

        t.selectorCountIs('.b-chip[data-id="age"]', 0, 'Age column is not available for export');

        await t.click('.b-fieldtrigger');

        await t.waitForSelector('.b-list-item:contains(age)');

        await t.click('button:contains(Cancel)');

        scheduler.columns.getAt(1).hidden = true;

        await scheduler.features.pdfExport.showExportDialog();

        await t.waitForSelector('.b-chip');

        t.selectorCountIs('.b-chip[data-id="color"]', 0, 'Color column is not available for export');
        t.selectorCountIs('.b-chip[data-id="age"]', 0, 'Age column is not available for export');

        await t.click('.b-fieldtrigger');

        await t.waitForSelector('.b-list-item:contains(color)');
        await t.waitForSelector('.b-list-item:contains(age)');
    });
});
