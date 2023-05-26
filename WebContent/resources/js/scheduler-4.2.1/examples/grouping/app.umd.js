var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    CrudManager = _bryntum$scheduler.CrudManager,
    StringHelper = _bryntum$scheduler.StringHelper; //TODO: tree filtering

var crudManager = new CrudManager({
  autoLoad: true,
  transport: {
    load: {
      url: 'data/data.json'
    }
  }
});
var scheduler = new Scheduler({
  appendTo: 'container',
  resourceImagePath: '../_shared/images/users/',
  features: {
    stripe: true,
    group: 'category',
    sort: 'name'
  },
  columns: [{
    text: 'Category',
    width: 100,
    field: 'category',
    hidden: true
  }, {
    type: 'resourceInfo',
    text: 'Staff',
    width: 160
  }, {
    text: 'Employment type',
    width: 130,
    field: 'type'
  }],
  rowHeight: 55,
  barMargin: 5,
  startDate: new Date(2017, 0, 1),
  endDate: new Date(2017, 0, 14),
  crudManager: crudManager,
  // Customize preset
  viewPreset: {
    base: 'dayAndWeek',
    displayDateFormat: 'YYYY-MM-DD',
    timeResolution: {
      unit: 'day',
      increment: 1
    }
  },
  eventRenderer: function eventRenderer(_ref) {
    var eventRecord = _ref.eventRecord,
        resourceRecord = _ref.resourceRecord,
        renderData = _ref.renderData;
    var colors = {
      Consultants: 'orange',
      Research: 'pink',
      Sales: 'lime',
      Testars: 'cyan'
    };
    renderData.eventColor = colors[resourceRecord.category];
    return StringHelper.encodeHtml(eventRecord.name);
  },
  tbar: [{
    type: 'combo',
    width: 300,
    label: 'Scroll to resource',
    store: crudManager.resourceStore,
    valueField: 'id',
    displayField: 'name',
    onSelect: function onSelect(_ref2) {
      var record = _ref2.record;
      scheduler.scrollRowIntoView(record, {
        animate: true,
        highlight: true
      });
    }
  }]
});
window.scheduler = scheduler;