function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr == null ? null : typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]; if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      var config,
          nbrEvents,
          scheduler,
          _args13 = arguments;
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              config = _args13.length > 1 && _args13[1] !== undefined ? _args13[1] : {};
              nbrEvents = _args13.length > 2 ? _args13[2] : undefined;
              scheduler = t.getScheduler(config, nbrEvents);
              _context13.next = 5;
              return t.waitForProjectReady();

            case 5:
              return _context13.abrupt("return", scheduler);

            case 6:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });
  t.it('Should not be possible to resize event if resize is in progress', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var eventStore, resizeContext, eventWidth, event2Box;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler(t, {
                startDate: new Date(2018, 4, 3),
                endDate: new Date(2018, 4, 5),
                viewPreset: 'hourAndDay',
                events: [{
                  startDate: new Date(2018, 4, 3, 5),
                  endDate: new Date(2018, 4, 3, 8),
                  id: 1,
                  cls: 'event-1',
                  resourceId: 'r2'
                }, {
                  startDate: new Date(2018, 4, 3, 5),
                  endDate: new Date(2018, 4, 3, 8),
                  id: 2,
                  cls: 'event-2',
                  resourceId: 'r3'
                }]
              });

            case 2:
              scheduler = _context.sent;
              eventStore = scheduler.eventStore;
              scheduler.on('beforeeventresizefinalize', function (_ref2) {
                var context = _ref2.context;
                context.async = true;
                resizeContext = context;
              });
              eventWidth = document.querySelector('.event-1').offsetWidth, event2Box = document.querySelector('.event-2').getBoundingClientRect();
              t.chain({
                drag: '.event-1',
                offset: ['100%-5', '50%'],
                by: [100, 0]
              }, {
                drag: [event2Box.right - 5, (event2Box.top + event2Box.bottom) / 2],
                offset: ['100%-5', '50%'],
                by: [100, 0]
              }, {
                drag: [event2Box.right - 5, (event2Box.top + event2Box.bottom) / 2],
                offset: ['100%-5', '50%'],
                by: [100, 0]
              }, {
                waitForEvent: [scheduler, 'eventResizeEnd'],
                trigger: function trigger() {
                  // Finish the first tried resize
                  resizeContext.finalize(true);
                  t.isGreater(eventStore.getAt(0).endDate, new Date(2018, 4, 3, 9), 'First event resized');
                  t.isGreater(document.querySelector('.event-1').offsetWidth, eventWidth, 'Event is visually bigger');
                  t.is(eventStore.getAt(1).endDate, new Date(2018, 4, 3, 8), 'Second event is not');
                  t.is(document.querySelector('.event-2').offsetWidth, eventWidth, 'Event is visually same');
                }
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
  t.it('Should be possible to resize when using AssignmentStore', function (t) {
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
      enableEventAnimations: false
    });
    t.chain({
      waitForProjectReady: scheduler
    }, {
      drag: '[data-event-id="1"]',
      offset: ['100%-5', 10],
      by: [65, 0]
    }, function () {
      t.is(scheduler.eventStore.first.endDate, new Date(2017, 0, 1, 13), 'endDate updated');

      var _Array$from = Array.from(document.querySelectorAll('[data-event-id="1"]')),
          _Array$from2 = _slicedToArray(_Array$from, 2),
          first = _Array$from2[0],
          second = _Array$from2[1];

      t.is(first.getBoundingClientRect().width, second.getBoundingClientRect().width, 'Both instances resized');
    });
  });
  t.it('Resize should work with empty dependency store', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      features: {
        dependencies: true,
        eventTooltip: false
      },
      resources: [{
        id: 'r1',
        name: 'Mike'
      }, {
        id: 'r2',
        name: 'Linda'
      }],
      events: [{
        id: 1,
        resourceId: 'r1',
        startDate: new Date(2017, 0, 1, 10),
        endDate: new Date(2017, 0, 1, 12)
      }, {
        id: 2,
        resourceId: 'r2',
        startDate: new Date(2017, 0, 1, 10),
        endDate: new Date(2017, 0, 1, 12)
      }],
      startDate: new Date(2017, 0, 1, 6),
      endDate: new Date(2017, 0, 1, 20),
      viewPreset: 'hourAndDay',
      enableEventAnimations: false
    });
    t.firesOnce(scheduler, 'eventresizeend');
    t.chain({
      waitForProjectReady: scheduler
    }, {
      drag: '.b-sch-event',
      fromOffset: ['100%-5', '50%'],
      by: [50, 0]
    });
  });
  t.it('Resize should not leave extra elements', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                features: {
                  dependencies: true,
                  eventTooltip: false
                },
                resources: [{
                  id: 'r1',
                  name: 'Mike'
                }, {
                  id: 'r2',
                  name: 'Linda'
                }],
                events: [{
                  id: 1,
                  cls: 'event1',
                  resourceId: 'r1',
                  startDate: new Date(2017, 0, 1, 10),
                  endDate: new Date(2017, 0, 1, 12)
                }, {
                  id: 2,
                  cls: 'event2',
                  resourceId: 'r2',
                  startDate: new Date(2017, 0, 1, 10),
                  endDate: new Date(2017, 0, 1, 12)
                }],
                dependencies: [{
                  from: 1,
                  to: 2
                }],
                startDate: new Date(2017, 0, 1, 6),
                endDate: new Date(2017, 0, 1, 20),
                viewPreset: 'hourAndDay',
                enableEventAnimations: false
              });
              t.firesOk({
                observable: scheduler,
                events: {
                  eventresizeend: 3
                }
              });
              scheduler.on('eventresizeend', function (_ref4) {
                var eventRecord = _ref4.eventRecord;
                scheduler.events[0].setEndDate(eventRecord.endDate, false);
              });
              t.chain({
                drag: '.event2',
                fromOffset: ['100%-5', '50%'],
                by: [scheduler.tickSize, 0]
              }, function (next) {
                t.isLessOrEqual(document.querySelectorAll('.event2 .b-sch-terminal').length, 4, 'No extra terminals found');
                next();
              }, {
                drag: '.event2',
                fromOffset: ['100%-5', '50%'],
                by: [scheduler.tickSize, 0]
              }, function (next) {
                t.isLessOrEqual(document.querySelectorAll('.event2 .b-sch-terminal').length, 4, 'No extra terminals found');
                next();
              }, {
                drag: '.event2',
                fromOffset: ['100%-5', '50%'],
                by: [-scheduler.tickSize, 0],
                dragOnly: true
              }, {
                moveMouseBy: [0, 50]
              }, {
                moveMouseBy: [-scheduler.tickSize, -50]
              }, function (next) {
                t.isLessOrEqual(document.querySelectorAll('.event2 .b-sch-terminal').length, 4, 'No extra terminals found');
                next();
              }, {
                mouseUp: null
              }, function (next) {
                t.isLessOrEqual(document.querySelectorAll('.event2 .b-sch-terminal').length, 4, 'No extra terminals found');
                next();
              });

            case 4:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should finalize refresh UI if operation is cancelled asynchronously ', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var eventWidth;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getScheduler(t, {
                startDate: new Date(2018, 4, 3),
                endDate: new Date(2018, 4, 5),
                viewPreset: 'hourAndDay',
                events: [{
                  startDate: new Date(2018, 4, 3, 5),
                  endDate: new Date(2018, 4, 3, 8),
                  id: 1,
                  cls: 'event-1',
                  resourceId: 'r2'
                }]
              });

            case 2:
              scheduler = _context3.sent;
              scheduler.on('beforeeventresizefinalize', function (_ref6) {
                var context = _ref6.context;
                context.async = true;
                setTimeout(function () {
                  return context.finalize(false);
                }, 100);
              });
              eventWidth = document.querySelector('.event-1').offsetWidth;
              t.chain({
                drag: '.event-1',
                offset: ['100%-5', '50%'],
                by: [200, 0]
              }, {
                waitFor: function waitFor() {
                  return document.querySelector('.event-1').offsetWidth === eventWidth;
                }
              }, function () {
                t.is(document.querySelector('.event-1').offsetWidth, eventWidth, 'Event is visually same');
              });

            case 6:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x4) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should work with custom non-continuous timeaxis', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return getScheduler(t, {
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }],
                timeAxis: {
                  continuous: false,
                  generateTicks: function generateTicks(start, end, unit, increment) {
                    var ticks = [];

                    while (start < end) {
                      if ([1, 2, 3].includes(start.getDay())) {
                        ticks.push({
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
              scheduler = _context4.sent;
              t.chain({
                drag: '.b-sch-event',
                offset: ['100%-3', '50%'],
                by: [scheduler.tickSize, 0]
              }, function () {
                t.isApprox(document.querySelector(scheduler.unreleasedEventSelector).offsetWidth, scheduler.tickSize * 3, 'Correct width after resize');
                t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 4), 'startDate still them same');
                t.is(scheduler.eventStore.first.endDate, new Date(2011, 0, 11), 'endDate correct');
              });

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x5) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('ScrollManager should not scroll vertically while resizing', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return getScheduler(t, {
                startDate: new Date(2017, 0, 1, 4),
                height: 210,
                viewPreset: 'hourAndDay',
                resourceStore: t.getResourceStore2({}, 100),
                events: [{
                  resourceId: 'r3',
                  id: 1,
                  startDate: new Date(2017, 0, 1, 6),
                  endDate: new Date(2017, 0, 1, 8)
                }],
                features: {
                  eventDrag: {
                    constrainDragToResource: true
                  }
                }
              });

            case 2:
              scheduler = _context5.sent;
              t.wontFire(scheduler.scrollable, 'scroll');
              t.chain({
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                fromOffset: ['100%-2', '50%'],
                by: [200, 0]
              });

            case 5:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x6) {
      return _ref8.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8898

  t.it('Should be possible to resize semi-small events', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return getScheduler(t, {
                features: {
                  eventTooltip: false
                }
              });

            case 2:
              scheduler = _context6.sent;
              scheduler.zoomToLevel('weekAndDayLetter');
              scheduler.tickSize = 5;
              t.chain({
                drag: '[data-event-id="1"]',
                offset: [1, 5],
                by: [-10, 0]
              }, {
                waitForProjectReady: scheduler
              }, function (next) {
                t.is(document.querySelector('[data-event-id="1"]').offsetWidth, 20, 'Resized left');
                next();
              }, {
                drag: '[data-event-id="2"]',
                offset: ['100%-1', 5],
                by: [10, 0]
              }, {
                waitForProjectReady: scheduler
              }, function (next) {
                t.is(document.querySelector('[data-event-id="2"]').offsetWidth, 20, 'Resized right');
                next();
              }, {
                drag: '[data-event-id="3"]',
                offset: ['50%', 5],
                by: [10, 0]
              }, {
                waitForProjectReady: scheduler
              }, function () {
                t.is(document.querySelector('[data-event-id="3"]').offsetWidth, 10, 'Not resized');
                t.isApprox(t.rect('[data-event-id="3"]').left, 424, 0.5, 'Moved');
              });

            case 6:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x7) {
      return _ref9.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1546

  t.it('Should not be possible to resize very small events, drag drop is prioritized in this case', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var el;
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return getScheduler(t, {
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  duration: 0.05
                }]
              }, 1);

            case 2:
              scheduler = _context7.sent;
              _context7.next = 5;
              return t.waitForAnimations();

            case 5:
              el = t.query(scheduler.unreleasedEventSelector)[0];
              t.wontFire(scheduler, 'beforeEventResize');
              t.wontFire(scheduler, 'beforeDragCreate');
              t.is(el.offsetWidth, 5, 'Small event, 5px wide'); // Start drag at every x coordinate in the 5px wide event

              _context7.next = 11;
              return t.dragBy('.b-sch-event', [20, 0], null, null, null, false, [0, 10]);

            case 11:
              _context7.next = 13;
              return t.dragBy('.b-sch-event', [20, 0], null, null, null, false, [1, 10]);

            case 13:
              _context7.next = 15;
              return t.dragBy('.b-sch-event', [20, 0], null, null, null, false, [2, 10]);

            case 15:
              _context7.next = 17;
              return t.dragBy('.b-sch-event', [20, 0], null, null, null, false, [3, 10]);

            case 17:
              _context7.next = 19;
              return t.dragBy('.b-sch-event', [20, 0], null, null, null, false, [4, 10]);

            case 19:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x8) {
      return _ref10.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/410

  t.it('Event element should stay visible when drag resized to 0 duration in horizontal mode', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              scheduler = t.getScheduler({
                features: {
                  eventResize: {
                    showExactResizePosition: true
                  }
                }
              }, 1);
              _context8.next = 3;
              return t.waitForProjectReady();

            case 3:
              _context8.next = 5;
              return t.dragBy('.b-sch-event', [-250, 0], null, null, null, true, ['100%-2', '50%']);

            case 5:
              t.ok(document.querySelector('.b-sch-event-wrap').offsetWidth, 'Event container is visible');
              t.ok(document.querySelector('.b-sch-event').offsetWidth, 'Event is visible');

            case 7:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x9) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Event element should stay visible when drag resized to 0 duration in vertical mode', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              scheduler = t.getScheduler({
                mode: 'vertical',
                features: {
                  eventResize: {
                    showExactResizePosition: true
                  }
                }
              }, 1);
              _context9.next = 3;
              return t.waitForProjectReady();

            case 3:
              _context9.next = 5;
              return t.dragBy('.b-sch-event', [0, -250], null, null, null, true, ['50%', '100%-2']);

            case 5:
              t.isGreater(document.querySelector('.b-sch-event-wrap').offsetHeight, 0, 'Event container is visible');
              t.isGreater(document.querySelector('.b-sch-event').offsetHeight, 0, 'Event is visible');

            case 7:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x10) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('should work crossing TimeAxis window boundaries', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var timeAxisChangeCount, event, jan27th, eventEl;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              timeAxisChangeCount = 0;
              _context10.next = 3;
              return getScheduler(t, {
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
              scheduler = _context10.sent;
              event = scheduler.eventStore.first, jan27th = new Date(2019, 0, 27); // So that the drag snaps to a day boundary making test reliable

              scheduler.timeAxis.resolutionUnit = 'day';
              _context10.next = 8;
              return t.mouseDown(scheduler.eventSelector, null, ['100%-2', '50%']);

            case 8:
              _context10.next = 10;
              return t.moveMouseTo(scheduler.timeAxisSubGridElement, null, null, [scheduler.timeAxisSubGridElement.offsetWidth - 20, 25]);

            case 10:
              _context10.next = 12;
              return t.waitFor({
                method: function method() {
                  return timeAxisChangeCount === 2 && scheduler.getDateFromCoordinate(scheduler.timeAxisSubGridElement.offsetWidth + scheduler.timelineScroller.x - 20, null, true) > jan27th;
                },
                timeout: 60000
              });

            case 12:
              _context10.next = 14;
              return t.mouseUp();

            case 14:
              _context10.next = 16;
              return t.waitFor(function () {
                return !scheduler.features.eventResize.context;
              });

            case 16:
              // Get the wrapper.
              eventEl = scheduler.getElementFromEventRecord(event, event.resource, true); // 6th Dec 2019 is at X=400 now that we have shifted once (since the initial shift).

              t.isApproxPx(DomHelper.getTranslateX(eventEl), 400, 'Event element\'s start point correct');
              t.is(eventEl.offsetWidth, 5200, 'Event element\'s length correct');
              t.selectorCountIs("".concat(scheduler.eventSelector, ":not(.b-released)"), 1, 'Event element is present'); // Event endpoint dragged end into future time axis frame

              t.is(event.endDate, new Date(2019, 0, 27));

            case 21:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x11) {
      return _ref13.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2945

  t.it('Should allow resizing to zero duration if allowResizeToZero is set', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              scheduler = t.getScheduler({
                features: {
                  eventResize: {
                    allowResizeToZero: true
                  }
                }
              }, 1);
              _context11.next = 3;
              return t.waitForProjectReady();

            case 3:
              _context11.next = 5;
              return t.dragBy('.b-sch-event', [-250, 0], null, null, null, false, ['100%-2', '50%']);

            case 5:
              t.is(scheduler.eventStore.first.duration, 0, '0 duration in data');
              t.selectorExists('.b-milestone-wrap', 'Event is zero duration === milestone');

            case 7:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x12) {
      return _ref14.apply(this, arguments);
    };
  }());
  t.it('Should not fail on clicking resize handle after drag create', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              scheduler = t.getScheduler({
                features: {
                  eventEdit: true
                }
              }, 4);
              _context12.next = 3;
              return t.dragBy('[data-region="normal"] .b-grid-row', [10, 0], null, null, null, false, [10, '50%']);

            case 3:
              _context12.next = 5;
              return t.click('[data-event-id="4"]', null, null, null, [5, '50%']);

            case 5:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x13) {
      return _ref15.apply(this, arguments);
    };
  }());
});