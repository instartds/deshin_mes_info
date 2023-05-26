function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    return scheduler && scheduler.destroy();
  });
  t.it('Should support dataset replace with syncDataOnLoad', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                width: 600,
                columns: [{
                  field: 'name',
                  width: 150
                }],
                eventStore: {
                  syncDataOnLoad: true
                },
                resources: [{
                  id: 1,
                  name: 'Lee',
                  type: 'Marketing',
                  eventColor: 'green'
                }, {
                  id: 2,
                  name: 'Lee',
                  type: 'Marketing',
                  eventColor: 'green'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  name: 'Appointment',
                  startDate: '2017-02-07 09:00',
                  endDate: '2017-02-07 11:00'
                }, {
                  id: 2,
                  resourceId: 2,
                  name: 'Meeting',
                  startDate: '2017-02-07 09:00',
                  endDate: '2017-02-07 11:00'
                }],
                startDate: new Date(2017, 1, 7, 8),
                endDate: new Date(2017, 1, 7, 18),
                viewPreset: 'hourAndDay'
              });
              _context.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 2, '2 events initially');
              scheduler.eventStore.data = [{
                id: 1,
                resourceId: 1,
                startDate: '2017-02-07 10:00',
                endDate: '2017-02-07 12:00',
                name: 'Appointment updated'
              }];
              t.waitForSelectorNotFound(scheduler.unreleasedEventSelector + ':contains(Meeting)');
              t.waitForSelector(scheduler.unreleasedEventSelector + ':contains(Appointment updated)');

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
  t.it('Should handle an event being updated while dragging', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                width: 600,
                columns: [{
                  field: 'name',
                  width: 150
                }],
                eventStore: {
                  syncDataOnLoad: true
                },
                resources: [{
                  id: 1,
                  name: 'Lee'
                }, {
                  id: 2,
                  name: 'Doug'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  name: 'Appointment',
                  startDate: '2017-02-07 09:00',
                  endDate: '2017-02-07 11:00'
                }, {
                  id: 2,
                  resourceId: 2,
                  name: 'Meeting',
                  startDate: '2017-02-07 09:00',
                  endDate: '2017-02-07 11:00'
                }],
                startDate: new Date(2017, 1, 7, 8),
                endDate: new Date(2017, 1, 7, 18),
                viewPreset: 'hourAndDay'
              });
              _context2.next = 3;
              return t.waitForProjectReady();

            case 3:
              _context2.next = 5;
              return t.dragBy('.b-sch-event', [-70, 0], null, null, null, true);

            case 5:
              // Update name, resource, duration, start date
              scheduler.eventStore.data = [{
                id: 1,
                resourceId: 2,
                startDate: '2017-02-07 10:00',
                endDate: '2017-02-07 13:00',
                name: 'Appointment updated'
              }];
              _context2.next = 8;
              return scheduler.project.commitAsync();

            case 8:
              t.waitForSelectorNotFound(scheduler.unreleasedEventSelector + ':contains(Meeting)');
              t.mouseUp(null);
              _context2.next = 12;
              return t.waitForSelectorNotFound('.b-dragging');

            case 12:
              _context2.next = 14;
              return scheduler.project.commitAsync();

            case 14:
              t.is(scheduler.eventStore.first.startDate, new Date(2017, 1, 7, 8), 'Start date ok');
              t.is(scheduler.eventStore.first.endDate, new Date(2017, 1, 7, 11), 'End date ok');
              t.is(scheduler.eventStore.first.resource.name, 'Lee', 'Resource ok');

            case 17:
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
  t.it('Should render correctly after a small **no-op** drag, during which the event is reassigned from outside', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 13),
                resources: [{
                  id: 'r1'
                }, {
                  id: 'r2'
                }, {
                  id: 'r3'
                }],
                eventStore: {
                  syncDataOnLoad: true,
                  data: [{
                    id: 1,
                    name: 'Assignment 1',
                    startDate: new Date(2011, 0, 4),
                    endDate: new Date(2011, 0, 6),
                    cls: 'event1',
                    resourceId: 'r1'
                  }, {
                    id: 2,
                    name: 'Assignment 2',
                    startDate: new Date(2011, 0, 5),
                    endDate: new Date(2011, 0, 7),
                    cls: 'event2',
                    resourceId: 'r2'
                  }, {
                    id: 3,
                    name: 'Assignment 3',
                    startDate: new Date(2011, 0, 6),
                    endDate: new Date(2011, 0, 8),
                    cls: 'event3',
                    resourceId: 'r3'
                  }]
                }
              });
              t.chain({
                drag: '.event1',
                by: [0, 20],
                dragOnly: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        scheduler.events = [{
                          id: 1,
                          name: 'Assignment 1 New',
                          startDate: new Date(2011, 0, 4),
                          endDate: new Date(2011, 0, 6),
                          cls: 'event1',
                          resourceId: 'r2'
                        }];
                        _context3.next = 3;
                        return scheduler.project.commitAsync();

                      case 3:
                        t.wontFire(scheduler.eventStore, 'update');

                      case 4:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3);
              })), {
                mouseUp: null
              }, function () {
                return scheduler.project.commitAsync();
              }, {
                waitForSelectorNotFound: '.b-dragging'
              }, function () {
                t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 4), 'Correct start date');
                t.is(scheduler.eventStore.first.endDate, new Date(2011, 0, 6), 'Correct end date');
                t.is(scheduler.eventStore.first.resource.id, 'r2', 'Since we performed a no-op, resource external resource modification is kept');
                t.selectorCountIs(scheduler.unreleasedEventSelector, 1, '1 event rendered');
              });

            case 2:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1929

  t.it('Should remove event bars from view if event store is cleared during single event drag drop (websocket update etc)', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 13),
                rowHeight: 40,
                resources: [{
                  id: 'r1'
                }],
                eventStore: {
                  syncDataOnLoad: true,
                  data: [{
                    id: 1,
                    name: 'Assignment 1',
                    startDate: new Date(2011, 0, 4),
                    endDate: new Date(2011, 0, 6),
                    resourceId: 'r1'
                  }, {
                    id: 2,
                    name: 'Assignment 2',
                    startDate: new Date(2011, 0, 4),
                    endDate: new Date(2011, 0, 6),
                    resourceId: 'r1'
                  }]
                }
              });
              t.chain({
                drag: '.b-sch-event',
                by: [100, 0],
                dragOnly: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
                return regeneratorRuntime.wrap(function _callee5$(_context5) {
                  while (1) {
                    switch (_context5.prev = _context5.next) {
                      case 0:
                        scheduler.events = [];
                        _context5.next = 3;
                        return scheduler.project.commitAsync();

                      case 3:
                        t.wontFire(scheduler.eventStore, 'update');

                      case 4:
                      case "end":
                        return _context5.stop();
                    }
                  }
                }, _callee5);
              })), {
                mouseUp: null
              }, {
                waitForSelectorNotFound: '.b-dragging'
              }, {
                waitForSelectorNotFound: scheduler.unreleasedEventSelector
              }, function () {
                t.is(scheduler.eventStore.count, 0, 'No events in store');
                t.hasApproxHeight('.b-grid-row', 40, 'Correct row height');
              });

            case 2:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x4) {
      return _ref5.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1929

  t.it('Should remove event bar from view if event is removed during drag drop (websocket update etc)', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 13),
                rowHeight: 40,
                resources: [{
                  id: 'r1'
                }],
                eventStore: {
                  syncDataOnLoad: true,
                  data: [{
                    id: 1,
                    name: 'Removed',
                    startDate: new Date(2011, 0, 4),
                    endDate: new Date(2011, 0, 6),
                    resourceId: 'r1'
                  }, {
                    id: 2,
                    name: 'Assignment 2',
                    startDate: new Date(2011, 0, 4),
                    endDate: new Date(2011, 0, 6),
                    resourceId: 'r1'
                  }]
                }
              });
              t.firesOnce(scheduler.eventStore, 'update');
              t.chain({
                drag: '.b-sch-event:contains(Removed)',
                by: [100, 0],
                dragOnly: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                return regeneratorRuntime.wrap(function _callee7$(_context7) {
                  while (1) {
                    switch (_context7.prev = _context7.next) {
                      case 0:
                        scheduler.eventStore.first.remove();
                        _context7.next = 3;
                        return scheduler.project.commitAsync();

                      case 3:
                      case "end":
                        return _context7.stop();
                    }
                  }
                }, _callee7);
              })), {
                mouseUp: null
              }, {
                waitForSelectorNotFound: '.b-dragging'
              }, {
                waitForSelectorNotFound: scheduler.unreleasedEventSelector + ':contains(Removed)'
              }, function (next) {
                t.selectorCountIs(scheduler.unreleasedEventSelector, 1, '1 event remaining');
                t.is(scheduler.eventStore.count, 1, '1 event in store');
                t.hasApproxHeight('.b-grid-row', 40, 'Correct row height');
                next();
              }, {
                drag: '.b-sch-event',
                by: [100, 0]
              }, {
                waitForSelectorNotFound: '.b-dragging'
              }, function (next) {
                t.selectorCountIs(scheduler.unreleasedEventSelector, 1, '1 event');
                t.is(scheduler.eventStore.count, 1, '1 event in store');
                t.hasApproxHeight('.b-grid-row', 40, 'Correct row height');
                t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 5), 'Start date ok');
              });

            case 3:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x5) {
      return _ref7.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1929

  t.it('Should remove event bar from view if one of multiple events is removed during drag drop (websocket update etc)', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 13),
                rowHeight: 40,
                multiEventSelect: true,
                resources: [{
                  id: 'r1'
                }],
                eventStore: {
                  syncDataOnLoad: true,
                  data: [{
                    id: 1,
                    name: 'Assignment 1',
                    startDate: new Date(2011, 0, 4),
                    endDate: new Date(2011, 0, 6),
                    resourceId: 'r1'
                  }, {
                    id: 2,
                    name: 'Assignment 2',
                    startDate: new Date(2011, 0, 4),
                    endDate: new Date(2011, 0, 6),
                    resourceId: 'r1'
                  }]
                }
              });
              t.willFireNTimes(scheduler.eventStore, 'update', 2);
              scheduler.selectEvents(scheduler.eventStore.getRange());
              t.chain({
                drag: '.b-sch-event',
                by: [100, 0],
                dragOnly: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9() {
                return regeneratorRuntime.wrap(function _callee9$(_context9) {
                  while (1) {
                    switch (_context9.prev = _context9.next) {
                      case 0:
                        scheduler.eventStore.first.remove();
                        _context9.next = 3;
                        return scheduler.project.commitAsync();

                      case 3:
                      case "end":
                        return _context9.stop();
                    }
                  }
                }, _callee9);
              })), {
                mouseUp: null
              }, {
                waitForSelectorNotFound: '.b-dragging'
              }, {
                waitForSelectorNotFound: scheduler.unreleasedEventSelector + ':contains(Removed)'
              }, function (next) {
                t.selectorCountIs(scheduler.unreleasedEventSelector, 1, '1 event remaining');
                t.is(scheduler.eventStore.count, 1, '1 event in store');
                t.hasApproxHeight('.b-grid-row', 40, 'Correct row height');
                next();
              }, {
                drag: '.b-sch-event',
                by: [100, 0]
              }, function (next) {
                t.selectorCountIs(scheduler.unreleasedEventSelector, 1, '1 event remaining');
                t.is(scheduler.eventStore.count, 1, '1 event in store');
                t.hasApproxHeight('.b-grid-row', 40, 'Correct row height');
              });

            case 4:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x6) {
      return _ref9.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2774

  t.it('Should remove event bars from view if event store is cleared during multi-event drag drop (websocket update etc)', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 13),
                rowHeight: 40,
                multiEventSelect: true,
                resources: [{
                  id: 'r1'
                }],
                eventStore: {
                  syncDataOnLoad: true,
                  data: [{
                    id: 1,
                    name: 'Event 1',
                    startDate: new Date(2011, 0, 4),
                    endDate: new Date(2011, 0, 6),
                    resourceId: 'r1'
                  }, {
                    id: 2,
                    name: 'Event 2',
                    startDate: new Date(2011, 0, 4),
                    endDate: new Date(2011, 0, 6),
                    resourceId: 'r1'
                  }]
                }
              });
              scheduler.selectEvents(scheduler.eventStore.getRange());
              t.chain({
                drag: '.b-sch-event',
                by: [100, 0],
                dragOnly: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11() {
                return regeneratorRuntime.wrap(function _callee11$(_context11) {
                  while (1) {
                    switch (_context11.prev = _context11.next) {
                      case 0:
                        scheduler.events = [];
                        _context11.next = 3;
                        return scheduler.project.commitAsync();

                      case 3:
                        t.wontFire(scheduler.eventStore, 'update');

                      case 4:
                      case "end":
                        return _context11.stop();
                    }
                  }
                }, _callee11);
              })), {
                mouseUp: null
              }, {
                waitForSelectorNotFound: '.b-dragging'
              }, {
                waitForSelectorNotFound: scheduler.unreleasedEventSelector
              }, function () {
                t.is(scheduler.eventStore.count, 0, 'No events in store');
                t.hasApproxHeight('.b-grid-row', 40, 'Correct row height');
              });

            case 3:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x7) {
      return _ref11.apply(this, arguments);
    };
  }());
});