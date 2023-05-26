function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    DateHelper = _bryntum$scheduler.DateHelper,
    ResourceTimeRangeModel = _bryntum$scheduler.ResourceTimeRangeModel,
    RecurringTimeSpan = _bryntum$scheduler.RecurringTimeSpan,
    RecurringTimeSpansMixin = _bryntum$scheduler.RecurringTimeSpansMixin,
    ResourceTimeRangeStore = _bryntum$scheduler.ResourceTimeRangeStore;
/* eslint-disable no-unused-vars */
//region Data

var resources = [{
  id: 'r1',
  name: 'Mike'
}, {
  id: 'r2',
  name: 'Linda'
}, {
  id: 'r3',
  name: 'Lisa'
}, {
  id: 'r4',
  name: 'Madison'
}, {
  id: 'r5',
  name: 'Mark'
}, {
  id: 'r6',
  name: 'Kate'
}, {
  id: 'r7',
  name: 'Dan'
}, {
  id: 'r8',
  name: 'Henrik'
}, {
  id: 'r9',
  name: 'Rob'
}, {
  id: 'r10',
  name: 'Gloria'
}],
    events = [{
  id: 1,
  resourceId: 'r1',
  startDate: new Date(2019, 0, 1, 8),
  endDate: new Date(2019, 0, 1, 11),
  name: 'Investigation',
  iconCls: 'b-fa b-fa-search'
}, {
  id: 2,
  resourceId: 'r1',
  startDate: new Date(2019, 0, 1, 13),
  endDate: new Date(2019, 0, 1, 15),
  name: 'Brief',
  iconCls: 'b-fa b-fa-newspaper'
}, {
  id: 3,
  resourceId: 'r2',
  startDate: new Date(2019, 0, 1, 8),
  endDate: new Date(2019, 0, 1, 9, 30),
  name: 'Scrum',
  iconCls: 'b-fa b-fa-bullhorn'
}, {
  id: 4,
  resourceId: 'r3',
  startDate: new Date(2019, 0, 1, 8),
  endDate: new Date(2019, 0, 1, 9, 30),
  name: 'Scrum',
  iconCls: 'b-fa b-fa-bullhorn'
}, {
  id: 5,
  resourceId: 'r4',
  startDate: new Date(2019, 0, 1, 7),
  endDate: new Date(2019, 0, 1, 11),
  name: 'Meeting',
  iconCls: 'b-fa b-fa-calendar'
}, {
  id: 6,
  resourceId: 'r4',
  startDate: new Date(2019, 0, 1, 15),
  endDate: new Date(2019, 0, 1, 17),
  name: 'Meeting',
  iconCls: 'b-fa b-fa-calendar',
  eventColor: 'blue'
}, {
  id: 7,
  resourceId: 'r6',
  startDate: new Date(2019, 0, 1, 12, 30),
  endDate: new Date(2019, 0, 1, 19),
  name: 'Important meeting',
  iconCls: 'b-fa b-fa-exclamation-triangle',
  eventColor: 'red'
}, {
  id: 8,
  resourceId: 'r6',
  startDate: new Date(2019, 0, 1, 9),
  endDate: new Date(2019, 0, 1, 12),
  name: 'Generic meeting',
  iconCls: 'b-fa b-fa-calendar'
}, {
  id: 9,
  resourceId: 'r7',
  startDate: new Date(2019, 0, 1, 9),
  endDate: new Date(2019, 0, 1, 11),
  name: 'Dad\'s birthday',
  iconCls: 'b-fa b-fa-birthday-cake',
  eventColor: 'green'
}, {
  id: 10,
  resourceId: 'r9',
  startDate: new Date(2019, 0, 1, 13),
  endDate: new Date(2019, 0, 1, 20),
  name: 'Golf tournament',
  iconCls: 'b-fa b-fa-golf-ball',
  eventColor: 'green'
}],
    resourceTimeRanges = [{
  id: 1,
  resourceId: 'r1',
  startDate: '2019-01-01T11:00',
  endDate: '2019-01-01T13:00',
  name: 'Lunch',
  // this time range should repeat every day
  recurrenceRule: 'FREQ=DAILY'
}, {
  id: 2,
  resourceId: 'r8',
  startDate: '2019-01-01T11:00',
  endDate: '2019-01-01T13:00',
  name: 'Lunch'
}, {
  id: 3,
  resourceId: 'r9',
  startDate: '2019-01-01T11:00',
  endDate: '2019-01-01T13:00',
  name: 'Lunch'
}, {
  id: 4,
  resourceId: 'r10',
  startDate: '2019-01-01T11:00',
  endDate: '2019-01-01T13:00',
  name: 'Lunch'
}, {
  id: 5,
  resourceId: 'r3',
  startDate: '2019-01-01T12:00',
  endDate: '2019-01-01T14:00',
  name: 'Lunch'
}, {
  id: 6,
  resourceId: 'r4',
  startDate: '2019-01-01T12:00',
  duration: 2,
  durationUnit: 'h',
  name: 'Lunch'
}, {
  id: 7,
  resourceId: 'r2',
  startDate: '2019-01-01T10:00',
  endDate: '2019-01-01T17:00',
  name: 'AFK (uses timeRangeColor)',
  timeRangeColor: 'red'
}, {
  id: 8,
  resourceId: 'r7',
  startDate: '2019-01-01T12:00',
  endDate: '2019-01-01T18:00',
  name: 'Afternoon off (custom style)',
  style: 'background: rgba(255,165,0,.3);color : orange'
}, {
  id: 9,
  resourceId: 'r5',
  startDate: '2019-01-01T06:00',
  endDate: '2019-01-01T20:00',
  name: 'Parental leave (custom CSS)',
  cls: 'custom'
}]; // We want to use recurring time ranges (see first entry in resourceTimeRanges array above)
// so we make a special model extending standard ResourceTimeRangeModel
// with RecurringTimeSpan which adds recurrence support

