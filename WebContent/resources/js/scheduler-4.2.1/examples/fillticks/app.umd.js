var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    DateHelper = _bryntum$scheduler.DateHelper,
    StringHelper = _bryntum$scheduler.StringHelper;
var scheduler = new Scheduler({
  appendTo: 'container',
  startDate: new Date(2018, 4, 13),
  endDate: new Date(2018, 4, 20),
  viewPreset: 'dayAndWeek',
  rowHeight: 60,
  barMargin: 5,
  fillTicks: true,
  eventStyle: 'colored',
  resourceImagePath: '../_shared/images/users/',
  features: {
    nonWorkingTime: true,
    // Not yet compatible with the event styles which center their content
    stickyEvents: false
  },
  columns: [{
    type: 'resourceInfo',
    text: 'Name',
    field: 'name',
    width: 130
  }],
  eventStore: {
    readUrl: 'data/events.json',
    autoLoad: true
  },
  resourceStore: {
    readUrl: 'data/resources.json',
    autoLoad: true
  },
  eventRenderer: function eventRenderer(_ref) {
    var eventRecord = _ref.eventRecord;
    return [{
      html: DateHelper.format(eventRecord.startDate, 'LT')
    }, {
      html: StringHelper.encodeHtml(eventRecord.name)
    }];
  },
  tbar: [{
    type: 'checkbox',
    label: 'Fill ticks',
    checked: true,
    onChange: function onChange(_ref2) {
      var checked = _ref2.checked;
      scheduler.fillTicks = checked;
    }
  }]
});