function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr == null ? null : typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]; if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

StartTest(function (t) {
  var _t$getDSTDates = t.getDSTDates(2021),
      _t$getDSTDates2 = _slicedToArray(_t$getDSTDates, 2),
      springDSTDate = _t$getDSTDates2[0],
      autumnDSTDate = _t$getDSTDates2[1];

  if (!springDSTDate) {
    t.pass('Current timezone does not have DST');
    return;
  }

  var springStartDate = DateHelper.add(springDSTDate, -4, 'h'),
      springEndDate = DateHelper.add(springDSTDate, 12, 'h'),
      autumnStartDate = DateHelper.add(autumnDSTDate, -4, 'h'),
      autumnEndDate = DateHelper.add(autumnDSTDate, 12, 'h');
  var scheduler;
  t.beforeEach(function () {
    var _scheduler;

    (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });
  t.it('Should properly render events which pass through DST', function (t) {
    function assertScheduler(_x, _x2, _x3, _x4) {
      return _assertScheduler.apply(this, arguments);
    }

    function _assertScheduler() {
      _assertScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t, startDate, endDate, eventStartDate) {
        var i;
        return regeneratorRuntime.wrap(function _callee3$(_context3) {
          while (1) {
            switch (_context3.prev = _context3.next) {
              case 0:
                _context3.next = 2;
                return t.getSchedulerAsync({
                  appendTo: document.body,
                  startDate: startDate,
                  endDate: endDate,
                  viewPreset: 'hourAndDay',
                  tickSize: 40,
                  height: 350,
                  resources: [{
                    id: 'r1',
                    name: 'Albert'
                  }],
                  events: []
                });

              case 2:
                scheduler = _context3.sent;

                for (i = 1; i < 8; i++) {
                  scheduler.eventStore.add({
                    id: i,
                    resourceId: 'r1',
                    startDate: eventStartDate,
                    endDate: DateHelper.add(eventStartDate, i, 'h'),
                    durationUnit: 'h'
                  });
                }

                _context3.next = 6;
                return t.waitForSelector('.b-sch-event');

              case 6:
                scheduler.eventStore.forEach(function (record) {
                  var _scheduler$getElement = scheduler.getElementsFromEventRecord(record, null, true),
                      _scheduler$getElement2 = _slicedToArray(_scheduler$getElement, 1),
                      eventEl = _scheduler$getElement2[0];

                  t.isApprox(eventEl.offsetWidth, record.duration * scheduler.tickSize, 1, "Event ".concat(record.id, " size is ok"));
                });

              case 7:
              case "end":
                return _context3.stop();
            }
          }
        }, _callee3);
      }));
      return _assertScheduler.apply(this, arguments);
    }

    t.it('Should correctly render events passing through DST (spring)', /*#__PURE__*/function () {
      var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
        return regeneratorRuntime.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                _context.next = 2;
                return assertScheduler(t, springStartDate, springEndDate, springDSTDate);

              case 2:
              case "end":
                return _context.stop();
            }
          }
        }, _callee);
      }));

      return function (_x5) {
        return _ref.apply(this, arguments);
      };
    }());
    t.it('Should correctly render events passing through DST (autumn)', /*#__PURE__*/function () {
      var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
        return regeneratorRuntime.wrap(function _callee2$(_context2) {
          while (1) {
            switch (_context2.prev = _context2.next) {
              case 0:
                _context2.next = 2;
                return assertScheduler(t, autumnStartDate, autumnEndDate, autumnDSTDate);

              case 2:
              case "end":
                return _context2.stop();
            }
          }
        }, _callee2);
      }));

      return function (_x6) {
        return _ref2.apply(this, arguments);
      };
    }());
  });
  t.it('Time range duration is ok when dragging over DST', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var springExactDST, autumnExactDST;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              springExactDST = t.getExactDSTDate(springDSTDate), autumnExactDST = t.getExactDSTDate(autumnDSTDate);
              _context8.next = 3;
              return t.getSchedulerAsync({
                appendTo: document.body,
                startDate: springStartDate,
                endDate: springEndDate,
                features: {
                  timeRanges: {
                    enableResizing: true
                  }
                },
                viewPreset: {
                  base: 'hourAndDay',
                  timeResolution: {
                    unit: 'h',
                    increment: 1
                  }
                },
                tickSize: 40,
                height: 100,
                resources: [{
                  id: 'r1',
                  name: 'Albert'
                }],
                timeRanges: [{
                  startDate: DateHelper.add(springExactDST, 1, 'h'),
                  endDate: DateHelper.add(springExactDST, 2, 'h'),
                  cls: 'spring'
                }, {
                  startDate: DateHelper.add(autumnExactDST, 1, 'h'),
                  endDate: DateHelper.add(autumnExactDST, 2, 'h'),
                  cls: 'autumn'
                }]
              });

            case 3:
              scheduler = _context8.sent;
              t.chain({
                drag: '.spring',
                by: [-scheduler.tickSize, 0]
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
                return regeneratorRuntime.wrap(function _callee4$(_context4) {
                  while (1) {
                    switch (_context4.prev = _context4.next) {
                      case 0:
                        t.hasApproxWidth('.spring', scheduler.tickSize, 0.5, 'Time range width is ok');

                      case 1:
                      case "end":
                        return _context4.stop();
                    }
                  }
                }, _callee4);
              })), {
                drag: '.spring',
                by: [scheduler.tickSize, 0]
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
                return regeneratorRuntime.wrap(function _callee5$(_context5) {
                  while (1) {
                    switch (_context5.prev = _context5.next) {
                      case 0:
                        t.hasApproxWidth('.spring', scheduler.tickSize, 0.5, 'Time range width is ok');
                        scheduler.setTimeSpan(autumnStartDate, autumnEndDate);

                      case 2:
                      case "end":
                        return _context5.stop();
                    }
                  }
                }, _callee5);
              })), {
                drag: '.autumn',
                by: [-scheduler.tickSize, 0]
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6() {
                return regeneratorRuntime.wrap(function _callee6$(_context6) {
                  while (1) {
                    switch (_context6.prev = _context6.next) {
                      case 0:
                        t.hasApproxWidth('.autumn', scheduler.tickSize, 0.5, 'Time range width is ok');

                      case 1:
                      case "end":
                        return _context6.stop();
                    }
                  }
                }, _callee6);
              })), {
                drag: '.autumn',
                by: [scheduler.tickSize, 0]
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                return regeneratorRuntime.wrap(function _callee7$(_context7) {
                  while (1) {
                    switch (_context7.prev = _context7.next) {
                      case 0:
                        t.hasApproxWidth('.autumn', scheduler.tickSize, 0.5, 'Time range width is ok');

                      case 1:
                      case "end":
                        return _context7.stop();
                    }
                  }
                }, _callee7);
              })));

            case 5:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x7) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Event duration is ok when dragging over DST', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var springExactDST, autumnExactDST, gap, _scheduler2, tickSize;

      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              springExactDST = t.getExactDSTDate(springDSTDate), autumnExactDST = t.getExactDSTDate(autumnDSTDate), gap = t.bowser.safari ? 2 : 1.1;
              _context9.next = 3;
              return t.getSchedulerAsync({
                appendTo: document.body,
                startDate: springStartDate,
                endDate: springEndDate,
                viewPreset: {
                  base: 'hourAndDay',
                  timeResolution: {
                    unit: 'h',
                    increment: 1
                  }
                },
                tickSize: 40,
                height: 200,
                resources: [{
                  id: 'r1',
                  name: 'Albert'
                }],
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: DateHelper.add(springExactDST, -2, 'h'),
                  endDate: springExactDST,
                  cls: 'event-1'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  startDate: springExactDST,
                  endDate: DateHelper.add(springExactDST, 2, 'h'),
                  cls: 'event-2'
                }, {
                  id: 3,
                  resourceId: 'r1',
                  startDate: DateHelper.add(autumnExactDST, -2, 'h'),
                  endDate: autumnExactDST,
                  cls: 'event-3'
                }, {
                  id: 4,
                  resourceId: 'r1',
                  startDate: autumnExactDST,
                  endDate: DateHelper.add(autumnExactDST, 2, 'h'),
                  cls: 'event-4'
                }]
              });

            case 3:
              scheduler = _context9.sent;
              _scheduler2 = scheduler, tickSize = _scheduler2.tickSize;
              _context9.next = 7;
              return t.dragBy({
                source: '.event-2',
                delta: [tickSize, 0]
              });

            case 7:
              t.hasApproxWidth('.event-2', tickSize * 2, gap, 'Event 2 width is ok');
              _context9.next = 10;
              return t.dragBy({
                source: '.event-1',
                delta: [tickSize, 0]
              });

            case 10:
              t.hasApproxWidth('.event-1', tickSize * 2, gap, 'Event 1 width is ok');
              scheduler.setTimeSpan(autumnStartDate, autumnEndDate);
              _context9.next = 14;
              return t.dragBy({
                source: '.event-4',
                delta: [tickSize, 0]
              });

            case 14:
              t.hasApproxWidth('.event-4', tickSize * 2, gap, 'Event 4 width is ok');
              _context9.next = 17;
              return t.dragBy({
                source: '.event-3',
                delta: [tickSize, 0]
              });

            case 17:
              t.hasApproxWidth('.event-3', tickSize * 2, gap, 'Event 3 width is ok');

            case 18:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x8) {
      return _ref8.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2520

  t.it('Events are rendered correctly with uneven ticks caused by DST transition', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var startDate, endDate, event1, event2, gap;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              startDate = new Date(springStartDate.getFullYear(), springStartDate.getMonth(), springStartDate.getDate() - 1), endDate = new Date(springEndDate.getFullYear(), springEndDate.getMonth(), springEndDate.getDate() + 2);
              _context10.next = 3;
              return t.getSchedulerAsync({
                appendTo: document.body,
                startDate: startDate,
                endDate: endDate,
                viewPreset: {
                  base: 'hourAndDay',
                  headers: [{
                    dateFormat: 'ddd MM/DD',
                    unit: 'day',
                    increment: 1
                  }, {
                    dateFormat: 'LST',
                    unit: 'hour',
                    increment: 6
                  }],
                  timeResolution: {
                    unit: 'h',
                    increment: 6
                  }
                },
                tickSize: 40,
                height: 200,
                resources: [{
                  id: 'r1',
                  name: 'Albert'
                }],
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(springStartDate.getFullYear(), springStartDate.getMonth(), springStartDate.getDate()),
                  endDate: new Date(springStartDate.getFullYear(), springStartDate.getMonth(), springStartDate.getDate() + 1),
                  cls: 'event-1'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  startDate: new Date(springStartDate.getFullYear(), springStartDate.getMonth(), springStartDate.getDate() + 1),
                  endDate: new Date(springStartDate.getFullYear(), springStartDate.getMonth(), springStartDate.getDate() + 2),
                  cls: 'event-2'
                }, {
                  id: 3,
                  resourceId: 'r1',
                  startDate: new Date(autumnStartDate.getFullYear(), autumnStartDate.getMonth(), autumnStartDate.getDate()),
                  endDate: new Date(autumnStartDate.getFullYear(), autumnStartDate.getMonth(), autumnStartDate.getDate() + 1),
                  cls: 'event-3'
                }, {
                  id: 4,
                  resourceId: 'r1',
                  startDate: new Date(autumnStartDate.getFullYear(), autumnStartDate.getMonth(), autumnStartDate.getDate() + 1),
                  endDate: new Date(autumnStartDate.getFullYear(), autumnStartDate.getMonth(), autumnStartDate.getDate() + 2),
                  cls: 'event-4'
                }]
              });

            case 3:
              scheduler = _context10.sent;
              _context10.next = 6;
              return t.waitForSelector('.event-1');

            case 6:
              event1 = scheduler.eventStore.getById(1), event2 = scheduler.eventStore.getById(2), gap = t.bowser.safari ? 2 : 1;
              [event1, event2].forEach(function (record) {
                var _scheduler$getElement3 = scheduler.getElementsFromEventRecord(record),
                    _scheduler$getElement4 = _slicedToArray(_scheduler$getElement3, 1),
                    el = _scheduler$getElement4[0],
                    box = el.getBoundingClientRect();

                t.isApproxPx(box.left, scheduler.getCoordinateFromDate(record.startDate, {
                  local: false
                }), gap, "Event ".concat(record.id, " start date is ok"));
                t.isApproxPx(box.right, scheduler.getCoordinateFromDate(record.endDate, {
                  local: false
                }), gap, "Event ".concat(record.id, " end date is ok"));
              });
              t.subTest('Spring DST', function (t) {
                scheduler.timeAxis.forEach(function (tick, i) {
                  t.is(scheduler.getCoordinateFromDate(tick.startDate), i * scheduler.tickSize, "Tick ".concat(i, " start date position is ok"));
                });
              });
              scheduler.setTimeSpan(new Date(autumnStartDate.getFullYear(), autumnStartDate.getMonth(), autumnStartDate.getDate() - 1), new Date(autumnEndDate.getFullYear(), autumnEndDate.getMonth(), autumnEndDate.getDate() + 2));
              t.subTest('Autumn DST', function (t) {
                scheduler.timeAxis.forEach(function (tick, i) {
                  t.is(scheduler.getCoordinateFromDate(tick.startDate), i * scheduler.tickSize, "Tick ".concat(i, " start date position is ok"));
                });
              });

            case 11:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x9) {
      return _ref9.apply(this, arguments);
    };
  }());
});