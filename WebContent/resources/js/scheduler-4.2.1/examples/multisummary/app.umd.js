var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    StringHelper = _bryntum$scheduler.StringHelper;
var red = '#FF1744',
    green = '#64DD17';
new Scheduler({
  appendTo: 'container',
  eventColor: null,
  eventStyle: null,
  barMargin: 15,
  viewPreset: 'hourAndDay',
  resourceImagePath: '../_shared/images/users/',
  features: {
    summary: {
      summaries: [{
        label: 'Total',
        renderer: function renderer(_ref) {
          var events = _ref.events;
          return events.length || 0;
        }
      }, {
        label: 'High rating',
        renderer: function renderer(_ref2) {
          var events = _ref2.events;
          return events.filter(function (event) {
            return event.resource.rating > 4;
          }).length || 0;
        }
      }, {
        label: 'Low rating',
        renderer: function renderer(_ref3) {
          var events = _ref3.events;
          var value = events.filter(function (event) {
            return event.resource.rating < 3;
          }).length || 0;
          return value > 0 ? "<span style=\"color: ".concat(red, "\">").concat(value, "</span>") : 0;
        }
      }]
    }
  },
  startDate: new Date(2017, 11, 1, 6),
  endDate: new Date(2017, 11, 3),
  columns: [{
    type: 'resourceInfo',
    text: 'Name',
    field: 'name',
    width: 150,
    sum: 'count',
    summaryRenderer: function summaryRenderer(_ref4) {
      var sum = _ref4.sum;
      return 'Total: ' + sum;
    }
  }, {
    type: 'number',
    text: 'Rating',
    field: 'rating',
    width: 150,
    sum: 'average',
    summaryRenderer: function summaryRenderer(_ref5) {
      var sum = _ref5.sum;
      return "Average: ".concat(sum.toFixed(2));
    },
    renderer: function renderer(_ref6) {
      var value = _ref6.value,
          cellElement = _ref6.cellElement;

      if (value < 3) {
        cellElement.style.color = red;
      }

      return value;
    }
  }],
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  eventRenderer: function eventRenderer(_ref7) {
    var eventRecord = _ref7.eventRecord,
        resourceRecord = _ref7.resourceRecord,
        renderData = _ref7.renderData;
    renderData.style += 'background-color: ' + (resourceRecord.rating < 3 ? red : green);
    return StringHelper.encodeHtml(eventRecord.name);
  }
});