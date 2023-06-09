import Scheduler from '../../lib/Scheduler/view/Scheduler.js';
import '../../lib/Scheduler/feature/ResourceTimeRanges.js';
import RecurringTimeSpan from '../../lib/Scheduler/model/mixin/RecurringTimeSpan.js';
import ResourceTimeRangeModel from '../../lib/Scheduler/model/ResourceTimeRangeModel.js';
import RecurringTimeSpansMixin from '../../lib/Scheduler/data/mixin/RecurringTimeSpansMixin.js';
import ResourceTimeRangeStore from '../../lib/Scheduler/data/ResourceTimeRangeStore.js';

StartTest(t => {
    let scheduler;

    // Setup model & store supporting recurrence

    class MyResourceTimeRange extends RecurringTimeSpan(ResourceTimeRangeModel) {};

    class MyResourceTimeRangeStore extends RecurringTimeSpansMixin(ResourceTimeRangeStore) {
        static get defaultConfig() {
            return {
                modelClass : MyResourceTimeRange
            };
        }
    };

    const rangeSelector = '.b-sch-resourcetimerange:not(.b-sch-released)';

    t.beforeEach(t => scheduler?.destroy());

    t.it('Should display recurring resource time ranges occurrences', async t => {
        scheduler = new Scheduler({
            appendTo           : document.body,
            startDate          : new Date(2019, 0, 1),
            endDate            : new Date(2019, 0, 2),
            autoAdjustTimeAxis : false,

            features : {
                resourceTimeRanges : true
            },

            resources : [
                { id : 'r1', name : 'Mike' }
            ],

            resourceTimeRangeStore : new MyResourceTimeRangeStore({
                data : [
                    {
                        id             : 1,
                        resourceId     : 'r1',
                        startDate      : '2019-01-01T13:00',
                        endDate        : '2019-01-01T14:00',
                        name           : 'lunch',
                        recurrenceRule : 'FREQ=DAILY'
                    }
                ]
            })
        });

        await t.waitForProjectReady();

        t.selectorCountIs(rangeSelector, 1, '1 range element found');

        scheduler.endDate = new Date(2019, 0, 3);

        t.selectorCountIs(rangeSelector, 2, '2 range elements found');

        scheduler.endDate = new Date(2019, 0, 4);

        t.selectorCountIs(rangeSelector, 3, '3 range elements found');
    });

});
