import AbstractTimeRanges from './AbstractTimeRanges.js';
import GridFeatureManager from '../../Grid/feature/GridFeatureManager.js';
import DateHelper from '../../Core/helper/DateHelper.js';
import AttachToProjectMixin from '../data/mixin/AttachToProjectMixin.js';

/**
 * @module Scheduler/feature/NonWorkingTime
 */

/**
 * Feature that allows styling of weekends (and other non working time) by adding timeRanges for those days.
 *
 * By default, Schedulers calendar is empty. When enabling this feature for the basic Scheduler, it injects weekend
 * intervals if no intervals are encountered (saturday and sunday).
 *
 * Please note that the feature does not render ranges smaller than the base unit used by the time axis
 * and for some levels it bails out rendering ranges completely (see {@link #config-maxTimeAxisUnit} for details).
 *
 * This feature is **off** by default for Scheduler, but **enabled** by default for Scheduler Pro.
 * For info on enabling it, see {@link Grid.view.mixin.GridFeatures}.
 *
 * @extends Scheduler/feature/AbstractTimeRanges
 * @demo Scheduler/configuration
 * @inlineexample Scheduler/feature/NonWorkingTime.js
 * @classtype nonWorkingTime
 * @feature
 */
export default class NonWorkingTime extends AbstractTimeRanges.mixin(AttachToProjectMixin) {
    //region Default config

    static get $name() {
        return 'NonWorkingTime';
    }

    static get defaultConfig() {
        return {
            /**
             * Set to `true` to highlight non working periods of time
             * @config {Boolean}
             * @default
             */
            highlightWeekends : true,

            showHeaderElements : true,
            showLabelInBody    : true,

            cls : 'b-sch-nonworkingtime',

            /**
             * The maximum time axis unit to display non working ranges for ('hour' or 'day' etc).
             * When zooming to a view with a larger unit, no non-working time elements will be rendered.
             *
             * **Note:** Be careful with setting this config to big units like 'year'. When doing this,
             * make sure the timeline {@link Scheduler.view.TimelineBase#config-startDate start} and
             * {@link Scheduler.view.TimelineBase#config-endDate end} dates are set tightly.
             * When using a long range (for example many years) with non-working time elements rendered per hour,
             * you will end up with millions of elements, impacting performance.
             * When zooming, use the {@link Scheduler.view.mixin.TimelineZoomable#config-zoomKeepsOriginalTimespan} config.
             * @config {String}
             * @default
             */
            maxTimeAxisUnit : 'week',

            autoGeneratedWeekends : false
        };
    }

    static get pluginConfig() {
        return {
            chain : [
                'onPaint',
                'attachToProject',
                'updateLocalization'
            ]
        };
    }

    //endregion

    //region Init & destroy

    doDestroy() {
        this.attachToCalendar(null);
        super.doDestroy();
    }

    //endregion

    //region Project

    attachToProject(project) {
        super.attachToProject(project);

        this.attachToCalendar(project.effectiveCalendar);

        project.on({
            name           : 'project',
            calendarChange : () => this.attachToCalendar(this.project.effectiveCalendar),
            thisObj        : this
        });
    }

    //endregion

    //region TimeAxisViewModel

    onTimeAxisViewModelUpdate() {
        this._timeAxisUnitDurationMs = null;
        return super.onTimeAxisViewModelUpdate();
    }

    //endregion

    //region Calendar

    updateLocalization() {
        super.updateLocalization?.();

        if (this.autoGeneratedWeekends && this.calendar) {
            const
                intervals    = this.defaultNonWorkingIntervals,
                hasIntervals = Boolean(intervals.length);

            this.calendar.clearIntervals(hasIntervals);

            // Update weekends as non-working time
            if (hasIntervals) {
                this.calendar.addIntervals(intervals);
            }
        }
    }