var MyResourceTimeRange = /*#__PURE__*/function (_RecurringTimeSpan) {
  _inherits(MyResourceTimeRange, _RecurringTimeSpan);

  var _super = _createSuper(MyResourceTimeRange);

  function MyResourceTimeRange() {
    _classCallCheck(this, MyResourceTimeRange);

    return _super.apply(this, arguments);
  }

  return MyResourceTimeRange;
}(RecurringTimeSpan(ResourceTimeRangeModel));

; // Define a new store extending standard ResourceTimeRangeStore
// with RecurringTimeSpansMixin mixin to add recurrence support to the store.
// This store will contain time ranges.

var MyResourceTimeRangeStore = /*#__PURE__*/function (_RecurringTimeSpansMi) {
  _inherits(MyResourceTimeRangeStore, _RecurringTimeSpansMi);

  var _super2 = _createSuper(MyResourceTimeRangeStore);

  function MyResourceTimeRangeStore() {
    _classCallCheck(this, MyResourceTimeRangeStore);

    return _super2.apply(this, arguments);
  }

  _createClass(MyResourceTimeRangeStore, null, [{
    key: "defaultConfig",
    get: function get() {
      return {
        // use our new MyResourceTimeRange model
        modelClass: MyResourceTimeRange
      };
    }
  }]);

  return MyResourceTimeRangeStore;
}(RecurringTimeSpansMixin(ResourceTimeRangeStore));

; // Instantiate store for resourceTimeRanges using our new classes

var resourceTimeRangeStore = new MyResourceTimeRangeStore({
  data: resourceTimeRanges
}); //endregion

var newRangeCount = 0;
var scheduler = new Scheduler({
  appendTo: 'container',
  startDate: new Date(2019, 0, 1, 6),
  endDate: new Date(2019, 0, 1, 20),
  viewPreset: 'hourAndDay',
  rowHeight: 90,
  barMargin: 3,
  resourceMargin: 25,
  resourceImagePath: '../_shared/images/users/',
  eventStyle: 'plain',
  eventColor: 'blue',
  columns: [{
    type: 'resourceInfo',
    text: 'Name',
    field: 'name',
    width: 130
  }],
  features: {
    resourceTimeRanges: true
  },
  resources: resources,
  events: events,
  // the store will be used by the "resourceTimeRanges" feature
  resourceTimeRangeStore: resourceTimeRangeStore,
  tbar: [{
    type: 'button',
    icon: 'b-icon-add',
    text: 'Add new range',
    onAction: function onAction() {
      if (newRangeCount < 10) {
        scheduler.resourceTimeRangeStore.add({
          name: 'New time range',
          startDate: new Date(2019, 0, 1, 6),
          duration: 2,
          durationUnit: 'h',
          timeRangeColor: 'green',
          resourceId: 'r' + ++newRangeCount
        });
      }
    }
  }, {
    type: 'button',
    icon: 'b-fa-clock',
    text: 'Move lunch',
    onAction: function onAction() {
      scheduler.resourceTimeRangeStore.forEach(function (range) {
        if (range.name === 'Lunch') {
          range.startDate = DateHelper.add(range.startDate, 1, 'hour');
        }
      });
    }
  }]
});