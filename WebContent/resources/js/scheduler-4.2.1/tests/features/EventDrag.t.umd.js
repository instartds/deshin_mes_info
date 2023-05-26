function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest({
  defaultTimeout: 90000
}, function (t) {
  var scheduler;
  t.beforeEach(function () {
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(config) {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              scheduler = t.getScheduler(Object.assign({
                features: {
                  eventDrag: true
                }
              }, config));
              _context13.next = 3;
              return t.waitForProjectReady(scheduler);

            case 3:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('CSS classes + styling sanity checks', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler({
                features: {
                  eventDrag: true
                },
                events: [{
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }, {
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }]
              });

            case 2:
              t.chain({
                drag: scheduler.eventSelector,
                by: [20, 0],
                dragOnly: true
              }, {
                waitForSelector: scheduler.eventSelector + '.b-dragging',
                desc: 'CSS classes applied to event'
              }, {
                waitForSelector: '.b-scheduler.b-dragging-event',
                desc: 'CSS classes applied to scheduler'
              }, function (next) {
                var draggedElementStyles = window.getComputedStyle(t.query(scheduler.eventSelector + '.b-dragging')[0]),
                    regularEventStyles = window.getComputedStyle(t.query(scheduler.eventSelector + ':not(.b-dragging)')[0]);
                t.ok(scheduler.isEventSelected(scheduler.eventStore.first), 'Dragged event selected');
                t.selectorNotExists('.b-drag-invalid');
                t.isGreater(parseInt(draggedElementStyles.zIndex, 10), parseInt(regularEventStyles.zIndex, 10), 'Dragged event has higher z-index');
                next();
              }, {
                mouseUp: null
              }, function () {
                t.selectorNotExists('.b-dragging');
                t.selectorNotExists('.b-drag-invalid');
                t.selectorNotExists('.b-dragging-event');
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
  t.it('Should abort on ESC keypress and restore dependencies', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var eventEls, eventElRects;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getScheduler({
                features: {
                  eventDrag: true,
                  dependencies: true
                },
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }, {
                  id: 2,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }],
                dependencies: [{
                  from: 1,
                  to: 2
                }]
              });

            case 2:
              eventEls = scheduler.eventStore.map(function (e) {
                return scheduler.getElementFromEventRecord(e);
              }), eventElRects = eventEls.map(function (e) {
                return Rectangle.from(e);
              });
              t.wontFire(scheduler.eventStore, 'update');
              t.chain({
                drag: scheduler.eventSelector,
                by: [20, 0],
                dragOnly: true
              }, function (next) {
                t.firesOnce(scheduler, 'dependenciesDrawn');
                next();
              }, {
                type: '[ESC]'
              }, // There really is no alternative here. The element has a transition
              // on its transform style, so we have to wait for its rectangle to settle back.
              {
                waitFor: 500
              }, function () {
                var endingEventEls = scheduler.eventStore.map(function (e) {
                  return scheduler.getElementFromEventRecord(e);
                }),
                    endingEventElRecs = endingEventEls.map(function (e) {
                  return Rectangle.from(e);
                }); // Same number of elements, and all in the same place.

                t.is(scheduler.timeAxisSubGridElement.querySelectorAll(scheduler.eventSelector).length, eventEls.length);
                t.is(endingEventEls.length, eventEls.length);

                for (var i = 0; i < eventEls.length; i++) {
                  t.isApproxRect(endingEventElRecs[i], eventElRects[i], 1, "Event rect is the same");
                }
              });

            case 5:
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
  t.it('Drag and drop with validator function', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var counter, dragFn, evt;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              counter = 0;

              dragFn = function dragFn(_ref4, e) {
                var eventRecords = _ref4.eventRecords,
                    assignmentRecords = _ref4.assignmentRecords,
                    newResource = _ref4.newResource,
                    startDate = _ref4.startDate,
                    duration = _ref4.duration,
                    draggedRecords = _ref4.draggedRecords;
                t.ok(draggedRecords[0].isEvent, 'draggedRecords is an array of Event records (deprecated)');

                if (draggedRecords && VersionHelper.checkVersion('scheduler', '5.0.0', '>=')) {
                  t.fail('Deprecated `draggedRecords` should be removed!');
                }

                if (counter % 200 === 0) {
                  t.isInstanceOf(eventRecords[0], EventModel, 'Correct function arguments 1');
                  t.isInstanceOf(assignmentRecords[0], AssignmentModel, 'Correct function arguments 2');
                  t.isInstanceOf(newResource, ResourceModel, 'Correct function arguments 3');
                  t.isInstanceOf(startDate, Date, 'Correct function arguments 4');
                  t.ok(typeof duration === 'number', 'Correct function arguments 5');
                  t.isInstanceOf(e, Event, 'Correct function arguments 6');
                }

                counter++;
                return startDate <= new Date(2011, 0, 6);
              };

              _context3.next = 4;
              return getScheduler({
                features: {
                  eventDrag: {
                    validatorFn: dragFn
                  }
                },
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }]
              });

            case 4:
              evt = scheduler.eventStore.first;
              t.chain({
                drag: scheduler.eventSelector,
                by: [100, 0]
              }, function (next) {
                t.isGreater(evt.endDate, new Date(2011, 0, 6), 'Task dragged properly');
                next();
              }, {
                waitForSelectorNotFound: '.b-dragging'
              }, {
                waitForSelectorNotFound: '.b-drag-invalid'
              }, {
                drag: scheduler.eventSelector,
                by: [300, 0]
              }, {
                moveCursorTo: scheduler.eventSelector
              }, function (next) {
                t.isLess(evt.endDate, new Date(2011, 0, 8), 'Task not dragged.');
                next();
              }, {
                drag: scheduler.eventSelector,
                by: [20, 0]
              });

            case 6:
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
  t.it('Drag and drop with constraining dates', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var _scheduler2, tickSize, draggedEvent, startDate, endDate, initialRegion, doConstraining;

      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return getScheduler({
                startDate: new Date(2011, 0, 3),
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }],
                // Constrain events within their current day
                getDateConstraints: function getDateConstraints(resourceRecord, eventRecord) {
                  if (eventRecord) {
                    return doConstraining ? {
                      start: new Date(2011, 0, 6),
                      end: new Date(2011, 0, 7)
                    } : null;
                  }
                }
              });

            case 2:
              _scheduler2 = scheduler, tickSize = _scheduler2.tickSize, draggedEvent = scheduler.eventStore.first, startDate = draggedEvent.startDate, endDate = draggedEvent.endDate, initialRegion = t.rect(scheduler.eventSelector);
              doConstraining = true;
              t.willFireNTimes(scheduler.eventStore, 'change', 2);
              t.chain({
                drag: scheduler.eventSelector,
                by: [-tickSize, 0],
                dragOnly: true
              }, function (next) {
                var region = t.rect('.b-dragging');
                t.isApprox(region.left, initialRegion.left, 1, 'Task constrained left properly');
                next();
              }, {
                action: 'mouseUp'
              }, function (next) {
                // Must not have moved
                t.is(draggedEvent.startDate, startDate);
                t.is(draggedEvent.endDate, endDate);
                next();
              }, {
                drag: scheduler.eventSelector,
                by: [tickSize, 0],
                dragOnly: true
              }, function (next) {
                var region = t.rect('.b-dragging');
                t.isApprox(region.right, initialRegion.right, 1, 'Task constrained right properly');
                next();
              }, {
                action: 'mouseUp'
              }, function (next) {
                // Must not have moved
                t.is(draggedEvent.startDate, startDate);
                t.is(draggedEvent.endDate, endDate);
                doConstraining = false;
                next();
              }, // This drag should move the event
              {
                drag: scheduler.eventSelector,
                by: [-tickSize, 0],
                dragOnly: true
              }, function (next) {
                var region = t.rect('.b-dragging');
                t.isApprox(region.left, initialRegion.left - tickSize, 1, 'Task not constrained');
                next();
              }, {
                action: 'mouseUp'
              }, function (next) {
                // Must have moved
                t.is(draggedEvent.startDate, DateHelper.add(startDate, -1, 'day'));
                t.is(draggedEvent.endDate, DateHelper.add(endDate, -1, 'day'));
                doConstraining = false;
                next();
              }, // This drag should move the event
              {
                drag: scheduler.eventSelector,
                by: [tickSize * 2, 0],
                dragOnly: true
              }, function (next) {
                var region = t.rect('.b-dragging');
                t.isApprox(region.left, initialRegion.left + tickSize, 1, 'Task not constrained');
                next();
              }, {
                action: 'mouseUp'
              }, function () {
                // Must have moved
                t.is(draggedEvent.startDate, DateHelper.add(startDate, 1, 'day'));
                t.is(draggedEvent.endDate, DateHelper.add(endDate, 1, 'day'));
              });

            case 6:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x5) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should not be possible to drag event to group header', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var record;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return getScheduler({
                startDate: new Date(2011, 0, 3),
                viewPreset: 'hourAndDay',
                events: [{
                  id: 1,
                  name: 'Event',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 3, 4, 13, 18),
                  endDate: new Date(2011, 0, 3, 6)
                }],
                features: {
                  group: 'name',
                  eventDrag: true
                }
              });

            case 2:
              record = scheduler.eventStore.first;
              t.chain({
                drag: scheduler.eventSelector,
                to: '.b-grid-subgrid-normal .b-group-row',
                toOffset: [100, '50%']
              }, function () {
                t.notOk(record.isModified, 'Record has not been changed');
              });

            case 4:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x6) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Drag and drop with showExactDropPosition w/o snapRelativeToEventStartDate (horizontal)', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var tickSize, record;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return getScheduler({
                appendTo: document.body,
                startDate: new Date(2011, 0, 3),
                viewPreset: 'hourAndDay',
                events: [{
                  id: 1,
                  name: 'Event',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 3, 4, 13, 18),
                  endDate: new Date(2011, 0, 3, 6)
                }],
                features: {
                  eventDrag: {
                    showExactDropPosition: true
                  }
                }
              });

            case 2:
              tickSize = scheduler.timeAxisViewModel.tickSize, record = scheduler.eventStore.first;
              t.chain({
                drag: scheduler.eventSelector,
                by: [-0.2 * tickSize, 0]
              }, function (next) {
                t.is(record.startDate, new Date(2011, 0, 3, 4), 'Event hasn\'t changed place');
                next();
              }, {
                drag: scheduler.eventSelector,
                by: [-0.5 * tickSize, 0]
              }, function (next) {
                t.is(record.startDate, new Date(2011, 0, 3, 3, 30), 'Event changed place');
                next();
              }, {
                drag: scheduler.eventSelector,
                by: [-0.2 * tickSize, 0]
              }, function () {
                t.is(record.startDate, new Date(2011, 0, 3, 3, 30), 'Event hasn\'t changed place');
              });

            case 4:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x7) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Drag and drop with showExactDropPosition w/ snapRelativeToEventStartDate (horizontal)', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var tickSize, record;
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return getScheduler({
                startDate: new Date(2011, 0, 3),
                viewPreset: 'hourAndDay',
                events: [{
                  id: 1,
                  name: 'Event',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 3, 4, 13, 18),
                  endDate: new Date(2011, 0, 3, 6)
                }],
                features: {
                  eventDrag: {
                    showExactDropPosition: true
                  }
                },
                snapRelativeToEventStartDate: true
              });

            case 2:
              tickSize = scheduler.timeAxisViewModel.tickSize, record = scheduler.eventStore.first;
              t.chain({
                drag: scheduler.eventSelector,
                by: [0.2 * tickSize, 0]
              }, function (next) {
                t.is(record.startDate, new Date(2011, 0, 3, 4, 13, 18), 'Event hasn\'t changed place');
                next();
              }, {
                drag: scheduler.eventSelector,
                by: [0.5 * tickSize, 0]
              }, function (next) {
                t.is(record.startDate, new Date(2011, 0, 3, 4, 43, 18), 'Event changed place');
                next();
              }, {
                drag: scheduler.eventSelector,
                by: [0.2 * tickSize, 0]
              }, function () {
                t.is(record.startDate, new Date(2011, 0, 3, 4, 43, 18), 'Event hasn\'t changed place');
              });

            case 4:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x8) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Dragged event should follow mouse after scroll (horizontal)', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var startRect, draggedEvent;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return getScheduler({
                resourceStore: t.getResourceStore2({}, 30),
                features: {
                  eventDrag: true
                }
              });

            case 2:
              t.chain({
                drag: scheduler.eventSelector,
                by: [0, 30],
                dragOnly: true
              }, function (next) {
                draggedEvent = t.query('.b-dragging')[0];
                startRect = Rectangle.from(draggedEvent, scheduler.timeAxisSubGridElement);
                t.isApproxPx(startRect.y, 40, 1);
                next();
              }, function (next) {
                scheduler.timeAxisSubGridElement.scrollLeft = 100;
                next();
              }, function (next) {
                var rect = Rectangle.from(draggedEvent, scheduler.timeAxisSubGridElement);
                t.isApproxPx(rect.x, startRect.x, 1, 'Horizontal position hasn\'t changed');
                t.isApproxPx(rect.y, startRect.y, 1, 'Vertical position hasn\'t changed');
                next();
              }, {
                moveMouseBy: [[0, 30]]
              }, function (next) {
                var rect = Rectangle.from(draggedEvent, scheduler.timeAxisSubGridElement);
                t.isApproxPx(rect.x, startRect.x + scheduler.timeAxisSubGridElement.scrollLeft, 1, 'Horizontal position has changed according to scroll position');
                t.isApproxPx(rect.y, startRect.y + 30, 1, 'Vertical position hasn\'t changed');
                next();
              }, {
                action: 'mouseUp'
              });

            case 3:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x9) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('ScrollManager should not be activated until drag actually starts', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return getScheduler({
                width: 400,
                startDate: new Date(2017, 0, 1, 4),
                viewPreset: 'hourAndDay',
                resourceStore: t.getResourceStore2({}, 1),
                events: [{
                  resourceId: 'r1',
                  id: 1,
                  startDate: new Date(2017, 0, 1, 6),
                  endDate: new Date(2017, 0, 1, 8)
                }],
                features: {
                  eventDrag: true,
                  eventResize: false
                }
              });

            case 2:
              t.wontFire(scheduler, 'eventdragstart');
              t.wontFire(scheduler.subGrids.normal.scrollable, 'scroll');
              t.chain({
                drag: scheduler.eventSelector,
                by: [1, 0],
                fromOffset: ['100%-2', '50%'],
                dragOnly: true
              }, {
                waitFor: 500,
                desc: 'Waiting for some time to make sure ScrollManager is not activated'
              });

            case 5:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x10) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Should display correct drop position with snap (horizontal)', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var testBox;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return getScheduler({
                viewPreset: 'weekAndDayLetter',
                snap: true,
                features: {
                  eventDrag: {
                    showExactDropPosition: true
                  }
                },
                eventRenderer: function eventRenderer(_ref12) {
                  var eventRecord = _ref12.eventRecord,
                      resourceRecord = _ref12.resourceRecord,
                      renderData = _ref12.renderData;
                  renderData.cls['b-sch-event' + resourceRecord.id] = 1;
                  return eventRecord.name;
                }
              });

            case 2:
              t.chain({
                waitForSelector: '.b-sch-eventr1'
              }, function (next) {
                testBox = Rectangle.from(t.query('.b-sch-eventr1')[0]);
                next();
              }, // Grab it on the left because allowOver means that the center is occluded by the event tip
              {
                drag: '.b-sch-eventr1',
                offset: ['0%+15', '50%'],
                by: [10, 0],
                dragOnly: true
              }, {
                waitFor: function waitFor() {
                  var draggedElementBox = Rectangle.from(t.query('.b-dragging')[0]); // The snapping to increment should mean that the dragged element won't move only 10px.
                  // It has to be dragged past a snap point to jump to the next or previous day.

                  return Math.abs(draggedElementBox.x - testBox.x) < 1;
                },
                desc: 'Dragged element unmoved after dragging 10px right'
              }, {
                moveCursorBy: [[-20, 0]]
              }, {
                waitFor: function waitFor() {
                  var draggedElementBox = Rectangle.from(t.query('.b-dragging')[0]); // The snapping to increment should mean that the dragged element won't move only 10px.
                  // It has to be dragged past a snap point to jump to the next or previous day.

                  return Math.abs(draggedElementBox.x - testBox.x) < 1;
                },
                desc: 'Dragged element unmoved after subsequent drag 20px left'
              }, {
                action: 'mouseUp'
              });

            case 3:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x11) {
      return _ref11.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/394

  t.it('ScrollManager should keep working if mouse moves outside its monitored element', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      var normalScroller;
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return getScheduler({
                width: 400,
                startDate: new Date(2017, 0, 1, 4),
                viewPreset: 'hourAndDay',
                events: [{
                  resourceId: 'r1',
                  id: 1,
                  startDate: new Date(2017, 0, 1, 6),
                  endDate: new Date(2017, 0, 1, 8)
                }]
              });

            case 2:
              normalScroller = scheduler.subGrids.normal.scrollable;
              t.chain({
                drag: scheduler.eventSelector,
                to: scheduler.element,
                toOffset: ['100%-20', 100],
                dragOnly: true
              }, {
                moveCursorBy: [100, 0]
              }, {
                waitFor: function waitFor() {
                  return t.samePx(normalScroller.x, normalScroller.maxX);
                }
              }, {
                mouseUp: null
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11() {
                return regeneratorRuntime.wrap(function _callee11$(_context11) {
                  while (1) {
                    switch (_context11.prev = _context11.next) {
                      case 0:
                        return _context11.abrupt("return", t.wontFire(normalScroller, 'scroll'));

                      case 1:
                      case "end":
                        return _context11.stop();
                    }
                  }
                }, _callee11);
              })), {
                moveCursorTo: '.b-grid-cell',
                offset: ['100%+20', 100]
              }, {
                waitFor: 200,
                desc: 'No scrolling should be observed after mouseup'
              });

            case 4:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x12) {
      return _ref13.apply(this, arguments);
    };
  }());
});