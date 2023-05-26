function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

// https://github.com/bryntum/support/issues/2566
// https://github.com/bryntum/support/issues/2720
StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    var _scheduler, _scheduler$destroy;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : (_scheduler$destroy = _scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(_scheduler);
  }); //region Change time => CRUD sync

  t.it('Drag event to another time slot and sync changes should apply correct classes to Event element when CRUD manager sync is prevented', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  events: {
                    rows: [{
                      id: 1,
                      name: 'Task',
                      startDate: '2021-04-12',
                      duration: 1
                    }]
                  },
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'Man'
                    }]
                  },
                  assignments: {
                    rows: [{
                      id: 1,
                      resourceId: 1,
                      eventId: 1
                    }]
                  }
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2021, 3, 11),
                endDate: new Date(2021, 3, 18),
                viewPreset: 'weekAndDay',
                loadMask: false,
                syncMask: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                crudManager: {
                  autoLoad: true,
                  autoSync: false,
                  transport: {
                    load: {
                      url: 'load'
                    },
                    sync: {
                      url: 'sync'
                    }
                  },
                  listeners: {
                    beforeSync: function beforeSync() {
                      t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
                      t.selectorNotExists('.b-sch-event.b-sch-committing', 'Element is not marked as committing');
                      return false;
                    },
                    // Should run after internal handlers are called
                    prio: -999
                  }
                }
              });
              _context.next = 4;
              return t.waitForSelector('.b-sch-event');

            case 4:
              t.selectorNotExists('.b-sch-dirty,.b-sch-committing', 'Element is not dirty and not committing');
              t.diag('First drag');
              _context.next = 8;
              return t.dragBy('.b-sch-event', [scheduler.tickSize * 2, 0]);

            case 8:
              _context.next = 10;
              return scheduler.crudManager.sync();

            case 10:
              // beforeSync prevents saving
              t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context.next = 14;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 14:
              t.diag('Second drag');
              _context.next = 17;
              return t.dragBy('.b-sch-event', [scheduler.tickSize * 2, 0]);

            case 17:
              _context.next = 19;
              return scheduler.crudManager.sync();

            case 19:
              // beforeSync prevents saving
              t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context.next = 23;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 23:
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
  t.it('Drag event to another time slot and sync changes should apply correct classes to Event element when CRUD manager sync fails to save data', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  events: {
                    rows: [{
                      id: 1,
                      name: 'Task',
                      startDate: '2021-04-12',
                      duration: 1
                    }]
                  },
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'Man'
                    }]
                  },
                  assignments: {
                    rows: [{
                      id: 1,
                      resourceId: 1,
                      eventId: 1
                    }]
                  }
                })
              });
              t.mockUrl('sync', {
                delay: 10,
                responseText: JSON.stringify({
                  success: false,
                  message: 'Data is not saved',
                  type: 'sync'
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2021, 3, 11),
                endDate: new Date(2021, 3, 18),
                viewPreset: 'weekAndDay',
                loadMask: false,
                syncMask: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                crudManager: {
                  autoLoad: true,
                  autoSync: false,
                  transport: {
                    load: {
                      url: 'load'
                    },
                    sync: {
                      url: 'sync'
                    }
                  },
                  listeners: {
                    syncStart: function syncStart() {
                      t.todo('Implement committingCls for Crud Manager #2720', function (todo) {
                        todo.ok(scheduler.eventStore.first.isCommitting, 'Record is marked as committing');
                        todo.selectorExists('.b-sch-event.b-sch-committing', 'Element is marked as committing');
                      });
                    },
                    // Should run after internal handlers are called
                    prio: -999
                  }
                }
              });
              _context2.next = 5;
              return t.waitForSelector('.b-sch-event');

            case 5:
              t.selectorNotExists('.b-sch-dirty,.b-sch-committing', 'Element is not dirty and not committing');
              t.diag('First drag');
              _context2.next = 9;
              return t.dragBy('.b-sch-event', [scheduler.tickSize * 2, 0]);

            case 9:
              _context2.next = 11;
              return scheduler.crudManager.sync().catch(function () {// exception is expected here because we return { success : false }
              });

            case 11:
              t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context2.next = 15;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 15:
              t.diag('Second drag');
              _context2.next = 18;
              return t.dragBy('.b-sch-event', [scheduler.tickSize * 2, 0]);

            case 18:
              _context2.next = 20;
              return scheduler.crudManager.sync().catch(function () {// exception is expected here because we return { success : false }
              });

            case 20:
              t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context2.next = 24;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 24:
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
  t.it('Drag event to another time slot and sync changes should apply correct classes to Event element when CRUD manager sync succeeds to save data', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  events: {
                    rows: [{
                      id: 1,
                      name: 'Task',
                      startDate: '2021-04-12',
                      duration: 1
                    }]
                  },
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'Man'
                    }]
                  },
                  assignments: {
                    rows: [{
                      id: 1,
                      resourceId: 1,
                      eventId: 1
                    }]
                  }
                })
              });
              t.mockUrl('sync', {
                delay: 10,
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  events: {
                    rows: [{
                      id: 1
                    }]
                  }
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2021, 3, 11),
                endDate: new Date(2021, 3, 18),
                viewPreset: 'weekAndDay',
                loadMask: false,
                syncMask: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                crudManager: {
                  autoLoad: true,
                  autoSync: false,
                  transport: {
                    load: {
                      url: 'load'
                    },
                    sync: {
                      url: 'sync'
                    }
                  },
                  listeners: {
                    syncStart: function syncStart() {
                      t.todo('Implement committingCls for Crud Manager #2720', function (todo) {
                        todo.ok(scheduler.eventStore.first.isCommitting, 'Record is marked as committing');
                        todo.selectorExists('.b-sch-event.b-sch-committing', 'Element is marked as committing');
                      });
                    },
                    // Should run after internal handlers are called
                    prio: -999
                  }
                }
              });
              _context3.next = 5;
              return t.waitForSelector('.b-sch-event');

            case 5:
              t.selectorNotExists('.b-sch-dirty,.b-sch-committing', 'Element is not dirty and not committing');
              t.diag('First drag');
              _context3.next = 9;
              return t.dragBy('.b-sch-event', [scheduler.tickSize * 2, 0]);

            case 9:
              _context3.next = 11;
              return scheduler.crudManager.sync();

            case 11:
              t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context3.next = 15;
              return t.waitForSelectorNotFound('.b-sch-dirty,.b-sch-committing');

            case 15:
              t.diag('Second drag');
              _context3.next = 18;
              return t.dragBy('.b-sch-event', [scheduler.tickSize * 2, 0]);

            case 18:
              _context3.next = 20;
              return scheduler.crudManager.sync();

            case 20:
              t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context3.next = 24;
              return t.waitForSelectorNotFound('.b-sch-dirty,.b-sch-committing');

            case 24:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }()); //endregion
  //region Change resource => CRUD sync

  t.it('Drag event to another resource and sync changes should apply correct classes to Event element when CRUD manager sync is prevented', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  events: {
                    rows: [{
                      id: 1,
                      name: 'Task',
                      startDate: '2021-04-12',
                      duration: 1
                    }]
                  },
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'Foo'
                    }, {
                      id: 2,
                      name: 'Bar'
                    }, {
                      id: 3,
                      name: 'Baz'
                    }]
                  },
                  assignments: {
                    rows: [{
                      id: 1,
                      resourceId: 1,
                      eventId: 1
                    }]
                  }
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2021, 3, 11),
                endDate: new Date(2021, 3, 18),
                viewPreset: 'weekAndDay',
                loadMask: false,
                syncMask: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                crudManager: {
                  autoLoad: true,
                  autoSync: false,
                  transport: {
                    load: {
                      url: 'load'
                    },
                    sync: {
                      url: 'sync'
                    }
                  },
                  listeners: {
                    beforeSync: function beforeSync() {
                      t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
                      t.selectorNotExists('.b-sch-event.b-sch-committing', 'Element is not marked as committing');
                      return false;
                    },
                    // Should run after internal handlers are called
                    prio: -999
                  }
                }
              });
              _context4.next = 4;
              return t.waitForSelector('.b-sch-event');

            case 4:
              t.selectorNotExists('.b-sch-dirty,.b-sch-committing', 'Element is not dirty and not committing');
              t.diag('First drag');
              _context4.next = 8;
              return t.dragBy('.b-sch-event', [0, scheduler.rowHeight]);

            case 8:
              _context4.next = 10;
              return scheduler.crudManager.sync();

            case 10:
              // beforeSync prevents saving
              t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context4.next = 14;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 14:
              t.diag('Second drag');
              _context4.next = 17;
              return t.dragBy('.b-sch-event', [0, scheduler.rowHeight]);

            case 17:
              _context4.next = 19;
              return scheduler.crudManager.sync();

            case 19:
              // beforeSync prevents saving
              t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context4.next = 23;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 23:
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
  t.it('Drag event to another resource and sync changes should apply correct classes to Event element when CRUD manager sync fails to save data', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  events: {
                    rows: [{
                      id: 1,
                      name: 'Task',
                      startDate: '2021-04-12',
                      duration: 1
                    }]
                  },
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'Foo'
                    }, {
                      id: 2,
                      name: 'Bar'
                    }, {
                      id: 3,
                      name: 'Baz'
                    }]
                  },
                  assignments: {
                    rows: [{
                      id: 1,
                      resourceId: 1,
                      eventId: 1
                    }]
                  }
                })
              });
              t.mockUrl('sync', {
                delay: 10,
                responseText: JSON.stringify({
                  success: false,
                  message: 'Data is not saved',
                  type: 'sync'
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2021, 3, 11),
                endDate: new Date(2021, 3, 18),
                viewPreset: 'weekAndDay',
                loadMask: false,
                syncMask: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                crudManager: {
                  autoLoad: true,
                  autoSync: false,
                  transport: {
                    load: {
                      url: 'load'
                    },
                    sync: {
                      url: 'sync'
                    }
                  },
                  listeners: {
                    syncStart: function syncStart() {
                      t.todo('Implement committingCls for Crud Manager #2720', function (todo) {
                        todo.ok(scheduler.assignmentStore.first.isCommitting, 'Record is marked as committing');
                        todo.selectorExists('.b-sch-event.b-sch-committing', 'Element is marked as committing');
                      });
                    },
                    // Should run after internal handlers are called
                    prio: -999
                  }
                }
              });
              _context5.next = 5;
              return t.waitForSelector('.b-sch-event');

            case 5:
              t.selectorNotExists('.b-sch-dirty,.b-sch-committing', 'Element is not dirty and not committing');
              t.diag('First drag');
              _context5.next = 9;
              return t.dragBy('.b-sch-event', [0, scheduler.rowHeight]);

            case 9:
              _context5.next = 11;
              return scheduler.crudManager.sync().catch(function () {// exception is expected here because we return { success : false }
              });

            case 11:
              t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context5.next = 15;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 15:
              t.diag('Second drag');
              _context5.next = 18;
              return t.dragBy('.b-sch-event', [0, scheduler.rowHeight]);

            case 18:
              _context5.next = 20;
              return scheduler.crudManager.sync().catch(function () {// exception is expected here because we return { success : false }
              });

            case 20:
              t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context5.next = 24;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 24:
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
  t.it('Drag event to another resource and sync changes should apply correct classes to Event element when CRUD manager sync succeeds to save data', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  events: {
                    rows: [{
                      id: 1,
                      name: 'Task',
                      startDate: '2021-04-12',
                      duration: 1
                    }]
                  },
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'Foo'
                    }, {
                      id: 2,
                      name: 'Bar'
                    }, {
                      id: 3,
                      name: 'Baz'
                    }]
                  },
                  assignments: {
                    rows: [{
                      id: 1,
                      resourceId: 1,
                      eventId: 1
                    }]
                  }
                })
              });
              t.mockUrl('sync', {
                delay: 10,
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  events: {
                    rows: [{
                      id: 1
                    }]
                  }
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2021, 3, 11),
                endDate: new Date(2021, 3, 18),
                viewPreset: 'weekAndDay',
                loadMask: false,
                syncMask: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                crudManager: {
                  autoLoad: true,
                  autoSync: false,
                  transport: {
                    load: {
                      url: 'load'
                    },
                    sync: {
                      url: 'sync'
                    }
                  },
                  listeners: {
                    syncStart: function syncStart() {
                      t.todo('Implement committingCls for Crud Manager #2720', function (todo) {
                        todo.ok(scheduler.assignmentStore.first.isCommitting, 'Record is marked as committing');
                        todo.selectorExists('.b-sch-event.b-sch-committing', 'Element is marked as committing');
                      });
                    },
                    // Should run after internal handlers are called
                    prio: -999
                  }
                }
              });
              _context6.next = 5;
              return t.waitForSelector('.b-sch-event');

            case 5:
              t.selectorNotExists('.b-sch-dirty,.b-sch-committing', 'Element is not dirty and not committing');
              t.diag('First drag');
              _context6.next = 9;
              return t.dragBy('.b-sch-event', [0, scheduler.rowHeight]);

            case 9:
              _context6.next = 11;
              return scheduler.crudManager.sync();

            case 11:
              t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context6.next = 15;
              return t.waitForSelectorNotFound('.b-sch-dirty,.b-sch-committing');

            case 15:
              t.diag('Second drag');
              _context6.next = 18;
              return t.dragBy('.b-sch-event', [0, scheduler.rowHeight]);

            case 18:
              _context6.next = 20;
              return scheduler.crudManager.sync();

            case 20:
              t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context6.next = 24;
              return t.waitForSelectorNotFound('.b-sch-dirty,.b-sch-committing');

            case 24:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref6.apply(this, arguments);
    };
  }()); //endregion
  //region Change time => Store commit

  t.it('Drag event to another time slot and commit changes should apply correct classes to Event element when store commit is prevented', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2021, 3, 11),
                endDate: new Date(2021, 3, 18),
                viewPreset: 'weekAndDay',
                loadMask: false,
                syncMask: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                eventStore: {
                  updateUrl: 'sync',
                  data: [{
                    id: 1,
                    name: 'Task',
                    startDate: '2021-04-12',
                    duration: 1
                  }],
                  listeners: {
                    beforeCommit: function beforeCommit() {
                      t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
                      t.selectorNotExists('.b-sch-event.b-sch-committing', 'Element is not marked as committing');
                      return false;
                    },
                    // Should run after internal handlers are called
                    prio: -999
                  }
                },
                resources: [{
                  id: 1,
                  name: 'Man'
                }],
                assignments: [{
                  id: 1,
                  resourceId: 1,
                  eventId: 1
                }]
              });
              _context7.next = 3;
              return t.waitForSelector('.b-sch-event');

            case 3:
              t.selectorNotExists('.b-sch-dirty,.b-sch-committing', 'Element is not dirty and not committing');
              t.diag('First drag');
              _context7.next = 7;
              return t.dragBy('.b-sch-event', [scheduler.tickSize * 2, 0]);

            case 7:
              _context7.next = 9;
              return scheduler.eventStore.commit();

            case 9:
              // beforeCommit prevents committing
              t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context7.next = 13;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 13:
              t.diag('Second drag');
              _context7.next = 16;
              return t.dragBy('.b-sch-event', [scheduler.tickSize * 2, 0]);

            case 16:
              _context7.next = 18;
              return scheduler.eventStore.commit();

            case 18:
              // beforeCommit prevents committing
              t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context7.next = 22;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 22:
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
  t.it('Drag event to another time slot and commit changes should apply correct classes to Event element when store commit fails to save data', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              // The Ajax request must succeed, but contain a failure message
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: false,
                  message: 'Data is not saved'
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2021, 3, 11),
                endDate: new Date(2021, 3, 18),
                viewPreset: 'weekAndDay',
                loadMask: false,
                syncMask: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                eventStore: {
                  updateUrl: 'sync',
                  data: [{
                    id: 1,
                    name: 'Task',
                    startDate: '2021-04-12',
                    duration: 1
                  }],
                  listeners: {
                    commitStart: function commitStart() {
                      t.ok(scheduler.eventStore.first.isCommitting, 'Record is marked as committing');
                      t.selectorExists('.b-sch-event.b-sch-committing', 'Element is marked as committing');
                    },
                    // Should run after internal handlers are called
                    prio: -999
                  }
                },
                resources: [{
                  id: 1,
                  name: 'Man'
                }],
                assignments: [{
                  id: 1,
                  resourceId: 1,
                  eventId: 1
                }]
              });
              _context8.next = 4;
              return t.waitForSelector('.b-sch-event');

            case 4:
              t.selectorNotExists('.b-sch-dirty,.b-sch-committing', 'Element is not dirty and not committing');
              t.diag('First drag');
              _context8.next = 8;
              return t.dragBy('.b-sch-event', [scheduler.tickSize * 2, 0]);

            case 8:
              _context8.next = 10;
              return scheduler.eventStore.commit().catch(function () {// exception is expected here because we return { success : false }
              });

            case 10:
              t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context8.next = 14;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 14:
              t.diag('Second drag');
              _context8.next = 17;
              return t.dragBy('.b-sch-event', [scheduler.tickSize * 2, 0]);

            case 17:
              _context8.next = 19;
              return scheduler.eventStore.commit().catch(function () {// exception is expected here because we return { success : false }
              });

            case 19:
              t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context8.next = 23;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 23:
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
  t.it('Drag event to another time slot and commit changes should apply correct classes to Event element when store commit succeeds to save data', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true,
                  data: [{
                    id: 1
                  }]
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2021, 3, 11),
                endDate: new Date(2021, 3, 18),
                viewPreset: 'weekAndDay',
                loadMask: false,
                syncMask: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                eventStore: {
                  updateUrl: 'sync',
                  data: [{
                    id: 1,
                    name: 'Task',
                    startDate: '2021-04-12',
                    duration: 1
                  }],
                  listeners: {
                    commitStart: function commitStart() {
                      t.ok(scheduler.eventStore.first.isCommitting, 'Record is marked as committing');
                      t.selectorExists('.b-sch-event.b-sch-committing', 'Element is marked as committing');
                    },
                    // Should run after internal handlers are called
                    prio: -999
                  }
                },
                resources: [{
                  id: 1,
                  name: 'Man'
                }],
                assignments: [{
                  id: 1,
                  resourceId: 1,
                  eventId: 1
                }]
              });
              _context9.next = 4;
              return t.waitForSelector('.b-sch-event');

            case 4:
              t.selectorNotExists('.b-sch-dirty,.b-sch-committing', 'Element is not dirty and not committing');
              t.diag('First drag');
              _context9.next = 8;
              return t.dragBy('.b-sch-event', [scheduler.tickSize * 2, 0]);

            case 8:
              _context9.next = 10;
              return scheduler.eventStore.commit();

            case 10:
              t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context9.next = 14;
              return t.waitForSelectorNotFound('.b-sch-dirty,.b-sch-committing');

            case 14:
              t.diag('Second drag');
              _context9.next = 17;
              return t.dragBy('.b-sch-event', [scheduler.tickSize * 2, 0]);

            case 17:
              _context9.next = 19;
              return scheduler.eventStore.commit();

            case 19:
              t.notOk(scheduler.eventStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context9.next = 23;
              return t.waitForSelectorNotFound('.b-sch-dirty,.b-sch-committing');

            case 23:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x9) {
      return _ref9.apply(this, arguments);
    };
  }()); //endregion
  //region Change resource => Store commit

  t.it('Drag event to another resource and commit changes should apply correct classes to Event element when store commit is prevented', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2021, 3, 11),
                endDate: new Date(2021, 3, 18),
                viewPreset: 'weekAndDay',
                loadMask: false,
                syncMask: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                events: [{
                  id: 1,
                  name: 'Task',
                  startDate: '2021-04-12',
                  duration: 1
                }],
                resources: [{
                  id: 1,
                  name: 'Foo'
                }, {
                  id: 2,
                  name: 'Bar'
                }, {
                  id: 3,
                  name: 'Baz'
                }],
                assignmentStore: {
                  updateUrl: 'sync',
                  data: [{
                    id: 1,
                    resourceId: 1,
                    eventId: 1
                  }],
                  listeners: {
                    beforeCommit: function beforeCommit() {
                      t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
                      t.selectorNotExists('.b-sch-event.b-sch-committing', 'Element is not marked as committing');
                      return false;
                    },
                    // Should run after internal handlers are called
                    prio: -999
                  }
                }
              });
              _context10.next = 3;
              return t.waitForSelector('.b-sch-event');

            case 3:
              t.selectorNotExists('.b-sch-dirty,.b-sch-committing', 'Element is not dirty and not committing');
              t.diag('First drag');
              _context10.next = 7;
              return t.dragBy('.b-sch-event', [0, scheduler.rowHeight]);

            case 7:
              _context10.next = 9;
              return scheduler.assignmentStore.commit();

            case 9:
              // beforeCommit prevents committing
              t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context10.next = 13;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 13:
              t.diag('Second drag');
              _context10.next = 16;
              return t.dragBy('.b-sch-event', [0, scheduler.rowHeight]);

            case 16:
              _context10.next = 18;
              return scheduler.assignmentStore.commit();

            case 18:
              // beforeCommit prevents committing
              t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context10.next = 22;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 22:
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
  t.it('Drag event to another resource and commit changes should apply correct classes to Event element when store commit fails to save data', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: false,
                  message: 'Data is not saved'
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2021, 3, 11),
                endDate: new Date(2021, 3, 18),
                viewPreset: 'weekAndDay',
                loadMask: false,
                syncMask: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                events: [{
                  id: 1,
                  name: 'Task',
                  startDate: '2021-04-12',
                  duration: 1
                }],
                resources: [{
                  id: 1,
                  name: 'Foo'
                }, {
                  id: 2,
                  name: 'Bar'
                }, {
                  id: 3,
                  name: 'Baz'
                }],
                assignmentStore: {
                  updateUrl: 'sync',
                  data: [{
                    id: 1,
                    resourceId: 1,
                    eventId: 1
                  }],
                  listeners: {
                    commitStart: function commitStart() {
                      t.ok(scheduler.assignmentStore.first.isCommitting, 'Record is marked as committing');
                      t.selectorExists('.b-sch-event.b-sch-committing', 'Element is marked as committing');
                    },
                    // Should run after internal handlers are called
                    prio: -999
                  }
                }
              });
              _context11.next = 4;
              return t.waitForSelector('.b-sch-event');

            case 4:
              t.selectorNotExists('.b-sch-dirty,.b-sch-committing', 'Element is not dirty and not committing');
              t.diag('First drag');
              _context11.next = 8;
              return t.dragBy('.b-sch-event', [0, scheduler.rowHeight]);

            case 8:
              _context11.next = 10;
              return scheduler.assignmentStore.commit().catch(function () {// exception is expected here because we return { success : false }
              });

            case 10:
              t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context11.next = 14;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 14:
              t.diag('Second drag');
              _context11.next = 17;
              return t.dragBy('.b-sch-event', [0, scheduler.rowHeight]);

            case 17:
              _context11.next = 19;
              return scheduler.assignmentStore.commit().catch(function () {// exception is expected here because we return { success : false }
              });

            case 19:
              t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context11.next = 23;
              return t.waitForSelector('.b-sch-event.b-sch-dirty');

            case 23:
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
  t.it('Drag event to another resource and commit changes should apply correct classes to Event element when store commit succeeds to save data', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true,
                  data: [{
                    id: 1
                  }]
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2021, 3, 11),
                endDate: new Date(2021, 3, 18),
                viewPreset: 'weekAndDay',
                loadMask: false,
                syncMask: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                events: [{
                  id: 1,
                  name: 'Task',
                  startDate: '2021-04-12',
                  duration: 1
                }],
                resources: [{
                  id: 1,
                  name: 'Foo'
                }, {
                  id: 2,
                  name: 'Bar'
                }, {
                  id: 3,
                  name: 'Baz'
                }],
                assignmentStore: {
                  updateUrl: 'sync',
                  data: [{
                    id: 1,
                    resourceId: 1,
                    eventId: 1
                  }],
                  listeners: {
                    commitStart: function commitStart() {
                      t.ok(scheduler.assignmentStore.first.isCommitting, 'Record is marked as committing');
                      t.selectorExists('.b-sch-event.b-sch-committing', 'Element is marked as committing');
                    },
                    // Should run after internal handlers are called
                    prio: -999
                  }
                }
              });
              _context12.next = 4;
              return t.waitForSelector('.b-sch-event');

            case 4:
              t.selectorNotExists('.b-sch-dirty,.b-sch-committing', 'Element is not dirty and not committing');
              t.diag('First drag');
              _context12.next = 8;
              return t.dragBy('.b-sch-event', [0, scheduler.rowHeight]);

            case 8:
              _context12.next = 10;
              return scheduler.assignmentStore.commit();

            case 10:
              t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context12.next = 14;
              return t.waitForSelectorNotFound('.b-sch-dirty,.b-sch-committing');

            case 14:
              t.diag('Second drag');
              _context12.next = 17;
              return t.dragBy('.b-sch-event', [0, scheduler.rowHeight]);

            case 17:
              _context12.next = 19;
              return scheduler.assignmentStore.commit();

            case 19:
              // beforeCommit prevents committing
              t.notOk(scheduler.assignmentStore.first.isCommitting, 'Record is not marked as committing');
              t.selectorNotExists('.b-sch-committing', 'Element is not marked as committing');
              _context12.next = 23;
              return t.waitForSelectorNotFound('.b-sch-dirty,.b-sch-committing');

            case 23:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x12) {
      return _ref12.apply(this, arguments);
    };
  }()); //endregion
});