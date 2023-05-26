var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    StringHelper = _bryntum$scheduler.StringHelper; // eslint-disable-next-line no-unused-vars

var scheduler = new Scheduler({
  appendTo: 'container',
  resourceImagePath: '../_shared/images/users/',
  features: {
    eventDragCreate: false,
    eventResize: false,
    eventTooltip: false,
    stickyEvents: false,
    eventDrag: {
      constrainDragToResource: true
    }
  },
  columns: [{
    type: 'resourceInfo',
    text: 'Staff',
    field: 'name',
    width: '13em',
    showEventCount: false,
    showRole: true
  }],
  rowHeight: 80,
  startDate: new Date(2017, 5, 1),
  endDate: new Date(2017, 5, 11),
  viewPreset: 'dayAndWeek',
  eventLayout: 'none',
  managedEventSizing: false,
  crudManager: {
    autoLoad: true,
    eventStore: {
      fields: ['startInfo', 'startInfoIcon', 'endInfo', 'endInfoIcon']
    },
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  eventRenderer: function eventRenderer(_ref) {
    var eventRecord = _ref.eventRecord,
        resourceRecord = _ref.resourceRecord,
        renderData = _ref.renderData;
    var startEndMarkers = ''; // Add a custom CSS classes to the template element data by setting a property name

    renderData.cls.milestone = eventRecord.isMilestone;
    renderData.cls.normalEvent = !eventRecord.isMilestone;
    renderData.cls[resourceRecord.id] = 1;

    if (eventRecord.startInfo) {
      startEndMarkers = "<i class=\"b-start-marker ".concat(eventRecord.startInfoIcon, "\" data-btip=\"").concat(eventRecord.startInfo, "\"></i>");
    }

    if (eventRecord.endInfo) {
      startEndMarkers += "<i class=\"b-end-marker ".concat(eventRecord.endInfoIcon, "\" data-btip=\"").concat(eventRecord.endInfo, "\"></i>");
    }

    return startEndMarkers + StringHelper.encodeHtml(eventRecord.name);
  }
});