function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler; // async beforeEach doesn't work in umd

  t.beforeEach( /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t, next) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler && scheduler.destroy();
              _context.next = 3;
              return t.getVerticalSchedulerAsync({
                resources: ArrayHelper.populate(1000, function (i) {
                  return {
                    id: 'r' + (i + 1),
                    name: 'Resource ' + (i + 1)
                  };
                }),
                endDate: new Date(2019, 12, 1)
              });

            case 3:
              scheduler = _context.sent;
              next();

            case 5:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x, _x2) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Date mapping', function (t) {
    var topDate = new Date(2019, 4, 26);
    scheduler.timeAxis.forEach(function (tick, i) {
      t.is(scheduler.getDateFromCoordinate(i * 50), DateHelper.add(topDate, i, 'days'));
    });
  });
  t.it('getElementsFromEventRecord for a record that\'s not in the store should not crash', function (t) {
    var newEvent = new scheduler.eventStore.modelClass({
      startDate: new Date(),
      duration: 1,
      durationUnit: 'd',
      name: ''
    });
    t.isDeeply(scheduler.getElementsFromEventRecord(newEvent), []);
  });
  t.it('Resource mapping', function (t) {
    function assertEventResource(eventId) {
      t.is(scheduler.resolveResourceRecord(document.querySelector("[data-event-id=\"".concat(eventId, "\"]"))).id, scheduler.eventStore.getById(eventId).resourceId, 'Correct for event ' + eventId);
    }

    assertEventResource(1);
    assertEventResource(2);
    assertEventResource(3);
    assertEventResource(4);
    assertEventResource(5);

    function assertResource(x, index) {
      t.is(scheduler.resolveResourceRecord(document.querySelector('.b-sch-timeaxis-cell'), [x, 0]), scheduler.resourceStore.getAt(index), 'Correct for x ' + x);
    }

    assertResource(0, 0);
    assertResource(150, 1);
    assertResource(999 * 150, 999);
  });
  t.it('should support visibleDateRange in vertical mode', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var halfHourMs;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler && scheduler.destroy();
              _context2.next = 3;
              return t.getSchedulerAsync({
                mode: 'vertical',
                startDate: new Date(2010, 1, 1),
                endDate: new Date(2010, 5, 1),
                width: 300
              });

            case 3:
              scheduler = _context2.sent;
              _context2.next = 6;
              return t.waitForRowsVisible(scheduler);

            case 6:
              scheduler.height = scheduler.headerHeight + 3 * scheduler.tickSize + DomHelper.scrollBarWidth;
              halfHourMs = 1000 * 60 * 30;
              t.chain({
                waitFor: function waitFor() {
                  return scheduler.timeAxisSubGrid.height > 0;
                }
              }, function () {
                t.is(scheduler.visibleDateRange.startDate, new Date(2010, 1, 1), 'Correct visible start date');
                t.isApprox(scheduler.visibleDateRange.endDate, new Date(2010, 1, 4), halfHourMs, 'Correct visible end date');
              });

            case 9:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('should support getStartEndDatesFromRectangle in vertical mode', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              scheduler.viewPreset = 'hourAndDay';
              scheduler.setTimeSpan(new Date(2011, 1, 1), new Date(2011, 1, 2));
              scheduler.resources = [{
                id: 'r1',
                name: 'foo'
              }];
              scheduler.events = [{
                id: 1,
                resourceId: 'r1',
                startDate: new Date(2011, 1, 1, 10),
                endDate: new Date(2011, 1, 1, 11)
              }];
              t.chain({
                waitForProjectReady: scheduler
              }, {
                waitForElementVisible: scheduler.unreleasedEventSelector
              }, {
                waitFor: function waitFor() {
                  return scheduler.timeAxisSubGrid.height > 0;
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                var rect, dates;
                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        rect = Rectangle.from(document.querySelector('.b-sch-event:not(.b-released)'), scheduler.foregroundCanvas), dates = scheduler.getStartEndDatesFromRectangle(rect);
                        t.is(dates.start, new Date(2011, 1, 1, 10), 'Correct start date');
                        t.is(dates.end, new Date(2011, 1, 1, 11), 'Correct end date');

                      case 3:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3);
              })));

            case 5:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref3.apply(this, arguments);
    };
  }());
});