    attachToCalendar(calendar) {
        const
            me                  = this,
            { project, client } = me;

        me.detachListeners('calendar');

        me.autoGeneratedWeekends = false;

        if (calendar) {
            if (
                // For basic scheduler...
                !client.isSchedulerPro &&
                !client.isGantt &&
                // ...that uses the default calendar...
                calendar === project.defaultCalendar &&
                // ...and has no defined intervals
                !project.defaultCalendar.intervalStore.count
            ) {
                const intervals = me.defaultNonWorkingIntervals;

                // Add weekends as non-working time
                if (intervals.length) {
                    calendar.addIntervals(intervals);
                    me.autoGeneratedWeekends = true;
                }
            }

            calendar.intervalStore.on({
                name   : 'calendar',
                change : () => me.setTimeout('renderRanges', 1)
            });
        }

        // On changing calendar we react to a data level event which is triggered after project refresh.
        // Redraw right away
        if (client.isEngineReady) {
            me.renderRanges();
        }
        // Initially there is no guarantee we are ready to draw, wait for refresh
        else if (!project.isDestroyed) {
            me.detachListeners('initialProjectListener');
            project.on({
                name    : 'initialProjectListener',
                refresh : me.renderRanges,
                thisObj : me,
                once    : true
            });
        }
    }

    get defaultNonWorkingIntervals() {
        const dayNames  = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

        return DateHelper.nonWorkingDaysAsArray.map(dayIndex => {
            return {
                recurrentStartDate : `on ${dayNames[dayIndex]} at 0:00`,
                recurrentEndDate   : `on ${dayNames[(dayIndex + 1) % 7]} at 0:00`,
                isWorking          : false
            };
        });
    }

    get calendar() {
        return this.project?.effectiveCalendar;
    }

    //endregion

    //region Draw

    get timeAxisUnitDurationMs() {
        // calculate and cache duration of the timeAxis unit in milliseconds
        if (!this._timeAxisUnitDurationMs) {
            this._timeAxisUnitDurationMs = DateHelper.as('ms', 1, this.client.timeAxis.unit);
        }

        return this._timeAxisUnitDurationMs;
    }

    shouldRenderRange(range) {
        // if the range is longer or equal than one timeAxis unit then render it
        return super.shouldRenderRange(range) && (range.durationMS >= this.timeAxisUnitDurationMs);
    }

    renderRanges() {
        const
            me                             = this,
            { store, calendar }            = me,
            { timeAxis, foregroundCanvas } = me.client;

        // if not too early (project correctly set up yet etc)
        if (calendar && foregroundCanvas && store && !store.isDestroyed) {
            if (!me.disabled) {
                // checks if we should render ranges for the current zoom level
                const shouldPaint = !me.maxTimeAxisUnit || DateHelper.compareUnits(timeAxis.unit, me.maxTimeAxisUnit) <= 0;

                store.removeAll(true);

                if (calendar && me.highlightWeekends && shouldPaint && timeAxis.count) {
                    const
                        timeRanges       = calendar.getNonWorkingTimeRanges(timeAxis.startDate, timeAxis.endDate).map((r, i) => ({
                            name      : r.name,
                            cls       : 'b-nonworkingtime',
                            startDate : r.startDate,
                            endDate   : r.endDate
                        })),
                        timeRangesMerged = [];

                    let prevRange;

                    // intervals returned by the calendar are not merged ..let's combine them
                    timeRanges.forEach(range => {
                        if (prevRange && range.startDate <= prevRange.endDate && range.name === prevRange.name) {
                            prevRange.endDate = range.endDate;
                        }
                        else {
                            timeRangesMerged.push(range);
                            range.id  = `nonworking-${timeRangesMerged.length}`;
                            prevRange = range;
                        }
                    });

                    store.add(timeRangesMerged, true);
                }
            }

            super.renderRanges();
        }
    }

    //endregion
}

GridFeatureManager.registerFeature(NonWorkingTime, false, 'Scheduler');
GridFeatureManager.registerFeature(NonWorkingTime, true, ['SchedulerPro', 'Gantt', 'ResourceHistogram']);
