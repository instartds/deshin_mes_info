function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, fired;

  function setup() {
    return _setup.apply(this, arguments);
  }

  function _setup() {
    _setup = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
      var config,
          _args4 = arguments;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              config = _args4.length > 0 && _args4[0] !== undefined ? _args4[0] : {};
              scheduler && scheduler.destroy();
              scheduler = t.getScheduler(Object.assign({
                features: {
                  eventDrag: {
                    showTooltip: false
                  },
                  eventDragCreate: false
                }
              }, config));
              fired = {
                beforeeventdrag: 0,
                eventdragstart: 0,
                eventdrop: 0,
                aftereventdrop: 0
              };
              scheduler.on({
                beforeeventdrag: function beforeeventdrag(_ref4) {
                  var source = _ref4.source,
                      eventRecord = _ref4.eventRecord;

                  if (source instanceof Scheduler && eventRecord instanceof EventModel) {
                    fired.beforeeventdrag++;
                  }
                },
                eventdragstart: function eventdragstart(_ref5) {
                  var source = _ref5.source,
                      eventRecords = _ref5.eventRecords;

                  if (source instanceof Scheduler && eventRecords instanceof Array && eventRecords[0] instanceof EventModel) {
                    fired.eventdragstart++;
                  }
                },
                eventdrop: function eventdrop(_ref6) {
                  var source = _ref6.source,
                      eventRecords = _ref6.eventRecords,
                      isCopy = _ref6.isCopy;

                  if (source instanceof Scheduler && eventRecords instanceof Array && eventRecords[0] instanceof EventModel && // The 'isCopy' argument
                  isCopy === false) {
                    fired.eventdrop++;
                  }
                },
                aftereventdrop: function aftereventdrop(_ref7) {
                  var source = _ref7.source;

                  if (source instanceof Scheduler) {
                    fired.aftereventdrop++;
                  }
                }
              });
              _context4.next = 7;
              return t.waitForProjectReady(scheduler);

            case 7:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));
    return _setup.apply(this, arguments);
  }

  function getTestSteps(t) {
    var draggedRecord = scheduler.eventStore.first;
    return [{
      drag: '.event1',
      by: [50, 0]
    }, function (next) {
      for (var o in fired) {
        t.ok(fired[o] === 1, "'".concat(o, "' event fired"));
      }

      t.ok(draggedRecord.startDate > draggedRecord.meta.modified.startDate, 'StartDate changed');
      t.ok(draggedRecord.endDate > draggedRecord.meta.modified.endDate, 'EndDate changed');
      t.diag('Prevent drag using Draggable = false');
      draggedRecord.draggable = false;
      scheduler.eventStore.commit();

      for (var _o in fired) {
        fired[_o] = 0;
      }

      next();
    }, {
      drag: '.event1',
      by: [50, 0]
    }, function (next) {
      for (var o in fired) {
        t.ok(fired[o] === 0, "'".concat(o, "' event not fired"));
      }

      t.diag('Prevent drag using beforeeventdrag handler');
      draggedRecord.draggable = true;
      scheduler.eventStore.commit();
      scheduler.on('beforeeventdrag', function () {
        return false;
      });
      next();
    }, {
      drag: '.b-sch-event',
      by: [50, 0]
    }, function () {
      delete fired.beforeeventdrag; // Make sure no events were fired, e.g. operation didn't start

      for (var o in fired) {
        t.ok(fired[o] === 0, "'".concat(o, "' event not fired since false was returned by beforeeventdrag handler"));
      }

      t.is(scheduler.eventStore.changes, null, 'Task not dirty since task was not moved.');
    }];
  }

  t.it('Plain horizontal scheduler', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return setup();

            case 2:
              t.chain(getTestSteps(t));

            case 3:
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
  t.it('Clock in tooltip is updated on drag', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var assertClock, step;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              assertClock = function _assertClock(t, hour, minute, side) {
                var hourIndicator = document.querySelector(".b-sch-tip-valid .b-sch-tooltip-".concat(side, "date .b-sch-hour-indicator")),
                    minuteIndicator = document.querySelector(".b-sch-tip-valid .b-sch-tooltip-".concat(side, "date .b-sch-minute-indicator"));
                t.is(hourIndicator.style.transform, "rotate(".concat(hour * 30, "deg)"), 'Hour indicator is ok');
                t.is(minuteIndicator.style.transform, "rotate(".concat(minute * 6, "deg)"), 'Minute indicator is ok');
              };

              scheduler && scheduler.destroy();
              scheduler = t.getScheduler({
                viewPreset: 'hourAndDay',
                startDate: new Date(2018, 3, 27),
                endDate: new Date(2018, 3, 30),
                eventStore: t.getEventStore({
                  data: [{
                    startDate: '2018-04-27 02:00',
                    endDate: '2018-04-27 03:00',
                    id: 1,
                    resourceId: 'r2'
                  }, {
                    startDate: '2018-04-27 04:00',
                    endDate: '2018-04-27 04:00',
                    id: 2,
                    resourceId: 'r4'
                  }]
                })
              });
              step = scheduler.timeAxisViewModel.tickSize;
              t.chain({
                drag: '.b-sch-event',
                by: [[step * 2, 0]],
                dragOnly: true
              }, {
                waitForSelector: '.b-sch-tip-valid'
              }, function (next) {
                assertClock(t, 4, 0, 'start');
                assertClock(t, 5, 0, 'end');
                next();
              }, {
                moveMouseBy: [step / 2, 0]
              }, function (next) {
                assertClock(t, 4, 30, 'start');
                assertClock(t, 5, 30, 'end');
                next();
              }, {
                mouseUp: null
              }, {
                drag: '.b-milestone',
                by: [[step, 0]],
                dragOnly: true
              }, {
                waitForSelector: '.b-sch-tip-valid'
              }, function (next) {
                t.selectorNotExists('.b-sch-tip-valid .b-sch-tooltip-enddate', 'Milestone tip is ok');
                assertClock(t, 5, 0, 'start');
                next();
              }, {
                mouseUp: null
              });

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
  }()); // TODO: PORT tree later

  t.xit('Tree scheduler', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return setup({
                __tree: true
              });

            case 2:
              t.chain(getTestSteps(t));

            case 3:
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
});