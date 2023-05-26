Ext.define('Sch.examples.columnsummary.preset.DayWeek', {
    extend              : 'Sch.preset.ViewPreset',
    singleton           : true,
    requires            : [
        'Sch.preset.Manager'
    ],
    name                : 'dayWeek',
    timeColumnWidth     : 100,
    rowHeight           : 24,
    resourceColumnWidth : 100,
    displayDateFormat   : 'Y-m-d G:i',
    shiftUnit           : "DAY",
    shiftIncrement      : 1,
    defaultSpan         : 5,
    timeResolution      : {
        unit      : "HOUR",
        increment : 1
    },

    headerConfig : {
        bottom : {
            unit     : "DAY",
            // Render some special 'frozen' header events which are always shown
            renderer : function (start, end, cfg, i, eventStore) {
                var timeAxisViewModel = this;
                var headerEventTpl    = '<div class="summary-event" style="left:{left}px;width:{width}px">{text}</div>';

                if (i === 0) {
                    var eventsInSpan = eventStore.queryBy(function (task) {
                        return task.getResourceId() === 'frozen' && timeAxisViewModel.timeAxis.timeSpanInAxis(task.getStartDate(), task.getEndDate());
                    });

                    return Ext.Array.map(eventsInSpan.items, function (task) {
                        var startX = timeAxisViewModel.getPositionFromDate(task.getStartDate());
                        var endX   = timeAxisViewModel.getPositionFromDate(task.getEndDate());

                        return headerEventTpl.replace('{left}', startX).replace('{width}', endX - startX).replace('{text}', task.getName());
                    }).join('');
                }
            }
        },
        middle : {
            unit     : "DAY",
            align    : "center",
            renderer : function (start, end, meta) {
                meta.headerCls = 'header-' + Ext.Date.format(start, 'Y-m-d');

                return Ext.Date.format(start, 'j');
            }
        },
        top    : {
            unit     : "WEEK",
            align    : "center",
            renderer : function (start, end, cfg) {
                return Sch.util.Date.getShortNameOfUnit("WEEK") + '.' + Ext.Date.format(start, 'W M Y');
            }
        }
    }
}, function () {
    Sch.preset.Manager.registerPreset(this.name, this);
});