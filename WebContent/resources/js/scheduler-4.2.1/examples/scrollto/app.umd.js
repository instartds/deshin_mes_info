var _bryntum$scheduler = bryntum.scheduler,
    DateHelper = _bryntum$scheduler.DateHelper,
    StringHelper = _bryntum$scheduler.StringHelper,
    Scheduler = _bryntum$scheduler.Scheduler;
var DH = DateHelper,
    today = DH.clearTime(new Date()),
    start = DH.startOf(today, 'week');
var highlight = true,
    center = false,
    animate = 1000; //region Data

var resources = [{
  id: 'r1',
  name: 'Machine 1'
}, {
  id: 'r2',
  name: 'Machine 2'
}, {
  id: 'r3',
  name: 'Machine 3'
}, {
  id: 'r4',
  name: 'Machine 4'
}, {
  id: 'r5',
  name: 'Machine 5'
}, {
  id: 'r6',
  name: 'Machine 6'
}, {
  id: 'r7',
  name: 'Machine 7'
}, {
  id: 'r8',
  name: 'Machine 8'
}, {
  id: 'r9',
  name: 'Machine 9'
}, {
  id: 'r10',
  name: 'Robot 1'
}, {
  id: 'r11',
  name: 'Robot 2'
}, {
  id: 'r12',
  name: 'Robot 3'
}, {
  id: 'r13',
  name: 'Robot 4'
}, {
  id: 'r14',
  name: 'Robot 5'
}, {
  id: 'r15',
  name: 'Robot 6'
}],
    events = [{
  id: 1,
  resourceId: 'r1',
  name: 'Event-1',
  startDate: DH.add(start, 2, 'days'),
  duration: 4,
  iconCls: 'b-fa b-fa-cogs'
}, {
  id: 2,
  resourceId: 'r2',
  name: 'Event-2',
  startDate: DH.add(start, 4, 'days'),
  duration: 6,
  iconCls: 'b-fa b-fa-cogs'
}, {
  id: 3,
  resourceId: 'r3',
  name: 'Event-3',
  startDate: DH.add(start, 20, 'days'),
  duration: 10,
  iconCls: 'b-fa b-fa-cogs'
}, {
  id: 4,
  resourceId: 'r13',
  name: 'Event-4',
  startDate: DH.add(start, 15, 'days'),
  duration: 5,
  iconCls: 'b-fa b-fa-wrench'
}, {
  id: 5,
  resourceId: 'r14',
  name: 'Event-5',
  startDate: DH.add(start, 20, 'days'),
  duration: 8,
  iconCls: 'b-fa b-fa-wrench'
}, {
  id: 6,
  resourceId: 'r15',
  name: 'Event-6',
  startDate: DH.add(start, 9, 'days'),
  duration: 12,
  iconCls: 'b-fa b-fa-wrench'
}]; //endregion

var scheduler = new Scheduler({
  appendTo: 'container',
  eventStyle: 'border',
  features: {
    timeRanges: {
      showHeaderElements: true,
      showCurrentTimeLine: true
    }
  },
  columns: [{
    text: 'Machines',
    field: 'name',
    width: 130,
    locked: true
  }],
  resources: resources,
  eventStore: {
    // Store id is used to configure the same store on the combo in the toolbar further down
    id: 'events',
    data: events
  },
  startDate: start,
  endDate: DateHelper.add(start, 4, 'weeks'),
  viewPreset: 'dayAndWeek',
  rowHeight: 55,
  eventRenderer: function eventRenderer(_ref) {
    var eventRecord = _ref.eventRecord,
        resourceRecord = _ref.resourceRecord,
        renderData = _ref.renderData;
    renderData.eventColor = resourceRecord.name.startsWith('Machine') ? 'indigo' : 'red';
    return StringHelper.encodeHtml(eventRecord.name);
  },
  tbar: [{
    type: 'dropdown',
    ref: 'scrollToEvent',
    placeholder: 'Scroll to event',
    editable: false,
    // Store will be resolved by id
    store: 'events',
    displayField: 'name',
    onAction: function onAction(_ref2) {
      var event = _ref2.record;
      scheduler.scrollEventIntoView(event, {
        highlight: highlight,
        animate: {
          easing: 'easeFromTo',
          duration: animate
        }
      });
    }
  }, {
    type: 'slider',
    ref: 'animate',
    width: '8em',
    min: 0,
    max: 3000,
    step: 100,
    value: animate,
    text: 'Animate',
    style: 'margin-right: 1em',
    onChange: function onChange(_ref3) {
      var value = _ref3.value;
      return animate = value;
    }
  }, {
    type: 'checkbox',
    ref: 'highlight',
    text: 'Highlight',
    style: 'margin-right: 2em',
    checked: true,
    onChange: function onChange(_ref4) {
      var checked = _ref4.checked;
      return highlight = checked;
    }
  }, {
    type: 'dropdown',
    ref: 'scrollToTime',
    placeholder: 'Scroll to time',
    editable: false,
    items: [[0, 'Today'], [2, '2 days from now'], [10, '10 days from now'], [-1, "Last day in view"]],
    onAction: function onAction(_ref5) {
      var value = _ref5.value;
      scheduler.scrollToDate(value === -1 ? scheduler.timeAxis.last.startDate : DH.add(today, value, 'days'), {
        highlight: highlight,
        animate: {
          easing: 'easeFromTo',
          duration: animate
        },
        block: center ? 'center' : 'nearest'
      });
    }
  }, {
    type: 'checkbox',
    ref: 'center',
    text: 'Center',
    checked: false,
    onChange: function onChange(_ref6) {
      var checked = _ref6.checked;
      return center = checked;
    }
  }]
});