
StartTest(t => {
    let scheduler;

    t.beforeEach(() => {
        scheduler?.destroy?.();
    });

    // #8943 - https://app.assembla.com/spaces/bryntum/tickets/8943
    t.it('Should not crash after drag-create', t => {

        let eventDragged = false;

        scheduler = t.getScheduler({
            appendTo : document.body,

            resources : [
                { id : 'r1', name : 'Resource 1' }
            ],

            events : [],

            features : {
                eventEdit : true
            },

            listeners : {
                eventDrag() {
                    eventDragged = true;
                }
            }
        });

        t.chain(
            { drag : '.b-sch-timeaxis-cell', offset : [100, '50%'], by : [200, 0] },

            { waitForSelector : '.b-eventeditor' },

            { type : '123[ENTER]' },

            { waitForSelectorNotFound : '.b-eventeditor' },

            { drag : scheduler.eventSelector, by : [50, 0] },

            () => {
                t.ok(eventDragged, 'Event dragged w/o issues');
            }
        );
    });

    // #8943 - https://app.assembla.com/spaces/bryntum/tickets/8943
    t.it('Should not crash after drag-create with Scheduler in multi-assignment mode', t => {

        let eventDragged = false;

        scheduler = t.getScheduler({
            appendTo : document.body,

            resources : [
                { id : 'r1', name : 'Resource 1' }
            ],

            events : [
                { id : 'e1', name : '123', startDate : new Date(2011, 0, 5), endDate : new Date(2011, 0, 6) }
            ],

            assignments : [
                { id : 'a1', eventId : 'e1', resourceId : 'r1' }
            ],

            features : {
                eventEdit    : true,
                eventTooltip : false
            },

            listeners : {
                eventDrag() {
                    eventDragged = true;
                }
            }
        });

        t.chain(
            { drag : '.b-sch-timeaxis-cell', offset : [100, '50%'], by : [200, 0] },

            { waitForSelector : '.b-eventeditor' },

            { type : '123[ENTER]' },

            { waitForSelectorNotFound : '.b-eventeditor' },

            { drag : scheduler.eventSelector + ' .b-sch-dirty-new', by : [50, 0] },

            () => {
                t.ok(eventDragged, 'Event dragged w/o issues');
            }
        );
    });

    // https://github.com/bryntum/support/issues/1376
    t.it('Should not get stuck after minimal drag create', async t => {
        scheduler = await t.getSchedulerAsync({ events : []  });

        t.chain(
            { drag : '.b-sch-timeaxis-cell', offset : [100, '50%'], by : [3, 0] },

            () => {
                t.selectorExists('.b-sch-event-wrap', 'New event created');
            }
        );
    });

    // https://github.com/bryntum/support/issues/2056
    t.it('Should be possible to set resource id in beforeEventAdd handler', async t => {
        scheduler = await t.getSchedulerAsync({
            features : {
                eventEdit    : true,
                eventTooltip : false
            },
            events : []
        });

        scheduler.on({
            beforeEventAdd({ eventRecord, resourceRecords }) {
                eventRecord.resourceId = resourceRecords[0].id;
            }
        });

        await t.dragBy('.b-sch-timeaxis-cell', [100, 0], null, null, null, null, [100, '50%']);
        await t.type('.b-textfield input[name="name"]', 'Foo');
        await t.click('button[data-ref="saveButton"]');
        await t.waitForSelector('.b-sch-event:contains(Foo)');
    });

    t.it('Should be possible to change resource field name', async t => {
        scheduler = await t.getSchedulerAsync({
            features : {
                eventEdit : {
                    editorConfig : {
                        items : {
                            resourceField : {
                                name : 'resourceId' // 'resource' is used by default
                            }
                        }
                    }
                },
                eventTooltip : false
            },
            events : []
        });

        await t.dragBy('.b-sch-timeaxis-cell', [100, 0], null, null, null, null, [100, '50%']);
        await t.type('.b-textfield input[name="name"]', 'Foo');
        await t.click('button[data-ref="saveButton"]');
        await t.waitForSelector('.b-sch-event:contains(Foo)');
    });

    t.it('Should ignore click on phantom event', async t => {
        scheduler = await t.getSchedulerAsync({
            events   : [],
            features : {
                eventEdit : true
            }
        });

        const livesOk = t.livesOkAsync('Click on temp event does not throw');

        await t.dragBy({
            source : '.b-sch-timeaxis-cell',
            offset : [50, '50%'],
            delta  : [100, 0]
        });

        await t.waitForSelector(scheduler.unreleasedEventSelector);

        await t.click('.b-sch-event');

        await t.waitForSelectorNotFound(scheduler.unreleasedEventSelector);

        livesOk();
    });
});
