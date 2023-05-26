function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler1, scheduler2;
  t.mockUrl('crud-manager', {
    delay: 40,
    responseText: JSON.stringify({
      success: true,
      resources: {
        rows: [{
          id: 'a'
        }]
      },
      events: {
        rows: [{
          id: 1,
          resourceId: 'a',
          startDate: '2018-02-01',
          endDate: '2018-03-01',
          recurrenceRule: 'FREQ=MONTHLY;INTERVAL=2'
        }]
      }
    })
  });
  t.mockUrl('event-store', {
    delay: 10,
    responseText: JSON.stringify([{
      id: 1,
      resourceId: 1,
      startDate: '2018-02-01',
      endDate: '2018-03-01',
      recurrenceRule: 'FREQ=MONTHLY;INTERVAL=2'
    }])
  });
  t.mockUrl('event-500', {
    delay: 10,
    status: 500
  });
  t.beforeEach(function () {
    return Base.destroy(scheduler1, scheduler2);
  });

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(config) {
      var result;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getSchedulerAsync(Object.assign({
                enableRecurringEvents: true,
                features: {
                  eventTooltip: false
                },
                height: 400,
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2019, 0, 1)
              }, config));

            case 2:
              result = _context6.sent;
              return _context6.abrupt("return", result);

            case 4:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('Loading fails', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var resourceStore, eventStore, async;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              resourceStore = new ResourceStore({
                data: [{
                  id: 1
                }]
              });
              eventStore = new EventStore({
                readUrl: 'event-500'
              });
              _context.next = 4;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 4:
              scheduler1 = _context.sent;
              async = t.beginAsync();
              eventStore.load().catch(function () {
                t.pass('promise rejection happened');
                t.endAsync(async);
              });

            case 7:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x2) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Recurring event occurrences are generated on event store load', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var resourceStore, eventStore;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              resourceStore = new ResourceStore({
                data: [{
                  id: 1
                }]
              });
              eventStore = new EventStore({
                readUrl: 'event-store'
              });
              _context2.next = 4;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore,
                destroyStores: false
              });

            case 4:
              scheduler1 = _context2.sent;
              _context2.next = 7;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 7:
              scheduler2 = _context2.sent;
              _context2.next = 10;
              return eventStore.load();

            case 10:
              _context2.next = 12;
              return t.waitForProjectReady();

            case 12:
              t.is(eventStore.getById(1).occurrences.length, 5, 'event 1 has proper number of occurrences');

            case 13:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Recurring event occurrences are generated properly if event store is loaded before panels creation', function (t) {
    var eventStore;
    var resourceStore = new ResourceStore({
      data: [{
        id: 1
      }]
    });
    t.chain(function (next) {
      eventStore = new EventStore({
        autoLoad: true,
        readUrl: 'event-store',
        listeners: {
          load: next
        }
      });
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore,
                destroyStores: false
              });

            case 2:
              scheduler1 = _context3.sent;
              _context3.next = 5;
              return getScheduler({
                resourceStore: resourceStore,
                eventStore: eventStore
              });

            case 5:
              scheduler2 = _context3.sent;
              t.is(eventStore.getById(1).occurrences.length, 5, 'event 1 has proper number of occurrences');

            case 7:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    })));
  }); // TODO: uncomment (xit -> it) this when fixing https://github.com/bryntum/bryntum-suite/issues/1158
  // Error is thrown "Duplicate listener added: CrudManager#onCrudStoreChange"

  t.it('Recurring event occurrences are generated properly on CrudManager load', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var crudManager;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              crudManager = new CrudManager({
                eventStore: new EventStore(),
                resourceStore: new ResourceStore(),
                transport: {
                  load: {
                    url: 'crud-manager'
                  }
                }
              });
              scheduler1 = new Scheduler({
                viewPreset: 'dayAndWeek',
                rowHeight: 45,
                enableRecurringEvents: true,
                features: {
                  eventTooltip: false
                },
                columns: [{
                  text: 'Name',
                  sortable: true,
                  field: 'name',
                  locked: true
                }],
                useInitialAnimation: false,
                height: 400,
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2019, 0, 1),
                appendTo: document.body,
                destroyStores: false,
                crudManager: crudManager
              });
              _context4.next = 4;
              return crudManager.load();

            case 4:
              scheduler2 = new Scheduler({
                viewPreset: 'dayAndWeek',
                rowHeight: 45,
                enableRecurringEvents: true,
                features: {
                  eventTooltip: false
                },
                columns: [{
                  text: 'Name',
                  sortable: true,
                  field: 'name',
                  locked: true
                }],
                useInitialAnimation: false,
                height: 400,
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2019, 0, 1),
                appendTo: document.body,
                destroyStores: false,
                crudManager: crudManager
              });
              _context4.next = 7;
              return t.waitForProjectReady();

            case 7:
              t.is(crudManager.eventStore.getById(1).occurrences.length, 5, 'event 1 has proper number of occurrences'); // added after bug report here: https://github.com/bryntum/support/issues/1431

              _context4.next = 10;
              return crudManager.load();

            case 10:
              t.is(crudManager.eventStore.getById(1).occurrences.length, 5, 'event 1 has proper number of occurrences after 1 reload');
              _context4.next = 13;
              return crudManager.load();

            case 13:
              t.is(crudManager.eventStore.getById(1).occurrences.length, 5, 'event 1 has proper number of occurrences after 2 reloads');

            case 14:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }()); // TODO: uncomment (xit -> it) this when fixing https://github.com/bryntum/bryntum-suite/issues/1158
  // Error is thrown "Duplicate listener added: CrudManager#onCrudStoreChange"

  t.it('Recurring event occurrences are generated properly if CrudManager is loaded before panels creation', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var crudManager;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              crudManager = new CrudManager({
                eventStore: new EventStore(),
                resourceStore: new ResourceStore(),
                transport: {
                  load: {
                    url: 'crud-manager'
                  }
                }
              });
              _context5.next = 3;
              return crudManager.load();

            case 3:
              scheduler1 = new Scheduler({
                viewPreset: 'dayAndWeek',
                rowHeight: 45,
                enableRecurringEvents: true,
                features: {
                  eventTooltip: false
                },
                columns: [{
                  text: 'Name',
                  sortable: true,
                  field: 'name',
                  locked: true
                }],
                useInitialAnimation: false,
                height: 400,
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2019, 0, 1),
                appendTo: document.body,
                destroyStores: false,
                crudManager: crudManager
              });
              scheduler2 = new Scheduler({
                viewPreset: 'dayAndWeek',
                rowHeight: 45,
                enableRecurringEvents: true,
                features: {
                  eventTooltip: false
                },
                columns: [{
                  text: 'Name',
                  sortable: true,
                  field: 'name',
                  locked: true
                }],
                useInitialAnimation: false,
                height: 400,
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2019, 0, 1),
                appendTo: document.body,
                destroyStores: false,
                crudManager: crudManager
              });
              _context5.next = 7;
              return t.waitForProjectReady();

            case 7:
              t.is(crudManager.eventStore.getById(1).occurrences.length, 5, 'event 1 has proper number of occurrences');

            case 8:
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
});