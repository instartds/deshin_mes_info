function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  t.it('generateOccurrencesForEvents DAILY', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var eventStore, project, event, occurrence1, occurrence2;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: '2018-05-16 12:30:55',
                  endDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=2;COUNT=3'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  startDate: '2018-05-16 13:30:55',
                  endDate: '2018-05-18 12:12:13'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1'
                  }]
                })
              });
              _context.next = 4;
              return project.commitAsync();

            case 4:
              event = eventStore.first;
              t.ok(event.isRecurring, 'event is recurring');
              eventStore.getOccurrencesForTimeSpan(event, event.startDate, new Date(2020, 0, 1));
              t.is(eventStore.count, 2, 'event store has new records');
              t.is(eventStore.getAt(0), event, 'event is still there');
              t.is(event.startDate, new Date(2018, 4, 16, 12, 30, 55), 'event start date is correct');
              t.is(event.endDate, new Date(2018, 4, 18, 11, 12, 13), 'event end date is correct');
              occurrence1 = event.occurrences[0];
              t.is(occurrence1.recurringTimeSpan, event, 'occurrence #1 refers to its master event');
              t.is(occurrence1.startDate, new Date(2018, 4, 18, 12, 30, 55), 'occurrence #1 start date is correct');
              t.is(occurrence1.endDate, new Date(2018, 4, 20, 11, 12, 13), 'occurrence #1 end date is correct');
              t.ok(occurrence1.isOccurrence, 'occurrence #1 is indicated as occurrence');
              occurrence2 = event.occurrences[1];
              t.is(occurrence2.recurringTimeSpan, event, 'occurrence #2 refers to its master event');
              t.is(occurrence2.startDate, new Date(2018, 4, 20, 12, 30, 55), 'occurrence #2 start date is correct');
              t.is(occurrence2.endDate, new Date(2018, 4, 22, 11, 12, 13), 'occurrence #2 end date is correct');
              t.ok(occurrence2.isOccurrence, 'occurrence #2 is indicated as occurrence');

            case 21:
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
  t.it('generateOccurrencesForEvents WEEKLY', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var eventStore, project, event, occurrence1, occurrence2;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: '2018-05-16 12:30:55',
                  endDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=3;'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  startDate: '2018-05-16 13:30:55',
                  endDate: '2018-05-18 12:12:13'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1'
                  }]
                })
              });
              _context2.next = 4;
              return project.commitAsync();

            case 4:
              event = eventStore.getById(1);
              t.ok(event.isRecurring, 'event is recurring');
              eventStore.getOccurrencesForTimeSpan(event, event.startDate, new Date(2020, 0, 1));
              t.is(eventStore.count, 2, 'event store has no new records');
              t.is(event.occurrences.length, 2);
              t.is(eventStore.getAt(0), event, 'event is still there');
              t.is(event.startDate, new Date(2018, 4, 16, 12, 30, 55), 'event start date is correct');
              t.is(event.endDate, new Date(2018, 4, 18, 11, 12, 13), 'event end date is correct');
              occurrence1 = event.occurrences[0];
              t.is(occurrence1.recurringTimeSpan, event, 'occurrence #1 refers to its master event');
              t.is(occurrence1.startDate, new Date(2018, 4, 23, 12, 30, 55), 'occurrence #1 start date is correct');
              t.is(occurrence1.endDate, new Date(2018, 4, 25, 11, 12, 13), 'occurrence #1 end date is correct');
              t.ok(occurrence1.isOccurrence, 'occurrence #1 is indicated as occurrence');
              occurrence2 = event.occurrences[1];
              t.is(occurrence2.recurringTimeSpan, event, 'occurrence #2 refers to its master event');
              t.is(occurrence2.startDate, new Date(2018, 4, 30, 12, 30, 55), 'occurrence #2 start date is correct');
              t.is(occurrence2.endDate, new Date(2018, 5, 1, 11, 12, 13), 'occurrence #2 end date is correct');
              t.ok(occurrence2.isOccurrence, 'occurrence #2 is indicated as occurrence');

            case 22:
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
  t.it('generateOccurrencesForEvents MONTHLY', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var eventStore, project, event, occurrence1, occurrence2;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: '2018-05-16 12:30:55',
                  endDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=MONTHLY;INTERVAL=1;COUNT=3'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  startDate: '2018-05-16 13:30:55',
                  endDate: '2018-05-18 12:12:13'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1'
                  }]
                })
              });
              _context3.next = 4;
              return project.commitAsync();

            case 4:
              event = eventStore.getById(1);
              t.ok(event.isRecurring, 'event is recurring');
              eventStore.getOccurrencesForTimeSpan(event, event.startDate, new Date(2020, 0, 1));
              t.is(eventStore.count, 2, 'event store has no new records');
              t.is(eventStore.getAt(0), event, 'event is still there');
              t.is(event.startDate, new Date(2018, 4, 16, 12, 30, 55), 'event start date is correct');
              t.is(event.endDate, new Date(2018, 4, 18, 11, 12, 13), 'event end date is correct');
              occurrence1 = event.occurrences[0];
              t.is(occurrence1.recurringTimeSpan, event, 'occurrence #1 refers to its master event');
              t.is(occurrence1.startDate, new Date(2018, 5, 16, 12, 30, 55), 'occurrence #1 start date is correct');
              t.is(occurrence1.endDate, new Date(2018, 5, 18, 11, 12, 13), 'occurrence #1 end date is correct');
              t.ok(occurrence1.isOccurrence, 'occurrence #1 is indicated as occurrence');
              occurrence2 = event.occurrences[1];
              t.is(occurrence2.recurringTimeSpan, event, 'occurrence #2 refers to its master event');
              t.is(occurrence2.startDate, new Date(2018, 6, 16, 12, 30, 55), 'occurrence #2 start date is correct');
              t.is(occurrence2.endDate, new Date(2018, 6, 18, 11, 12, 13), 'occurrence #2 end date is correct');
              t.ok(occurrence2.isOccurrence, 'occurrence #2 is indicated as occurrence');

            case 21:
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
  t.it('generateOccurrencesForEvents YEARLY', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var eventStore, project, event, occurrence1, occurrence2;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: '2018-05-16 12:30:55',
                  endDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=YEARLY;INTERVAL=1;COUNT=3;'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  startDate: '2018-05-16 13:30:55',
                  endDate: '2018-05-18 12:12:13'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1'
                  }]
                })
              });
              _context4.next = 4;
              return project.commitAsync();

            case 4:
              event = eventStore.getById(1);
              t.ok(event.isRecurring, 'event is recurring');
              eventStore.getOccurrencesForTimeSpan(event, event.startDate, new Date(2020, 4, 17));
              t.is(eventStore.count, 2, 'event store has no new records');
              t.is(eventStore.getAt(0), event, 'event is still there');
              t.is(event.startDate, new Date(2018, 4, 16, 12, 30, 55), 'event start date is correct');
              t.is(event.endDate, new Date(2018, 4, 18, 11, 12, 13), 'event end date is correct');
              occurrence1 = event.occurrences[0];
              t.is(occurrence1.recurringTimeSpan, event, 'occurrence #1 refers to its master event');
              t.is(occurrence1.startDate, new Date(2019, 4, 16, 12, 30, 55), 'occurrence #1 start date is correct');
              t.is(occurrence1.endDate, new Date(2019, 4, 18, 11, 12, 13), 'occurrence #1 end date is correct');
              t.ok(occurrence1.isOccurrence, 'occurrence #1 is indicated as occurrence');
              occurrence2 = event.occurrences[1];
              t.is(occurrence2.recurringTimeSpan, event, 'occurrence #2 refers to its master event');
              t.is(occurrence2.startDate, new Date(2020, 4, 16, 12, 30, 55), 'occurrence #2 start date is correct');
              t.is(occurrence2.endDate, new Date(2020, 4, 18, 11, 12, 13), 'occurrence #2 end date is correct');
              t.ok(occurrence2.isOccurrence, 'occurrence #2 is indicated as occurrence');

            case 21:
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
  t.it('DAILY Record should stay not modified if fields are the same', function (t) {
    var event = new EventModel({
      id: 'event1',
      startDate: new Date(2018, 5, 14),
      endDate: new Date(2018, 5, 15),
      name: 'Foo'
    });
    var recurrence = new RecurrenceModel({
      id: 'recurrence1',
      event: event,
      frequency: 'DAILY',
      interval: 5
    });
    t.notOk(recurrence.modified, 'Recurrence record is not modified');
    recurrence.set({
      id: 'recurrence1',
      frequency: 'DAILY',
      interval: 5
    });
    t.notOk(recurrence.modified, 'Still recurrence record is not modified');
  });
  t.it('WEEKLY Record should stay not modified if fields are the same', function (t) {
    var event = new EventModel({
      id: 'event1',
      startDate: new Date(2018, 5, 14),
      endDate: new Date(2018, 5, 15),
      name: 'Foo'
    });
    var recurrence = new RecurrenceModel({
      id: 'recurrence1',
      event: event,
      frequency: 'WEEKLY',
      interval: 5,
      days: ['MO', 'WE']
    });
    t.notOk(recurrence.modified, 'Recurrence record is not modified');
    recurrence.set({
      id: 'recurrence1',
      frequency: 'WEEKLY',
      interval: 5,
      days: ['MO', 'WE']
    });
    t.notOk(recurrence.modified, 'Still recurrence record is not modified');
  });
  t.it('MONTHLY Record should stay not modified if fields are the same', function (t) {
    var event = new EventModel({
      id: 'event1',
      startDate: new Date(2018, 5, 14),
      endDate: new Date(2018, 5, 15),
      name: 'Foo'
    });
    var recurrence = new RecurrenceModel({
      id: 'recurrence1',
      event: event,
      frequency: 'MONTHLY',
      interval: 5,
      monthDays: [1, 2, 3]
    });
    t.notOk(recurrence.modified, 'Recurrence record is not modified');
    recurrence.set({
      id: 'recurrence1',
      frequency: 'MONTHLY',
      interval: 5,
      monthDays: [1, 2, 3]
    });
    t.notOk(recurrence.modified, 'Still recurrence record is not modified');
  });
  t.it('YEARLY Record should stay not modified if fields are the same', function (t) {
    var event = new EventModel({
      id: 'event1',
      startDate: new Date(2018, 5, 14),
      endDate: new Date(2018, 5, 15),
      name: 'Foo'
    });
    var recurrence = new RecurrenceModel({
      id: 'recurrence1',
      event: event,
      frequency: 'YEARLY',
      interval: 5,
      months: [5, 6, 7],
      days: ['TU'],
      positions: [2]
    });
    t.notOk(recurrence.modified, 'Recurrence record is not modified');
    recurrence.set({
      id: 'recurrence1',
      frequency: 'YEARLY',
      interval: 5,
      months: [5, 6, 7],
      days: ['TU'],
      positions: [2]
    });
    t.notOk(recurrence.modified, 'Still recurrence record is not modified');
  }); //region Sanitize

  t.it('MONTHLY Record should not lose days info if the day matches event start date', function (t) {
    var event = new EventModel({
      id: 'event1',
      startDate: new Date(2018, 5, 14),
      // TH
      endDate: new Date(2018, 5, 15),
      // FR
      name: 'Foo'
    });
    var recurrence = new RecurrenceModel({
      id: 'recurrence1',
      event: event,
      frequency: 'MONTHLY',
      interval: 5,
      days: ['TH'],
      // Day matches event start date
      positions: [2]
    });
    t.notOk(recurrence.modified, 'Recurrence record is not modified');
    recurrence.set({
      id: 'recurrence1',
      frequency: 'MONTHLY',
      interval: 5,
      days: ['TH'],
      // Day matches event start date
      positions: [2]
    });
    t.notOk(recurrence.modified, 'Still recurrence record is not modified');
  });
  t.it('YEARLY Record should not lose days info if the day matches event start date', function (t) {
    var event = new EventModel({
      id: 'event1',
      startDate: new Date(2018, 5, 14),
      // TH
      endDate: new Date(2018, 5, 15),
      // FR
      name: 'Foo'
    });
    var recurrence = new RecurrenceModel({
      id: 'recurrence1',
      event: event,
      frequency: 'YEARLY',
      interval: 5,
      months: [5, 6, 7],
      days: ['TH'],
      // Day matches event start date
      positions: [2]
    });
    t.notOk(recurrence.modified, 'Recurrence record is not modified');
    recurrence.set({
      id: 'recurrence1',
      frequency: 'YEARLY',
      interval: 5,
      months: [5, 6, 7],
      days: ['TH'],
      // Day matches event start date
      positions: [2]
    });
    t.notOk(recurrence.modified, 'Still recurrence record is not modified');
  }); //endregion Sanitize

  t.it('Overridden startDate and endDate field definitions', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var EventClass, eventStore, project, event, occurrence1, occurrence2;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              EventClass = /*#__PURE__*/function (_EventModel) {
                _inherits(EventClass, _EventModel);

                var _super = _createSuper(EventClass);

                function EventClass() {
                  _classCallCheck(this, EventClass);

                  return _super.apply(this, arguments);
                }

                _createClass(EventClass, null, [{
                  key: "fields",
                  get: function get() {
                    return [{
                      name: 'startDate',
                      dataSource: 'EventDate',
                      type: 'date'
                    }, {
                      name: 'endDate',
                      dataSource: 'EndDate',
                      type: 'date'
                    }];
                  }
                }]);

                return EventClass;
              }(EventModel);

              eventStore = new EventStore({
                modelClass: EventClass,
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  EventDate: '2018-05-16 12:30:55',
                  EndDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=2;COUNT=3'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1'
                  }]
                })
              });
              _context5.next = 5;
              return project.commitAsync();

            case 5:
              event = eventStore.first;
              t.ok(event.isRecurring, 'event is recurring');
              eventStore.getOccurrencesForTimeSpan(event, event.startDate, new Date(2020, 0, 1));
              t.is(eventStore.count, 1, 'event store has new records');
              t.is(eventStore.getAt(0), event, 'event is still there');
              t.is(event.startDate, new Date(2018, 4, 16, 12, 30, 55), 'event start date is correct');
              t.is(event.endDate, new Date(2018, 4, 18, 11, 12, 13), 'event end date is correct');
              occurrence1 = event.occurrences[0];
              t.is(occurrence1.recurringTimeSpan, event, 'occurrence #1 refers to its master event');
              t.is(occurrence1.startDate, new Date(2018, 4, 18, 12, 30, 55), 'occurrence #1 start date is correct');
              t.is(occurrence1.endDate, new Date(2018, 4, 20, 11, 12, 13), 'occurrence #1 end date is correct');
              t.ok(occurrence1.isOccurrence, 'occurrence #1 is indicated as occurrence');
              occurrence2 = event.occurrences[1];
              t.is(occurrence2.recurringTimeSpan, event, 'occurrence #2 refers to its master event');
              t.is(occurrence2.startDate, new Date(2018, 4, 20, 12, 30, 55), 'occurrence #2 start date is correct');
              t.is(occurrence2.endDate, new Date(2018, 4, 22, 11, 12, 13), 'occurrence #2 end date is correct');
              t.ok(occurrence2.isOccurrence, 'occurrence #2 is indicated as occurrence');

            case 22:
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
  t.it('getEvents date range is mandatory if occurrences are required', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var eventStore, project, event;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: '2018-05-16 12:30:55',
                  endDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=2;COUNT=3'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1'
                  }]
                })
              });
              _context6.next = 4;
              return project.commitAsync();

            case 4:
              event = eventStore.first;
              t.ok(event.isRecurring, 'event is recurring');
              t.throwsOk(function () {
                eventStore.getEvents({
                  resourceRecord: event.resource
                });
              }, 'getEvents MUST be passed startDate and endDate if recurring occurrences are requested', 'Error correctly thrown if no date range passed');

            case 7:
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
});