
StartTest(t => {
    let scheduler;

    t.beforeEach(t => {
        scheduler && scheduler.destroy();
        scheduler = null;
    });

    async function setup(t, config = {}) {
        scheduler && scheduler.destroy();

        scheduler = t.getScheduler(Object.assign({
            startDate  : new Date(2018, 8, 20),
            endDate    : new Date(2018, 9, 30),
            viewPreset : 'weekAndMonth',
            resources  : [
                { id : 1 },
                { id : 2 }
            ],
            events : [
                { id : 1, resourceId : 1, startDate : new Date(2018, 9, 20), duration : 2, name : 'task 1' },
                { id : 2, resourceId : 1, startDate : new Date(2018, 9, 24), duration : 2, name : 'task 2' }
            ],

            dependencies : [
                { id : 1, from : 1, to : 2, type : 2 }
            ],

            features : {
                dependencies : {
                    showTooltip : false
                },
                eventTooltip   : false,
                dependencyEdit : true
            }
        }, config));

        await t.waitForDependencies();
    }

    t.it('Should show editor on dblclick on dependency', async t => {
        await setup(t);

        t.firesOnce(scheduler, 'beforeDependencyEdit');

        t.chain(
            { dblclick : '.b-sch-dependency' },

            { waitForSelector : '.b-popup .b-header-title:contains(Edit dependency)', desc : 'Popup shown with correct title' },

            () => {
                const depFeature = scheduler.features.dependencyEdit;

                t.hasValue(depFeature.fromNameField, 'task 1');
                t.hasValue(depFeature.toNameField, 'task 2');
                t.hasValue(depFeature.typeField, 2);
                t.is(depFeature.typeField.inputValue, 'End to Start');

                t.selectorNotExists('label:contains(Lag)', 'Lag field should not exist by default');
            }
        );
    });

    t.it('Should delete dependency on Delete click', async t => {
        await setup(t);

        t.firesOnce(scheduler.dependencyStore, 'remove');
        t.firesOnce(scheduler, 'beforeDependencyDelete');
        t.firesOnce(scheduler, 'beforeDependencyEdit');

        t.chain(
            { dblclick : '.b-sch-dependency' },

            { click : '.b-popup button:textEquals(Delete)' },

            { waitForSelectorNotFound : '.b-sch-dependency' }
        );
    });

    t.it('Should change nothing on Cancel and close popup', async t => {
        await setup(t);

        t.wontFire(scheduler.dependencyStore, 'change');
        t.firesOnce(scheduler, 'beforeDependencyEdit');

        t.chain(
            { dblclick : '.b-sch-dependency' },

            { click : '.b-popup button:textEquals(Cancel)' }
        );
    });

    t.it('Should repaint and update model when changing type', async t => {
        await setup(t);
// TODO: Revisit when engine integration is complete
//        t.firesOnce(scheduler.dependencyStore, 'update');
        t.firesOnce(scheduler, 'beforeDependencyEdit');
        t.firesOnce(scheduler, 'beforeDependencyEditShow');
        t.firesOnce(scheduler, 'afterDependencySave');

        t.chain(
            { dblclick : '.b-sch-dependency' },

            next => {
                const depFeature = scheduler.features.dependencyEdit;

                depFeature.typeField.value = 0;
                next();
            },

            { click : '.b-popup button:textEquals(Save)' },

            () => {
                t.is(scheduler.dependencyStore.first.type, 0, 'Type updated');
            }
        );
    });

    t.it('Should not show if scheduler is readOnly', async t => {
        await setup(t, {
            readOnly : true
        });

        t.wontFire(scheduler, 'beforeDependencyEdit');

        t.chain(
            { dblclick : '.b-sch-dependency' }
        );
    });

    t.it('Should be possible to show editor programmatically', async t => {
        await setup(t, {
            height : 300
        });

        scheduler.features.dependencyEdit.editDependency(scheduler.dependencyStore.first);

        t.chain(
            { waitForSelector : '.b-dependencyeditor' }
        );
    });

    t.it('Should support disabling', async t => {
        await setup(t);

        scheduler.features.dependencyEdit.disabled = true;

        t.firesOk(scheduler, {
            beforeDependencyEdit : 1
        });

        t.chain(
            { dblclick : '.b-sch-dependency' },

            next => {
                t.selectorNotExists('.b-popup.b-dependencyeditor');

                scheduler.features.dependencyEdit.disabled = false;

                next();
            },

            { dblclick : '.b-sch-dependency' },

            () => {
                t.selectorExists('.b-popup.b-dependencyeditor');
            }
        );
    });
});
