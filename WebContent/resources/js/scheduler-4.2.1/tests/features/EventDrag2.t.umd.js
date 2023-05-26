function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  // Cannot figure how to get window/body scroll in Edge, although API works even in IE11
  if (BrowserHelper.isEdge) {
    return;
  }

  var scheduler;
  t.beforeEach(function () {
    scheduler && !scheduler.isDestroyed && scheduler.destroy();
  });

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(config) {
      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              scheduler = t.getScheduler(Object.assign({
                features: {
                  eventDrag: true
                }
              }, config));
              _context20.next = 3;
              return t.waitForProjectReady(scheduler);

            case 3:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('ScrollManager should not react if dragging is constrained vertically', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler({
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
              t.wontFire(scheduler.scrollable, 'scroll');
              t.chain({
                drag: scheduler.eventSelector,
                by: [200, 0]
              }, function () {
                t.selectorNotExists('.b-dragging-event');
              });

            case 4:
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
  t.it('Should clear dragging CSS class after invalid drag', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getScheduler({
                startDate: new Date(2017, 0, 1, 4),
                height: 210,
                viewPreset: 'hourAndDay',
                events: [{
                  resourceId: 'r3',
                  id: 1,
                  startDate: new Date(2017, 0, 1, 6),
                  endDate: new Date(2017, 0, 1, 8)
                }]
              });

            case 2:
              t.chain({
                drag: scheduler.eventSelector,
                to: [0, 0]
              }, function () {
                t.selectorNotExists('.b-dragging-event');
              });

            case 3:
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
  t.it('Should deselect events on drag without Ctrl', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getScheduler({
                multiEventSelect: true
              });

            case 2:
              t.chain({
                click: '[data-event-id=3]'
              }, {
                click: '[data-event-id=2]',
                options: {
                  ctrlKey: true
                }
              }, function (next) {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2], 'Correct selection initially');
                next();
              }, {
                drag: '[data-event-id=1]',
                by: [50, 0]
              }, function () {
                // Dragging an unselected event does affect the selection
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [1], 'Selection is replaced by dragging a non-selected event');
              });

            case 3:
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
  t.it('Should support disabling', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return getScheduler({
                startDate: new Date(2017, 0, 1, 4),
                height: 210,
                viewPreset: 'hourAndDay',
                resources: [{
                  id: 1
                }],
                events: [{
                  resourceId: 1,
                  id: 1,
                  startDate: new Date(2017, 0, 1, 6),
                  endDate: new Date(2017, 0, 1, 8)
                }]
              });

            case 2:
              scheduler.features.eventDrag.disabled = true;
              t.wontFire(scheduler, 'eventdragstart');
              t.chain({
                drag: scheduler.eventSelector,
                by: [20, 0]
              }, function () {
                t.selectorNotExists('.b-dragging-event');
              });

            case 5:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x5) {
      return _ref4.apply(this, arguments);
    };
  }()); // TODO: Expected behaviour is no longer correct, drag does full redraw

  t.xit('Should not draw all dependencies after valid drop where rowHeight is unaffected', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
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
                  startDate: new Date(2011, 0, 8),
                  endDate: new Date(2011, 0, 9)
                }],
                dependencies: [{
                  from: 1,
                  to: 2
                }]
              });

            case 2:
              t.chain({
                drag: scheduler.eventSelector,
                by: [-100, 0],
                dragOnly: true
              }, function (next) {
                scheduler.on('dependenciesdrawn', function (_ref6) {
                  var partial = _ref6.partial;

                  if (!partial) {
                    t.fail('Full refresh done');
                  } else {
                    t.pass('Partial redraw done');
                  }
                });
                next();
              }, {
                mouseUp: null
              }, // Wait a little to ensure nothing is fired
              {
                waitFor: 500
              });

            case 3:
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
  t.it('should scroll correctly during drag after a previous drag/drop has caused a row height change', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var _scheduler, eventStore, scrollable, e2, e3, check, checkInterval;

      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return getScheduler({
                height: 700,
                width: 900,
                startDate: new Date(2018, 1, 7, 8),
                endDate: new Date(2018, 1, 7, 22),
                viewPreset: 'hourAndDay',
                rowHeight: 46,
                barMargin: 5,
                multiEventSelect: true,
                features: {
                  eventTooltip: false
                },
                events: [{
                  id: 1,
                  resourceId: 'a',
                  name: 'Meeting #1',
                  desc: 'Discuss new features',
                  startDate: '2018-02-07 11:00',
                  endDate: '2018-02-07 14:00',
                  eventType: 'Meeting',
                  eventColor: 'blue',
                  iconCls: 'b-fa b-fa-calendar'
                }, {
                  id: 2,
                  resourceId: 'b',
                  name: 'Meeting #2',
                  desc: 'Strategy meeting',
                  startDate: '2018-02-07 12:00',
                  endDate: '2018-02-07 15:00',
                  eventType: 'Meeting',
                  eventColor: 'blue',
                  iconCls: 'b-fa b-fa-calendar'
                }, {
                  id: 3,
                  resourceId: 'c',
                  name: 'Meeting #3',
                  desc: 'Emerging markets',
                  startDate: '2018-02-07 13:00',
                  endDate: '2018-02-07 16:00',
                  eventType: 'Meeting',
                  eventColor: 'blue',
                  iconCls: 'b-fa b-fa-calendar'
                }, {
                  id: 4,
                  resourceId: 'd',
                  name: 'Meeting #4',
                  desc: 'Code review',
                  startDate: '2018-02-07 09:00',
                  endDate: '2018-02-07 11:00',
                  eventType: 'Meeting',
                  eventColor: 'blue',
                  iconCls: 'b-fa b-fa-calendar'
                }, {
                  id: 5,
                  resourceId: 'e',
                  name: 'Appointment #1',
                  desc: 'Dental',
                  startDate: '2018-02-07 10:00',
                  endDate: '2018-02-07 12:00',
                  eventType: 'Appointment',
                  iconCls: 'b-fa b-fa-clock'
                }, {
                  id: 6,
                  resourceId: 'f',
                  name: 'Appointment #2',
                  desc: 'Golf preparations',
                  startDate: '2018-02-07 11:00',
                  endDate: '2018-02-07 13:00',
                  eventType: 'Appointment',
                  iconCls: 'b-fa b-fa-golf-ball'
                }, {
                  id: 7,
                  resourceId: 'g',
                  name: 'Appointment #3',
                  desc: 'Important',
                  startDate: '2018-02-07 14:00',
                  endDate: '2018-02-07 17:00',
                  location: 'Home office',
                  eventColor: 'red',
                  eventType: 'Appointment',
                  iconCls: 'b-fa b-fa-exclamation-circle'
                }, {
                  id: 8,
                  resourceId: 'h',
                  name: 'Meeting #5',
                  desc: 'Planning',
                  startDate: '2018-02-07 13:00',
                  endDate: '2018-02-07 15:00',
                  eventType: 'Meeting',
                  eventColor: 'blue',
                  iconCls: 'b-fa b-fa-calendar'
                }, {
                  id: 9,
                  resourceId: 'i',
                  name: 'Important activity',
                  desc: 'Hanging at the bar',
                  startDate: '2018-02-07 16:00',
                  endDate: '2018-02-07 19:00',
                  eventType: 'Appointment',
                  iconCls: 'b-fa b-fa-beer',
                  eventColor: 'orange'
                }, {
                  id: 10,
                  resourceId: 'j',
                  name: 'Overtime',
                  desc: 'Deadline approaching',
                  startDate: '2018-02-07 17:00',
                  endDate: '2018-02-07 20:00',
                  eventType: 'Meeting',
                  iconCls: 'b-fa b-fa-calendar',
                  eventColor: 'blue'
                }, {
                  id: 11,
                  resourceId: 'k',
                  name: 'Scrum',
                  desc: 'Team A',
                  startDate: '2018-02-07 9:00',
                  endDate: '2018-02-07 11:00',
                  eventType: 'Appointment',
                  iconCls: 'b-fa b-fa-calendar',
                  eventColor: 'blue'
                }],
                resources: [{
                  id: 'a',
                  name: 'Arcady',
                  role: 'Developer'
                }, {
                  id: 'b',
                  name: 'Dave',
                  role: 'Sales'
                }, {
                  id: 'c',
                  name: 'Henrik',
                  role: 'Sales'
                }, {
                  id: 'f',
                  name: 'Celia',
                  role: 'CEO'
                }, {
                  id: 'g',
                  name: 'Lee',
                  role: 'CTO'
                }, {
                  id: 'd',
                  name: 'Madison',
                  role: 'Developer'
                }, {
                  id: 'e',
                  name: 'Maxim',
                  role: 'Developer'
                }, {
                  id: 'h',
                  name: 'Amit',
                  role: 'Sales'
                }, {
                  id: 'i',
                  name: 'Kate',
                  role: 'Developer'
                }, {
                  id: 'j',
                  name: 'Mark',
                  role: 'Developer'
                }, {
                  id: 'k',
                  name: 'Emilia',
                  role: 'Developer'
                }, {
                  id: 'l',
                  name: 'Lillo',
                  role: 'Developer'
                }, {
                  id: 'm',
                  name: 'Pluto',
                  role: 'Sales'
                }, {
                  id: 'n',
                  name: 'Topolino',
                  role: 'Sales'
                }, {
                  id: 'o',
                  name: 'Paperino',
                  role: 'CEO'
                }, {
                  id: 'p',
                  name: 'Nonna Papera',
                  role: 'CTO'
                }, {
                  id: 'q',
                  name: 'Donald Duck',
                  role: 'Developer'
                }, {
                  id: 'r',
                  name: 'Stecchino',
                  role: 'Developer'
                }, {
                  id: 's',
                  name: 'Lalit',
                  role: 'Sales'
                }, {
                  id: 't',
                  name: 'Bassotto',
                  role: 'Developer'
                }, {
                  id: 'u',
                  name: 'Maradona',
                  role: 'Developer'
                }, {
                  id: 'v',
                  name: 'Anne',
                  role: 'Developer'
                }, {
                  id: 'w',
                  name: 'John',
                  role: 'Developer'
                }, {
                  id: 'x',
                  name: 'Michael',
                  role: 'Developer'
                }, {
                  id: 'y',
                  name: 'El',
                  role: 'Developer'
                }, {
                  id: 'z',
                  name: 'Mario',
                  role: 'Developer'
                }]
              });

            case 2:
              _scheduler = scheduler, eventStore = _scheduler.eventStore, scrollable = _scheduler.scrollable, e2 = eventStore.getById(2), e3 = eventStore.getById(3), check = function check() {
                var rows = document.querySelectorAll('.b-grid-subgrid-normal .b-grid-row'),
                    rowsByIndex = {};

                for (var i = 0; i < rows.length; i++) {
                  var index = rows[i].dataset.index;

                  if (rowsByIndex[index]) {
                    clearInterval(checkInterval);
                    t.fail('Duplicate index ' + index);
                  }

                  rowsByIndex[index] = rows[i];
                }
              }, checkInterval = setInterval(check, 1 / 60);
              t.chain( // Height adjustment is buffered
              {
                waitForEvent: [scheduler.rowManager, 'changeTotalHeight'],
                trigger: {
                  // This should make the scheduler scroll height taller.
                  drag: scheduler.getElementFromEventRecord(e2),
                  by: [0, -75]
                }
              }, // Drag event 3 to the bottom of the scheduler
              {
                drag: scheduler.getElementFromEventRecord(e3),
                by: [0, 465],
                dragOnly: true
              }, // Hold if there until we have scrolled to the bottom of the dataset
              {
                waitFor: function waitFor() {
                  return t.samePx(scrollable.y, scrollable.maxY);
                }
              }, // Drop event 3
              {
                mouseup: null
              }, {
                waitForAnimationFrame: null
              }, function (next) {
                // It must have allowed us to drop on the bottom resource
                t.is(e3.resource, scheduler.resourceStore.last);
                next();
              }, // It should scroll back to 0, triggering changeTotalHeight which should be ignored.
              {
                waitForEvent: [scrollable, 'scrollend'],
                trigger: function trigger() {
                  return scrollable.scrollTo(null, 0, {
                    animate: true,
                    force: true
                  });
                }
              }, function () {
                clearInterval(checkInterval);
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
  t.it('Should correctly display proxy position on scrolled page', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      var DoTest, _DoTest;

      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _DoTest = function _DoTest3() {
                _DoTest = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t, constrainDragToTimeline) {
                  var scrollable, container, originalBox;
                  return regeneratorRuntime.wrap(function _callee10$(_context10) {
                    while (1) {
                      switch (_context10.prev = _context10.next) {
                        case 0:
                          // In Firefox 74 extra scrolling occurs when you start dragging event on a scrolled body.
                          // This is only reproducible in siesta, when body inside the frame is scrollable. Scroll occurs when
                          // resize monitor is setup on the body and `b-resize-monitored` class is added to the body element.
                          // Solution for the test is to avoid scrolling body and scroll block element instead.
                          scrollable = document.createElement('div');
                          scrollable.id = 'foo';
                          scrollable.style.height = '600px';
                          scrollable.style.overflow = 'auto';
                          container = document.createElement('div');
                          container.id = 'bar';
                          container.style.marginTop = '400px';
                          scrollable.appendChild(container);
                          document.body.appendChild(scrollable);
                          scheduler = t.getScheduler({
                            appendTo: 'bar',
                            height: 500,
                            features: {
                              eventDrag: {
                                constrainDragToTimeline: constrainDragToTimeline
                              }
                            },
                            enableEventAnimations: false
                          });
                          _context10.next = 12;
                          return t.waitForProjectReady(scheduler);

                        case 12:
                          t.chain({
                            waitForSelector: '.b-sch-event-wrap'
                          }, function (next, els) {
                            scrollable.scrollTop = 200;
                            t.waitFor(function () {
                              return t.samePx(scrollable.scrollTop, 200);
                            }, function () {
                              originalBox = els[0].getBoundingClientRect();
                              next();
                            });
                          }, {
                            drag: '.b-sch-event',
                            by: [100, 0],
                            dragOnly: true
                          }, function (next) {
                            var el = document.querySelector('.b-dragging:not(.b-hidden)') || scheduler.features.eventDrag.drag.context.element,
                                box = el.getBoundingClientRect();
                            t.isApproxPx(box.left, originalBox.left + 100, 1, 'Event drag proxy is positioned correctly');
                            t.isApproxPx(box.top, originalBox.top, 1, 'Event drag proxy is positioned correctly');
                            next();
                          }, {
                            moveMouseTo: '.b-scheduler',
                            offset: [200, -100]
                          }, {
                            mouseUp: null
                          }, {
                            waitForSelectorNotFound: '.b-dragging'
                          }, {
                            waitForElementVisible: '.b-sch-event.event1'
                          }, {
                            waitFor: function waitFor() {
                              if (constrainDragToTimeline) {
                                return true;
                              } // The drag upwards, outside of the timeline will have done a revert
                              // for the non-constraining case. Wait for the animation to settle
                              // into the correct original position
                              else {
                                  var el = document.querySelector('.b-sch-event.event1'),
                                      box = el.getBoundingClientRect();
                                  return t.samePx(box.left, originalBox.left) && t.samePx(box.top, originalBox.top);
                                }
                            }
                          }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9() {
                            return regeneratorRuntime.wrap(function _callee9$(_context9) {
                              while (1) {
                                switch (_context9.prev = _context9.next) {
                                  case 0:
                                    scrollable.remove();

                                  case 1:
                                  case "end":
                                    return _context9.stop();
                                }
                              }
                            }, _callee9);
                          })));

                        case 13:
                        case "end":
                          return _context10.stop();
                      }
                    }
                  }, _callee10);
                }));
                return _DoTest.apply(this, arguments);
              };

              DoTest = function _DoTest2(_x9, _x10) {
                return _DoTest.apply(this, arguments);
              };

              t.it('Constrained to timeline', /*#__PURE__*/function () {
                var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
                  return regeneratorRuntime.wrap(function _callee7$(_context7) {
                    while (1) {
                      switch (_context7.prev = _context7.next) {
                        case 0:
                          _context7.next = 2;
                          return DoTest(t, true);

                        case 2:
                        case "end":
                          return _context7.stop();
                      }
                    }
                  }, _callee7);
                }));

                return function (_x11) {
                  return _ref9.apply(this, arguments);
                };
              }());
              t.it('Not constrained to timeline', /*#__PURE__*/function () {
                var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
                  return regeneratorRuntime.wrap(function _callee8$(_context8) {
                    while (1) {
                      switch (_context8.prev = _context8.next) {
                        case 0:
                          _context8.next = 2;
                          return DoTest(t, false);

                        case 2:
                        case "end":
                          return _context8.stop();
                      }
                    }
                  }, _callee8);
                }));

                return function (_x12) {
                  return _ref10.apply(this, arguments);
                };
              }());

            case 4:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x8) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Should not fail on dragging event outside view with working time preset', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return getScheduler({
                startDate: new Date(2011, 0, 6),
                endDate: new Date(2011, 0, 7),
                workingTime: {
                  fromDay: 1,
                  toDay: 6
                },
                events: [{
                  resourceId: 'r3',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }]
              });

            case 2:
              t.chain({
                drag: scheduler.eventSelector,
                by: [-50, -50]
              }, {
                drag: scheduler.eventSelector,
                by: [100, 100]
              });

            case 3:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x13) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('Should be possible to toggle constrainDragToResource programmatically + before drag is starting', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return getScheduler({
                startDate: new Date(2017, 0, 1, 4),
                height: 210,
                resourceStore: t.getResourceStore2({}, 3),
                events: [{
                  resourceId: 'r3',
                  id: 1,
                  startDate: new Date(2017, 0, 1),
                  endDate: new Date(2017, 0, 2)
                }],
                features: {
                  eventDrag: {
                    constrainDragToResource: true
                  }
                }
              });

            case 2:
              scheduler.features.eventDrag.constrainDragToResource = false;
              t.chain({
                drag: scheduler.eventSelector,
                by: [100, -50]
              }, {
                waitForSelectorNotFound: '.b-dragging-event'
              }, function (next) {
                t.is(scheduler.eventStore.first.resourceId, 'r2', 'constrainDragToResource was set dynamically, drag vertically worked');
                scheduler.on('beforeEventDrag', function () {
                  return scheduler.features.eventDrag.constrainDragToResource = true;
                });
                next();
              }, {
                drag: scheduler.eventSelector,
                by: [100, 50]
              }, {
                waitForSelectorNotFound: '.b-dragging-event'
              }, function () {
                return t.is(scheduler.eventStore.first.resourceId, 'r2', 'constrainDragToResource was set in ´beforeDragStart´, drag vertically was not allowed');
              });

            case 4:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x14) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('Should be possible to freely drag unconstrained event after dragging a constrained event', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return getScheduler({
                startDate: new Date(2017, 0, 1, 4),
                height: 210,
                resourceStore: t.getResourceStore2({}, 3),
                events: [{
                  resourceId: 'r3',
                  name: 'constrained',
                  id: 1,
                  startDate: new Date(2017, 0, 1),
                  endDate: new Date(2017, 0, 2)
                }, {
                  resourceId: 'r3',
                  name: 'free',
                  id: 2,
                  startDate: new Date(2017, 0, 1),
                  endDate: new Date(2017, 0, 2)
                }],
                features: {
                  eventDrag: {
                    constrainDragToTimeSlot: true
                  }
                }
              });

            case 2:
              t.chain({
                drag: scheduler.eventSelector + ':contains(constrained)',
                by: [100, 0]
              }, {
                waitForSelectorNotFound: '.b-dragging-event'
              }, function (next) {
                t.firesOnce(scheduler.eventStore, 'update');
                scheduler.on('beforeEventDrag', function () {
                  scheduler.features.eventDrag.constrainDragToResource = false;
                  scheduler.features.eventDrag.constrainDragToTimeSlot = false;
                });
                t.is(scheduler.eventStore.first.startDate, new Date(2017, 0, 1), 'constrainDragToTimeSlot enabled');
                next();
              }, {
                drag: scheduler.eventSelector + ':contains(free)',
                by: [200, 0],
                dragOnly: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14() {
                return regeneratorRuntime.wrap(function _callee14$(_context14) {
                  while (1) {
                    switch (_context14.prev = _context14.next) {
                      case 0:
                        return _context14.abrupt("return", t.isGreater(t.query(scheduler.eventSelector + ':contains(free)')[0].getBoundingClientRect().left, t.query(scheduler.eventSelector + ':contains(constrained)')[0].getBoundingClientRect().left, 'Free event could move along x-axis'));

                      case 1:
                      case "end":
                        return _context14.stop();
                    }
                  }
                }, _callee14);
              })), {
                mouseUp: null
              }, {
                waitForSelectorNotFound: '.b-dragging-event'
              }, function () {
                return t.isGreater(scheduler.eventStore.last.startDate, new Date(2017, 0, 1), 'constrainDragToTimeSlot disabled');
              });

            case 3:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x15) {
      return _ref14.apply(this, arguments);
    };
  }());
  t.it('Should never affect start date of dragged event if constrainDragToTimeSlot is true', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      var eventLeft;
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return getScheduler({
                startDate: new Date(2017, 0, 1, 4),
                height: 210,
                resourceStore: t.getResourceStore2({}, 3),
                viewPreset: 'hourAndDay',
                snap: true,
                timeResolution: 15,
                events: [{
                  resourceId: 'r3',
                  name: 'constrained',
                  id: 1,
                  startDate: new Date(2017, 0, 1, 5, 20),
                  endDate: new Date(2017, 0, 1, 6, 20)
                }],
                features: {
                  eventDrag: {
                    constrainDragToTimeSlot: true
                  }
                }
              });

            case 2:
              t.firesOnce(scheduler.eventStore, 'update');
              eventLeft = t.rect('.b-sch-event').left;
              t.chain({
                drag: scheduler.eventSelector + ':contains(constrained)',
                by: [30, -100],
                dragOnly: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16() {
                return regeneratorRuntime.wrap(function _callee16$(_context16) {
                  while (1) {
                    switch (_context16.prev = _context16.next) {
                      case 0:
                        t.isApprox(t.rect('.b-sch-event').left, eventLeft, 0.5, 'Drag proxy x position intact');

                      case 1:
                      case "end":
                        return _context16.stop();
                    }
                  }
                }, _callee16);
              })), {
                mouseUp: null
              }, {
                waitForSelectorNotFound: '.b-dragging-event'
              }, function () {
                t.is(scheduler.eventStore.last.startDate, new Date(2017, 0, 1, 5, 20), 'Start date intact');
              });

            case 5:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x16) {
      return _ref16.apply(this, arguments);
    };
  }());
  t.it('Should support snap in vertical mode', /*#__PURE__*/function () {
    var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t) {
      var eventRect;
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              _context19.next = 2;
              return getScheduler({
                startDate: new Date(2017, 0, 1, 4),
                resourceStore: t.getResourceStore2({}, 3),
                viewPreset: 'hourAndDay',
                mode: 'vertical',
                snap: true,
                timeResolution: 60,
                events: [{
                  resourceId: 'r1',
                  id: 1,
                  startDate: new Date(2017, 0, 1, 5),
                  endDate: new Date(2017, 0, 1, 6)
                }]
              });

            case 2:
              t.firesOnce(scheduler.eventStore, 'update');
              eventRect = t.rect('.b-sch-event');
              t.chain({
                drag: scheduler.eventSelector,
                by: [0, scheduler.tickSize * 0.8],
                dragOnly: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18() {
                return regeneratorRuntime.wrap(function _callee18$(_context18) {
                  while (1) {
                    switch (_context18.prev = _context18.next) {
                      case 0:
                        t.is(t.rect('.b-sch-event').left, eventRect.left, 'Drag proxy x intact');
                        t.is(t.rect('.b-sch-event').top, eventRect.top + scheduler.tickSize, 'Drag proxy snapped to timeResolution value');

                      case 2:
                      case "end":
                        return _context18.stop();
                    }
                  }
                }, _callee18);
              })), {
                mouseUp: null
              }, {
                waitForSelectorNotFound: '.b-dragging-event'
              }, function () {
                t.is(scheduler.eventStore.last.startDate, new Date(2017, 0, 1, 6), 'Start date correct');
                t.is(scheduler.eventStore.last.endDate, new Date(2017, 0, 1, 7), 'End date correct');
              });

            case 5:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    }));

    return function (_x17) {
      return _ref18.apply(this, arguments);
    };
  }());
});