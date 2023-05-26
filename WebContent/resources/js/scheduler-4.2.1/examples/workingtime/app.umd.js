function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr == null ? null : typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]; if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    WidgetHelper = _bryntum$scheduler.WidgetHelper,
    Popup = _bryntum$scheduler.Popup,
    DomHelper = _bryntum$scheduler.DomHelper;
/* eslint-disable no-unused-vars */

var scheduler,
    workingTime = {
  fromDay: 1,
  toDay: 6,
  fromHour: 8,
  toHour: 17
}; // Get values from the form and use as working time config

function refreshWorkingTime() {
  var newWorkingTime = {};
  tools.eachWidget(function (field) {
    if (field.isType('number')) {
      newWorkingTime[field.name] = field.value;
    }
  });
  scheduler.workingTime = newWorkingTime;
  displayInfo();
} // Display humanly readable info about working time in a bar below the header


function displayInfo() {
  var info = elements.info,
      _ref = scheduler.workingTime || {},
      fromDay = _ref.fromDay,
      toDay = _ref.toDay,
      fromHour = _ref.fromHour,
      toHour = _ref.toHour,
      days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      dayPart = fromDay >= 0 && toDay >= 0 ? "".concat(days[fromDay], " - ").concat(days[toDay - 1]) : '',
      timePart = fromHour >= 0 && toHour >= 0 ? "".concat(fromHour, " - ").concat(toHour) : '';

  if (timePart || dayPart) {
    info.innerHTML = "<i class=\"b-fa b-fa-calendar-check\"></i> Scheduler configured to show only working time: <b>".concat(dayPart, " ").concat(timePart, "</b>");
    info.classList.remove('not-in-use');
  } else {
    info.innerHTML = '<i class="b-fa b-fa-calendar"></i> Scheduler not configured with working time';
    info.classList.add('not-in-use');
  }
} // Create infrastructure to hold the different components of the demo


var elements = DomHelper.createElement({
  parent: 'container',
  tag: 'div',
  reference: 'outer',
  dataset: {
    appElement: true // To work with the built in code editor, not demo related

  },
  children: [{
    reference: 'info',
    className: 'b-color-orange'
  }, {
    reference: 'horizontal',
    children: [{
      reference: 'container'
    }, {
      reference: 'tools',
      className: 'b-panel-content'
    } // To use panels background color
    ]
  }]
});

