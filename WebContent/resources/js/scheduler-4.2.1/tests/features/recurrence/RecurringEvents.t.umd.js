function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler1, scheduler2;
  t.beforeEach(function () {
    return Base.destroy(scheduler1, scheduler2);
  });

  function occurrence(event, index) {
    return event.occurrences[index];
  }

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(config) {
      var scheduler;
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return t.getSchedulerAsync(Object.assign({
                enableRecurringEvents: true,
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 17),
                height: 300
              }, config));

            case 2:
              scheduler = _context17.sent;
              return _context17.abrupt("return", scheduler);

            case 4:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('Does not generate events after the recurrence rule\'s COUNT has been reached', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var resourceStore, eventStore, recurringEvent, events;
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
                  name: 'Only twice!',
                  startDate: '2020-01-06',
                  endDate: '2020-01-08',
                  recurrenceRule: 'FREQ=WEEKLY;COUNT=2'
                }]
              });
              _context.next = 4;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore,
                startDate: '2020-01-13',
                endDate: '2020-01-31'
              });

            case 4:
              scheduler1 = _context.sent;
              recurringEvent = eventStore.first; // It should occur on its own startDate, the 6th

              events = eventStore.getEvents({
                startDate: new Date(2020, 0, 6),
                endDate: new Date(2020, 0, 7)
              });
              t.is(events.length, 1);
              t.is(events[0], recurringEvent, 'event occurs on its startDate'); // And the date it extends into, the 7th

              events = eventStore.getEvents({
                startDate: new Date(2020, 0, 7),
                endDate: new Date(2020, 0, 8)
              });
              t.is(events.length, 1);
              t.is(events[0], recurringEvent, 'event occurs on its startDate'); // There should be an occurrence on the 13th

              events = eventStore.getEvents({
                startDate: new Date(2020, 0, 13),
                endDate: new Date(2020, 0, 14)
              });
              t.is(events.length, 1);
              t.is(events[0], recurringEvent.occurrences[0], 'event recurs the following week'); // And the 14th

              events = eventStore.getEvents({
                startDate: new Date(2020, 0, 14),
                endDate: new Date(2020, 0, 15)
              });
              t.is(events.length, 1);
              t.is(events[0], recurringEvent.occurrences[0], 'event recurs the following week');
              events = eventStore.getEvents({
                startDate: new Date(2020, 0, 20),
                endDate: new Date(2020, 0, 21)
              }); // We're past the last occurrence which was on the 13th
              // So no occurrences

              t.is(events.length, 0, 'No occurrences after the second week');
              events = eventStore.getEvents({
                startDate: new Date(2020, 0, 21),
                endDate: new Date(2020, 0, 22)
              }); // We're past the last occurrence which was on the 13th
              // So no occurrences

              t.is(events.length, 0, 'No occurrences after the second week');
              events = eventStore.getEvents({
                startDate: new Date(2020, 0, 27),
                endDate: new Date(2020, 0, 28)
              }); // We're past the last occurrence which was on the 13th
              // So no occurrences

              t.is(events.length, 0, 'No occurrences after the second week');
              events = eventStore.getEvents({
                startDate: new Date(2020, 0, 28),
                endDate: new Date(2020, 0, 29)
              }); // We're past the last occurrence which was on the 13th
              // So no occurrences

              t.is(events.length, 0, 'No occurrences after the second week');

            case 26:
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
  t.it('Generates occurrences for recurring events', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var resourceStore, eventStore, _eventStore$records, event1, event2, event3, occurrence;

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
              _eventStore$records = _slicedToArray(eventStore.records, 3), event1 = _eventStore$records[0], event2 = _eventStore$records[1], event3 = _eventStore$records[2];
              t.isntCalled('add', eventStore, 'occurrences are not added');
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
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.notOk(event2.occurrences.length, 'event 2 has no occurrences');
              t.is(event3.occurrences.length, 1, 'event 3 has 1 occurrence');
              t.hasCls(scheduler1.getElementsFromEventRecord(event3)[0], 'b-recurring', 'scheduler 1: event 3 element is marked with proper CSS class');
              t.hasCls(scheduler2.getElementsFromEventRecord(event3)[0], 'b-recurring', 'scheduler 2: event 3 element is marked with proper CSS class');
              occurrence = event3.occurrences[0];
              t.is(occurrence.startDate, new Date(2018, 5, 16), 'occurrence start date is correct');
              t.is(occurrence.endDate, new Date(2018, 5, 17), 'occurrence end date is correct');
              t.is(occurrence.recurringTimeSpan, event3, 'occurrence references to event 3');
              t.hasCls(scheduler1.getElementsFromEventRecord(occurrence)[0], 'b-occurrence', 'scheduler 1: occurrence element is marked with proper CSS class');
              t.hasCls(scheduler2.getElementsFromEventRecord(occurrence)[0], 'b-occurrence', 'scheduler 2: occurrence element is marked with proper CSS class');

            case 21:
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
  t.it('Doesn\'t generates occurrences if enableRecurringEvents===false', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var resourceStore, eventStore, _eventStore, event1, event2, event3;

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
              _eventStore = _slicedToArray(eventStore, 3), event1 = _eventStore[0], event2 = _eventStore[1], event3 = _eventStore[2];
              _context3.next = 5;
              return getScheduler({
                enableRecurringEvents: false,
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 5:
              scheduler1 = _context3.sent;
              _context3.next = 8;
              return getScheduler({
                enableRecurringEvents: false,
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 8:
              scheduler2 = _context3.sent;
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.notOk(event2.occurrences.length, 'event 2 has no occurrences');
              t.notOk(event3.occurrences.length, 'event 3 has no occurrences');

            case 12:
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
  t.it('Generates occurrences for recurring multi-assigned events', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var resourceStore, eventStore, assignmentStore;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              resourceStore = new ResourceStore({
                data: [{
                  id: 'r1'
                }, {
                  id: 'r2'
                }]
              });
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  name: 'Foo',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15'
                }, {
                  id: 2,
                  name: 'Bar',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1'
                }, {
                  id: 3,
                  name: 'Baz',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=2'
                }]
              });
              assignmentStore = new AssignmentStore({
                data: [{
                  id: 1,
                  eventId: 1,
                  resourceId: 'r1'
                }, {
                  id: 2,
                  eventId: 2,
                  resourceId: 'r1'
                }, {
                  id: 3,
                  eventId: 3,
                  resourceId: 'r1'
                }, {
                  id: 4,
                  eventId: 1,
                  resourceId: 'r2'
                }, {
                  id: 5,
                  eventId: 2,
                  resourceId: 'r2'
                }, {
                  id: 6,
                  eventId: 3,
                  resourceId: 'r2'
                }]
              });
              _context4.next = 5;
              return getScheduler({
                assignmentStore: assignmentStore,
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 5:
              scheduler1 = _context4.sent;
              t.selectorCountIs('.b-sch-event:textEquals(Baz)', 4, 'Baz Multi-assigned + recurring');
              t.selectorCountIs('.b-sch-event:textEquals(Bar)', 2, 'Bar Multi-assigned');
              t.selectorCountIs('.b-sch-event:textEquals(Foo)', 2, 'Foo Multi-assigned');

            case 9:
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
  t.it('Generate occurrences on timespan change', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var resourceStore, eventStore, _eventStore2, event1, event2, event3;

      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
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
              _eventStore2 = _slicedToArray(eventStore, 3), event1 = _eventStore2[0], event2 = _eventStore2[1], event3 = _eventStore2[2];
              _context5.next = 5;
              return getScheduler({
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 18),
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 5:
              scheduler1 = _context5.sent;
              _context5.next = 8;
              return getScheduler({
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 18),
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 8:
              scheduler2 = _context5.sent;
              // move to the next week
              scheduler1.shiftNext(7);
              _context5.next = 12;
              return scheduler1.project.commitAsync();

            case 12:
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrence');
              t.is(occurrence(event2, 0).startDate, new Date(2018, 5, 21), 'event 2 1st occurrence start date is correct');
              t.is(occurrence(event2, 0).endDate, new Date(2018, 5, 22), 'event 2 1st occurrence end date is correct');
              t.is(occurrence(event2, 0).recurringTimeSpan, event2, 'event 2 1st occurrence references to event 2');
              t.is(occurrence(event3, 0).startDate, new Date(2018, 5, 16), 'event 3 1st occurrence start date is correct');
              t.is(occurrence(event3, 0).endDate, new Date(2018, 5, 17), 'event 3 1st occurrence end date is correct');
              t.is(occurrence(event3, 0).recurringTimeSpan, event3, 'event 3 1st occurrence references to event 3');
              t.is(occurrence(event3, 1).startDate, new Date(2018, 5, 18), 'event 3 2nd occurrence start date is correct');
              t.is(occurrence(event3, 1).endDate, new Date(2018, 5, 19), 'event 3 2nd occurrence end date is correct');
              t.is(occurrence(event3, 1).recurringTimeSpan, event3, 'event 3 2nd occurrence references to event 3');
              t.is(occurrence(event3, 2).startDate, new Date(2018, 5, 20), 'event 3 3rd occurrence start date is correct');
              t.is(occurrence(event3, 2).endDate, new Date(2018, 5, 21), 'event 3 3rd occurrence end date is correct');
              t.is(occurrence(event3, 2).recurringTimeSpan, event3, 'event 3 3rd occurrence references to event 3');
              t.is(occurrence(event3, 3).startDate, new Date(2018, 5, 22), 'event 3 4th occurrence start date is correct');
              t.is(occurrence(event3, 3).endDate, new Date(2018, 5, 23), 'event 3 4th occurrence end date is correct');
              t.is(occurrence(event3, 3).recurringTimeSpan, event3, 'event 3 4th occurrence references to event 3');
              t.is(occurrence(event3, 4).startDate, new Date(2018, 5, 24), 'event 3 5th occurrence start date is correct');
              t.is(occurrence(event3, 4).endDate, new Date(2018, 5, 25), 'event 3 5th occurrence end date is correct');
              t.is(occurrence(event3, 4).recurringTimeSpan, event3, 'event 3 5th occurrence references to event 3');

            case 33:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x6) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Adds occurrences on event add', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var resourceStore, eventStore, _eventStore3, event1, event2, event3, event4;

      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
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
              _eventStore3 = _slicedToArray(eventStore, 3), event1 = _eventStore3[0], event2 = _eventStore3[1], event3 = _eventStore3[2];
              t.isCalledOnce('add', eventStore, 'Only 1 event will be added');
              _context6.next = 6;
              return getScheduler({
                id: 'scheduler1',
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 18),
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 6:
              scheduler1 = _context6.sent;
              _context6.next = 9;
              return getScheduler({
                id: 'scheduler2',
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 18),
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 9:
              scheduler2 = _context6.sent;
              eventStore.add({
                id: 4,
                resourceId: 'r1',
                name: 'Neo',
                startDate: '2018-06-14 08:00:00',
                endDate: '2018-06-15',
                recurrenceRule: 'FREQ=DAILY;INTERVAL=2'
              });
              _context6.next = 13;
              return t.waitForProjectReady();

            case 13:
              t.is(eventStore.count, 4, 'store has correct number of records');
              t.selectorCountIs('.b-sch-event-wrap', 12, 'Correct number of event bars');
              event4 = eventStore.getById(4);
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.notOk(event2.occurrences.length, 'event 2 has no occurrences');
              t.is(event3.occurrences.length, 2, 'event 3 has 2 occurrences');
              t.is(event4.occurrences.length, 1, 'event 4 has 1 occurrence');
              t.is(occurrence(event3, 0).startDate, new Date(2018, 5, 16), 'event 3 1st occurrence start date is correct');
              t.is(occurrence(event3, 0).endDate, new Date(2018, 5, 17), 'event 3 1st occurrence end date is correct');
              t.is(occurrence(event3, 0).recurringTimeSpan, event3, 'event 3 1st occurrence references to event 3');
              t.is(occurrence(event3, 1).startDate, new Date(2018, 5, 18), 'event 3 2nd occurrence start date is correct');
              t.is(occurrence(event3, 1).endDate, new Date(2018, 5, 19), 'event 3 2nd occurrence end date is correct');
              t.is(occurrence(event3, 1).recurringTimeSpan, event3, 'event 3 2nd occurrence references to event 3');
              t.is(occurrence(event4, 0).startDate, new Date(2018, 5, 16, 8), 'event 4 1st occurrence start date is correct');
              t.is(occurrence(event4, 0).endDate, new Date(2018, 5, 17), 'event 4 1st occurrence end date is correct');
              t.is(occurrence(event4, 0).recurringTimeSpan, event4, 'event 4 1st occurrence references to event 4');

            case 29:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x7) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Removes occurrences on event remove', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var resourceStore, eventStore, _eventStore4, event1, event2, event3;

      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
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
              _eventStore4 = _slicedToArray(eventStore, 3), event1 = _eventStore4[0], event2 = _eventStore4[1], event3 = _eventStore4[2];
              t.isntCalled('add', eventStore, 'occurrences are not added');
              t.isCalledNTimes('remove', eventStore, 1, '1 event is removed');
              _context7.next = 7;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore,
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25)
              });

            case 7:
              scheduler1 = _context7.sent;
              _context7.next = 10;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore,
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25)
              });

            case 10:
              scheduler2 = _context7.sent;
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.selectorCountIs('.b-sch-event-wrap', 12, 'Correct number of event bars');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrence');
              eventStore.remove(event3);
              _context7.next = 19;
              return t.waitForProjectReady();

            case 19:
              t.is(eventStore.count, 2, 'store got correct number of records');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');

            case 22:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x8) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Updates occurrences on event update', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var resourceStore, eventStore, _eventStore5, event1, event2, event3;

      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
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
              _eventStore5 = _slicedToArray(eventStore, 3), event1 = _eventStore5[0], event2 = _eventStore5[1], event3 = _eventStore5[2];
              t.firesOk({
                observable: eventStore,
                events: {
                  add: 0,
                  remove: 0,
                  // there are 2 update events:
                  // 1. setting name
                  // 2. first setStartDate which starts async commit
                  // No events for changes to occurrences
                  update: 2
                }
              });
              _context8.next = 6;
              return getScheduler({
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25),
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 6:
              scheduler1 = _context8.sent;
              _context8.next = 9;
              return getScheduler({
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25),
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 9:
              scheduler2 = _context8.sent;
              event3.setStartDate(new Date(2018, 5, 14, 13), false);
              event3.name = 'zaB';
              _context8.next = 14;
              return scheduler1.project.commitAsync();

            case 14:
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.selectorCountIs(scheduler1.unreleasedEventSelector, 10, 'Correct number of event bars');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrence');
              t.is(occurrence(event3, 0).startDate, new Date(2018, 5, 16, 13), 'event 3 1st occurrence start date is correct');
              t.is(occurrence(event3, 0).endDate, new Date(2018, 5, 17), 'event 3 1st occurrence end date is correct');
              t.is(occurrence(event3, 0).recurringTimeSpan, event3, 'event 3 1st occurrence references to event 3');
              t.is(occurrence(event3, 0).name, 'zaB', 'event 3 1st occurrence name is correct');
              t.is(occurrence(event3, 1).startDate, new Date(2018, 5, 18, 13), 'event 3 2nd occurrence start date is correct');
              t.is(occurrence(event3, 1).endDate, new Date(2018, 5, 19), 'event 3 2nd occurrence end date is correct');
              t.is(occurrence(event3, 1).recurringTimeSpan, event3, 'event 3 2nd occurrence references to event 3');
              t.is(occurrence(event3, 1).name, 'zaB', 'event 3 2nd occurrence name is correct');
              t.is(occurrence(event3, 2).startDate, new Date(2018, 5, 20, 13), 'event 3 3rd occurrence start date is correct');
              t.is(occurrence(event3, 2).endDate, new Date(2018, 5, 21), 'event 3 3rd occurrence end date is correct');
              t.is(occurrence(event3, 2).recurringTimeSpan, event3, 'event 3 3rd occurrence references to event 3');
              t.is(occurrence(event3, 2).name, 'zaB', 'event 3 3rd occurrence name is correct');
              t.is(occurrence(event3, 3).startDate, new Date(2018, 5, 22, 13), 'event 3 4th occurrence start date is correct');
              t.is(occurrence(event3, 3).endDate, new Date(2018, 5, 23), 'event 3 4th occurrence end date is correct');
              t.is(occurrence(event3, 3).recurringTimeSpan, event3, 'event 3 4th occurrence references to event 3');
              t.is(occurrence(event3, 3).name, 'zaB', 'event 3 4th occurrence name is correct');
              t.is(occurrence(event3, 4).startDate, new Date(2018, 5, 24, 13), 'event 3 5th occurrence start date is correct');
              t.is(occurrence(event3, 4).endDate, new Date(2018, 5, 25), 'event 3 5th occurrence end date is correct');
              t.is(occurrence(event3, 4).recurringTimeSpan, event3, 'event 3 5th occurrence references to event 3');
              t.is(occurrence(event3, 4).name, 'zaB', 'event 3 5th occurrence name is correct');

            case 39:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x9) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Repeating events a persistable but their occurrences are not', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var resourceStore, eventStore, _eventStore6, event1, event2, event3;

      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
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
              _eventStore6 = _slicedToArray(eventStore, 3), event1 = _eventStore6[0], event2 = _eventStore6[1], event3 = _eventStore6[2];
              _context9.next = 5;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore,
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25)
              });

            case 5:
              scheduler1 = _context9.sent;
              _context9.next = 8;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore,
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25)
              });

            case 8:
              scheduler2 = _context9.sent;
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.selectorCountIs('.b-sch-event-wrap', 12, 'Correct number of event bars');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrence');
              t.ok(event1.isPersistable, 'event 1 is persistable');
              t.ok(event2.isPersistable, 'event 2 is persistable');
              t.ok(event3.isPersistable, 'event 3 is persistable');
              t.notOk(event2.occurrences[0].isPersistable, 'event 2 occurrence is not persistable');
              event3.occurrences.forEach(function (occurrence, index) {
                return t.notOk(occurrence.isPersistable, "event 3 occurrence ".concat(index, " is not persistable"));
              });

            case 19:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x10) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Should be possible to disable ', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return getScheduler({
                enableRecurringEvents: false,
                eventStore: t.getEventStore({
                  data: [{
                    startDate: '2011-01-04 08:00',
                    endDate: '2011-01-04 12:00',
                    recurrenceRule: 'FREQ=DAILY'
                  }]
                })
              });

            case 2:
              scheduler1 = _context10.sent;
              t.is(scheduler1.eventStore.count, 1, 'Only one event is visible');

            case 4:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x11) {
      return _ref10.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7431

  t.it('Recurring event occurrences are generated once even if event and timespan are changed in the process of generating', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      var eventStore, scheduler1, event;
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              eventStore = new EventStore();
              _context11.next = 3;
              return getScheduler({
                eventStore: eventStore,
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1',
                    name: 'Resource 1'
                  }]
                }),
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 18)
              });

            case 3:
              scheduler1 = _context11.sent;
              event = eventStore.add({
                id: 1,
                resourceId: 'r1',
                name: 'Foo',
                startDate: '2018-06-14',
                endDate: '2018-06-15',
                recurrenceRule: 'FREQ=DAILY;INTERVAL=2;COUNT=2'
              })[0];
              event.name = 'Bar';
              scheduler1.setTimeSpan(new Date(2018, 5, 12), new Date(2018, 5, 19));
              _context11.next = 9;
              return t.waitForProjectReady();

            case 9:
              t.is(eventStore.getById(1).occurrences.length, 1, 'Event has proper number of occurrences');

            case 10:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x12) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Generates occurrences for future occurrences of new recurring event', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      var resourceStore, eventStore, event1, newBase;
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
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
                  name: 'Bar',
                  startDate: '2018-06-06T09:00:00',
                  endDate: '2018-06-06T10:00:00',
                  recurrenceRule: 'FREQ=WEEKLY;BYDAY=TU,TH'
                }]
              });
              event1 = eventStore.getById(1);
              _context12.next = 5;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore,
                startDate: new Date(2018, 5, 1),
                endDate: new Date(2018, 6, 1),
                viewPreset: 'weekAndDayLetter',
                fillTicks: true
              });

            case 5:
              scheduler1 = _context12.sent;
              // Due to engine rescheduling activity, occurrences will be uncached.
              // refresh the Scheduler's view of occurrences to make them available.
              event1.getOccurrencesForDateRange(scheduler1.timeAxis.startDate, scheduler1.timeAxis.endDate);
              t.is(eventStore.count, 1, 'Only one event in store');
              t.is(event1.occurrences.length, 6, 'event 1 has 6 occurrences');
              newBase = event1.occurrences[2]; // Promote Tues 19th June's occurrence to be a new base of wednesday and thursday occurrences

              newBase.set('recurrenceRule', 'FREQ=WEEKLY;BYDAY=WE,TH');
              _context12.next = 13;
              return t.waitForProjectReady();

            case 13:
              t.is(eventStore.count, 2, 'Two events in store');
              t.is(event1.occurrences.length, 2, 'event 1 has 2 occurrences');
              t.is(event1.occurrences[0].startDate, new Date(2018, 5, 12, 9));
              t.is(event1.occurrences[1].startDate, new Date(2018, 5, 14, 9));
              t.is(newBase.occurrences.length, 3, 'New recurring base has 3 occurrences');
              t.is(newBase.occurrences[0].startDate, new Date(2018, 5, 21, 9));
              t.is(newBase.occurrences[1].startDate, new Date(2018, 5, 27, 9));
              t.is(newBase.occurrences[2].startDate, new Date(2018, 5, 28, 9));

            case 21:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x13) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('Generates correct number of occurrences from COUNT on new recurring event', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      var resourceStore, eventStore, event1;
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
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
                  name: 'Bar',
                  startDate: '2018-06-06T09:00:00',
                  endDate: '2018-06-06T10:00:00',
                  recurrenceRule: 'FREQ=DAILY;COUNT=3'
                }]
              });
              event1 = eventStore.getById(1);
              _context13.next = 5;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore,
                startDate: new Date(2018, 5, 1),
                endDate: new Date(2018, 6, 1),
                viewPreset: 'weekAndDayLetter',
                fillTicks: true
              });

            case 5:
              scheduler1 = _context13.sent;
              // Due to engine rescheduling activity, occurrences will be uncached.
              // refresh the Scheduler's view of occurrences to make them available.
              event1.getOccurrencesForDateRange(scheduler1.timeAxis.startDate, scheduler1.timeAxis.endDate);
              t.is(eventStore.count, 1, 'Only one event in store');
              t.is(event1.occurrences.length, 2, 'event has 2 occurrences');
              t.is(event1.occurrences[0].startDate, new Date(2018, 5, 7, 9));
              t.is(event1.occurrences[1].startDate, new Date(2018, 5, 8, 9));

            case 11:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x14) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('Generates occurrences for events which are promoted to be recurring', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      var resourceStore, eventStore, _eventStore$records2, event1;

      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
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
                  startDate: '2018-06-11',
                  endDate: '2018-06-12'
                }]
              });
              _eventStore$records2 = _slicedToArray(eventStore.records, 1), event1 = _eventStore$records2[0];
              t.isntCalled('add', eventStore, 'occurrences are not added');
              _context14.next = 6;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 6:
              scheduler1 = _context14.sent;
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.hasNotCls(scheduler1.getElementsFromEventRecord(event1)[0], 'b-recurring', 'Event 1 element has not got recurring CSS class');
              event1.recurrenceRule = 'FREQ=DAILY;INTERVAL=2';
              t.ok(eventStore.recurringEvents.has(event1), 'Newly recurring event is in recurringEvents cache');
              t.hasCls(scheduler1.getElementsFromEventRecord(event1)[0], 'b-recurring', 'Event 1 element has got recurring CSS class');
              t.is(event1.occurrences.length, 3, 'event 1 has 3 occurrences');

            case 13:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x15) {
      return _ref14.apply(this, arguments);
    };
  }());
  t.it('Clears occurrences for events which are demoted from recurring to singular', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      var resourceStore, eventStore, _eventStore$records3, event1;

      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
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
                  startDate: '2018-06-11',
                  endDate: '2018-06-12',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=2'
                }]
              });
              _eventStore$records3 = _slicedToArray(eventStore.records, 1), event1 = _eventStore$records3[0];
              t.isntCalled('add', eventStore, 'occurrences are not added');
              _context15.next = 6;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 6:
              scheduler1 = _context15.sent;
              t.ok(eventStore.recurringEvents.has(event1), 'Recurring event is in recurringEvents cache');
              t.hasCls(scheduler1.getElementsFromEventRecord(event1)[0], 'b-recurring', 'Event 1 element has got recurring CSS class');
              t.chain({
                waitFor: function waitFor() {
                  return event1.occurrences.length === 3;
                }
              }, function (next) {
                t.is(event1.occurrences.length, 3, 'event 1 has 3 occurrences');
                event1.recurrenceRule = '';
                next();
              }, {
                waitFor: function waitFor() {
                  return event1.occurrences.length === 0;
                }
              }, function () {
                t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
                t.notOk(eventStore.recurringEvents.has(event1), 'Newly singular event is not in recurringEvents cache');
                t.hasNotCls(scheduler1.getElementsFromEventRecord(event1)[0], 'b-recurring', 'Event 1 element has not got recurring CSS class');
              });

            case 10:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x16) {
      return _ref15.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1570

  t.it('Draws recurring events on scroll', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return getScheduler({
                rowHeight: 70,
                minHeight: '20em',
                events: [],
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2018, 4, 1),
                viewPreset: 'weekAndDayLetter'
              });

            case 2:
              scheduler1 = _context16.sent;
              // Bug happens when data is applied after initial propagate
              scheduler1.resourceStore.data = ArrayHelper.populate(10, function (i) {
                return {
                  id: i + 1
                };
              });
              scheduler1.eventStore.data = [{
                id: 1,
                name: 'Annual meeting',
                startDate: '2018-01-16',
                endDate: '2018-01-30',
                recurrenceRule: 'FREQ=YEARLY'
              }];
              scheduler1.assignmentStore.data = [{
                eventId: 1,
                resourceId: 4
              }];
              _context16.next = 8;
              return scheduler1.project.commitAsync();

            case 8:
              scheduler1.scrollTop = 100;
              _context16.next = 11;
              return t.waitForAnimationFrame();

            case 11:
              t.selectorExists(scheduler1.unreleasedEventSelector, 'Event drawn');

            case 12:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x17) {
      return _ref16.apply(this, arguments);
    };
  }());
});