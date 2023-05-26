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
    scheduler && !scheduler.isDestroyed && scheduler.destroy();
    document.body.innerHTML = '';
  });
  t.it('Animation state should persist until the last requested animated update has finished', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var transitionEndCounter, event1, event2, oneDay;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              // Make a long transition so we can determine that it moves slowly
              CSSHelper.insertRule('#animation-state-test-scheduler .b-sch-event-wrap { transition-duration: 2s !important; }');
              transitionEndCounter = 0;
              scheduler = new Scheduler({
                appendTo: document.body,
                transitionDuration: 2000,
                enableEventAnimations: true,
                // Needs explicitly configuring because IE11 turns animations off
                id: 'animation-state-test-scheduler',
                resources: [{
                  id: 1,
                  name: 'First'
                }, {
                  id: 2,
                  name: 'Second'
                }],
                viewPreset: 'dayAndWeek',
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2018, 2, 31),
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: '2018-01-01',
                  endDate: '2018-01-03'
                }, {
                  id: 2,
                  resourceId: 2,
                  startDate: '2018-01-02',
                  endDate: '2018-01-04'
                }],
                listeners: {
                  transitionend: function transitionend() {
                    transitionEndCounter++;
                  }
                }
              });
              _context6.next = 5;
              return t.waitForProjectReady();

            case 5:
              event1 = scheduler.eventStore.first, event2 = scheduler.eventStore.getAt(1), oneDay = 1000 * 60 * 60 * 24;
              t.chain({
                waitForSelector: '.b-sch-event'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        _context.next = 2;
                        return event1.setStartDate(new Date(event1.startDate.valueOf() + oneDay));

                      case 2:
                        t.ok(scheduler.isAnimating);

                      case 3:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })), {
                waitFor: 100
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        _context2.next = 2;
                        return event2.setStartDate(new Date(event2.startDate.valueOf() + oneDay));

                      case 2:
                        t.ok(scheduler.isAnimating, 'Scheduler is still in animating state');
                        t.is(transitionEndCounter, 0, 'Scheduler is still in animating state');

                      case 4:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              })), {
                waitFor: 200
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        event1.setStartDate(new Date(event1.startDate.valueOf() - oneDay));
                        t.ok(scheduler.isAnimating, 'Scheduler is still in animating state');
                        t.is(transitionEndCounter, 0, 'Scheduler is still in animating state');

                      case 3:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3);
              })), {
                waitFor: 200
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
                return regeneratorRuntime.wrap(function _callee4$(_context4) {
                  while (1) {
                    switch (_context4.prev = _context4.next) {
                      case 0:
                        event2.setStartDate(new Date(event2.startDate.valueOf() - oneDay));
                        t.ok(scheduler.isAnimating, 'Scheduler is still in animating state');
                        t.is(transitionEndCounter, 0, 'Scheduler is still in animating state');

                      case 3:
                      case "end":
                        return _context4.stop();
                    }
                  }
                }, _callee4);
              })), {
                waitFor: 200
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
                return regeneratorRuntime.wrap(function _callee5$(_context5) {
                  while (1) {
                    switch (_context5.prev = _context5.next) {
                      case 0:
                        t.ok(scheduler.isAnimating, 'Scheduler is still in animating state');
                        t.is(transitionEndCounter, 0, 'Scheduler is still in animating state');

                      case 2:
                      case "end":
                        return _context5.stop();
                    }
                  }
                }, _callee5);
              })), // Give some time for the animation to come to a halt, possibly several times
              // if there's ever a regression...
              {
                waitFor: 3000
              }, function () {
                t.is(transitionEndCounter, 1, 'Only exited animating state once');
              });

            case 7:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Horizontal scroll: Virtual event rendering', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                id: 'test',
                resources: [{
                  id: 1,
                  name: 'First'
                }],
                viewPreset: 'dayAndWeek',
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2018, 2, 31),
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: '2018-01-01',
                  endDate: '2018-01-03'
                }, {
                  id: 2,
                  resourceId: 1,
                  startDate: '2018-03-01',
                  endDate: '2018-03-03'
                }],
                listeners: {
                  // Initially visible event
                  renderEvent: function renderEvent(_ref8) {
                    var eventRecord = _ref8.eventRecord,
                        element = _ref8.element;
                    t.is(eventRecord.id, 1, 'renderEvent eventRecord param correct');
                    t.is(element, document.querySelector('[data-event-id="1"]'), 'renderEvent element param correct');
                  },
                  once: true
                }
              });
              _context7.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Only one event displayed initially');
              t.selectorNotExists('[data-event-id="2"]');
              t.firesOnce(scheduler, 'renderevent', 'renderEvent triggered'); // Triggered when second event is scrolled into view
              // Second event when it is scrolled into view

              scheduler.on({
                renderEvent: function renderEvent(_ref9) {
                  var eventRecord = _ref9.eventRecord,
                      element = _ref9.element;
                  t.is(eventRecord.id, 2, 'renderEvent eventRecord param correct');
                  t.is(element, document.querySelector('[data-event-id="2"]'), 'renderEvent element param correct');
                }
              });
              scheduler.scrollEventIntoView(scheduler.events[1]);
              t.chain({
                waitForSelector: '[data-event-id="2"]'
              }, function () {
                t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Only one event displayed after scroll');
              });

            case 9:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x2) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Horizontal scroll: Should rerender event body correctly', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                eventRenderer: function eventRenderer(_ref11) {
                  var eventRecord = _ref11.eventRecord;
                  return eventRecord.name;
                },
                // disable encodeHtml
                resources: [{
                  id: 1,
                  name: 'First'
                }, {
                  id: 2,
                  name: 'Second'
                }],
                viewPreset: 'dayAndWeek',
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2018, 0, 31),
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: '2018-01-01T00:00',
                  endDate: '2018-01-04T00:00',
                  name: '<div>1</div><span>1</span>'
                }, {
                  id: 2,
                  resourceId: 1,
                  startDate: '2018-01-28T00:00',
                  endDate: '2018-01-31T00:00',
                  name: '2'
                }, {
                  id: 3,
                  resourceId: 2,
                  startDate: '2018-01-01T00:00',
                  endDate: '2018-01-04T00:00',
                  name: '<div>1</div><span>1</span>'
                }, {
                  id: 4,
                  resourceId: 2,
                  startDate: '2018-01-28T00:00',
                  endDate: '2018-01-31T00:00',
                  name: '2'
                }]
              });
              _context8.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.willFireNTimes(scheduler, 'renderevent', 4);
              t.chain({
                waitForSelector: '[data-event-id="1"]:contains(11)'
              }, {
                waitForSelector: '[data-event-id="3"]:contains(11)'
              }, {
                waitForAnimationFrame: null
              }, //() => scheduler.scrollEventIntoView(scheduler.events[1]),
              function (next) {
                scheduler.scrollEventIntoView(scheduler.events[1]).then(function () {
                  return next();
                });
              }, {
                waitForSelector: '[data-event-id="2"]:contains(2)'
              }, {
                waitForSelector: '[data-event-id="4"]:contains(2)'
              }, {
                waitForAnimationFrame: null
              }, //() => scheduler.scrollEventIntoView(scheduler.events[0]),
              function (next) {
                scheduler.scrollEventIntoView(scheduler.events[0]).then(function () {
                  return next();
                });
              }, {
                waitForSelector: '[data-event-id="1"]:contains(11)'
              }, {
                waitForSelector: '[data-event-id="3"]:contains(11)'
              });

            case 5:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x3) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Should preserve viewportCentre when zooming', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var center, schedulerHeaderHeight;
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                id: 'test',
                resources: [{
                  id: 1,
                  name: 'First'
                }],
                viewPreset: 'dayAndWeek',
                startDate: new Date(2018, 0, 8),
                endDate: new Date(2018, 0, 14),
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: '2018-01-11 10:00',
                  endDate: '2018-01-11 11:00'
                }, {
                  id: 2,
                  resourceId: 2,
                  startDate: '2018-01-11 12:00',
                  endDate: '2018-01-11 13:00'
                }]
              });
              _context9.next = 3;
              return t.waitForProjectReady();

            case 3:
              _context9.next = 5;
              return scheduler.scrollEventIntoView(scheduler.eventStore.first);

            case 5:
              center = scheduler.viewportCenterDate, schedulerHeaderHeight = scheduler.timeAxisSubGrid.header.element.offsetHeight;
              scheduler.zoomIn(); // Note that we zoom far out here, because at the very zoomed out scales,
              // estimating the center from the pixel position becomes impossible
              // We test here that the center position is cached and remains identical.
              // Center and header height must be unchanged.

              t.is(scheduler.viewportCenterDateCached, center);
              t.is(scheduler.timeAxisSubGrid.header.element.offsetHeight, schedulerHeaderHeight);
              scheduler.zoomIn(); // Center and header height must be unchanged.

              t.is(scheduler.viewportCenterDateCached, center);
              t.is(scheduler.timeAxisSubGrid.header.element.offsetHeight, schedulerHeaderHeight);
              scheduler.zoomOut(); // Center and header height must be unchanged.

              t.is(scheduler.viewportCenterDateCached, center);
              t.is(scheduler.timeAxisSubGrid.header.element.offsetHeight, schedulerHeaderHeight);
              scheduler.zoomOut(); // Center and header height must be unchanged.

              t.is(scheduler.viewportCenterDateCached, center);
              t.is(scheduler.timeAxisSubGrid.header.element.offsetHeight, schedulerHeaderHeight);
              scheduler.zoomOut(); // Center and header height must be unchanged.

              t.is(scheduler.viewportCenterDateCached, center);
              t.is(scheduler.timeAxisSubGrid.header.element.offsetHeight, schedulerHeaderHeight);
              scheduler.zoomOut(); // Center and header height must be unchanged.

              t.is(scheduler.viewportCenterDateCached, center);
              t.is(scheduler.timeAxisSubGrid.header.element.offsetHeight, schedulerHeaderHeight);
              scheduler.zoomOut(); // Center and header height must be unchanged.

              t.is(scheduler.viewportCenterDateCached, center);
              t.is(scheduler.timeAxisSubGrid.header.element.offsetHeight, schedulerHeaderHeight);
              scheduler.zoomOut(); // Center and header height must be unchanged.

              t.is(scheduler.viewportCenterDateCached, center);
              t.is(scheduler.timeAxisSubGrid.header.element.offsetHeight, schedulerHeaderHeight);
              scheduler.zoomOut(); // Center and header height must be unchanged.

              t.is(scheduler.viewportCenterDateCached, center);
              t.is(scheduler.timeAxisSubGrid.header.element.offsetHeight, schedulerHeaderHeight);
              scheduler.zoomOut(); // Center and header height must be unchanged.

              t.is(scheduler.viewportCenterDateCached, center);
              t.is(scheduler.timeAxisSubGrid.header.element.offsetHeight, schedulerHeaderHeight);
              scheduler.zoomOut(); // Center and header height must be unchanged.

              t.is(scheduler.viewportCenterDateCached, center);
              t.is(scheduler.timeAxisSubGrid.header.element.offsetHeight, schedulerHeaderHeight);

            case 39:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x4) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('Should render correctly when providing subGridConfigs config', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                subGridConfigs: {
                  normal: {}
                },
                columns: [{}],
                viewPreset: 'dayAndWeek',
                startDate: new Date(2018, 0, 8),
                endDate: new Date(2018, 0, 14)
              });
              _context10.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.elementIsTopElement('.b-sch-header-text.b-sticky-header:last-child');

            case 4:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x5) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('Adding rows to empty scheduler should work', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      var _scheduler, resourceStore, rowManager, resources;

      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                height: 500
              }, 6);

            case 2:
              scheduler = _context11.sent;
              _scheduler = scheduler, resourceStore = _scheduler.resourceStore, rowManager = _scheduler.rowManager, resources = resourceStore.getRange();
              t.is(rowManager.rowCount, resources.length, 'All resources rendered');
              t.is(scheduler.element.querySelectorAll('.b-sch-event:not(.b-released)').length, 6, 'Configured number of events rendered');
              resourceStore.remove(resources);
              _context11.next = 9;
              return t.waitForProjectReady();

            case 9:
              t.is(rowManager.rowCount, 0, 'No resources rendered');
              t.is(scheduler.element.querySelectorAll(scheduler.unreleasedEventSelector).length, 0, 'No events rendered');
              resourceStore.add(resources);
              _context11.next = 14;
              return t.waitForProjectReady();

            case 14:
              t.is(rowManager.rowCount, resources.length, 'All resources rendered'); // Apparently, per Mats, Schedule->Event links *should* be permanently broken on resource removal.
              // So the following assertion should not work.
              //t.is(scheduler.element.querySelectorAll('.b-sch-event:not(.b-released)').length, 6, 'Configured number of events rendered');

            case 15:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x6) {
      return _ref14.apply(this, arguments);
    };
  }()); // TODO

  t.xit('Should correctly update events on event mutation when scrolled', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      var event;
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 13),
                resourceStore: {
                  data: function () {
                    var resources = [];

                    for (var i = 1; i <= 200; i++) {
                      resources.push({
                        id: 'r' + i,
                        name: 'r' + i
                      });
                    }

                    return resources;
                  }()
                },
                eventStore: {
                  data: function () {
                    var events = [];

                    for (var i = 1; i <= 200; i++) {
                      for (var j = 0; j < 2; j++) {
                        events.push({
                          id: i * 2 + j,
                          cls: 'event' + (i * 2 + j),
                          resourceId: 'r' + i,
                          name: 'Assignment ' + (i * 2 + j),
                          startDate: new Date(2011, 0, 3 + j),
                          endDate: new Date(2011, 0, 5 + j)
                        });
                      }
                    }

                    return events;
                  }()
                }
              }, 1000);

            case 2:
              scheduler = _context13.sent;
              // Pick an event which is not in the initially rendered block so that we have to scroll
              // down to bring it into view.
              event = scheduler.eventStore.getAt(scheduler.rowManager.rowCount * 3 + 1);
              t.chain(function () {
                return scheduler.scrollEventIntoView(event);
              }, // Wait for the requested event to be rendered.
              {
                waitFor: function waitFor() {
                  return scheduler.getElementFromEventRecord(event);
                }
              },
              /*#__PURE__*/
              // Test mutating events om a scrolled state
              _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12() {
                var scrollTop, renderedEventCount, renderedEventElements, eventElement, eventElementIndex, renderedEventRectangles, i;
                return regeneratorRuntime.wrap(function _callee12$(_context12) {
                  while (1) {
                    switch (_context12.prev = _context12.next) {
                      case 0:
                        scrollTop = scheduler.scrollable.y, renderedEventCount = scheduler.element.querySelectorAll(scheduler.eventSelector).length, renderedEventElements = Array.from(scheduler.element.querySelectorAll(scheduler.eventSelector)), eventElement = scheduler.getElementFromEventRecord(event).parentNode, eventElementIndex = renderedEventElements.indexOf(eventElement), renderedEventRectangles = renderedEventElements.map(function (el) {
                          return Rectangle.from(el);
                        }); // What we are testing is that nothing changes in the rendered event block except the
                        // width of this event's element.

                        event.duration += 1;
                        _context12.next = 4;
                        return t.waitForProjectReady();

                      case 4:
                        // Hardly anything should have changed
                        t.is(scheduler.element.querySelectorAll(scheduler.eventSelector).length, renderedEventCount, 'Rendered event count stable');
                        t.is(scheduler.scrollable.y, scrollTop, 'Scroll position stable'); // The only change to any Rectangle is that the mutated one should have changed width.

                        renderedEventRectangles[eventElementIndex].width = eventElement.offsetWidth; // All rendered event elements should have exactly the same rectangles as before.
                        // Apart from the mutated one which we have adjusted above.

                        for (i = 0; i < renderedEventElements.length; i++) {
                          t.ok(Rectangle.from(renderedEventElements[i]).equals(renderedEventRectangles[i]), 'Event rectangles are all correct');
                        }

                      case 8:
                      case "end":
                        return _context12.stop();
                    }
                  }
                }, _callee12);
              })));

            case 5:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x7) {
      return _ref15.apply(this, arguments);
    };
  }()); // TODO

  t.xit('Should not respond to changes to events which are outside of the rendered area', /*#__PURE__*/function () {
    var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      var scroller, firstEvent, renderedEventCount, testStarts, scrollNext, async, iteration, lastScrollPos, mutationTimer;
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _context14.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 13),
                resourceStore: {
                  data: function () {
                    var resources = [];

                    for (var i = 1; i <= 200; i++) {
                      resources.push({
                        id: 'r' + i,
                        name: 'r' + i
                      });
                    }

                    return resources;
                  }()
                },
                eventStore: {
                  data: function () {
                    var events = [];

                    for (var i = 1; i <= 200; i++) {
                      for (var j = 0; j < 2; j++) {
                        events.push({
                          id: i * 2 + j,
                          cls: 'event' + (i * 2 + j),
                          resourceId: 'r' + i,
                          name: 'Assignment ' + (i * 2 + j),
                          startDate: new Date(2011, 0, 3 + j),
                          endDate: new Date(2011, 0, 5 + j)
                        });
                      }
                    }

                    return events;
                  }()
                }
              }, 1000);

            case 2:
              scheduler = _context14.sent;
              scroller = scheduler.scrollable, firstEvent = scheduler.eventStore.first, renderedEventCount = scheduler.element.querySelectorAll('.b-sch-event').length, testStarts = [new Date(2011, 0, 4), new Date(2011, 0, 5), new Date(2011, 0, 6), new Date(2011, 0, 7), new Date(2011, 0, 8), new Date(2011, 0, 9)], scrollNext = function scrollNext() {
                // The scroll position should not jump, it should progress as we command it below.
                t.is(scroller.y, lastScrollPos);
                scroller.y += 100; // If scroll moved, we're not at the end, so go again soon.

                if (scroller.y !== lastScrollPos) {
                  setTimeout(scrollNext, 100);
                } else {
                  clearInterval(mutationTimer);
                  t.endAsync(async);
                }

                lastScrollPos = scroller.y; // And the number of rendered events should stay stable

                t.isApprox(scheduler.element.querySelectorAll('.b-sch-event').length, renderedEventCount, 2);
              }, async = t.beginAsync(30000);
              iteration = 0, lastScrollPos = scroller.y;
              mutationTimer = setInterval(function () {
                firstEvent.startDate = testStarts[iteration];
                iteration = (iteration + 1) % 6;
              }, 2000); // Kick off a scroll through the scheduler

              scrollNext();

            case 7:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x8) {
      return _ref17.apply(this, arguments);
    };
  }()); // TODO

  t.xit('Should not respond to event additions and deletions which are outside of the rendered area', /*#__PURE__*/function () {
    var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      var scroller, renderedEventCount, scrollNext, async, iteration, lastScrollPos, mutationTimer;
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 13),
                resourceStore: {
                  data: function () {
                    var resources = [];

                    for (var i = 1; i <= 200; i++) {
                      resources.push({
                        id: 'r' + i,
                        name: 'r' + i
                      });
                    }

                    return resources;
                  }()
                },
                eventStore: {
                  data: function () {
                    var events = [];

                    for (var i = 1; i <= 200; i++) {
                      for (var j = 0; j < 2; j++) {
                        events.push({
                          id: i * 2 + j,
                          cls: 'event' + (i * 2 + j),
                          resourceId: 'r' + i,
                          name: 'Assignment ' + (i * 2 + j),
                          startDate: new Date(2011, 0, 3 + j),
                          endDate: new Date(2011, 0, 5 + j)
                        });
                      }
                    }

                    return events;
                  }()
                }
              }, 1000);

            case 2:
              scheduler = _context16.sent;
              scroller = scheduler.scrollable, renderedEventCount = scheduler.element.querySelectorAll('.b-sch-event').length, scrollNext = function scrollNext() {
                // The scroll position should not jump, it should progress as we command it below.
                t.is(scroller.y, lastScrollPos);
                scroller.y += 100; // If scroll moved, we're not at the end, so go again soon.

                if (scroller.y !== lastScrollPos) {
                  setTimeout(scrollNext, 100);
                } else {
                  clearInterval(mutationTimer);
                  t.endAsync(async);
                }

                lastScrollPos = scroller.y; // And the number of rendered events should stay stable

                t.isApprox(scheduler.element.querySelectorAll('.b-sch-event').length, renderedEventCount, 2);
              }, async = t.beginAsync(30000);
              iteration = 0, lastScrollPos = scroller.y;
              mutationTimer = setInterval( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15() {
                var event, startDate;
                return regeneratorRuntime.wrap(function _callee15$(_context15) {
                  while (1) {
                    switch (_context15.prev = _context15.next) {
                      case 0:
                        event = scheduler.eventStore.allRecords[2];
                        scheduler.eventStore.remove(event.id);
                        startDate = new Date(2011, 0, 3 + iteration);
                        event.startDate = startDate;
                        event.endDate = DateHelper.add(startDate, Math.floor(Math.random() * 11), 'day');
                        scheduler.eventStore.add(event);
                        iteration = (iteration + 1) % 9;
                        _context15.next = 9;
                        return scheduler.project.commitAsync();

                      case 9:
                      case "end":
                        return _context15.stop();
                    }
                  }
                }, _callee15);
              })), 1000); // Kick off a scroll through the scheduler

              scrollNext();

            case 7:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x9) {
      return _ref18.apply(this, arguments);
    };
  }());
  t.it('Should render event correctly if time axis includes a DST transition', /*#__PURE__*/function () {
    var _ref20 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      var eventBarEl, eventLeft;
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2018, 9, 28),
                endDate: new Date(2018, 10, 10),
                viewPreset: 'dayAndWeek',
                resources: [{
                  id: 'r1',
                  name: 'Machine 1'
                }],
                events: [{
                  resourceId: 'r1',
                  startDate: new Date(2018, 9, 29),
                  duration: 4
                }]
              }, 1);

            case 2:
              scheduler = _context17.sent;
              // Event bar should be drawn at 100px, the width of 1 tick
              // https://app.assembla.com/spaces/bryntum/tickets/realtime_list?tickets_report_id=filter:u4270341&ticket=7037
              eventBarEl = document.querySelector(scheduler.eventSelector), eventLeft = eventBarEl.getBoundingClientRect().left - eventBarEl.parentNode.getBoundingClientRect().left;
              t.isApproxPx(eventLeft, scheduler.timeAxisViewModel.tickSize, 'Correct position');

            case 5:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x10) {
      return _ref20.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7165

  t.it('Element clearing upon repaint', /*#__PURE__*/function () {
    var _ref21 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t) {
      var eventStore;
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                id: 'test',
                resources: [{
                  id: 1,
                  name: 'First'
                }, {
                  id: 2,
                  name: 'Second'
                }],
                features: {
                  labels: {
                    right: {
                      field: 'id'
                    }
                  }
                },
                viewPreset: 'dayAndWeek',
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2018, 2, 31),
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: '2018-01-01',
                  endDate: '2018-01-02'
                }, {
                  id: 2,
                  resourceId: 2,
                  startDate: '2018-01-01',
                  endDate: '2018-01-02'
                }, {
                  id: 3,
                  resourceId: 2,
                  startDate: '2018-01-03',
                  endDate: '2018-01-04'
                }]
              });
              _context19.next = 3;
              return t.waitForProjectReady();

            case 3:
              eventStore = scheduler.eventStore;
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18() {
                return regeneratorRuntime.wrap(function _callee18$(_context18) {
                  while (1) {
                    switch (_context18.prev = _context18.next) {
                      case 0:
                        t.is(scheduler.timeAxisSubGridElement.querySelectorAll(':not(.b-released) > .b-sch-label.b-sch-label-right').length, 3, 'There are 3 labels to begin with'); // This event's element will be placed into the cache

                        _context18.next = 3;
                        return eventStore.getAt(0).setStartDate(new Date(2020, 11, 31));

                      case 3:
                        t.is(scheduler.timeAxisSubGridElement.querySelectorAll(':not(.b-released) > .b-sch-label.b-sch-label-right').length, 2, 'There are 2 labels after moving one event outside of TimeAxis'); // All event elements on a row get tossed out when an event is deleted,
                        // So the render of the remaining one will get the cached element.
                        // The bug is that while this was correctly triggered as a paint, the element
                        // is UNCLEARED from last usage, and so the labels feature elements are
                        // still in there, but being a paint instead of repaint, label elements are added.

                        eventStore.remove(eventStore.getAt(1));
                        _context18.next = 7;
                        return scheduler.project.commitAsync();

                      case 7:
                      case "end":
                        return _context18.stop();
                    }
                  }
                }, _callee18);
              })), // After rerendering that row which will recycle the element of the
              // event that got moved outside of the TimeAxis, and after hiding the outgoing
              // event element, there should only be one visible label element left.
              {
                waitFor: function waitFor() {
                  return scheduler.timeAxisSubGridElement.querySelectorAll(':not(.b-released) > .b-sch-label.b-sch-label-right').length === 1;
                },
                desc: 'Only 1 label exists now that there is only 1 event in view'
              });

            case 5:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    }));

    return function (_x11) {
      return _ref21.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7410

  t.it('Setting new start date should shift the range', /*#__PURE__*/function () {
    var _ref23 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(t) {
      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                viewPreset: 'dayAndWeek',
                startDate: new Date(2019, 0, 6),
                endDate: new Date(2019, 0, 11)
              });
              _context20.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.isDateEqual(scheduler.startDate, new Date(2019, 0, 6), 'Initial start date is correct');
              t.isDateEqual(scheduler.endDate, new Date(2019, 0, 11), 'Initial end date is correct');
              scheduler.startDate = new Date(2019, 0, 13);
              t.isDateEqual(scheduler.startDate, new Date(2019, 0, 13), 'Start date is correct');
              t.isDateEqual(scheduler.endDate, new Date(2019, 0, 18), 'End date is correct');
              scheduler.startDate = new Date(2019, 0, 6);
              t.isDateEqual(scheduler.startDate, new Date(2019, 0, 6), 'Start date is correct');
              t.isDateEqual(scheduler.endDate, new Date(2019, 0, 11), 'End date is correct');

            case 11:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    }));

    return function (_x12) {
      return _ref23.apply(this, arguments);
    };
  }());
  t.it('Setting new start date > end date with keepDuration false should throw an exception', /*#__PURE__*/function () {
    var _ref24 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21(t) {
      return regeneratorRuntime.wrap(function _callee21$(_context21) {
        while (1) {
          switch (_context21.prev = _context21.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                viewPreset: 'dayAndWeek',
                startDate: new Date(2019, 0, 6),
                endDate: new Date(2019, 0, 11)
              });
              _context21.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.throwsOk(function () {
                scheduler.setStartDate(new Date(2019, 0, 13), false);
              }, /Invalid start\/end dates\. Start date must less than end date\. Start date: .*\. End date: .*\./);

            case 4:
            case "end":
              return _context21.stop();
          }
        }
      }, _callee21);
    }));

    return function (_x13) {
      return _ref24.apply(this, arguments);
    };
  }());
  t.it('Setting new start date < end date with keepDuration false should modify the range', /*#__PURE__*/function () {
    var _ref25 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
      return regeneratorRuntime.wrap(function _callee22$(_context22) {
        while (1) {
          switch (_context22.prev = _context22.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                viewPreset: 'dayAndWeek',
                startDate: new Date(2019, 0, 6),
                endDate: new Date(2019, 0, 11)
              });
              _context22.next = 3;
              return t.waitForProjectReady();

            case 3:
              scheduler.setStartDate(new Date(2019, 0, 8), false);
              t.isDateEqual(scheduler.startDate, new Date(2019, 0, 8), 'Start date is correct');
              t.isDateEqual(scheduler.endDate, new Date(2019, 0, 11), 'End date is correct');
              scheduler.setStartDate(new Date(2019, 0, 6), false);
              t.isDateEqual(scheduler.startDate, new Date(2019, 0, 6), 'Start date is correct');
              t.isDateEqual(scheduler.endDate, new Date(2019, 0, 11), 'End date is correct');

            case 9:
            case "end":
              return _context22.stop();
          }
        }
      }, _callee22);
    }));

    return function (_x14) {
      return _ref25.apply(this, arguments);
    };
  }());
  t.it('Setting new end date with keepDuration true should shift the range', /*#__PURE__*/function () {
    var _ref26 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23(t) {
      return regeneratorRuntime.wrap(function _callee23$(_context23) {
        while (1) {
          switch (_context23.prev = _context23.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                viewPreset: 'dayAndWeek',
                startDate: new Date(2019, 0, 13),
                endDate: new Date(2019, 0, 18)
              });
              _context23.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.isDateEqual(scheduler.startDate, new Date(2019, 0, 13), 'Initial start date is correct');
              t.isDateEqual(scheduler.endDate, new Date(2019, 0, 18), 'Initial end date is correct');
              scheduler.setEndDate(new Date(2019, 0, 11), true);
              t.isDateEqual(scheduler.startDate, new Date(2019, 0, 6), 'Start date is correct');
              t.isDateEqual(scheduler.endDate, new Date(2019, 0, 11), 'End date is correct');
              scheduler.setEndDate(new Date(2019, 0, 18), true);
              t.isDateEqual(scheduler.startDate, new Date(2019, 0, 13), 'Start date is correct');
              t.isDateEqual(scheduler.endDate, new Date(2019, 0, 18), 'End date is correct');

            case 11:
            case "end":
              return _context23.stop();
          }
        }
      }, _callee23);
    }));

    return function (_x15) {
      return _ref26.apply(this, arguments);
    };
  }());
  t.it('Setting new end date < start date should throw an exception', /*#__PURE__*/function () {
    var _ref27 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee24(t) {
      return regeneratorRuntime.wrap(function _callee24$(_context24) {
        while (1) {
          switch (_context24.prev = _context24.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                viewPreset: 'dayAndWeek',
                startDate: new Date(2019, 0, 13),
                endDate: new Date(2019, 0, 18)
              });
              _context24.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.throwsOk(function () {
                scheduler.endDate = new Date(2019, 0, 11);
              }, /Invalid start\/end dates\. Start date must less than end date\. Start date: .*\. End date: .*\./);

            case 4:
            case "end":
              return _context24.stop();
          }
        }
      }, _callee24);
    }));

    return function (_x16) {
      return _ref27.apply(this, arguments);
    };
  }());
  t.it('Setting new end date > start date should should modify the range', /*#__PURE__*/function () {
    var _ref28 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee25(t) {
      return regeneratorRuntime.wrap(function _callee25$(_context25) {
        while (1) {
          switch (_context25.prev = _context25.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                viewPreset: 'dayAndWeek',
                startDate: new Date(2019, 0, 6),
                endDate: new Date(2019, 0, 11)
              });
              _context25.next = 3;
              return t.waitForProjectReady();

            case 3:
              scheduler.setEndDate(new Date(2019, 0, 8), false);
              t.isDateEqual(scheduler.startDate, new Date(2019, 0, 6), 'Start date is correct');
              t.isDateEqual(scheduler.endDate, new Date(2019, 0, 8), 'End date is correct');
              scheduler.setEndDate(new Date(2019, 0, 11), false);
              t.isDateEqual(scheduler.startDate, new Date(2019, 0, 6), 'Start date is correct');
              t.isDateEqual(scheduler.endDate, new Date(2019, 0, 11), 'End date is correct');

            case 9:
            case "end":
              return _context25.stop();
          }
        }
      }, _callee25);
    }));

    return function (_x17) {
      return _ref28.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7502

  t.it('Appending to scheduler container should trigger timelineviewportresize', /*#__PURE__*/function () {
    var _ref29 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee26(t) {
      return regeneratorRuntime.wrap(function _callee26$(_context26) {
        while (1) {
          switch (_context26.prev = _context26.next) {
            case 0:
              document.body.innerHTML = '<div id="container" style="display: flex; flex-direction: row; height: 400px; width: 100%"></div>';
              scheduler = new Scheduler({
                appendTo: 'container',
                viewPreset: 'dayAndWeek',
                startDate: new Date(2019, 0, 14),
                endDate: new Date(2019, 0, 21),
                flex: 1 // Needed for IE11

              });
              _context26.next = 4;
              return t.waitForProjectReady();

            case 4:
              // Acquiring a scrollbar will change the viewport size
              t.willFireNTimes(scheduler, 'timelineviewportresize', 1);
              t.chain({
                waitForEvent: [scheduler, 'timelineviewportresize'],
                trigger: function trigger() {
                  DomHelper.createElement({
                    parent: document.getElementById('container'),
                    tag: 'div',
                    style: 'width: 200px; background: red'
                  });
                }
              });

            case 6:
            case "end":
              return _context26.stop();
          }
        }
      }, _callee26);
    }));

    return function (_x18) {
      return _ref29.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7599

  t.it('Should position correctly for monthAndYear', /*#__PURE__*/function () {
    var _ref30 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee27(t) {
      return regeneratorRuntime.wrap(function _callee27$(_context27) {
        while (1) {
          switch (_context27.prev = _context27.next) {
            case 0:
              _context27.next = 2;
              return t.getSchedulerAsync({
                width: 1200,
                viewPreset: 'monthAndYear',
                columns: [],
                startDate: new Date(2019, 0, 1),
                endDate: new Date(2019, 2, 31),
                //events
                events: [{
                  id: 'lastJan',
                  resourceId: 'r1',
                  name: 'Last Jan',
                  startDate: new Date(2019, 0, 31),
                  duration: 24,
                  durationUnit: 'h'
                }, {
                  id: 'firstFeb',
                  resourceId: 'r1',
                  name: 'First Feb',
                  startDate: new Date(2019, 1, 1),
                  duration: 24,
                  durationUnit: 'h'
                }, {
                  id: 'lastFeb',
                  resourceId: 'r1',
                  name: 'Last Feb',
                  startDate: new Date(2019, 1, 28),
                  duration: 24,
                  durationUnit: 'h'
                }]
              });

            case 2:
              scheduler = _context27.sent;
              t.isApprox(t.rect('[data-event-id="lastJan"]').right, 400, 0.5);
              t.isApprox(t.rect('[data-event-id="firstFeb"]').left, 400, 0.5);
              t.isApprox(t.rect('[data-event-id="lastFeb"]').right, 800, 0.5);

            case 6:
            case "end":
              return _context27.stop();
          }
        }
      }, _callee27);
    }));

    return function (_x19) {
      return _ref30.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7657

  t.it('Should render correctly when used in TabPanel', /*#__PURE__*/function () {
    var _ref31 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee28(t) {
      var tabPanel, first, second;
      return regeneratorRuntime.wrap(function _callee28$(_context28) {
        while (1) {
          switch (_context28.prev = _context28.next) {
            case 0:
              tabPanel = new TabPanel({
                appendTo: document.body,
                height: 500,
                animateTabChange: false,
                items: [{
                  type: 'scheduler',
                  id: 'one',
                  title: 'One',
                  startDate: new Date(2019, 2, 11),
                  endDate: new Date(2019, 2, 30),
                  useInitialAnimation: false,
                  columns: [{
                    text: 'Name',
                    field: 'name',
                    width: 150
                  }],
                  resources: ArrayHelper.populate(5, function (i) {
                    return {
                      id: 'r' + i,
                      name: 'Resource ' + i
                    };
                  }),
                  events: [{
                    id: 'e1',
                    resourceId: 'r0',
                    startDate: new Date(2019, 2, 12),
                    duration: 3,
                    name: 'Event A'
                  }]
                }, {
                  type: 'scheduler',
                  id: 'two',
                  title: 'Two',
                  startDate: new Date(2019, 2, 11),
                  endDate: new Date(2019, 2, 30),
                  columns: [{
                    text: 'Name',
                    field: 'name',
                    width: 150
                  }],
                  useInitialAnimation: false,
                  resources: ArrayHelper.populate(5, function (i) {
                    return {
                      id: 'r' + i,
                      name: 'Resource ' + i
                    };
                  }),
                  events: [{
                    id: 'e1',
                    resourceId: 'r0',
                    startDate: new Date(2019, 2, 12),
                    duration: 3,
                    name: 'Event B'
                  }]
                }]
              });
              _context28.next = 3;
              return t.waitForProjectReady();

            case 3:
              first = tabPanel.widgetMap.one, second = tabPanel.widgetMap.two;
              t.is(first.subGrids.locked.splitterElement.offsetLeft, 150, 'Splitter correctly positioned');
              t.isApprox(first.tickSize, 40, 0.5, 'Correct tickSize');
              t.selectorExists('.b-sch-event:contains(Event A)', 'Event rendered');
              t.isApprox(first.getElementFromEventRecord(first.eventStore.first).getBoundingClientRect().left, 249, 'Event at correct X');
              t.isApprox(first.timeAxisColumn.element.offsetWidth, 840, 'Header has correct width');
              tabPanel.activeTab = 1;
              t.is(second.subGrids.locked.splitterElement.offsetLeft, 150, 'Splitter correctly positioned #2');
              t.isApprox(second.tickSize, 40, 0.5, 'Correct tickSize #2');
              t.selectorExists('.b-sch-event:contains(Event B)', 'Event rendered #2');
              t.isApprox(second.getElementFromEventRecord(second.eventStore.first).getBoundingClientRect().left, 249, 'Event at correct X #2');
              t.isApprox(second.timeAxisColumn.element.offsetWidth, 840, 'Header has correct width #2');
              tabPanel.destroy();

            case 16:
            case "end":
              return _context28.stop();
          }
        }
      }, _callee28);
    }));

    return function (_x20) {
      return _ref31.apply(this, arguments);
    };
  }()); // Arcady: I'm snoozing this assertion so far. Need to review the case.
  // We refresh view twice in this tests:
  // - first time when reacting on "dataset" action caused by store.data = ...
  // - and second time is caused by changes propagation (event endDate get recalculated)

  if (new Date() > new Date(2022, 2, 1)) {
    t.fail('snoozed test woke up'); // https://app.assembla.com/spaces/bryntum/tickets/8411

    t.it('EventStore dataset rerenders events once', /*#__PURE__*/function () {
      var _ref32 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee29(t) {
        var renderedEventCount;
        return regeneratorRuntime.wrap(function _callee29$(_context29) {
          while (1) {
            switch (_context29.prev = _context29.next) {
              case 0:
                _context29.next = 2;
                return t.getSchedulerAsync({
                  viewPreset: 'dayAndWeek',
                  height: 500
                });

              case 2:
                scheduler = _context29.sent;
                renderedEventCount = scheduler.element.querySelectorAll(scheduler.eventSelector).length;
                t.willFireNTimes(scheduler, 'renderEvent', renderedEventCount);
                scheduler.eventStore.data = scheduler.eventStore.records.map(function (r) {
                  var data = r.data;
                  data.duration++;
                  return data;
                });
                _context29.next = 8;
                return t.waitForProjectReady();

              case 8:
              case "end":
                return _context29.stop();
            }
          }
        }, _callee29);
      }));

      return function (_x21) {
        return _ref32.apply(this, arguments);
      };
    }());
  }

  t.it('Ending a EventStore batch rerenders events once', /*#__PURE__*/function () {
    var _ref33 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee30(t) {
      var _scheduler2, eventStore;

      return regeneratorRuntime.wrap(function _callee30$(_context30) {
        while (1) {
          switch (_context30.prev = _context30.next) {
            case 0:
              _context30.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                height: 500
              });

            case 2:
              scheduler = _context30.sent;
              t.willFireNTimes(scheduler, 'renderEvent', 2);
              _scheduler2 = scheduler, eventStore = _scheduler2.eventStore;
              eventStore.beginBatch();
              eventStore.first.duration++;
              eventStore.last.duration++;
              eventStore.endBatch();
              _context30.next = 11;
              return t.waitForProjectReady();

            case 11:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 5, 'All events still there');

            case 12:
            case "end":
              return _context30.stop();
          }
        }
      }, _callee30);
    }));

    return function (_x22) {
      return _ref33.apply(this, arguments);
    };
  }()); // Both these cases should just run without errors.
  // https://app.assembla.com/spaces/bryntum/tickets/8141

  t.describe('Row reordering', /*#__PURE__*/function () {
    var _ref34 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee33(t) {
      return regeneratorRuntime.wrap(function _callee33$(_context33) {
        while (1) {
          switch (_context33.prev = _context33.next) {
            case 0:
              t.it('Many resources', /*#__PURE__*/function () {
                var _ref35 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee31(t) {
                  return regeneratorRuntime.wrap(function _callee31$(_context31) {
                    while (1) {
                      switch (_context31.prev = _context31.next) {
                        case 0:
                          _context31.next = 2;
                          return t.getSchedulerAsync({
                            resourceStore: t.getResourceStore2({}, 1000),
                            features: {
                              rowReorder: true
                            },
                            columns: [{
                              text: 'Name',
                              width: 100,
                              field: 'name',
                              locked: true
                            }, {
                              text: 'Id',
                              field: 'id',
                              locked: true
                            }],
                            startDate: new Date(2018, 0, 1),
                            endDate: new Date(2018, 2, 31),
                            events: [{
                              id: 1,
                              resourceId: 'r1',
                              startDate: '2018-01-01',
                              endDate: '2018-01-03'
                            }]
                          });

                        case 2:
                          scheduler = _context31.sent;
                          t.chain({
                            drag: '.b-grid-cell',
                            to: '.b-sch-event-wrap'
                          });

                        case 4:
                        case "end":
                          return _context31.stop();
                      }
                    }
                  }, _callee31);
                }));

                return function (_x24) {
                  return _ref35.apply(this, arguments);
                };
              }());
              t.it('Few resources', /*#__PURE__*/function () {
                var _ref36 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee32(t) {
                  return regeneratorRuntime.wrap(function _callee32$(_context32) {
                    while (1) {
                      switch (_context32.prev = _context32.next) {
                        case 0:
                          _context32.next = 2;
                          return t.getSchedulerAsync({
                            id: 'test',
                            resourceStore: t.getResourceStore2({}, 5),
                            features: {
                              rowReorder: true
                            },
                            columns: [{
                              text: 'Name',
                              width: 100,
                              field: 'name',
                              locked: true
                            }, {
                              text: 'Id',
                              field: 'id',
                              locked: true
                            }],
                            startDate: new Date(2018, 0, 1),
                            endDate: new Date(2018, 2, 31),
                            events: [{
                              id: 1,
                              resourceId: 'r1',
                              startDate: '2018-01-01',
                              endDate: '2018-01-03'
                            }]
                          });

                        case 2:
                          scheduler = _context32.sent;
                          t.chain({
                            drag: '.b-grid-cell',
                            to: '.b-sch-event-wrap'
                          });

                        case 4:
                        case "end":
                          return _context32.stop();
                      }
                    }
                  }, _callee32);
                }));

                return function (_x25) {
                  return _ref36.apply(this, arguments);
                };
              }());

            case 2:
            case "end":
              return _context33.stop();
          }
        }
      }, _callee33);
    }));

    return function (_x23) {
      return _ref34.apply(this, arguments);
    };
  }());
  t.it('Should not throw an exception when mouse is moved out from event which is fading out due to its removing', /*#__PURE__*/function () {
    var _ref37 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee35(t) {
      var rec, el;
      return regeneratorRuntime.wrap(function _callee35$(_context35) {
        while (1) {
          switch (_context35.prev = _context35.next) {
            case 0:
              // Make a long transition so we can determine that it removes slowly
              CSSHelper.insertRule('#animation-state-test-scheduler .b-sch-event-wrap { transition-duration: 1s !important; }');
              scheduler = new Scheduler({
                appendTo: document.body,
                height: 200,
                id: 'animation-state-test-scheduler',
                transitionDuration: 1000,
                enableEventAnimations: true,
                // Needs explicitly configuring because IE11 turns animations off
                useInitialAnimation: false,
                startDate: new Date(2018, 9, 19),
                endDate: new Date(2018, 9, 31),
                columns: [{
                  field: 'name',
                  text: 'Name'
                }],
                resources: ArrayHelper.fill(2, {}, function (resource, i) {
                  return Object.assign(resource, {
                    id: i + 1,
                    name: 'Resource ' + (i + 1)
                  });
                }),
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2018, 9, 20),
                  duration: 2
                }, {
                  id: 2,
                  resourceId: 1,
                  startDate: new Date(2018, 9, 24),
                  duration: 2,
                  cls: 'event2'
                }]
              });
              _context35.next = 4;
              return t.waitForProjectReady();

            case 4:
              rec = scheduler.eventStore.getById(2);
              t.chain({
                waitForSelector: '.event2'
              }, {
                click: '.event2',
                offset: [1, 1]
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee34() {
                return regeneratorRuntime.wrap(function _callee34$(_context34) {
                  while (1) {
                    switch (_context34.prev = _context34.next) {
                      case 0:
                        return _context34.abrupt("return", el = scheduler.getElementFromEventRecord(rec));

                      case 1:
                      case "end":
                        return _context34.stop();
                    }
                  }
                }, _callee34);
              })), {
                type: '[DELETE]',
                target: el
              }, // Events removing happens with a delay (see EventNavigation.onDeleteKeyBuffer),
              // so need to wait when animation starts.
              {
                waitFor: function waitFor() {
                  return scheduler.isAnimating;
                },
                desc: 'Event element starts disappearing'
              }, // This step is required to reproduce the bug, no extra mouse movement needed
              function (next) {
                // The bug happens when the element becomes `pointer-events: none;` due to being
                // put into an animated removing state. Mouseout is triggered in a real UI,
                // so we have to explicitly fire one here.
                t.simulator.simulateEvent(el, 'mouseout');
                next();
              }, {
                waitForSelectorNotFound: "".concat(scheduler.unreleasedEventSelector, " .event2"),
                desc: 'Event is removed'
              });

            case 6:
            case "end":
              return _context35.stop();
          }
        }
      }, _callee35);
    }));

    return function (_x26) {
      return _ref37.apply(this, arguments);
    };
  }());
  t.it('Scheduler in a Popup', /*#__PURE__*/function () {
    var _ref39 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee36(t) {
      var popup;
      return regeneratorRuntime.wrap(function _callee36$(_context36) {
        while (1) {
          switch (_context36.prev = _context36.next) {
            case 0:
              scheduler = t.getScheduler({
                multiEventSelect: true,
                features: {
                  timeRanges: true
                },
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 130
                }]
              });
              popup = new Popup({
                autoClose: false,
                x: 0,
                y: 0,
                width: 600,
                height: 400,
                layout: 'fit',
                showAnimation: false,
                hideAnimation: false,
                rootElement: document.body,
                items: [scheduler]
              });
              t.ok(scheduler.isVisible);
              popup.hide();
              t.notOk(scheduler.isVisible);
              popup.show();
              t.ok(scheduler.isVisible);
              popup.destroy();

            case 8:
            case "end":
              return _context36.stop();
          }
        }
      }, _callee36);
    }));

    return function (_x27) {
      return _ref39.apply(this, arguments);
    };
  }());
  t.it('Empty text', /*#__PURE__*/function () {
    var _ref40 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee37(t) {
      return regeneratorRuntime.wrap(function _callee37$(_context37) {
        while (1) {
          switch (_context37.prev = _context37.next) {
            case 0:
              _context37.next = 2;
              return t.getSchedulerAsync({
                emptyText: 'empty_schedule'
              });

            case 2:
              scheduler = _context37.sent;
              scheduler.resourceStore.removeAll();
              _context37.next = 6;
              return t.waitForProjectReady();

            case 6:
              t.is(scheduler.subGrids.normal.dataset.emptyText, 'empty_schedule', 'Should find empty text in schedule with no rows');

            case 7:
            case "end":
              return _context37.stop();
          }
        }
      }, _callee37);
    }));

    return function (_x28) {
      return _ref40.apply(this, arguments);
    };
  }());
  t.it('Should not duplicate event on changing id', /*#__PURE__*/function () {
    var _ref41 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee38(t) {
      var event;
      return regeneratorRuntime.wrap(function _callee38$(_context38) {
        while (1) {
          switch (_context38.prev = _context38.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2018, 9, 19),
                endDate: new Date(2018, 9, 31),
                columns: [{
                  field: 'name',
                  text: 'Name'
                }],
                resources: [{
                  id: 1,
                  name: 'First'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2018, 9, 20),
                  duration: 2
                }]
              });
              _context38.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.selectorCountIs('.b-sch-event', 1, 'Only one event is rendered');
              event = scheduler.eventStore.first;
              event.id = 2;
              _context38.next = 8;
              return t.waitForProjectReady();

            case 8:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Only one event is rendered');

            case 9:
            case "end":
              return _context38.stop();
          }
        }
      }, _callee38);
    }));

    return function (_x29) {
      return _ref41.apply(this, arguments);
    };
  }());
  t.it('New columns should default to locked region', /*#__PURE__*/function () {
    var _ref42 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee39(t) {
      var _scheduler$columns$ad, _scheduler$columns$ad2, col;

      return regeneratorRuntime.wrap(function _callee39$(_context39) {
        while (1) {
          switch (_context39.prev = _context39.next) {
            case 0:
              scheduler = t.getScheduler();
              _scheduler$columns$ad = scheduler.columns.add({
                field: 'new',
                text: 'new'
              }), _scheduler$columns$ad2 = _slicedToArray(_scheduler$columns$ad, 1), col = _scheduler$columns$ad2[0];
              t.is(col.region, 'locked', 'Correct region');

            case 3:
            case "end":
              return _context39.stop();
          }
        }
      }, _callee39);
    }));

    return function (_x30) {
      return _ref42.apply(this, arguments);
    };
  }());
  t.it('Should display zoomed event bars which are too wide for the browser as clipped just beyond the viewport boundaries', /*#__PURE__*/function () {
    var _ref43 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee40(t) {
      return regeneratorRuntime.wrap(function _callee40$(_context40) {
        while (1) {
          switch (_context40.prev = _context40.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                id: 'test',
                resources: [{
                  id: 1,
                  name: 'First'
                }],
                // Display a long term project with a months long event.
                viewPreset: 'monthAndYear',
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2018, 11, 31),
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: '2018-04-01',
                  endDate: '2018-08-01'
                }]
              });
              _context40.next = 3;
              return t.waitForProjectReady();

            case 3:
              // Zoom to where ticks are minutes. The event bar will be insanely wide.
              scheduler.zoomToLevel(scheduler.maxZoomLevel);
              _context40.next = 6;
              return t.waitFor(function () {
                return document.querySelector('.b-sch-event-wrap').offsetWidth > scheduler.timeAxisColumn.width;
              });

            case 6:
              // In this extreme close up, the calculated bar width of 274,060,800 would not be visible
              // so the Mapper clips it to 100px either side of the TimeAxisColumn.
              t.isApprox(document.querySelector('.b-sch-event-wrap').offsetWidth, scheduler.timeAxisColumn.width + 200, 10);

            case 7:
            case "end":
              return _context40.stop();
          }
        }
      }, _callee40);
    }));

    return function (_x31) {
      return _ref43.apply(this, arguments);
    };
  }());
  t.it('Should use DateHelper.defaultFormat by default', /*#__PURE__*/function () {
    var _ref44 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee41(t) {
      var oldDefault;
      return regeneratorRuntime.wrap(function _callee41$(_context41) {
        while (1) {
          switch (_context41.prev = _context41.next) {
            case 0:
              oldDefault = DateHelper.defaultFormat;
              DateHelper.defaultFormat = 'MM.DD.YY';
              scheduler = new Scheduler({
                startDate: '10.13.19',
                endDate: '11.24.19',
                resources: [{
                  id: 1,
                  name: 'First'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: '10.20.19',
                  endDate: '10.25.19'
                }]
              });
              _context41.next = 5;
              return t.waitForProjectReady();

            case 5:
              t.is(scheduler.startDate, new Date(2019, 9, 13), 'Correct timeline start date');
              t.is(scheduler.endDate, new Date(2019, 10, 24), 'Correct timeline end date');
              t.is(scheduler.eventStore.first.startDate, new Date(2019, 9, 20), 'Correct event start date');
              t.is(scheduler.eventStore.first.endDate, new Date(2019, 9, 25), 'Correct event end date');
              DateHelper.defaultFormat = oldDefault;

            case 10:
            case "end":
              return _context41.stop();
          }
        }
      }, _callee41);
    }));

    return function (_x32) {
      return _ref44.apply(this, arguments);
    };
  }());
  t.it('Should not see `b-using-keyboard class after click', /*#__PURE__*/function () {
    var _ref45 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee42(t) {
      return regeneratorRuntime.wrap(function _callee42$(_context42) {
        while (1) {
          switch (_context42.prev = _context42.next) {
            case 0:
              scheduler = t.getScheduler();
              document.body.classList.remove('b-using-keyboard');
              _context42.next = 4;
              return t.click('.b-sch-timeaxis-cell');

            case 4:
              t.selectorNotExists('.b-using-keyboard');

            case 5:
            case "end":
              return _context42.stop();
          }
        }
      }, _callee42);
    }));

    return function (_x33) {
      return _ref45.apply(this, arguments);
    };
  }());
  t.it('Should remove `b-using-keyboard` class after click', /*#__PURE__*/function () {
    var _ref46 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee43(t) {
      return regeneratorRuntime.wrap(function _callee43$(_context43) {
        while (1) {
          switch (_context43.prev = _context43.next) {
            case 0:
              scheduler = t.getScheduler();
              document.body.classList.remove('b-using-keyboard');
              _context43.next = 4;
              return t.type('.b-sch-event', 'foo');

            case 4:
              t.selectorExists('.b-using-keyboard');
              _context43.next = 7;
              return t.click('.b-sch-timeaxis-cell');

            case 7:
              t.selectorNotExists('.b-using-keyboard');

            case 8:
            case "end":
              return _context43.stop();
          }
        }
      }, _callee43);
    }));

    return function (_x34) {
      return _ref46.apply(this, arguments);
    };
  }());
  t.it('Should support formatting duration via #formatDuration', /*#__PURE__*/function () {
    var _ref47 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee44(t) {
      return regeneratorRuntime.wrap(function _callee44$(_context44) {
        while (1) {
          switch (_context44.prev = _context44.next) {
            case 0:
              scheduler = new Scheduler();
              t.expect(scheduler.formatDuration(1)).toBe(1);
              t.expect(scheduler.formatDuration(1, 1)).toBe(1);
              t.expect(scheduler.formatDuration(1.1, 1)).toBe(1.1);
              t.expect(scheduler.formatDuration(1.160, 1)).toBe(1.2);
              t.expect(scheduler.formatDuration(1.160, 0)).toBe(1);
              t.expect(scheduler.formatDuration(1.560, 0)).toBe(2);

            case 7:
            case "end":
              return _context44.stop();
          }
        }
      }, _callee44);
    }));

    return function (_x35) {
      return _ref47.apply(this, arguments);
    };
  }());
  t.it('Should not transition row height initially', /*#__PURE__*/function () {
    var _ref48 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee45(t) {
      return regeneratorRuntime.wrap(function _callee45$(_context45) {
        while (1) {
          switch (_context45.prev = _context45.next) {
            case 0:
              t.wontFire(document, 'transitionstart');
              _context45.next = 3;
              return t.getSchedulerAsync({
                useInitialAnimation: false,
                events: [{
                  id: 1,
                  name: 'Event 1',
                  startDate: '2011-01-04',
                  duration: 2,
                  resourceId: 'r1'
                }, {
                  id: 2,
                  name: 'Event 2',
                  startDate: '2011-01-04',
                  duration: 2,
                  resourceId: 'r1'
                }]
              });

            case 3:
              scheduler = _context45.sent;
              _context45.next = 6;
              return t.waitFor(500);

            case 6:
            case "end":
              return _context45.stop();
          }
        }
      }, _callee45);
    }));

    return function (_x36) {
      return _ref48.apply(this, arguments);
    };
  }());
  t.it('Should show load fail message if initial load fails', /*#__PURE__*/function () {
    var _ref49 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee46(t) {
      var maskEl;
      return regeneratorRuntime.wrap(function _callee46$(_context46) {
        while (1) {
          switch (_context46.prev = _context46.next) {
            case 0:
              new Scheduler({
                appendTo: document.body,
                loadMaskError: {
                  autoClose: 3000
                },
                resourceStore: {
                  autoLoad: true,
                  // requests will fail due to x-domain violation
                  readUrl: 'http://localhost:3000/'
                }
              });
              _context46.next = 3;
              return t.waitForSelector('.b-grid-load-failure:contains(Data loading failed)');

            case 3:
              maskEl = t.query('.b-mask')[0];
              _context46.next = 6;
              return t.waitFor(function () {
                return window.getComputedStyle(maskEl).opacity === '1';
              });

            case 6:
              t.pass('Load mask visible');

            case 7:
            case "end":
              return _context46.stop();
          }
        }
      }, _callee46);
    }));

    return function (_x37) {
      return _ref49.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2368

  t.it('Should not apply background color when hovering timeline subgrid row', /*#__PURE__*/function () {
    var _ref50 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee47(t) {
      return regeneratorRuntime.wrap(function _callee47$(_context47) {
        while (1) {
          switch (_context47.prev = _context47.next) {
            case 0:
              new Scheduler({
                appendTo: document.body,
                resources: [{}],
                columns: [{}]
              });
              _context47.next = 3;
              return t.moveCursorTo('.b-grid-cell');

            case 3:
              t.is(window.getComputedStyle(t.query('.b-sch-timeaxis-cell')[0]).backgroundColor, 'rgba(0, 0, 0, 0)', 'No bg color');
              _context47.next = 6;
              return t.moveCursorTo('.b-sch-timeaxis-cell');

            case 6:
              t.is(window.getComputedStyle(t.query('.b-sch-timeaxis-cell')[0]).backgroundColor, 'rgba(0, 0, 0, 0)', 'No bg color');

            case 7:
            case "end":
              return _context47.stop();
          }
        }
      }, _callee47);
    }));

    return function (_x38) {
      return _ref50.apply(this, arguments);
    };
  }());
});