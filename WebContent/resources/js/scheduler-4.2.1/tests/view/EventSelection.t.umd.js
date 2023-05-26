function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var events = [],
      eventEls = [];
  var scheduler, eventStore, assignments, selectionChangeSpy, assignmentSelectionChangeSpy;

  function createScheduler() {
    return _createScheduler.apply(this, arguments);
  }

  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23() {
      var config,
          i,
          _args23 = arguments;
      return regeneratorRuntime.wrap(function _callee23$(_context23) {
        while (1) {
          switch (_context23.prev = _context23.next) {
            case 0:
              config = _args23.length > 0 && _args23[0] !== undefined ? _args23[0] : {};
              selectionChangeSpy = t.createSpy('Selection change spy');
              assignmentSelectionChangeSpy = t.createSpy('Selection change spy');
              _context23.next = 5;
              return t.getSchedulerAsync(Object.assign({
                selectionChangeHandler: selectionChangeSpy,
                assignmentSelectionChangeHandler: assignmentSelectionChangeSpy
              }, config));

            case 5:
              scheduler = _context23.sent;
              eventStore = scheduler.eventStore;

              for (i = 0; i < eventStore.count; i++) {
                events[i] = eventStore.getAt(i);
                eventEls[i] = scheduler.getElementFromEventRecord(events[i]);
              }

              assignments = scheduler.assignmentStore.getRange();

            case 9:
            case "end":
              return _context23.stop();
          }
        }
      }, _callee23);
    }));
    return _createScheduler.apply(this, arguments);
  }

  function checkEventsCount(t, count) {
    t.isCalledNTimes('selectionChangeHandler', scheduler, count, "eventSelectionChange called ".concat(count, " times"));
    t.isCalledNTimes('assignmentSelectionChangeHandler', scheduler, count, "assignmentSelectionChange called ".concat(count, " times"));
    scheduler.on({
      eventSelectionChange: scheduler.selectionChangeHandler,
      assignmentSelectionChange: scheduler.assignmentSelectionChangeHandler,
      thisObj: scheduler
    });
  }

  function checkUISelection(t, selectedIndexes) {
    for (var i = 0; i < events.length; i++) {
      if (eventStore.includes(events[i])) {
        var selected = selectedIndexes.includes(i),
            hasClass = eventEls[i].classList.contains(scheduler.eventSelectedCls);

        if (hasClass !== selected) {
          t.fail("Event \"".concat(events[i].name, "\" should be ").concat(selected ? 'selected' : 'deselected'));
        }
      }
    }
  }

  t.beforeEach(function () {
    return scheduler && scheduler.destroy();
  });
  t.it('Selecting', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return createScheduler();

            case 2:
              checkEventsCount(t, 6); // Start with no selections

              checkUISelection(t, []);
              _context.next = 6;
              return t.click(eventEls[0]);

            case 6:
              t.isDeeply(selectionChangeSpy.calls.argsFor(0), [{
                type: 'eventselectionchange',
                action: 'select',
                deselected: [],
                selected: [events[0]],
                selection: [events[0]],
                source: scheduler
              }], 'Event: selection change to [0]');
              t.isDeeply(assignmentSelectionChangeSpy.calls.argsFor(0), [{
                type: 'assignmentselectionchange',
                action: 'select',
                deselected: [],
                selected: [assignments[0]],
                selection: [assignments[0]],
                source: scheduler
              }], 'Assignment: selection change to [0]');
              checkUISelection(t, [0]); // Clicking outside an event deselects All

              _context.next = 11;
              return t.click(scheduler.timeAxisSubGridElement);

            case 11:
              t.isDeeply(selectionChangeSpy.calls.argsFor(1), [{
                type: 'eventselectionchange',
                action: 'clear',
                deselected: [events[0]],
                selected: [],
                selection: [],
                source: scheduler
              }], 'Event: Deselect all');
              t.isDeeply(assignmentSelectionChangeSpy.calls.argsFor(1), [{
                type: 'assignmentselectionchange',
                action: 'clear',
                deselected: [assignments[0]],
                selected: [],
                selection: [],
                source: scheduler
              }], 'Assignment: Deselect all'); // Should be none selected

              checkUISelection(t, []);
              _context.next = 16;
              return t.click(eventEls[0]);

            case 16:
              t.isDeeply(selectionChangeSpy.calls.argsFor(2), [{
                type: 'eventselectionchange',
                action: 'select',
                deselected: [],
                selected: [events[0]],
                selection: [events[0]],
                source: scheduler
              }], 'Event: Selection change to [0]');
              t.isDeeply(assignmentSelectionChangeSpy.calls.argsFor(2), [{
                type: 'assignmentselectionchange',
                action: 'select',
                deselected: [],
                selected: [assignments[0]],
                selection: [assignments[0]],
                source: scheduler
              }], 'Assignment: Selection change to [0]');
              checkUISelection(t, [0]);
              _context.next = 21;
              return t.click(eventEls[2], null, null, {
                ctrlKey: true
              });

            case 21:
              t.isDeeply(selectionChangeSpy.calls.argsFor(3), [{
                type: 'eventselectionchange',
                action: 'update',
                deselected: [events[0]],
                selected: [events[2]],
                selection: [events[2]],
                source: scheduler
              }], 'Event: Select 2 and deselects 0 because we are multiEventSelect: false by default');
              t.isDeeply(assignmentSelectionChangeSpy.calls.argsFor(3), [{
                type: 'assignmentselectionchange',
                action: 'update',
                deselected: [assignments[0]],
                selected: [assignments[2]],
                selection: [assignments[2]],
                source: scheduler
              }], 'Assignment: Select 2 and deselects 0 because we are multiEventSelect: false by default');
              checkUISelection(t, [2]);
              scheduler.multiEventSelect = true;
              _context.next = 27;
              return t.click(eventEls[0], null, null, {
                ctrlKey: true
              });

            case 27:
              t.isDeeply(selectionChangeSpy.calls.argsFor(4), [{
                type: 'eventselectionchange',
                action: 'select',
                deselected: [],
                selected: [events[0]],
                selection: [events[2], events[0]],
                source: scheduler
              }], 'Event: Then we select 0 which adds it');
              t.isDeeply(assignmentSelectionChangeSpy.calls.argsFor(4), [{
                type: 'assignmentselectionchange',
                action: 'select',
                deselected: [],
                selected: [assignments[0]],
                selection: [assignments[2], assignments[0]],
                source: scheduler
              }], 'Assignment: Then we select 0 which adds it');
              checkUISelection(t, [0, 2]);
              _context.next = 32;
              return t.click(eventEls[2], null, null, {
                ctrlKey: true
              });

            case 32:
              t.isDeeply(selectionChangeSpy.calls.argsFor(5), [{
                type: 'eventselectionchange',
                action: 'deselect',
                deselected: [events[2]],
                selected: [],
                selection: [events[0]],
                source: scheduler
              }], 'Event: Then we deselect 2 with CTRL which will remove 2 from the selection');
              t.isDeeply(assignmentSelectionChangeSpy.calls.argsFor(5), [{
                type: 'assignmentselectionchange',
                action: 'deselect',
                deselected: [assignments[2]],
                selected: [],
                selection: [assignments[0]],
                source: scheduler
              }], 'Assignment: Then we deselect 2 with CTRL which will remove 2 from the selection');
              checkUISelection(t, [0]);

            case 35:
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
  t.it('Selecting using keyboard', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return createScheduler({
                multiEventSelect: true
              });

            case 2:
              checkEventsCount(t, 4); // Start with no selections

              checkUISelection(t, []); // Click to select [0]

              _context3.next = 6;
              return t.click(eventEls[0].parentNode);

            case 6:
              t.isDeeply(selectionChangeSpy.calls.argsFor(0), [{
                type: 'eventselectionchange',
                action: 'select',
                deselected: [],
                selected: [events[0]],
                selection: [events[0]],
                source: scheduler
              }], 'Selection change to [0]');
              checkUISelection(t, [0]); // Navigate to [1] maintaining existing selection

              _context3.next = 10;
              return t.keyPress(eventEls[0].parentNode, '[RIGHT]', {
                ctrlKey: true
              });

            case 10:
              t.chain({
                waitFor: function waitFor() {
                  return document.activeElement === eventEls[1].parentNode;
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        t.isDeeply(selectionChangeSpy.calls.argsFor(1), [{
                          type: 'eventselectionchange',
                          action: 'select',
                          deselected: [],
                          selected: [events[1]],
                          selection: [events[0], events[1]],
                          source: scheduler
                        }], 'Selection change to [0] and [1]'); // UI rendition is correct

                        checkUISelection(t, [0, 1]); // Navigate to [2] discarding existing selection

                        _context2.next = 4;
                        return t.keyPress(eventEls[1].parentNode, '[RIGHT]');

                      case 4:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              })), {
                waitFor: function waitFor() {
                  return document.activeElement === eventEls[2].parentNode;
                }
              }, function () {
                t.isDeeply(selectionChangeSpy.calls.argsFor(2), [{
                  type: 'eventselectionchange',
                  action: 'clear',
                  deselected: [events[0], events[1]],
                  selected: [],
                  selection: [],
                  source: scheduler
                }], 'deselect 0 and 1');
                t.isDeeply(selectionChangeSpy.calls.argsFor(3), [{
                  type: 'eventselectionchange',
                  action: 'select',
                  deselected: [],
                  selected: [events[2]],
                  selection: [events[2]],
                  source: scheduler
                }], 'Select 2');
                checkUISelection(t, [2]);
              });

            case 11:
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
  t.it('Attempting to select immediately after a delete should not throw', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return createScheduler();

            case 2:
              checkEventsCount(t, 3);
              t.chain({
                moveMouseTo: eventEls[0]
              }, {
                click: null
              }, {
                type: '[DELETE]'
              }, {
                waitForSelector: ['.b-released']
              }, {
                click: null
              });

            case 4:
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
  t.it('Config triggerSelectionChangeOnRemove should affect triggering', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var count;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return createScheduler();

            case 2:
              checkEventsCount(t, 3);
              count = 0;
              scheduler.on('eventSelectionChange', function (_ref6) {
                var deselected = _ref6.deselected;

                if (deselected && deselected.length) {
                  count++;
                }
              }); // Remove should not trigger

              scheduler.triggerSelectionChangeOnRemove = false;
              scheduler.selectEvent(scheduler.eventStore.first);
              checkUISelection(t, [0]);
              scheduler.eventStore.first.remove();
              _context5.next = 11;
              return t.waitForProjectReady();

            case 11:
              checkUISelection(t, []);
              t.is(count, 0, 'Not triggered when "false"'); // Remove should not trigger

              scheduler.triggerSelectionChangeOnRemove = true;
              scheduler.selectEvent(scheduler.eventStore.first);
              checkUISelection(t, [1]);
              scheduler.eventStore.first.remove();
              _context5.next = 19;
              return t.waitForProjectReady();

            case 19:
              checkUISelection(t, []);
              t.is(count, 1, 'Triggered when "true"');

            case 21:
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
  t.it('Setting a new dataset should clear selected records that are no longer part of the eventStore', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var event;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return createScheduler();

            case 2:
              checkEventsCount(t, 2);
              event = scheduler.eventStore.first;
              scheduler.triggerSelectionChangeOnRemove = true;
              scheduler.selectEvent(event);
              t.ok(scheduler.isEventSelected(event), 'First event selected');
              scheduler.events = [];
              _context6.next = 10;
              return t.waitForProjectReady();

            case 10:
              t.notOk(scheduler.isEventSelected(event), 'event not selected after dataset changed');

            case 11:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x5) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Should clear selection if maintainSelectionOnDatasetChange is false', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return createScheduler();

            case 2:
              checkEventsCount(t, 1);
              scheduler.events = [{
                id: 1,
                resourceId: 'r1',
                startDate: new Date(2017, 0, 1, 10),
                endDate: new Date(2017, 0, 1, 12)
              }];
              scheduler.maintainSelectionOnDatasetChange = false;
              scheduler.selectEvent(scheduler.eventStore.first);
              scheduler.events = [{
                id: 1,
                resourceId: 'r1',
                startDate: new Date(2017, 0, 1, 10),
                endDate: new Date(2017, 0, 1, 12)
              }];
              t.is(scheduler.selectedEvents.length, 0, 'No events selected');

            case 8:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x6) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Should not clear selection if maintainSelectionOnDatasetChange is true', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return createScheduler();

            case 2:
              checkEventsCount(t, 1);
              scheduler.events = [{
                id: 1,
                resourceId: 'r1',
                startDate: new Date(2011, 0, 4),
                endDate: new Date(2011, 0, 5)
              }];
              _context8.next = 6;
              return t.waitForProjectReady();

            case 6:
              scheduler.maintainSelectionOnDatasetChange = true;
              scheduler.selectEvent(scheduler.eventStore.first);
              t.is(scheduler.selectedEvents.length, 1, '1 event selected');
              scheduler.events = [{
                id: 1,
                resourceId: 'r1',
                startDate: new Date(2011, 0, 5),
                endDate: new Date(2011, 0, 6)
              }];
              _context8.next = 12;
              return t.waitForProjectReady();

            case 12:
              t.ok(scheduler.isEventSelected(scheduler.eventStore.first), 'Event still selected after new dataset was loaded');

            case 13:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x7) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Setting selection programmatically', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return createScheduler();

            case 2:
              checkEventsCount(t, 10); // Start with no selections

              checkUISelection(t, []); // Set multiple selected events

              scheduler.selectedEvents = [events[0], events[1], events[2]];
              checkUISelection(t, [0, 1, 2]); // Set single selected event

              scheduler.selectedEvents = [events[1]];
              checkUISelection(t, [1]); // Set empty selected events

              scheduler.selectedEvents = [];
              checkUISelection(t, []); // Set null selected events

              scheduler.selectedEvents = null;
              checkUISelection(t, []); // Set undefiled selected events

              scheduler.selectedEvents = null;
              checkUISelection(t, []); // Select single event and preserve selection

              scheduler.selectEvent(events[1], true);
              scheduler.selectEvent(events[2], true);
              checkUISelection(t, [1, 2]); // Select already selected event and don't preserve selection should do nothing

              scheduler.selectEvent(events[1], false);
              checkUISelection(t, [1, 2]); // Select single event and don't preserve selection

              scheduler.selectEvent(events[3], false);
              checkUISelection(t, [3]); // Deselect single event and preserve selection

              scheduler.selectedEvents = [events[1], events[2], events[3]];
              scheduler.deselectEvent(events[3]);
              checkUISelection(t, [1, 2]); // Deselect deselected event and don't preserve selection should do nothing

              scheduler.deselectEvent(events[3]);
              checkUISelection(t, [1, 2]); // Select multiple events

              scheduler.selectEvents([events[1], events[2], events[3]]);
              checkUISelection(t, [1, 2, 3]);
              scheduler.deselectEvents([events[1], events[2]]);
              checkUISelection(t, [3]);

            case 30:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x8) {
      return _ref10.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8398

  t.it('Clicking a resize handle should select the event', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return createScheduler();

            case 2:
              checkEventsCount(t, 1);
              t.chain({
                click: '.b-sch-event',
                offset: ['100%-3', '50%']
              }, function () {
                checkUISelection(t, [0]);
              });

            case 4:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x9) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Should clear selection classes on released elements', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return createScheduler({
                startDate: new Date(2011, 0, 2),
                endDate: new Date(2011, 2, 1),
                width: 800,
                events: [{
                  id: 'e2-1',
                  startDate: '2011-01-03',
                  endDate: '2011-01-05',
                  resourceId: 'r2'
                }, {
                  id: 'e3-1',
                  startDate: '2011-01-03',
                  endDate: '2011-01-05',
                  resourceId: 'r3'
                }, {
                  id: 'e2-2',
                  startDate: '2011-01-17',
                  endDate: '2011-01-19',
                  resourceId: 'r2'
                }, {
                  id: 'e3-2',
                  startDate: '2011-01-17',
                  endDate: '2011-01-19',
                  resourceId: 'r3'
                }, {
                  id: 'e4-1',
                  startDate: '2011-01-17',
                  endDate: '2011-01-19',
                  resourceId: 'r4'
                }, {
                  id: 'e5-1',
                  startDate: '2011-01-17',
                  endDate: '2011-01-19',
                  resourceId: 'r5'
                }]
              });

            case 2:
              t.chain({
                click: '[data-event-id="e2-1"]'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11() {
                return regeneratorRuntime.wrap(function _callee11$(_context11) {
                  while (1) {
                    switch (_context11.prev = _context11.next) {
                      case 0:
                        _context11.next = 2;
                        return scheduler.scrollToDate(new Date(2011, 0, 16), {
                          block: 'start'
                        });

                      case 2:
                        _context11.next = 4;
                        return t.waitForSelectorNotFound("".concat(scheduler.unreleasedEventSelector, " .b-sch-event-selected"));

                      case 4:
                        t.is(scheduler.selectedEvents[0].id, 'e2-1', 'event 2-1 is selected');

                      case 5:
                      case "end":
                        return _context11.stop();
                    }
                  }
                }, _callee11);
              })), {
                click: '[data-event-id="e5-1"]'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12() {
                return regeneratorRuntime.wrap(function _callee12$(_context12) {
                  while (1) {
                    switch (_context12.prev = _context12.next) {
                      case 0:
                        _context12.next = 2;
                        return scheduler.scrollToDate(new Date(2011, 0, 2), {
                          block: 'start'
                        });

                      case 2:
                        _context12.next = 4;
                        return t.waitForSelectorNotFound("".concat(scheduler.unreleasedEventSelector, " .b-sch-event-selected"));

                      case 4:
                        t.is(scheduler.selectedEvents[0].id, 'e5-1', 'event 5-1 is selected');

                      case 5:
                      case "end":
                        return _context12.stop();
                    }
                  }
                }, _callee12);
              })));

            case 3:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x10) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('Should select event outside of the view', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _context14.next = 2;
              return createScheduler({
                startDate: new Date(2011, 0, 2),
                endDate: new Date(2011, 2, 1),
                width: 800,
                events: [{
                  id: 'e4-1',
                  startDate: '2011-01-17',
                  endDate: '2011-01-19',
                  resourceId: 'r4'
                }]
              });

            case 2:
              scheduler.selectEvent(scheduler.eventStore.first);
              _context14.next = 5;
              return scheduler.scrollToDate(new Date(2011, 0, 16), {
                block: 'start'
              });

            case 5:
              _context14.next = 7;
              return t.waitForSelector('.b-sch-event-selected');

            case 7:
              t.pass('Event outside of the view is selected');

            case 8:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x11) {
      return _ref15.apply(this, arguments);
    };
  }()); // https://www.bryntum.com/forum/viewtopic.php?p=76925#p76925

  t.it('Should not duplicate records when multi selection is enabled and dataset is replaced', function (t) {
    var events = [{
      id: 1,
      resourceId: 'r1',
      startDate: new Date(2011, 0, 5),
      endDate: new Date(2011, 0, 6)
    }];
    scheduler = t.getScheduler({
      multiEventSelect: true,
      maintainSelectionOnDatasetChange: true,
      events: events
    });
    t.chain({
      click: '.b-sch-event'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15() {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              // replace with the same dataset
              scheduler.events = events;

            case 1:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    })), {
      drag: '.b-sch-event',
      by: [0, scheduler.rowHeight]
    }, {
      drag: '.b-sch-event',
      by: [0, scheduler.rowHeight]
    }, function () {
      t.selectorCountIs('.b-sch-event', 1, 'One element on the screen');
      t.is(scheduler.eventStore.count, 1, 'One record in the store');
    });
  }); // https://github.com/bryntum/support/issues/1742

  t.it('Should highlight assignments correctly in multi-assignment mode', /*#__PURE__*/function () {
    var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return createScheduler({
                multiEventSelect: true,
                features: {
                  eventTooltip: false,
                  scheduleTooltip: false
                },
                events: [{
                  id: 1,
                  name: 'The task',
                  startDate: new Date(2011, 0, 5),
                  endDate: new Date(2011, 0, 6)
                }],
                assignments: [{
                  resourceId: 'r1',
                  eventId: 1
                }, {
                  resourceId: 'r2',
                  eventId: 1
                }, {
                  resourceId: 'r3',
                  eventId: 1
                }]
              });

            case 2:
              _context16.next = 4;
              return t.click('[data-resource-id="r1"]');

            case 4:
              t.selectorExists('[data-resource-id="r1"] .b-sch-event-selected');
              t.selectorExists('[data-resource-id="r2"] .b-sch-event-assign-selected');
              t.selectorExists('[data-resource-id="r3"] .b-sch-event-assign-selected');
              _context16.next = 9;
              return t.click('[data-resource-id="r2"]');

            case 9:
              t.selectorExists('[data-resource-id="r2"] .b-sch-event-selected');
              t.selectorExists('[data-resource-id="r1"] .b-sch-event-assign-selected');
              t.selectorExists('[data-resource-id="r3"] .b-sch-event-assign-selected');

            case 12:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x12) {
      return _ref17.apply(this, arguments);
    };
  }());
  t.it('Should delete all selected events when pressing Delete key', /*#__PURE__*/function () {
    var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return createScheduler({
                multiEventSelect: true
              });

            case 2:
              _context17.next = 4;
              return t.click('.b-sch-event:contains(Assignment 1)', null, null, {
                ctrlKey: true
              });

            case 4:
              _context17.next = 6;
              return t.click('.b-sch-event:contains(Assignment 2)', null, null, {
                ctrlKey: true
              });

            case 6:
              t.firesOnce(scheduler.assignmentStore, 'remove');
              scheduler.eventStore.on({
                remove: function remove(_ref19) {
                  var records = _ref19.records;
                  t.is(records.length, 2, '2 records removed');
                }
              });
              _context17.next = 10;
              return t.type(null, '[DELETE]');

            case 10:
              _context17.next = 12;
              return t.waitForSelectorNotFound("".concat(scheduler.unreleasedEventSelector, ":contains(Assignment 1)"));

            case 12:
              _context17.next = 14;
              return t.waitForSelectorNotFound("".concat(scheduler.unreleasedEventSelector, ":contains(Assignment 2)"));

            case 14:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x13) {
      return _ref18.apply(this, arguments);
    };
  }());
  t.it('Should delete all selected events when drag selecting then pressing Delete key', /*#__PURE__*/function () {
    var _ref20 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
      var fired;
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              fired = false;
              _context18.next = 3;
              return createScheduler({
                features: {
                  eventDragSelect: true,
                  eventDragCreate: false
                }
              });

            case 3:
              _context18.next = 5;
              return t.dragTo('.b-sch-timeaxis-cell', [600, 300], null, null, null, false, [10, 10]);

            case 5:
              t.firesOnce(scheduler.assignmentStore, 'remove');
              scheduler.assignmentStore.on({
                remove: function remove(_ref21) {
                  var records = _ref21.records;
                  t.is(records.length, 4, '4 records removed');
                  fired = true;
                }
              });
              _context18.next = 9;
              return t.waitForSelector('.b-sch-event-wrap.b-active:contains(Assignment 4)');

            case 9:
              _context18.next = 11;
              return t.type(null, '[DELETE]');

            case 11:
              _context18.next = 13;
              return t.waitFor(function () {
                return fired;
              });

            case 13:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    }));

    return function (_x14) {
      return _ref20.apply(this, arguments);
    };
  }());
  t.it('Should deselect all events when replacing project', /*#__PURE__*/function () {
    var _ref22 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t) {
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              _context19.next = 2;
              return createScheduler();

            case 2:
              scheduler.selectEvents(scheduler.eventStore.records);
              scheduler.project = {
                eventsData: [{
                  id: 1,
                  startDate: '2011-01-04',
                  endDate: '2011-01-06',
                  resourceId: 'r1'
                }],
                resourcesData: [{
                  id: 'r1',
                  name: 'Resource 1'
                }]
              };
              t.is(scheduler.selectedEvents.length, 0, 'No events selected after replacing project');

            case 5:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    }));

    return function (_x15) {
      return _ref22.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2797

  t.it('Should handle event being deleted while being highlighted', /*#__PURE__*/function () {
    var _ref23 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(t) {
      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              _context20.next = 2;
              return createScheduler({
                highlightSuccessors: true,
                highlightPredecessors: true
              });

            case 2:
              scheduler.selectedEvents = [scheduler.eventStore.first];
              scheduler.eventStore.remove(scheduler.selectedEvents);

            case 4:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    }));

    return function (_x16) {
      return _ref23.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/31

  t.it('Should clear cell focus when selecting an event', /*#__PURE__*/function () {
    var _ref24 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21(t) {
      return regeneratorRuntime.wrap(function _callee21$(_context21) {
        while (1) {
          switch (_context21.prev = _context21.next) {
            case 0:
              _context21.next = 2;
              return createScheduler();

            case 2:
              _context21.next = 4;
              return t.click('.b-grid-cell');

            case 4:
              _context21.next = 6;
              return t.click('.b-sch-event');

            case 6:
              t.is(scheduler.focusedCell, null, 'No cell focused after clicking event');
              t.is(scheduler.selectedRecords.length, 1, 'Still 1 row selected after clicking event');

            case 8:
            case "end":
              return _context21.stop();
          }
        }
      }, _callee21);
    }));

    return function (_x17) {
      return _ref24.apply(this, arguments);
    };
  }());
  t.it('Should not scroll to last focused cell after dataset reload', /*#__PURE__*/function () {
    var _ref25 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
      var data;
      return regeneratorRuntime.wrap(function _callee22$(_context22) {
        while (1) {
          switch (_context22.prev = _context22.next) {
            case 0:
              document.body.setAttribute('tabIndex', -1);
              data = {
                success: true,
                resources: {
                  rows: [{
                    id: 1,
                    name: 'John'
                  }, {
                    id: 2,
                    name: 'Abby'
                  }, {
                    id: 3,
                    name: 'Dibby'
                  }, {
                    id: 4,
                    name: 'Gooby'
                  }, {
                    id: 5,
                    name: 'Maaybe'
                  }, {
                    id: 6,
                    name: 'Daby'
                  }]
                },
                events: {
                  rows: [{
                    id: 1,
                    resourceId: 1,
                    name: 'event',
                    startDate: '2011-01-05',
                    duration: 1
                  }]
                }
              };
              _context22.next = 4;
              return t.getScheduler({
                height: 200,
                width: 800,
                crudManager: {}
              });

            case 4:
              scheduler = window.scheduler = _context22.sent;
              scheduler.crudManager.loadCrudManagerData(data);
              _context22.next = 8;
              return t.click('.b-grid-cell:contains(Daby)');

            case 8:
              _context22.next = 10;
              return t.click('.b-sch-event');

            case 10:
              t.is(scheduler.focusedCell, null, 'No cell focused after clicking event');
              t.is(scheduler.selectedRecords.length, 1, 'Still 1 row selected after clicking event');
              scheduler.scrollable.y = 0;
              scheduler.crudManager.loadCrudManagerData(data);
              document.body.focus();
              scheduler.focus();
              t.is(scheduler.scrollable.y, 0, 'Scroll still at top, not modified due to Scheduler receiving focus');

            case 17:
            case "end":
              return _context22.stop();
          }
        }
      }, _callee22);
    }));

    return function (_x18) {
      return _ref25.apply(this, arguments);
    };
  }());
});