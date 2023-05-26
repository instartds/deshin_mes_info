function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.it('Should be able to restore previously stored state', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var startDate, endDate, state;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              startDate = new Date(2011, 0, 3), endDate = new Date(2011, 0, 20);
              _context.next = 3;
              return t.getSchedulerAsync({
                rowHeight: 50,
                barMargin: 5,
                tickWidth: 100,
                enableEventAnimations: false,
                startDate: startDate,
                endDate: endDate
              });

            case 3:
              scheduler = _context.sent;
              state = scheduler.state;
              t.is(document.querySelector('.b-sch-event').offsetHeight, 40, 'Correct height initially');
              t.is(document.querySelector('.b-sch-header-row-1 .b-sch-header-timeaxis-cell').offsetWidth, 100, 'Correct width initially');
              scheduler.barMargin = 10;
              scheduler.tickSize = 70;
              t.is(document.querySelector('.b-sch-event').offsetHeight, 30, 'Correct height after changes');
              t.is(document.querySelector('.b-sch-header-row-1 .b-sch-header-timeaxis-cell').offsetWidth, 70, 'Correct width after change');
              scheduler.state = state;
              t.is(document.querySelector('.b-sch-event').offsetHeight, 40, 'Correct height after restoring state');
              t.is(document.querySelector('.b-sch-header-row-1 .b-sch-header-timeaxis-cell').offsetWidth, 100, 'Correct width after restore');
              t.is(scheduler.startDate, startDate, 'Start date is restored');
              t.is(scheduler.endDate, endDate, 'End date is restored');

            case 16:
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
  t.it('Should restore scheduler state if start/end was not provided in config', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var startDate, endDate;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                events: [],
                resources: []
              });
              _context2.next = 3;
              return t.waitForProjectReady();

            case 3:
              scheduler.endDate = DateHelper.add(new Date(), 10, 'd');
              scheduler.resourceStore.data = [{
                id: 1,
                name: 'Albert'
              }];
              scheduler.eventStore.data = [{
                id: 1,
                resourceId: 1,
                startDate: new Date(),
                endDate: DateHelper.add(new Date(), 2, 'd')
              }];
              _context2.next = 8;
              return t.waitForProjectReady();

            case 8:
              startDate = scheduler.startDate, endDate = scheduler.endDate; // eslint-disable-next-line no-self-assign

              scheduler.state = scheduler.state;
              t.is(scheduler.startDate, startDate, 'Start date is restored');
              t.is(scheduler.endDate, endDate, 'End date is restored');

            case 12:
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
  t.it('Should restore start/end dates', function (t) {
    scheduler = t.getScheduler({
      tickWidth: 40,
      viewPreset: 'weekAndDayLetter',
      startDate: null,
      endDate: null
    });
    var _scheduler = scheduler,
        startDate = _scheduler.startDate,
        endDate = _scheduler.endDate;
    delete scheduler.config.startDate;
    delete scheduler.config.endDate; // eslint-disable-next-line no-self-assign

    scheduler.state = scheduler.state;
    t.is(scheduler.startDate, startDate, 'Start date is restored');
    t.is(scheduler.endDate, endDate, 'End date is restored');
  });
  t.it('Should change view preset correctly after restoring state', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var newStart, newEnd, centerDate;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              newStart = new Date(2020, 6, 6), newEnd = DateHelper.add(new Date(), 6, 'M'), centerDate = new Date(newEnd - (newEnd - newStart) / 2);
              scheduler = t.getScheduler({
                viewPreset: 'hourAndDay',
                // monday
                startDate: newStart,
                width: 450
              }); // eslint-disable-next-line no-self-assign

              scheduler.state = scheduler.state;
              _context3.next = 5;
              return scheduler.timeAxisSubGrid.header.scrollable.await('scrollEnd', {
                checkLog: false
              });

            case 5:
              scheduler.viewPreset = {
                base: 'weekAndDay',
                options: {
                  startDate: newStart,
                  endDate: newEnd,
                  centerDate: centerDate
                }
              };
              t.is(scheduler.timeAxisSubGrid.header.scrollable.x, scheduler.timeAxisSubGrid.scrollable.x, 'Header and grid scrollables are synced');

            case 7:
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
  t.it('Should restore zoom level/tick size correctly', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var _scheduler2, state, tickSize, startDate, endDate, viewportCenterDate;

      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              scheduler = t.getScheduler(); // change tick size

              scheduler.tickSize *= 2;
              _scheduler2 = scheduler, state = _scheduler2.state, tickSize = _scheduler2.tickSize, startDate = _scheduler2.startDate, endDate = _scheduler2.endDate, viewportCenterDate = _scheduler2.viewportCenterDate;
              scheduler.tickSize += 50; // eslint-disable-next-line no-self-assign

              scheduler.state = state;
              t.is(scheduler.tickSize, tickSize, 'Tick size is ok');
              t.is(scheduler.startDate, startDate, 'Start is ok');
              t.is(scheduler.endDate, endDate, 'End is ok');
              t.is(scheduler.viewportCenterDate, viewportCenterDate, 'Center date is ok');

            case 9:
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
  t.it('Should be no errors on re-apply state', function (t) {
    scheduler = t.getScheduler();
    scheduler.applyState(JSON.parse(JSON.stringify(scheduler.getState())));
    t.pass('No error thrown');
  });
});