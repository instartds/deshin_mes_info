var _templateObject;

function _taggedTemplateLiteral(strings, raw) { if (!raw) { raw = strings.slice(0); } return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

var _bryntum$scheduler = bryntum.scheduler,
    DateHelper = _bryntum$scheduler.DateHelper,
    Scheduler = _bryntum$scheduler.Scheduler,
    StringHelper = _bryntum$scheduler.StringHelper;
var scheduler = new Scheduler({
  appendTo: 'container',
  eventStyle: 'colored',
  resourceImagePath: '../_shared/images/users/',
  barMargin: 5,
  features: {
    stripe: true,
    timeRanges: {
      enableResizing: true,
      showCurrentTimeLine: true,
      showHeaderElements: true
    }
  },
  columns: [{
    type: 'resourceInfo',
    text: 'Staff',
    field: 'name',
    width: '10em'
  }],
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  startDate: new Date(2019, 1, 7, 8),
  endDate: new Date(2019, 1, 7, 18),
  viewPreset: 'hourAndDay',
  // Specialized body template with header and footer
  eventBodyTemplate: function eventBodyTemplate(data) {
    return StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["\n        <div class=\"b-sch-event-header\">", "</div>\n        <div class=\"b-sch-event-footer\">", "</div>\n    "])), data.headerText, data.footerText);
  },
  eventRenderer: function eventRenderer(_ref) {
    var eventRecord = _ref.eventRecord;
    return {
      headerText: DateHelper.format(eventRecord.startDate, this.displayDateFormat),
      footerText: eventRecord.name || ''
    };
  },
  tbar: [{
    type: 'button',
    icon: 'b-icon-add',
    text: 'Add range',
    onAction: function onAction(_ref2) {
      var button = _ref2.source;
      scheduler.project.timeRangeStore.add({
        name: 'New time range',
        startDate: DateHelper.add(scheduler.startDate, 8, 'h'),
        duration: 1,
        durationUnit: 'h'
      });
      button.disable();
    }
  }, {
    type: 'button',
    text: 'Move lunch to 12pm',
    onAction: function onAction() {
      scheduler.features.timeRanges.store.getById('lunch').setStartDate(new Date(2019, 1, 7, 12), true);
    }
  }, '->', {
    type: 'buttongroup',
    items: [{
      type: 'button',
      icon: 'b-fa-angle-left',
      tooltip: 'View previous day',
      onAction: function onAction() {
        scheduler.shiftPrevious();
      }
    }, {
      type: 'button',
      ref: 'todayButton',
      text: 'Today',
      tooltip: 'View today, to see the current time line',
      onAction: function onAction() {
        var today = DateHelper.clearTime(new Date());
        today.setHours(5);
        scheduler.setTimeSpan(today, DateHelper.add(today, 18, 'hour'));
      }
    }, {
      type: 'button',
      icon: 'b-fa-angle-right',
      tooltip: 'View next day',
      onAction: function onAction() {
        scheduler.shiftNext();
      }
    }]
  }, {
    type: 'button',
    text: 'Start',
    tooltip: 'Return to initial view',
    onAction: function onAction() {
      scheduler.setTimeSpan(new Date(2019, 1, 7, 8), new Date(2019, 1, 7, 18));
    }
  }]
});