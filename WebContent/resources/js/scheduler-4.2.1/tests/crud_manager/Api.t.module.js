import { Scheduler } from '../../build/scheduler.module.js';

StartTest(t => {
    let scheduler;

    t.beforeEach(() => {
        Scheduler.destroy(scheduler);
    });

    t.it('Should revert / accept all changes when revertChanges / acceptChanges is called', async t => {
        t.mockUrl('load', {
            responseText : JSON.stringify({
                success     : true,
                type        : 'load',
                assignments : {
                    rows : [{
                        resourceId : 1,
                        eventId    : 1
                    }]
                },
                events : {
                    rows : [{
                        id   : 1,
                        name : 'Task'
                    }]
                },
                resources : {
                    rows : [{
                        id   : 1,
                        name : 'Man'
                    }]
                }
            })
        });

        scheduler = t.getScheduler({
            crudManager : {
                transport : {
                    load : {
                        url : 'load'
                    },
                    sync : {
                        url : 'sync'
                    }
                },
                autoLoad : false,
                autoSync : false
            }
        });

        const cm = scheduler.crudManager;

        await cm.load();

        cm.resourceStore.add({});
        cm.eventStore.add({});
        cm.assignmentStore.add({});

        t.ok(cm.hasChanges(), 'Changes found');

        cm.revertChanges();

        t.notOk(cm.hasChanges(), 'No changes found');

        cm.resourceStore.first.name = 'foo';
        cm.eventStore.first.name = 'foo';
        cm.assignmentStore.first.eventId = null;

        t.ok(cm.hasChanges(), 'Changes found');

        cm.acceptChanges();

        t.notOk(cm.hasChanges(), 'No changes found');
    });
});
