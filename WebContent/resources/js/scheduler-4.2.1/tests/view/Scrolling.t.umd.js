function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    return scheduler && scheduler.destroy();
  });
  t.it('Should support scrolling event into view without animation', /*#__PURE__*/function () {
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
                resources: [{
                  id: 7,
                  name: 'Lee',
                  type: 'Marketing',
                  eventColor: 'green'
                }],
                events: [{
                  id: 11,
                  resourceId: 7,
                  name: 'Appointment #7',
                  startDate: '2017-02-07 15:00',
                  endDate: '2017-02-07 18:00',
                  iconCls: 'b-fa b-fa-calendar-alt'
                }],
                startDate: new Date(2017, 1, 7, 8),
                endDate: new Date(2017, 1, 7, 18),
                viewPreset: 'hourAndDay'
              });
              _context.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.chain(function (next) {
                t.waitForScrollChange(scheduler.subGrids.normal.element, 'left', next);
                scheduler.scrollEventIntoView(scheduler.eventStore.first, {
                  animate: false
                });
              }, {
                waitForHeaderAndBodyScrollSynced: scheduler
              }, function () {
                document.querySelector('.b-fa-calendar-alt').style.pointerEvents = 'all';
                t.elementIsTopElement('.b-fa-calendar-alt');
                t.isInView('.b-fa-calendar-alt');
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
  }()); // Do not run test on scrollbar-free env

  if (DomHelper.scrollBarWidth !== 0) {
    // Also tested in grid, but scheduler does not call super by design for one handler so test needed here also
    t.it('Should refresh fake scroller when adding first record', /*#__PURE__*/function () {
      var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
        return regeneratorRuntime.wrap(function _callee2$(_context2) {
          while (1) {
            switch (_context2.prev = _context2.next) {
              case 0:
                _context2.next = 2;
                return t.getSchedulerAsync({
                  resources: [],
                  events: []
                });

              case 2:
                scheduler = _context2.sent;
                scheduler.resourceStore.add({
                  id: 1
                });
                t.ok(t.isElementVisible(scheduler.virtualScrollers), 'Scroller shown');

              case 5:
              case "end":
                return _context2.stop();
            }
          }
        }, _callee2);
      }));

      return function (_x2) {
        return _ref2.apply(this, arguments);
      };
    }()); // https://app.assembla.com/spaces/bryntum/tickets/7443

    t.it('Should not get stuck in infinite scrollbar toggling', /*#__PURE__*/function () {
      var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
        return regeneratorRuntime.wrap(function _callee3$(_context3) {
          while (1) {
            switch (_context3.prev = _context3.next) {
              case 0:
                _context3.next = 2;
                return t.getSchedulerAsync({
                  // Different height for IE11 since headers are a bit lower there
                  height: t.browser.msie ? 333 : 353,
                  width: 600,
                  tickSize: 35
                });

              case 2:
                scheduler = _context3.sent;
                // "Internal" resize triggered by render is on a timeout to prevent ResizeMonitor loop crash, so a single
                // update is expected.
                // Seems not triggered any longer after HorizontalTimeAxis refactoring
                t.firesOk(scheduler.timeAxisViewModel, {
                  update: '<=1'
                });
                t.chain( // Need to give it some time to toggle back and forth (or rather not toggle if fix is working)
                {
                  waitFor: 500
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
  }

  t.it('Should correctly update scroll range when adding resources in succession', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var i;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync();

            case 2:
              scheduler = _context4.sent;

              for (i = 0; i < 50; i++) {
                scheduler.resourceStore.add({
                  name: "r".concat(i + 11)
                });
              }

              _context4.next = 6;
              return t.waitForProjectReady();

            case 6:
              t.is(scheduler.scrollable.scrollHeight, scheduler.resourceStore.count * scheduler.rowManager.rowOffsetHeight, 'Correct scrollHeight');

            case 7:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7563

  t.it('Should not scroll scheduler without header when clicking row', function (t) {
    scheduler = t.getScheduler({
      hideHeaders: true,
      sanityCheck: false // Sanity check does not work with hidden headers

    });
    scheduler.scrollLeft = 80;
    t.chain({
      click: '.b-sch-timeaxis-cell'
    }, function () {
      t.is(scheduler.scrollLeft, 80, 'Did not scroll after click');
    });
  });
  t.it('Should use initial animation, not when scrolling', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              scheduler = t.getScheduler({
                useInitialAnimation: true,
                startDate: new Date(2019, 0, 25),
                endDate: new Date(2019, 0, 31),
                resources: ArrayHelper.populate(100, function (i) {
                  return {
                    id: i + 1
                  };
                }),
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2019, 0, 25, 0),
                  endDate: new Date(2019, 0, 25, 12)
                }, {
                  id: 2,
                  resourceId: 80,
                  startDate: new Date(2019, 0, 25, 0),
                  endDate: new Date(2019, 0, 25, 12)
                }]
              });
              _context5.next = 3;
              return t.waitFor(function () {
                return !scheduler.isFirstRender;
              });

            case 3:
              _context5.next = 5;
              return scheduler.scrollEventIntoView(scheduler.eventStore.last);

            case 5:
              t.selectorNotExists('.b-initial-fade-in', 'Initial animation no longer applied');

            case 6:
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
  t.it('should draw events correctly after scrolling into view', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getSchedulerAsync({
                columns: [{
                  text: 'Machines',
                  field: 'name',
                  width: 130
                }],
                resources: [{
                  id: 'r13',
                  name: 'Robot 4'
                }, {
                  id: 'r15',
                  name: 'Robot 6'
                }],
                events: [{
                  id: 4,
                  resourceId: 'r13',
                  startDate: '2019-12-10',
                  duration: 5
                }, {
                  id: 6,
                  resourceId: 'r15',
                  startDate: '2019-12-03',
                  duration: 12
                }],
                startDate: '2019-11-29',
                endDate: '2019-12-27',
                viewPreset: 'dayAndWeek'
              });

            case 2:
              scheduler = _context6.sent;
              _context6.next = 5;
              return scheduler.scrollEventIntoView(scheduler.eventStore.last);

            case 5:
              t.selectorExists('[data-event-id="6"]', 'Target event rendered');
              t.selectorExists('[data-event-id="4"]', 'Other event rendered');
              t.selectorExists('[data-tick-index="11"]', 'Other events start tick rendered');

            case 8:
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
  t.it('Scrolling a focused event quickly out of view', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var events, i, j, averageRowHeight, resizeEventEl, scrollTimer;
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              t.waitForScrolling = false;
              events = [];

              for (i = 0; i < 200; i++) {
                j = i * 2;
                events.push({
                  id: j + 1,
                  resourceId: "r".concat(i + 1),
                  name: "Event ".concat(j + 1),
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                });
                events.push({
                  id: j + 2,
                  resourceId: "r".concat(i + 1),
                  name: "Event ".concat(j + 2),
                  startDate: new Date(2011, 0, 5),
                  endDate: new Date(2011, 0, 7)
                });
              }

              _context7.next = 5;
              return t.getSchedulerAsync({
                features: {
                  eventDrag: {
                    showTooltip: false
                  },
                  eventTooltip: false,
                  scheduleTooltip: false
                },
                resources: ArrayHelper.populate(200, function (i) {
                  return {
                    id: "r".concat(i + 1),
                    name: "Resource ".concat(i + 1)
                  };
                }),
                events: events
              });

            case 5:
              scheduler = _context7.sent;
              // Focus exit to the scheduler's encapsulating element upon event derender caused by scroll
              // was erroneously focusing a grid cell causing a spurious scrollIntoView
              t.isCalledNTimes('focusCell', scheduler, 0, 'Scrolling does not cause cell focus'); // https://github.com/bryntum/support/issues/263
              // The issue was that event record change was causing a potential row height change.
              // This attempted to "reset" the RowManager's averageRowHeight by setting it to null.
              // The next incremental adjustment of that then calculates a small value.

              t.chain({
                waitForSelector: scheduler.eventSelector
              }, function (next) {
                averageRowHeight = scheduler.rowManager.averageRowHeight;
                scrollTimer = setInterval(function () {
                  return scheduler.scrollable.y += 50;
                }, 50);
                next();
              }, {
                waitFor: function waitFor() {
                  return scheduler.getElementFromEventRecord(scheduler.eventStore.getAt(90));
                }
              }, function (next) {
                clearInterval(scrollTimer);
                next();
              }, {
                waitFor: function waitFor() {
                  return !scheduler.scrolling;
                }
              }, function (next) {
                t.is(scheduler.rowManager.averageRowHeight, averageRowHeight, 'Average row height is unchanged');
                resizeEventEl = scheduler.getElementFromEventRecord(scheduler.eventStore.getAt(70));
                next();
              }, {
                moveCursorTo: function moveCursorTo() {
                  return resizeEventEl;
                }
              }, {
                drag: function drag() {
                  return resizeEventEl;
                },
                offset: ['100%-3', 5],
                by: [100, 0]
              }, function (next) {
                scrollTimer = setInterval(function () {
                  return scheduler.scrollable.y += 50;
                }, 100);
                next();
              }, {
                waitFor: function waitFor() {
                  return document.activeElement !== resizeEventEl.parentNode;
                }
              }, function (next) {
                clearInterval(scrollTimer);
                next();
              }, {
                waitFor: function waitFor() {
                  return !scheduler.scrolling;
                }
              }, function () {
                t.is(scheduler.rowManager.averageRowHeight, averageRowHeight, 'Average row height is unchanged');
              });

            case 8:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x7) {
      return _ref7.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/331

  t.it('Should not crash when calling scrollEventInto view with schedule subgrid collapsed', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                width: 600,
                columns: [{
                  field: 'name',
                  width: 150
                }],
                resources: [{
                  id: 1,
                  name: 'Lee'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  name: 'Appointment #7',
                  startDate: '2017-02-07',
                  endDate: '2017-02-08'
                }],
                startDate: new Date(2017, 1, 7, 8),
                endDate: new Date(2017, 1, 7, 18)
              });
              _context8.next = 3;
              return t.waitForProjectReady();

            case 3:
              _context8.next = 5;
              return scheduler.subGrids.normal.collapse();

            case 5:
              _context8.next = 7;
              return scheduler.scrollEventIntoView(scheduler.eventStore.first);

            case 7:
              scheduler.startDate = new Date(2019, 1, 7, 8);
              _context8.next = 10;
              return scheduler.subGrids.normal.expand();

            case 10:
              _context8.next = 12;
              return scheduler.scrollEventIntoView(scheduler.eventStore.first);

            case 12:
              t.selectorExists(scheduler.unreleasedEventSelector, 'Event scrolled into view');

            case 13:
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
  t.it('Should scroll resource into view if an event is not scheduled', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                width: 600,
                height: 300,
                columns: [{
                  field: 'name',
                  width: 150
                }],
                resources: [{
                  id: 1
                }, {
                  id: 2
                }, {
                  id: 3
                }, {
                  id: 4
                }, {
                  id: 5
                }, {
                  id: 6
                }, {
                  id: 7
                }, {
                  id: 8
                }, {
                  id: 9
                }],
                events: [{
                  id: 1,
                  resourceId: 9,
                  name: 'unscheduled'
                }]
              });
              _context9.next = 3;
              return t.waitForProjectReady();

            case 3:
              _context9.next = 5;
              return scheduler.scrollEventIntoView(scheduler.eventStore.first);

            case 5:
              t.elementIsTopElement('.b-grid-row[data-index="8"] .b-grid-cell', 'Row scrolled into view');

            case 6:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x9) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Should respect time axis incremement setting when calling scrollToNow', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2017, 0, 1, 6),
                endDate: new Date(2017, 0, 1, 20),
                viewPreset: 'minuteAndHour'
              });
              _context10.next = 3;
              return scheduler.scrollToNow({
                block: 'center'
              });

            case 3:
              t.is(scheduler.timeAxis.increment, 30, '30 min increments');
              t.is(scheduler.timeAxis.getAt(0).startDate.getMinutes() % 30, 0, '1st tick minutes correctly snapped');
              t.is(scheduler.timeAxis.getAt(1).startDate.getMinutes() % 30, 0, '2nd tick minutes correctly snapped');

            case 6:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x10) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Should support specifying a date to scroll to initially', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                viewPreset: 'dayAndWeek',
                width: 1000,
                tickSize: 50,
                resources: [],
                events: [],
                startDate: new Date(2017, 1, 0),
                endDate: new Date(2017, 3, 0),
                visibleDate: new Date(2017, 2, 1)
              });
              _context11.next = 3;
              return t.waitForElementTop('.b-sch-header-timeaxis-cell:contains(We 01)');

            case 3:
              t.isApprox(scheduler.scrollable.x, 500, 'Scrolled date to right viewport edge');

            case 4:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x11) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Should support specifying an object defining the initial scroll of the time axis', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                viewPreset: 'dayAndWeek',
                width: 1000,
                tickSize: 50,
                resources: [],
                events: [],
                startDate: new Date(2017, 1, 0),
                endDate: new Date(2017, 5, 0),
                visibleDate: {
                  date: new Date(2017, 3, 1),
                  block: 'start',
                  animate: 100
                }
              });
              _context12.next = 3;
              return t.waitForScroll();

            case 3:
              _context12.next = 5;
              return t.waitForElementTop('.b-sch-header-timeaxis-cell:contains(Sa 01)');

            case 5:
              t.isApprox(scheduler.scrollable.x, (28 + 31) * 50, 'Scrolled date to left viewport edge');

            case 6:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x12) {
      return _ref12.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2200

  t.it('Should support scrolling an event into view when its resource is inside a collapsed parent', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      var resourceStore;
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                // TODO, this test fails if run with all other tests before it and startDate/endDate below commented out
                startDate: new Date(2017, 11, 1),
                endDate: new Date(2017, 11, 20),
                features: {
                  tree: true
                },
                columns: [{
                  type: 'tree',
                  field: 'name'
                }],
                resources: [{
                  id: 1,
                  name: 'Airport',
                  expanded: false,
                  children: [{
                    id: 2,
                    name: 'Terminal',
                    expanded: false,
                    children: [{
                      id: 3,
                      name: 'Gate',
                      leaf: true
                    }]
                  }]
                }],
                events: [{
                  id: 1,
                  resourceId: 3,
                  name: 'Boarding',
                  startDate: '2017-12-02',
                  endDate: '2017-12-10'
                }]
              });
              resourceStore = scheduler.resourceStore;
              scheduler.scrollEventIntoView(scheduler.eventStore.first);
              _context13.next = 5;
              return t.waitForElementTop('.b-sch-event:contains(Boarding)');

            case 5:
              t.ok(resourceStore.getById(1).isExpanded(resourceStore), 'parent 1 expanded');
              t.ok(resourceStore.getById(2).isExpanded(resourceStore), 'parent 2 expanded');

            case 7:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x13) {
      return _ref13.apply(this, arguments);
    };
  }());
});