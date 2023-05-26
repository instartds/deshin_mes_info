function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler1, scheduler2;
  t.beforeEach(function () {
    return Base.destroy(scheduler1, scheduler2);
  });

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(config) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              return _context5.abrupt("return", t.getSchedulerAsync(Object.assign({
                height: 200,
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25),
                enableRecurringEvents: true
              }, config)));

            case 1:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('Supports occurrences detaching', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var resourceStore, eventStore, event3, occurrence2, exceptionDate;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              resourceStore = new ResourceStore({
                data: [{
                  id: 'r1'
                }]
              });
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Foo',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  name: 'Bar',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1'
                }, {
                  id: 3,
                  resourceId: 'r1',
                  name: 'Baz',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=2'
                }]
              });
              event3 = eventStore.getById(3);
              t.isCalledNTimes('add', eventStore, 1, 'One exception is added');
              _context.next = 6;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 6:
              scheduler1 = _context.sent;
              _context.next = 9;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 9:
              scheduler2 = _context.sent;
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.is(event3.occurrences.length, 5, 'event3 has proper number of occurrences');
              occurrence2 = event3.occurrences[2];
              t.diag('initial occurrence dates');
              t.is(occurrence2.startDate, new Date(2018, 5, 20), 'occurrence #2 start is correct');
              t.is(occurrence2.endDate, new Date(2018, 5, 21), 'occurrence #2 end is correct');
              t.diag('detach the occurrence2 and change its start & end dates');
              exceptionDate = occurrence2.startDate;
              occurrence2.beginBatch();
              occurrence2.setStartEndDate(new Date(2018, 5, 21), new Date(2018, 5, 22));
              occurrence2.recurrence = null;
              occurrence2.endBatch();
              t.ok(event3.hasException(exceptionDate), 'Exception date automatically added');
              t.notOk(occurrence2.isModified, 'Changes to occurrences do not mark them as modified');
              t.diag('update master event name to trigger occurrences regenerating');
              event3.name = 'zaB';
              _context.next = 28;
              return t.waitForProjectReady();

            case 28:
              t.is(eventStore.count, 4, 'Exception has been added');
              t.is(event3.occurrences.length, 4, 'event 3 has proper number of occurrences');
              t.is(event3.occurrences[0].name, 'zaB', 'event 3 occurrence got new name');
              t.is(occurrence2.name, 'Baz', 'occurrence #2 name is correct');
              t.is(occurrence2.startDate, new Date(2018, 5, 21), 'occurrence #2 start is correct');
              t.is(occurrence2.endDate, new Date(2018, 5, 22), 'occurrence #2 end is correct');
              scheduler1.destroy();
              scheduler2.destroy();

            case 36:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x2) {
      return _ref.apply(this, arguments);
    };
  }()); // TODO: 2 more cases - limited by "Count" & limited by "Until"

  t.it('Supports recurrence splitting', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var resourceStore, eventStore, event3, occurrence2, recurringEvent, newStartDate, newEndDate;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              resourceStore = new ResourceStore({
                data: [{
                  id: 'r1'
                }]
              });
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Foo',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  name: 'Bar',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1'
                }, {
                  id: 3,
                  resourceId: 'r1',
                  name: 'Baz',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=2'
                }]
              });
              event3 = eventStore.getById(3);
              t.isCalledNTimes('add', eventStore, 1);
              _context2.next = 6;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 6:
              scheduler1 = _context2.sent;
              _context2.next = 9;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 9:
              scheduler2 = _context2.sent;
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.is(event3.occurrences.length, 5, 'event 3 has 4 occurrences');
              occurrence2 = event3.occurrences[2];
              t.diag('initial occurrence dates');
              t.is(occurrence2.startDate, new Date(2018, 5, 20), 'occurrence #2 start is correct');
              t.is(occurrence2.endDate, new Date(2018, 5, 21), 'occurrence #2 end is correct');
              t.diag('detach the occurrence2 and change its start & end dates');
              recurringEvent = occurrence2.recurringEvent;
              occurrence2.beginBatch();
              newStartDate = new Date(2018, 5, 15);
              newEndDate = new Date(occurrence2.endDate - 0 + (newStartDate - occurrence2.startDate));
              occurrence2.name = 'oops'; // setStartEndDate will not invoke setting values on project when batching is on, instead changes will be
              // postponed until endBatch.

              occurrence2.setStartEndDate(newStartDate, newEndDate);
              occurrence2.endBatch(); // Occurrence has changes -> promoted to actual event already
              // Need to calculate project before reading event start/end dates, they have been changed

              _context2.next = 26;
              return t.waitForProjectReady(eventStore);

            case 26:
              // applying the recurrence from old master
              occurrence2.recurrence = recurringEvent.recurrence.copy();
              _context2.next = 29;
              return t.waitForProjectReady();

            case 29:
              t.is(eventStore.count, 4, 'store has correct number of records');
              t.is(event3.occurrences.length, 2, 'event 3 has 2 attached occurrences');
              t.is(occurrence2.occurrences.length, 2, 'occurrence2 has 2 attached occurrences');
              t.is(event3.occurrences[0].name, 'Baz', 'event 3 occurrence got proper name');
              t.is(occurrence2.occurrences[0].name, 'oops', 'occurrence2 occurrence got proper name');
              t.notOk(occurrence2.dirty, 'occurrence #2 is not dirty');
              t.is(occurrence2.name, 'oops', 'occurrence #2 name is correct');
              t.is(occurrence2.startDate, new Date(2018, 5, 15), 'occurrence #2 start is correct');
              t.is(occurrence2.endDate, new Date(2018, 5, 16), 'occurrence #2 end is correct');

            case 38:
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
  t.it('Removing of an individual occurrence', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var resourceStore, eventStore, event3, occurrence2, occurrences;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              resourceStore = new ResourceStore({
                data: [{
                  id: 'r1'
                }]
              });
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Foo',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  name: 'Bar',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1'
                }, {
                  id: 3,
                  resourceId: 'r1',
                  name: 'Baz',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=2'
                }]
              });
              event3 = eventStore.getById(3);
              t.isntCalled('add', eventStore, 'Recurrences are not added');
              _context3.next = 6;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 6:
              scheduler1 = _context3.sent;
              _context3.next = 9;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 9:
              scheduler2 = _context3.sent;
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
              occurrence2 = event3.occurrences[2];
              event3.addExceptionDate(occurrence2.startDate);
              eventStore.remove(occurrence2);
              _context3.next = 17;
              return t.waitForProjectReady();

            case 17:
              t.diag('update master event name to trigger occurrences regenerating');
              event3.name = 'zaB';
              _context3.next = 21;
              return t.waitForProjectReady();

            case 21:
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.is(event3.occurrences.length, 4, 'event 3 has 4 attached occurrences');
              occurrences = event3.occurrences;
              t.is(occurrences[0].name, 'zaB', 'occurrence #0 got new name');
              t.is(occurrences[0].startDate, new Date(2018, 5, 16), 'occurrence #0 start is correct');
              t.is(occurrences[0].endDate, new Date(2018, 5, 17), 'occurrence #0 end is correct');
              t.is(occurrences[1].name, 'zaB', 'occurrence #1 got new name');
              t.is(occurrences[1].startDate, new Date(2018, 5, 18), 'occurrence #1 start is correct');
              t.is(occurrences[1].endDate, new Date(2018, 5, 19), 'occurrence #1 end is correct');
              t.is(occurrences[2].name, 'zaB', 'occurrence #2 got new name');
              t.is(occurrences[2].startDate, new Date(2018, 5, 22), 'occurrence #2 start is correct');
              t.is(occurrences[2].endDate, new Date(2018, 5, 23), 'occurrence #2 end is correct');
              t.is(occurrences[3].name, 'zaB', 'occurrence #3 got new name');
              t.is(occurrences[3].startDate, new Date(2018, 5, 24), 'occurrence #3 start is correct');
              t.is(occurrences[3].endDate, new Date(2018, 5, 25), 'occurrence #3 end is correct');

            case 36:
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
  t.it('Removing of further occurrences', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var resourceStore, eventStore, event3, occurrence2, occurrences;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              resourceStore = new ResourceStore({
                data: [{
                  id: 'r1'
                }]
              });
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Foo',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  name: 'Bar',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1'
                }, {
                  id: 3,
                  resourceId: 'r1',
                  name: 'Baz',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=2'
                }]
              });
              event3 = eventStore.getById(3);
              t.isntCalled('add', eventStore, 'Occurrences are not added');
              _context4.next = 6;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 6:
              scheduler1 = _context4.sent;
              _context4.next = 9;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 9:
              scheduler2 = _context4.sent;
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
              occurrence2 = event3.occurrences[2];
              event3.recurrence.endDate = new Date(occurrence2.startDate - 1);
              _context4.next = 16;
              return t.waitForProjectReady();

            case 16:
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.is(event3.occurrences.length, 2, 'event 3 has 2 attached occurrences');
              occurrences = event3.occurrences;
              t.is(occurrences[0].name, 'Baz', 'occurrence #0 got new name');
              t.is(occurrences[0].startDate, new Date(2018, 5, 16), 'occurrence #0 start is correct');
              t.is(occurrences[0].endDate, new Date(2018, 5, 17), 'occurrence #0 end is correct');
              t.is(occurrences[1].name, 'Baz', 'occurrence #1 got new name');
              t.is(occurrences[1].startDate, new Date(2018, 5, 18), 'occurrence #1 start is correct');
              t.is(occurrences[1].endDate, new Date(2018, 5, 19), 'occurrence #1 end is correct');

            case 25:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x5) {
      return _ref4.apply(this, arguments);
    };
  }());
});