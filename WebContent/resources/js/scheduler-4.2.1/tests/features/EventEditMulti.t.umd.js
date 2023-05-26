function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && !scheduler.isDestroyed && scheduler.destroy();
  });

  function getMultiScheduler() {
    return _getMultiScheduler.apply(this, arguments);
  }

  function _getMultiScheduler() {
    _getMultiScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12() {
      var config,
          _args12 = arguments;
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              config = _args12.length > 0 && _args12[0] !== undefined ? _args12[0] : {};
              scheduler = new Scheduler(Object.assign({
                appendTo: document.body,
                resources: [{
                  id: 'r1',
                  name: 'Mike'
                }, {
                  id: 'r2',
                  name: 'Linda'
                }, {
                  id: 'r3',
                  name: 'Jenny'
                }],
                events: [{
                  id: 1,
                  name: 'test event',
                  startDate: new Date(2017, 0, 1, 10),
                  endDate: new Date(2017, 0, 1, 12)
                }],
                assignments: config.assignmentStore ? undefined : [{
                  id: 1,
                  resourceId: 'r1',
                  eventId: 1
                }, {
                  id: 2,
                  resourceId: 'r2',
                  eventId: 1
                }],
                features: {
                  eventTooltip: false,
                  eventEdit: true
                },
                startDate: new Date(2017, 0, 1, 6),
                endDate: new Date(2017, 0, 1, 20),
                viewPreset: 'hourAndDay',
                enableEventAnimations: false
              }, config));
              _context12.next = 4;
              return t.waitForProjectReady();

            case 4:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));
    return _getMultiScheduler.apply(this, arguments);
  }

  t.it('Editing a multi assigned event should update all instances', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var initialLeft;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getMultiScheduler();

            case 2:
              initialLeft = document.querySelector('.b-sch-event').getBoundingClientRect().left;
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                type: 'Fun[ENTER]',
                target: 'input:focus'
              }, function (next) {
                t.selectorCountIs('.b-sch-event:contains(Fun)', 2, 'All elements text updated');
                next();
              }, {
                dblclick: '.b-sch-event'
              }, {
                click: '.b-timefield'
              }, {
                type: '09[ENTER]',
                clearExisting: true
              }, function () {
                DomHelper.forEachSelector(document, '.b-sch-event', function (el, i) {
                  t.isLess(el.getBoundingClientRect().left, initialLeft, "Element ".concat(i, " moved to the left"));
                });
              });

            case 4:
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
  t.it('Deleting a multi assigned event should remove all instances', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getMultiScheduler();

            case 2:
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                click: 'button:textEquals(Delete)'
              }, {
                waitForSelectorNotFound: scheduler.unreleasedEventSelector,
                desc: 'All elements gone'
              });

            case 3:
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
  t.it('Should support multiple resources w/ assignment store', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var event, eventEdit;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getMultiScheduler({
                startDate: new Date(2017, 0, 1),
                endDate: new Date(2017, 0, 3),
                features: {
                  eventTooltip: false,
                  eventEdit: true
                },
                resources: [{
                  id: 1,
                  name: 'Celia',
                  city: 'Barcelona'
                }, {
                  id: 2,
                  name: 'Lee',
                  city: 'London'
                }, {
                  id: 3,
                  name: 'Henrik',
                  city: 'London'
                }],
                events: [{
                  id: 1,
                  startDate: new Date(2017, 0, 1, 10),
                  endDate: new Date(2017, 0, 1, 12),
                  name: 'Multi assigned',
                  iconCls: 'b-fa b-fa-users'
                }],
                assignments: [{
                  resourceId: 1,
                  eventId: 1
                }, {
                  resourceId: 2,
                  eventId: 1
                }]
              }, false);

            case 2:
              event = scheduler.eventStore.first, eventEdit = scheduler.features.eventEdit;
              eventEdit.editEvent(event, scheduler.resourceStore.first);
              t.chain({
                waitFor: function waitFor() {
                  return bryntum.query('resourcecombo');
                }
              }, // Assign to one resource
              function (next) {
                var resourceCombo = bryntum.query('resourcecombo');
                t.isDeeplyUnordered(resourceCombo.value, [1, 2], 'Resource combo has correct initial value');
                resourceCombo.value = [1];
                eventEdit.save();
                t.isDeeply(event.resources, [scheduler.resourceStore.first], 'Correct resources assigned');
                next();
              }, {
                waitForSelector: '.b-released'
              }, // Assign to two resources
              function (next) {
                var resourceCombo = bryntum.query('resourcecombo');
                resourceCombo.value = [1, 2];
                eventEdit.save();
                t.is(event.resources.length, 2, 'Two resources now');
                t.ok(event.resources.includes(scheduler.resourceStore.getAt(0)), 'First resource assigned');
                t.ok(event.resources.includes(scheduler.resourceStore.getAt(1)), 'Second resource assigned');
                next();
              }, {
                waitForSelectorNotFound: '.b-released'
              }, function (next) {
                t.selectorCountIs(scheduler.unreleasedEventSelector, 2);
                next();
              }, {
                click: 'button:contains(Delete)'
              }, {
                waitForSelectorNotFound: scheduler.unreleasedEventSelector
              });

            case 5:
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
  t.it('Should select correct resource in event editor resource combo when creating new event using assignment store', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return getMultiScheduler({
                startDate: new Date(2017, 0, 1),
                endDate: new Date(2017, 0, 3),
                features: {
                  eventTooltip: false,
                  eventEdit: true
                },
                resources: [{
                  id: 1,
                  name: 'Celia',
                  city: 'Barcelona'
                }, {
                  id: 2,
                  name: 'Lee',
                  city: 'London'
                }, {
                  id: 3,
                  name: 'Henrik',
                  city: 'London'
                }],
                events: [],
                assignments: [{
                  resourceId: 1,
                  eventId: 1
                }, {
                  resourceId: 2,
                  eventId: 1
                }]
              }, false);

            case 2:
              t.chain({
                dblClick: '.b-sch-timeaxis-cell',
                offset: [1, 1]
              }, {
                type: 'foo',
                target: 'input:focus'
              }, function (next) {
                var resourceCombo = bryntum.query('resourcecombo');
                t.isDeeply(resourceCombo.value, [1], 'Resource combo has correct initial value');
                next();
              }, {
                click: 'button:contains(Save)'
              }, {
                waitForSelector: '.b-sch-event:contains(foo)'
              });

            case 3:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7444

  t.it('Should be able to delete a new multi assigned event from the editor', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return getMultiScheduler({
                events: [],
                assignments: []
              });

            case 2:
              t.chain({
                dblClick: [50, 90]
              }, {
                waitFor: function waitFor() {
                  return scheduler.features.eventEdit.editor.containsFocus;
                }
              }, {
                type: 'New test event'
              }, {
                click: '.b-icon-picker'
              }, {
                click: ':textEquals(Linda)'
              }, {
                click: ':textEquals(Save)'
              }, {
                dblClick: [50, 90]
              }, {
                click: ':textEquals(Delete)'
              }, function () {
                t.is(scheduler.eventStore.count, 0, 'EventStore is empty');
                t.is(scheduler.assignmentStore.count, 0, 'AssignmentStore is empty');
              });

            case 3:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x5) {
      return _ref5.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/6862

  t.it('Should anchor to correct element with multi assignment', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var eventEdit, element;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return getMultiScheduler();

            case 2:
              eventEdit = scheduler.features.eventEdit;
              t.chain({
                dblClick: '[data-event-id="1"]'
              }, function (next, el) {
                element = el = el.firstChild;
                t.is(eventEdit.editor.anchoredTo, el, 'Anchored to correct element');
                next();
              }, {
                type: '[ESC]'
              }, {
                waitForSelectorNotFound: '.b-eventeditor'
              }, {
                type: '[ENTER]'
              }, function (next) {
                t.is(eventEdit.editor.anchoredTo, element, 'Anchored to correct element');
                next();
              }, {
                type: '[ESC]'
              }, {
                waitForSelectorNotFound: '.b-eventeditor'
              }, {
                rightClick: '[data-event-id="1"]'
              }, {
                click: ':textEquals(Edit event)'
              }, function () {
                t.is(eventEdit.editor.anchoredTo, element, 'Anchored to correct element');
              });

            case 4:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref6.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/210

  t.it('Removing one existing resource assignment of a multi assigned event should trigger one assignment store change event', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return getMultiScheduler();

            case 2:
              t.firesOnce(scheduler.assignmentStore, 'change');
              _context7.next = 5;
              return scheduler.assignmentStore.commit();

            case 5:
              t.chain({
                waitFor: function waitFor() {
                  return document.querySelectorAll('.b-sch-event-wrap:not(.b-sch-released)').length === 2;
                }
              }, {
                dblclick: '.b-sch-event'
              }, function (next) {
                var resourceCombo = bryntum.query('resourcecombo');
                resourceCombo.value = ['r1'];
                next();
              }, {
                click: 'button:contains(Save)'
              }, {
                waitFor: function waitFor() {
                  return document.querySelectorAll('.b-sch-event-wrap:not(.b-sch-released)').length === 1;
                }
              }, function () {
                t.is(scheduler.assignmentStore.added.count, 0, 'No assignment added after removing one existing');
                t.is(scheduler.assignmentStore.removed.count, 1, 'One old assignment removed');
                t.is(scheduler.assignmentStore.modified.count, 0, 'No modified');
              });

            case 6:
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
  t.it('Adding 1 new assignment should trigger one assignment store change events', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return getMultiScheduler();

            case 2:
              // Add + commitAsync
              t.firesOk(scheduler.assignmentStore, {
                change: 2
              });
              scheduler.assignmentStore.commit();
              t.chain({
                waitFor: function waitFor() {
                  return document.querySelectorAll('.b-sch-event-wrap').length === 2;
                }
              }, {
                dblclick: '.b-sch-event'
              }, function (next) {
                var resourceCombo = bryntum.query('resourcecombo');
                resourceCombo.value = ['r1', 'r2', 'r3'];
                next();
              }, {
                click: 'button:contains(Save)'
              }, {
                waitFor: function waitFor() {
                  return document.querySelectorAll('.b-sch-event-wrap').length === 3;
                }
              }, function () {
                t.is(scheduler.assignmentStore.added.count, 1, 'No assignment added after removing one existing');
                t.is(scheduler.assignmentStore.removed.count, 0, 'No assignment removed');
                t.is(scheduler.assignmentStore.modified.count, 0, 'no modified');
              });

            case 5:
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
  t.it('Removing one existing resource assignment of a multi assigned event + adding 1 new should trigger 2 assignment store change events', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var commitCalls, _scheduler, assignmentStore;

      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              commitCalls = 0;
              t.mockUrl('read', {
                delay: 200,
                responseText: JSON.stringify([{
                  id: 1,
                  resourceId: 'r1',
                  eventId: 1
                }, {
                  id: 2,
                  resourceId: 'r2',
                  eventId: 1
                }])
              });
              _context10.next = 4;
              return getMultiScheduler({
                assignmentStore: new AssignmentStore({
                  autoCommit: true,
                  readUrl: 'read'
                })
              });

            case 4:
              _scheduler = scheduler, assignmentStore = _scheduler.assignmentStore; // there is inline data and first project commit which clears changes is triggered from there.
              // we are loading data from external source here, need to commit manually

              _context10.next = 7;
              return assignmentStore.load();

            case 7:
              _context10.next = 9;
              return t.waitForProjectReady(scheduler);

            case 9:
              _context10.next = 11;
              return assignmentStore.acceptChanges();

            case 11:
              assignmentStore.on({
                // prevent actual requests
                beforecommit: function beforecommit() {
                  commitCalls++;
                  return false;
                }
              });
              t.chain({
                waitFor: function waitFor() {
                  return document.querySelectorAll('.b-sch-event-wrap').length === 2;
                }
              }, {
                dblclick: '.b-sch-event'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9() {
                var resourceCombo;
                return regeneratorRuntime.wrap(function _callee9$(_context9) {
                  while (1) {
                    switch (_context9.prev = _context9.next) {
                      case 0:
                        commitCalls = 0;
                        resourceCombo = bryntum.query('resourcecombo');
                        resourceCombo.value = ['r1', 'r3']; // Add + remove + engine commit

                        t.willFireNTimes(assignmentStore, 'change', 3);

                      case 4:
                      case "end":
                        return _context9.stop();
                    }
                  }
                }, _callee9);
              })), {
                click: 'button:contains(Save)'
              }, function () {
                t.is(assignmentStore.added.count, 1, 'Single assignment added');
                t.is(assignmentStore.removed.count, 1, 'Single assignment removed');
                t.is(assignmentStore.modified.count, 0, 'No assignment modified');
                t.is(commitCalls, 1, 'Assignment store just made one commit');
              });

            case 13:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x9) {
      return _ref9.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/233

  t.it('Editing dates of a multi assigned event should NOT cause change to assignment store', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      var assignmentStore;
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return getMultiScheduler();

            case 2:
              assignmentStore = scheduler.assignmentStore;
              t.wontFire(assignmentStore, 'change');
              assignmentStore.commit();
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                dblclick: '.b-timefield .b-icon-angle-right'
              }, {
                type: '[ENTER]'
              }, function () {
                t.is(assignmentStore.added.count, 0, 'no added');
                t.is(assignmentStore.removed.count, 0, 'no removed');
                t.is(assignmentStore.modified.count, 0, 'no modified');
              });

            case 6:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x10) {
      return _ref11.apply(this, arguments);
    };
  }());
});