var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    StringHelper = _bryntum$scheduler.StringHelper;
/* eslint-disable no-unused-vars */

var maxValue = 10;
var scheduler = new Scheduler({
  appendTo: 'container',
  eventStyle: 'border',
  resourceImagePath: '../_shared/images/users/',
  features: {
    //stripe       : true,
    group: 'category',
    sort: 'name',
    groupSummary: {
      collapseToHeader: true,
      summaries: [{
        label: 'Full time',
        renderer: function renderer(_ref) {
          var events = _ref.events;
          // Only count events for resources that are "Full time"
          return events.filter(function (event) {
            return event.resource.type === 'Full time';
          }).length;
        }
      }, {
        label: 'Part time',
        renderer: function renderer(_ref2) {
          var events = _ref2.events;
          return events.reduce(function (result, event) {
            // Only count events for resources that are "Part time"
            return result + (event.resource.type === 'Part time' ? 1 : 0);
          }, 0);
        }
      }, {
        label: 'Total',
        height: 40,
        // needed to make summary row grow correctly
        renderer: function renderer(_ref3) {
          var events = _ref3.events;
          var value = Math.min(1, events.length / maxValue),
              height = 100 * value + '%';
          return "\n                           <div class=\"bar-outer\">\n                               <div class=\"bar-inner\" style=\"height: ".concat(height, "\"><label class=\"").concat(value > 0.5 ? 'b-summarybar-label-inside' : '', "\">").concat(events.length || '', "</label></div>\n                           </div>\n                        ");
        }
      }]
    }
  },
  columns: [{
    text: 'Category',
    width: 100,
    field: 'category',
    hidden: true
  }, {
    type: 'resourceInfo',
    text: 'Staff',
    width: 170,
    summaries: [{
      sum: 'count',
      label: 'Employees'
    }]
  }, {
    text: 'Employment type',
    width: 130,
    field: 'type',
    summaries: [{
      sum: function sum(result, record) {
        return result + (record.type === 'Part time' ? 1 : 0);
      },
      label: 'Part time'
    }]
  }],
  rowHeight: 55,
  barMargin: 10,
  startDate: new Date(2017, 0, 1),
  endDate: new Date(2017, 0, 14),
  // Customize preset
  viewPreset: {
    base: 'dayAndWeek',
    displayDateFormat: 'YYYY-MM-DD',
    timeResolution: {
      unit: 'day',
      increment: 1
    }
  },
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  eventRenderer: function eventRenderer(_ref4) {
    var eventRecord = _ref4.eventRecord,
        resourceRecord = _ref4.resourceRecord,
        renderData = _ref4.renderData;
    var colors = {
      Consultants: 'orange',
      Research: 'purple',
      Sales: 'lime',
      Testers: 'cyan'
    };

    if (!eventRecord.eventColor) {
      renderData.eventColor = colors[resourceRecord.category];
    } // Add a custom CSS classes to the template element data by setting a property name


    renderData.cls.full = resourceRecord.type === 'Full time';
    renderData.cls.part = !renderData.cls.full; // Add data to be applied to the event template

    return StringHelper.encodeHtml(eventRecord.name);
  }
});