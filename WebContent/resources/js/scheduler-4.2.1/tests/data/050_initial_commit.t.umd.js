function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  // Asserts initial commit handling by the project (https://github.com/bryntum/support/issues/1346)
  t.it('CrudManager loading', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              t.mockUrl('cm-load', {
                delay: 1,
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  events: {
                    rows: [{
                      id: 'e1',
                      name: 'Buldoze 1',
                      startDate: new Date(2019, 0, 1),
                      duration: 10,
                      durationUnit: 'd'
                    }]
                  }
                })
              });
              t.mockUrl('cm-sync', {
                delay: 1,
                responseText: '{ "success" : true }'
              });
              t.it('silenceInitialCommit=true (default) silently accepts the data changes caused by propagation', /*#__PURE__*/function () {
                var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
                  var async, project, crudManager;
                  return regeneratorRuntime.wrap(function _callee$(_context) {
                    while (1) {
                      switch (_context.prev = _context.next) {
                        case 0:
                          async = t.beginAsync(), project = new ProjectModel(), crudManager = new CrudManager({
                            project: project,
                            transport: {
                              load: {
                                url: 'cm-load'
                              },
                              sync: {
                                url: 'cm-sync'
                              }
                            },
                            autoLoad: true,
                            autoSync: true,
                            listeners: {
                              load: function load() {
                                t.endAsync(async);
                                t.notOk(crudManager.crudStoreHasChanges(), 'no changes after loading');
                              }
                            }
                          });
                          t.notOk(crudManager.crudStoreHasChanges(), 'no changes before loading');
                          t.wontFire(crudManager, 'sync', 'no sync happened');
                          _context.next = 5;
                          return t.waitFor(100);

                        case 5:
                        case "end":
                          return _context.stop();
                      }
                    }
                  }, _callee);
                }));

                return function (_x2) {
                  return _ref2.apply(this, arguments);
                };
              }());
              t.it('silenceInitialCommit=false should trigger autoSync and leave the data dirty', /*#__PURE__*/function () {
                var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
                  var async, project, crudManager;
                  return regeneratorRuntime.wrap(function _callee2$(_context2) {
                    while (1) {
                      switch (_context2.prev = _context2.next) {
                        case 0:
                          async = t.beginAsync(), project = new ProjectModel({
                            silenceInitialCommit: false
                          }), crudManager = new CrudManager({
                            project: project,
                            transport: {
                              load: {
                                url: 'cm-load'
                              },
                              sync: {
                                url: 'cm-sync'
                              }
                            },
                            autoLoad: true,
                            autoSync: true,
                            listeners: {
                              load: function load() {
                                return t.ok(crudManager.crudStoreHasChanges(), 'there are changes after loading & propagating');
                              },
                              sync: function sync() {
                                t.endAsync(async);
                                t.pass('sync is triggered');
                              }
                            }
                          });
                          t.notOk(crudManager.crudStoreHasChanges(), 'no changes before loading');

                        case 2:
                        case "end":
                          return _context2.stop();
                      }
                    }
                  }, _callee2);
                }));

                return function (_x3) {
                  return _ref3.apply(this, arguments);
                };
              }());

            case 4:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Individual stores loading', function (t) {
    t.mockUrl('resources-read', {
      delay: 1,
      responseText: JSON.stringify([{
        id: 1,
        name: 'Volvo V90'
      }, {
        id: 2,
        name: 'Volvo XC60'
      }, {
        id: 3,
        name: 'BMW M3'
      }, {
        id: 4,
        name: 'BMW X5'
      }, {
        id: 5,
        name: 'Peugeot 308'
      }])
    });
    t.mockUrl('events-read', {
      delay: 1,
      responseText: JSON.stringify([{
        id: 1,
        resourceId: 1,
        name: 'Serve engine',
        startDate: '2018-05-21 08:00',
        duration: 2
      }, {
        id: 2,
        resourceId: 1,
        name: 'Paint job',
        startDate: '2018-05-21 12:00',
        duration: 2
      }, {
        id: 3,
        resourceId: 2,
        name: 'Tune',
        startDate: '2018-05-21 07:00',
        duration: 1
      }, {
        id: 4,
        resourceId: 2,
        name: 'Diagnostics',
        startDate: '2018-05-21 09:00',
        duration: 2
      }, {
        id: 5,
        resourceId: 3,
        name: 'Replace engine',
        startDate: '2018-05-21 07:00',
        duration: 6
      }, {
        id: 6,
        resourceId: 4,
        name: 'New windshield',
        startDate: '2018-05-21 08:00',
        duration: 2
      }, {
        id: 7,
        resourceId: 4,
        name: 'Replace airbag',
        startDate: '2018-05-21 09:00',
        duration: 3
      }, {
        id: 8,
        resourceId: 4,
        name: 'Wash',
        startDate: '2018-05-21 14:00',
        duration: 2
      }, {
        id: 9,
        resourceId: 5,
        name: 'Repair cooler',
        startDate: '2018-05-21 10:00',
        duration: 7
      }])
    });
    t.mockUrl('events-update', {
      delay: 1,
      responseText: JSON.stringify({
        success: true,
        data: [{
          id: 1
        }, {
          id: 2
        }, {
          id: 3
        }, {
          id: 4
        }, {
          id: 5
        }, {
          id: 6
        }, {
          id: 7
        }, {
          id: 8
        }, {
          id: 9
        }]
      })
    });
    t.it('silenceInitialCommit=true (default) silently accepts the data changes caused by propagation', /*#__PURE__*/function () {
      var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
        var projectAsync, resourcesAsync, eventsAsync, resourceStore, eventStore, project;
        return regeneratorRuntime.wrap(function _callee4$(_context4) {
          while (1) {
            switch (_context4.prev = _context4.next) {
              case 0:
                projectAsync = t.beginAsync(), resourcesAsync = t.beginAsync(), eventsAsync = t.beginAsync(), resourceStore = new ResourceStore({
                  createUrl: 'resources-create',
                  readUrl: 'resources-read',
                  updateUrl: 'resources-update',
                  deleteUrl: 'resources-delete',
                  autoLoad: true,
                  autoCommit: true,
                  listeners: {
                    load: function load() {
                      t.endAsync(resourcesAsync);
                    }
                  }
                }), eventStore = new EventStore({
                  createUrl: 'events-create',
                  readUrl: 'events-read',
                  updateUrl: 'events-update',
                  deleteUrl: 'events-delete',
                  autoLoad: true,
                  autoCommit: true,
                  listeners: {
                    load: function load() {
                      t.endAsync(eventsAsync);
                    }
                  }
                }), project = new ProjectModel({
                  resourceStore: resourceStore,
                  eventStore: eventStore
                });
                t.notOk(resourceStore.changes, 'no resource changes before loading');
                t.notOk(eventStore.changes, 'no event changes before loading');
                t.wontFire(resourceStore, 'update', 'no resourceStore update happened');
                t.wontFire(resourceStore, 'commit', 'no resourceStore commit happened');
                t.wontFire(eventStore, 'update', 'no eventStore update happened');
                t.wontFire(eventStore, 'commit', 'no eventStore commit happened');
                t.willFireNTimes(project, 'dataReady', 1, 'one propagation happens');
                _context4.next = 10;
                return t.waitFor(100);

              case 10:
                // project is in consistent state
                t.waitForProjectReady(project, function () {
                  return t.endAsync(projectAsync);
                });
                t.notOk(resourceStore.changes, 'no resource changes after loading');
                t.notOk(eventStore.changes, 'no event changes after loading');

              case 13:
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
    t.it('silenceInitialCommit=false triggers store events on data changes caused by propagation', /*#__PURE__*/function () {
      var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
        var projectAsync, resourcesAsync, eventsAsync, resourceStore, eventStore, project;
        return regeneratorRuntime.wrap(function _callee5$(_context5) {
          while (1) {
            switch (_context5.prev = _context5.next) {
              case 0:
                projectAsync = t.beginAsync(), resourcesAsync = t.beginAsync(), eventsAsync = t.beginAsync(), resourceStore = new ResourceStore({
                  createUrl: 'resources-create',
                  readUrl: 'resources-read',
                  updateUrl: 'resources-update',
                  deleteUrl: 'resources-delete',
                  autoLoad: true,
                  autoCommit: true,
                  listeners: {
                    load: function load() {
                      t.endAsync(resourcesAsync);
                    }
                  }
                }), eventStore = new EventStore({
                  createUrl: 'events-create',
                  readUrl: 'events-read',
                  updateUrl: 'events-update',
                  deleteUrl: 'events-delete',
                  autoLoad: true,
                  autoCommit: true,
                  listeners: {
                    load: function load() {
                      t.endAsync(eventsAsync);
                    }
                  }
                }), project = new ProjectModel({
                  resourceStore: resourceStore,
                  eventStore: eventStore,
                  silenceInitialCommit: false
                });
                t.notOk(resourceStore.changes, 'no resource changes before loading');
                t.notOk(eventStore.changes, 'no event changes before loading');
                t.wontFire(resourceStore, 'update', 'no resourceStore update happened');
                t.wontFire(resourceStore, 'commit', 'no resourceStore commit happened');
                t.willFireNTimes(eventStore, 'update', 9, 'eventStore update happens for each event');
                t.willFireNTimes(eventStore, 'commit', 1, 'eventStore commit happened');
                t.willFireNTimes(project, 'dataReady', 1, 'one propagation happens');
                _context5.next = 10;
                return t.waitFor(100);

              case 10:
                // project is in consistent state
                t.waitForProjectReady(project, function () {
                  return t.endAsync(projectAsync);
                });
                t.notOk(resourceStore.changes, 'no resource changes after loading');
                t.notOk(eventStore.changes, 'no event changes after loading');

              case 13:
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
    t.it('silenceInitialCommit=true (default) silently accepts the data changes caused by propagation', /*#__PURE__*/function () {
      var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
        var projectAsync, resourceStore, eventStore, project;
        return regeneratorRuntime.wrap(function _callee6$(_context6) {
          while (1) {
            switch (_context6.prev = _context6.next) {
              case 0:
                projectAsync = t.beginAsync(), resourceStore = new ResourceStore({
                  createUrl: 'resources-create',
                  readUrl: 'resources-read',
                  updateUrl: 'resources-update',
                  deleteUrl: 'events-delete',
                  data: [{
                    id: 1,
                    name: 'Volvo V90'
                  }, {
                    id: 2,
                    name: 'Volvo XC60'
                  }, {
                    id: 3,
                    name: 'BMW M3'
                  }, {
                    id: 4,
                    name: 'BMW X5'
                  }, {
                    id: 5,
                    name: 'Peugeot 308'
                  }],
                  autoCommit: true
                }), eventStore = new EventStore({
                  createUrl: 'resources-create',
                  readUrl: 'events-read',
                  updateUrl: 'events-update',
                  deleteUrl: 'events-delete',
                  data: [{
                    id: 1,
                    resourceId: 1,
                    name: 'Serve engine',
                    startDate: '2018-05-21 08:00',
                    duration: 2
                  }, {
                    id: 2,
                    resourceId: 1,
                    name: 'Paint job',
                    startDate: '2018-05-21 12:00',
                    duration: 2
                  }, {
                    id: 3,
                    resourceId: 2,
                    name: 'Tune',
                    startDate: '2018-05-21 07:00',
                    duration: 1
                  }, {
                    id: 4,
                    resourceId: 2,
                    name: 'Diagnostics',
                    startDate: '2018-05-21 09:00',
                    duration: 2
                  }, {
                    id: 5,
                    resourceId: 3,
                    name: 'Replace engine',
                    startDate: '2018-05-21 07:00',
                    duration: 6
                  }, {
                    id: 6,
                    resourceId: 4,
                    name: 'New windshield',
                    startDate: '2018-05-21 08:00',
                    duration: 2
                  }, {
                    id: 7,
                    resourceId: 4,
                    name: 'Replace airbag',
                    startDate: '2018-05-21 09:00',
                    duration: 3
                  }, {
                    id: 8,
                    resourceId: 4,
                    name: 'Wash',
                    startDate: '2018-05-21 14:00',
                    duration: 2
                  }, {
                    id: 9,
                    resourceId: 5,
                    name: 'Repair cooler',
                    startDate: '2018-05-21 10:00',
                    duration: 7
                  }],
                  autoCommit: true
                }), project = new ProjectModel({
                  resourceStore: resourceStore,
                  eventStore: eventStore
                });
                t.notOk(resourceStore.changes, 'no resource changes before loading');
                t.notOk(eventStore.changes, 'no event changes before loading');
                t.wontFire(resourceStore, 'update', 'no resourceStore update happened');
                t.wontFire(resourceStore, 'commit', 'no resourceStore commit happened');
                t.wontFire(eventStore, 'update', 'no eventStore update happened');
                t.wontFire(eventStore, 'commit', 'no eventStore commit happened');
                t.willFireNTimes(project, 'dataReady', 1, 'one propagation happens');
                _context6.next = 10;
                return t.waitFor(100);

              case 10:
                t.waitForProjectReady(project, function () {
                  return t.endAsync(projectAsync);
                });
                t.notOk(resourceStore.changes, 'no resource changes after loading');
                t.notOk(eventStore.changes, 'no event changes after loading');

              case 13:
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
    t.it('silenceInitialCommit=false triggers store events on data changes caused by propagation', /*#__PURE__*/function () {
      var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
        var projectAsync, resourceStore, eventStore, project;
        return regeneratorRuntime.wrap(function _callee7$(_context7) {
          while (1) {
            switch (_context7.prev = _context7.next) {
              case 0:
                projectAsync = t.beginAsync(), resourceStore = new ResourceStore({
                  createUrl: 'resources-create',
                  readUrl: 'resources-read',
                  updateUrl: 'resources-update',
                  deleteUrl: 'events-delete',
                  data: [{
                    id: 1,
                    name: 'Volvo V90'
                  }, {
                    id: 2,
                    name: 'Volvo XC60'
                  }, {
                    id: 3,
                    name: 'BMW M3'
                  }, {
                    id: 4,
                    name: 'BMW X5'
                  }, {
                    id: 5,
                    name: 'Peugeot 308'
                  }],
                  autoCommit: true
                }), eventStore = new EventStore({
                  createUrl: 'resources-create',
                  readUrl: 'events-read',
                  updateUrl: 'events-update',
                  deleteUrl: 'events-delete',
                  data: [{
                    id: 1,
                    resourceId: 1,
                    name: 'Serve engine',
                    startDate: '2018-05-21 08:00',
                    duration: 2
                  }, {
                    id: 2,
                    resourceId: 1,
                    name: 'Paint job',
                    startDate: '2018-05-21 12:00',
                    duration: 2
                  }, {
                    id: 3,
                    resourceId: 2,
                    name: 'Tune',
                    startDate: '2018-05-21 07:00',
                    duration: 1
                  }, {
                    id: 4,
                    resourceId: 2,
                    name: 'Diagnostics',
                    startDate: '2018-05-21 09:00',
                    duration: 2
                  }, {
                    id: 5,
                    resourceId: 3,
                    name: 'Replace engine',
                    startDate: '2018-05-21 07:00',
                    duration: 6
                  }, {
                    id: 6,
                    resourceId: 4,
                    name: 'New windshield',
                    startDate: '2018-05-21 08:00',
                    duration: 2
                  }, {
                    id: 7,
                    resourceId: 4,
                    name: 'Replace airbag',
                    startDate: '2018-05-21 09:00',
                    duration: 3
                  }, {
                    id: 8,
                    resourceId: 4,
                    name: 'Wash',
                    startDate: '2018-05-21 14:00',
                    duration: 2
                  }, {
                    id: 9,
                    resourceId: 5,
                    name: 'Repair cooler',
                    startDate: '2018-05-21 10:00',
                    duration: 7
                  }],
                  autoCommit: true
                }), project = new ProjectModel({
                  resourceStore: resourceStore,
                  eventStore: eventStore,
                  silenceInitialCommit: false
                });
                t.notOk(resourceStore.changes, 'no resource changes before loading');
                t.notOk(eventStore.changes, 'no event changes before loading');
                t.wontFire(resourceStore, 'update', 'no resourceStore update happened');
                t.wontFire(resourceStore, 'commit', 'no resourceStore commit happened');
                t.willFireNTimes(eventStore, 'update', 9, 'eventStore update happens for each event');
                t.willFireNTimes(eventStore, 'commit', 1, 'eventStore commit happened');
                t.willFireNTimes(project, 'dataReady', 1, 'one propagation happens');
                _context7.next = 10;
                return t.waitFor(100);

              case 10:
                t.waitForProjectReady(project, function () {
                  return t.endAsync(projectAsync);
                });
                t.notOk(resourceStore.changes, 'no resource changes after loading');
                t.notOk(eventStore.changes, 'no event changes after loading');

              case 13:
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
  });
});