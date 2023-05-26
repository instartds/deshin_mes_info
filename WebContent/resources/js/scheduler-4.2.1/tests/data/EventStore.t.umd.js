function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr == null ? null : typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]; if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

StartTest(function (t) {
  var project;
  t.beforeEach(function (t) {
    var _project;

    (_project = project) === null || _project === void 0 ? void 0 : _project.destroy();
    project = null;
  });
  t.it('Basic instantiation', function (t) {
    var store = new EventStore({
      data: [{}]
    });
    t.isInstanceOf(store.first, EventModel, 'Store should be configured with EventModel');

    var Event2 = /*#__PURE__*/function (_EventModel) {
      _inherits(Event2, _EventModel);

      var _super = _createSuper(Event2);

      function Event2() {
        _classCallCheck(this, Event2);

        return _super.apply(this, arguments);
      }

      return Event2;
    }(EventModel);

    store = new EventStore({
      modelClass: Event2,
      data: [{}]
    });
    t.isInstanceOf(store.first, EventModel, 'Should be ok to subclass EventModel');
    t.throwsOk(function () {
      new EventStore({
        modelClass: /*#__PURE__*/function (_Model) {
          _inherits(Event3, _Model);

          var _super2 = _createSuper(Event3);

          function Event3() {
            _classCallCheck(this, Event3);

            return _super2.apply(this, arguments);
          }

          return Event3;
        }(Model)
      });
    }, 'The model for the EventStore must subclass EventModel');
  });
  t.it('isInterDay determination', function (t) {
    var store = new EventStore({
      data: [{
        id: 1,
        // interDay: midnight to midnight
        startDate: '2020-01-01',
        endDate: '2020-01-02'
      }, {
        id: 2,
        startDate: '2020-01-01T23:59:59',
        // Only 2 seconds, but spans midnight: interDay
        endDate: '2020-01-02T00:00:01'
      }, {
        id: 3,
        startDate: '2020-01-01',
        // interDay by one second
        endDate: '2020-01-02T00:00:01'
      }, {
        id: 4,
        startDate: '2020-01-01T00:00:01',
        // Not interday, ends at midnight
        endDate: '2020-01-02T00:00:00'
      }, {
        id: 5,
        startDate: '2020-01-01T20:00:00',
        // Not interday, ends at midnight
        endDate: '2020-01-02T00:00:00'
      }]
    });
    t.ok(store.records[0].isInterDay, 'midnight to midnight event is interDay');
    t.ok(store.records[1].isInterDay, 'Two second event is interDay');
    t.ok(store.records[2].isInterDay, 'interDay by one second event is interDay');
    t.notOk(store.records[3].isInterDay, 'Event which starts at 00:00:01 is not interDay');
    t.notOk(store.records[4].isInterDay, 'Event which starts at 20:00:00 is not interDay');
  });
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
                  startDate: '2020-01-01',
                  endDate: '2020-01-03',
                  recurrenceRule: 'FREQ=WEEKLY;BYDAY=MO;COUNT=2'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: resourceStore
              });
              _context.next = 5;
              return project.commitAsync();

            case 5:
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
              }); // That should have corrected the event

              t.is(recurringEvent.startDate, new Date(2020, 0, 6), 'Event start has been adjusted to align with its rule');
              t.is(recurringEvent.endDate, new Date(2020, 0, 8), 'Event end has been adjusted to align with its rule'); // We're past the last occurrence which was on the 13th
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

            case 28:
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
  t.it('EventStore data assignment', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var data, store, rs, events1, events2;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              data = [{
                id: 1,
                resourceId: 'c2',
                name: 'Derp',
                startDate: '2020-05-20',
                endDate: '2020-05-21'
              }];
              store = new EventStore({
                data: ObjectHelper.clone(data)
              });
              rs = new ResourceStore();
              project = new ProjectModel({
                eventStore: store,
                resourceStore: rs
              });
              _context2.next = 6;
              return project.commitAsync();

            case 6:
              events1 = store.getEvents({
                startDate: new Date(2020, 4, 19),
                endDate: new Date(2020, 4, 22)
              });
              t.is(events1.length, 1, 'Correct number of events');
              store.data = data;
              events2 = store.getEvents({
                startDate: new Date(2020, 4, 19),
                endDate: new Date(2020, 4, 22)
              });
              t.is(events2.length, 1, 'Correct number of events');

            case 11:
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
  t.it('getEvents + getTotalTimeSpan', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var store, rs;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              store = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'c2',
                  name: 'Linda',
                  startDate: '2010-12-09',
                  endDate: '2010-12-13'
                }]
              });
              rs = new ResourceStore();
              project = new ProjectModel({
                eventStore: store,
                resourceStore: rs
              });
              _context3.next = 5;
              return project.commitAsync();

            case 5:
              t.is(store.resourceStore, rs, 'Should find resourceStore set on the eventStore');
              t.is(store.getEvents({
                startDate: new Date(2010, 11, 9),
                endDate: new Date(2010, 11, 13)
              }).length, 1, 'getEventsInTimeSpan');
              t.is(store.getEvents({
                startDate: new Date(2010, 11, 9),
                endDate: new Date(2010, 11, 10),
                allowPartial: false
              }).length, 0, 'getEventsInTimeSpan partial miss');
              t.is(store.getEvents({
                startDate: new Date(2010, 11, 9),
                endDate: new Date(2010, 11, 13),
                allowPartial: false
              }).length, 1, 'getEventsInTimeSpan get 1');
              t.isDeeplyStrict(store.getTotalTimeSpan(), {
                startDate: new Date(2010, 11, 9),
                endDate: new Date(2010, 11, 13)
              }, 'getTotalTimeSpan');
              store.add(new EventModel({
                startDate: new Date(2009, 1, 1)
              }));
              _context3.next = 13;
              return project.commitAsync();

            case 13:
              t.isDeeplyStrict(store.getTotalTimeSpan(), {
                startDate: new Date(2009, 1, 1),
                endDate: new Date(2010, 11, 13)
              }, 'getTotalTimeSpan 2');
              store.remove(store.first);

            case 15:
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
  t.it('getTotalTimeSpan partial data', function (t) {
    var store = new EventStore({
      data: [{
        startDate: '2010-12-09'
      }]
    });
    t.isDeeplyStrict(store.getTotalTimeSpan(), {
      startDate: new Date(2010, 11, 9),
      endDate: new Date(2010, 11, 9)
    }, 'Missing end date');
    store.first.set({
      startDate: null,
      endDate: new Date(2009, 1, 1)
    });
    t.isDeeplyStrict(store.getTotalTimeSpan(), {
      startDate: null,
      endDate: new Date(2009, 1, 1)
    }, 'Missing start date');
  });
  t.it('getEvents startOnly', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var resourceStore, eventStore, intersecting, starting, recurring, r0, r1;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              resourceStore = new ResourceStore({
                data: [{
                  id: 1
                }]
              }), eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 1,
                  name: 'Intersecting',
                  startDate: '2010-12-21',
                  endDate: '2011-01-21'
                }, {
                  id: 2,
                  resourceId: 1,
                  name: 'Starting',
                  startDate: '2011-01-02',
                  endDate: '2011-01-02'
                }, {
                  id: 3,
                  resourceId: 1,
                  name: '2nd Occurrence is 01 to 03 Jan 2011',
                  startDate: '2010-12-25',
                  endDate: '2010-12-28',
                  recurrenceRule: 'FREQ=WEEKLY'
                }]
              }), intersecting = eventStore.getById(1), starting = eventStore.getById(2), recurring = eventStore.getById(3);
              project = new ProjectModel({
                eventStore: eventStore,
                // With engine, matching resources are required
                resourceStore: resourceStore
              });
              _context4.next = 4;
              return t.waitForProjectReady(project);

            case 4:
              r0 = eventStore.getEvents({
                startDate: new Date(2011, 0, 1),
                startOnly: false
              });
              t.isDeeply(r0, [recurring.occurrences[0], intersecting], 'allowPartial is the defalt when startOnly is not set'); // This must not include the occurrence of the recurring event that intersects this date

              r1 = eventStore.getEvents({
                startDate: new Date(2011, 0, 2),
                startOnly: true
              });
              t.isDeeply(r1, [starting], 'startOnly overrides the default of allowPartial');

            case 8:
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
  t.it('getByInternalId + append', function (t) {
    var store = new EventStore({
      data: [{
        resourceId: 'c2',
        name: 'Linda',
        startDate: '2010-12-09',
        endDate: '2010-12-13'
      }]
    });
    t.is(store.getById(store.first.id), store.first, 'getById with dirty id');
    store.append({
      id: 2
    });
    t.ok(store.getById(2), 'Found record after "append"');
  });
  t.it('Should properly report list of events assigned to resource', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var idify, eventStore, resourceStore, event;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              idify = function _idify(arr) {
                return arr.map(function (item) {
                  return item.id;
                });
              };

              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(),
                  duration: 1
                }]
              }), resourceStore = new ResourceStore({
                data: [{
                  id: 1
                }, {
                  id: 2
                }, {
                  id: 3
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                // With engine, matching resources are required
                resourceStore: resourceStore
              });
              _context5.next = 5;
              return t.waitForProjectReady(project);

            case 5:
              t.isDeeply(idify(eventStore.getEventsForResource(1)), [1]);
              eventStore.add([{
                id: 2,
                resourceId: 1,
                startDate: new Date(),
                duration: 1
              }, {
                id: 3,
                resourceId: 1,
                startDate: new Date(),
                duration: 1
              }, {
                id: 4,
                resourceId: 2,
                startDate: new Date(),
                duration: 1
              }]);
              _context5.next = 9;
              return t.waitForProjectReady(project);

            case 9:
              t.isDeeplyUnordered(idify(eventStore.getEventsForResource(1)), [1, 2, 3]);
              t.isDeeplyUnordered(idify(eventStore.getEventsForResource(2)), [4]);
              eventStore.remove(eventStore.first);
              _context5.next = 14;
              return t.waitForProjectReady(project);

            case 14:
              t.isDeeplyUnordered(idify(eventStore.getEventsForResource(1)), [2, 3]);
              t.isDeeplyUnordered(idify(eventStore.getEventsForResource(2)), [4]);
              eventStore.remove(eventStore.last);
              _context5.next = 19;
              return t.waitForProjectReady(project);

            case 19:
              t.isDeeplyUnordered(idify(eventStore.getEventsForResource(1)), [2, 3]);
              t.isDeeplyUnordered(idify(eventStore.getEventsForResource(2)), []);
              event = eventStore.add({
                resourceId: 3,
                id: 5
              })[0];
              _context5.next = 24;
              return t.waitForProjectReady(project);

            case 24:
              t.isDeeplyUnordered(idify(eventStore.getEventsForResource(3)), [5]);
              event.resourceId = 1;
              _context5.next = 28;
              return t.waitForProjectReady(project);

            case 28:
              t.isDeeplyUnordered(idify(eventStore.getEventsForResource(1)), [2, 3, 5]);
              eventStore.removeAll();
              _context5.next = 32;
              return t.waitForProjectReady(project);

            case 32:
              t.isDeeplyUnordered(idify(eventStore.getEventsForResource(1)), []);
              eventStore.data = [{
                resourceId: 1,
                id: 1
              }];
              _context5.next = 36;
              return t.waitForProjectReady(project);

            case 36:
              t.isDeeplyUnordered(idify(eventStore.getEventsForResource(1)), [1]);

            case 37:
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
  t.it('Should add split record to store and assign to same resource', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var _project2, eventStore;

      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              project = new ProjectModel({
                eventsData: [{
                  resourceId: 1,
                  id: 1,
                  startDate: new Date(2020, 0, 23),
                  duration: 2
                }],
                resourcesData: [{
                  id: 1
                }]
              });
              _project2 = project, eventStore = _project2.eventStore;
              _context6.next = 4;
              return project.commitAsync();

            case 4:
              _context6.next = 6;
              return eventStore.first.split();

            case 6:
              t.is(eventStore.count, 2, 'Both parts in EventStore');
              t.is(eventStore.last.resourceId, eventStore.first.resourceId, 'Parts have matching resourceIds');
              t.is(project.assignmentStore.count, 2, '2 assignments found');
              t.ok(eventStore.last.isPhantom, 'New part flagged as phantom');

            case 10:
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
  t.it('Should be able to split a multiassigned event', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var _project3, eventStore, _project$eventStore, original, clone;

      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              project = new ProjectModel({
                eventsData: [{
                  id: 1,
                  startDate: new Date(2020, 0, 23),
                  duration: 2
                }],
                resourcesData: [{
                  id: 1
                }, {
                  id: 2
                }],
                assignmentsData: [{
                  id: 1,
                  eventId: 1,
                  resourceId: 1
                }, {
                  id: 2,
                  eventId: 1,
                  resourceId: 2
                }]
              });
              _project3 = project, eventStore = _project3.eventStore;
              _context7.next = 4;
              return project.commitAsync();

            case 4:
              _context7.next = 6;
              return eventStore.first.split();

            case 6:
              _project$eventStore = _slicedToArray(project.eventStore, 2), original = _project$eventStore[0], clone = _project$eventStore[1];
              t.is(eventStore.count, 2, 'Both parts in EventStore');
              t.is(project.assignmentStore.count, 4, '4 assignments found');
              t.isDeeplyUnordered(original.resources, project.resourceStore.records, 'Original has correct resources');
              t.isDeeplyUnordered(clone.resources, project.resourceStore.records, 'Clone has correct resources');
              t.ok(eventStore.last.isPhantom, 'New part flagged as phantom');

            case 12:
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
  t.it('isDateRangeAvailable should work', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var _project4, eventStore, resourceStore, firstEvent, lastEvent, firstResource, lastResource;

      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              project = new ProjectModel({
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1',
                    name: 'Mike'
                  }, {
                    id: 'r2',
                    name: 'Linda'
                  }]
                }),
                eventStore: new EventStore({
                  data: [{
                    id: 'e10',
                    resourceId: 'r1',
                    name: 'Foo',
                    startDate: '2011-01-04',
                    endDate: '2011-01-06'
                  }, {
                    id: 'e11',
                    resourceId: 'r2',
                    name: 'Bar',
                    startDate: '2011-01-05',
                    endDate: '2011-01-07'
                  }, {
                    id: 'e12',
                    resourceId: 'r1',
                    name: 'XYZ',
                    startDate: '2011-01-08',
                    endDate: '2011-01-09'
                  }, // Should handle missing dates
                  {}, {
                    resourceId: 'r1'
                  }, {
                    resourceId: 'r1',
                    startDate: new Date()
                  }, {
                    startDate: new Date()
                  }, {
                    endDate: new Date()
                  }]
                })
              });
              _project4 = project, eventStore = _project4.eventStore, resourceStore = _project4.resourceStore, firstEvent = eventStore.first, lastEvent = eventStore.getById('e12'), firstResource = resourceStore.first, lastResource = resourceStore.last;
              _context8.next = 4;
              return project.commitAsync();

            case 4:
              t.ok(eventStore.isDateRangeAvailable(firstEvent.startDate, firstEvent.endDate, firstEvent, firstResource), 'First resource is available during the first event timespan (with event excluded)');
              t.notOk(eventStore.isDateRangeAvailable(firstEvent.startDate, firstEvent.endDate, null, firstResource), 'First resource is not available during the first event timespan');
              t.notOk(eventStore.isDateRangeAvailable(firstEvent.startDate, firstEvent.endDate, firstEvent, lastResource), 'Last resource is not available during the first event timespan (with event excluded)');
              t.notOk(eventStore.isDateRangeAvailable(firstEvent.startDate, firstEvent.endDate, null, lastResource), 'Last resource is not available during the first event timespan');
              t.ok(eventStore.isDateRangeAvailable(lastEvent.startDate, lastEvent.endDate, firstEvent, lastResource), 'Last resource is available during the last event timespan (with exception to the first event timespan)');
              t.ok(eventStore.isDateRangeAvailable(lastEvent.startDate, lastEvent.endDate, null, lastResource), 'Last resource is available during the last event timespan');

            case 10:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x8) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('isDateRangeAvailable with assignments should work', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var _project5, eventStore, resourceStore, assignmentStore, firstEvent, lastEvent, firstAssignment, firstResource, lastResource;

      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              project = new ProjectModel({
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1',
                    name: 'Mike'
                  }, {
                    id: 'r2',
                    name: 'Linda'
                  }]
                }),
                eventStore: new EventStore({
                  data: [{
                    id: 'e10',
                    name: 'Foo',
                    startDate: '2011-01-04',
                    endDate: '2011-01-06'
                  }, {
                    id: 'e11',
                    name: 'Bar',
                    startDate: '2011-01-05',
                    endDate: '2011-01-07'
                  }, {
                    id: 'e12',
                    name: 'XYZ',
                    startDate: '2011-01-08',
                    endDate: '2011-01-09'
                  }]
                }),
                assignmentStore: new AssignmentStore({
                  data: [{
                    id: 'a1',
                    resourceId: 'r1',
                    eventId: 'e10'
                  }, {
                    id: 'a2',
                    resourceId: 'r2',
                    eventId: 'e11'
                  }, {
                    id: 'a3',
                    resourceId: 'r1',
                    eventId: 'e12'
                  }]
                })
              });
              _project5 = project, eventStore = _project5.eventStore, resourceStore = _project5.resourceStore, assignmentStore = _project5.assignmentStore, firstEvent = eventStore.first, lastEvent = eventStore.last, firstAssignment = assignmentStore.first, firstResource = resourceStore.first, lastResource = resourceStore.last;
              _context9.next = 4;
              return project.commitAsync();

            case 4:
              t.ok(eventStore.isDateRangeAvailable(firstEvent.startDate, firstEvent.endDate, firstAssignment, firstResource), 'First resource is available during the first event timespan (with assignment excluded)');
              t.notOk(eventStore.isDateRangeAvailable(firstEvent.startDate, firstEvent.endDate, firstAssignment, lastResource), 'Last resource is not available during the first event timespan (with assignment excluded)');
              t.ok(eventStore.isDateRangeAvailable(lastEvent.startDate, lastEvent.endDate, firstAssignment, lastResource), 'Last resource is available during the last event timespan (with assignment excluded)');
              t.notOk(eventStore.isDateRangeAvailable(firstEvent.startDate, firstEvent.endDate, null, firstResource), 'First resource is not available during the first event timespan');
              t.notOk(eventStore.isDateRangeAvailable(firstEvent.startDate, firstEvent.endDate, null, lastResource), 'Last resource is not available during the first event timespan');
              t.ok(eventStore.isDateRangeAvailable(lastEvent.startDate, lastEvent.endDate, null, lastResource), 'Last resource is available during the last event timespan');

            case 10:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x9) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('isDateRangeAvailable with multi-assignments should work', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var _project6, eventStore, assignmentStore, assignment1, assignment2, resource, firstEvent, lastEvent;

      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              project = new ProjectModel({
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1',
                    name: 'Mike'
                  }, {
                    id: 'r2',
                    name: 'Linda'
                  }, {
                    id: 'r3',
                    name: 'John'
                  }]
                }),
                eventStore: new EventStore({
                  data: [{
                    id: 'e10',
                    name: 'Foo',
                    startDate: '2011-01-04',
                    endDate: '2011-01-06'
                  }, {
                    id: 'e11',
                    name: 'Bar',
                    startDate: '2011-01-05',
                    endDate: '2011-01-07'
                  }, {
                    id: 'e12',
                    name: 'XYZ',
                    startDate: '2011-01-08',
                    endDate: '2011-01-09'
                  }]
                }),
                assignmentStore: new AssignmentStore({
                  data: [{
                    id: 'a11',
                    resourceId: 'r1',
                    eventId: 'e10'
                  }, {
                    id: 'a12',
                    resourceId: 'r3',
                    eventId: 'e10'
                  }, {
                    id: 'a2',
                    resourceId: 'r2',
                    eventId: 'e11'
                  }, {
                    id: 'a3',
                    resourceId: 'r1',
                    eventId: 'e12'
                  }]
                })
              });
              _project6 = project, eventStore = _project6.eventStore, assignmentStore = _project6.assignmentStore, assignment1 = assignmentStore.getById('a11'), assignment2 = assignmentStore.getById('a12'), resource = project.resourceStore.getById('r2'), firstEvent = eventStore.first, lastEvent = eventStore.last;
              _context10.next = 4;
              return project.commitAsync();

            case 4:
              t.notOk(eventStore.isDateRangeAvailable(firstEvent.startDate, firstEvent.endDate, assignment1, resource), 'Second resource is not available during the first event timespan (with assignment excluded)');
              t.ok(eventStore.isDateRangeAvailable(lastEvent.startDate, lastEvent.endDate, assignment1, resource), 'Second resource is available during the last event timespan (with assignment excluded)');
              t.ok(eventStore.isDateRangeAvailable(new Date(2011, 0, 10), new Date(2011, 0, 12), assignment1, resource), 'Second resource is available during custom timespan (with assignment excluded)');
              t.notOk(eventStore.isDateRangeAvailable(firstEvent.startDate, firstEvent.endDate, assignment2, resource), 'Second resource is not available during the first event timespan (with another assignment excluded)');
              t.notOk(eventStore.isDateRangeAvailable(lastEvent.startDate, lastEvent.endDate, assignment2, resource), 'Second resource is not available during the last event timespan (with another assignment excluded)');
              t.ok(eventStore.isDateRangeAvailable(new Date(2011, 0, 10), new Date(2011, 0, 12), assignment2, resource), 'Second resource is available during custom timespan (with another assignment excluded)');

            case 10:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x10) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Should not crash with syncDataOnLoad', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      var eventStore;
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              eventStore = new EventStore({
                syncDataOnLoad: true,
                data: [{
                  id: 1,
                  startDate: '2020-08-21',
                  endDate: '2020-08-22'
                }, {
                  id: 2,
                  startDate: '2020-08-21',
                  endDate: '2020-08-23'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore
              });
              _context11.next = 4;
              return project.commitAsync();

            case 4:
              eventStore.data = [{
                id: 1,
                startDate: '2020-08-21',
                endDate: '2020-08-23'
              }, {
                id: 2,
                startDate: '2020-08-21',
                endDate: '2020-08-23'
              }];
              _context11.next = 7;
              return project.commitAsync();

            case 7:
              t.is(eventStore.first.endDate, new Date(2020, 7, 23), 'Event\'s endDate updated');
              t.is(eventStore.first.duration, 2, 'Duration too');

            case 9:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x11) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Data should be ready after addAsync()', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      var eventStore;
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              eventStore = new EventStore();
              project = new ProjectModel({
                eventStore: eventStore
              });
              _context12.next = 4;
              return eventStore.addAsync({
                startDate: '2020-09-11',
                duration: 3
              });

            case 4:
              t.is(eventStore.first.endDate, new Date(2020, 8, 14), 'Calculations performed');

            case 5:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x12) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('Data should be ready after loadDataAsync()', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      var eventStore;
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              eventStore = new EventStore();
              project = new ProjectModel({
                eventStore: eventStore
              });
              _context13.next = 4;
              return eventStore.loadDataAsync([{
                startDate: '2020-09-11',
                duration: 3
              }]);

            case 4:
              t.is(eventStore.first.endDate, new Date(2020, 8, 14), 'Calculations performed');

            case 5:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x13) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('Should trigger events when data is ready', function (t) {
    t.it('Add', /*#__PURE__*/function () {
      var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
        var eventStore;
        return regeneratorRuntime.wrap(function _callee14$(_context14) {
          while (1) {
            switch (_context14.prev = _context14.next) {
              case 0:
                eventStore = new EventStore({
                  listeners: {
                    addPreCommit: function addPreCommit(_ref15) {
                      var records = _ref15.records;
                      t.is(records[0].endDate, undefined, 'Not normalized in addPreCommit');
                    },
                    add: function add(_ref16) {
                      var records = _ref16.records;
                      t.is(records[0].endDate, new Date(2020, 8, 10), 'Normalized in add');
                    },
                    changePreCommit: function changePreCommit(_ref17) {
                      var records = _ref17.records,
                          action = _ref17.action;

                      if (action === 'add') {
                        t.is(records[0].endDate, undefined, 'Not normalized in changePreCommit');
                      }
                    },
                    change: function change(_ref18) {
                      var records = _ref18.records,
                          action = _ref18.action;

                      if (action === 'add') {
                        t.is(records[0].endDate, new Date(2020, 8, 10), 'Normalized in change');
                      }
                    }
                  }
                });
                t.firesOk(eventStore, {
                  addPreCommit: 1,
                  add: 1,
                  changePreCommit: 2,
                  // update caused by normalization + add
                  change: 2 // dito

                });
                project = new ProjectModel({
                  eventStore: eventStore
                });
                _context14.next = 5;
                return project.commitAsync();

              case 5:
                eventStore.add({
                  id: 1,
                  startDate: '2020-09-08',
                  duration: 2
                });
                _context14.next = 8;
                return project.commitAsync();

              case 8:
              case "end":
                return _context14.stop();
            }
          }
        }, _callee14);
      }));

      return function (_x14) {
        return _ref14.apply(this, arguments);
      };
    }());
    t.it('Dataset', /*#__PURE__*/function () {
      var _ref19 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
        var eventStore;
        return regeneratorRuntime.wrap(function _callee15$(_context15) {
          while (1) {
            switch (_context15.prev = _context15.next) {
              case 0:
                eventStore = new EventStore({
                  listeners: {
                    refreshPreCommit: function refreshPreCommit(_ref20) {
                      var records = _ref20.records,
                          action = _ref20.action;

                      if (action === 'dataset') {
                        t.notOk(records[0].endDate, 'Not normalized in refreshPreCommit');
                      }
                    },
                    refresh: function refresh(_ref21) {
                      var records = _ref21.records,
                          action = _ref21.action;

                      if (action === 'dataset') {
                        t.is(records[0].endDate, new Date(2020, 8, 10), 'Normalized in refresh');
                      }
                    },
                    changePreCommit: function changePreCommit(_ref22) {
                      var records = _ref22.records,
                          action = _ref22.action;

                      if (action === 'dataset') {
                        t.notOk(records[0].endDate, 'Not normalized in changePreCommit');
                      }
                    },
                    change: function change(_ref23) {
                      var records = _ref23.records,
                          action = _ref23.action;

                      if (action === 'dataset') {
                        t.is(records[0].endDate, new Date(2020, 8, 10), 'Normalized in change');
                      }
                    }
                  }
                });
                t.firesOk(eventStore, {
                  refreshPreCommit: 1,
                  refresh: 1,
                  changePreCommit: 2,
                  // update caused by normalization + add
                  change: 2 // dito

                });
                project = new ProjectModel({
                  silenceInitialCommit: false,
                  eventStore: eventStore
                });
                _context15.next = 5;
                return project.commitAsync();

              case 5:
                eventStore.data = [{
                  id: 1,
                  startDate: '2020-09-08',
                  duration: 2
                }];
                _context15.next = 8;
                return project.commitAsync();

              case 8:
              case "end":
                return _context15.stop();
            }
          }
        }, _callee15);
      }));

      return function (_x15) {
        return _ref19.apply(this, arguments);
      };
    }());
    t.it('Remove', /*#__PURE__*/function () {
      var _ref24 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
        var eventStore;
        return regeneratorRuntime.wrap(function _callee16$(_context16) {
          while (1) {
            switch (_context16.prev = _context16.next) {
              case 0:
                eventStore = new EventStore({
                  data: [{
                    id: 1,
                    startDate: '2020-09-08',
                    duration: 2
                  }]
                });
                project = new ProjectModel({
                  eventStore: eventStore
                });
                _context16.next = 4;
                return project.commitAsync();

              case 4:
                t.firesOk(eventStore, {
                  removePreCommit: 1,
                  remove: 1,
                  changePreCommit: 1,
                  change: 1
                });
                eventStore.first.remove();
                _context16.next = 8;
                return project.commitAsync();

              case 8:
              case "end":
                return _context16.stop();
            }
          }
        }, _callee16);
      }));

      return function (_x16) {
        return _ref24.apply(this, arguments);
      };
    }());
    t.it('Update should come after add', /*#__PURE__*/function () {
      var _ref25 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
        var triggeredEvents, eventStore;
        return regeneratorRuntime.wrap(function _callee17$(_context17) {
          while (1) {
            switch (_context17.prev = _context17.next) {
              case 0:
                triggeredEvents = [];
                eventStore = new EventStore({
                  listeners: {
                    catchAll: function catchAll(_ref26) {
                      var type = _ref26.type,
                          action = _ref26.action;
                      var result = {
                        type: type
                      };

                      if (action) {
                        result.action = action;
                      }

                      triggeredEvents.push(result);
                    }
                  }
                });
                project = new ProjectModel({
                  eventStore: eventStore
                });
                _context17.next = 5;
                return project.commitAsync();

              case 5:
                eventStore.add({
                  id: 1,
                  startDate: '2020-09-08',
                  duration: 2
                });
                _context17.next = 8;
                return project.commitAsync();

              case 8:
                t.isDeeply(triggeredEvents, [{
                  type: 'beforeadd'
                }, {
                  type: 'addprecommit'
                }, {
                  type: 'changeprecommit',
                  action: 'add'
                }, {
                  type: 'beforeupdate'
                }, {
                  type: 'updateprecommit'
                }, {
                  type: 'changeprecommit',
                  action: 'update'
                }, {
                  type: 'add'
                }, {
                  type: 'change',
                  action: 'add'
                }, {
                  type: 'update'
                }, {
                  type: 'change',
                  action: 'update'
                }]);

              case 9:
              case "end":
                return _context17.stop();
            }
          }
        }, _callee17);
      }));

      return function (_x17) {
        return _ref25.apply(this, arguments);
      };
    }());
  }); // https://github.com/bryntum/support/issues/1576

  t.it('Should be able to assign using `set()', /*#__PURE__*/function () {
    var _ref27 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
      var eventStore, resourceStore, _eventStore, event;

      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1
                }]
              });
              resourceStore = new ResourceStore({
                data: [{
                  id: 1
                }, {
                  id: 2
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: resourceStore
              });
              _eventStore = _slicedToArray(eventStore, 1), event = _eventStore[0];
              _context18.next = 6;
              return project.commitAsync();

            case 6:
              event.set({
                resourceId: 1
              });
              _context18.next = 9;
              return project.commitAsync();

            case 9:
              t.is(event.resource, resourceStore.first, 'Assigned correctly after set()');
              t.is(event.data.resourceId, 1, 'Data updated correctly');
              event.resourceId = 2;
              _context18.next = 14;
              return project.commitAsync();

            case 14:
              t.is(event.resource, resourceStore.last, 'Assigned correctly after resourceId=');
              t.is(event.data.resourceId, 2, 'Data updated correctly');
              event.beginBatch();
              event.resourceId = 1;
              event.endBatch();
              _context18.next = 21;
              return project.commitAsync();

            case 21:
              t.is(event.resource, resourceStore.first, 'Assigned correctly after batch');
              t.is(event.data.resourceId, 1, 'Data updated correctly');

            case 23:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    }));

    return function (_x18) {
      return _ref27.apply(this, arguments);
    };
  }());
  t.it('reapplyFilterOnAdd : false should work with getEvents API', /*#__PURE__*/function () {
    var _ref28 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t) {
      var eventStore, event1, event2, records, event3;
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              eventStore = new EventStore({
                syncDataOnLoad: true,
                data: [{
                  id: 1,
                  name: 'Event 1',
                  category: 'A',
                  startDate: '2020-08-21',
                  endDate: '2020-08-22'
                }, {
                  id: 2,
                  name: 'Event 2',
                  category: 'B',
                  startDate: '2020-08-22',
                  endDate: '2020-08-23'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore
              });
              event1 = eventStore.getById(1), event2 = eventStore.getById(2);
              _context19.next = 5;
              return project.commitAsync();

            case 5:
              records = eventStore.getEvents({
                startDate: new Date(2020, 7, 21),
                endDate: new Date(2020, 7, 25)
              }); // All records available

              t.is(records.length, 2);
              t.ok(records.includes(event1));
              t.ok(records.includes(event2));
              eventStore.filter({
                property: 'category',
                value: 'B',
                operator: '='
              });
              records = eventStore.getEvents({
                startDate: new Date(2020, 7, 21),
                endDate: new Date(2020, 7, 25)
              }); // Only category B records available

              t.is(records.length, 1);
              t.notOk(records.includes(event1));
              t.ok(records.includes(event2)); // Create an event which would be filtered out if reapplyFilterOnAdd was true

              event3 = eventStore.createRecord({
                id: 3,
                name: 'Event 3',
                category: 'A',
                startDate: '2020-08-23',
                endDate: '2020-08-24'
              });
              _context19.next = 17;
              return eventStore.addAsync(event3);

            case 17:
              records = eventStore.getEvents({
                startDate: new Date(2020, 7, 21),
                endDate: new Date(2020, 7, 25)
              }); // Event 3 is there because reapplyFilterOnAdd is false

              t.is(records.length, 2);
              t.notOk(records.includes(event1));
              t.ok(records.includes(event2));
              t.ok(records.includes(event3)); // Programmatically reapply same filter set

              eventStore.filter();
              records = eventStore.getEvents({
                startDate: new Date(2020, 7, 21),
                endDate: new Date(2020, 7, 25)
              }); // Event 3 is not there now because we have reapplied the filters

              t.is(records.length, 1);
              t.notOk(records.includes(event1));
              t.ok(records.includes(event2));
              t.notOk(records.includes(event3));

            case 28:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    }));

    return function (_x19) {
      return _ref28.apply(this, arguments);
    };
  }());
  t.it('reapplyFilterOnAdd : true should work with getEvents API', /*#__PURE__*/function () {
    var _ref29 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(t) {
      var eventStore, event1, event2, records, event3;
      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              eventStore = new EventStore({
                syncDataOnLoad: true,
                reapplyFilterOnAdd: true,
                data: [{
                  id: 1,
                  name: 'Event 1',
                  category: 'A',
                  startDate: '2020-08-21',
                  endDate: '2020-08-22'
                }, {
                  id: 2,
                  name: 'Event 2',
                  category: 'B',
                  startDate: '2020-08-22',
                  endDate: '2020-08-23'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore
              });
              event1 = eventStore.getById(1), event2 = eventStore.getById(2);
              _context20.next = 5;
              return project.commitAsync();

            case 5:
              records = eventStore.getEvents({
                startDate: new Date(2020, 7, 21),
                endDate: new Date(2020, 7, 25)
              }); // All records available

              t.is(records.length, 2);
              t.ok(records.includes(event1));
              t.ok(records.includes(event2));
              eventStore.filter({
                property: 'category',
                value: 'B',
                operator: '='
              });
              records = eventStore.getEvents({
                startDate: new Date(2020, 7, 21),
                endDate: new Date(2020, 7, 25)
              }); // Only category B records available

              t.is(records.length, 1);
              t.notOk(records.includes(event1));
              t.ok(records.includes(event2)); // Create an event which would be filtered out if reapplyFilterOnAdd was true

              event3 = eventStore.createRecord({
                id: 3,
                name: 'Event 3',
                category: 'A',
                startDate: '2020-08-23',
                endDate: '2020-08-24'
              });
              _context20.next = 17;
              return eventStore.addAsync(event3);

            case 17:
              records = eventStore.getEvents({
                startDate: new Date(2020, 7, 21),
                endDate: new Date(2020, 7, 25)
              }); // Event 3 is not there because reapplyFilterOnAdd is true

              t.is(records.length, 1);
              t.notOk(records.includes(event1));
              t.ok(records.includes(event2));
              t.notOk(records.includes(event3));

            case 22:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    }));

    return function (_x20) {
      return _ref29.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2418

  t.it('Should respect silent flag for add() method', /*#__PURE__*/function () {
    var _ref30 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21(t) {
      var eventStore;
      return regeneratorRuntime.wrap(function _callee21$(_context21) {
        while (1) {
          switch (_context21.prev = _context21.next) {
            case 0:
              eventStore = new EventStore();
              project = new ProjectModel({
                eventStore: eventStore
              });
              t.wontFire(eventStore, 'change');
              t.wontFire(eventStore, 'add');
              eventStore.add({}, true);
              _context21.next = 7;
              return project.commitAsync();

            case 7:
            case "end":
              return _context21.stop();
          }
        }
      }, _callee21);
    }));

    return function (_x21) {
      return _ref30.apply(this, arguments);
    };
  }());
  t.describe('dayTime indexing', function (t) {
    var eventStore;
    t.beforeEach(function () {
      eventStore = new EventStore({
        data: [{
          id: 1,
          name: 'Zip',
          startDate: '2021-05-04 15:00:00',
          endDate: '2021-05-04 19:00:00'
        }, {
          id: 2,
          name: 'Foo',
          startDate: '2021-05-04 20:00:00',
          endDate: '2021-05-05 02:00:00'
        }, {
          id: 3,
          name: 'Bar',
          startDate: '2021-05-05 01:00:00',
          endDate: '2021-05-05 03:00:00'
        }, {
          id: 4,
          name: 'Derp',
          startDate: '2021-05-05 17:00:00',
          endDate: '2021-05-06 01:00:00'
        }, {
          id: 5,
          name: 'Woot',
          startDate: '2021-05-06 07:00:00',
          endDate: '2021-05-06 10:00:00'
        }, {
          id: 6,
          name: 'Woot',
          startDate: '2021-05-06 15:00:00',
          endDate: '2021-05-06 17:00:00'
        }]
      });
    });
    t.it('should handle the day shift', function (t) {
      var events02 = eventStore.getEvents({
        startDate: DateHelper.parse('2021-05-02'),
        endDate: DateHelper.parse('2021-05-03')
      });
      var events03 = eventStore.getEvents({
        startDate: DateHelper.parse('2021-05-03'),
        endDate: DateHelper.parse('2021-05-04')
      });
      var events04 = eventStore.getEvents({
        startDate: DateHelper.parse('2021-05-04'),
        endDate: DateHelper.parse('2021-05-05')
      });
      var events05 = eventStore.getEvents({
        startDate: DateHelper.parse('2021-05-05'),
        endDate: DateHelper.parse('2021-05-06')
      });
      var events06 = eventStore.getEvents({
        startDate: DateHelper.parse('2021-05-06'),
        endDate: DateHelper.parse('2021-05-07')
      });
      var events07 = eventStore.getEvents({
        startDate: DateHelper.parse('2021-05-07'),
        endDate: DateHelper.parse('2021-05-08')
      });
      t.isDeeply(events02.map(function (e) {
        return e.id;
      }), [], 'Correct events for the 2nd');
      t.isDeeply(events03.map(function (e) {
        return e.id;
      }), [], 'Correct events for the 3rd');
      t.isDeeply(events04.map(function (e) {
        return e.id;
      }), [1, 2], 'Correct events for the 4th');
      t.isDeeply(events05.map(function (e) {
        return e.id;
      }), [2, 3, 4], 'Correct events for the 5th');
      t.isDeeply(events06.map(function (e) {
        return e.id;
      }), [4, 5, 6], 'Correct events for the 6th');
      t.isDeeply(events07.map(function (e) {
        return e.id;
      }), [], 'Correct events for the 7th');
    });
    t.it('should reject an invalid shift', function (t) {
      var dayTime = new DayTime({
        startShift: 16
      }); // SHOULD FAIL w/o THIS: eventStore.indices.use(dayTime);

      t.throwsOk(function () {
        eventStore.getEvents({
          dayTime: dayTime,
          startDate: DateHelper.parse('2021-05-02 16:00:00'),
          endDate: DateHelper.parse('2021-05-03 16:00:00')
        });
      }, 'No day index registered for @16:00 on events', 'Throws for invalid dayTime');
    });
    t.it('should handle the night shift', function (t) {
      var dayTime = new DayTime({
        startShift: 16
      });
      eventStore.registerDayIndex(dayTime);
      var events02 = eventStore.getEvents({
        dayTime: dayTime,
        startDate: DateHelper.parse('2021-05-02 16:00:00'),
        endDate: DateHelper.parse('2021-05-03 16:00:00')
      });
      var events03 = eventStore.getEvents({
        dayTime: dayTime,
        startDate: DateHelper.parse('2021-05-03 16:00:00'),
        endDate: DateHelper.parse('2021-05-04 16:00:00')
      });
      var events04 = eventStore.getEvents({
        dayTime: dayTime,
        startDate: DateHelper.parse('2021-05-04 16:00:00'),
        endDate: DateHelper.parse('2021-05-05 16:00:00')
      });
      var events05 = eventStore.getEvents({
        dayTime: dayTime,
        startDate: DateHelper.parse('2021-05-05 16:00:00'),
        endDate: DateHelper.parse('2021-05-06 16:00:00')
      });
      var events06 = eventStore.getEvents({
        dayTime: dayTime,
        startDate: DateHelper.parse('2021-05-06 16:00:00'),
        endDate: DateHelper.parse('2021-05-07 16:00:00')
      });
      var events07 = eventStore.getEvents({
        dayTime: dayTime,
        startDate: DateHelper.parse('2021-05-07 16:00:00'),
        endDate: DateHelper.parse('2021-05-08 16:00:00')
      });
      t.isDeeply(events02.map(function (e) {
        return e.id;
      }), [], 'Correct events for the 2nd');
      t.isDeeply(events03.map(function (e) {
        return e.id;
      }), [1], 'Correct events for the 3rd');
      t.isDeeply(events04.map(function (e) {
        return e.id;
      }), [1, 2, 3], 'Correct events for the 4th');
      t.isDeeply(events05.map(function (e) {
        return e.id;
      }), [4, 5, 6], 'Correct events for the 5th');
      t.isDeeply(events06.map(function (e) {
        return e.id;
      }), [6], 'Correct events for the 6th');
      t.isDeeply(events07.map(function (e) {
        return e.id;
      }), [], 'Correct events for the 7th');
    });
  });
});