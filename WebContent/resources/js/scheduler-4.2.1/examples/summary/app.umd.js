function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

var _templateObject, _templateObject2, _templateObject3, _templateObject4;

function _taggedTemplateLiteral(strings, raw) { if (!raw) { raw = strings.slice(0); } return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

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
    Scheduler = _bryntum$scheduler.Scheduler,
    ResourceModel = _bryntum$scheduler.ResourceModel,
    EventModel = _bryntum$scheduler.EventModel,
    StringHelper = _bryntum$scheduler.StringHelper;

var Property = /*#__PURE__*/function (_ResourceModel) {
  _inherits(Property, _ResourceModel);

  var _super = _createSuper(Property);

  function Property() {
    _classCallCheck(this, Property);

    return _super.apply(this, arguments);
  }

  _createClass(Property, null, [{
    key: "fields",
    get: function get() {
      return ['sleeps', // Using icons for resources
      {
        name: 'image',
        defaultValue: false
      }];
    }
  }]);

  return Property;
}(ResourceModel);

var Booking = /*#__PURE__*/function (_EventModel) {
  _inherits(Booking, _EventModel);

  var _super2 = _createSuper(Booking);

  function Booking() {
    _classCallCheck(this, Booking);

    return _super2.apply(this, arguments);
  }

  _createClass(Booking, null, [{
    key: "fields",
    get: function get() {
      return [{
        name: 'guests',
        defaultValue: 2
      }];
    }
  }]);

  return Booking;
}(EventModel);

var scheduler = new Scheduler({
  appendTo: 'container',
  eventStyle: 'line',
  viewPreset: 'weekAndDayLetter',
  rowHeight: 60,
  barMargin: 15,
  resourceImagePath: '../_shared/images/users/',
  features: {
    summary: {
      renderer: function renderer(_ref) {
        var reservations = _ref.events;
        var result;

        if (scheduler.widgetMap.summaryCombo.value === 'count') {
          result = reservations.length;
        } else {
          result = reservations.reduce(function (total, reservation) {
            return total += reservation.guests;
          }, 0);
        }

        result = result || '';
        return StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["", ""])), result);
      }
    },
    eventEdit: {
      editorConfig: {
        defaults: {
          labelPosition: 'above'
        }
      },
      items: {
        startDateField: {
          flex: '1 0 50%'
        },
        endDateField: {
          flex: '1 0 50%',
          cls: ''
        },
        startTimeField: false,
        endTimeField: false,
        // Custom field for number of guests
        guestsField: {
          type: 'number',
          name: 'guests',
          label: 'Guests',
          weight: 210,
          value: 2,
          required: true,
          min: 1
        }
      }
    }
  },
  startDate: new Date(2017, 11, 1),
  endDate: new Date(2017, 11, 20),
  allowOverlap: false,
  tbar: [{
    type: 'combo',
    ref: 'summaryCombo',
    width: 300,
    label: 'Summary:',
    displayField: 'name',
    valueField: 'id',
    editable: false,
    items: [{
      id: 'count',
      name: 'Booked properties / day'
    }, {
      id: 'guests',
      name: 'Booked guests / day'
    }],
    value: 'count',
    onChange: function onChange() {
      scheduler.features.summary.refresh();
    }
  }, {
    text: 'Sum selected rows',
    toggleable: true,
    onToggle: 'up.onSelectToggle'
  }],
  tickSize: 80,
  columns: [{
    type: 'resourceInfo',
    text: 'Name',
    width: 200,
    sum: 'count',
    summaryRenderer: function summaryRenderer(_ref2) {
      var sum = _ref2.sum;
      return StringHelper.xss(_templateObject2 || (_templateObject2 = _taggedTemplateLiteral(["Total properties: ", ""])), sum);
    },
    showEventCount: false,
    showMeta: function showMeta(property) {
      return StringHelper.xss(_templateObject3 || (_templateObject3 = _taggedTemplateLiteral(["Sleeps ", ""])), property.sleeps);
    }
  }],
  crudManager: {
    autoLoad: true,
    resourceStore: {
      modelClass: Property
    },
    eventStore: {
      modelClass: Booking
    },
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  eventRenderer: function eventRenderer(_ref3) {
    var eventRecord = _ref3.eventRecord;
    return StringHelper.xss(_templateObject4 || (_templateObject4 = _taggedTemplateLiteral(["", " <i class=\"b-fa b-fa-user\"><sup>", "</sup>"])), eventRecord.name, eventRecord.guests);
  },
  onSelectToggle: function onSelectToggle() {
    this.features.summary.selectedOnly = !this.features.summary.selectedOnly;
  }
});