function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

var _bryntum$scheduler = bryntum.scheduler,
    DateHelper = _bryntum$scheduler.DateHelper,
    PresetStore = _bryntum$scheduler.PresetStore,
    EventModel = _bryntum$scheduler.EventModel,
    Scheduler = _bryntum$scheduler.Scheduler,
    PresetManager = _bryntum$scheduler.PresetManager; //region Presets & Widgets

PresetManager.registerPreset('dayNightShift', {
  name: 'Day/night shift (custom)',
  tickWidth: 35,
  rowHeight: 32,
  displayDateFormat: 'HH:mm',
  shiftIncrement: 1,
  shiftUnit: 'day',
  timeResolution: {
    unit: 'minute',
    increment: 15
  },
  defaultSpan: 24,
  mainHeaderLevel: 1,
  headers: [{
    unit: 'day',
    increment: 1,
    dateFormat: 'MMMM Do YYYY'
  }, {
    unit: 'hour',
    increment: 12,
    renderer: function renderer(startDate, endDate, headerConfig, cellIdx) {
      if (startDate.getHours() === 0) {
        // Setting a custom CSS on the header cell element
        headerConfig.headerCellCls = 'b-fa b-fa-moon';
        return DateHelper.format(startDate, 'MMM DD') + ' Night Shift';
      } else {
        // Setting a custom CSS on the header cell element
        headerConfig.headerCellCls = 'b-fa b-fa-sun';
        return DateHelper.format(startDate, 'MMM DD') + ' Day Shift';
      }
    }
  }, {
    unit: 'hour',
    increment: 1,
    dateFormat: 'H'
  }]
});
var requiredPresetIds = {
  secondAndMinute: 1,
  minuteAndHour: 1,
  hourAndDay: 1,
  dayNightShift: 1,
  weekAndDay: 1,
  weekAndMonth: 1,
  weekAndDayLetter: 1,
  weekDateAndMonth: 1,
  monthAndYear: 1,
  year: 1,
  manyYears: 1
},
    // Create a presets store with just the ones we want.
// The set of available Presets is what provides the zoom levels.
presets = PresetManager.records.filter(function (p) {
  return requiredPresetIds[p.id];
}),
    presetStore = new PresetStore({
  data: presets,
  // We'd like the order to go from seconds to years, rather than the default order
  zoomOrder: -1
}); //endregion
//region Data

var resources = [{
  id: 1,
  name: 'Arcady',
  role: 'Core developer',
  eventColor: 'purple'
}, {
  id: 2,
  name: 'Dave',
  role: 'Tech Sales',
  eventColor: 'indigo'
}, {
  id: 3,
  name: 'Henrik',
  role: 'Sales',
  eventColor: 'blue'
}, {
  id: 4,
  name: 'Linda',
  role: 'Core developer',
  eventColor: 'cyan'
}, {
  id: 5,
  name: 'Maxim',
  role: 'Developer & UX',
  eventColor: 'green'
}, {
  id: 6,
  name: 'Mike',
  role: 'CEO',
  eventColor: 'lime'
}, {
  id: 7,
  name: 'Lee',
  role: 'CTO',
  eventColor: 'orange'
}],
    events = [{
  id: 1,
  resourceId: 1,
  percentDone: 60,
  startDate: new Date(2017, 0, 1, 10),
  endDate: new Date(2017, 0, 1, 12)
}, {
  id: 2,
  resourceId: 2,
  percentDone: 20,
  startDate: new Date(2017, 0, 1, 12),
  endDate: new Date(2017, 0, 1, 17)
}, {
  id: 3,
  resourceId: 3,
  percentDone: 80,
  startDate: new Date(2017, 0, 1, 14),
  endDate: new Date(2017, 0, 1, 16)
}, {
  id: 4,
  resourceId: 4,
  percentDone: 90,
  startDate: new Date(2017, 0, 1, 8),
  endDate: new Date(2017, 0, 1, 11)
}, {
  id: 5,
  resourceId: 5,
  percentDone: 40,
  startDate: new Date(2017, 0, 1, 15),
  endDate: new Date(2017, 0, 1, 17)
}, {
  id: 6,
  resourceId: 6,
  percentDone: 70,
  startDate: new Date(2017, 0, 1, 16),
  endDate: new Date(2017, 0, 1, 18)
}]; //endregion

var EventModelWithPercent = /*#__PURE__*/function (_EventModel) {
  _inherits(EventModelWithPercent, _EventModel);

  var _super = _createSuper(EventModelWithPercent);

  function EventModelWithPercent() {
    _classCallCheck(this, EventModelWithPercent);

    return _super.apply(this, arguments);
  }

  _createClass(EventModelWithPercent, null, [{
    key: "fields",
    get: function get() {
      return [{
        name: 'percentDone',
        type: 'number',
        defaultValue: 0
      }];
    }
  }]);

  return EventModelWithPercent;
}(EventModel);

var scheduler = new Scheduler({
  appendTo: 'container',
  resourceImagePath: '../_shared/images/users/',
  features: {
    stripe: true,
    sort: 'name'
  },
  columns: [{
    type: 'resourceInfo',
    text: 'Staff',
    width: '10em'
  }],
  resources: resources,
  eventStore: {
    modelClass: EventModelWithPercent,
    data: events
  },
  startDate: new Date(2017, 0, 1),
  endDate: new Date(2017, 0, 2),
  // Use our custom list of just the ones we plucked out of the PresetManager
  presets: presets,
  viewPreset: 'dayNightShift',
  eventRenderer: function eventRenderer(_ref) {
    var eventRecord = _ref.eventRecord,
        renderData = _ref.renderData;
    var value = eventRecord.percentDone || 0; // Add a child to the event element (b-sch-event)

    renderData.children.push({
      className: 'value',
      style: {
        width: "".concat(value, "%")
      },
      html: value
    });
  },
  listeners: {
    presetChange: function presetChange(_ref2) {
      var from = _ref2.from,
          to = _ref2.to;
      var _scheduler$widgetMap = scheduler.widgetMap,
          presetCombo = _scheduler$widgetMap.presetCombo,
          zoomInButton = _scheduler$widgetMap.zoomInButton,
          zoomOutButton = _scheduler$widgetMap.zoomOutButton;
      presetCombo.value = to; // To disable buttons based on zoom levels use this code:
      // zoomOutButton.disabled = level <= 0;
      // zoomInButton.disabled = level >= this.presets.length - 1;
      // To disable buttons based on presets in combo use this code:

      var index = presetCombo.store.indexOf(presetCombo.record);
      zoomOutButton.disabled = index === 0;
      zoomInButton.disabled = index === presetCombo.store.count - 1;
    }
  },
  tbar: [{
    type: 'combo',
    width: 200,
    ref: 'presetCombo',
    placeholder: 'Preset',
    editable: false,
    store: presetStore,
    valueField: 'id',
    displayField: 'name',
    value: 'dayNightShift',
    picker: {
      maxHeight: 500
    },
    onChange: function onChange(_ref3) {
      var combo = _ref3.source;
      scheduler.zoomToLevel(combo.selected);
    }
  }, {
    type: 'button',
    ref: 'zoomInButton',
    icon: 'b-icon-search-plus',
    text: 'Zoom in',
    onClick: function onClick() {
      scheduler.zoomIn();
    }
  }, {
    type: 'button',
    ref: 'zoomOutButton',
    icon: 'b-icon-search-minus',
    text: 'Zoom out',
    onClick: function onClick() {
      scheduler.zoomOut();
    }
  }]
});