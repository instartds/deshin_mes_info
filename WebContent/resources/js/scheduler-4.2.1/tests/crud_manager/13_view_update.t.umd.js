function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    var _scheduler, _scheduler$destroy;

    (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : (_scheduler$destroy = _scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(_scheduler);
  }); // https://github.com/bryntum/support/issues/385

  t.it('Should cleanup extra event elements correctly after resource is saved', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var _scheduler$resourceSt, _scheduler$resourceSt2, newResource, _scheduler$eventStore, _scheduler$eventStore2, event1, event2;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  events: {
                    rows: []
                  },
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'Default'
                    }]
                  }
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                width: 500,
                height: 300,
                startDate: new Date(2020, 2, 1),
                endDate: new Date(2020, 2, 8),
                enableEventAnimations: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 150
                }],
                crudManager: {
                  transport: {
                    load: {
                      url: 'load'
                    },
                    sync: {
                      url: 'sync'
                    }
                  },
                  autoLoad: false,
                  autoSync: false
                }
              });
              _context.next = 4;
              return scheduler.crudManager.load();

            case 4:
              _scheduler$resourceSt = scheduler.resourceStore.add({
                name: 'New resource'
              }), _scheduler$resourceSt2 = _slicedToArray(_scheduler$resourceSt, 1), newResource = _scheduler$resourceSt2[0], _scheduler$eventStore = scheduler.eventStore.add([{
                name: 'Event 1',
                resourceId: 1,
                startDate: '2020-03-01',
                endDate: '2020-03-03'
              }, {
                name: 'Event 2',
                resourceId: newResource.id,
                startDate: '2020-03-01',
                endDate: '2020-03-03'
              }]), _scheduler$eventStore2 = _slicedToArray(_scheduler$eventStore, 2), event1 = _scheduler$eventStore2[0], event2 = _scheduler$eventStore2[1];
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  events: {
                    rows: [{
                      $PhantomId: event1.id,
                      id: 1
                    }, {
                      $PhantomId: event2.id,
                      id: 2,
                      resourceId: 2
                    }]
                  },
                  resources: {
                    rows: [{
                      $PhantomId: newResource.id,
                      id: 2
                    }]
                  }
                })
              }); // Wait for first render to avoid stepping into rendering logic during debug

              _context.next = 8;
              return t.waitForSelector('.b-sch-event-wrap[data-resource-id="1"]');

            case 8:
              _context.next = 10;
              return scheduler.crudManager.sync();

            case 10:
              _context.next = 12;
              return t.waitForSelector('.b-sch-event-wrap[data-event-id="1"]');

            case 12:
              _context.next = 14;
              return t.waitForSelector('.b-sch-event-wrap[data-event-id="2"]');

            case 14:
              t.selectorCountIs('.b-sch-event', 2, 'No ghost event elements');
              t.is(scheduler.getElementFromEventRecord(event1), document.querySelector('[data-event-id="1"] .b-sch-event'), 'Event 1 element is resolved correctly');
              t.is(scheduler.getElementFromEventRecord(event2), document.querySelector('[data-event-id="2"] .b-sch-event'), 'Event 2 element is resolved correctly');

            case 17:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2577

  t.it('Should update event element dataset with IDs returned from server: horizontal mode', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var _scheduler$eventStore3, _scheduler$eventStore4, eventRecord, assignmentId, eventId;

      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  events: {
                    rows: []
                  },
                  assignments: {
                    rows: []
                  },
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'Default'
                    }]
                  }
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                width: 500,
                height: 300,
                startDate: new Date(2020, 2, 1),
                endDate: new Date(2020, 2, 8),
                enableEventAnimations: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 150
                }],
                crudManager: {
                  transport: {
                    load: {
                      url: 'load'
                    },
                    sync: {
                      url: 'sync'
                    }
                  },
                  autoLoad: false,
                  autoSync: false
                }
              });
              _context2.next = 4;
              return scheduler.crudManager.load();

            case 4:
              _scheduler$eventStore3 = scheduler.eventStore.add([{
                name: 'Foo',
                resourceId: 1,
                startDate: '2020-03-01',
                endDate: '2020-03-03'
              }]), _scheduler$eventStore4 = _slicedToArray(_scheduler$eventStore3, 1), eventRecord = _scheduler$eventStore4[0], assignmentId = eventRecord.assignments[0].id, eventId = eventRecord.id;
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  events: {
                    rows: [{
                      $PhantomId: eventId,
                      id: 10
                    }]
                  },
                  assignments: {
                    rows: [{
                      $PhantomId: assignmentId,
                      id: 20
                    }]
                  }
                })
              }); // Wait for first render to avoid stepping into rendering logic during debug

              _context2.next = 8;
              return t.waitForSelector(".b-sch-event-wrap[data-resource-id=\"1\"][data-event-id=\"".concat(eventId, "\"][data-assignment-id=\"").concat(assignmentId, "\"]"));

            case 8:
              _context2.next = 10;
              return scheduler.crudManager.sync();

            case 10:
              t.is(scheduler.resourceStore.last.id, 1);
              t.is(scheduler.eventStore.last.id, 10);
              t.is(scheduler.assignmentStore.last.id, 20);
              _context2.next = 15;
              return t.waitForSelector('.b-sch-event-wrap[data-resource-id="1"][data-event-id="10"][data-assignment-id="20"]');

            case 15:
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
  t.it('Should update event element dataset with IDs returned from server: vertical mode', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var _scheduler$eventStore5, _scheduler$eventStore6, eventRecord, assignmentId, eventId;

      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  events: {
                    rows: []
                  },
                  assignments: {
                    rows: []
                  },
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'Default'
                    }]
                  }
                })
              });
              scheduler = new Scheduler({
                mode: 'vertical',
                appendTo: document.body,
                width: 500,
                height: 300,
                startDate: new Date(2020, 2, 1),
                endDate: new Date(2020, 2, 8),
                enableEventAnimations: false,
                crudManager: {
                  transport: {
                    load: {
                      url: 'load'
                    },
                    sync: {
                      url: 'sync'
                    }
                  },
                  autoLoad: false,
                  autoSync: false
                }
              });
              _context3.next = 4;
              return scheduler.crudManager.load();

            case 4:
              _scheduler$eventStore5 = scheduler.eventStore.add([{
                name: 'Foo',
                resourceId: 1,
                startDate: '2020-03-01',
                endDate: '2020-03-03'
              }]), _scheduler$eventStore6 = _slicedToArray(_scheduler$eventStore5, 1), eventRecord = _scheduler$eventStore6[0], assignmentId = eventRecord.assignments[0].id, eventId = eventRecord.id;
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  events: {
                    rows: [{
                      $PhantomId: eventId,
                      id: 10
                    }]
                  },
                  assignments: {
                    rows: [{
                      $PhantomId: assignmentId,
                      id: 20
                    }]
                  }
                })
              }); // Wait for first render to avoid stepping into rendering logic during debug

              _context3.next = 8;
              return t.waitForSelector(".b-sch-event-wrap[data-resource-id=\"1\"][data-event-id=\"".concat(eventId, "\"][data-assignment-id=\"").concat(assignmentId, "\"]"));

            case 8:
              _context3.next = 10;
              return scheduler.crudManager.sync();

            case 10:
              t.is(scheduler.resourceStore.last.id, 1);
              t.is(scheduler.eventStore.last.id, 10);
              t.is(scheduler.assignmentStore.last.id, 20);
              _context3.next = 15;
              return t.waitForSelector('.b-sch-event-wrap[data-resource-id="1"][data-event-id="10"][data-assignment-id="20"]');

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
});