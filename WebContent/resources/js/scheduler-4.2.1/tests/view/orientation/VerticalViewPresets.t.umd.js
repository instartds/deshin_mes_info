function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
  });

  function createScheduler() {
    return _createScheduler.apply(this, arguments);
  }

  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15() {
      var config,
          _args15 = arguments;
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              config = _args15.length > 0 && _args15[0] !== undefined ? _args15[0] : {};
              _context15.next = 3;
              return t.getVerticalSchedulerAsync(config);

            case 3:
              scheduler = _context15.sent;

            case 4:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));
    return _createScheduler.apply(this, arguments);
  }

  function assertEventElement(t, eventId) {
    var x = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
    var y = arguments.length > 3 ? arguments[3] : undefined;
    var width = arguments.length > 4 ? arguments[4] : undefined;
    var height = arguments.length > 5 ? arguments[5] : undefined;
    var msg = arguments.length > 6 && arguments[6] !== undefined ? arguments[6] : '';
    var selector = "[data-event-id=\"".concat(eventId, "\"]:not(.b-released)");

    if (x === null) {
      t.selectorNotExists(selector, 'Element not found ' + msg);
    } else {
      var element = document.querySelector(selector);
      t.ok(element, 'Element found ' + msg);
      var box = Rectangle.from(element, scheduler.timeAxisSubGridElement);
      t.isApprox(box.left, x, 'Correct x');
      t.isApprox(box.top, y, 'Correct y');
      t.isApprox(box.width, width, 'Correct width');
      t.isApprox(box.height, height, 'Correct height');
    }
  }

  t.it('secondAndMinute', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var tickHeight;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              tickHeight = 40;
              _context.next = 3;
              return createScheduler({
                viewPreset: 'secondAndMinute',
                startDate: new Date(2019, 5, 1, 10),
                endDate: new Date(2019, 5, 1, 10, 10),
                // 6 * 10 = 60 ticks
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2019, 5, 1, 10, 1),
                  duration: 1,
                  durationUnit: 'minute'
                }]
              });

            case 3:
              t.is(scheduler.timeAxisSubGridElement.offsetHeight, 60 * tickHeight, 'Correct height');
              assertEventElement(t, 1, 0, 6 * tickHeight, 150, 6 * tickHeight);

            case 5:
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
  t.it('minuteAndHour', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var tickHeight;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              tickHeight = 60;
              _context2.next = 3;
              return createScheduler({
                viewPreset: 'minuteAndHour',
                startDate: new Date(2019, 5, 1, 10),
                endDate: new Date(2019, 5, 1, 20),
                // 10 * 2 = 20 ticks
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2019, 5, 1, 11),
                  duration: 1,
                  durationUnit: 'hour'
                }]
              });

            case 3:
              t.is(scheduler.timeAxisSubGridElement.offsetHeight, 20 * tickHeight, 'Correct height');
              assertEventElement(t, 1, 0, 2 * tickHeight, 150, 2 * tickHeight);

            case 5:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('hourAndDay', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var tickHeight;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              tickHeight = 40;
              _context3.next = 3;
              return createScheduler({
                viewPreset: 'hourAndDay',
                startDate: new Date(2019, 5, 1),
                endDate: new Date(2019, 5, 4),
                // 3 * 24 = 72 ticks
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2019, 5, 1, 11),
                  duration: 2,
                  durationUnit: 'hour'
                }]
              });

            case 3:
              t.is(scheduler.timeAxisSubGridElement.offsetHeight, 72 * tickHeight, 'Correct height');
              assertEventElement(t, 1, 0, 11 * tickHeight, 150, 2 * tickHeight);

            case 5:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('dayAndWeek', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var tickHeight;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              tickHeight = 80;
              _context4.next = 3;
              return createScheduler({
                viewPreset: 'dayAndWeek',
                startDate: new Date(2019, 5, 2),
                endDate: new Date(2019, 5, 23),
                // 21 ticks
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2019, 5, 3),
                  duration: 2,
                  durationUnit: 'days'
                }]
              });

            case 3:
              t.is(scheduler.timeAxisSubGridElement.offsetHeight, 21 * tickHeight, 'Correct height');
              assertEventElement(t, 1, 0, tickHeight, 150, 2 * tickHeight);

            case 5:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('weekAndDay', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var tickHeight;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              tickHeight = 80;
              _context5.next = 3;
              return createScheduler({
                viewPreset: 'weekAndDay',
                startDate: new Date(2019, 5, 2),
                endDate: new Date(2019, 5, 23),
                // 21 ticks
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2019, 5, 3),
                  duration: 2,
                  durationUnit: 'days'
                }]
              });

            case 3:
              t.is(scheduler.timeAxisSubGridElement.offsetHeight, 21 * tickHeight, 'Correct height');
              assertEventElement(t, 1, 0, tickHeight, 150, 2 * tickHeight);

            case 5:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x5) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('weekAndMonth', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var tickHeight;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              tickHeight = 105;
              _context6.next = 3;
              return createScheduler({
                viewPreset: 'weekAndMonth',
                startDate: new Date(2019, 5, 2),
                endDate: new Date(2019, 9, 1),
                // 18 ticks
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2019, 5, 9),
                  duration: 1,
                  durationUnit: 'week'
                }]
              });

            case 3:
              t.is(scheduler.timeAxisSubGridElement.offsetHeight, 18 * tickHeight, 'Correct height');
              assertEventElement(t, 1, 0, tickHeight, 150, tickHeight);

            case 5:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('monthAndYear', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var tickHeight;
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              tickHeight = 110;
              _context7.next = 3;
              return createScheduler({
                viewPreset: 'monthAndYear',
                startDate: new Date(2019, 5, 1),
                endDate: new Date(2021, 6, 1),
                // 25 ticks
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2019, 6, 1),
                  duration: 3,
                  durationUnit: 'months'
                }]
              });

            case 3:
              t.is(scheduler.timeAxisSubGridElement.offsetHeight, 25 * tickHeight, 'Correct height');
              assertEventElement(t, 1, 0, tickHeight, 150, 3 * tickHeight);

            case 5:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x7) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('year', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var tickHeight;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              tickHeight = 100;
              _context8.next = 3;
              return createScheduler({
                viewPreset: 'year',
                startDate: new Date(2019, 1, 1),
                endDate: new Date(2022, 12, 31),
                // 17 ticks
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2019, 6, 1),
                  duration: 3,
                  durationUnit: 'quarters'
                }]
              });

            case 3:
              t.is(scheduler.timeAxisSubGridElement.offsetHeight, 17 * tickHeight, 'Correct height');
              assertEventElement(t, 1, 0, 2 * tickHeight, 150, 3 * tickHeight);

            case 5:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x8) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('manyYears', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var tickHeight;
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              tickHeight = 50;
              _context9.next = 3;
              return createScheduler({
                viewPreset: 'manyYears',
                startDate: new Date(2010, 1, 1),
                endDate: new Date(2030, 12, 31),
                // 22 ticks
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2010, 6, 1),
                  duration: 4,
                  durationUnit: 'years'
                }]
              });

            case 3:
              t.is(scheduler.timeAxisSubGridElement.offsetHeight, 22 * tickHeight, 'Correct height');
              assertEventElement(t, 1, 0, tickHeight / 2, 150, 4 * tickHeight);

            case 5:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x9) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('weekAndDayLetter', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var tickHeight;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              tickHeight = 50;
              _context10.next = 3;
              return createScheduler({
                viewPreset: 'weekAndDayLetter',
                startDate: new Date(2019, 5, 1),
                endDate: new Date(2019, 6, 30),
                // 70 ticks
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2019, 5, 10),
                  duration: 5,
                  durationUnit: 'd'
                }]
              });

            case 3:
              t.is(scheduler.timeAxisSubGridElement.offsetHeight, 70 * tickHeight, 'Correct height');
              assertEventElement(t, 1, 0, 15 * tickHeight, 150, 5 * tickHeight);

            case 5:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x10) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('weekDateAndMonth', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      var tickHeight;
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              tickHeight = 40;
              _context11.next = 3;
              return createScheduler({
                viewPreset: 'weekDateAndMonth',
                startDate: new Date(2019, 5, 1),
                endDate: new Date(2019, 9, 30),
                // 23 ticks
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2019, 5, 16),
                  duration: 2,
                  durationUnit: 'w'
                }]
              });

            case 3:
              t.is(scheduler.timeAxisSubGridElement.offsetHeight, 23 * tickHeight, 'Correct height');
              assertEventElement(t, 1, 0, 3 * tickHeight, 150, 2 * tickHeight);

            case 5:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x11) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('weekDateAndMonth', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      var tickHeight;
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              tickHeight = 40;
              _context12.next = 3;
              return createScheduler({
                viewPreset: 'weekDateAndMonth',
                startDate: new Date(2019, 5, 1),
                endDate: new Date(2019, 9, 30),
                // 23 ticks
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2019, 5, 16),
                  duration: 2,
                  durationUnit: 'w'
                }]
              });

            case 3:
              t.is(scheduler.timeAxisSubGridElement.offsetHeight, 23 * tickHeight, 'Correct height');
              assertEventElement(t, 1, 0, 3 * tickHeight, 150, 2 * tickHeight);

            case 5:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x12) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('Should zoom on CTRL + mousewheel sanity checks', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      var originalZoomLevel, centerDate;
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'hourAndDay',
                startDate: new Date(2018, 1, 7, 7),
                endDate: new Date(2018, 1, 8),
                mode: 'vertical',
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2018, 1, 7, 12),
                  duration: 2,
                  durationUnit: 'h'
                }],
                height: 500
              });

            case 2:
              scheduler = _context13.sent;
              originalZoomLevel = scheduler.zoomLevel, centerDate = scheduler.viewportCenterDate;
              t.willFireNTimes(scheduler.timeAxisViewModel, 'update', 4);
              _context13.next = 7;
              return t.wheel('.b-timeline-subgrid', function () {
                t.expect(scheduler.zoomLevel).toBe(originalZoomLevel + 1);
                t.isApprox(scheduler.viewportCenterDate, centerDate, 15 * 1000, 'Center date within 15s exactness');
              }, t, {
                deltaY: -1000,
                ctrlKey: true
              });

            case 7:
              _context13.next = 9;
              return t.wheel('.b-timeline-subgrid', function () {
                t.expect(scheduler.zoomLevel).toBe(originalZoomLevel);
                t.isApprox(scheduler.viewportCenterDate, centerDate, 4 * 60 * 1000, 'Center date within 3 min exactness');
              }, t, {
                deltaY: 1000,
                ctrlKey: true
              });

            case 9:
              _context13.next = 11;
              return t.wheel('.b-timeline-subgrid', function () {
                t.expect(scheduler.zoomLevel).toBe(originalZoomLevel - 1);
                t.isApprox(scheduler.viewportCenterDate, centerDate, 4 * 60 * 1000, 'Center date within 4 min exactness');
              }, t, {
                deltaY: 1000,
                ctrlKey: true
              });

            case 11:
              _context13.next = 13;
              return t.wheel('.b-timeline-subgrid', function () {
                t.expect(scheduler.zoomLevel).toBe(originalZoomLevel - 2);
                t.isApprox(scheduler.viewportCenterDate, centerDate, 8 * 60 * 1000, 'Center date within 8 min exactness');
              }, t, {
                deltaY: 1000,
                ctrlKey: true
              });

            case 13:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x13) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('Should support zooming when double clicking time axis in vertical mode', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      var timeAxisColumn, visibleDateRange;
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _context14.next = 2;
              return createScheduler({
                viewPreset: 'weekDateAndMonth',
                startDate: new Date(2019, 5, 1),
                endDate: new Date(2019, 9, 30),
                // 23 ticks
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2019, 5, 16),
                  duration: 2,
                  durationUnit: 'w'
                }]
              });

            case 2:
              timeAxisColumn = scheduler.columns.first;
              t.firesOnce(scheduler.timeAxisViewModel, 'update');
              t.willFireNTimes(scheduler, 'timeAxisHeaderClick', 2);
              t.firesOnce(scheduler, 'timeAxisHeaderDblClick');
              t.firesOnce(scheduler, 'timeAxisHeaderContextMenu');
              t.willFireNTimes(timeAxisColumn, 'timeAxisHeaderClick', 2);
              t.firesOnce(timeAxisColumn, 'timeAxisHeaderDblClick');
              t.firesOnce(timeAxisColumn, 'timeAxisHeaderContextMenu');
              _context14.next = 12;
              return t.doubleClick('.b-sch-header-timeaxis-cell:contains(2019 July)');

            case 12:
              _context14.next = 14;
              return t.rightClick('.b-sch-header-timeaxis-cell:contains(Jul 2019)');

            case 14:
              visibleDateRange = scheduler.visibleDateRange;
              t.isApprox(visibleDateRange.startDate, new Date(2019, 6, 1), 3 * 3600 * 1000, 'Visible start date correct');
              t.isApprox(visibleDateRange.endDate, new Date(2019, 7, 1), 2 * 3600 * 1000, 'Visible end date correct');

            case 17:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x14) {
      return _ref14.apply(this, arguments);
    };
  }());
});