var _templateObject, _templateObject2, _templateObject3;

function _taggedTemplateLiteral(strings, raw) { if (!raw) { raw = strings.slice(0); } return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    StringHelper = _bryntum$scheduler.StringHelper;
var scheduler = new Scheduler({
  appendTo: 'container',
  startDate: new Date(2019, 1, 19, 6),
  endDate: new Date(2019, 1, 19, 20),
  viewPreset: 'hourAndDay',
  rowHeight: 50,
  barMargin: 5,
  eventStyle: 'colored',
  crudManager: {
    autoLoad: true,
    resourceStore: {
      // Additional fields for resources
      fields: ['capacity', 'condition', 'color', 'floor', {
        name: 'redecorated',
        type: 'date'
      }]
    },
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  columns: [{
    text: 'Room',
    field: 'name',
    width: 130,
    region: 'left',
    htmlEncode: false,
    renderer: function renderer(_ref) {
      var value = _ref.value,
          record = _ref.record;
      return StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["<div class=\"box b-sch-", "\"></div>", ""])), record.color, value);
    }
  }, {
    text: 'Floor',
    field: 'floor',
    width: 100,
    region: 'left'
  }, {
    text: 'Capacity',
    field: 'capacity',
    width: 80,
    region: 'left',
    type: 'number',
    align: 'right',
    htmlEncode: false,
    renderer: function renderer(_ref2) {
      var value = _ref2.value;
      var icon = value < 25 ? 'user' : value < 200 ? 'user-friends' : 'users';
      return StringHelper.xss(_templateObject2 || (_templateObject2 = _taggedTemplateLiteral(["", "<div class=\"capacity b-fa b-fa-", "\"></div>"])), value, icon);
    }
  }, {
    text: 'Redecorated',
    field: 'redecorated',
    width: 115,
    region: 'right',
    type: 'date'
  }, {
    text: 'Condition',
    field: 'condition',
    region: 'right',
    type: 'rating'
  }],
  subGridConfigs: {
    left: {
      width: 310
    },
    // A "normal" flexed region is automatically added for scheduler unless specified
    right: {
      width: 275
    }
  },
  eventRenderer: function eventRenderer(_ref3) {
    var eventRecord = _ref3.eventRecord,
        renderData = _ref3.renderData;
    var hours = eventRecord.duration * 24;

    if (hours > 8) {
      renderData.eventColor = 'red';
    } else if (hours > 4) {
      renderData.eventColor = 'orange';
    } else if (hours > 2) {
      renderData.eventColor = 'lime';
    }

    return StringHelper.xss(_templateObject3 || (_templateObject3 = _taggedTemplateLiteral(["", "<span>(", " hour", ")</span>"])), eventRecord.name, hours, hours > 1 ? 's' : '');
  },
  features: {
    eventEdit: {
      resourceFieldConfig: {
        label: 'Room'
      }
    }
  },
  columnLines: false,
  tbar: [{
    type: 'button',
    ref: 'addButton',
    icon: 'b-fa-plus',
    text: 'Add column',
    onClick: function onClick() {
      // scheduler.columns is a store, it supports the normal Store CRUD operations
      scheduler.columns.insert(1, {
        text: 'Accessible',
        field: 'accessible',
        region: 'left',
        type: 'check'
      });
      scheduler.widgetMap.addButton.disable();
      scheduler.widgetMap.removeButton.enable();
    }
  }, {
    type: 'button',
    ref: 'removeButton',
    cls: 'b-red',
    icon: 'b-fa-trash',
    text: 'Remove column',
    disabled: true,
    onClick: function onClick() {
      scheduler.columns.getAt(1).remove();
      scheduler.widgetMap.addButton.enable();
      scheduler.widgetMap.removeButton.disable();
    }
  }]
});