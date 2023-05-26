function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, scheduler2;

  function initSchedulers(_x, _x2, _x3) {
    return _initSchedulers.apply(this, arguments);
  }

  function _initSchedulers() {
    _initSchedulers = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t, cfg1, cfg2) {
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              _context19.next = 2;
              return t.getSchedulerAsync(Object.assign({
                id: 'first',
                height: 200,
                width: 500,
                features: {
                  eventDrag: {
                    constrainDragToTimeline: false
                  }
                },
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'foo',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }],
                eventRenderer: function eventRenderer(_ref19) {
                  var eventRecord = _ref19.eventRecord,
                      renderData = _ref19.renderData;
                  renderData.eventColor = 'yellow';
                  return eventRecord.name;
                }
              }, cfg1));

            case 2:
              scheduler = _context19.sent;
              _context19.next = 5;
              return t.getSchedulerAsync(Object.assign({
                id: 'second',
                height: 200,
                width: 500,
                events: [{
                  id: 2,
                  resourceId: 1,
                  name: 'bar',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }],
                features: {
                  eventDrag: {
                    constrainDragToTimeline: false,
                    showTooltip: false
                  }
                },
                resources: [{
                  id: 1,
                  name: 'Foo'
                }, {
                  id: 2,
                  name: 'Bar'
                }, {
                  id: 3,
                  name: 'Baz'
                }, {
                  id: 4,
                  name: 'Ketchup'
                }]
              }, cfg2));

            case 5:
              scheduler2 = _context19.sent;

            case 6:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    }));
    return _initSchedulers.apply(this, arguments);
  }

  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
    scheduler2 && scheduler2.destroy();
    scheduler = scheduler2 = null;
  });
  t.it('Should work to drag drop inside same scheduler without constrainDragToTimeline', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return initSchedulers(t);

            case 2:
              // date change + resourceId change fires separately now
              //t.firesOk(scheduler.eventStore, { update : 2 });
              t.firesOnce(scheduler.eventStore, 'update');
              t.chain({
                drag: '#first .b-sch-event',
                to: '#first .b-grid-row[data-index="1"] .b-sch-timeaxis-cell',
                toOffset: [100, '50%']
              }, function () {
                t.is(scheduler.eventStore.first.resourceId, 'r2');
              });

            case 4:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x4) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Should only affect own events when drag is inside scheduler when partnered', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return initSchedulers(t);

            case 2:
              scheduler2.partner = scheduler;
              t.isNot(scheduler.eventStore, scheduler2.eventStore, 'Not sharing event store');
              t.firesOnce(scheduler.eventStore, 'update');
              t.wontFire(scheduler2.eventStore, 'update');
              t.chain({
                drag: '#first .b-sch-event',
                by: [50, 0]
              });

            case 7:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x5) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Should trigger scroll manager of currently hovered scheduler', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var horizontal1, vertical1, horizontal2, vertical2;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return initSchedulers(t);

            case 2:
              horizontal1 = scheduler.subGrids.normal.scrollable, vertical1 = scheduler.scrollable, horizontal2 = scheduler2.subGrids.normal.scrollable, vertical2 = scheduler2.scrollable;
              t.chain({
                drag: '.b-sch-event',
                to: '#second',
                dragOnly: true,
                toOffset: ["100%-25", '100%-20']
              }, {
                waitFor: function waitFor() {
                  return Math.abs(horizontal2.x - horizontal2.maxX) <= 1 && Math.abs(vertical2.y - vertical2.maxY) <= 1;
                }
              }, {
                moveCursorTo: '#second .b-grid-headers-normal',
                offset: [5, '100%+5']
              }, {
                waitFor: function waitFor() {
                  return horizontal2.x === 0 && vertical2.y === 0;
                }
              }, {
                moveCursorTo: '#first .b-grid-headers-normal',
                offset: [5, '100%+5']
              }, {
                waitFor: function waitFor() {
                  return horizontal1.x === 0 && vertical1.y === 0;
                }
              }, {
                moveCursorTo: '#first',
                offset: ['100%-20', '100%-20']
              }, {
                waitFor: function waitFor() {
                  return Math.abs(horizontal1.x - horizontal1.maxX) <= 1 && Math.abs(vertical1.y - vertical1.maxY) <= 1;
                }
              }, {
                mouseUp: null
              });

            case 4:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x6) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should trigger scroll manager of source scheduler', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return initSchedulers(t);

            case 2:
              t.chain({
                drag: '.b-sch-event',
                to: '#first',
                dragOnly: true,
                toOffset: ['100%-20', '100%-20']
              }, {
                waitFor: function waitFor() {
                  return Math.abs(scheduler.subGrids.normal.scrollable.x - scheduler.subGrids.normal.scrollable.maxX) <= 1 && Math.abs(scheduler.scrollable.y - scheduler.scrollable.maxY) <= 1;
                }
              }, {
                moveCursorTo: '#first .b-grid-headers-normal',
                offset: [5, '100%+5']
              }, {
                waitFor: function waitFor() {
                  return scheduler.subGrids.normal.scrollable.x === 0 && scheduler.scrollable.y === 0;
                }
              }, {
                mouseUp: null
              });

            case 3:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x7) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should still behave normal for drag drop inside 1 scheduler', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return initSchedulers(t);

            case 2:
              t.firesOnce(scheduler.eventStore, 'update');
              t.wontFire(scheduler.eventStore, 'remove');
              t.wontFire(scheduler.eventStore, 'add');
              t.chain({
                drag: '#first .b-sch-event',
                by: [100, 10]
              });

            case 6:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x8) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should just result in an update action if target event store is the same after drag drop', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return initSchedulers(t);

            case 2:
              scheduler2.eventStore.removeAll();
              scheduler2.resourceStore.removeAll();
              scheduler2.resourceStore.add([{
                id: 1,
                name: 'Foo'
              }, {
                id: 2,
                name: 'Bar'
              }]); // Record is removed from scheduler

              t.firesOnce(scheduler.eventStore, 'remove');
              t.wontFire(scheduler.eventStore, 'add'); // And added to scheduler2

              t.wontFire(scheduler2.eventStore, 'remove');
              t.firesOnce(scheduler2.eventStore, 'add');
              t.chain({
                drag: '#first .b-sch-event',
                to: '#second .b-sch-timeaxis-cell',
                toOffset: [105, 25]
              }, function () {
                t.selectorExists('#second .b-sch-event:not(.b-sch-released)');
              });

            case 10:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x9) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Should remove dragged event from source store and add to new event store if target event store is not the same', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return initSchedulers(t);

            case 2:
              t.firesOnce(scheduler.eventStore, 'remove');
              t.firesOnce(scheduler.eventStore, 'update'); // From setting resourceId to null when removing the assignment

              t.firesOnce(scheduler2.eventStore, 'add');
              t.chain({
                drag: '#first .b-sch-event',
                to: '#second .b-sch-event',
                dragOnly: true
              }, {
                waitForSelectorNotFound: '#first.b-dragging-event'
              }, {
                waitForSelector: '#second.b-dragging-event'
              }, {
                mouseUp: null
              }, {
                waitForSelectorNotFound: '#first ' + scheduler.unreleasedEventSelector,
                desc: 'Top empty'
              }, {
                waitForSelectorNotFound: '.b-dragging-event'
              }, // Wait until there are two live events in scheduler 2
              {
                waitFor: function waitFor() {
                  return scheduler2.element.querySelectorAll('#second ' + scheduler.unreleasedEventSelector).length === 2;
                }
              }, function (next) {
                t.is(scheduler.eventStore.count, 0, 'Event removed');
                t.is(scheduler2.eventStore.count, 2, 'Event added');
                t.is(scheduler2.eventStore.last.resourceId, 1, 'New resource assigned');
                t.is(scheduler2.eventStore.last.name, 'foo', 'Name intact');
                t.is(scheduler2.eventStore.last.startDate, scheduler2.eventStore.first.startDate, 'Same start date'); // t.is(scheduler2.eventStore.last.isPhantom, true, 'Newly added event should be phantom if target event store is different');

                t.selectorCountIs('#second ' + scheduler.unreleasedEventSelector, 2);
                t.wontFire(scheduler2.scrollable, 'scroll');
                next();
              }, {
                moveCursorTo: '#second .b-grid-headers-normal',
                offset: [5, '100%+5']
              });

            case 6:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x10) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Should support drag to a new scheduler and back', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return initSchedulers(t);

            case 2:
              t.chain({
                drag: "#first ".concat(scheduler.eventSelector),
                to: '#second',
                dragOnly: true,
                toOffset: ['100%-25', '100%-25']
              }, {
                waitFor: function waitFor() {
                  return Math.abs(scheduler2.subGrids.normal.scrollable.x - scheduler2.subGrids.normal.scrollable.maxX) <= 1 && Math.abs(scheduler2.scrollable.y - scheduler2.scrollable.maxY) <= 1;
                }
              }, {
                moveMouseBy: [-20, -20]
              }, {
                mouseUp: null
              }, {
                waitForSelectorNotFound: "#first ".concat(scheduler.unreleasedEventSelector, " .b-sch-event")
              }, {
                drag: "#second ".concat(scheduler.unreleasedEventSelector, " .b-sch-event"),
                to: '#first',
                dragOnly: true,
                toOffset: ['100%-25', '100%-25']
              }, {
                waitFor: function waitFor() {
                  return Math.abs(scheduler.subGrids.normal.scrollable.x - scheduler.subGrids.normal.scrollable.maxX) <= 1 && Math.abs(scheduler.scrollable.y - scheduler.scrollable.maxY) <= 1;
                }
              }, {
                mouseUp: null
              }, {
                waitForSelectorNotFound: "#second ".concat(scheduler.unreleasedEventSelector, " .b-sch-event")
              }, function (next) {
                t.is(scheduler.eventStore.count, 1, '1 in first scheduler');
                t.is(scheduler2.eventStore.count, 1, '1 in second scheduler');
                next();
              }, {
                drag: "#first ".concat(scheduler.unreleasedEventSelector),
                to: '#second .b-grid-headers-normal',
                dragOnly: true,
                toOffset: [5, '100%+5']
              }, {
                waitFor: function waitFor() {
                  return scheduler2.subGrids.normal.scrollable.x === 0 && scheduler2.scrollable.y === 0;
                }
              }, {
                mouseUp: null
              }, {
                waitForSelectorNotFound: "#first ".concat(scheduler.unreleasedEventSelector, " .b-sch-event")
              });

            case 3:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x11) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Should distribute events to resources on multi drag between schedulers', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return initSchedulers(t, {
                multiEventSelect: true,
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'foo',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }, {
                  id: 3,
                  resourceId: 'r2',
                  name: 'test',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 5)
                }]
              }, {
                multiEventSelect: true
              });

            case 2:
              t.chain({
                click: '.b-sch-event-content:textEquals(test)'
              }, {
                drag: '.b-sch-event-content:textEquals(foo)',
                options: {
                  ctrlKey: true
                },
                to: '#second .b-sch-event'
              }, {
                waitForSelectorNotFound: '#first .b-sch-event:contains(test)'
              }, {
                waitForSelectorNotFound: '#first .b-sch-event:contains(foo)'
              }, {
                waitForSelector: '#second .b-sch-event:contains(test)'
              }, {
                waitForSelector: '#second .b-sch-event:contains(foo)'
              }, function () {
                t.is(scheduler2.resourceStore.getAt(0).events.length, 2, 'Top resource has 2 events after drop');
                t.is(scheduler2.resourceStore.getAt(1).events.length, 1, 'Second resource has 1 event after drop');
              });

            case 3:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x12) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Should activate scroll manager when dragging twice in same scheduler with cloneTarget', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return initSchedulers(t);

            case 2:
              t.firesOk(scheduler.eventStore, {
                update: 2
              });
              t.chain({
                drag: '#first .b-sch-event',
                by: [100, 0]
              }, {
                drag: '#first .b-sch-event',
                to: '#first',
                dragOnly: true,
                toOffset: ['100%-20', '50%']
              }, {
                waitFor: function waitFor() {
                  return scheduler.subGrids.normal.scrollable.x === scheduler.subGrids.normal.scrollable.maxX;
                }
              }, {
                mouseUp: null
              });

            case 4:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x13) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Should treat header of other scheduler as invalid drop position', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return initSchedulers(t);

            case 2:
              t.wontFire(scheduler.eventStore, 'update');
              t.wontFire(scheduler2.eventStore, 'update');
              t.wontFire(scheduler.eventStore, 'change');
              t.wontFire(scheduler2.eventStore, 'change');
              t.chain({
                waitForEvent: [document, 'transitionend'],
                trigger: {
                  drag: '#first .b-sch-event',
                  to: '#second .b-sch-header-timeaxis-cell'
                }
              }, {
                waitForSelector: '#first .b-sch-event:not(.b-released):textEquals(foo)'
              });

            case 7:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x14) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Should call validity checker on currently hovered Grid', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return initSchedulers(t);

            case 2:
              scheduler2.allowOverlap = false;
              t.wontFire(scheduler.eventStore, 'update');
              t.wontFire(scheduler2.eventStore, 'update');
              t.wontFire(scheduler.eventStore, 'change');
              t.wontFire(scheduler2.eventStore, 'change');
              t.chain({
                drag: '#first .b-sch-event',
                to: '#second .b-sch-event'
              });

            case 8:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x15) {
      return _ref12.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/9234

  t.it('Should not make event disappear when drag and dropping another event from the same row', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return initSchedulers(t, {
                enableEventAnimations: false,
                useInitialAnimation: false
              }, {
                enableEventAnimations: false,
                useInitialAnimation: false,
                events: [{
                  id: 2,
                  resourceId: 1,
                  name: 'bar',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }, {
                  id: 3,
                  resourceId: 1,
                  name: 'test',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 5)
                }]
              });

            case 2:
              t.chain( // drop on non valid area on the first grid
              {
                drag: '#second .b-sch-event:contains(test)',
                to: '#first .b-sch-header-timeaxis-cell'
              }, {
                waitForSelector: '#second .b-sch-event:contains(test)'
              }, // drop on valid area on the first grid
              {
                drag: '#second .b-sch-event:contains(bar)',
                to: '#first .b-sch-event'
              }, {
                waitForSelector: '#first .b-sch-event:contains(bar)'
              }, {
                waitForSelector: '#second .b-sch-event:contains(test)'
              });

            case 3:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x16) {
      return _ref13.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/207

  t.it('Should constrain dragging to the union of all partnered Schedulers', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _context14.next = 2;
              return initSchedulers(t, {
                enableEventAnimations: false,
                useInitialAnimation: false
              }, {
                enableEventAnimations: false,
                useInitialAnimation: false,
                events: [{
                  id: 2,
                  resourceId: 1,
                  name: 'bar',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }, {
                  id: 3,
                  resourceId: 1,
                  name: 'test',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 5)
                }]
              });

            case 2:
              t.chain( // Drag event downwards to the bottom of the second scheduler
              {
                drag: function drag() {
                  return '[data-event-id="1"]';
                },
                to: function to() {
                  return scheduler2.bodyContainer;
                },
                toOffset: ['50%', '100%-10'],
                dragOnly: true
              }, // Wait for it to reach its scroll limit and stop scrolling
              {
                waitFor: function waitFor() {
                  return !scheduler2.timeAxisSubGrid.scrolling;
                }
              }, {
                mouseup: null
              }, function () {
                // It should have reached the last row, and dropped there. The bug was that the Y constraining was not
                // allowing this. Cannot hoist record, it now always make a copy when dropping on another scheduler
                t.is(scheduler2.eventStore.last.resource, scheduler2.resourceStore.last, 'Drag/drop succeeded');
              });

            case 3:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x17) {
      return _ref14.apply(this, arguments);
    };
  }());
  t.it('Should trigger just 1 commit if using autoCommit', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return initSchedulers(t);

            case 2:
              scheduler.eventStore.autoCommit = true;
              t.firesOnce(scheduler.eventStore, 'commit');
              t.chain({
                drag: '#second .b-sch-event',
                to: '#first .b-sch-timeaxis-cell',
                toOffset: [100, '50%']
              });

            case 5:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x18) {
      return _ref15.apply(this, arguments);
    };
  }());
  t.it('Should stop scrolling when moving over a new Scheduler', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              _context18.next = 2;
              return initSchedulers(t, {
                enableEventAnimations: false,
                useInitialAnimation: false,
                resources: [{
                  id: 1
                }, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}]
              }, {
                enableEventAnimations: false,
                useInitialAnimation: false,
                events: [{
                  id: 2,
                  resourceId: 1,
                  name: 'bar',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }, {
                  id: 3,
                  resourceId: 1,
                  name: 'test',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 5)
                }]
              });

            case 2:
              scheduler.scrollManager.scrollSpeed = 100;
              t.waitForScrolling = false;
              t.chain( // Drag event downwards to the bottom of the second scheduler
              {
                drag: function drag() {
                  return '[data-event-id="2"]';
                },
                to: function to() {
                  return scheduler.bodyContainer;
                },
                toOffset: ['50%', '100%-10'],
                dragOnly: true
              }, {
                waitFor: function waitFor() {
                  return scheduler.scrolling;
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16() {
                return regeneratorRuntime.wrap(function _callee16$(_context16) {
                  while (1) {
                    switch (_context16.prev = _context16.next) {
                      case 0:
                        return _context16.abrupt("return", t.ok(scheduler.scrollManager.monitoring.has(scheduler.subGrids.normal.element), 'Active scrolling'));

                      case 1:
                      case "end":
                        return _context16.stop();
                    }
                  }
                }, _callee16);
              })), // Wait for top scheduler to start scrolling
              {
                moveCursorTo: scheduler2.bodyContainer,
                offset: ['50%', 10]
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17() {
                return regeneratorRuntime.wrap(function _callee17$(_context17) {
                  while (1) {
                    switch (_context17.prev = _context17.next) {
                      case 0:
                        return _context17.abrupt("return", t.notOk(scheduler.scrollManager.monitoring.has(scheduler.subGrids.normal.element), 'No active scrolling'));

                      case 1:
                      case "end":
                        return _context17.stop();
                    }
                  }
                }, _callee17);
              })), {
                waitFor: function waitFor() {
                  return !scheduler.scrolling;
                },
                desc: 'Stopped scrolling after hovering new scheduler'
              }, {
                mouseup: null
              });

            case 5:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    }));

    return function (_x19) {
      return _ref16.apply(this, arguments);
    };
  }());
});