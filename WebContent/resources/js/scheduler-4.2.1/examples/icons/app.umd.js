var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    StringHelper = _bryntum$scheduler.StringHelper;
/* eslint-disable no-unused-vars */

var scheduler = new Scheduler({
  appendTo: 'container',
  features: {
    eventResize: false,
    eventDrag: {
      constrainDragToResource: true
    }
  },
  columns: [{
    text: 'Staff',
    field: 'name',
    width: 200
  }],
  rowHeight: 65,
  barMargin: 20,
  startDate: new Date(2017, 5, 1),
  endDate: new Date(2017, 5, 11),
  viewPreset: 'dayAndWeek',
  eventBodyTemplate: function eventBodyTemplate(data) {
    return "\n        ".concat(data.cls.startsWith('svg') ? "\n            <svg height=\"24\" width=\"24\">\n                ".concat(data.startDate.getDay() % 2 ? "\n                    <path fill=\"#748ffc\" d=\"M10.392304845413264 0L20.784609690826528 6L20.784609690826528 18L10.392304845413264 24L0 18L0 6Z\"></path>" : "\n                    <circle cx=\"12\" cy=\"12\" r=\"12\" fill=\"#748ffc\" />\n                ", "\n        </svg>") : '', "\n\n        ").concat((data.iconCls || '').match('^b-fa') ? "<i class=\"".concat(data.iconCls, "\"></i>") : '', "\n        \n        <label class=\"label\">").concat(StringHelper.encodeHtml(data.name || ''), "</label>\n    ");
  },
  crudManager: {
    autoLoad: true,
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
    // Add a custom CSS class to the event element
    renderData.wrapperCls.add(resourceRecord.id);
    return eventRecord.data;
  }
});