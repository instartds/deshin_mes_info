function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  var defaultWeekends = LocaleManager.locale.DateHelper.nonWorkingDays;
  t.beforeEach(function (t) {
    var _scheduler, _scheduler$destroy;

    (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : (_scheduler$destroy = _scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(_scheduler);
  });

  var createScheduler = function createScheduler() {
    var weekends = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : defaultWeekends;
    // reset weekends
    LocaleManager.locale.DateHelper.nonWorkingDays = weekends;
    scheduler = t.getScheduler({
      startDate: new Date(2018, 1, 1),
      endDate: new Date(2018, 1, 15),
      viewPreset: 'weekAndDayLetter',
      height: 300,
      features: {
        nonWorkingTime: true
      }
    });
  };

  t.it('Rendering sanity checks', function (t) {
    createScheduler();
    t.chain({
      waitForSelector: '.b-grid-headers .b-sch-nonworkingtime',
      desc: 'Should find range element in header'
    }, function () {
      t.isApproxPx(document.querySelector('.b-grid-headers .b-sch-nonworkingtime').offsetHeight, document.querySelector('.b-grid-headers').offsetHeight / 2, 'non working time elements has half height of 2-level header');
    });
  });
  t.it('Should support disabling', function (t) {
    createScheduler();
    scheduler.features.nonWorkingTime.disabled = true;
    t.selectorNotExists('.b-sch-timerange', 'No timeranges');
    scheduler.features.nonWorkingTime.disabled = false;
    t.selectorExists('.b-sch-timerange', 'Timeranges found');
  }); // https://github.com/bryntum/support/issues/2309

  t.it('Weekends should be configurable. Weekends are Sat - Sun', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var firstDay, secondDay, interval, firstDayRect, secondDayRect, intervalRect;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              createScheduler();
              _context.next = 3;
              return t.waitForSelector('.b-sch-nonworkingtime');

            case 3:
              firstDay = t.query('.b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index="6"]')[0], secondDay = t.query('.b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index="7"]')[0], interval = t.query('.b-sch-nonworkingtime[data-id=nonworking-2]')[0], firstDayRect = firstDay.getBoundingClientRect(), secondDayRect = secondDay.getBoundingClientRect(), intervalRect = interval.getBoundingClientRect();
              t.isApproxPx(firstDayRect.left, intervalRect.left - 1, 'Non working time starts at Sat');
              t.isApproxPx(secondDayRect.right, intervalRect.right - 1, 'Non working time end at Sun');

            case 6:
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
  t.it('Weekends should be configurable. Weekends are Fri - Sat', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var firstDay, secondDay, interval, firstDayRect, secondDayRect, intervalRect;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              createScheduler({
                5: true,
                6: true
              });
              _context2.next = 3;
              return t.waitForSelector('.b-sch-nonworkingtime');

            case 3:
              firstDay = t.query('.b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index="5"]')[0], secondDay = t.query('.b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index="6"]')[0], interval = t.query('.b-sch-nonworkingtime[data-id=nonworking-1]')[0], firstDayRect = firstDay.getBoundingClientRect(), secondDayRect = secondDay.getBoundingClientRect(), intervalRect = interval.getBoundingClientRect();
              t.isApproxPx(firstDayRect.left, intervalRect.left - 1, 'Non working time starts at Fri');
              t.isApproxPx(secondDayRect.right, intervalRect.right - 1, 'Non working time end at Sat');

            case 6:
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
  t.it('Weekends should be configurable. Weekends are Sun - Mon', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var firstDay, secondDay, interval, firstDayRect, secondDayRect, intervalRect;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              createScheduler({
                0: true,
                1: true
              });
              _context3.next = 3;
              return t.waitForSelector('.b-sch-nonworkingtime');

            case 3:
              firstDay = t.query('.b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index="0"]')[0], secondDay = t.query('.b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index="1"]')[0], interval = t.query('.b-sch-nonworkingtime[data-id=nonworking-1]')[0], firstDayRect = firstDay.getBoundingClientRect(), secondDayRect = secondDay.getBoundingClientRect(), intervalRect = interval.getBoundingClientRect();
              t.isApproxPx(firstDayRect.left, intervalRect.left - 1, 'Non working time starts at Sun');
              t.isApproxPx(secondDayRect.right, intervalRect.right - 1, 'Non working time end at Mon');

            case 6:
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
  t.it('Should be possible to update weekends dynamically', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var firstDay, secondDay, interval, firstDayRect, secondDayRect, intervalRect;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              createScheduler();
              _context4.next = 3;
              return t.waitForSelector('.b-sch-nonworkingtime');

            case 3:
              firstDay = t.query('.b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index="6"]')[0], secondDay = t.query('.b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index="7"]')[0], interval = t.query('.b-sch-nonworkingtime[data-id=nonworking-2]')[0], firstDayRect = firstDay.getBoundingClientRect(), secondDayRect = secondDay.getBoundingClientRect(), intervalRect = interval.getBoundingClientRect();
              t.isApproxPx(firstDayRect.left, intervalRect.left - 1, 'Non working time starts at Sat');
              t.isApproxPx(secondDayRect.right, intervalRect.right - 1, 'Non working time end at Sun');
              LocaleManager.locale.DateHelper.nonWorkingDays = {};
              LocaleManager.applyLocale(LocaleManager.locale.localeName, true);
              _context4.next = 10;
              return t.waitForSelectorNotFound('.b-sch-nonworkingtime');

            case 10:
              LocaleManager.locale.DateHelper.nonWorkingDays = {
                0: true,
                1: true
              };
              LocaleManager.applyLocale(LocaleManager.locale.localeName, true);
              _context4.next = 14;
              return t.waitForSelector('.b-sch-nonworkingtime');

            case 14:
              firstDay = t.query('.b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index="0"]')[0]; // Sunday header

              secondDay = t.query('.b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index="1"]')[0]; // Monday header

              interval = t.query('.b-sch-nonworkingtime[data-id=nonworking-1]')[0]; // First interval

              firstDayRect = firstDay.getBoundingClientRect();
              secondDayRect = secondDay.getBoundingClientRect();
              intervalRect = interval.getBoundingClientRect();
              t.isApproxPx(firstDayRect.left, intervalRect.left - 1, 'Non working time starts at Sun');
              t.isApproxPx(secondDayRect.right, intervalRect.right - 1, 'Non working time end at Mon');

            case 22:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2771

  t.it('Should work in non-english locale', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              scheduler = t.getScheduler({
                startDate: new Date(2018, 1, 1),
                endDate: new Date(2018, 1, 15),
                viewPreset: 'weekAndDayLetter',
                height: 300,
                features: {
                  nonWorkingTime: true
                }
              });
              _context5.next = 3;
              return t.waitForSelector('.b-sch-header-timeaxis-cell[data-tick-index="1"]:contains(M)');

            case 3:
              _context5.next = 5;
              return t.waitForSelector('.b-sch-nonworkingtime');

            case 5:
              t.diag('Applying locale Ru');
              LocaleManager.locale = window.bryntum.locales.Ru; // Non-working time generates new calendar intervals, so need to wait when propagation is finished

              _context5.next = 9;
              return scheduler.project.commitAsync();

            case 9:
              _context5.next = 11;
              return t.waitForSelector(".b-sch-header-timeaxis-cell[data-tick-index=\"1\"]:contains(".concat(BrowserHelper.isSafari ? 'П' : 'п', ")"));

            case 11:
              _context5.next = 13;
              return t.waitForSelector('.b-sch-nonworkingtime');

            case 13:
              t.diag('Applying locale En');
              LocaleManager.locale = window.bryntum.locales.En; // Non-working time generates new calendar intervals, so need to wait when propagation is finished

              _context5.next = 17;
              return scheduler.project.commitAsync();

            case 17:
              _context5.next = 19;
              return t.waitForSelector('.b-sch-header-timeaxis-cell[data-tick-index="1"]:contains(M)');

            case 19:
              _context5.next = 21;
              return t.waitForSelector('.b-sch-nonworkingtime');

            case 21:
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
});