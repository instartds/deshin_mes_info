function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && !scheduler.isDestroyed && scheduler.destroy();
    document.body.innerHTML = '';
  }); // Ported from 2101_view_filter.t.js

  t.it('View should not render filtered events', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync();

            case 2:
              scheduler = _context.sent;
              scheduler.eventStore.filter({
                filterBy: function filterBy() {
                  return false;
                }
              });
              t.is(scheduler.eventStore.count, 0, 'All events are filtered from store');
              t.selectorNotExists(scheduler.unreleasedEventSelector, 'Rendered events are filtered');
              scheduler.eventStore.clearFilters();
              t.selectorExists(scheduler.unreleasedEventSelector, 'Events are no longer filtered');

            case 8:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }()); // Ported from 2101_view_filter.t.js

  t.it('View should not render filtered events (multiassignment)', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var resourceStore;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              resourceStore = new ResourceStore({
                data: [{
                  id: 'r1',
                  name: 'Albert'
                }]
              });
              _context2.next = 3;
              return t.getSchedulerAsync({
                resourceStore: resourceStore,
                assignmentStore: new AssignmentStore({
                  data: [{
                    eventId: 1,
                    resourceId: 'r1'
                  }]
                }),
                eventStore: t.getEventStore({
                  data: [{
                    id: 1,
                    startDate: new Date(2011, 0, 4),
                    endDate: new Date(2011, 0, 5)
                  }]
                })
              });

            case 3:
              scheduler = _context2.sent;
              scheduler.assignmentStore.filter({
                filterBy: function filterBy() {
                  return false;
                }
              });
              t.selectorNotExists(scheduler.unreleasedEventSelector, 'Rendered events are filtered');
              scheduler.assignmentStore.clearFilters();
              t.selectorExists(scheduler.unreleasedEventSelector, 'Events are no longer filtered');

            case 8:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }()); // Ported from 2101_view_filter.t.js

  t.it('Filter out events while editing', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var scheduler, resourceStore, resource, events;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getSchedulerAsync({
                eventStore: t.getEventStore({
                  reapplyFilterOnUpdate: true,
                  data: function () {
                    var events = [];

                    for (var i = 1; i <= 6; i++) {
                      events.push({
                        id: i,
                        resourceId: 'r2',
                        cls: 'green',
                        name: 'Assignment ' + i,
                        startDate: new Date(2011, 0, 3 + i),
                        endDate: new Date(2011, 0, 5 + i)
                      });
                    }

                    return events;
                  }()
                })
              });

            case 2:
              scheduler = _context3.sent;
              scheduler.eventStore.filter({
                filterBy: function filterBy(event) {
                  return !event.cls.isEqual('red');
                }
              });
              resourceStore = scheduler.resourceStore, resource = resourceStore.getById('r2'), events = resource.events.slice();
              t.is(events.length, 6, 'Event has 6 items');
              events.forEach(function (event) {
                event.cls = 'red';
              });
              t.selectorNotExists(scheduler.unreleasedEventSelector, 'Rendered events are filtered');
              scheduler.destroy();

            case 9:
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
  t.it('View should derender an event moved to a filtered out resource', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var dan;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 5),
                resources: [{
                  id: 1,
                  name: 'Mike'
                }, {
                  id: 2,
                  name: 'Dan'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2011, 0, 3),
                  duration: 1
                }]
              });

            case 2:
              scheduler = _context4.sent;
              dan = scheduler.resourceStore.getAt(1);
              scheduler.resourceStore.filter({
                filterBy: function filterBy(resource) {
                  return resource.name === 'Mike';
                }
              });
              scheduler.eventStore.first.assign(dan);
              t.chain({
                waitForSelectorNotFound: scheduler.unreleasedEventSelector
              });

            case 7:
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
});