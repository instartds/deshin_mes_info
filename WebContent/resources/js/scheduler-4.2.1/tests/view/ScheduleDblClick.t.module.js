
StartTest(t => {
    let scheduler;

    t.beforeEach(() => scheduler && scheduler.destroy());

    t.it('Should create event and show event editor', async t => {
        scheduler = await t.getSchedulerAsync({
            features : {
                eventEdit : true
            },
            viewPreset : 'hourAndDay',
            startDate  : new Date(2018, 2, 1, 8),
            endDate    : new Date(2018, 2, 1, 19)
        });

        t.chain(
            { dblClick : '.b-timeline-subgrid .b-grid-cell', offset : ['50%+1', '50%'] },
            { waitForSelector : '.b-sch-dirty-new', desc : 'Event element created' },
            { waitForSelector : '.b-eventeditor', desc : 'Editor shown' },
            { waitForSelectorNotFound : '.b-sch-event-tooltip', desc : 'event tooltip not triggered' },
            next => {
                t.selectorNotExists('.b-sch-event-tooltip', 'event tooltip not triggered');

                const record = scheduler.features.eventEdit.eventRecord;

                t.is(record.startDate, new Date(2018, 2, 1, 13, 30), 'Start date is correct');
                t.is(record.endDate, new Date(2018, 2, 1, 14, 30), 'End date is correct');
            }
        );
    });

    t.it('Should create event but should not show event editor if no editors specified', async t => {
        scheduler = await t.getSchedulerAsync({
            features : {
                eventEdit : false
            },
            viewPreset : 'hourAndDay',
            startDate  : new Date(2018, 2, 1, 8),
            endDate    : new Date(2018, 2, 1, 19)
        });

        t.chain(
            { dblClick : '.b-timeline-subgrid .b-grid-cell' },
            { waitForSelector : '.b-sch-event', desc : 'Event created' },
            { waitForSelectorNotFound : '.b-eventeditor', desc : 'Editor not shown' }
        );
    });

    t.it('Should not create event and show event editor if scheduler in read only mode', async t => {
        scheduler = await t.getSchedulerAsync({
            features : {
                eventEdit : true
            },
            readOnly   : true,
            viewPreset : 'hourAndDay',
            startDate  : new Date(2018, 2, 1, 8),
            endDate    : new Date(2018, 2, 1, 19)
        });

        t.chain(
            { dblClick : '.b-timeline-subgrid .b-grid-cell' },
            { waitForSelectorNotFound : '.b-sch-dirty-new', desc : 'New event element not created' },
            { waitForSelectorNotFound : '.b-eventeditor', desc : 'Editor not shown' }
        );
    });

    t.it('Should not create event and show event editor if this option is turned off', async t => {
        scheduler = await t.getSchedulerAsync({
            features : {
                eventEdit : true
            },
            readOnly              : false,
            createEventOnDblClick : false,
            viewPreset            : 'hourAndDay',
            startDate             : new Date(2018, 2, 1, 8),
            endDate               : new Date(2018, 2, 1, 19)
        });

        t.chain(
            { dblClick : '.b-timeline-subgrid .b-grid-cell' },
            { waitForSelectorNotFound : '.b-sch-dirty-new', desc : 'Event element not created' },
            { waitForSelectorNotFound : '.b-eventeditor', desc : 'Editor not shown' }
        );
    });
});
