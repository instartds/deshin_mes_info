function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, resourceStore, eventStore, resources; // async beforeEach doesn't work in umd

  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  }); // #8923 - Child nodes not shown for newly added resource in a tree

  t.it('Append nodes and collapse/expand after works fine', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var i, resource;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              resources = [];

              for (i = 0; i < 100; i++) {
                resources.push({
                  id: i,
                  name: "r".concat(i)
                });
              }

              _context.next = 4;
              return t.getSchedulerAsync({
                startDate: new Date(2018, 8, 20),
                endDate: new Date(2018, 9, 30),
                viewPreset: 'weekAndMonth',
                resourceStore: new ResourceStore({
                  tree: true,
                  data: resources
                }),
                events: [],
                features: {
                  tree: true
                },
                columns: [{
                  type: 'tree',
                  field: 'name'
                }]
              });

            case 4:
              scheduler = _context.sent;
              resourceStore = scheduler.resourceStore;
              eventStore = scheduler.eventStore;
              t.chain({
                waitFor: function waitFor() {
                  return scheduler;
                },
                desc: 'Scheduler is here'
              }, function (next) {
                resource = resourceStore.rootNode.appendChild({
                  id: 2000,
                  name: 'parent',
                  expanded: true,
                  children: [{
                    id: 2001,
                    name: 'child'
                  }]
                });
                eventStore.add({
                  startDate: new Date(2018, 8, 21),
                  endDate: new Date(2018, 8, 22),
                  name: 'foo',
                  resourceId: 2000
                });
                next();
              }, {
                waitForEvent: [scheduler, 'scroll'],
                trigger: function trigger() {
                  return scheduler.scrollResourceIntoView(resource.firstChild);
                }
              }, {
                waitForSelector: '.b-grid-cell:contains(child)',
                desc: 'Child is visible initially'
              }, {
                diag: 'Collapsing...'
              }, function () {
                return scheduler.features.tree.collapse(resource);
              }, {
                waitForSelectorNotFound: '.b-grid-cell:contains(child)',
                desc: 'Child got hidden'
              }, {
                diag: 'Expanding...'
              }, function () {
                return scheduler.features.tree.expand(resource);
              }, function (next) {
                t.ok(scheduler.getRowById(2001), 'Sub node is here');
                next();
              }, {
                waitForSelector: '.b-grid-cell:contains(child)',
                desc: 'Child got visible'
              });

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
  }()); // #635 Events disappear when toggling other node

  t.it('Events are rendered correctly after collapse/expand', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                resources: [{
                  id: 1,
                  name: 'School',
                  expanded: true,
                  children: [{
                    id: 11,
                    name: 'Floor 11',
                    expanded: true,
                    children: [{
                      id: 111,
                      name: 'Room 11-1'
                    }, {
                      id: 112,
                      name: 'Room 11-2'
                    }]
                  }, {
                    id: 12,
                    name: 'Floor 12',
                    expanded: true,
                    children: [{
                      id: 121,
                      name: 'Room 12-1'
                    }, {
                      id: 122,
                      name: 'Room 12-2'
                    }]
                  }]
                }],
                events: [{
                  id: 1,
                  resourceId: 111,
                  name: 'Moving out',
                  startDate: '2020-04-27',
                  duration: 1
                }, {
                  id: 2,
                  resourceId: 112,
                  name: 'Moving in',
                  startDate: '2020-04-29',
                  duration: 1
                }, {
                  id: 3,
                  resourceId: 121,
                  name: 'Moving in',
                  startDate: '2020-04-28',
                  duration: 1
                }, {
                  id: 4,
                  resourceId: 122,
                  name: 'Moving out',
                  startDate: '2020-04-30',
                  duration: 1
                }],
                startDate: '2020-04-27',
                endDate: '2020-04-30',
                features: {
                  tree: true
                },
                columns: [{
                  type: 'tree',
                  field: 'name',
                  text: 'Name',
                  width: 200
                }]
              });
              _context2.next = 3;
              return t.waitForProjectReady(scheduler);

            case 3:
              _context2.next = 5;
              return scheduler.collapse(11);

            case 5:
              _context2.next = 7;
              return scheduler.collapse(12);

            case 7:
              _context2.next = 9;
              return scheduler.expand(11);

            case 9:
              _context2.next = 11;
              return t.waitForSelector(scheduler.unreleasedEventSelector);

            case 11:
              _context2.next = 13;
              return scheduler.expand(12);

            case 13:
              _context2.next = 15;
              return t.waitForSelector(scheduler.unreleasedEventSelector);

            case 15:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 4, '4 events rendered');

            case 16:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1227

  t.it('Should be possible to undo event removing when tree feature is used and assignment is set using resourceId field', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var stm;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                features: {
                  tree: true,
                  dependencies: true
                },
                columns: [{
                  type: 'tree',
                  text: 'Name',
                  field: 'name',
                  width: 200
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  name: 'Test',
                  startDate: '2011-01-04',
                  endDate: '2011-01-05'
                }],
                resources: [{
                  id: 1,
                  name: 'Foo',
                  leaf: true
                }],
                enableEventAnimations: false
              });

            case 2:
              scheduler = _context4.sent;
              stm = scheduler.project.getStm();
              stm.enable();
              stm.autoRecord = true;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        scheduler.eventStore.first.remove();

                      case 1:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3);
              })), {
                waitFor: function waitFor() {
                  return stm.canUndo;
                }
              }, function () {
                stm.undo();
                t.notOk(scheduler.eventStore.changes);
              });

            case 7:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should be possible to undo event removing when tree feature is used and assignment is set as a record in AssignmentStore', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var stm;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getSchedulerAsync({
                features: {
                  tree: true,
                  dependencies: true
                },
                columns: [{
                  type: 'tree',
                  text: 'Name',
                  field: 'name',
                  width: 200
                }],
                events: [{
                  id: 1,
                  name: 'Test',
                  startDate: '2011-01-04',
                  endDate: '2011-01-05'
                }],
                assignments: [{
                  id: 1,
                  resourceId: 1,
                  eventId: 1
                }],
                resources: [{
                  id: 1,
                  name: 'Foo',
                  leaf: true
                }],
                enableEventAnimations: false
              });

            case 2:
              scheduler = _context6.sent;
              stm = scheduler.project.getStm();
              stm.enable();
              stm.autoRecord = true;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
                return regeneratorRuntime.wrap(function _callee5$(_context5) {
                  while (1) {
                    switch (_context5.prev = _context5.next) {
                      case 0:
                        scheduler.eventStore.first.remove();

                      case 1:
                      case "end":
                        return _context5.stop();
                    }
                  }
                }, _callee5);
              })), {
                waitFor: function waitFor() {
                  return stm.canUndo;
                }
              }, function () {
                stm.undo();
                t.notOk(scheduler.eventStore.changes);
              });

            case 7:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x4) {
      return _ref5.apply(this, arguments);
    };
  }());
});