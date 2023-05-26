function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(config) {
      var scheduler;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync(Object.assign({
                enableEventAnimations: false,
                features: {
                  eventDrag: true
                }
              }, config));

            case 2:
              scheduler = _context4.sent;
              return _context4.abrupt("return", scheduler);

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('Should work with custom non-continuous timeaxis', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler({
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 10),
                  endDate: new Date(2011, 0, 11)
                }, {
                  id: 2,
                  resourceId: 'r2',
                  startDate: new Date(2011, 0, 5),
                  endDate: new Date(2011, 0, 7)
                }],
                timeAxis: {
                  continuous: false,
                  generateTicks: function generateTicks(start, end, unit, increment) {
                    var ticks = [];

                    while (start < end) {
                      if ([1, 2, 3].includes(start.getDay())) {
                        ticks.push({
                          startDate: start,
                          endDate: DateHelper.add(start, increment, unit)
                        });
                      }

                      start = DateHelper.add(start, increment, unit);
                    }

                    return ticks;
                  }
                }
              });

            case 2:
              scheduler = _context.sent;
              t.isApprox(t.rect('[data-event-id="2"]').width, scheduler.tickSize, 0.5, 'Only displaying part of event initially');
              t.chain( // Drag bottom event to reveal more of it
              {
                drag: '[data-event-id="2"]',
                by: [-scheduler.tickSize, 0]
              }, function (next) {
                t.isApprox(t.rect('[data-event-id="2"]').width, scheduler.tickSize * 2, 0.5, 'More revealed after drop');
                t.is(scheduler.eventStore.last.startDate, new Date(2011, 0, 4), 'startDate correct');
                t.is(scheduler.eventStore.last.endDate, new Date(2011, 0, 6), 'endDate correct');
                next();
              }, // Entire event is now visible, drag it some more to make sure it stays so
              {
                drag: '[data-event-id="2"]',
                by: [-scheduler.tickSize, 0]
              }, function (next) {
                t.isApprox(t.rect('[data-event-id="2"]').width, scheduler.tickSize * 2, 0.5, 'Same width after drop');
                t.is(scheduler.eventStore.last.startDate, new Date(2011, 0, 3), 'startDate correct');
                t.is(scheduler.eventStore.last.endDate, new Date(2011, 0, 5), 'endDate correct');
                next();
              }, // Should clip when moved to overlap "hidden" ticks
              {
                drag: '[data-event-id="1"]',
                by: [-scheduler.tickSize / 2, 0]
              }, function () {
                t.isApprox(document.querySelector('[data-event-id="1"]').offsetWidth, Math.floor(scheduler.tickSize / 2), 'Clipped after drop');
                t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 5, 12), 'startDate correct');
                t.is(scheduler.eventStore.first.endDate, new Date(2011, 0, 6, 12), 'endDate correct');
              });

            case 5:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x2) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Should not disappear when dropped at edge between non-continuous ticks', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getScheduler({
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2019, 0, 16, 16),
                  endDate: new Date(2019, 0, 16, 18)
                }],
                viewPreset: 'hourAndDay',
                startDate: new Date(2019, 0, 15),
                endDate: new Date(2019, 0, 17),
                timeAxis: {
                  continuous: false,
                  generateTicks: function generateTicks(start, end, unit, increment) {
                    var ticks = [];

                    while (start < end) {
                      if (start.getHours() > 15 && start.getHours() < 22) {
                        ticks.push({
                          startDate: start,
                          endDate: DateHelper.add(start, increment, unit)
                        });
                      }

                      start = DateHelper.add(start, increment, unit);
                    }

                    return ticks;
                  }
                }
              });

            case 2:
              scheduler = _context2.sent;
              t.chain({
                drag: '.b-sch-event',
                by: [-5, 0]
              }, function () {
                t.selectorExists('.b-sch-event:not(.b-sch-released)', 'Events element still there');
              });

            case 4:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref2.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/779

  t.it('Should be no exceptions when dragging an event starting & ending outside timeaxis', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var startDate, endDate;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              startDate = new Date(2011, 0, 2), endDate = new Date(2011, 0, 12);
              _context3.next = 3;
              return getScheduler({
                resources: [{
                  id: 'r1',
                  name: 'Foo'
                }],
                workingTime: {
                  fromHour: 8,
                  toHour: 17
                },
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'foo',
                  startDate: startDate,
                  endDate: endDate
                }],
                startDate: new Date(2011, 0, 2),
                endDate: new Date(2011, 0, 7),
                tickSize: 100
              });

            case 3:
              scheduler = _context3.sent;
              t.chain({
                drag: '.b-sch-event',
                by: [-100, 0]
              }, function () {
                t.pass('No crash');
              });

            case 5:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x4) {
      return _ref3.apply(this, arguments);
    };
  }());
});