var _WidgetHelper$append = WidgetHelper.append([{
  type: 'container',
  items: [// Combo for picking a view preset
  {
    type: 'combo',
    value: 'week',
    editable: false,
    ref: 'viewPresetCombo',
    items: [{
      value: 'month',
      text: 'Month',
      startDate: new Date(2019, 0, 1),
      endDate: new Date(2019, 2, 31),
      viewPreset: {
        base: 'monthAndYear',
        displayDateFormat: 'ddd D/M HH:mm'
      }
    }, {
      value: 'week',
      text: 'Week',
      startDate: new Date(2019, 1, 1),
      endDate: new Date(2019, 1, 16),
      viewPreset: {
        base: 'weekAndMonth',
        displayDateFormat: 'ddd D/M HH:mm',
        timeResolution: {
          unit: 'hour',
          increment: 1
        },
        headers: [{
          unit: 'month',
          align: 'center',
          dateFormat: 'MMM YYYY' //Jan 2017

        }, {
          unit: 'week',
          align: 'center',
          dateFormat: 'DD MMM (wW)'
        }]
      }
    }, {
      value: 'day',
      text: 'Day',
      startDate: new Date(2019, 1, 3),
      endDate: new Date(2019, 1, 10),
      viewPreset: 'dayAndWeek'
    }],
    onSelect: function onSelect(_ref2) {
      var value = _ref2.value,
          record = _ref2.record;
      scheduler.viewPreset = record.viewPreset;
      scheduler.setTimeSpan(record.startDate, record.endDate);
    }
  }, // Button to toggle working time on/off
  {
    type: 'button',
    text: 'Use working time',
    ref: 'workingTimeBtn',
    color: 'b-gray',
    icon: 'b-fa b-fa-square',
    pressedIcon: 'b-fa b-fa-check-square',
    toggleable: true,
    pressed: true,
    flex: 1,
    style: 'margin-bottom: .5em',
    onToggle: function onToggle(_ref3) {
      var pressed = _ref3.pressed;
      var widgets = tools.widgetMap;
      widgets.fromHour.disabled = widgets.toHour.disabled = widgets.fromDay.disabled = widgets.toDay.disabled = widgets.restore.disabled = !pressed; // Change the display, but keep the visual center the same to preserve user's context.

      // Change the display, but keep the visual center the same to preserve user's context.
      scheduler.preserveViewCenter(function () {
        if (pressed) {
          refreshWorkingTime();
        } else {
          scheduler.workingTime = null;
          displayInfo();
        }
      });
    }
  }, // Fields for configuring working time. Changing a field sets min/max value on the "opposite" field and
  // triggers setting a new working time config on Scheduler.
  {
    type: 'number',
    label: 'From hour',
    ref: 'fromHour',
    name: 'fromHour',
    clearable: true,
    min: 0,
    onChange: function onChange(_ref4) {
      var value = _ref4.value,
          userAction = _ref4.userAction;
      tools.widgetMap.toHour.min = value + 1;
      userAction && refreshWorkingTime();
    }
  }, {
    type: 'number',
    label: 'To hour',
    ref: 'toHour',
    name: 'toHour',
    clearable: true,
    max: 24,
    onChange: function onChange(_ref5) {
      var value = _ref5.value,
          userAction = _ref5.userAction;
      tools.widgetMap.fromHour.max = value - 1;
      userAction && refreshWorkingTime();
    }
  }, {
    type: 'number',
    label: 'From day',
    ref: 'fromDay',
    name: 'fromDay',
    clearable: true,
    min: 0,
    onChange: function onChange(_ref6) {
      var value = _ref6.value,
          userAction = _ref6.userAction;
      tools.widgetMap.toDay.min = value + 1;
      userAction && refreshWorkingTime();
    }
  }, {
    type: 'number',
    label: 'To day',
    ref: 'toDay',
    name: 'toDay',
    clearable: true,
    max: 7,
    onChange: function onChange(_ref7) {
      var value = _ref7.value,
          userAction = _ref7.userAction;
      tools.widgetMap.fromDay.max = value - 1;
      userAction && refreshWorkingTime();
    }
  }, // Button to restore working time to the initially used values
  {
    type: 'button',
    text: 'Restore defaults',
    ref: 'restore',
    flex: 1,
    color: 'b-gray',
    icon: 'b-fa b-fa-sync-alt',
    onClick: function onClick() {
      tools.record = scheduler.workingTime = workingTime;
      displayInfo();
    }
  }]
}], elements.tools),
    _WidgetHelper$append2 = _slicedToArray(_WidgetHelper$append, 1),
    tools = _WidgetHelper$append2[0]; // Scheduler configured to use working time, with view preset and dates plucked from the combo


scheduler = new Scheduler({
  appendTo: elements.container,
  eventStyle: 'border',
  eventColor: 'lime',
  resourceImagePath: '../_shared/images/users/',
  // Zooming feature is not supported!
  zoomOnMouseWheel: false,
  zoomOnTimeAxisDoubleClick: false,
  features: {
    stripe: true,
    timeRanges: true
  },
  columns: [{
    type: 'resourceInfo',
    text: 'Staff'
  }],
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  barMargin: 10,
  rowHeight: 60,
  viewPreset: tools.widgetMap.viewPresetCombo.selected.viewPreset,
  startDate: tools.widgetMap.viewPresetCombo.selected.startDate,
  endDate: tools.widgetMap.viewPresetCombo.selected.endDate,
  workingTime: workingTime
}); // Display working time in the configuration fields

tools.record = scheduler.workingTime; // Update the top info bar to display correct initial info

displayInfo();