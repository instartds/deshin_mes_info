var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    DateHelper = _bryntum$scheduler.DateHelper,
    StringHelper = _bryntum$scheduler.StringHelper;
/* eslint-disable no-unused-vars */

var // Normalizes agenda items on load by converting string dates to actual dates and by calculating start and end offsets
// from the events startDate, to keep a relative position later on drag/resize
normalizeAgendaItems = function normalizeAgendaItems(eventData) {
  var _eventData$agenda;

  eventData.startDate = DateHelper.parse(eventData.startDate);
  (_eventData$agenda = eventData.agenda) === null || _eventData$agenda === void 0 ? void 0 : _eventData$agenda.forEach(function (nestedEvent) {
    nestedEvent.startDate = DateHelper.parse(nestedEvent.startDate);
    nestedEvent.endDate = DateHelper.parse(nestedEvent.endDate); // Calculate offsets, more useful for rendering in case event is dragged to a new date

    nestedEvent.startOffset = DateHelper.diff(eventData.startDate, nestedEvent.startDate);
    nestedEvent.endOffset = DateHelper.diff(nestedEvent.startDate, nestedEvent.endDate);
  });
},
    // Updates nested events dates on resize, based on events startDate and offsets stored during normalization (above)
refreshAgendaDates = function refreshAgendaDates(eventRecord) {
  var _eventRecord$agenda;

  (_eventRecord$agenda = eventRecord.agenda) === null || _eventRecord$agenda === void 0 ? void 0 : _eventRecord$agenda.forEach(function (nestedEvent) {
    nestedEvent.startDate = DateHelper.add(eventRecord.startDate, nestedEvent.startOffset);
    nestedEvent.endDate = DateHelper.add(eventRecord.startDate, nestedEvent.endOffset);
  });
},
    scheduler = new Scheduler({
  appendTo: 'container',
  startDate: new Date(2018, 8, 24, 7),
  endDate: new Date(2018, 8, 25),
  viewPreset: 'hourAndDay',
  rowHeight: 60,
  barMargin: 10,
  resourceImagePath: '../_shared/images/users/',
  columns: [{
    type: 'resourceInfo',
    text: 'Name',
    field: 'name',
    width: 130
  }],
  features: {
    labels: {
      bottomLabel: 'name'
    },
    // Nested events have fixed content
    stickyEvents: false
  },
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    },
    listeners: {
      // Will be called after data is fetched but before it is loaded into stores
      beforeLoadApply: function beforeLoadApply(_ref) {
        var response = _ref.response;
        // Turn "nested event" dates into actual dates, to not have to process them each time during render
        response.events.rows.forEach(function (event) {
          return normalizeAgendaItems(event);
        });
      }
    },
    eventStore: {
      listeners: {
        // When an events startDate changes we want to update the dates of the nested events too
        update: function update(_ref2) {
          var record = _ref2.record,
              changes = _ref2.changes;

          if (changes.startDate) {
            refreshAgendaDates(record);
          }
        }
      }
    }
  },
  // eventBodyTemplate is used to render markup inside an event. It is populated using data from eventRenderer()
  eventBodyTemplate: function eventBodyTemplate(values) {
    return values.map(function (value) {
      return "\n        <div class=\"nested\" style=\"left: ".concat(value.left, "px;width: ").concat(value.width, "px\">\n            ").concat(StringHelper.encodeHtml(value.name), "\n        </div>\n    ");
    }).join('');
  },
  // eventRenderer is here used to translate the dates of nested events into pixels, passed on to the eventBodyTemplate
  eventRenderer: function eventRenderer(_ref3) {
    var _this = this;

    var eventRecord = _ref3.eventRecord,
        renderData = _ref3.renderData;

    var // Note that during a resize, we have to use `eventRecord.get('startDate')` to get the current value.
    // The value is not properly updated until the resize finishes
    startDate = eventRecord.get('startDate'),
        // getCoordinateFromDate gives us a px value in time axis, subtract events left from it to be within the event
    dateToPx = function dateToPx(date) {
      return _this.getCoordinateFromDate(date) - renderData.left;
    }; // Calculate coordinates for all nested events and put in an array passed on to eventBodyTemplate


    return (eventRecord.agenda || [eventRecord]).map(function (nestedEvent) {
      return {
        left: dateToPx(DateHelper.add(startDate, nestedEvent.startOffset)),
        width: dateToPx(DateHelper.add(startDate, nestedEvent.endOffset)),
        name: nestedEvent.name
      };
    });
  }
});