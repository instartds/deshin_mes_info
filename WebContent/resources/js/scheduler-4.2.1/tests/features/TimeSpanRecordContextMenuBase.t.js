import TimeSpanRecordContextMenuBase from '../../lib/Scheduler/feature/base/TimeSpanRecordContextMenuBase.js';
import '../../lib/Scheduler/feature/Dependencies.js';
import '../../lib/Scheduler/feature/DependencyEdit.js';
import VersionHelper from '../../lib/Core/helper/VersionHelper.js';
import GridFeatureManager from '../../lib/Grid/feature/GridFeatureManager.js';

StartTest(t => {
    let scheduler;

    t.beforeEach(() => {
        scheduler && scheduler.destroy();

        // After scheduler destroy, all menuitems must also have been destroyed
        t.is(bryntum.queryAll('menuitem').length, 0, 'Menu items all destroyed');
    });

    const spy = t.spyOn(VersionHelper, 'deprecate').and.callFake(() => {});

    t.it('LEGACY: Sanity', t => {
        spy.reset();

        class MyMenu extends TimeSpanRecordContextMenuBase {
            construct(grid, config) {
                t.is(grid.features.myMenu, this, 'This feature is already available');
                super.construct(grid, config);
            }
        }

        GridFeatureManager.registerFeature(MyMenu);

        scheduler = t.getScheduler({
            viewPreset : 'dayAndWeek',
            appendTo   : document.body,
            features   : {
                myMenu : true
            }
        });

        t.chain(
            { contextmenu : '.b-sch-header-timeaxis-cell' },
            () => {
                t.expect(spy).toHaveBeenCalled(1);
                t.expect(spy).toHaveBeenCalledWith('Scheduler', '5.0.0', '`TimeSpanRecordContextMenuBase` feature is deprecated, in favor of `TimeSpanMenuBase` feature. Please see https://bryntum.com/docs/scheduler/#Scheduler/guides/upgrades/3.1.0.md for more information.');
            }
        );
    });
});
