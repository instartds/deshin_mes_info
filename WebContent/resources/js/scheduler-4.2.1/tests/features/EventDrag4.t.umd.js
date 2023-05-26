function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest({
  defaultTimeout: 90000
}, function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee30(config) {
      var scheduler;
      return regeneratorRuntime.wrap(function _callee30$(_context30) {
        while (1) {
          switch (_context30.prev = _context30.next) {
            case 0:
              scheduler = t.getScheduler(Object.assign({
                features: {
                  eventDrag: true
                }
              }, config));
              _context30.next = 3;
              return t.waitForProjectReady();

            case 3:
              return _context30.abrupt("return", scheduler);

            case 4:
            case "end":
              return _context30.stop();
          }
        }
      }, _callee30);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('dragging outside the rendered block', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var resources, events, event, layout, dragEl, schedulerRectangle, startPoint, newLocation, droppedOnResource, dragElMutationObserver;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.waitForScrolling = false;
              resources = ArrayHelper.populate(200, function (i) {
                return {
                  id: "r".concat(i + 1),
                  name: "Resource ".concat(i + 1)
                };
              }), events = ArrayHelper.populate(116, function (i) {
                return {
                  id: i + 2,
                  resourceId: "r".concat(i + 2),
                  name: "Event ".concat(i + 2),
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                };
              });
              events.unshift({
                id: 1,
                resourceId: 'r1',
                name: 'Drag Event',
                startDate: new Date(2011, 0, 4),
                endDate: new Date(2011, 0, 6)
              });
              scheduler = t.getScheduler({
                features: {
                  eventDrag: {
                    showTooltip: false
                  },
                  eventTooltip: false,
                  scheduleTooltip: false
                },
                resources: resources,
                events: events
              });
              _context.next = 6;
              return t.waitForProjectReady();

            case 6:
              event = scheduler.eventStore.first, layout = scheduler.currentOrientation, dragEl = scheduler.getElementFromEventRecord(event).parentNode, schedulerRectangle = Rectangle.from(scheduler.element), startPoint = Rectangle.from(dragEl).center;
              t.chain({
                mouseDown: dragEl
              }, function (next) {
                // Ensure that during the drag, the dragEl does not get mutated
                dragElMutationObserver = new MutationObserver(function () {
                  dragElMutationObserver.disconnect();
                  t.fail('Dragged element got mutated during drag');
                });
                dragElMutationObserver.observe(dragEl, {
                  characterData: true,
                  childList: true
                });
                next();
              }, // This will kick off scrolling
              {
                moveMouseTo: document.body,
                offset: [startPoint.x, schedulerRectangle.bottom - 20]
              }, {
                waitFor: function waitFor() {
                  return scheduler.rowManager.topIndex >= 100;
                },
                timeout: 40000,
                desc: 'Scrolling'
              }, {
                moveMouseTo: document.body,
                offset: [startPoint.x, schedulerRectangle.bottom - 100]
              }, function (next) {
                droppedOnResource = scheduler.resolveResourceRecord(t.elementFromPoint.apply(t, t.currentPosition));
                var row = scheduler.rowManager.getRowFor(droppedOnResource),
                    rowRectangle = Rectangle.from(row._elements.normal),
                    newLayout = layout.getTimeSpanRenderData(event, droppedOnResource);
                newLocation = new Rectangle(rowRectangle.x + newLayout.left, rowRectangle.y + newLayout.top, newLayout.width, newLayout.height);
                t.ok(dragEl.retainElement, 'Dragged element is retained'); // Disconnect observer. We expect content to change now

                dragElMutationObserver.disconnect(); // Edge and IE11 require some help to drop event to correct position. Moving mouse to the vertical center
                // of the target resource

                t.moveMouseTo([t.currentPosition[0], rowRectangle.y + rowRectangle.height / 2], next);
              }, {
                mouseUp: null
              }, // Wait for the drag element to settle into the calculated new position
              {
                waitFor: function waitFor() {
                  return t.sameRect(Rectangle.from(dragEl), newLocation);
                }
              }, function () {
                // The drag/dropped element is reused as the event's render el
                t.is(scheduler.getElementFromEventRecord(event).parentNode, dragEl);
                t.notOk(dragEl.retainElement, 'Dragged element is no longer retained');
              });

            case 8:
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
  t.it('dragging outside the rendered block with ESC to abort', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var resources, events, event, dragEl, schedulerRectangle, startPoint, eventEls, eventElRects, endingEventEls, endingEventElRects, dragElMutationObserver;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              t.waitForScrolling = false;
              resources = ArrayHelper.populate(200, function (i) {
                return {
                  id: "r".concat(i + 1),
                  name: "Resource ".concat(i + 1)
                };
              }), events = [{
                id: 1,
                resourceId: 'r1',
                name: 'Drag Event',
                startDate: new Date(2011, 0, 4),
                endDate: new Date(2011, 0, 6)
              }].concat(_toConsumableArray(ArrayHelper.populate(116, function (i) {
                return {
                  id: i + 2,
                  resourceId: "r".concat(i + 2),
                  name: "Event ".concat(i + 2),
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                };
              })));
              _context2.next = 4;
              return t.getSchedulerAsync({
                features: {
                  eventDrag: {
                    showTooltip: false
                  },
                  eventTooltip: false,
                  scheduleTooltip: false
                },
                resources: resources,
                events: events
              });

            case 4:
              scheduler = _context2.sent;
              event = scheduler.eventStore.first, dragEl = scheduler.getElementFromEventRecord(event).parentNode, schedulerRectangle = Rectangle.from(scheduler.element), startPoint = Rectangle.from(dragEl).center;
              t.chain({
                mouseDown: dragEl
              }, function (next) {
                // Ensure that during the drag, the dragEl does not get mutated
                dragElMutationObserver = new MutationObserver(function () {
                  dragElMutationObserver.disconnect();
                  t.fail('Dragged element got mutated during drag');
                });
                dragElMutationObserver.observe(dragEl, {
                  characterData: true,
                  childList: true
                });
                next();
              }, // This will kick off scrolling
              {
                moveMouseTo: document.body,
                offset: [startPoint.x, schedulerRectangle.bottom - 20]
              }, {
                waitFor: function waitFor() {
                  return scheduler.rowManager.topIndex >= 100;
                },
                timeout: 60000
              }, {
                moveCursorBy: [0, -80]
              }, function (next) {
                // The scheduler's rendered block should not change
                eventEls = scheduler.eventStore.reduce(function (result, event) {
                  var el = scheduler.getElementFromEventRecord(event);

                  if (el) {
                    result.push(el);
                  }

                  return result;
                }, []);
                eventElRects = eventEls.map(function (e) {
                  return Rectangle.from(e);
                });
                t.ok(dragEl.retainElement, 'Dragged element retained'); // Disconnect observer. We expect content to change now

                dragElMutationObserver.disconnect();
                next();
              }, {
                type: '[ESC]'
              }, {
                waitFor: function waitFor() {
                  endingEventEls = scheduler.eventStore.reduce(function (result, event) {
                    var el = scheduler.getElementFromEventRecord(event);

                    if (el) {
                      result.push(el);
                    }

                    return result;
                  }, []);
                  return endingEventEls.length === eventEls.length;
                }
              }, function () {
                endingEventElRects = endingEventEls.map(function (e) {
                  return Rectangle.from(e);
                }); // Same number of elements, and all in the same place.
                // TODO: Ask nige about this
                //                t.is(scheduler.timeAxisSubGridElement.querySelectorAll(scheduler.unreleasedEventSelector).length, eventEls.length);

                t.is(endingEventEls.length, eventEls.length); // Not the first one; that's the dragEl which will be in a different place by now

                for (var i = 1; i < eventEls.length; i++) {
                  t.ok(endingEventElRects[i].equals(eventElRects[i]), "Event ".concat(i, " correct"));
                }
              });

            case 7:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref2.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7120/details

  t.it('Should work with resources and events that has - in their id', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getScheduler({
                resources: [{
                  id: 'r-1',
                  name: 'Resource-1'
                }],
                events: [{
                  id: 'e-1',
                  resourceId: 'r-1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }]
              });

            case 2:
              scheduler = _context3.sent;
              t.chain({
                drag: '[data-event-id="e-1"]',
                by: [-100, 0]
              }, function () {
                t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 5), 'Drag worked');
              });

            case 4:
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
  t.it('Event should not disappear when dragging right', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return getScheduler({
                resources: [{
                  id: 1,
                  name: '1'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2018, 11, 6),
                  endDate: new Date(2018, 11, 7)
                }],
                startDate: new Date(2018, 11, 6),
                endDate: new Date(2018, 11, 30)
              });

            case 2:
              scheduler = _context4.sent;
              t.chain({
                drag: scheduler.eventSelector,
                to: '.b-scheduler',
                toOffset: ['100%-25', 70],
                dragOnly: true
              }, {
                waitFor: function waitFor() {
                  return scheduler.scrollLeft > 500;
                }
              }, function (next) {
                t.elementIsVisible(scheduler.eventSelector, 'Still visible');
                next();
              }, {
                mouseUp: null
              });

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x5) {
      return _ref4.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7307

  t.it('Event should not disappear when dragging right with assignment', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return getScheduler({
                resources: [{
                  id: 1,
                  name: '1'
                }],
                events: [{
                  id: 1,
                  startDate: new Date(2018, 11, 6),
                  endDate: new Date(2018, 11, 7)
                }],
                assignments: [{
                  eventId: 1,
                  resourceId: 1
                }],
                startDate: new Date(2018, 11, 6),
                endDate: new Date(2018, 11, 30)
              });

            case 2:
              scheduler = _context5.sent;
              t.chain({
                drag: scheduler.eventSelector,
                by: [850, 0],
                dragOnly: true
              }, {
                waitFor: function waitFor() {
                  return scheduler.scrollLeft > 500;
                }
              }, function (next) {
                t.elementIsVisible(scheduler.eventSelector, 'Still visible');
                next();
              }, {
                mouseUp: null
              });

            case 4:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x6) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('should not crash when clicking escape after mousedown which aborts drag', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return getScheduler({
                resources: [{
                  id: 1,
                  name: '1'
                }],
                events: [{
                  id: 1,
                  startDate: new Date(2018, 11, 6),
                  endDate: new Date(2018, 11, 7)
                }],
                assignments: [{
                  eventId: 1,
                  resourceId: 1
                }],
                startDate: new Date(2018, 11, 6),
                endDate: new Date(2018, 11, 30)
              });

            case 2:
              scheduler = _context6.sent;
              t.chain({
                mousedown: scheduler.eventSelector
              }, {
                type: '[ESCAPE]'
              }, {
                waitFor: 1000,
                desc: 'Make sure the async restore of drag proxy does not crash if drag did not start'
              });

            case 4:
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
  t.it('Should fire eventDragAbort if user aborts with Escape key', function (t) {
    scheduler = t.getScheduler();
    t.firesOnce(scheduler, 'eventDragAbort', 1);
    scheduler.on('eventDragAbort', function (_ref7) {
      var eventRecords = _ref7.eventRecords,
          context = _ref7.context;
      t.is(eventRecords.length, 1);
      t.isInstanceOf(eventRecords[0], scheduler.eventStore.modelClass);
      t.ok(context);
    });
    t.chain({
      drag: '.b-sch-event',
      by: [20, 0],
      dragOnly: true
    }, {
      type: '[ESCAPE]'
    });
  });
  t.it('Should be able to configure DragHelper using dragHelperConfig', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var eventX;
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return getScheduler({
                features: {
                  eventDrag: {
                    dragHelperConfig: {
                      lockX: true
                    }
                  }
                },
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }]
              });

            case 2:
              scheduler = _context7.sent;
              eventX = document.querySelector('.b-sch-event').getBoundingClientRect().left;
              t.chain({
                drag: '.b-sch-event',
                by: [200, 200],
                dragOnly: true
              }, function () {
                var proxyX = document.querySelector('.b-sch-event').getBoundingClientRect().left;
                t.is(proxyX, eventX, 'Constrain worked');
              });

            case 5:
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
  t.it('Drag and drop with constrainDragToTimeSlot', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var _scheduler, tickSize, draggedEvent, startDate, endDate;

      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return getScheduler({
                startDate: new Date(2011, 0, 3),
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }],
                features: {
                  eventDrag: {
                    constrainDragToTimeSlot: true
                  }
                }
              });

            case 2:
              scheduler = _context8.sent;
              _scheduler = scheduler, tickSize = _scheduler.tickSize, draggedEvent = scheduler.eventStore.first, startDate = draggedEvent.startDate, endDate = draggedEvent.endDate;
              t.willFireNTimes(scheduler.eventStore, 'change', 1);
              t.chain(function (next) {
                t._region = document.querySelector(scheduler.eventSelector).getBoundingClientRect();
                next();
              }, {
                drag: scheduler.eventSelector,
                by: [-tickSize, 0],
                dragOnly: true
              }, function (next) {
                var region = document.querySelector('.b-dragging').getBoundingClientRect();
                t.isApprox(region.left, t._region.left, 1, 'Task constrained left properly');
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
                var region = document.querySelector('.b-dragging').getBoundingClientRect();
                t.isApprox(region.right, t._region.right, 1, 'Task constrained right properly');
                next();
              }, {
                action: 'mouseUp'
              }, function (next) {
                // Must not have moved
                t.is(draggedEvent.startDate, startDate);
                t.is(draggedEvent.endDate, endDate);
                next();
              }, // This drag should move the event down
              {
                drag: scheduler.eventSelector,
                by: [0, scheduler.rowHeight]
              }, function () {
                t.is(draggedEvent.startDate, startDate);
                t.is(draggedEvent.endDate, endDate);
                t.is(draggedEvent.resourceId, 'r2');
              });

            case 6:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x9) {
      return _ref9.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/630

  t.xit('Drag and drop with fillTicks', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      var origLeft;
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return getScheduler({
                startDate: new Date(2011, 0, 3),
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6, 10),
                  endDate: new Date(2011, 0, 6, 14)
                }],
                minHeight: '20em',
                viewPreset: 'dayAndWeek',
                rowHeight: 60,
                barMargin: 5,
                fillTicks: true,
                eventStyle: 'colored',
                eventRenderer: function eventRenderer(_ref11) {
                  var eventRecord = _ref11.eventRecord;
                  return "           \n                    <div>\n                    <span>".concat(DateHelper.format(eventRecord.startDate, 'LT'), "</span>\n                    ").concat(eventRecord.name, "\n                    </div>\n                ");
                }
              });

            case 2:
              scheduler = _context11.sent;
              t.chain({
                waitForSelector: '.b-sch-event'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9() {
                return regeneratorRuntime.wrap(function _callee9$(_context9) {
                  while (1) {
                    switch (_context9.prev = _context9.next) {
                      case 0:
                        return _context9.abrupt("return", origLeft = t.rect('.b-sch-event').left);

                      case 1:
                      case "end":
                        return _context9.stop();
                    }
                  }
                }, _callee9);
              })), {
                drag: '.b-sch-event',
                by: [5, 0]
              }, {
                waitForSelectorNotFound: '.b-dragging-event'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10() {
                return regeneratorRuntime.wrap(function _callee10$(_context10) {
                  while (1) {
                    switch (_context10.prev = _context10.next) {
                      case 0:
                        return _context10.abrupt("return", t.is(t.rect('.b-sch-event').left, origLeft, 'Event rendered in correct position'));

                      case 1:
                      case "end":
                        return _context10.stop();
                    }
                  }
                }, _callee10);
              })));

            case 4:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x10) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Should transition aborted drag on filtered timeaxis', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      var transitioned;
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return getScheduler({
                timeAxis: {
                  filters: function filters(tick) {
                    return tick.startDate.getDay() !== 1;
                  }
                },
                subGridConfigs: {
                  locked: {
                    width: 200
                  }
                }
              });

            case 2:
              scheduler = _context12.sent;
              transitioned = false;
              scheduler.timeAxisSubGridElement.addEventListener('transitionstart', function (event) {
                if (event.propertyName === 'transform') {
                  transitioned = true;
                }
              });
              _context12.next = 7;
              return t.dragBy({
                source: scheduler.unreleasedEventSelector,
                delta: [-250, 0]
              });

            case 7:
              _context12.next = 9;
              return t.waitFor(function () {
                return transitioned;
              });

            case 9:
              t.is(scheduler.eventStore.first.startDate, scheduler.startDate, 'Event drag is cancelled');

            case 10:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x11) {
      return _ref14.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1286

  t.it('Should be possible to drag narrow event', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return getScheduler({
                startDate: new Date(2017, 0, 1, 6),
                endDate: new Date(2017, 0, 1, 20),
                viewPreset: 'hourAndDay',
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  resizable: false,
                  startDate: new Date(2017, 0, 1, 10),
                  duration: 0.006
                }]
              });

            case 2:
              scheduler = _context13.sent;
              t.firesOnce(scheduler, 'aftereventdrop');
              t.chain({
                drag: scheduler.unreleasedEventSelector,
                by: [scheduler.tickSize, 0]
              }, function () {
                t.is(scheduler.eventStore.first.startDate, new Date(2017, 0, 1, 11), 'Event moved');
              });

            case 5:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x12) {
      return _ref15.apply(this, arguments);
    };
  }());
  t.it('Should not animate dragged elements as a side effect of external changes to data being animated', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              // Make a long transition so we can determine that it removes slowly
              CSSHelper.insertRule('#animation-state-test-scheduler .b-sch-event-wrap { transition-duration: 5s !important; }');
              _context15.next = 3;
              return getScheduler({
                id: 'animation-state-test-scheduler',
                transitionDuration: 5000,
                startDate: new Date(2017, 0, 1, 10),
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2017, 0, 1, 10),
                  duration: 1
                }, {
                  id: 2,
                  resourceId: 'r2',
                  startDate: new Date(2017, 0, 1, 10),
                  duration: 1
                }]
              });

            case 3:
              scheduler = _context15.sent;
              t.chain({
                drag: scheduler.unreleasedEventSelector,
                by: [100, 0],
                dragOnly: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14() {
                return regeneratorRuntime.wrap(function _callee14$(_context14) {
                  while (1) {
                    switch (_context14.prev = _context14.next) {
                      case 0:
                        t.firesOnce(scheduler.timeAxisSubGridElement, 'transitionstart'); // Fake an external change, which should be animated

                        scheduler.eventStore.last.duration = 4;

                      case 2:
                      case "end":
                        return _context14.stop();
                    }
                  }
                }, _callee14);
              })), {
                moveCursorBy: [100, 0]
              }, {
                moveCursorBy: [100, 0]
              }, {
                moveCursorBy: [100, 0]
              }, {
                moveCursorBy: [100, 0]
              }, {
                moveCursorBy: [100, 0]
              });

            case 5:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x13) {
      return _ref16.apply(this, arguments);
    };
  }());
  t.it('Should animate dragged elements drop is finalized', /*#__PURE__*/function () {
    var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return getScheduler({
                rowHeight: 60,
                startDate: new Date(2017, 0, 1, 10),
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2017, 0, 1, 10),
                  duration: 1
                }]
              });

            case 2:
              scheduler = _context16.sent;
              t.chain({
                drag: scheduler.unreleasedEventSelector,
                by: [0, 40],
                dragOnly: true
              }, {
                mouseUp: null
              }, {
                waitForEvent: [scheduler.timeAxisSubGridElement, 'transitionend']
              });

            case 4:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x14) {
      return _ref18.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2381

  t.it('Should be possible to drag event in left edge when it only allows resizing its end date', /*#__PURE__*/function () {
    var _ref19 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return getScheduler({
                startDate: new Date(2017, 0, 1, 10),
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2017, 0, 1, 10),
                  duration: 1,
                  resizable: 'end'
                }]
              });

            case 2:
              scheduler = _context17.sent;
              t.wontFire(scheduler, 'eventresizestart');
              t.firesOnce(scheduler, 'aftereventdrop');
              t.chain({
                drag: scheduler.unreleasedEventSelector,
                by: [0, 40],
                offset: [2, '50%']
              });

            case 6:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x15) {
      return _ref19.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/893

  t.it('Event proxy is updated correctly on page scroll', /*#__PURE__*/function () {
    var _ref20 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(t) {
      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              _context20.next = 2;
              return t.getSchedulerAsync({
                resourceStore: new ResourceStore({
                  data: function () {
                    var result = [];

                    for (var i = 1; i <= 100; i++) {
                      result.push({
                        id: i,
                        name: "Resource ".concat(i)
                      });
                    }

                    return result;
                  }()
                }),
                eventStore: new EventStore({
                  data: [{
                    id: 1,
                    resourceId: 10,
                    name: 'Event',
                    startDate: '2011-01-05',
                    endDate: '2011-01-09'
                  }]
                })
              });

            case 2:
              scheduler = _context20.sent;
              t.chain({
                waitForSelector: '.b-sch-event'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18() {
                return regeneratorRuntime.wrap(function _callee18$(_context18) {
                  while (1) {
                    switch (_context18.prev = _context18.next) {
                      case 0:
                        scheduler.scrollable.y = 100;
                        _context18.next = 3;
                        return scheduler.scrollable.await('scrollEnd');

                      case 3:
                      case "end":
                        return _context18.stop();
                    }
                  }
                }, _callee18);
              })), {
                drag: '.b-sch-event',
                by: [100, 0],
                dragOnly: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19() {
                var box, newBox;
                return regeneratorRuntime.wrap(function _callee19$(_context19) {
                  while (1) {
                    switch (_context19.prev = _context19.next) {
                      case 0:
                        box = t.rect('.b-sch-event-wrap');
                        _context19.next = 3;
                        return scheduler.scrollVerticallyTo(135);

                      case 3:
                        newBox = t.rect('.b-sch-event-wrap');
                        t.is(newBox.top, box.top, 'Drag proxy is updated');

                      case 5:
                      case "end":
                        return _context19.stop();
                    }
                  }
                }, _callee19);
              })), {
                mouseUp: null
              });

            case 4:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    }));

    return function (_x16) {
      return _ref20.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2528

  t.it('Should support snap with noncontinuous timeaxis', /*#__PURE__*/function () {
    var _ref23 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21(t) {
      return regeneratorRuntime.wrap(function _callee21$(_context21) {
        while (1) {
          switch (_context21.prev = _context21.next) {
            case 0:
              _context21.next = 2;
              return t.getSchedulerAsync({
                eventStore: new EventStore({
                  data: [{
                    id: 1,
                    resourceId: 'r1',
                    name: 'Event',
                    startDate: '2011-01-05T09:00:00',
                    endDate: '2011-01-05T11:00:00'
                  }]
                }),
                startDate: new Date(2011, 0, 5),
                endDate: new Date(2011, 0, 6),
                snap: true,
                viewPreset: 'hourAndDay',
                timeResolution: 15,
                tickSize: 100,
                columns: [{
                  text: 'Name',
                  field: 'name'
                }],
                timeAxis: {
                  continuous: false,
                  generateTicks: function generateTicks(start, end, unit, increment) {
                    var ticks = [];

                    while (start < end) {
                      if (unit !== 'hour' || start.getHours() >= 8 && start.getHours() <= 22) {
                        ticks.push({
                          id: ticks.length + 1,
                          startDate: start,
                          endDate: DateHelper.add(start, increment, unit)
                        });
                      }

                      start = DateHelper.add(start, increment, unit);
                    }

                    return ticks;
                  }
                }
              });

            case 2:
              scheduler = _context21.sent;
              t.chain({
                drag: '.b-sch-event',
                by: [30, 0],
                dragOnly: true
              }, function () {
                t.contentLike('.b-sch-tooltip-startdate .b-sch-clock-text', '9:15', 'Snapped to 9:15');
              });

            case 4:
            case "end":
              return _context21.stop();
          }
        }
      }, _callee21);
    }));

    return function (_x17) {
      return _ref23.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2530

  t.it('Should snap event start to next tick if dropped at a filtered out start position', /*#__PURE__*/function () {
    var _ref24 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
      return regeneratorRuntime.wrap(function _callee22$(_context22) {
        while (1) {
          switch (_context22.prev = _context22.next) {
            case 0:
              _context22.next = 2;
              return t.getSchedulerAsync({
                eventStore: new EventStore({
                  data: [{
                    id: 1,
                    resourceId: 'r1',
                    name: 'Event',
                    startDate: '2011-01-05T21:00:00',
                    endDate: '2011-01-05T22:00:00'
                  }]
                }),
                startDate: new Date(2011, 0, 5),
                endDate: new Date(2011, 0, 8),
                columns: [{
                  text: 'Name',
                  field: 'name'
                }],
                viewPreset: {
                  displayDateFormat: 'H:mm',
                  tickWidth: 25,
                  shiftIncrement: 1,
                  shiftUnit: 'WEEK',
                  timeResolution: {
                    unit: 'MINUTE',
                    increment: 60
                  },
                  headers: [{
                    unit: 'DAY',
                    align: 'center',
                    dateFormat: 'ddd L'
                  }, {
                    unit: 'HOUR',
                    align: 'center',
                    dateFormat: 'H'
                  }]
                },
                timeAxis: {
                  continuous: false,
                  generateTicks: function generateTicks(start, end, unit, increment) {
                    var ticks = [];

                    while (start < end) {
                      if (unit !== 'hour' || start.getHours() >= 8 && start.getHours() <= 21) {
                        ticks.push({
                          id: ticks.length + 1,
                          startDate: start,
                          endDate: DateHelper.add(start, increment, unit)
                        });
                      }

                      start = DateHelper.add(start, increment, unit);
                    }

                    return ticks;
                  }
                }
              });

            case 2:
              scheduler = _context22.sent;
              t.chain({
                drag: scheduler.unreleasedEventSelector,
                by: [15, 0]
              }, function () {
                t.selectorExists(scheduler.unreleasedEventSelector, 'Event still rendered');
                t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 6, 8), 'Event snapped to next tick start');
              });

            case 4:
            case "end":
              return _context22.stop();
          }
        }
      }, _callee22);
    }));

    return function (_x18) {
      return _ref24.apply(this, arguments);
    };
  }());
  t.it('should work crossing TimeAxis window boundaries', /*#__PURE__*/function () {
    var _ref25 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23(t) {
      var timeAxisChangeCount, event;
      return regeneratorRuntime.wrap(function _callee23$(_context23) {
        while (1) {
          switch (_context23.prev = _context23.next) {
            case 0:
              timeAxisChangeCount = 0;
              _context23.next = 3;
              return getScheduler({
                infiniteScroll: true,
                resources: [{
                  id: 1,
                  name: '1'
                }],
                events: [{
                  id: 1,
                  startDate: new Date(2018, 11, 6),
                  endDate: new Date(2018, 11, 7)
                }],
                assignments: [{
                  eventId: 1,
                  resourceId: 1
                }],
                startDate: new Date(2018, 11, 6),
                endDate: new Date(2018, 11, 30),
                listeners: {
                  timeaxischange: function timeaxischange() {
                    timeAxisChangeCount++;
                  }
                }
              });

            case 3:
              scheduler = _context23.sent;
              event = scheduler.eventStore.first; // So that the drag snaps to a day boundary making test reliable

              scheduler.timeAxis.resolutionUnit = 'day';
              _context23.next = 8;
              return t.mouseDown(scheduler.eventSelector);

            case 8:
              _context23.next = 10;
              return t.moveMouseTo(scheduler.timeAxisSubGridElement, null, null, [scheduler.timeAxisSubGridElement.offsetWidth - 10, 25]);

            case 10:
              _context23.next = 12;
              return t.waitFor(function () {
                return timeAxisChangeCount === 2;
              });

            case 12:
              _context23.next = 14;
              return t.mouseUp();

            case 14:
              t.isGreaterOrEqual(event.startDate, new Date(2019, 0, 26), 'Dragged into future time axis frame');

            case 15:
            case "end":
              return _context23.stop();
          }
        }
      }, _callee23);
    }));

    return function (_x19) {
      return _ref25.apply(this, arguments);
    };
  }());
  t.it('Should be possible to use custom tooltipTemplate', /*#__PURE__*/function () {
    var _ref26 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee24(t) {
      var _scheduler$eventStore, startDate, endDate;

      return regeneratorRuntime.wrap(function _callee24$(_context24) {
        while (1) {
          switch (_context24.prev = _context24.next) {
            case 0:
              _context24.next = 2;
              return t.getScheduler({
                features: {
                  eventDrag: {
                    // Custom tooltip for when an event is dragged
                    tooltipTemplate: function tooltipTemplate(_ref27) {
                      var eventRecord = _ref27.eventRecord,
                          newStartDate = _ref27.startDate,
                          newEndDate = _ref27.endDate;
                      t.is(eventRecord, scheduler.eventStore.first, 'eventRecord date ok');
                      t.isGreaterOrEqual(newStartDate, startDate, 'Start date ok');
                      t.isGreaterOrEqual(newEndDate, endDate, 'End date ok');
                      return 'foo';
                    }
                  }
                }
              });

            case 2:
              scheduler = _context24.sent;
              _scheduler$eventStore = scheduler.eventStore.first, startDate = _scheduler$eventStore.startDate, endDate = _scheduler$eventStore.endDate;
              t.chain({
                drag: scheduler.unreleasedEventSelector,
                by: [100, 0],
                dragOnly: true
              }, function () {
                t.selectorExists('.b-tooltip:contains(foo)', 'Custom tooltip used');
              });

            case 5:
            case "end":
              return _context24.stop();
          }
        }
      }, _callee24);
    }));

    return function (_x20) {
      return _ref26.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2882

  t.it('Should snap all dragged events when dragging multiple', /*#__PURE__*/function () {
    var _ref28 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee25(t) {
      return regeneratorRuntime.wrap(function _callee25$(_context25) {
        while (1) {
          switch (_context25.prev = _context25.next) {
            case 0:
              _context25.next = 2;
              return t.getScheduler({
                multiEventSelect: true,
                snap: true,
                timeResolution: {
                  increment: 1,
                  unit: 'day'
                },
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'source',
                  startDate: '2011-01-05',
                  endDate: '2011-01-07'
                }, {
                  id: 2,
                  resourceId: 'r2',
                  name: 'extra',
                  startDate: '2011-01-05',
                  endDate: '2011-01-07'
                }]
              });

            case 2:
              scheduler = _context25.sent;
              scheduler.selectedEvents = scheduler.eventStore.records;
              _context25.next = 6;
              return t.dragBy(scheduler.unreleasedEventSelector, [40, 0], null, null, null, true);

            case 6:
              t.is(t.rect('.b-sch-event:contains(source)').left, t.rect('.b-sch-event:contains(extra)').left, 'Events aligned before snap');
              _context25.next = 9;
              return t.moveCursorBy([40, 0]);

            case 9:
              t.is(t.rect('.b-sch-event:contains(source)').left, t.rect('.b-sch-event:contains(extra)').left, 'Events aligned after snap');
              _context25.next = 12;
              return t.moveCursorBy([40, 0]);

            case 12:
              t.is(t.rect('.b-sch-event:contains(source)').left, t.rect('.b-sch-event:contains(extra)').left, 'Events aligned after moving past first snap point');
              _context25.next = 15;
              return t.mouseUp();

            case 15:
            case "end":
              return _context25.stop();
          }
        }
      }, _callee25);
    }));

    return function (_x21) {
      return _ref28.apply(this, arguments);
    };
  }());
  t.it('Should snap to correct date when moving cursor to point 0 on timeaxis', /*#__PURE__*/function () {
    var _ref29 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee26(t) {
      return regeneratorRuntime.wrap(function _callee26$(_context26) {
        while (1) {
          switch (_context26.prev = _context26.next) {
            case 0:
              _context26.next = 2;
              return t.getScheduler({
                viewPreset: 'hourAndDay',
                rowHeight: 50,
                barMargin: 5,
                multiEventSelect: true,
                snap: true,
                startDate: new Date(2011, 0, 5, 8),
                endDate: new Date(2011, 0, 5, 18),
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 130
                }],
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'source',
                  startDate: '2011-01-05T08:00:00',
                  endDate: '2011-01-05T12:00:00'
                }]
              });

            case 2:
              scheduler = _context26.sent;
              t.firesOnce(scheduler.eventStore, 'update');
              _context26.next = 6;
              return t.dragBy(scheduler.unreleasedEventSelector, [-scheduler.tickSize, 0]);

            case 6:
              t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 5, 7), 'startDate updated');

            case 7:
            case "end":
              return _context26.stop();
          }
        }
      }, _callee26);
    }));

    return function (_x22) {
      return _ref29.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2919

  t.it('Should handle events being removed after mousedown before starting drag', /*#__PURE__*/function () {
    var _ref30 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee27(t) {
      return regeneratorRuntime.wrap(function _callee27$(_context27) {
        while (1) {
          switch (_context27.prev = _context27.next) {
            case 0:
              _context27.next = 2;
              return t.getSchedulerAsync({
                multiEventSelect: true,
                eventStore: new EventStore({
                  data: [{
                    id: 1,
                    resourceId: 'r1',
                    name: 'Event',
                    startDate: '2011-01-05T21:00:00',
                    endDate: '2011-01-05T22:00:00'
                  }, {
                    id: 2,
                    resourceId: 'r1',
                    name: 'Event',
                    startDate: '2011-01-05T21:00:00',
                    endDate: '2011-01-05T22:00:00'
                  }]
                }),
                startDate: new Date(2011, 0, 5),
                endDate: new Date(2011, 0, 8),
                columns: [{
                  text: 'Name',
                  field: 'name'
                }]
              });

            case 2:
              scheduler = _context27.sent;
              scheduler.selectedEvents = scheduler.eventStore.records;
              t.wontFire(scheduler, 'beforeEventDrag');
              _context27.next = 7;
              return t.mouseDown('.b-sch-event');

            case 7:
              scheduler.eventStore.removeAll();
              _context27.next = 10;
              return t.moveCursorBy([100, 0]);

            case 10:
            case "end":
              return _context27.stop();
          }
        }
      }, _callee27);
    }));

    return function (_x23) {
      return _ref30.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2928

  t.it('Should handle all events being removed after dragging to invalid drop position', /*#__PURE__*/function () {
    var _ref31 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee28(t) {
      return regeneratorRuntime.wrap(function _callee28$(_context28) {
        while (1) {
          switch (_context28.prev = _context28.next) {
            case 0:
              _context28.next = 2;
              return t.getSchedulerAsync({
                multiEventSelect: true,
                eventStore: new EventStore({
                  data: [{
                    id: 1,
                    resourceId: 'r1',
                    name: 'Event 1',
                    startDate: '2011-01-05T19:00:00',
                    endDate: '2011-01-07T22:00:00'
                  }, {
                    id: 2,
                    resourceId: 'r2',
                    name: 'Event 2',
                    startDate: '2011-01-05T14:00:00',
                    endDate: '2011-01-06T22:00:00'
                  }, {
                    id: 3,
                    resourceId: 'r2',
                    name: 'Event',
                    startDate: '2011-01-05T21:00:00',
                    endDate: '2011-01-05T22:00:00'
                  }, {
                    id: 4,
                    resourceId: 'r3',
                    name: 'foo',
                    startDate: '2011-01-05T21:00:00',
                    endDate: '2011-01-05T22:00:00'
                  }]
                }),
                startDate: new Date(2011, 0, 5),
                endDate: new Date(2011, 0, 8),
                columns: [{
                  text: 'Name',
                  field: 'name'
                }]
              });

            case 2:
              scheduler = _context28.sent;
              t.firesOnce(scheduler, 'eventDragAbort');
              scheduler.selectedEvents = scheduler.eventStore.records.slice(0, 2);
              _context28.next = 7;
              return t.dragTo('.b-sch-event:contains(Event 1)', '.b-grid-row', null, null, null, true, ['100%-30', '50%']);

            case 7:
              scheduler.eventStore.data = [];
              _context28.next = 10;
              return t.waitForSelectorNotFound(scheduler.unreleasedEventSelector + ':contains(foo)');

            case 10:
              _context28.next = 12;
              return t.mouseUp();

            case 12:
              _context28.next = 14;
              return t.waitForSelectorNotFound(scheduler.unreleasedEventSelector);

            case 14:
            case "end":
              return _context28.stop();
          }
        }
      }, _callee28);
    }));

    return function (_x24) {
      return _ref31.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2928

  t.it('Should handle some events being removed after dragging to invalid drop position', /*#__PURE__*/function () {
    var _ref32 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee29(t) {
      return regeneratorRuntime.wrap(function _callee29$(_context29) {
        while (1) {
          switch (_context29.prev = _context29.next) {
            case 0:
              _context29.next = 2;
              return t.getSchedulerAsync({
                multiEventSelect: true,
                eventStore: new EventStore({
                  data: [{
                    id: 1,
                    resourceId: 'r1',
                    name: 'Event 1',
                    startDate: '2011-01-05T19:00:00',
                    endDate: '2011-01-07T22:00:00'
                  }, {
                    id: 2,
                    resourceId: 'r2',
                    name: 'Event 2',
                    startDate: '2011-01-05T14:00:00',
                    endDate: '2011-01-06T22:00:00'
                  }, {
                    id: 3,
                    resourceId: 'r2',
                    name: 'Event',
                    startDate: '2011-01-05T21:00:00',
                    endDate: '2011-01-06T22:00:00'
                  }, {
                    id: 4,
                    resourceId: 'r3',
                    name: 'foo',
                    startDate: '2011-01-05T21:00:00',
                    endDate: '2011-01-06T22:00:00'
                  }]
                }),
                startDate: new Date(2011, 0, 5),
                endDate: new Date(2011, 0, 8),
                columns: [{
                  text: 'Name',
                  field: 'name'
                }]
              });

            case 2:
              scheduler = _context29.sent;
              t.firesOnce(scheduler, 'eventDragAbort');
              scheduler.selectedEvents = scheduler.eventStore.records.slice(0, 2);
              _context29.next = 7;
              return t.dragTo('.b-sch-event:contains(Event 1)', '.b-grid-row', null, null, null, true, ['100%-30', '50%']);

            case 7:
              scheduler.eventStore.getById(2).remove();
              _context29.next = 10;
              return t.mouseUp();

            case 10:
              _context29.next = 12;
              return t.waitForSelectorNotFound(scheduler.unreleasedEventSelector + ':contains(Event 2)');

            case 12:
              _context29.next = 14;
              return t.dragBy('.b-sch-event:contains(Event 1)', [100, 0]);

            case 14:
            case "end":
              return _context29.stop();
          }
        }
      }, _callee29);
    }));

    return function (_x25) {
      return _ref32.apply(this, arguments);
    };
  }());
});