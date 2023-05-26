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
  var monday = new Date(2018, 4, 7),
      tuesday = new Date(2018, 4, 8);

  function getDataSample() {
    return new ProjectModel({
      eventStore: new EventStore({
        data: [{
          id: 1,
          name: 'Event 1',
          startDate: monday,
          endDate: tuesday
        }, {
          id: 2,
          name: 'Event 2',
          startDate: monday,
          endDate: tuesday
        }]
      }),
      resourceStore: new ResourceStore({
        data: [{
          id: 1,
          name: 'Resource 1'
        }, {
          id: 2,
          name: 'Resource 2'
        }]
      }),
      assignmentStore: new AssignmentStore({
        data: [{
          id: 1,
          eventId: 1,
          resourceId: 1
        }, {
          id: 2,
          eventId: 1,
          resourceId: 2
        }, {
          id: 3,
          eventId: 2,
          resourceId: 2
        }]
      })
    });
  }

  function createScheduler() {
    return _createScheduler.apply(this, arguments);
  }

  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14() {
      var data,
          _args14 = arguments;
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              data = _args14.length > 0 && _args14[0] !== undefined ? _args14[0] : getDataSample();
              scheduler = new Scheduler({
                appendTo: document.body,
                id: 'test',
                features: {
                  eventTooltip: false
                },
                columns: [{
                  text: 'name',
                  field: 'name'
                }],
                viewPreset: 'dayAndWeek',
                startDate: new Date(monday.getTime() - 3 * 24 * 60 * 60 * 1000),
                endDate: new Date(tuesday.getTime() + 4 * 24 * 60 * 60 * 1000),
                eventStore: data.eventStore,
                resourceStore: data.resourceStore,
                assignmentStore: data.assignmentStore
              });
              _context14.next = 4;
              return t.waitForProjectReady();

            case 4:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));
    return _createScheduler.apply(this, arguments);
  }

  function createScheduler2(_x) {
    return _createScheduler2.apply(this, arguments);
  }

  function _createScheduler2() {
    _createScheduler2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(config) {
      var _getDataSample, eventStore, resourceStore, assignmentStore;

      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              // Need to clear the mouse out of the way so that tooltips don't interfere with tests
              t.moveMouseTo(document.body, null, null, [0, 0], false);
              _getDataSample = getDataSample(), eventStore = _getDataSample.eventStore, resourceStore = _getDataSample.resourceStore, assignmentStore = _getDataSample.assignmentStore;
              scheduler = new Scheduler(Object.assign({
                appendTo: document.body,
                height: 600,
                width: 800,
                startDate: monday,
                eventStore: eventStore,
                resourceStore: resourceStore,
                assignmentStore: assignmentStore
              }, config));
              _context15.next = 5;
              return t.waitForProjectReady();

            case 5:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));
    return _createScheduler2.apply(this, arguments);
  }

  function createMultiScheduler() {
    return _createMultiScheduler.apply(this, arguments);
  }

  function _createMultiScheduler() {
    _createMultiScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16() {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              scheduler = new Scheduler({
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
                eventStore: {
                  removeUnassignedEvent: false,
                  data: [{
                    id: 1,
                    startDate: new Date(2017, 0, 1, 10),
                    endDate: new Date(2017, 0, 1, 12)
                  }]
                },
                assignments: [{
                  id: 1,
                  resourceId: 'r1',
                  eventId: 1
                }, {
                  id: 2,
                  resourceId: 'r2',
                  eventId: 1
                }],
                startDate: new Date(2017, 0, 1, 6),
                endDate: new Date(2017, 0, 1, 20),
                viewPreset: 'hourAndDay',
                enableEventAnimations: false,
                useInitialAnimation: false
              });
              _context16.next = 3;
              return t.waitForProjectReady();

            case 3:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));
    return _createMultiScheduler.apply(this, arguments);
  }

  t.it('Scheduler configured with assignment store must show events assigned to a resource', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return createScheduler();

            case 2:
              t.chain({
                waitForSelector: scheduler.eventSelector
              }, function () {
                t.selectorCountIs(scheduler.eventSelector, null, 3, '3 events are rendered');
              });

            case 3:
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
  t.it('Changing startDate of multi assigned event should update all instances', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var initialLeft, _Array$from, _Array$from2, first, second;

      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return createMultiScheduler();

            case 2:
              initialLeft = document.querySelector('[data-event-id="1"]').getBoundingClientRect().left;
              scheduler.eventStore.first.startDate = new Date(2017, 0, 1, 12);
              _context2.next = 6;
              return t.waitForProjectReady();

            case 6:
              _Array$from = Array.from(document.querySelectorAll('[data-event-id="1"]')), _Array$from2 = _slicedToArray(_Array$from, 2), first = _Array$from2[0], second = _Array$from2[1];
              t.isGreater(first.getBoundingClientRect().left, initialLeft, 'First instance moved to the right');
              t.is(first.getBoundingClientRect().left, second.getBoundingClientRect().left, 'Second instance moved to same location');

            case 9:
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
  t.it('Reassigning a multi assigned event should update element', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var initialTop, newTop;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return createMultiScheduler();

            case 2:
              initialTop = document.querySelector('[data-event-id="1"]').getBoundingClientRect().top; // Reassign to new resource

              scheduler.assignmentStore.first.resourceId = 'r3';
              _context3.next = 6;
              return t.waitForProjectReady();

            case 6:
              newTop = document.querySelector("[data-assignment-id=\"1\"]").getBoundingClientRect().top;
              t.isApprox(newTop, initialTop + scheduler.rowHeight * 2, 'First instance moved to the bottom'); // Assign back again

              scheduler.assignmentStore.first.resourceId = 'r1';
              _context3.next = 11;
              return t.waitForProjectReady();

            case 11:
              newTop = document.querySelector("[data-assignment-id=\"1\"]").getBoundingClientRect().top;
              t.is(newTop, initialTop, 'First instance moved to the top again');
              t.is(document.querySelectorAll(scheduler.unreleasedEventSelector).length, 2, 'Two events displayed');

            case 14:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x4) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Removing a multi assigned event should remove all elements', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return createMultiScheduler();

            case 2:
              scheduler.eventStore.first.remove();
              _context4.next = 5;
              return t.waitForProjectReady();

            case 5:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 0, 'No event element found');

            case 6:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x5) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('AssignmentStore CRUD operations should update events', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var _scheduler, assignmentStore;

      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return createMultiScheduler();

            case 2:
              _scheduler = scheduler, assignmentStore = _scheduler.assignmentStore;
              t.selectorCountIs(scheduler.unreleasedEventSelector, 2, 'Two events initially');
              assignmentStore.first.remove();
              _context5.next = 7;
              return t.waitForProjectReady();

            case 7:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Single event remain after remove()');
              assignmentStore.add({
                eventId: 1,
                resourceId: 'r3'
              });
              _context5.next = 11;
              return t.waitForProjectReady();

            case 11:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 2, 'Two events after add()');
              assignmentStore.removeAll();
              _context5.next = 15;
              return t.waitForProjectReady();

            case 15:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 0, 'No events after removeAll()');
              assignmentStore.data = [{
                eventId: 1,
                resourceId: 'r1'
              }, {
                eventId: 1,
                resourceId: 'r2'
              }, {
                eventId: 1,
                resourceId: 'r3'
              }];
              _context5.next = 19;
              return t.waitForProjectReady();

            case 19:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 3, 'Three events after assigning to data');
              assignmentStore.filter(function (r) {
                return r.resourceId === 'r1';
              });
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'One event after applying filter');

            case 22:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x6) {
      return _ref5.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/6862/details

  t.it('Deleting events should work', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return createScheduler();

            case 2:
              // Need to click since bug was in EventNavigation & EventSelection
              t.chain( // Single instance of Event 2
              {
                click: ':textEquals(Event 2)'
              }, {
                type: '[DELETE]'
              }, {
                waitForSelectorNotFound: scheduler.unreleasedEventSelector + ':textEquals(Event 2)'
              }, // Two instances of Event 1
              {
                click: '[data-assignment-id="2"]'
              }, {
                type: '[DELETE]'
              }, {
                waitForSelectorNotFound: '[data-assignment-id="2"]:not(.b-released)'
              }, {
                click: '[data-assignment-id="1"]'
              }, {
                type: '[DELETE]'
              }, {
                waitForSelectorNotFound: '[data-assignment-id="1"]:not(.b-released)'
              }, function () {
                t.pass('Could remove all events');
              });

            case 3:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x7) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Config `removeUnassignedEvent` should affect if events get removed or not', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return createScheduler();

            case 2:
              scheduler.eventStore.removeUnassignedEvent = true;
              scheduler.assignmentStore.last.remove();
              t.is(scheduler.eventStore.count, 1, 'Event removed with last assignment and `removeUnassignedEvent : true`');
              scheduler.assignmentStore.last.remove();
              t.is(scheduler.eventStore.count, 1, 'Event not removed with assignment and `removeUnassignedEvent : true`');
              scheduler.eventStore.removeUnassignedEvent = false;
              t.is(scheduler.eventStore.count, 1, 'Event not removed with last assignment and `removeUnassignedEvent : false`');

            case 9:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x8) {
      return _ref7.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7344-setting-a-new-dataset-crashes-when-using-assignmentstore

  t.it('Should be able to consume a new dataset', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return createScheduler();

            case 2:
              scheduler.eventStore.data = [{
                id: 1,
                startDate: '2018-05-07',
                duration: 2
              }];
              scheduler.resourceStore.data = [{
                id: 1
              }];
              scheduler.assignmentStore.data = [{
                eventId: 1,
                resourceId: 1
              }];
              _context8.next = 7;
              return t.waitForProjectReady();

            case 7:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Single rendered event');
              t.selectorCountIs('.b-sch-released', 0, 'No released events');

            case 9:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x9) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Delete event with no current active event', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var _scheduler2, eventStore;

      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return createScheduler2();

            case 2:
              _scheduler2 = scheduler, eventStore = _scheduler2.eventStore;
              t.is(scheduler.eventStore.count, 2); // Must successfully delete event and not throw error.
              // https://app.assembla.com/spaces/bryntum/tickets/7235

              scheduler.removeEvents([eventStore.first]);
              _context9.next = 7;
              return t.waitForProjectReady();

            case 7:
              t.is(scheduler.eventStore.count, 1);

            case 8:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x10) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Delete event with keyboard (multi-assign scheduler)', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      var _scheduler3, eventStore, assignmentStore, feature;

      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return createScheduler2();

            case 2:
              _scheduler3 = scheduler, eventStore = _scheduler3.eventStore, assignmentStore = _scheduler3.assignmentStore;
              feature = scheduler.features.eventEdit; // Focus should stay within the Scheduler by moving to the next closest event.

              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10() {
                return regeneratorRuntime.wrap(function _callee10$(_context10) {
                  while (1) {
                    switch (_context10.prev = _context10.next) {
                      case 0:
                        return _context10.abrupt("return", t.is(assignmentStore.count, 3, 'Correct initial assignment count'));

                      case 1:
                      case "end":
                        return _context10.stop();
                    }
                  }
                }, _callee10);
              })), // Focus the first event assignment
              {
                click: '[data-event-id="1"]'
              }, // Pressing delete should delete it
              {
                type: '[DELETE]'
              }, {
                waitFor: function waitFor() {
                  return assignmentStore.count === 2 && document.activeElement === scheduler.getElementFromEventRecord(eventStore.first).parentNode;
                }
              }, function (next) {
                t.rightClick(scheduler.getElementFromEventRecord(eventStore.first).parentNode).then(next);
              }, // Wait for context menu
              {
                waitFor: function waitFor() {
                  return scheduler.features.eventMenu.menu && scheduler.features.eventMenu.menu.containsFocus;
                }
              }, // Invoke the "Edit Event" option
              {
                type: '[DOWN]'
              }, {
                type: '[ENTER]'
              }, {
                waitFor: feature.editor && feature.nameField.containsFocus
              }, function (next) {
                feature.deleteButton.element.focus();
                next();
              }, {
                waitFor: function waitFor() {
                  return document.activeElement === feature.deleteButton.element;
                }
              }, // Activate the delete button without using the mouse
              function (next) {
                feature.deleteButton.element.click();
                next();
              }, // The remaining event should be focused
              {
                waitFor: function waitFor() {
                  return assignmentStore.count === 1 && document.activeElement === scheduler.getElementFromAssignmentRecord(assignmentStore.first).parentNode;
                }
              });

            case 5:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x11) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Delete event with keyboard then mouse (multi-assign scheduler)', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      var _scheduler4, eventStore, assignmentStore, feature;

      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return createScheduler2({
                features: {
                  eventTooltip: false
                }
              });

            case 2:
              _scheduler4 = scheduler, eventStore = _scheduler4.eventStore, assignmentStore = _scheduler4.assignmentStore; // Focus should stay within the Scheduler by moving to the next closest event.

              feature = scheduler.features.eventEdit;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12() {
                return regeneratorRuntime.wrap(function _callee12$(_context12) {
                  while (1) {
                    switch (_context12.prev = _context12.next) {
                      case 0:
                        return _context12.abrupt("return", t.is(assignmentStore.count, 3, 'Correct initial assignment count'));

                      case 1:
                      case "end":
                        return _context12.stop();
                    }
                  }
                }, _callee12);
              })), // Focus the first event assignment
              {
                click: '[data-event-id="1"]'
              }, // Pressing delete should delete it
              {
                type: '[DELETE]'
              }, {
                waitFor: function waitFor() {
                  return assignmentStore.count === 2 && document.activeElement === scheduler.getElementFromEventRecord(eventStore.first).parentNode;
                }
              }, // dblclick to show the event editor
              function (next) {
                t.doubleClick(scheduler.getElementFromEventRecord(eventStore.first).parentNode);
                next();
              }, {
                waitFor: function waitFor() {
                  return feature.editor && feature.deleteButton.isVisible;
                }
              }, // Click the delete button
              function (next) {
                t.click(feature.deleteButton.element);
                next();
              }, // Only one event remains
              {
                waitFor: function waitFor() {
                  return assignmentStore.count === 1;
                }
              }, // And because they used the mouse, we had to push focus out to
              // the Scheduler. Per Mats: We cannot refocus
              function () {
                t.is(document.activeElement, scheduler.focusElement);
              });

            case 5:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x12) {
      return _ref12.apply(this, arguments);
    };
  }());
});