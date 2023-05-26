function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var counter = 0,
      scheduler;
  t.beforeEach(function () {
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });
  t.afterEach( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
    return regeneratorRuntime.wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            _context.next = 2;
            return t.mouseUp();

          case 2:
            if (!(scheduler && !scheduler.isDestroyed && !scheduler.project.isDestroyed)) {
              _context.next = 5;
              break;
            }

            _context.next = 5;
            return t.waitForProjectReady(scheduler.project);

          case 5:
          case "end":
            return _context.stop();
        }
      }
    }, _callee);
  })));

  var createFn = function createFn(_ref2, event) {
    var resourceRecord = _ref2.resourceRecord,
        startDate = _ref2.startDate,
        endDate = _ref2.endDate;

    //limiting number of assertions
    if (counter < 2) {
      t.ok(resourceRecord instanceof ResourceModel && startDate instanceof Date && endDate instanceof Date && (event ? event instanceof Event : true), 'Correct function arguments');
    }

    counter++;
    if (endDate > new Date(2011, 0, 10)) return false;
  };

  document.body.style.width = '500px';
  t.it('Should not create an event if validatorFn returns false', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getSchedulerAsync({
                aaa: 'aaa',
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 3, 3),
                viewPreset: 'weekAndMonth',
                resourceStore: new ResourceStore({
                  data: [// Put some empty rows first to make sure tooltip fits above for alignment checks
                  {}, {}, {
                    id: 1,
                    name: 'Foo'
                  }]
                }),
                eventStore: new EventStore(),
                features: {
                  eventDragCreate: {
                    validatorFn: function validatorFn() {
                      return false;
                    }
                  }
                }
              });

            case 2:
              scheduler = _context2.sent;
              //t.ok(scheduler.enableDragCreation === true, 'Should see enableDragCreation configured correctly on the view');
              t.ok(scheduler.features.eventDragCreate, 'EventDragCreate is there');
              t.firesOnce(scheduler.eventStore, 'add');
              t.firesOnce(scheduler.eventStore, 'remove');
              t.wontFire(scheduler, 'scheduleclick');
              scheduler.contentElement.addEventListener('transitionstart', function (_ref4) {
                var target = _ref4.target,
                    propertyName = _ref4.propertyName;

                if (target.matches('.b-sch-event-wrap') && propertyName === 'width') {
                  t.fail('No event width animations should be started');
                }
              });
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                fromOffset: [2, 2],
                by: [50, 0]
              });

            case 9:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should hide creator proxy after cancelled operation', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var generateListener;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                eventStore: new EventStore(),
                features: {
                  eventEdit: false,
                  eventDragCreate: true
                }
              });

            case 2:
              scheduler = _context4.sent;

              generateListener = function generateListener(doFinalize) {
                return function (_ref6) {
                  var context = _ref6.context;
                  context.async = true;
                  setTimeout(function () {
                    context.finalize(doFinalize);
                  }, 100);
                };
              }; // do first drag passing false to finalize call


              scheduler.on('beforedragcreatefinalize', {
                fn: generateListener(false),
                once: true
              });
              t.willFireNTimes(scheduler, 'afterdragcreate', 2);
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                offset: [5, '100%+20'],
                by: [100, 0],
                dragOnly: true
              }, {
                waitForEvent: [scheduler, 'afterdragcreate'],
                trigger: {
                  mouseUp: null
                }
              }, {
                waitForSelectorNotFound: '.b-sch-event-wrap:not(.b-released)'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        // do second drag passing true to finalize call
                        scheduler.on('beforedragcreatefinalize', {
                          fn: generateListener(true),
                          once: true
                        });
                        t.selectorNotExists('.b-sch-event-wrap:not(.b-released)', 'Event not created');

                      case 2:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3);
              })), // The drag operation should cause only one width transition - that's at the mouseup.
              // The width changing during the drag must not be animated.
              function (next) {
                var transitionCount = 0;
                scheduler.contentElement.addEventListener('transitionstart', function (_ref8) {
                  var target = _ref8.target,
                      propertyName = _ref8.propertyName;

                  if (target.matches('.b-sch-event-wrap') && propertyName === 'width') {
                    if (++transitionCount > 1) {
                      t.fail('Only one event width animations should be started');
                    }
                  }
                });
                next();
              }, {
                drag: '.b-sch-timeaxis-cell',
                offset: [20, 75],
                by: [100, 0],
                dragOnly: true
              }, {
                waitForEvent: [scheduler, 'afterdragcreate'],
                trigger: {
                  mouseUp: null
                }
              }, {
                waitForProjectReady: scheduler
              }, function () {
                t.selectorExists('.b-sch-event-wrap:not(.b-released)', 'Event created');
                scheduler.destroy();
              });

            case 7:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x2) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should create an event if createValidator returns true', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var eventDragCreate;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              // For realism, we need all mouse events that are part of a drag path to fire.
              // Turbo mode only fires events at the start end end of the path, and to exercise
              // drag/drop code, we need it to fire the complete sequence.
              t.simulator.setSpeed('speedRun');
              _context5.next = 3;
              return t.getSchedulerAsync({
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 3, 3),
                features: {
                  eventEdit: false,
                  eventDragCreate: {
                    validatorFn: createFn
                  }
                },
                viewPreset: 'dayAndWeek',
                resourceStore: new ResourceStore({
                  data: [// Put some empty rows first to make sure tooltip fits above for alignment checks
                  {}, {}, {
                    id: 1,
                    name: 'Foo'
                  }]
                }),
                eventStore: new EventStore()
              });

            case 3:
              scheduler = _context5.sent;
              t.willFireNTimes(scheduler.eventStore, 'add', 2);
              t.wontFire(scheduler, 'scheduleclick');
              eventDragCreate = scheduler.features.eventDragCreate;
              t.chain({
                waitFor: 100
              }, {
                drag: '.b-sch-timeaxis-cell',
                fromOffset: [1, 2],
                by: [99, 0],
                dragOnly: true
              }, function (next) {
                var tipBox = eventDragCreate.tip.element.getBoundingClientRect(),
                    eventBox = eventDragCreate.dragging.context.element.getBoundingClientRect();
                t.isApprox(tipBox.right, eventBox.right, 15, 'Tip x should be aligned with proxy');
                t.isApprox(tipBox.top, eventBox.bottom, 10, 'Tip y should be aligned with proxy');
                next();
              }, {
                action: 'mouseUp'
              }, function (next) {
                scheduler.eventStore.removeAll();
                next();
              }, {
                drag: '.b-sch-timeaxis-cell',
                fromOffset: [1, 2],
                by: [99, 0],
                dragOnly: true
              }, function (next) {
                var tipBox = eventDragCreate.tip.element.getBoundingClientRect(),
                    eventBox = eventDragCreate.dragging.context.element.getBoundingClientRect();
                t.isApprox(tipBox.right, eventBox.right, 15, 'Tip x should be aligned with proxy');
                t.isApprox(tipBox.top, eventBox.bottom, 10, 'Tip y should be aligned with proxy');
                next();
              }, {
                action: 'mouseUp'
              }, function () {
                t.is(scheduler.eventStore.count, 1, '1 new event added');
                var event = scheduler.eventStore.first;
                t.is(event.startDate, new Date(2011, 0, 3), 'StartDate read ok');
                t.is(event.endDate, new Date(2011, 0, 4), 'EndDate read ok');
                t.simulator.setSpeed('turboMode');
              });

            case 8:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x3) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Should trigger scroll when creating event close to timeaxis edges', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2011, 0, 2),
                endDate: new Date(2011, 3, 3),
                viewPreset: 'weekAndMonth',
                resourceStore: new ResourceStore({
                  data: [// Put some empty rows first to make sure tooltip fits above for alignment checks
                  {}, {}, {
                    id: 1,
                    name: 'Foo'
                  }]
                }),
                eventStore: new EventStore(),
                features: {
                  eventEdit: false,
                  eventDragCreate: true
                }
              });

            case 2:
              scheduler = _context6.sent;
              //        t.firesAtLeastNTimes(viewEl, 'scroll', 1);
              t.is(scheduler.scrollLeft, 0, 'Scroll 0 initially');
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                fromOffset: [300, 2],
                to: '.b-scheduler',
                toOffset: ['100%-25', '50%'],
                dragOnly: true
              }, {
                waitFor: function waitFor() {
                  return scheduler.scrollLeft >= 200;
                },
                desc: 'Scrolling'
              }, {
                waitFor: 100
              }, function (next) {
                t.isGreater(scheduler.features.eventDragCreate.dragging.context.element.offsetWidth, 100, 'Proxy gained width');
                t.ok(scheduler.features.eventDragCreate.dragging, 'Still in dragging mode after scroll happened');
                next();
              }, {
                moveMouseBy: [[-30, 0]]
              }, {
                action: 'mouseUp'
              }, function () {
                var newEvent = scheduler.eventStore.first;
                t.isGreaterOrEqual(scheduler.scrollLeft, 100, 'Scrolled right');
                t.is(newEvent.startDate, new Date(2011, 0, 23));
              });

            case 5:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x4) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Created event element should not move after scroll (horizontal)', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var rect, el;
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return t.getSchedulerAsync({
                resourceStore: t.getResourceStore2({}, 30),
                features: {
                  eventEdit: false,
                  eventDragCreate: true
                }
              });

            case 2:
              scheduler = _context7.sent;
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                fromOffset: [2, 2],
                by: [30, 0],
                dragOnly: true
              }, function (next) {
                el = scheduler.features.eventDragCreate.dragging.context.element;
                rect = el.getBoundingClientRect();
                t.isLess(scheduler.bodyContainer.scrollTop, rect.top, 'DragCreator proxy is visible');
                scheduler.bodyContainer.scrollTop = 40;
                next();
              }, function (next) {
                var newRect = el.getBoundingClientRect();
                t.is(Math.round(newRect.top + 40), Math.round(rect.top), 'DragCreator proxy is not visible');
                next();
              }, {
                action: 'mouseUp'
              });

            case 4:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x5) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Hovertip should be disabled during dragcreate', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              scheduler = t.getScheduler();
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                offset: [5, 19],
                by: [40, 0],
                dragOnly: true
              }, {
                waitForSelectorNotFound: '.b-sch-scheduletip',
                desc: 'Hover tip is hidden'
              }, {
                mouseUp: null
              });

            case 2:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x6) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('Should create new event if overlaps are disabled', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return t.getSchedulerAsync({
                allowOverlap: false,
                resources: [{
                  id: 1,
                  name: 'Albert'
                }, {
                  id: 2,
                  name: 'Ben'
                }],
                events: [{
                  resourceId: 2,
                  startDate: '2011-01-04',
                  endDate: '2011-01-05'
                }]
              });

            case 2:
              scheduler = _context9.sent;
              t.chain({
                waitForSelector: '.b-sch-event'
              }, {
                drag: '.b-sch-timeaxis-cell',
                offset: [12, 12],
                by: [100, 0]
              }, function () {
                t.is(scheduler.eventStore.count, 2, '');
              });

            case 4:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x7) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('should add events when time axis is smaller than one day', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var oldCount;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventTooltip: true
                },
                events: []
              });

            case 2:
              scheduler = _context10.sent;
              oldCount = scheduler.eventStore.count;
              t.chain({
                drag: '.b-timeline-subgrid .b-grid-row[data-index="2"] > .b-sch-timeaxis-cell',
                offset: [202, 12],
                by: [46, 0]
              }, {
                type: 'Test'
              }, {
                click: 'button:contains(Save)'
              }, function () {
                t.is(scheduler.eventStore.count, oldCount + 1, 'Event has been added');
              });

            case 5:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x8) {
      return _ref14.apply(this, arguments);
    };
  }());
  t.it('Should not allow dragcreate if readOnly', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return t.getSchedulerAsync({
                events: [],
                readOnly: true,
                features: {
                  eventEdit: false,
                  eventDragCreate: true
                }
              });

            case 2:
              scheduler = _context11.sent;
              t.wontFire(scheduler, 'beforedragcreate');
              t.wontFire(scheduler, 'dragcreatestart');
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                offset: ['10%', 10],
                by: [50, 0]
              }, function () {
                t.selectorNotExists('.b-sch-event', 'Event not created on drag');
              });

            case 6:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x9) {
      return _ref15.apply(this, arguments);
    };
  }());
  t.it('Should work with AssignmentStore', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                resources: [{
                  id: 'r1',
                  name: 'Mike'
                }, {
                  id: 'r2',
                  name: 'Linda'
                }],
                events: [{
                  id: 1,
                  startDate: new Date(2017, 0, 1, 10),
                  endDate: new Date(2017, 0, 1, 12)
                }],
                assignments: [{
                  resourceId: 'r1',
                  eventId: 1
                }, {
                  resourceId: 'r2',
                  eventId: 1
                }],
                startDate: new Date(2017, 0, 1, 6),
                endDate: new Date(2017, 0, 1, 20),
                viewPreset: 'hourAndDay',
                enableEventAnimations: false,
                features: {
                  eventEdit: false,
                  eventTooltip: false,
                  scheduleTooltip: false,
                  eventDragCreate: {
                    showTooltip: false
                  }
                }
              });
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                offset: ['10%', 10],
                by: [50, 0]
              }, function () {
                t.selectorCountIs('.b-sch-event:not(.b-sch-released)', 3, 'Correct number of event elements');
                t.is(scheduler.assignmentStore.count, 3, 'Correct assignment count');
              });

            case 2:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x10) {
      return _ref16.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/6786

  t.it('Should be able to drag create across a milestone', /*#__PURE__*/function () {
    var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'hourAndDay',
                rowHeight: 60,
                barMargin: 15,
                resources: [{
                  id: 1,
                  name: 'Albert'
                }],
                events: [{
                  resourceId: 1,
                  startDate: new Date(2017, 11, 1, 10),
                  duration: 0
                }],
                startDate: new Date(2017, 11, 1, 9),
                endDate: new Date(2017, 11, 3, 9),
                features: {
                  eventTooltip: false,
                  scheduleTooltip: false,
                  eventDragCreate: {
                    showTooltip: false
                  }
                }
              });

            case 2:
              scheduler = _context13.sent;
              _context13.next = 5;
              return t.waitForProjectReady();

            case 5:
              t.ok(scheduler.eventStore.first.isMilestone, 'Event is milestone');
              t.chain([{
                waitForSelector: '.b-sch-event'
              }, {
                moveMouseTo: '.b-milestone',
                offset: [-15, 15]
              }, {
                mousedown: null
              }, {
                moveMouseBy: [10, -10]
              }, {
                mouseup: null
              }]);

            case 7:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x11) {
      return _ref17.apply(this, arguments);
    };
  }()); // Test tooltip alignment when the document is scrolled.

  if (document.scrollingElement) {
    t.it('Tooltip should align correctly', /*#__PURE__*/function () {
      var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
        return regeneratorRuntime.wrap(function _callee14$(_context14) {
          while (1) {
            switch (_context14.prev = _context14.next) {
              case 0:
                _context14.next = 2;
                return t.getSchedulerAsync({
                  viewPreset: 'hourAndDay',
                  startDate: new Date(2018, 3, 27),
                  endDate: new Date(2018, 3, 28)
                });

              case 2:
                scheduler = _context14.sent;
                // Visually the look should be the same, but the document is scrolled.
                document.scrollingElement.style.paddingTop = '1000px';
                document.scrollingElement.scrollTop = 1000;
                t.chain({
                  drag: '.b-sch-timeaxis-cell',
                  offset: ['10%', 10],
                  by: [50, 0],
                  dragOnly: true
                }, {
                  waitForSelector: '.b-sch-tip-valid'
                }, function (next) {
                  var proxy = scheduler.features.eventDragCreate.dragging.context.element,
                      tip = scheduler.features.eventDragCreate.tip;
                  t.isApprox(tip.element.getBoundingClientRect().top, proxy.getBoundingClientRect().bottom + tip.anchorSize[1], 'Resize tip is aligned just below the dragcreate proxy');
                  next();
                }, {
                  mouseUp: null
                });

              case 6:
              case "end":
                return _context14.stop();
            }
          }
        }, _callee14);
      }));

      return function (_x12) {
        return _ref18.apply(this, arguments);
      };
    }());
  }

  t.it('Should show message and block creation if validator returns object with `valid` false', /*#__PURE__*/function () {
    var _ref19 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventDragCreate: {
                    validatorFn: function validatorFn(_ref20, event) {
                      var resourceRecord = _ref20.resourceRecord;
                      return {
                        valid: false,
                        message: 'msg'
                      };
                    }
                  }
                },
                events: []
              });

            case 2:
              scheduler = _context15.sent;
              t.firesOnce(scheduler.eventStore, 'addPrecommit');
              t.firesOnce(scheduler.eventStore, 'removePrecommit');
              t.chain( // IE11 and Edge cannot drag 0 offset in automation mode
              {
                drag: '.b-sch-timeaxis-cell',
                offset: [100, BrowserHelper.isIE11 || BrowserHelper.isEdge || BrowserHelper.isFirefox ? 5 : 0],
                by: [50, 0],
                dragOnly: true
              }, {
                waitForSelector: '.b-tooltip .b-sch-tip-message:textEquals(msg)'
              }, {
                mouseUp: null
              });

            case 6:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x13) {
      return _ref19.apply(this, arguments);
    };
  }());
  t.it('Should not show message if validator returns object with `valid` true', /*#__PURE__*/function () {
    var _ref21 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: false,
                  eventDrag: {
                    validatorFn: function validatorFn(_ref22, event) {
                      var resourceRecord = _ref22.resourceRecord,
                          eventRecord = _ref22.eventRecord,
                          start = _ref22.start,
                          end = _ref22.end;
                      return {
                        valid: true
                      };
                    }
                  }
                },
                events: []
              });

            case 2:
              scheduler = _context16.sent;
              t.firesOnce(scheduler.eventStore, 'add');
              t.chain( // IE11 and Edge cannot drag 0 offset in automation mode
              {
                drag: '.b-sch-timeaxis-cell',
                offset: [100, BrowserHelper.isIE11 || BrowserHelper.isEdge || BrowserHelper.isFirefox ? 5 : 0],
                by: [50, 0],
                dragOnly: true
              }, {
                waitForSelector: '.b-tooltip .b-sch-tip-message:empty'
              }, {
                mouseUp: null
              });

            case 5:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x14) {
      return _ref21.apply(this, arguments);
    };
  }());
  t.it('Should consider undefined return value as valid action', /*#__PURE__*/function () {
    var _ref23 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: false,
                  eventDrag: {
                    validatorFn: function validatorFn(_ref24, event) {
                      var resourceRecord = _ref24.resourceRecord,
                          eventRecord = _ref24.eventRecord,
                          start = _ref24.start,
                          end = _ref24.end;
                    }
                  }
                },
                events: []
              });

            case 2:
              scheduler = _context17.sent;
              t.firesOnce(scheduler.eventStore, 'add');
              t.chain( // IE11 and Edge cannot drag 0 offset in automation mode
              {
                drag: '.b-sch-timeaxis-cell',
                offset: [100, BrowserHelper.isIE11 || BrowserHelper.isEdge || BrowserHelper.isFirefox ? 5 : 0],
                by: [50, 0]
              });

            case 5:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x15) {
      return _ref23.apply(this, arguments);
    };
  }());
  t.it('should not reset scroll position when finishing edit of newly created event', /*#__PURE__*/function () {
    var _ref25 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
      var oldCount;
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              _context18.next = 2;
              return t.getSchedulerAsync({
                height: 200,
                resourceStore: t.getResourceStore2({}, 30),
                features: {
                  eventEdit: true
                }
              });

            case 2:
              scheduler = _context18.sent;
              oldCount = scheduler.eventStore.count;
              scheduler.scrollable.y = scheduler.scrollable.maxY;
              t.chain({
                drag: '.b-timeline-subgrid .b-grid-row[data-index="29"] > .b-sch-timeaxis-cell',
                offset: [202, 12],
                by: [46, 0],
                dragOnly: true
              }, function (next) {
                t.wontFire(scheduler, 'scroll');
                next();
              }, {
                mouseUp: null
              }, {
                type: 'Test'
              }, {
                click: 'button:contains(Save)'
              }, function () {
                t.is(scheduler.eventStore.count, oldCount + 1, 'Event has been added');
                t.is(scheduler.eventStore.last.name, 'Test');
              });

            case 6:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    }));

    return function (_x16) {
      return _ref25.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7224/details

  t.it('Event should be visible if not reapplying filters', /*#__PURE__*/function () {
    var _ref26 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t) {
      var newEvent;
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              _context19.next = 2;
              return t.getSchedulerAsync({
                resourceStore: t.getResourceStore2({}, 3),
                features: {
                  eventEdit: true
                }
              });

            case 2:
              scheduler = _context19.sent;
              scheduler.eventStore.reapplyFilterOnAdd = false;
              scheduler.eventStore.filter('name', 'Assignment 1');
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                offset: [50, 10],
                by: [100, 0]
              }, {
                waitFor: function waitFor() {
                  return scheduler.features.eventEdit.editor.containsFocus;
                }
              }, function (next) {
                newEvent = scheduler.features.eventEdit.eventRecord;
                t.notOk(scheduler.eventStore.added.includes(newEvent));
                next();
              }, {
                type: 'New test event'
              }, {
                click: ':textEquals(Save)'
              }, function () {
                t.ok(scheduler.eventStore.added.includes(newEvent));
                t.selectorCountIs(scheduler.eventSelector + ':not(.b-sch-released) .b-sch-event', 2, 'Correct event element count');
              });

            case 6:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    }));

    return function (_x17) {
      return _ref26.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7224/details

  t.it('Drag proxy should be removed if event is filtered out', /*#__PURE__*/function () {
    var _ref27 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(t) {
      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              _context20.next = 2;
              return t.getSchedulerAsync({
                resourceStore: t.getResourceStore2({}, 3),
                features: {
                  eventEdit: true
                }
              });

            case 2:
              scheduler = _context20.sent;
              scheduler.eventStore.reapplyFilterOnAdd = true;
              scheduler.eventStore.filter('name', 'Assignment 1');
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                offset: [50, 10],
                by: [100, 0]
              }, {
                waitFor: function waitFor() {
                  return scheduler.features.eventEdit.editor.containsFocus;
                }
              }, {
                type: 'New test event'
              }, {
                click: ':textEquals(Save)'
              });

            case 6:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    }));

    return function (_x18) {
      return _ref27.apply(this, arguments);
    };
  }());
  t.it('Should fire scheduleclick, beforeeventadd and call onEventCreated after drag create operation', /*#__PURE__*/function () {
    var _ref28 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21(t) {
      return regeneratorRuntime.wrap(function _callee21$(_context21) {
        while (1) {
          switch (_context21.prev = _context21.next) {
            case 0:
              _context21.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2011, 0, 1),
                endDate: new Date(2011, 0, 2),
                resourceStore: new ResourceStore({
                  data: [{
                    id: 1,
                    name: 'Foo'
                  }, {}]
                }),
                eventStore: new EventStore()
              });

            case 2:
              scheduler = _context21.sent;
              t.firesOnce(scheduler, 'scheduleclick');
              t.isCalledOnce('onEventCreated', scheduler, 'onEventCreated hook is called once');
              t.firesOnce(scheduler, 'beforeeventadd', 'beforeeventadd is fired once');
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                fromOffset: [2, 2],
                by: [50, 0]
              }, {
                click: '.b-sch-timeaxis-cell'
              });

            case 7:
            case "end":
              return _context21.stop();
          }
        }
      }, _callee21);
    }));

    return function (_x19) {
      return _ref28.apply(this, arguments);
    };
  }());
  t.it('Should respect Scheduler#getDateConstraints', /*#__PURE__*/function () {
    var _ref29 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
      var called;
      return regeneratorRuntime.wrap(function _callee22$(_context22) {
        while (1) {
          switch (_context22.prev = _context22.next) {
            case 0:
              called = false;
              _context22.next = 3;
              return t.getSchedulerAsync({
                resources: [{
                  id: 'r1',
                  name: 'Resource 1'
                }],
                events: [],
                features: {
                  eventEdit: false
                },
                getDateConstraints: function getDateConstraints(resourceRecord, newEventRecord) {
                  t.ok(resourceRecord instanceof scheduler.resourceStore.modelClass, 'resourceRecord arg has correct type');
                  t.ok(newEventRecord instanceof scheduler.eventStore.modelClass, 'eventRecord arg has correct type');
                  called = true;
                  return {
                    start: new Date(2011, 0, 4),
                    end: new Date(2011, 0, 5)
                  };
                }
              });

            case 3:
              scheduler = _context22.sent;
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                offset: [100, '50%'],
                by: [200, 0]
              }, function () {
                t.ok(called, 'getDateConstraints() was called');
                t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 4), 'Correct startDate');
                t.is(scheduler.eventStore.first.endDate, new Date(2011, 0, 5), 'Correctly constrained endDate');
              });

            case 5:
            case "end":
              return _context22.stop();
          }
        }
      }, _callee22);
    }));

    return function (_x20) {
      return _ref29.apply(this, arguments);
    };
  }());
  t.it('Should abort on ESC key', /*#__PURE__*/function () {
    var _ref30 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23(t) {
      return regeneratorRuntime.wrap(function _callee23$(_context23) {
        while (1) {
          switch (_context23.prev = _context23.next) {
            case 0:
              _context23.next = 2;
              return t.getSchedulerAsync({
                resourceStore: new ResourceStore({
                  data: [{
                    id: 1
                  }]
                }),
                eventStore: new EventStore()
              });

            case 2:
              scheduler = _context23.sent;
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                fromOffset: [2, 2],
                by: [50, 0],
                dragOnly: true
              }, {
                type: '[ESCAPE]'
              }, function () {
                t.notOk(scheduler.features.eventDragCreate.dragging, 'not dragging');
              });

            case 4:
            case "end":
              return _context23.stop();
          }
        }
      }, _callee23);
    }));

    return function (_x21) {
      return _ref30.apply(this, arguments);
    };
  }());
  t.it('Should support disabling', /*#__PURE__*/function () {
    var _ref31 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee24(t) {
      return regeneratorRuntime.wrap(function _callee24$(_context24) {
        while (1) {
          switch (_context24.prev = _context24.next) {
            case 0:
              scheduler = t.getScheduler();
              scheduler.features.eventDragCreate.disabled = true;
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                fromOffset: [2, 2],
                by: [50, 0],
                dragOnly: true
              }, {
                mouseUp: null
              }, function (next) {
                scheduler.features.eventDragCreate.disabled = false;
                next();
              }, {
                drag: '.b-sch-timeaxis-cell',
                fromOffset: [2, 2],
                by: [50, 0],
                dragOnly: true
              }, {
                mouseUp: null
              });

            case 3:
            case "end":
              return _context24.stop();
          }
        }
      }, _callee24);
    }));

    return function (_x22) {
      return _ref31.apply(this, arguments);
    };
  }());
  t.it('Should handle external updates happening while editor is open', /*#__PURE__*/function () {
    var _ref32 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee26(t) {
      return regeneratorRuntime.wrap(function _callee26$(_context26) {
        while (1) {
          switch (_context26.prev = _context26.next) {
            case 0:
              _context26.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: true
                }
              });

            case 2:
              scheduler = _context26.sent;
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                fromOffset: [2, 2],
                by: [50, 0]
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee25() {
                return regeneratorRuntime.wrap(function _callee25$(_context25) {
                  while (1) {
                    switch (_context25.prev = _context25.next) {
                      case 0:
                        scheduler.resourceStore.insert(0, {});
                        t.selectorExists('.b-eventeditor', 'Editor still visible');

                      case 2:
                      case "end":
                        return _context25.stop();
                    }
                  }
                }, _callee25);
              })), {
                type: '[ESCAPE]'
              }, {
                waitForSelectorNotFound: '.b-eventeditor'
              });

            case 4:
            case "end":
              return _context26.stop();
          }
        }
      }, _callee26);
    }));

    return function (_x23) {
      return _ref32.apply(this, arguments);
    };
  }());
  t.it('Should not scroll vertical when drag creating event', /*#__PURE__*/function () {
    var _ref34 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee27(t) {
      return regeneratorRuntime.wrap(function _callee27$(_context27) {
        while (1) {
          switch (_context27.prev = _context27.next) {
            case 0:
              _context27.next = 2;
              return t.getSchedulerAsync({
                height: 300,
                events: []
              });

            case 2:
              scheduler = _context27.sent;
              _context27.next = 5;
              return t.dragBy({
                source: '.b-grid-subgrid-normal .b-grid-row[data-id="r3"]',
                offset: [50, '50%'],
                delta: [100, 0],
                dragOnly: true
              });

            case 5:
              _context27.next = 7;
              return t.moveMouseTo({
                target: scheduler.scrollable.element,
                offset: ['60%', '100%']
              });

            case 7:
              _context27.next = 9;
              return t.waitFor(1000);

            case 9:
              t.is(scheduler.scrollable.y, 0, 'Scheduler is not scrolled vertically');

            case 10:
            case "end":
              return _context27.stop();
          }
        }
      }, _callee27);
    }));

    return function (_x24) {
      return _ref34.apply(this, arguments);
    };
  }());
  t.it('Click on just-created element should cancel create', /*#__PURE__*/function () {
    var _ref35 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee28(t) {
      return regeneratorRuntime.wrap(function _callee28$(_context28) {
        while (1) {
          switch (_context28.prev = _context28.next) {
            case 0:
              _context28.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2011, 0, 1),
                endDate: new Date(2011, 0, 2),
                resourceStore: new ResourceStore({
                  data: [{
                    id: 1,
                    name: 'Foo'
                  }, {}]
                }),
                eventStore: new EventStore(),
                features: {
                  eventEdit: true
                }
              });

            case 2:
              scheduler = _context28.sent;
              _context28.next = 5;
              return t.dragBy({
                source: '.b-grid-subgrid-normal .b-grid-row[data-id="1"]',
                offset: [50, '50%'],
                delta: [100, 0]
              });

            case 5:
              _context28.next = 7;
              return t.waitFor(function () {
                var _scheduler$features$e;

                return (_scheduler$features$e = scheduler.features.eventEdit.editor) === null || _scheduler$features$e === void 0 ? void 0 : _scheduler$features$e.containsFocus;
              });

            case 7:
              _context28.next = 9;
              return t.click(scheduler.getEventElement(scheduler.eventStore.first));

            case 9:
            case "end":
              return _context28.stop();
          }
        }
      }, _callee28);
    }));

    return function (_x25) {
      return _ref35.apply(this, arguments);
    };
  }());
});