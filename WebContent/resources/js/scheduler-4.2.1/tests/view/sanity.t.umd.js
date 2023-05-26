function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && !scheduler.isDestroyed && scheduler.destroy();
  }); // Going to replace store handling with Project anyway

  t.xit('Scheduler should not leave listeners on stores', function (t) {
    var assignmentStore = new AssignmentStore(),
        eventStore = t.getEventStore({
      assignmentStore: assignmentStore
    }, 2),
        resourceStore = t.getResourceStore2(null, 2),
        dependencyStore = t.getDependencyStore(null, 2);
    t.snapShotListeners(assignmentStore, 'assignments');
    t.snapShotListeners(eventStore, 'events');
    t.snapShotListeners(resourceStore, 'resources');
    t.snapShotListeners(dependencyStore, 'dependencies');
    scheduler = t.getScheduler({
      appendTo: document.body,
      destroyStores: false,
      assignmentStore: assignmentStore,
      eventStore: eventStore,
      resourceStore: resourceStore,
      dependencyStore: dependencyStore,
      features: {
        dependencies: true,
        eventMenu: true,
        eventEdit: true,
        eventFilter: true,
        groupSummary: {
          summaries: [{
            label: 'Full time',
            renderer: function renderer(_ref) {
              var events = _ref.events;
              // Only count events for resources that are "Full time"
              return events.filter(function (event) {
                return event.resource.type === 'Full time';
              }).length;
            }
          }]
        },
        timeAxisHeaderMenu: true,
        labels: true,
        nonWorkingTime: true,
        summary: {
          renderer: function renderer(_ref2) {
            var events = _ref2.events;
            return events.length || '';
          }
        },
        timeRanges: true
      }
    });
    scheduler.destroy(); // When scheduler is configured with stores it links them together. It is not clear what to do with such links
    // after scheduler is destroyed. When stores are used in another scheduler, those links will be changed anyway
    // So we are ignoring listeners with stores as a scope

    t.verifyListeners(assignmentStore, 'assignments', [dependencyStore, resourceStore, eventStore]);
    t.verifyListeners(eventStore, 'events', [dependencyStore, resourceStore, assignmentStore]);
    t.verifyListeners(resourceStore, 'resources', [dependencyStore, eventStore, assignmentStore]);
    t.verifyListeners(dependencyStore, 'dependencies', [eventStore, resourceStore, assignmentStore]);
  });
  t.it('Vertical scheduler loaded using CrudManager should start with no error on touch devices', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var wasTouchDevice;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              wasTouchDevice = BrowserHelper.isTouchDevice; // While we do not run tests on touch devices, fake it.

              BrowserHelper.isTouchDevice = true;
              _context.next = 4;
              return t.getSchedulerAsync({
                mode: 'vertical',
                crudManager: {
                  autoLoad: true,
                  transport: {
                    load: {
                      url: 'view/orientation/vertical-sanity-crud-test.json'
                    }
                  }
                },
                startDate: new Date(2019, 0, 1, 6),
                endDate: new Date(2019, 0, 1, 18),
                viewPreset: 'hourAndDay',
                barMargin: 5,
                eventStyle: 'colored',
                tickSize: 80,
                events: null,
                resources: null
              });

            case 4:
              scheduler = _context.sent;
              t.pass('Scheduler has started with no errors');
              BrowserHelper.isTouchDevice = wasTouchDevice;

            case 7:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Initial scheduler config is intact', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var initialConfig;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              initialConfig = {
                appendTo: document.body,
                startDate: new Date(2025, 11, 1, 8),
                endDate: new Date(2025, 11, 1, 18),
                flex: 1,
                crudManager: {
                  autoLoad: true,
                  transport: {
                    load: {
                      url: 'view/orientation/vertical-sanity-crud-test.json'
                    }
                  }
                },
                columns: [{
                  field: 'name',
                  text: 'Name',
                  width: 200
                }]
              };
              scheduler = new Scheduler(ObjectHelper.clone(initialConfig));
              _context2.next = 4;
              return t.waitForProjectReady(scheduler);

            case 4:
              delete scheduler.initialConfig.subGridConfigs;
              t.isDeeply(scheduler.initialConfig, initialConfig, 'initialConfig is ok');

            case 6:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should be able to adopt element', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              scheduler = new Scheduler({
                adopt: document.body,
                startDate: new Date(),
                columns: [{
                  field: 'name',
                  text: 'Name'
                }],
                resources: [{
                  id: 1,
                  name: 'R1'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(),
                  duration: 2
                }]
              });
              _context3.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.selectorExists('.b-grid-row', 'Row rendered');
              t.selectorExists('.b-sch-event', 'Event rendered');

            case 5:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref5.apply(this, arguments);
    };
  }());
});