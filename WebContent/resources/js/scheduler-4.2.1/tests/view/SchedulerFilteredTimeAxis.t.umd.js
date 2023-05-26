function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var q = function q(query) {
    return document.querySelector(query);
  };

  var scheduler, timeAxis;
  t.beforeEach(function (t) {
    return scheduler && scheduler.destroy();
  }); // Ported from 2112_filtered_time_axis

  t.it('Basic timeAxis filtering should work', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                startDate: new Date(2012, 5, 2),
                endDate: new Date(2012, 5, 11)
              });

            case 2:
              scheduler = _context.sent;
              timeAxis = scheduler.timeAxis;
              scheduler.eventStore.add({
                resourceId: scheduler.resourceStore.first.id,
                startDate: new Date(2012, 5, 5),
                endDate: new Date(2012, 5, 6),
                cls: 'b-sch-foo'
              });
              _context.next = 7;
              return t.waitForProjectReady();

            case 7:
              t.selectorExists(scheduler.eventSelector + ':not(.b-sch-released) .b-sch-foo', 'Should find event in normal state');
              timeAxis.filterBy(function (tick) {
                return tick.startDate.getDay() === 6 || tick.startDate.getDay() === 0;
              });
              t.selectorNotExists(scheduler.eventSelector + ':not(.b-sch-released) .b-sch-foo', 'Should not find event in filtered state');
              timeAxis.clearFilters();
              t.selectorExists(scheduler.eventSelector + ':not(.b-sch-released) .b-sch-foo', 'Should find event after clearing filter');

            case 12:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }()); // Ported from 2116_filtered_timeaxis_getdate

  t.it('View should return correct date for coordinate in filtered timeaxis', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var tickSize, correctDate;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              document.body.style.width = '1000px';
              scheduler = new Scheduler({
                appendTo: document.body,
                border: true,
                startDate: new Date(2011, 1, 14),
                endDate: new Date(2011, 1, 29),
                viewPreset: 'weekAndDayLetter',
                margin: '10 0 0 0',
                forceFit: true,
                columns: [],
                resources: [],
                events: []
              });
              scheduler.timeAxis.filterBy(function (tick) {
                return tick.startDate.getDay() !== 6 && tick.startDate.getDay() !== 0;
              });
              tickSize = scheduler.timeAxisViewModel.tickSize, correctDate = new Date(2011, 2, 4); // now scheduler has splitter, append 4px to compensate it's width

              t.isDateEqual(scheduler.getDateFromCoordinate(tickSize * 14.1 + 4, 'floor'), correctDate, 'Date in last tick is correct');
              t.isDateEqual(scheduler.getDateFromCoordinate(tickSize * 14.4, 'floor'), correctDate, 'Date in last tick is correct');
              t.isDateEqual(scheduler.getDateFromCoordinate(tickSize * 14.8, 'floor'), correctDate, 'Date in last tick is correct');

            case 7:
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
  t.it('Should resize headers and events when filtering out ticks', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var initialTickSize, _scheduler, tickSize, _scheduler2, _scheduler3;

      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 10),
                enableEventAnimations: false
              });

            case 2:
              scheduler = _context3.sent;
              timeAxis = scheduler.timeAxis;
              initialTickSize = scheduler.tickSize;
              t.diag('Filtering out weekends');
              timeAxis.filterBy(function (tick) {
                return tick.startDate.getDay() !== 0 && tick.startDate.getDay() !== 6;
              });
              _scheduler = scheduler, tickSize = _scheduler.tickSize;
              t.isApprox(tickSize, 184, 'Tick width updated');
              t.is(q('.b-sch-header-row-1 .b-sch-header-timeaxis-cell').offsetWidth, tickSize, 'Header cells resized');
              t.is(q(scheduler.eventSelector).offsetWidth, tickSize * 2, 'Event element resized');
              t.selectorCountIs('.b-sch-header-row-0 .b-sch-header-timeaxis-cell', 1, 'Single top header cell');
              t.is(q('.b-sch-header-row-0 .b-sch-header-timeaxis-cell').offsetWidth, tickSize * 5, 'Top header cell size correct');
              t.diag('Filtering out mondays');
              timeAxis.filterBy(function (tick) {
                return tick.startDate.getDay() !== 1;
              });
              _scheduler2 = scheduler;
              tickSize = _scheduler2.tickSize;
              t.isApprox(tickSize, 153, 'Tick width updated');
              t.isApprox(q('.b-sch-header-row-1 .b-sch-header-timeaxis-cell').getBoundingClientRect().width, tickSize, 0.4, 'Header cells resized');
              t.isApprox(q(scheduler.eventSelector).getBoundingClientRect().width, tickSize * 2, 0.4, 'Event element resized');
              t.selectorCountIs('.b-sch-header-row-0 .b-sch-header-timeaxis-cell', 2, 'Two top header cells');
              t.isApprox(q('.b-sch-header-row-0 .b-sch-header-timeaxis-cell').getBoundingClientRect().width, tickSize * 5, 0.4, 'First top header cell size correct');
              t.isApprox(q('.b-sch-header-row-0 .b-sch-header-timeaxis-cell:last-child').getBoundingClientRect().width, tickSize, 0.4, 'Last top header cell size correct');
              t.diag('Clearing filters');
              timeAxis.clearFilters();
              _scheduler3 = scheduler;
              tickSize = _scheduler3.tickSize;
              t.isApprox(tickSize, initialTickSize, 'Tick width restored');
              t.isApprox(q('.b-sch-header-row-1 .b-sch-header-timeaxis-cell').getBoundingClientRect().width, tickSize, 0.4, 'Header cells resized');
              t.isApprox(q(scheduler.eventSelector).getBoundingClientRect().width, tickSize * 2, 0.4, 'Event element resized');
              t.isApprox(q('.b-sch-header-row-0 .b-sch-header-timeaxis-cell').getBoundingClientRect().width, tickSize * 6, 0.4, 'First top header cell size correct');
              t.isApprox(q('.b-sch-header-row-0 .b-sch-header-timeaxis-cell:last-child').getBoundingClientRect().width, tickSize, 0.4, 'Last top header cell size correct');

            case 32:
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
  t.it('Should resize when filtering out ticks, scenario 2', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var initialTickSize, tickSize;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 10)
              });

            case 2:
              scheduler = _context4.sent;
              timeAxis = scheduler.timeAxis;
              initialTickSize = scheduler.tickSize;
              timeAxis.filterBy(function (tick) {
                return tick.startDate.getDay() !== 0 && tick.startDate.getDay() !== 6;
              });
              timeAxis.clearFilters();
              tickSize = scheduler.tickSize;
              t.isApprox(tickSize, initialTickSize, 'Tick width restored');
              t.isApprox(q('.b-sch-header-row-1 .b-sch-header-timeaxis-cell').getBoundingClientRect().width, tickSize, 0.4, 'Header cells resized');
              t.isApprox(q(scheduler.eventSelector).getBoundingClientRect().width, tickSize * 2, 0.4, 'Event element resized');
              t.isApprox(q('.b-sch-header-row-0 .b-sch-header-timeaxis-cell').getBoundingClientRect().width, tickSize * 6, 0.4, 'First top header cell size correct');
              t.isApprox(q('.b-sch-header-row-0 .b-sch-header-timeaxis-cell:last-child').getBoundingClientRect().width, tickSize, 0.4, 'Last top header cell size correct');

            case 13:
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
  t.it('Should render header levels with same unit correctly with filter', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return t.getSchedulerAsync({
                viewPreset: {
                  timeResolution: {
                    unit: 'HOUR',
                    increment: 6
                  },
                  headers: [{
                    unit: 'DAY',
                    dateFormat: 'DD'
                  }, {
                    unit: 'DAY',
                    renderer: function renderer(start) {
                      return DateHelper.format(start, 'dd').substr(0, 1);
                    }
                  }]
                },
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 10)
              });

            case 2:
              scheduler = _context5.sent;
              timeAxis = scheduler.timeAxis;
              timeAxis.filterBy(function (tick) {
                return tick.startDate.getDay() < 2;
              });
              t.selectorCountIs('.b-sch-header-row-0 .b-sch-header-timeaxis-cell', 2, 'Correct cell count for middle');
              t.selectorCountIs('.b-sch-header-row-1 .b-sch-header-timeaxis-cell', 2, 'Correct cell count for bottom');

            case 7:
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
  t.it('Should revert filter if no ticks remain', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var tickCount;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getSchedulerAsync();

            case 2:
              scheduler = _context6.sent;
              timeAxis = scheduler.timeAxis;
              tickCount = timeAxis.count;
              t.firesOnce(timeAxis, 'invalidFilter');
              timeAxis.filterBy(function () {
                return false;
              });
              t.is(timeAxis.count, tickCount, 'All ticks available');
              t.notOk(timeAxis.isFiltered, 'No filter applied');

            case 9:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref6.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7810/details

  t.it('shiftPrevious() should not crash with filtered out days', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 4)
              });

            case 2:
              scheduler = _context7.sent;
              timeAxis = scheduler.timeAxis;
              timeAxis.filterBy(function (tick) {
                return tick.startDate.getDay() !== 6 && tick.startDate.getDay() !== 0;
              });
              timeAxis.shiftPrevious();
              t.selectorExists('.b-sch-header-timeaxis-cell:contains(31)', 'Header updated');

            case 7:
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
});