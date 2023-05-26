var _templateObject;

function _taggedTemplateLiteral(strings, raw) { if (!raw) { raw = strings.slice(0); } return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

var _bryntum$scheduler = bryntum.scheduler,
    StringHelper = _bryntum$scheduler.StringHelper,
    Toast = _bryntum$scheduler.Toast,
    Scheduler = _bryntum$scheduler.Scheduler; //region Data

var resources = [{
  id: 'r1',
  name: 'Mike',
  eventColor: 'pink'
}, {
  id: 'r2',
  name: 'Linda',
  eventColor: 'orange'
}, {
  id: 'r3',
  name: 'Dan',
  eventColor: 'violet'
}, {
  id: 'r4',
  name: 'Madison',
  eventColor: 'blue'
}, {
  id: 'r5',
  name: 'Malik',
  eventColor: 'purple',
  rowHeight: 90,
  resourceMargin: 10
}, {
  id: 'r6',
  name: 'Rob',
  eventColor: 'indigo'
}],
    events = [{
  id: 1,
  resourceId: 'r1',
  name: 'Fork project',
  startDate: new Date(2017, 0, 1, 10),
  endDate: new Date(2017, 0, 1, 12),
  iconCls: 'b-fa b-fa-code-branch'
}, {
  id: 2,
  resourceId: 'r1',
  name: 'Extend test',
  startDate: new Date(2017, 0, 1, 11),
  endDate: new Date(2017, 0, 1, 15),
  iconCls: 'b-fa b-fa-search'
}, {
  id: 3,
  resourceId: 'r2',
  name: 'UI testing',
  startDate: new Date(2017, 0, 1, 10),
  endDate: new Date(2017, 0, 1, 15),
  iconCls: 'b-fa b-fa-user'
}, {
  id: 4,
  resourceId: 'r3',
  name: 'Release to prod server',
  startDate: new Date(2017, 0, 1, 14),
  endDate: new Date(2017, 0, 1, 17),
  iconCls: 'b-fa b-fa-server'
}, {
  id: 5,
  resourceId: 'r4',
  name: 'Update docs',
  startDate: new Date(2017, 0, 1, 8),
  endDate: new Date(2017, 0, 1, 11),
  iconCls: 'b-fa b-fa-book'
}, {
  id: 6,
  resourceId: 'r5',
  name: 'Fix bug',
  startDate: new Date(2017, 0, 1, 15),
  endDate: new Date(2017, 0, 1, 17),
  iconCls: 'b-fa b-fa-bug'
}, {
  id: 7,
  resourceId: 'r6',
  name: 'Fix IE issues',
  startDate: new Date(2017, 0, 1, 16),
  endDate: new Date(2017, 0, 1, 18),
  iconCls: 'b-fa b-fa-band-aid'
}]; //endregion

var scheduler = new Scheduler({
  appendTo: 'container',
  eventStyle: 'border',
  resourceImagePath: '../_shared/images/users/',
  columns: [{
    type: 'resourceInfo',
    text: 'Name',
    field: 'name',
    width: 130
  }, {
    type: 'template',
    text: 'Cool link',
    width: 130,
    template: function template(_ref) {
      var record = _ref.record;
      return record.rowHeight || record.resourceMargin || record.barMargin ? 'Settings from data' : "<a href=#>Click me<a>";
    }
  }],
  resources: resources,
  events: events,
  startDate: new Date(2017, 0, 1, 8),
  endDate: new Date(2017, 0, 1, 19),
  viewPreset: 'hourAndDay',
  onCellClick: function onCellClick(context) {
    if (context.column.field === 'name') {
      Toast.show(StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["You clicked ", ""])), context.record.name));
    }
  },
  eventRenderer: function eventRenderer(_ref2) {
    var eventRecord = _ref2.eventRecord,
        renderData = _ref2.renderData;
    // Make events with low height use a small font (uses em in styling, will scale)
    renderData.cls.tiny = renderData.height < 23;
    return StringHelper.encodeHtml(eventRecord.name);
  },
  tbar: [{
    type: 'combo',
    ref: 'resource',
    label: 'Adjust',
    displayField: 'name',
    value: 'all',
    editable: false,
    items: [{
      id: 'all',
      name: 'All unset'
    }].concat(resources),
    onSelect: function onSelect(_ref3) {
      var record = _ref3.record;

      if (record.id === 'all') {
        changeAdjustTarget(scheduler);
      } else {
        changeAdjustTarget(scheduler.resourceStore.getById(record.id));
      }
    }
  }, {
    type: 'slider',
    ref: 'rowHeight',
    text: 'Row height',
    showValue: true,
    min: 20,
    onInput: function onInput(_ref4) {
      var value = _ref4.value;
      adjustTarget.rowHeight = value;
      barMargin.max = Math.max(0, (value - 10) / 2);
    }
  }, {
    type: 'slider',
    ref: 'barMargin',
    text: 'Bar margin',
    showValue: true,
    onInput: function onInput(_ref5) {
      var value = _ref5.value;
      adjustTarget.barMargin = value;
    }
  }, {
    type: 'slider',
    ref: 'resourceMargin',
    text: 'Resource margin',
    showValue: true,
    max: 20,
    onInput: function onInput(_ref6) {
      var value = _ref6.value;
      adjustTarget.resourceMargin = value;
    }
  }]
});
var _scheduler$widgetMap = scheduler.widgetMap,
    rowHeight = _scheduler$widgetMap.rowHeight,
    barMargin = _scheduler$widgetMap.barMargin,
    resourceMargin = _scheduler$widgetMap.resourceMargin;
var adjustTarget;

function changeAdjustTarget(target) {
  var _target$rowHeight, _target$barMargin, _target$resourceMargi;

  adjustTarget = target;
  var rowHeightValue = (_target$rowHeight = target.rowHeight) !== null && _target$rowHeight !== void 0 ? _target$rowHeight : scheduler.rowHeight;
  rowHeight.value = rowHeightValue;
  barMargin.value = (_target$barMargin = target.barMargin) !== null && _target$barMargin !== void 0 ? _target$barMargin : scheduler.barMargin;
  barMargin.max = Math.max(0, (rowHeightValue - 10) / 2);
  resourceMargin.value = (_target$resourceMargi = target.resourceMargin) !== null && _target$resourceMargi !== void 0 ? _target$resourceMargi : scheduler.resourceMargin;
}

changeAdjustTarget(scheduler);