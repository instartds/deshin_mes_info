function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });
  t.it('Should be possible to dragcreate events', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventDragCreate: true,
        eventEdit: false,
        eventTooltip: false
      },
      onEventCreated: function onEventCreated(ev) {
        return ev.name = 'foo';
      }
    });
    var fired = {
      beforedragcreate: 0,
      dragcreatestart: 0,
      dragcreateend: 0,
      afterdragcreate: 0,
      beforeeventadd: 0
    };
    scheduler.on({
      beforedragcreate: function beforedragcreate(_ref) {
        var source = _ref.source,
            resourceRecord = _ref.resourceRecord,
            date = _ref.date,
            event = _ref.event;
        t.ok(source instanceof Scheduler && resourceRecord instanceof ResourceModel && date instanceof Date && event instanceof Event, 'Correct event signature of `beforedragcreate`');
        fired.beforedragcreate++;
      },
      dragcreatestart: function dragcreatestart(_ref2) {
        var source = _ref2.source,
            proxyElement = _ref2.proxyElement;
        t.ok(source instanceof Scheduler && proxyElement.classList.contains('b-sch-dirty-new'), 'Correct event signature of `dragcreatestart`');
        fired.dragcreatestart++;
      },
      dragcreateend: function dragcreateend(_ref3) {
        var source = _ref3.source,
            eventRecord = _ref3.eventRecord,
            resourceRecord = _ref3.resourceRecord,
            event = _ref3.event,
            proxyElement = _ref3.proxyElement;
        t.ok(source instanceof Scheduler && eventRecord instanceof EventModel && resourceRecord instanceof ResourceModel && event instanceof Event && proxyElement.classList.contains('b-sch-dirty-new'), 'Correct event signature of `dragcreateend`');
        fired.dragcreateend++;
      },
      afterdragcreate: function afterdragcreate(_ref4) {
        var source = _ref4.source,
            proxyElement = _ref4.proxyElement;
        t.ok(source instanceof Scheduler && proxyElement.classList.contains('b-sch-dirty-new'), 'Correct event signature of `afterdragcreate`');
        fired.afterdragcreate++;
      },
      beforeeventadd: function beforeeventadd(_ref5) {
        var source = _ref5.source,
            eventRecord = _ref5.eventRecord,
            resourceRecords = _ref5.resourceRecords;
        t.ok(source instanceof Scheduler && eventRecord instanceof EventModel && resourceRecords instanceof Array, 'Correct event signature of `beforeeventadd`');
        fired.beforeeventadd++;
      }
    });

    var eventStore = scheduler.eventStore,
        falseFn = function falseFn() {
      return false;
    };

    eventStore.removeAll();
    t.chain({
      drag: '.b-sch-timeaxis-cell',
      by: [100, 0]
    }, function (next) {
      for (var o in fired) {
        t.ok(fired[o] === 1, "'".concat(o, "' event fired"));
      }

      t.ok(eventStore.count === 1, 'New event added to store');
      t.ok(eventStore.first.startDate instanceof Date, 'StartDate is a valid Date');
      t.ok(eventStore.first.endDate instanceof Date, 'EndDate is a valid Date');
      t.isLess(eventStore.first.startDate, eventStore.first.endDate, 'EndDate is greater than start date');
      t.is(eventStore.first.name, 'foo', 'onEventCreated successfully modified the new record');
      t.selectorExists('.b-sch-event-wrap .b-sch-event .b-sch-event-content', 'Correct DOM structure for new event');
      scheduler.on('beforedragcreate', falseFn);

      for (var p in fired) {
        fired[p] = 0;
      }

      next();
    }, // TODO: should be -100 but EventDragCreate doesn't support that yet
    {
      drag: '[data-index=1] .b-sch-timeaxis-cell',
      by: [100, 0]
    }, function (next) {
      // Make sure no events were fired, e.g. operation didn't start
      t.isDeeply(fired, {
        beforedragcreate: 1,
        dragcreatestart: 0,
        dragcreateend: 0,
        afterdragcreate: 0,
        beforeeventadd: 0
      }, 'Only `beforedragcreate` was fired which did not result in any event created');
      t.is(eventStore.count, 1, 'No new event added to store');
      scheduler.un('beforedragcreate', falseFn); // Try again and make sure that firing 'beforeeventadd' event behaves as expected

      scheduler.on('beforeeventadd', falseFn);
      next();
    }, {
      drag: '[data-index=1] .b-sch-timeaxis-cell',
      by: [-100, 0]
    });
  });
  t.it('Clock in tooltip is updated on create', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var step, assertClock;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              assertClock = function _assertClock(t, hour, minute, side) {
                var hourIndicator = t.query(".b-sch-tip-valid .b-sch-tooltip-".concat(side, "date .b-sch-hour-indicator"))[0],
                    minuteIndicator = t.query(".b-sch-tip-valid .b-sch-tooltip-".concat(side, "date .b-sch-minute-indicator"))[0];
                t.is(hourIndicator.style.transform, "rotate(".concat(hour * 30, "deg)"), 'Hour indicator is ok');
                t.is(minuteIndicator.style.transform, "rotate(".concat(minute * 6, "deg)"), 'Minute indicator is ok');
              };

              scheduler = t.getScheduler({
                eventStore: t.getEventStore(null, 0),
                startDate: new Date(2018, 3, 27),
                endDate: new Date(2018, 3, 28),
                viewPreset: 'hourAndDay'
              });
              _context.next = 4;
              return t.waitForProjectReady(scheduler);

            case 4:
              step = scheduler.timeAxisViewModel.tickSize;
              t.chain({
                waitForSelector: '.b-sch-header-timeaxis-cell'
              }, {
                drag: '.b-sch-timeaxis-cell',
                fromOffset: [step, 10],
                by: [step, 0],
                dragOnly: true
              }, {
                waitForSelector: '.b-sch-tip-valid'
              }, function (next) {
                assertClock(t, 1, 0, 'start');
                assertClock(t, 2, 0, 'end');
                next();
              }, {
                moveMouseBy: [40, 0]
              }, function (next) {
                assertClock(t, 1, 0, 'start');
                assertClock(t, 2, 30, 'end');
                next();
              }, {
                moveMouseBy: [step - 40, 0]
              }, function (next) {
                assertClock(t, 1, 0, 'start');
                assertClock(t, 3, 0, 'end');
                next();
              }, {
                mouseUp: null
              });

            case 6:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref6.apply(this, arguments);
    };
  }());
});