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
    RecurringTimeSpan = _bryntum$scheduler.RecurringTimeSpan,
    TimeSpan = _bryntum$scheduler.TimeSpan,
    RecurringTimeSpansMixin = _bryntum$scheduler.RecurringTimeSpansMixin,
    Store = _bryntum$scheduler.Store,
    DateHelper = _bryntum$scheduler.DateHelper; //region Data
// Define a new Model extending TimeSpan class
// with RecurringTimeSpan mixin which adds recurrence support

var MyTimeRange = /*#__PURE__*/function (_RecurringTimeSpan) {
  _inherits(MyTimeRange, _RecurringTimeSpan);

  var _super = _createSuper(MyTimeRange);

  function MyTimeRange() {
    _classCallCheck(this, MyTimeRange);

    return _super.apply(this, arguments);
  }

  return MyTimeRange;
}(RecurringTimeSpan(TimeSpan)); // Define a new store extending the Store class
// with RecurringTimeSpansMixin mixin to add recurrence support to the store.
// This store will contain time ranges.


var MyTimeRangeStore = /*#__PURE__*/function (_RecurringTimeSpansMi) {
  _inherits(MyTimeRangeStore, _RecurringTimeSpansMi);

  var _super2 = _createSuper(MyTimeRangeStore);

  function MyTimeRangeStore() {
    _classCallCheck(this, MyTimeRangeStore);

    return _super2.apply(this, arguments);
  }

  _createClass(MyTimeRangeStore, null, [{
    key: "defaultConfig",
    get: function get() {
      return {
        // use our new MyTimeRange model
        modelClass: MyTimeRange,
        storeId: 'timeRanges'
      };
    }
  }]);

  return MyTimeRangeStore;
}(RecurringTimeSpansMixin(Store)); // instantiate store for time ranges using our new classes


var myTimeRangeStore = new MyTimeRangeStore(); //endregion

var scheduler = new Scheduler({
  appendTo: 'container',
  eventStyle: 'colored',
  resourceImagePath: '../_shared/images/users/',
  features: {
    timeRanges: {
      showCurrentTimeLine: true,
      showHeaderElements: false
    }
  },
  columns: [{
    type: 'resourceInfo',
    text: 'Staff',
    field: 'name',
    width: '10em'
  }],
  project: {
    // use our store for time ranges (crudManager will load it automatically among other project stores)
    timeRangeStore: myTimeRangeStore
  },
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  barMargin: 5,
  startDate: new Date(2019, 1, 7, 8),
  endDate: new Date(2019, 1, 29, 18),
  viewPreset: {
    tickWidth: 50,
    base: 'dayAndWeek'
  },
  tbar: [{
    type: 'button',
    ref: 'addCoffeeButton',
    icon: 'b-fa-coffee',
    text: 'More coffee',
    tooltip: 'Click to add morning coffee to Thursdays too',
    onAction: function onAction(_ref) {
      var button = _ref.source;
      var coffee = scheduler.features.timeRanges.store.getById(1);
      coffee.recurrenceRule = 'FREQ=WEEKLY;BYDAY=MO,TH;';
      button.disable();
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
      scheduler.setTimeSpan(new Date(2019, 1, 7, 8), new Date(2019, 1, 29, 18));
    }
  }]
});