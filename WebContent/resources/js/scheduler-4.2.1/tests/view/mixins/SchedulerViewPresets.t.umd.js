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

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    var _scheduler, _scheduler$destroy;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : (_scheduler$destroy = _scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(_scheduler);
  });
  t.it('Display date format should have priority over view preset', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var tip;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getSchedulerAsync({
                displayDateFormat: 'foo'
              });

            case 2:
              scheduler = _context3.sent;
              tip = scheduler.features.scheduleTooltip.hoverTip;
              t.chain({
                waitForAnimationFrame: null
              }, {
                moveMouseTo: '.b-sch-timeaxis-cell',
                offset: [20, '50%']
              }, {
                waitForSelector: '.b-sch-scheduletip:not(.b-hidden)',
                desc: 'Waiting for cell tooltip'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        t.is(tip.contentElement.querySelector('.b-sch-clock-text').innerText, 'foo', 'Tip contained correct data');

                      case 1:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })), {
                moveMouseTo: '.b-grid-header'
              }, {
                waitForSelectorNotFound: '.b-sch-scheduletip:not(.b-hidden)',
                desc: 'Waiting for cell tooltip'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        scheduler.zoomToLevel(5);

                      case 1:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              })), {
                waitForAnimationFrame: null
              }, {
                moveMouseTo: '.b-grid-header',
                offset: ['150%', '150%']
              }, {
                waitForSelector: '.b-sch-scheduletip:not(.b-hidden)',
                desc: 'Waiting for cell tooltip'
              }, function () {
                t.is(tip.contentElement.querySelector('.b-sch-clock-text').innerText, 'foo', 'Tip contained correct data');
              });

            case 5:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Should refresh correctly when returning to initial preset', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'hourAndDay',
                startDate: new Date(2011, 0, 4),
                endDate: new Date(2011, 0, 5)
              });

            case 2:
              scheduler = _context4.sent;
              scheduler.viewPreset = 'dayAndWeek';
              t.firesOnce(scheduler, 'beforePresetChange');
              t.firesOnce(scheduler.timeAxisViewModel, 'reconfigure');
              scheduler.viewPreset = 'hourAndDay';

            case 7:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x2) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should format time correctly for all presets with time value', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var viewPresetsWithTime, i, preset, val;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              viewPresetsWithTime = ['secondAndMinute', 'secondAndMinute-60by40', 'secondAndMinute-130by40', 'minuteAndHour', 'minuteAndHour-30by60', 'minuteAndHour-130by60', 'minuteAndHour-60by60', 'minuteAndHour-100by60', 'hourAndDay', 'hourAndDay-64by40', 'hourAndDay-100by40', 'hourAndDay-64by40-2', 'weekAndDay', 'weekAndDay-54by80', 'dayAndWeek'];
              _context5.next = 3;
              return t.getSchedulerAsync({
                viewPreset: 'secondAndMinute',
                startDate: new Date(2017, 0, 1, 1, 0),
                endDate: new Date(2017, 0, 1, 8, 0),
                events: [{
                  id: 1,
                  name: 'Work',
                  resourceId: 'r1',
                  startDate: new Date(2017, 0, 1, 1, 0),
                  endDate: new Date(2017, 0, 1, 2, 0)
                }]
              });

            case 3:
              scheduler = _context5.sent;
              i = 0;

            case 5:
              if (!(i < viewPresetsWithTime.length)) {
                _context5.next = 28;
                break;
              }

              preset = viewPresetsWithTime[i];
              val = preset.includes('secondAndMinute') ? '1:00:00 AM' : '1 AM';
              t.diag("Preset ".concat(preset));
              _context5.next = 11;
              return t.waitForAnimationFrame();

            case 11:
              _context5.next = 13;
              return t.moveMouseTo([0, 0]);

            case 13:
              _context5.next = 15;
              return t.waitForSelectorNotFound('.b-sch-event-tooltip');

            case 15:
              scheduler.viewPreset = preset;
              _context5.next = 18;
              return scheduler.scrollEventIntoView(scheduler.eventStore.first);

            case 18:
              _context5.next = 20;
              return t.waitForAnimationFrame();

            case 20:
              _context5.next = 22;
              return t.moveMouseTo('[data-event-id=1]', null, null, [1, 10]);

            case 22:
              _context5.next = 24;
              return t.waitForSelector('.b-sch-event-tooltip');

            case 24:
              t.selectorExists(".b-sch-event-tooltip:contains(".concat(val, ")"), "Correct format for preset ".concat(preset));

            case 25:
              i++;
              _context5.next = 5;
              break;

            case 28:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x3) {
      return _ref5.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1889

  t.it('Should apply viewPreset config object when subclassing', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var MyScheduler;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              MyScheduler = /*#__PURE__*/function (_Scheduler) {
                _inherits(MyScheduler, _Scheduler);

                var _super = _createSuper(MyScheduler);

                function MyScheduler() {
                  _classCallCheck(this, MyScheduler);

                  return _super.apply(this, arguments);
                }

                _createClass(MyScheduler, null, [{
                  key: "configurable",
                  get: function get() {
                    return {
                      viewPreset: {
                        base: 'weekAndDayLetter',
                        tickWidth: 300,
                        headers: [{
                          unit: 'month',
                          align: 'center',
                          dateFormat: 'MMMM YY'
                        }, {
                          unit: 'd',
                          align: 'center',
                          dateFormat: 'd0'
                        }]
                      }
                    };
                  }
                }]);

                return MyScheduler;
              }(Scheduler);

              scheduler = new MyScheduler({
                appendTo: t.global.document.body
              });
              _context6.next = 4;
              return t.waitForProjectReady(scheduler);

            case 4:
              t.is(t.rect('.b-sch-header-row.b-lowest .b-sch-header-timeaxis-cell').width, 300, 'viewPreset tickWidth config applied');

            case 5:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x4) {
      return _ref6.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2598

  t.it('Should be possible to detect in DOM what ViewPreset is used', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return t.getSchedulerAsync();

            case 2:
              scheduler = _context7.sent;
              _context7.next = 5;
              return t.waitForSelector(".b-scheduler[data-preset-id=\"".concat(scheduler.viewPreset.id, "\"]"));

            case 5:
              scheduler.zoomIn();
              _context7.next = 8;
              return t.waitForSelector(".b-scheduler[data-preset-id=\"".concat(scheduler.viewPreset.id, "\"]"));

            case 8:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x5) {
      return _ref7.apply(this, arguments);
    };
  }());
});