var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    StringHelper = _bryntum$scheduler.StringHelper; // Simple custom sorter that sorts late start before early start

function customSorter(a, b) {
  return b.startDate.getTime() - a.startDate.getTime();
}

var scheduler = new Scheduler({
  appendTo: 'container',
  resourceImagePath: '../_shared/images/users/',
  eventStyle: 'colored',
  features: {
    cellEdit: {
      // Start cell editing on click
      triggerEvent: 'cellclick'
    }
  },
  listeners: {
    // Auto-show picker on cell editing
    startCellEdit: function startCellEdit(_ref) {
      var _editorContext$editor, _editorContext$editor2;

      var editorContext = _ref.editorContext;
      (_editorContext$editor = (_editorContext$editor2 = editorContext.editor.inputField).showPicker) === null || _editorContext$editor === void 0 ? void 0 : _editorContext$editor.call(_editorContext$editor2);
    }
  },
  columns: [{
    type: 'resourceInfo',
    text: 'Staff'
  }, {
    text: 'Layout',
    field: 'eventLayout',
    // Config for the editor.inputField
    editor: {
      type: 'combo',
      editable: false,
      placeholder: 'Inherit',
      items: [['', 'Inherit'], ['stack', 'Stack'], ['pack', 'Pack'], ['none', 'Overlap']]
    },
    renderer: function renderer(_ref2) {
      var _column$editor$store$, _column$editor$store$2;

      var value = _ref2.value,
          column = _ref2.column;
      return {
        class: 'layoutCellContent',
        children: [{
          tag: 'span',
          html: (_column$editor$store$ = (_column$editor$store$2 = column.editor.store.getById(value)) === null || _column$editor$store$2 === void 0 ? void 0 : _column$editor$store$2.text) !== null && _column$editor$store$ !== void 0 ? _column$editor$store$ : 'Inherit'
        }, {
          tag: 'i',
          class: 'b-fa b-fa-pen'
        }]
      };
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
  barMargin: 1,
  rowHeight: 50,
  eventLayout: 'stack',
  startDate: new Date(2017, 1, 7, 8),
  endDate: new Date(2017, 1, 7, 18),
  viewPreset: 'hourAndDay',
  eventRenderer: function eventRenderer(_ref3) {
    var eventRecord = _ref3.eventRecord,
        resourceRecord = _ref3.resourceRecord,
        renderData = _ref3.renderData;
    // Color by resource
    renderData.eventColor = resourceRecord.firstStore.indexOf(resourceRecord) % 2 === 0 ? 'green' : 'orange'; // Icon by type

    renderData.iconCls = eventRecord.eventType === 'Meeting' ? 'b-fa b-fa-calendar' : 'b-fa b-fa-calendar-alt'; // Encode name to protect against xss

    return StringHelper.encodeHtml(eventRecord.name);
  },
  tbar: [{
    type: 'buttonGroup',
    toggleGroup: true,
    defaults: {
      width: '8em'
    },
    items: [{
      id: 'stack',
      type: 'button',
      ref: 'stackButton',
      text: 'Stack',
      pressed: true
    }, {
      id: 'pack',
      type: 'button',
      ref: 'packButton',
      text: 'Pack'
    }, {
      id: 'none',
      type: 'button',
      ref: 'noneButton',
      text: 'Overlap'
    }],
    onAction: function onAction(_ref4) {
      var button = _ref4.source;
      scheduler.eventLayout = button.id;
    }
  }, {
    type: 'button',
    ref: 'customButton',
    text: 'Custom sorter',
    toggleable: true,
    icon: 'b-fa-square',
    pressedIcon: 'b-fa-check-square',
    tooltip: 'Click to use a custom event sorting function',
    onToggle: function onToggle(_ref5) {
      var pressed = _ref5.pressed;
      scheduler.horizontalEventSorterFn = pressed ? customSorter : null;
    }
  }]
});