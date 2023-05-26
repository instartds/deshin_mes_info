function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

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

StartTest(function (t) {
  var scheduler; // Setup model & store supporting recurrence

  var MyResourceTimeRange = /*#__PURE__*/function (_RecurringTimeSpan) {
    _inherits(MyResourceTimeRange, _RecurringTimeSpan);

    var _super = _createSuper(MyResourceTimeRange);

    function MyResourceTimeRange() {
      _classCallCheck(this, MyResourceTimeRange);

      return _super.apply(this, arguments);
    }

    return MyResourceTimeRange;
  }(RecurringTimeSpan(ResourceTimeRangeModel));

  ;

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
          modelClass: MyResourceTimeRange
        };
      }
    }]);

    return MyResourceTimeRangeStore;
  }(RecurringTimeSpansMixin(ResourceTimeRangeStore));

  ;
  var rangeSelector = '.b-sch-resourcetimerange:not(.b-sch-released)';
  t.beforeEach(function (t) {
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });
  t.it('Should display recurring resource time ranges occurrences', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2019, 0, 1),
                endDate: new Date(2019, 0, 2),
                autoAdjustTimeAxis: false,
                features: {
                  resourceTimeRanges: true
                },
                resources: [{
                  id: 'r1',
                  name: 'Mike'
                }],
                resourceTimeRangeStore: new MyResourceTimeRangeStore({
                  data: [{
                    id: 1,
                    resourceId: 'r1',
                    startDate: '2019-01-01T13:00',
                    endDate: '2019-01-01T14:00',
                    name: 'lunch',
                    recurrenceRule: 'FREQ=DAILY'
                  }]
                })
              });
              _context.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.selectorCountIs(rangeSelector, 1, '1 range element found');
              scheduler.endDate = new Date(2019, 0, 3);
              t.selectorCountIs(rangeSelector, 2, '2 range elements found');
              scheduler.endDate = new Date(2019, 0, 4);
              t.selectorCountIs(rangeSelector, 3, '3 range elements found');

            case 8:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
});