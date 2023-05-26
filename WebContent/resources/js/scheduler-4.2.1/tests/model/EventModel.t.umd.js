function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _get(target, property, receiver) { if (typeof Reflect !== "undefined" && Reflect.get) { _get = Reflect.get; } else { _get = function _get(target, property, receiver) { var base = _superPropBase(target, property); if (!base) return; var desc = Object.getOwnPropertyDescriptor(base, property); if (desc.get) { return desc.get.call(receiver); } return desc.value; }; } return _get(target, property, receiver || target); }

function _superPropBase(object, property) { while (!Object.prototype.hasOwnProperty.call(object, property)) { object = _getPrototypeOf(object); if (object === null) break; } return object; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var resourceStore, eventStore, project;
  t.beforeEach(function () {
    var _resourceStore, _resourceStore$destro, _eventStore, _eventStore$destroy, _project, _project$destroy;

    (_resourceStore = resourceStore) === null || _resourceStore === void 0 ? void 0 : (_resourceStore$destro = _resourceStore.destroy) === null || _resourceStore$destro === void 0 ? void 0 : _resourceStore$destro.call(_resourceStore);
    (_eventStore = eventStore) === null || _eventStore === void 0 ? void 0 : (_eventStore$destroy = _eventStore.destroy) === null || _eventStore$destroy === void 0 ? void 0 : _eventStore$destroy.call(_eventStore);
    (_project = project) === null || _project === void 0 ? void 0 : (_project$destroy = _project.destroy) === null || _project$destroy === void 0 ? void 0 : _project$destroy.call(_project);
    resourceStore = new ResourceStore({
      data: [{
        id: 'c1',
        name: 'Foo'
      }, {
        id: 'c2',
        name: 'Foo'
      }]
    });
    eventStore = new EventStore();
    project = new ProjectModel({
      eventStore: eventStore,
      resourceStore: resourceStore
    });
  });
  t.it('Validation, isPersistable', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var event, _resourceStore$insert, _resourceStore$insert2, newResource;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              event = new EventModel({
                resourceId: 'c1',
                name: 'Mike',
                startDate: '2010-12-09 09:45',
                endDate: '2010-12-09 11:00'
              });
              eventStore.add(event);
              _context.next = 4;
              return eventStore.project.commitAsync();

            case 4:
              t.ok(event.isValid, 'isValid');
              event.startDate = new Date(event.endDate.getTime() + 1);
              _context.next = 8;
              return eventStore.project.commitAsync();

            case 8:
              t.ok(event.isValid, 'isValid, normalized by engine');
              t.ok(event.isPersistable, 'isPersistable true');
              _resourceStore$insert = resourceStore.insert(0, {}), _resourceStore$insert2 = _slicedToArray(_resourceStore$insert, 1), newResource = _resourceStore$insert2[0];
              event.resource = newResource; // Always considered persistable with assignmentstore according to docs

              t.ok(event.isPersistable, 'isPersistable true'); //t.notOk(event.isPersistable, 'isPersistable false');

              t.ok(event.resourceId, newResource.id, 'found phantom resource internal id');
              t.is(event.resource, newResource, 'found phantom resource');

            case 15:
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
  t.it('getters and setters', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var event;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              event = new EventModel({
                resourceId: 'c1',
                name: 'Mike',
                startDate: '2010-12-09 09:45',
                endDate: '2010-12-09 11:00'
              });
              eventStore.add(event);
              _context2.next = 4;
              return eventStore.project.commitAsync();

            case 4:
              event.startDate = null;
              event.endDate = null;
              _context2.next = 8;
              return eventStore.project.commitAsync();

            case 8:
              t.is(event.startDate, null, 'Could set end date to null');
              t.is(event.endDate, null, 'Could set end date to null');
              t.is(event.duration, null, 'Duration also null');
              event.setStartEndDate(new Date(2010, 1, 1), new Date(2010, 1, 2));
              _context2.next = 14;
              return eventStore.project.commitAsync();

            case 14:
              t.is(event.startDate, new Date(2010, 1, 1), 'Could set startDate to 2010, 1, 1');
              t.is(event.endDate, new Date(2010, 1, 2), 'Could set endDate to 2010, 1, 2');
              t.is(event.duration, 1, 'Duration calculated to 1');
              event.setStartEndDate(null, null);
              _context2.next = 20;
              return eventStore.project.commitAsync();

            case 20:
              t.is(event.startDate, null, 'Could set start date to null, setStartEndDate');
              t.is(event.endDate, null, 'Could set end date to null, setStartEndDate');

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
  t.it('Events should support belonging to multiple stores', function (t) {
    var event = new EventModel({
      resourceId: 'c1',
      name: 'Mike',
      startDate: '2010-12-09 09:45',
      endDate: '2010-12-09 11:00'
    }),
        resource = resourceStore.getById('c1');
    new Store({
      modelClass: EventModel,
      data: [event]
    });
    eventStore.add(event);
    t.is(event.resource, resource, 'resource works');
    t.isDeeply(event.resources, [resource], 'resources works');
  });
  t.it('Event setter resourceId can be overridden', function (t) {
    var MyModel = /*#__PURE__*/function (_EventModel) {
      _inherits(MyModel, _EventModel);

      var _super = _createSuper(MyModel);

      function MyModel() {
        _classCallCheck(this, MyModel);

        return _super.apply(this, arguments);
      }

      _createClass(MyModel, null, [{
        key: "fields",
        get: function get() {
          return _get(_getPrototypeOf(MyModel), "fields", this).concat([{
            name: 'resourceId',
            dataSource: 'resource'
          }]);
        }
      }]);

      return MyModel;
    }(EventModel);

    var event = new MyModel({
      resource: 'c1',
      name: 'Mike',
      startDate: '2016-02-12 14:40',
      endDate: '2010-02-12 14:45'
    });
    t.is(event.resourceId, 'c1', 'ResourceId is properly set');
    event.resourceId = 'c2';
    t.is(event.resourceId, 'c2', 'ResourceId is properly set');
  });
  t.it('Setting resourceId = null should yield event.resource === null', function (t) {
    var _eventStore$add = eventStore.add({
      resourceId: 'c1'
    }),
        _eventStore$add2 = _slicedToArray(_eventStore$add, 1),
        event = _eventStore$add2[0];

    t.is(event.resourceId, 'c1', 'ResourceId is properly set');
    event.resourceId = null;
    t.is(event.resource, null, 'resource is properly set');
    t.is(event.resourceId, null, 'resourceId is properly set');
  });
  t.it('should support shift() API without unit and use default durationUnit', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var event;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              event = new EventModel({
                startDate: new Date(2018, 11, 1),
                endDate: new Date(2018, 11, 2)
              });
              eventStore.add(event);
              _context3.next = 4;
              return eventStore.project.commitAsync();

            case 4:
              _context3.next = 6;
              return event.shift(1);

            case 6:
              t.is(event.startDate, new Date(2018, 11, 2));
              t.is(event.endDate, new Date(2018, 11, 3));
              t.is(event.duration, 1);
              _context3.next = 11;
              return event.shift(-1);

            case 11:
              t.is(event.startDate, new Date(2018, 11, 1));
              t.is(event.endDate, new Date(2018, 11, 2));
              t.is(event.duration, 1);

            case 14:
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
  t.it('should support shift() API with unit', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var event;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              event = new EventModel({
                startDate: new Date(2018, 11, 1),
                endDate: new Date(2018, 11, 2),
                durationUnit: 'h'
              });
              eventStore.add(event);
              _context4.next = 4;
              return eventStore.project.commitAsync();

            case 4:
              _context4.next = 6;
              return event.shift(1, 'w');

            case 6:
              t.is(event.startDate, new Date(2018, 11, 8));
              t.is(event.endDate, new Date(2018, 11, 9));
              t.is(event.duration, 24);

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
  t.it('should support split() API', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var event, clone, clone2;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              event = new EventModel({
                startDate: new Date(2018, 11, 1),
                duration: 5,
                durationUnit: 'd'
              });
              eventStore.add(event);
              _context5.next = 4;
              return eventStore.project.commitAsync();

            case 4:
              clone = event.split();
              _context5.next = 7;
              return eventStore.project.commitAsync();

            case 7:
              t.is(event.startDate, new Date(2018, 11, 1));
              t.is(event.duration, 2.5);
              t.is(clone.startDate, new Date(2018, 11, 3, 12));
              t.is(clone.duration, 2.5);
              clone2 = clone.split(0.2);
              _context5.next = 14;
              return eventStore.project.commitAsync();

            case 14:
              t.is(clone.startDate, new Date(2018, 11, 3, 12));
              t.is(clone.duration, 0.5);
              t.is(clone2.startDate, new Date(2018, 11, 4));
              t.is(clone2.duration, 2);

            case 18:
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
  t.it('Should support allDay', function (t) {
    var startDate = new Date(2018, 11, 1, 9),
        endDate = new Date(2018, 11, 1, 10),
        allDayStartDate = new Date(2018, 11, 1),
        allDayEndDate = new Date(2018, 11, 2);
    var event = new EventModel({
      startDate: startDate,
      endDate: endDate
    }); // It starts off as a 9 to 10am event

    t.is(event.startDate.valueOf(), startDate.valueOf(), 'Non allDay startDate is correct');
    t.is(event.endDate.valueOf(), endDate.valueOf(), 'Non allDay endDate is correct');
    event.allDay = true; // Now it should be midnight to midnight

    t.is(event.startDate.valueOf(), allDayStartDate.valueOf(), 'allDay startDate is correct');
    t.is(event.endDate.valueOf(), allDayEndDate.valueOf(), 'allDay endDate is correct');
    event.allDay = false; // And back to a 9am to 10am event

    t.is(event.startDate.valueOf(), startDate.valueOf(), 'Non allDay startDate is correct');
    t.is(event.endDate.valueOf(), endDate.valueOf(), 'Non allDay endDate is correct');
  });
  t.it('Should batch start/end date changes', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var _eventStore$add3, _eventStore$add4, event, startDate, endDate, newStartDate, newEndDate;

      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _eventStore$add3 = eventStore.add({
                id: 1,
                startDate: '2020-04-01',
                duration: 1
              }), _eventStore$add4 = _slicedToArray(_eventStore$add3, 1), event = _eventStore$add4[0];
              _context6.next = 3;
              return t.waitForProjectReady(project);

            case 3:
              startDate = event.startDate, endDate = event.endDate, newStartDate = new Date(2020, 3, 2), newEndDate = new Date(2020, 3, 5);
              event.beginBatch();
              event.startDate = newStartDate;
              event.endDate = newEndDate; // Old assertions, changed after discussion with Maxim
              // t.is(event.startDate, startDate, 'Start date is intact during batch');
              // t.is(event.endDate, endDate, 'End date is intact during batch');

              t.is(event.data.startDate, startDate, 'Start date is intact during batch');
              t.is(event.data.endDate, endDate, 'End date is intact during batch');
              event.endBatch();
              _context6.next = 12;
              return t.waitForProjectReady(project);

            case 12:
              t.is(event.startDate, newStartDate, 'Start date is updated after batch');
              t.is(event.endDate, newEndDate, 'End date is updated after batch');

            case 14:
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
  t.it('Should be able to set/get `resources`', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var _eventStore$add5, _eventStore$add6, event;

      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _eventStore$add5 = eventStore.add({
                id: 1,
                startDate: '2020-04-01',
                duration: 1
              }), _eventStore$add6 = _slicedToArray(_eventStore$add5, 1), event = _eventStore$add6[0];
              _context7.next = 3;
              return t.waitForProjectReady(project);

            case 3:
              event.resources = 'c1';
              t.isDeeply(event.resources, [resourceStore.getById('c1')], 'Should be able to set resources as single resource id');
              event.resources = ['c1', 'c2'];
              t.isDeeply(event.resources.map(function (r) {
                return r.id;
              }), ['c1', 'c2'], 'Should be able to set resources as single resource id');

            case 7:
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
  t.it('Should work with nested dates', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var MyEvent;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              project.destroy();

              MyEvent = /*#__PURE__*/function (_EventModel2) {
                _inherits(MyEvent, _EventModel2);

                var _super2 = _createSuper(MyEvent);

                function MyEvent() {
                  _classCallCheck(this, MyEvent);

                  return _super2.apply(this, arguments);
                }

                _createClass(MyEvent, null, [{
                  key: "fields",
                  get: function get() {
                    return [{
                      name: 'startDate',
                      dataSource: 'nested.start'
                    }];
                  }
                }]);

                return MyEvent;
              }(EventModel);

              project = new ProjectModel({
                eventModelClass: MyEvent,
                eventsData: [{
                  id: 1,
                  nested: {
                    start: '2020-09-29'
                  },
                  duration: 1,
                  durationUnit: 'day'
                }]
              });
              _context8.next = 5;
              return project.commitAsync();

            case 5:
              t.is(project.eventStore.first.startDate, new Date(2020, 8, 29), 'Correct startDate');
              t.is(project.eventStore.first.endDate, new Date(2020, 8, 30), 'Correct endDate');

            case 7:
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
  t.describe('iCal', function (t) {
    t.it('Should provide empty string for unscheduled event', function (t) {
      var span = new EventModel({
        id: 2,
        name: 'My task'
      });
      t.is(span.toICSString(), '', 'Serializing unscheduled event should return empty string');
    });
    t.it('Should be possible to get the timespan serialized to the iCal format', function (t) {
      VersionHelper.setVersion('scheduler', '4.0.0-beta-2');
      var span = new EventModel({
        id: 1,
        name: 'My task',
        startDate: new Date(2019, 2, 8),
        endDate: new Date(2019, 2, 9)
      });
      var startAsUTC = DateHelper.toUTC(span.startDate),
          endAsUTC = DateHelper.toUTC(span.endDate),
          formattedStart = DateHelper.format(startAsUTC, 'YYYYMMDDTHHmmss') + 'Z',
          formattedEnd = DateHelper.format(endAsUTC, 'YYYYMMDDTHHmmss') + 'Z';
      t.is(span.toICSString({
        DTSTAMP: 'foo'
      }), "BEGIN:VCALENDAR\nVERSION:2.0\nCALSCALE:GREGORIAN\nPRODID:-//Bryntum AB//Bryntum Scheduler 4.0.0-beta-2 //EN\nBEGIN:VEVENT\nUID:1@bryntum.com\nCLASS:PUBLIC\nSUMMARY:My task\nDTSTAMP:foo\nDTSTART:".concat(formattedStart, "\nDTEND:").concat(formattedEnd, "\nEND:VEVENT\nEND:VCALENDAR"), 'serialized correctly');
    });
    t.it('Should include recurrence rule', function (t) {
      var span = new EventModel({
        id: 2,
        name: 'My task',
        recurrenceRule: 'WEEKLY',
        startDate: new Date(2019, 2, 8),
        endDate: new Date(2019, 2, 9)
      });
      var startAsUTC = DateHelper.toUTC(span.startDate),
          endAsUTC = DateHelper.toUTC(span.endDate),
          formattedStart = DateHelper.format(startAsUTC, 'YYYYMMDDTHHmmss') + 'Z',
          formattedEnd = DateHelper.format(endAsUTC, 'YYYYMMDDTHHmmss') + 'Z';
      t.is(span.toICSString({
        DTSTAMP: 'foo'
      }), "BEGIN:VCALENDAR\nVERSION:2.0\nCALSCALE:GREGORIAN\nPRODID:-//Bryntum AB//Bryntum Scheduler 4.0.0-beta-2 //EN\nBEGIN:VEVENT\nUID:2@bryntum.com\nCLASS:PUBLIC\nSUMMARY:My task\nDTSTAMP:foo\nDTSTART:".concat(formattedStart, "\nDTEND:").concat(formattedEnd, "\nRRULE:WEEKLY\nEND:VEVENT\nEND:VCALENDAR"), 'serialized correctly');
    });
    t.it('Should use correct date format for all day events', function (t) {
      var span = new EventModel({
        id: 2,
        name: 'My task',
        allDay: true,
        startDate: new Date(2019, 2, 8),
        endDate: new Date(2019, 2, 9)
      });
      var startAsUTC = DateHelper.toUTC(span.startDate),
          endAsUTC = DateHelper.toUTC(span.endDate),
          formattedStart = DateHelper.format(startAsUTC, 'YYYYMMDD'),
          formattedEnd = DateHelper.format(endAsUTC, 'YYYYMMDD');
      t.is(span.toICSString({
        DTSTAMP: 'foo'
      }), "BEGIN:VCALENDAR\nVERSION:2.0\nCALSCALE:GREGORIAN\nPRODID:-//Bryntum AB//Bryntum Scheduler 4.0.0-beta-2 //EN\nBEGIN:VEVENT\nUID:2@bryntum.com\nCLASS:PUBLIC\nSUMMARY:My task\nDTSTAMP:foo\nDTSTART;VALUE=DATE:".concat(formattedStart, "\nDTEND;VALUE=DATE:").concat(formattedEnd, "\nEND:VEVENT\nEND:VCALENDAR"), 'serialized correctly');
    });
    t.it('Should trigger download', function (t) {
      if (BrowserHelper.isIE11) return;
      var span = new EventModel({
        id: 2,
        name: 'My task',
        allDay: true,
        startDate: new Date(2019, 2, 8),
        endDate: new Date(2019, 2, 9)
      });
      document.documentElement.addEventListener('click', function (event) {
        t.is(event.target.download, 'My task.ics', 'If no name exists, default to Event');
        t.like(event.target.href, new RegExp("blob:".concat(location.protocol)), '`href` attr set correctly');
        event.preventDefault();
      }, {
        once: true
      });
      t.firesOnce(document.documentElement, 'click');
      span.exportToICS();
    });
    t.it('Should use some default if no name exists', function (t) {
      if (BrowserHelper.isIE11) return;
      var span = new EventModel({
        id: 2,
        startDate: new Date(2019, 2, 8),
        endDate: new Date(2019, 2, 9)
      });
      document.documentElement.addEventListener('click', function (event) {
        t.is(event.target.download, 'Event.ics', '`download` attr set correctly');
        t.like(event.target.href, new RegExp("blob:".concat(location.protocol)), '`href` attr set correctly');
        event.preventDefault();
      }, {
        once: true
      });
      t.firesOnce(document.documentElement, 'click');
      span.exportToICS();
    });
  });
  t.it('Should not persist buckets', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var toPersist;
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              eventStore.add({
                resourceId: 'c1',
                name: 'Mike',
                startDate: '2010-12-09 09:45',
                endDate: '2010-12-09 11:00'
              });
              _context9.next = 3;
              return project.commitAsync();

            case 3:
              toPersist = eventStore.first.persistableData;
              t.notOk('resources' in toPersist, 'Resources not persisted');
              t.notOk('assigned' in toPersist, 'Assignments not persisted');

            case 6:
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
});