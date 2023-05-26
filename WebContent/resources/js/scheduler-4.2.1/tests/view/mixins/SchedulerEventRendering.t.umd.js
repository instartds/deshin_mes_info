function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    return scheduler && !scheduler.isDestroyed && scheduler.destroy();
  });
  t.it('fillTicks should make all event widths multipliers of tickSize', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var elements;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                startDate: '2018-05-11',
                endDate: '2018-05-18',
                resources: [{
                  id: 1,
                  name: 'Carl Lewis'
                }, {
                  id: 2,
                  name: 'Ben Johnson'
                }],
                events: [{
                  resourceId: 1,
                  name: '100m',
                  startDate: '2018-05-11 15:00',
                  duration: 10,
                  durationUnit: 'seconds'
                }, {
                  resourceId: 1,
                  name: 'Long jump',
                  startDate: '2018-05-11 16:00',
                  duration: 4,
                  durationUnit: 'hours'
                }, {
                  resourceId: 1,
                  name: '200m',
                  startDate: '2018-05-13 10:00',
                  duration: 21,
                  durationUnit: 'seconds'
                }, {
                  resourceId: 2,
                  name: '100m',
                  startDate: '2018-05-11 15:00',
                  duration: 11,
                  durationUnit: 'seconds'
                }],
                fillTicks: true
              });

            case 2:
              scheduler = _context.sent;
              elements = Array.from(document.querySelectorAll(scheduler.unreleasedEventSelector));
              elements.forEach(function (element) {
                return t.isApprox(element.getBoundingClientRect().width, scheduler.tickSize, 0.5, 'Event has correct width');
              });

            case 5:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/194

  t.it('fillTicks should make event ending at midnight the correct size', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                startDate: '2018-05-11',
                endDate: '2018-05-18',
                resources: [{
                  id: 1,
                  name: 'Carl Lewis'
                }, {
                  id: 2,
                  name: 'Ben Johnson'
                }],
                events: [{
                  resourceId: 1,
                  name: '100m',
                  startDate: '2018-05-11 00:00',
                  duration: 1,
                  durationUnit: 'day'
                }],
                fillTicks: true
              });

            case 2:
              scheduler = _context2.sent;
              t.isApprox(document.querySelector(scheduler.unreleasedEventSelector).offsetWidth, scheduler.tickSize, 0.5, 'Event has correct width');

            case 4:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7293

  t.it('Event should be visible in monthAndYear preset if end date is out of scheduler timespan', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var element, rect;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'monthAndYear',
                startDate: '2018-05-01',
                endDate: '2018-06-01',
                resources: [{
                  id: 1,
                  name: 'Carl Lewis'
                }],
                events: [{
                  resourceId: 1,
                  name: '2 month long',
                  startDate: '2018-05-11 15:00',
                  duration: 2,
                  durationUnit: 'month'
                }]
              });

            case 2:
              scheduler = _context3.sent;
              element = document.querySelector(scheduler.unreleasedEventSelector);
              t.ok(element, 'Element found');
              rect = element.getBoundingClientRect();
              t.isGreater(rect.left, 0, 'Left offset is positive'); // elementIsTopElement checks center or all corners, so use elementIsTop with an offset instead

              t.ok(t.elementIsTop(scheduler.unreleasedEventSelector, true, [5, 5]), 'Event element is reachable');

            case 8:
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
  t.it('Should apply initial animation cls', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var getScheduler, _getScheduler;

      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _getScheduler = function _getScheduler3() {
                _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(anim) {
                  return regeneratorRuntime.wrap(function _callee4$(_context4) {
                    while (1) {
                      switch (_context4.prev = _context4.next) {
                        case 0:
                          scheduler && !scheduler.isDestroyed && scheduler.destroy();
                          _context4.next = 3;
                          return t.getSchedulerAsync({
                            useInitialAnimation: anim
                          });

                        case 3:
                          scheduler = _context4.sent;

                        case 4:
                        case "end":
                          return _context4.stop();
                      }
                    }
                  }, _callee4);
                }));
                return _getScheduler.apply(this, arguments);
              };

              getScheduler = function _getScheduler2(_x5) {
                return _getScheduler.apply(this, arguments);
              };

              _context5.next = 4;
              return getScheduler(true);

            case 4:
              t.selectorExists('.b-scheduler.b-initial-fade-in', 'Specifying true uses default animation');
              _context5.next = 7;
              return getScheduler(false);

            case 7:
              t.selectorNotExists('.b-scheduler.b-initial-fade-in', 'Specifying false prevents default animation');
              _context5.next = 10;
              return getScheduler('slide-from-left');

            case 10:
              t.selectorExists('.b-scheduler.b-initial-slide-from-left', 'Specified animation name used');

            case 11:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should not interrupt initial animation', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              t.firesOk({
                observable: document.body,
                events: {
                  animationend: '>= 1'
                }
              });
              _context6.next = 3;
              return t.getSchedulerAsync({
                useInitialAnimation: true
              });

            case 3:
              scheduler = _context6.sent;
              t.selectorExists('.b-initial-fade-in', 'Initial animation applied');
              _context6.next = 7;
              return t.waitFor(function () {
                return !scheduler.isFirstRender;
              });

            case 7:
              t.selectorNotExists('.b-initial-fade-in', 'Initial animation no longer applied');

            case 8:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref5.apply(this, arguments);
    };
  }());

  if (t.browser.firefox) {
    t.it('Should block transitions during initial animation in FF', /*#__PURE__*/function () {
      var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
        return regeneratorRuntime.wrap(function _callee7$(_context7) {
          while (1) {
            switch (_context7.prev = _context7.next) {
              case 0:
                _context7.next = 2;
                return t.getSchedulerAsync({
                  useInitialAnimation: true
                });

              case 2:
                scheduler = _context7.sent;
                t.is(window.getComputedStyle(t.query('.b-sch-event-wrap')[0]).transitionProperty, 'none', 'No transition');

              case 4:
              case "end":
                return _context7.stop();
            }
          }
        }, _callee7);
      }));

      return function (_x7) {
        return _ref6.apply(this, arguments);
      };
    }());
  }

  t.it('Should apply custom CSS and style', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return t.getSchedulerAsync();

            case 2:
              scheduler = _context8.sent;
              scheduler.eventStore.first.cls = 'custom';
              t.selectorExists('.b-sch-event.custom', 'Custom CSS applied');
              scheduler.eventStore.last.style = 'color: red';
              t.is(scheduler.getElementFromEventRecord(scheduler.eventStore.last).style.color, 'red', 'Custom style applied');

            case 7:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x8) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('resourceMargin', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      var assertEventsTop, _assertEventsTop;

      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _assertEventsTop = function _assertEventsTop3() {
                _assertEventsTop = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
                  var elements,
                      _len,
                      tops,
                      _key,
                      _args13 = arguments;

                  return regeneratorRuntime.wrap(function _callee13$(_context13) {
                    while (1) {
                      switch (_context13.prev = _context13.next) {
                        case 0:
                          _context13.next = 2;
                          return scheduler.project.commitAsync();

                        case 2:
                          elements = Array.from(document.querySelectorAll('.b-sch-event-wrap')).map(function (el) {
                            return Rectangle.from(el, scheduler.timeAxisSubGridElement);
                          });

                          for (_len = _args13.length, tops = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
                            tops[_key - 1] = _args13[_key];
                          }

                          tops.forEach(function (top, i) {
                            t.isApprox(elements[i].top, top, 'Correct top for ' + (i + 1));
                          });

                        case 5:
                        case "end":
                          return _context13.stop();
                      }
                    }
                  }, _callee13);
                }));
                return _assertEventsTop.apply(this, arguments);
              };

              assertEventsTop = function _assertEventsTop2(_x10) {
                return _assertEventsTop.apply(this, arguments);
              };

              t.it('Should respect configured resourceMargin', /*#__PURE__*/function () {
                var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
                  return regeneratorRuntime.wrap(function _callee9$(_context9) {
                    while (1) {
                      switch (_context9.prev = _context9.next) {
                        case 0:
                          _context9.next = 2;
                          return t.getSchedulerAsync({
                            resourceMargin: 10,
                            barMargin: 5,
                            enableEventAnimations: false
                          }, 3);

                        case 2:
                          scheduler = _context9.sent;
                          scheduler.eventStore.getById(2).resourceId = 'r1';
                          _context9.next = 6;
                          return assertEventsTop(t, 10, 40, 132);

                        case 6:
                          scheduler.eventStore.getById(3).resourceId = 'r1';
                          scheduler.eventStore.getById(3).startDate = new Date(2011, 0, 5, 5);
                          _context9.next = 10;
                          return assertEventsTop(t, 10, 40, 70);

                        case 10:
                        case "end":
                          return _context9.stop();
                      }
                    }
                  }, _callee9);
                }));

                return function (_x11) {
                  return _ref9.apply(this, arguments);
                };
              }());
              t.it('Should default to barMargin', /*#__PURE__*/function () {
                var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
                  return regeneratorRuntime.wrap(function _callee10$(_context10) {
                    while (1) {
                      switch (_context10.prev = _context10.next) {
                        case 0:
                          _context10.next = 2;
                          return t.getSchedulerAsync({
                            barMargin: 10,
                            enableEventAnimations: false
                          }, 3);

                        case 2:
                          scheduler = _context10.sent;
                          scheduler.eventStore.getById(2).resourceId = 'r1';
                          t.is(scheduler.resourceMargin, 10, 'Correct default');
                          _context10.next = 7;
                          return assertEventsTop(t, 10, 45, 137);

                        case 7:
                          scheduler.eventStore.getById(3).resourceId = 'r1';
                          scheduler.eventStore.getById(3).startDate = new Date(2011, 0, 5, 5);
                          _context10.next = 11;
                          return assertEventsTop(t, 10, 45, 80);

                        case 11:
                        case "end":
                          return _context10.stop();
                      }
                    }
                  }, _callee10);
                }));

                return function (_x12) {
                  return _ref10.apply(this, arguments);
                };
              }());
              t.it('Should work with layout: none', /*#__PURE__*/function () {
                var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
                  return regeneratorRuntime.wrap(function _callee11$(_context11) {
                    while (1) {
                      switch (_context11.prev = _context11.next) {
                        case 0:
                          _context11.next = 2;
                          return t.getSchedulerAsync({
                            resourceMargin: 10,
                            barMargin: 5,
                            enableEventAnimations: false,
                            eventLayout: 'none'
                          }, 3);

                        case 2:
                          scheduler = _context11.sent;
                          scheduler.eventStore.getById(2).resourceId = 'r1';
                          _context11.next = 6;
                          return assertEventsTop(t, 10, 10, 100);

                        case 6:
                          scheduler.eventStore.getById(3).resourceId = 'r1';
                          scheduler.eventStore.getById(3).startDate = new Date(2011, 0, 5, 5);
                          _context11.next = 10;
                          return assertEventsTop(t, 10, 10, 10);

                        case 10:
                        case "end":
                          return _context11.stop();
                      }
                    }
                  }, _callee11);
                }));

                return function (_x13) {
                  return _ref11.apply(this, arguments);
                };
              }());
              t.it('Should work with layout: pack', /*#__PURE__*/function () {
                var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
                  return regeneratorRuntime.wrap(function _callee12$(_context12) {
                    while (1) {
                      switch (_context12.prev = _context12.next) {
                        case 0:
                          _context12.next = 2;
                          return t.getSchedulerAsync({
                            resourceMargin: 10,
                            barMargin: 5,
                            enableEventAnimations: false,
                            eventLayout: 'pack'
                          }, 3);

                        case 2:
                          scheduler = _context12.sent;
                          scheduler.eventStore.getById(2).resourceId = 'r1';
                          _context12.next = 6;
                          return assertEventsTop(t, 10, 25, 100);

                        case 6:
                          scheduler.eventStore.getById(3).resourceId = 'r1';
                          scheduler.eventStore.getById(3).startDate = new Date(2011, 0, 5, 5);
                          _context12.next = 10;
                          return assertEventsTop(t, 10, 20, 30);

                        case 10:
                        case "end":
                          return _context12.stop();
                      }
                    }
                  }, _callee12);
                }));

                return function (_x14) {
                  return _ref12.apply(this, arguments);
                };
              }());

            case 6:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x9) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Should render bars correctly in max zoomed out state', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(1970, 0, 1),
                endDate: new Date(2070, 0, 1),
                viewPreset: {
                  base: 'manyYears',
                  tickWidth: 10
                }
              });

            case 2:
              scheduler = _context15.sent;
              _context15.next = 5;
              return t.waitForRowsVisible(scheduler);

            case 5:
              t.query(scheduler.unreleasedEventSelector).forEach(function (barEl) {
                t.isApprox(barEl.offsetWidth, 1);
              });

            case 6:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x15) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('Event animation should stay disabled when change barMargin', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      var el;
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              // Make a long transition so we can determine the animation in case it is present
              CSSHelper.insertRule('.my-scheduler .b-sch-event-wrap { transition-duration: 2s !important; }');
              scheduler = new Scheduler({
                cls: 'my-scheduler',
                enableEventAnimations: false,
                transitionDuration: 2000,
                appendTo: document.body,
                height: 200,
                resources: [{
                  id: 'r1',
                  name: 'Mike'
                }],
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2017, 0, 1, 10),
                  endDate: new Date(2017, 0, 1, 12),
                  name: 'Click me'
                }],
                startDate: new Date(2017, 0, 1, 6),
                endDate: new Date(2017, 0, 1, 20),
                viewPreset: 'hourAndDay',
                rowHeight: 50,
                barMargin: 5,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 130
                }]
              });
              _context16.next = 4;
              return t.waitForEventsToRender();

            case 4:
              el = document.querySelector(scheduler.eventSelector);
              t.is(el.offsetHeight, 40);
              scheduler.barMargin = 20;
              t.is(el.offsetHeight, 10, 'Height should be changed immediately with no animation');

            case 8:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x16) {
      return _ref14.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2014

  t.it('Should handle per resource margins', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      var assertTop;
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              assertTop = function _assertTop(assignmentId, top) {
                var assignment = scheduler.assignmentStore.getById(assignmentId),
                    element = document.querySelector("[data-assignment-id=\"".concat(assignmentId, "\"]")),
                    rowElement = document.querySelector(".b-grid-row[data-id=\"".concat(assignment.resourceId, "\"]")),
                    bounds = Rectangle.from(element, rowElement);
                t.isApprox(bounds.top, top, 0.5, 'Correct top for ' + assignmentId);
              };

              _context17.next = 3;
              return t.getSchedulerAsync({
                enableEventAnimations: false,
                startDate: '2020-12-02',
                endDate: '2020-12-03',
                resourceMargin: 3,
                barMargin: 6,
                resources: [{
                  id: 1,
                  name: 'One',
                  resourceMargin: 10
                }, {
                  id: 2,
                  name: 'Two',
                  barMargin: 10
                }, {
                  id: 3,
                  name: 'Three',
                  resourceMargin: 10,
                  barMargin: 10
                }, {
                  id: 4,
                  name: 'Four'
                }],
                events: [{
                  id: 1,
                  name: 'One',
                  startDate: '2020-12-02',
                  endDate: '2020-12-03'
                }, {
                  id: 2,
                  name: 'Two',
                  startDate: '2020-12-02',
                  endDate: '2020-12-03'
                }],
                assignments: [{
                  id: 'r1e1',
                  eventId: 1,
                  resourceId: 1
                }, {
                  id: 'r1e2',
                  eventId: 2,
                  resourceId: 1
                }, {
                  id: 'r2e1',
                  eventId: 1,
                  resourceId: 2
                }, {
                  id: 'r2e2',
                  eventId: 2,
                  resourceId: 2
                }, {
                  id: 'r3e1',
                  eventId: 1,
                  resourceId: 3
                }, {
                  id: 'r3e2',
                  eventId: 2,
                  resourceId: 3
                }, {
                  id: 'r4e1',
                  eventId: 1,
                  resourceId: 4
                }, {
                  id: 'r4e2',
                  eventId: 2,
                  resourceId: 4
                }]
              });

            case 3:
              scheduler = _context17.sent;
              assertTop('r1e1', 10); // Resource 1 has resourceMargin = 10

              assertTop('r1e2', 10 + 25 + 6); // and barMargin as configured on Scheduler = 6

              assertTop('r2e1', 3); // Resource 2 has resourceMargin as configured on Scheduler = 3

              assertTop('r2e2', 3 + 39 + 10); // and barMargin = 10

              assertTop('r3e1', 10); // Resource 3 has resourceMargin = 10

              assertTop('r3e2', 10 + 25 + 10); // and barMargin = 5

              assertTop('r4e1', 3); // Resource 4 has resourceMargin as configured on Scheduler = 3

              assertTop('r4e2', 3 + 39 + 6); // and barMargin as configured on Scheduler = 6

              t.diag('Changing barMargin for R1');
              scheduler.resourceStore.first.barMargin = 10;
              assertTop('r1e1', 10); // Resource 1 now has resourceMargin = 10

              assertTop('r1e2', 10 + 25 + 10); // and barMargin = 10

              t.diag('Changing resourceMargin for R2');
              scheduler.resourceStore.getAt(1).resourceMargin = 10;
              assertTop('r2e1', 10); // Resource 2 now has resourceMargin = 10

              assertTop('r2e2', 10 + 25 + 10); // and barMargin = 10

              t.diag('Changing barMargin and resourceMargin for R4');
              scheduler.resourceStore.last.resourceMargin = 10;
              scheduler.resourceStore.last.barMargin = 10;
              assertTop('r4e1', 10); // Resource 2 now has resourceMargin = 10

              assertTop('r4e2', 10 + 25 + 10); // and barMargin = 10

            case 25:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x17) {
      return _ref15.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2158

  t.it('Should handle per resource rowHeight, from data', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
      var createScheduler, _createScheduler;

      return regeneratorRuntime.wrap(function _callee22$(_context22) {
        while (1) {
          switch (_context22.prev = _context22.next) {
            case 0:
              _createScheduler = function _createScheduler3() {
                _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21(config) {
                  return regeneratorRuntime.wrap(function _callee21$(_context21) {
                    while (1) {
                      switch (_context21.prev = _context21.next) {
                        case 0:
                          _context21.next = 2;
                          return t.getSchedulerAsync(Object.assign({
                            enableEventAnimations: false,
                            startDate: '2020-12-02',
                            endDate: '2020-12-03',
                            rowHeight: 45,
                            resourceMargin: 5,
                            barMargin: 5,
                            resources: [{
                              id: 1,
                              name: 'One'
                            }, {
                              id: 2,
                              name: 'Two',
                              rowHeight: 105
                            }, {
                              id: 3,
                              name: 'Three',
                              rowHeight: 35
                            }],
                            events: [{
                              id: 1,
                              name: 'One',
                              startDate: '2020-12-02',
                              endDate: '2020-12-03'
                            }, {
                              id: 2,
                              name: 'Two',
                              startDate: '2020-12-02',
                              endDate: '2020-12-03'
                            }, {
                              id: 3,
                              name: 'Three',
                              startDate: '2020-12-02',
                              endDate: '2020-12-03'
                            }],
                            assignments: [{
                              id: 'r1e1',
                              eventId: 1,
                              resourceId: 1
                            }, {
                              id: 'r1e2',
                              eventId: 2,
                              resourceId: 1
                            }, {
                              id: 'r2e1',
                              eventId: 1,
                              resourceId: 2
                            }, {
                              id: 'r2e2',
                              eventId: 2,
                              resourceId: 2
                            }, {
                              id: 'r3e1',
                              eventId: 1,
                              resourceId: 3
                            }, {
                              id: 'r3e2',
                              eventId: 2,
                              resourceId: 3
                            }, {
                              id: 'r3e3',
                              eventId: 3,
                              resourceId: 3
                            }]
                          }, config));

                        case 2:
                          scheduler = _context21.sent;

                        case 3:
                        case "end":
                          return _context21.stop();
                      }
                    }
                  }, _callee21);
                }));
                return _createScheduler.apply(this, arguments);
              };

              createScheduler = function _createScheduler2(_x19) {
                return _createScheduler.apply(this, arguments);
              };

              t.it('Using stack', /*#__PURE__*/function () {
                var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
                  return regeneratorRuntime.wrap(function _callee18$(_context18) {
                    while (1) {
                      switch (_context18.prev = _context18.next) {
                        case 0:
                          _context18.next = 2;
                          return createScheduler({
                            eventLayout: 'stack'
                          });

                        case 2:
                          // event height = resource height - 2 x resourceMargin
                          // row height = event height * overlap count + 2 x resourceMargin + barMargin x (overlap count - 1) + border
                          t.hasHeight('[data-assignment-id="r1e1"]', 35); // Event, 45 - 2 x 5 = 35

                          t.hasHeight('[data-assignment-id="r1e2"]', 35);
                          t.hasHeight('[data-id="1"]', 86); // Row, 5 + 35 + 5 + 35 + 5 + 1

                          t.hasHeight('[data-assignment-id="r2e1"]', 95); // 105 - 2 x 5 = 95

                          t.hasHeight('[data-assignment-id="r2e2"]', 95);
                          t.hasHeight('[data-id="2"]', 206); // 5 + 95 + 5 + 95 + 5 + 1

                          t.hasHeight('[data-assignment-id="r3e1"]', 25); // 35 - 2 x 5 = 25

                          t.hasHeight('[data-assignment-id="r3e2"]', 25);
                          t.hasHeight('[data-assignment-id="r3e3"]', 25);
                          t.hasHeight('[data-id="3"]', 96); // 5 + 25 + 5 + 25 + 5 + 25 + 5 + 1

                        case 12:
                        case "end":
                          return _context18.stop();
                      }
                    }
                  }, _callee18);
                }));

                return function (_x20) {
                  return _ref17.apply(this, arguments);
                };
              }());
              t.it('Using pack', /*#__PURE__*/function () {
                var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t) {
                  return regeneratorRuntime.wrap(function _callee19$(_context19) {
                    while (1) {
                      switch (_context19.prev = _context19.next) {
                        case 0:
                          _context19.next = 2;
                          return createScheduler({
                            eventLayout: 'pack'
                          });

                        case 2:
                          t.hasHeight('[data-assignment-id="r1e1"]', 15); // Event, (45 - 15) / 2

                          t.hasHeight('[data-assignment-id="r1e2"]', 15);
                          t.hasHeight('[data-id="1"]', 46);
                          t.hasHeight('[data-assignment-id="r2e1"]', 45); // (105 - 15) / 2

                          t.hasHeight('[data-assignment-id="r2e2"]', 45);
                          t.hasHeight('[data-id="2"]', 106);
                          t.hasHeight('[data-assignment-id="r3e1"]', 5); // (35 - 20) / 3

                          t.hasHeight('[data-assignment-id="r3e2"]', 5);
                          t.hasHeight('[data-assignment-id="r3e3"]', 5);
                          t.hasHeight('[data-id="3"]', 36);

                        case 12:
                        case "end":
                          return _context19.stop();
                      }
                    }
                  }, _callee19);
                }));

                return function (_x21) {
                  return _ref18.apply(this, arguments);
                };
              }());
              t.it('Using overlap (none)', /*#__PURE__*/function () {
                var _ref19 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(t) {
                  return regeneratorRuntime.wrap(function _callee20$(_context20) {
                    while (1) {
                      switch (_context20.prev = _context20.next) {
                        case 0:
                          _context20.next = 2;
                          return createScheduler({
                            eventLayout: 'none'
                          });

                        case 2:
                          t.hasHeight('[data-assignment-id="r1e1"]', 35); // Event, 45 - 10

                          t.hasHeight('[data-assignment-id="r1e2"]', 35);
                          t.hasHeight('[data-id="1"]', 46);
                          t.hasHeight('[data-assignment-id="r2e1"]', 95); // 105 - 10

                          t.hasHeight('[data-assignment-id="r2e2"]', 95);
                          t.hasHeight('[data-id="2"]', 106);
                          t.hasHeight('[data-assignment-id="r3e1"]', 25); // 35 - 10

                          t.hasHeight('[data-assignment-id="r3e2"]', 25);
                          t.hasHeight('[data-assignment-id="r3e3"]', 25);
                          t.hasHeight('[data-id="3"]', 36);

                        case 12:
                        case "end":
                          return _context20.stop();
                      }
                    }
                  }, _callee20);
                }));

                return function (_x22) {
                  return _ref19.apply(this, arguments);
                };
              }());

            case 5:
            case "end":
              return _context22.stop();
          }
        }
      }, _callee22);
    }));

    return function (_x18) {
      return _ref16.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2158

  t.it('Should handle per resource rowHeight, from renderer', /*#__PURE__*/function () {
    var _ref20 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee27(t) {
      var createScheduler, _createScheduler4;

      return regeneratorRuntime.wrap(function _callee27$(_context27) {
        while (1) {
          switch (_context27.prev = _context27.next) {
            case 0:
              _createScheduler4 = function _createScheduler6() {
                _createScheduler4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee26(config) {
                  return regeneratorRuntime.wrap(function _callee26$(_context26) {
                    while (1) {
                      switch (_context26.prev = _context26.next) {
                        case 0:
                          _context26.next = 2;
                          return t.getSchedulerAsync(Object.assign({
                            enableEventAnimations: false,
                            startDate: '2020-12-02',
                            endDate: '2020-12-03',
                            rowHeight: 45,
                            resourceMargin: 5,
                            barMargin: 5,
                            resources: [{
                              id: 1,
                              name: 'One'
                            }, {
                              id: 2,
                              name: 'Two'
                            }, // 105
                            {
                              id: 3,
                              name: 'Three'
                            } // 35
                            ],
                            events: [{
                              id: 1,
                              name: 'One',
                              startDate: '2020-12-02',
                              endDate: '2020-12-03'
                            }, {
                              id: 2,
                              name: 'Two',
                              startDate: '2020-12-02',
                              endDate: '2020-12-03'
                            }, {
                              id: 3,
                              name: 'Three',
                              startDate: '2020-12-02',
                              endDate: '2020-12-03'
                            }],
                            assignments: [{
                              id: 'r1e1',
                              eventId: 1,
                              resourceId: 1
                            }, {
                              id: 'r1e2',
                              eventId: 2,
                              resourceId: 1
                            }, {
                              id: 'r2e1',
                              eventId: 1,
                              resourceId: 2
                            }, {
                              id: 'r2e2',
                              eventId: 2,
                              resourceId: 2
                            }, {
                              id: 'r3e1',
                              eventId: 1,
                              resourceId: 3
                            }, {
                              id: 'r3e2',
                              eventId: 2,
                              resourceId: 3
                            }, {
                              id: 'r3e3',
                              eventId: 3,
                              resourceId: 3
                            }],
                            columns: [{
                              field: 'name',
                              text: 'Name',
                              renderer: function renderer(_ref24) {
                                var record = _ref24.record,
                                    size = _ref24.size;

                                if (record.id === 2) {
                                  size.height = 105;
                                } else if (record.id === 3) {
                                  size.height = 35;
                                }

                                return record.name;
                              }
                            }]
                          }, config));

                        case 2:
                          scheduler = _context26.sent;

                        case 3:
                        case "end":
                          return _context26.stop();
                      }
                    }
                  }, _callee26);
                }));
                return _createScheduler4.apply(this, arguments);
              };

              createScheduler = function _createScheduler5(_x24) {
                return _createScheduler4.apply(this, arguments);
              };

              t.it('Using stack', /*#__PURE__*/function () {
                var _ref21 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23(t) {
                  return regeneratorRuntime.wrap(function _callee23$(_context23) {
                    while (1) {
                      switch (_context23.prev = _context23.next) {
                        case 0:
                          _context23.next = 2;
                          return createScheduler({
                            eventLayout: 'stack'
                          });

                        case 2:
                          // event height = resource height - 2 x resourceMargin
                          // row height = event height * overlap count + 2 x resourceMargin + barMargin x (overlap count - 1) + border
                          t.hasHeight('[data-assignment-id="r1e1"]', 35); // Event, 45 - 2 x 5 = 35

                          t.hasHeight('[data-assignment-id="r1e2"]', 35);
                          t.hasHeight('[data-id="1"]', 86); // Row, 5 + 35 + 5 + 35 + 5 + 1

                          t.hasHeight('[data-assignment-id="r2e1"]', 95); // 105 - 2 x 5 = 95

                          t.hasHeight('[data-assignment-id="r2e2"]', 95);
                          t.hasHeight('[data-id="2"]', 206); // 5 + 95 + 5 + 95 + 5 + 1

                          t.hasHeight('[data-assignment-id="r3e1"]', 25); // 35 - 2 x 5 = 25

                          t.hasHeight('[data-assignment-id="r3e2"]', 25);
                          t.hasHeight('[data-assignment-id="r3e3"]', 25);
                          t.hasHeight('[data-id="3"]', 96); // 5 + 25 + 5 + 25 + 5 + 25 + 5 + 1

                        case 12:
                        case "end":
                          return _context23.stop();
                      }
                    }
                  }, _callee23);
                }));

                return function (_x25) {
                  return _ref21.apply(this, arguments);
                };
              }());
              t.it('Using pack', /*#__PURE__*/function () {
                var _ref22 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee24(t) {
                  return regeneratorRuntime.wrap(function _callee24$(_context24) {
                    while (1) {
                      switch (_context24.prev = _context24.next) {
                        case 0:
                          _context24.next = 2;
                          return createScheduler({
                            eventLayout: 'pack'
                          });

                        case 2:
                          t.hasHeight('[data-assignment-id="r1e1"]', 15); // Event, (45 - 15) / 2

                          t.hasHeight('[data-assignment-id="r1e2"]', 15);
                          t.hasHeight('[data-id="1"]', 46);
                          t.hasHeight('[data-assignment-id="r2e1"]', 45); // (105 - 15) / 2

                          t.hasHeight('[data-assignment-id="r2e2"]', 45);
                          t.hasHeight('[data-id="2"]', 106);
                          t.hasHeight('[data-assignment-id="r3e1"]', 5); // (35 - 20) / 3

                          t.hasHeight('[data-assignment-id="r3e2"]', 5);
                          t.hasHeight('[data-assignment-id="r3e3"]', 5);
                          t.hasHeight('[data-id="3"]', 36);

                        case 12:
                        case "end":
                          return _context24.stop();
                      }
                    }
                  }, _callee24);
                }));

                return function (_x26) {
                  return _ref22.apply(this, arguments);
                };
              }());
              t.it('Using overlap (none)', /*#__PURE__*/function () {
                var _ref23 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee25(t) {
                  return regeneratorRuntime.wrap(function _callee25$(_context25) {
                    while (1) {
                      switch (_context25.prev = _context25.next) {
                        case 0:
                          _context25.next = 2;
                          return createScheduler({
                            eventLayout: 'none'
                          });

                        case 2:
                          t.hasHeight('[data-assignment-id="r1e1"]', 35); // Event, 45 - 10

                          t.hasHeight('[data-assignment-id="r1e2"]', 35);
                          t.hasHeight('[data-id="1"]', 46);
                          t.hasHeight('[data-assignment-id="r2e1"]', 95); // 105 - 10

                          t.hasHeight('[data-assignment-id="r2e2"]', 95);
                          t.hasHeight('[data-id="2"]', 106);
                          t.hasHeight('[data-assignment-id="r3e1"]', 25); // 35 - 10

                          t.hasHeight('[data-assignment-id="r3e2"]', 25);
                          t.hasHeight('[data-assignment-id="r3e3"]', 25);
                          t.hasHeight('[data-id="3"]', 36);

                        case 12:
                        case "end":
                          return _context25.stop();
                      }
                    }
                  }, _callee25);
                }));

                return function (_x27) {
                  return _ref23.apply(this, arguments);
                };
              }());

            case 5:
            case "end":
              return _context27.stop();
          }
        }
      }, _callee27);
    }));

    return function (_x23) {
      return _ref20.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/176

  t.it('Should handle per resource eventLayout', /*#__PURE__*/function () {
    var _ref25 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee28(t) {
      return regeneratorRuntime.wrap(function _callee28$(_context28) {
        while (1) {
          switch (_context28.prev = _context28.next) {
            case 0:
              _context28.next = 2;
              return t.getSchedulerAsync({
                enableEventAnimations: false,
                startDate: '2020-12-02',
                endDate: '2020-12-03',
                rowHeight: 45,
                resourceMargin: 5,
                barMargin: 5,
                resources: [{
                  id: 1,
                  name: 'One',
                  eventLayout: 'stack'
                }, {
                  id: 2,
                  name: 'Two',
                  eventLayout: 'pack'
                }, {
                  id: 3,
                  name: 'Three',
                  eventLayout: 'none'
                }],
                events: [{
                  id: 1,
                  name: 'One',
                  startDate: '2020-12-02',
                  endDate: '2020-12-03'
                }, {
                  id: 2,
                  name: 'Two',
                  startDate: '2020-12-02',
                  endDate: '2020-12-03'
                }, {
                  id: 3,
                  name: 'Three',
                  startDate: '2020-12-02',
                  endDate: '2020-12-03'
                }],
                assignments: [{
                  id: 'r1e1',
                  eventId: 1,
                  resourceId: 1
                }, {
                  id: 'r1e2',
                  eventId: 2,
                  resourceId: 1
                }, {
                  id: 'r2e1',
                  eventId: 1,
                  resourceId: 2
                }, {
                  id: 'r2e2',
                  eventId: 2,
                  resourceId: 2
                }, {
                  id: 'r3e1',
                  eventId: 1,
                  resourceId: 3
                }, {
                  id: 'r3e2',
                  eventId: 2,
                  resourceId: 3
                }, {
                  id: 'r3e3',
                  eventId: 3,
                  resourceId: 3
                }]
              });

            case 2:
              scheduler = _context28.sent;
              t.hasHeight('[data-assignment-id="r1e1"]', 35);
              t.hasHeight('[data-assignment-id="r1e2"]', 35);
              t.hasHeight('[data-id="1"]', 86);
              t.hasHeight('[data-assignment-id="r2e1"]', 15);
              t.hasHeight('[data-assignment-id="r2e2"]', 15);
              t.hasHeight('[data-id="2"]', 46);
              t.hasHeight('[data-assignment-id="r3e1"]', 35);
              t.hasHeight('[data-assignment-id="r3e2"]', 35);
              t.hasHeight('[data-assignment-id="r3e3"]', 35);
              t.hasHeight('[data-id="3"]', 46);

            case 13:
            case "end":
              return _context28.stop();
          }
        }
      }, _callee28);
    }));

    return function (_x28) {
      return _ref25.apply(this, arguments);
    };
  }());
});