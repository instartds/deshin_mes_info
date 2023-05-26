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
    Scheduler = _bryntum$scheduler.Scheduler,
    ResourceModel = _bryntum$scheduler.ResourceModel,
    DateHelper = _bryntum$scheduler.DateHelper,
    LocaleManager = _bryntum$scheduler.LocaleManager;
/* eslint-disable no-unused-vars */

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
      return [// Using icons for resources
      {
        name: 'image',
        defaultValue: false
      }];
    }
  }]);

  return Property;
}(ResourceModel);

var scheduler = new Scheduler({
  appendTo: 'container',
  startDate: new Date(2017, 11, 1),
  endDate: new Date(2017, 11, 20),
  barMargin: 10,
  rowHeight: 60,
  viewPreset: 'weekAndDayLetter',
  features: {
    // Shade non-working days
    nonWorkingTime: true
  },
  // CrudManager loads all data from a single source
  crudManager: {
    resourceStore: {
      modelClass: Property
    },
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  resourceImagePath: '../_shared/images/users/',
  columns: [{
    type: 'resourceInfo',
    width: 200
  }],
  tbar: ['->', {
    type: 'widget',
    cls: 'b-has-label',
    html: '<label>Non-working days</label>'
  }, {
    type: 'buttongroup',
    ref: 'nonWorkingDays',
    defaults: {
      cls: 'b-raised',
      toggleable: true
    },
    items: DateHelper.getDayShortNames().map(function (name, index) {
      return {
        text: name,
        pressed: DateHelper.nonWorkingDays[index],
        index: index
      };
    }),
    listeners: {
      click: 'up.onNonWorkingDayChange'
    }
  }],
  onNonWorkingDayChange: function onNonWorkingDayChange() {
    var // Collect an array of pressed button indices
    values = this.widgetMap.nonWorkingDays.items.filter(function (button) {
      return button.pressed;
    }).map(function (button) {
      return button.index;
    }),
        // Convert array [0, 6] to object { 0 : true, 6 : true } for example
    days = values.reduce(function (acc, day) {
      acc[day] = true;
      return acc;
    }, {}); // Update nonWorkingDays in current locale

    LocaleManager.locale.DateHelper.nonWorkingDays = days; // Force-apply current locale to update non-working intervals

    LocaleManager.applyLocale(LocaleManager.locale.localeName, true);
  },
  listeners: {
    paint: function paint(_ref) {
      var firstPaint = _ref.firstPaint,
          source = _ref.source;

      // Update widget buttons on locale change
      if (firstPaint) {
        LocaleManager.on({
          locale: function locale() {
            var days = DateHelper.getDayShortNames(),
                weekends = DateHelper.nonWorkingDays,
                nonWorkingDays = this.widgetMap.nonWorkingDays;
            nonWorkingDays.suspendEvents();
            nonWorkingDays.eachWidget(function (button) {
              button.text = days[button.index];
              button.pressed = weekends[button.index];
            });
            nonWorkingDays.resumeEvents();
          },
          thisObj: source
        });
      }
    }
  }
});