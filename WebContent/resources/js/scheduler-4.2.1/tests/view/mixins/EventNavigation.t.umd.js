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
    return scheduler && scheduler.destroy();
  });

  function getScheduler() {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14() {
      var config,
          scheduler,
          _args14 = arguments;
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              config = _args14.length > 0 && _args14[0] !== undefined ? _args14[0] : {};
              scheduler = t.getScheduler(config);
              _context14.next = 4;
              return t.waitForProjectReady();

            case 4:
              return _context14.abrupt("return", scheduler);

            case 5:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('Should allow key activation', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler({
                features: {
                  eventEdit: true
                }
              });

            case 2:
              scheduler = _context.sent;
              t.chain({
                click: '.b-sch-event.event1'
              }, {
                waitFor: function waitFor() {
                  return document.activeElement === document.querySelector('.b-sch-event.event1').parentNode;
                },
                desc: 'event1 is focused'
              }, {
                waitFor: function waitFor() {
                  return scheduler.activeAssignment === scheduler.assignmentStore.getAt(0);
                },
                desc: 'event1 is the active event'
              }, {
                type: '[RIGHT]'
              }, {
                waitFor: function waitFor() {
                  return document.activeElement === document.querySelector('.b-sch-event.event2').parentNode;
                },
                desc: 'event2 is focused'
              }, {
                waitFor: function waitFor() {
                  return scheduler.activeAssignment === scheduler.assignmentStore.getAt(1);
                },
                desc: 'event2 is the active event'
              }, {
                type: '[DELETE]'
              }, {
                waitFor: function waitFor() {
                  return document.activeElement === document.querySelector('.b-sch-event.event3').parentNode;
                },
                desc: 'event3 is focused'
              }, {
                waitFor: function waitFor() {
                  return scheduler.activeAssignment === scheduler.assignmentStore.getAt(1);
                },
                desc: 'event3 is the active event'
              }, {
                type: '[ENTER]'
              }, {
                waitForElementVisible: '.b-eventeditor'
              }, function (next) {
                var secondRec = scheduler.eventStore.getAt(1); // check editor contents

                t.is(document.querySelector('input[name=name]').value, secondRec.name, 'Name correct');
                t.is(document.querySelector('input[name=resource]').value, secondRec.resource.name, 'Resource correct');
                t.is(document.querySelector('.b-datefield input[name=startDate]').value, '01/06/2011', 'Start date correct');
                t.is(document.querySelector('.b-datefield input[name=endDate]').value, '01/08/2011', 'End date correct');
                t.is(document.querySelector('.b-timefield input[name=startDate]').value, '12:00 AM', 'Start time correct');
                t.is(document.querySelector('.b-timefield input[name=endDate]').value, '12:00 AM', 'End time correct'); // exposes fields?

                var editor = scheduler.features.eventEdit;
                t.ok(editor.nameField, 'name field exposed');
                t.ok(editor.resourceField, 'resource field exposed');
                t.ok(editor.startDateField, 'startDate field exposed');
                t.ok(editor.endDateField, 'endDate field exposed');
                t.ok(editor.startTimeField, 'startTime field exposed');
                t.ok(editor.endTimeField, 'endTime field exposed');
                next();
              }, {
                type: '[ESCAPE]'
              }, {
                waitFor: function waitFor() {
                  return document.activeElement === document.querySelector('.b-sch-event.event3').parentNode;
                },
                desc: 'Focus has reverted to event3'
              }, function (next) {
                t.ok(scheduler.activeAssignment === scheduler.assignmentStore.getAt(1), 'event3 is the active event');
                next();
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
  t.it('Should omit events outside the TimeAxis', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var _scheduler$assignment, a1, a2, a3;

      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getScheduler({
                features: {
                  eventEdit: true
                }
              });

            case 2:
              scheduler = _context2.sent;
              _scheduler$assignment = _slicedToArray(scheduler.assignmentStore, 3), a1 = _scheduler$assignment[0], a2 = _scheduler$assignment[1], a3 = _scheduler$assignment[2];
              t.is(scheduler.getNext(a1), a2, 'assignment2 is next from assignment1');
              t.is(scheduler.getPrevious(a3), a2, 'assignment2 is previous from assignment3'); // Push e2 out of the TimeAxis so that it is not navigable

              _context2.next = 8;
              return a2.event.setStartDate(DateHelper.add(a2.event.startDate, 6, 'month'), true);

            case 8:
              // getNext(1) should return 3 and getPrevious(3) should return 2
              t.is(scheduler.getNext(a1), a3, 'assignment3 is next from assignment1');
              t.is(scheduler.getPrevious(a3), a1, 'assignment1 is previous from assignment3');

            case 10:
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
  t.it('Navigation should be disabled during scrolling event into view, and should be unresponsive', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getScheduler({
                events: [{
                  startDate: new Date(2011, 0, 3),
                  endDate: new Date(2011, 0, 4),
                  name: 'Event 1',
                  resourceId: 'r1'
                }, {
                  startDate: new Date(2011, 0, 12),
                  endDate: new Date(2011, 0, 13),
                  name: 'Event 2',
                  resourceId: 'r2'
                }]
              });

            case 2:
              scheduler = _context3.sent;
              // This should just not throw
              t.chain({
                click: '.b-sch-event'
              }, {
                type: '[RIGHT][RIGHT]'
              });

            case 4:
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
  t.it('Clicking on half-visible event should not scroll it', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return getScheduler({
                startDate: new Date(2011, 0, 1),
                endDate: new Date(2011, 0, 31),
                events: [{
                  startDate: new Date(2011, 0, 3),
                  endDate: new Date(2011, 0, 4),
                  name: 'Event 1',
                  resourceId: 'r1'
                }, {
                  startDate: new Date(2011, 0, 12),
                  endDate: new Date(2011, 0, 13),
                  name: 'Event 2',
                  resourceId: 'r2'
                }]
              });

            case 2:
              scheduler = _context4.sent;
              scheduler.timeAxisSubGrid.scrollable.x = 255;
              t.chain( // It's hanging off the left edge, so click what we can see.
              // This must not scroll it fully into view. https://github.com/bryntum/support/issues/105
              {
                click: '.b-sch-event',
                offset: ['85%', '50%']
              }, function () {
                t.is(scheduler.timeAxisSubGrid.scrollable.x, 255, 'Clicking has not changed scroll');
              });

            case 5:
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
  t.it('Derendering an event which is scrolled out of the rendered block should focus the view', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var firstEventEl;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return getScheduler({
                events: [{
                  startDate: new Date(2011, 0, 3),
                  endDate: new Date(2011, 0, 4),
                  name: 'Event 1',
                  resourceId: 'r1'
                }, {
                  startDate: new Date(2011, 2, 12),
                  endDate: new Date(2011, 2, 13),
                  name: 'Event 2',
                  resourceId: 'r2'
                }],
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 2, 31)
              });

            case 2:
              scheduler = _context5.sent;
              firstEventEl = scheduler.getElementFromEventRecord(scheduler.eventStore.first); // Focus should be thrown up to the main Scheduler element when the focused event scrolls out of view

              t.chain({
                click: '.b-sch-event'
              }, // First event element is focused
              {
                waitFor: function waitFor() {
                  return document.activeElement === firstEventEl.parentNode;
                }
              }, function (next) {
                // Scroll rightwards a long way
                scheduler.timeAxisSubGrid.scrollable.scrollBy(10000);
                next();
              }, // Focus jumped upwards to Scheduler
              {
                waitFor: function waitFor() {
                  return document.activeElement === scheduler.focusElement;
                }
              });

            case 5:
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
  t.it('Navigate event arguments are fired correctly', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var assertEvent;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              assertEvent = function _assertEvent(element) {
                scheduler.navigator.on({
                  navigate: function navigate(_ref7) {
                    var item = _ref7.item;
                    t.is(item, element, 'Event argument is ok');
                  },
                  once: true
                });
              };

              _context6.next = 3;
              return getScheduler();

            case 3:
              scheduler = _context6.sent;
              assertEvent(document.querySelector('.b-sch-event-wrap[data-event-id="1"]'));
              t.chain({
                click: '.b-sch-event-wrap[data-event-id="1"]'
              }, function (next) {
                assertEvent(document.querySelector('.b-sch-event-wrap[data-event-id="2"]'));
                next();
              }, {
                type: '[RIGHT]'
              }, function (next) {
                assertEvent(document.querySelector('.b-sch-event-wrap[data-event-id="3"]'));
                next();
              }, {
                type: '[RIGHT]'
              });

            case 6:
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
  t.it('Should navigate events on filtered time axis', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return getScheduler({
                viewPreset: 'weekAndDay',
                resources: [{
                  id: 1,
                  name: 'Alber'
                }, {
                  id: 2,
                  name: 'Ben'
                }],
                startDate: '2011-01-04',
                endDate: '2011-03-06',
                events: [{
                  id: 1,
                  cls: 'event1',
                  resourceId: 1,
                  startDate: '2011-01-04',
                  endDate: '2011-01-04 17:00:00',
                  name: 'Visible'
                }, {
                  id: 2,
                  cls: 'event2',
                  resourceId: 1,
                  startDate: '2011-01-04 18:00:00',
                  endDate: '2011-01-04 20:00:00',
                  name: 'Filtered'
                }, {
                  id: 3,
                  cls: 'event3',
                  resourceId: 1,
                  startDate: '2011-01-05',
                  endDate: '2011-01-05 17:00:00',
                  name: 'Visible'
                }, {
                  id: 4,
                  cls: 'event4',
                  resourceId: 1,
                  startDate: '2011-03-03',
                  endDate: '2011-03-03 17:00:00',
                  name: 'Far right'
                }],
                workingTime: {
                  fromDay: 1,
                  toDay: 6,
                  fromHour: 8,
                  toHour: 17
                }
              });

            case 2:
              scheduler = _context7.sent;
              t.chain({
                click: '.b-sch-event'
              }, {
                type: '[RIGHT]'
              }, {
                waitForSelector: '.event3.b-sch-event-selected',
                desc: 'Navigated to event 3 successfully'
              }, {
                type: '[RIGHT]'
              }, {
                waitForSelector: '.event4.b-sch-event-selected',
                desc: 'Navigated to event 4 successfully'
              });

            case 4:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x7) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Programmatic focus through scrollEventIntoView should activate event', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return getScheduler({
                features: {
                  eventEdit: true
                }
              });

            case 2:
              scheduler = _context9.sent;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8() {
                return regeneratorRuntime.wrap(function _callee8$(_context8) {
                  while (1) {
                    switch (_context8.prev = _context8.next) {
                      case 0:
                        return _context8.abrupt("return", scheduler.scrollEventIntoView(scheduler.eventStore.first, {
                          focus: true
                        }));

                      case 1:
                      case "end":
                        return _context8.stop();
                    }
                  }
                }, _callee8);
              })), {
                waitFor: function waitFor() {
                  return scheduler.activeAssignment === scheduler.assignmentStore.first && document.activeElement === document.querySelector('.b-sch-event.event1').parentNode;
                },
                desc: 'event1 is focused'
              });

            case 4:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x8) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Should navigate between events in tree', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                features: {
                  tree: true
                },
                columns: [{
                  type: 'tree',
                  text: 'Name',
                  width: 220,
                  field: 'name'
                }],
                startDate: '2019-07-03',
                endDate: '2019-07-20',
                crudManager: {
                  autoLoad: true,
                  transport: {
                    load: {
                      url: 'view/mixins/EventNavigation.json'
                    }
                  }
                }
              });
              t.chain({
                click: '.b-sch-event'
              }, {
                type: '[RIGHT]'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10() {
                return regeneratorRuntime.wrap(function _callee10$(_context10) {
                  while (1) {
                    switch (_context10.prev = _context10.next) {
                      case 0:
                        t.is(scheduler.selectedEvents[0].id, 2, 'Proper event is selected');

                      case 1:
                      case "end":
                        return _context10.stop();
                    }
                  }
                }, _callee10);
              })));

            case 2:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x9) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Keyboard event removal should be preventable', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return getScheduler({
                listeners: {
                  beforeEventDelete: function beforeEventDelete() {
                    return false;
                  }
                }
              });

            case 2:
              scheduler = _context12.sent;
              t.chain({
                click: '[data-event-id="1"]'
              }, {
                type: '[DELETE]'
              }, function () {
                t.selectorExists('[data-event-id="1"]', 'Element not removed');
                t.ok(scheduler.eventStore.getById(1), 'Record not removed');
              });

            case 4:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x10) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('Should skip filtered events during navigation', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context13.sent;
              // filter out resources with even ids
              scheduler.eventStore.filter(function (e) {
                return e.id % 2;
              });
              t.chain({
                waitForSelectorNotFound: "".concat(scheduler.unreleasedEventSelector, "[data-event-id=\"4\"]")
              }, {
                click: '.event5'
              }, {
                type: '[LEFT]'
              }, {
                waitForSelector: '.event3.b-sch-event-selected',
                desc: 'Navigated to previous event'
              }, {
                type: '[RIGHT]'
              }, {
                waitForSelector: '.event5.b-sch-event-selected',
                desc: 'Navigated to next event'
              });

            case 5:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x11) {
      return _ref14.apply(this, arguments);
    };
  }());
});