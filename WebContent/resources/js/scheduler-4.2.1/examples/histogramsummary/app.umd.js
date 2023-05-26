var Scheduler = bryntum.scheduler.Scheduler;
var maxValue = 10;
new Scheduler({
  appendTo: 'container',
  viewPreset: 'hourAndDay',
  eventColor: 'blue',
  features: {
    summary: {
      renderer: function renderer(_ref) {
        var element = _ref.element,
            events = _ref.events;
        var value = events.length / maxValue;
        element.style.height = "".concat(100 * value, "%");

        if (value > 0.5) {
          element.classList.add('b-summarybar-label-inside');
        } else {
          element.classList.remove('b-summarybar-label-inside');
        }

        return "<label>".concat(events.length || '', "</label>");
      }
    }
  },
  barMargin: 15,
  startDate: new Date(2017, 11, 1, 6),
  endDate: new Date(2017, 11, 3),
  resourceImagePath: '../_shared/images/users/',
  columns: [{
    type: 'resourceInfo',
    text: 'Name',
    width: 170,
    sum: 'count',
    summaryRenderer: function summaryRenderer(_ref2) {
      var sum = _ref2.sum;
      return "Total: ".concat(sum);
    }
  }, {
    type: 'number',
    text: 'Rating',
    field: 'rating',
    width: 100,
    sum: 'average',
    align: 'right',
    summaryRenderer: function summaryRenderer(_ref3) {
      var sum = _ref3.sum;
      return "Average: ".concat(sum.toFixed(2));
    }
  }],
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  }
});