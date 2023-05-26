function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

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
  t.it('Id change should update assignment', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var project;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              project = new ProjectModel({
                assignmentsData: [{
                  id: 1,
                  eventId: 1,
                  resourceId: 'phantomResource'
                }],
                resourcesData: [{
                  id: 'phantomResource'
                }],
                eventsData: [{
                  id: 1
                }]
              });
              _context.next = 3;
              return project.commitAsync();

            case 3:
              // Happens for example as the result of a commit to backend
              project.resourceStore.first.id = 1;
              _context.next = 6;
              return project.commitAsync();

            case 6:
              t.is(project.assignmentStore.first.resourceId, project.resourceStore.first.id);

            case 7:
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
  t.it('Sanity checks + phantom record handling', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var eventStore, resourceStore, project, res, ev, phantomResId, handle;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  name: 'Linda',
                  startDate: '2010-12-09',
                  endDate: '2010-12-13'
                }]
              });
              resourceStore = new ResourceStore({
                createUrl: 'lib/create_resource.json'
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: resourceStore
              });
              _context3.next = 5;
              return project.commitAsync();

            case 5:
              res = new resourceStore.modelClass();
              resourceStore.add(res);
              t.is(eventStore.getEventsForResource(res).length, 0, 'Should not find any events for a new resource');
              ev = eventStore.first;
              ev.resource = res;
              t.is(ev.resource, res, 'Found phantom resource');
              t.is(res.events[0], ev, 'Found event by resource');
              phantomResId = ev.resourceId;
              handle = t.beginAsync();
              resourceStore.on('commitadded', /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        _context2.next = 2;
                        return project.commitAsync();

                      case 2:
                        t.isnt(ev.resourceId, phantomResId, 'Found phantom resource');
                        t.is(ev.resource, res, 'Found real resource'); // Make sure we tolerate sloppy input with mixed types, ResourceId as string '1' and the Id of a Resource as int 1.

                        ev.resourceId = 1;
                        res.set('id', 1);
                        t.is(eventStore.getEventsForResource(res)[0], ev, 'Should be able to use strings and int mixed, == check instead of ===');
                        t.endAsync(handle);

                      case 8:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              })), null, {
                delay: 1
              });
              resourceStore.commit();

            case 16:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('ResourceTreeStore init', function (t) {
    new ResourceStore({
      tree: true,
      modelClass: /*#__PURE__*/function (_ResourceModel) {
        _inherits(Mod2, _ResourceModel);

        var _super = _createSuper(Mod2);

        function Mod2() {
          _classCallCheck(this, Mod2);

          return _super.apply(this, arguments);
        }

        return Mod2;
      }(ResourceModel)
    });
    t.throwsOk(function () {
      new ResourceStore({
        tree: true,
        modelClass: /*#__PURE__*/function (_Model) {
          _inherits(Mod, _Model);

          var _super2 = _createSuper(Mod);

          function Mod() {
            _classCallCheck(this, Mod);

            return _super2.apply(this, arguments);
          }

          return Mod;
        }(Model)
      });
    }, 'Model for ResourceStore must subclass ResourceModel');
  });
  t.it('Basic instantiation', function (t) {
    var store = new ResourceStore({
      data: [{}]
    });
    t.isInstanceOf(store.first, ResourceModel, 'Should use ResourceModel');
    t.throwsOk(function () {
      new ResourceStore({
        modelClass: /*#__PURE__*/function (_Model2) {
          _inherits(Mod4, _Model2);

          var _super3 = _createSuper(Mod4);

          function Mod4() {
            _classCallCheck(this, Mod4);

            return _super3.apply(this, arguments);
          }

          return Mod4;
        }(Model)
      });
    }, 'Model for ResourceStore must subclass ResourceModel');
  });
  t.it('Assignments should be cleared upon removeAll(true)', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var eventStore, resourceStore, project, resource;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 1
                }]
              });
              resourceStore = new ResourceStore({
                data: [{
                  id: 1,
                  name: 'Linda'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: resourceStore
              });
              _context4.next = 5;
              return project.commitAsync();

            case 5:
              resource = resourceStore.first;
              t.is(resource.events.length, 1, 'Event found');
              eventStore.removeAll(true);
              t.is(resource.events.length, 0, 'Event gone');

            case 9:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x3) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Removing all resources should unassign all events', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var eventStore, resourceStore, project;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 1
                }, {
                  id: 2,
                  resourceId: 1
                }, {
                  id: 3,
                  resourceId: 2
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
              _context5.next = 5;
              return project.commitAsync();

            case 5:
              resourceStore.removeAll();
              t.ok(eventStore.records.every(function (eventRecord) {
                return !eventRecord.resourceId;
              }), 'All events unassigned');

            case 7:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x4) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Data should be ready after addAsync()', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var project, _yield$project$resour, _yield$project$resour2, resource;

      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              project = new ProjectModel({
                assignmentsData: [{
                  id: 1,
                  eventId: 1,
                  resourceId: 1
                }, {
                  id: 2,
                  eventId: 2,
                  resourceId: 1
                }],
                resourcesData: [],
                eventsData: [{
                  id: 1
                }, {
                  id: 2
                }]
              });
              _context6.next = 3;
              return project.resourceStore.addAsync({
                id: 1
              });

            case 3:
              _yield$project$resour = _context6.sent;
              _yield$project$resour2 = _slicedToArray(_yield$project$resour, 1);
              resource = _yield$project$resour2[0];
              t.isDeeply(resource.events, project.eventStore.records, 'Calculations performed');

            case 7:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x5) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Data should be ready after loadDataAsync()', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var project;
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              project = new ProjectModel({
                assignmentsData: [{
                  id: 1,
                  eventId: 1,
                  resourceId: 1
                }, {
                  id: 2,
                  eventId: 2,
                  resourceId: 1
                }],
                resourcesData: [],
                eventsData: [{
                  id: 1
                }, {
                  id: 2
                }]
              });
              _context7.next = 3;
              return project.resourceStore.loadDataAsync([{
                id: 1
              }]);

            case 3:
              t.isDeeply(project.resourceStore.first.events, project.eventStore.records, 'Calculations performed');

            case 4:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x6) {
      return _ref7.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2428

  t.it('Resources in tree format should be re-assigned properly after reload', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var scheduler, event, resource;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              t.mockUrl('load1', {
                responseText: JSON.stringify({
                  success: true,
                  resources: {
                    rows: [{
                      id: '1',
                      name: 'resource1'
                    }, {
                      id: '2',
                      name: 'resource2',
                      children: [{
                        id: '53',
                        name: 'resource3'
                      }, {
                        id: '54',
                        name: 'resource4'
                      }],
                      expanded: true
                    }]
                  },
                  events: {
                    rows: [{
                      id: '420',
                      resourceId: '1',
                      name: '168.00',
                      startDate: '2011-01-04',
                      endDate: '2011-01-05'
                    }]
                  }
                })
              });
              t.mockUrl('load2', {
                responseText: JSON.stringify({
                  success: true,
                  resources: {
                    rows: [{
                      id: '1',
                      name: 'resource1'
                    }, {
                      id: '2',
                      name: 'resource2',
                      children: [{
                        id: '53',
                        name: 'resource3'
                      }, {
                        id: '54',
                        name: 'resource4'
                      }],
                      expanded: true
                    }]
                  },
                  events: {
                    rows: []
                  }
                })
              });
              _context8.next = 4;
              return t.getSchedulerAsync({
                crudManager: {
                  transport: {
                    load: {
                      url: 'load1'
                    }
                  }
                }
              });

            case 4:
              scheduler = _context8.sent;
              _context8.next = 7;
              return scheduler.crudManager.load();

            case 7:
              event = scheduler.eventStore.first, resource = scheduler.resourceStore.getById(event.resource.id);
              t.is(event.resource, resource, 'The resource in the event and in the resourceStore are same');
              scheduler.crudManager.transport.load.url = 'load2';
              _context8.next = 12;
              return scheduler.crudManager.load();

            case 12:
              t.is(scheduler.eventStore.records.length, 0, 'No events available after data load');
              scheduler.crudManager.transport.load.url = 'load1';
              _context8.next = 16;
              return scheduler.crudManager.load();

            case 16:
              t.is(scheduler.eventStore.records.length, 1, 'Event is in the store again after data load');
              event = scheduler.eventStore.records[0];
              resource = scheduler.resourceStore.getById(event.resource.id);
              t.is(event.resource, resource, 'The resource in the event and in the resourceStore are same after data reload');
              t.selectorExists(scheduler.unreleasedEventSelector, 'Event rendered');

            case 21:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x7) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Resource store should load tree correctly', function (t) {
    var resourceStore = new ResourceStore({
      tree: true
    });
    resourceStore.rootNode.appendChild([{
      id: 1,
      name: 'Parent 1',
      children: true
    }, {
      id: 2,
      name: 'Parent 2',
      expanded: true,
      children: [{
        id: 3,
        name: 'Child 1'
      }]
    }]);
    t.is(resourceStore.getCount(), 3, 'All 3 nodes loaded');
  });
});