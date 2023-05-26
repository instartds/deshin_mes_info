function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    var _scheduler, _scheduler$destroy;

    (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : (_scheduler$destroy = _scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(_scheduler);
    t.setWindowSize(1024, 768);
  });

  var assertHeaders = function assertHeaders(t) {
    var threshold = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : 0;
    var headerWrapper = t.query('.b-grid-headers-normal')[0],
        header = t.query('.b-grid-headers-normal .b-grid-header')[0],
        // Assume header might be a bit less than available space due to rounding to have integer width of all ticks
    headerWidthIsCorrect = header.offsetWidth >= headerWrapper.offsetWidth - threshold;
    t.ok(headerWidthIsCorrect, 'Header takes all available width');
  };

  t.it('Should be able to scroll during paint without height', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              // Ignore grid height warning
              t.spyOn(console, 'warn').and.callFake(function () {});
              _context.next = 3;
              return t.getSchedulerAsync({
                height: 0,
                listeners: {
                  paint: function paint(_ref2) {
                    var scheduler = _ref2.source;
                    scheduler.scrollToDate(new Date(2020, 9, 7));
                  }
                }
              });

            case 3:
              scheduler = _context.sent;
              _context.next = 6;
              return t.waitForSelector('.b-sch-header-timeaxis-cell:textEquals(We 07)');

            case 6:
              t.pass('Scrolled without crashing');

            case 7:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2414

  t.it('Time axis header should take all available space on window resize', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              t.setWindowSize(300, 500);
              _context6.next = 3;
              return t.getSchedulerAsync({
                startDate: new Date(2018, 0, 1, 6),
                endDate: new Date(2018, 0, 1, 12),
                viewPreset: 'hourAndDay'
              });

            case 3:
              scheduler = _context6.sent;
              t.chain({
                waitForSelector: '.b-grid-headers-normal .b-grid-header'
              }, {
                waitFor: function waitFor() {
                  return scheduler.timeAxisViewModel.availableSpace > 290;
                },
                trigger: function trigger() {
                  return t.setWindowSize(400, 500);
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        assertHeaders(t, 6); // Threshold is number of ticks

                      case 1:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              })), {
                waitFor: function waitFor() {
                  return scheduler.timeAxisViewModel.availableSpace > 390;
                },
                trigger: function trigger() {
                  return t.setWindowSize(500, 500);
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        assertHeaders(t, 6);

                      case 1:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3);
              })), {
                waitFor: function waitFor() {
                  return scheduler.timeAxisViewModel.availableSpace > 490;
                },
                trigger: function trigger() {
                  return t.setWindowSize(600, 500);
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
                return regeneratorRuntime.wrap(function _callee4$(_context4) {
                  while (1) {
                    switch (_context4.prev = _context4.next) {
                      case 0:
                        assertHeaders(t, 6);

                      case 1:
                      case "end":
                        return _context4.stop();
                    }
                  }
                }, _callee4);
              })), {
                waitFor: function waitFor() {
                  return scheduler.timeAxisViewModel.availableSpace > 590;
                },
                trigger: function trigger() {
                  return t.setWindowSize(700, 500);
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
                return regeneratorRuntime.wrap(function _callee5$(_context5) {
                  while (1) {
                    switch (_context5.prev = _context5.next) {
                      case 0:
                        assertHeaders(t, 6);

                      case 1:
                      case "end":
                        return _context5.stop();
                    }
                  }
                }, _callee5);
              })));

            case 5:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x2) {
      return _ref3.apply(this, arguments);
    };
  }()); //region Scroll flickering

  t.it('Time axis header should not update available space in infinite loop', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var spy;
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              t.setWindowSize(600, 330);
              _context9.next = 3;
              return t.getSchedulerAsync({
                startDate: new Date(2018, 0, 1, 6),
                endDate: new Date(2018, 0, 1, 12),
                viewPreset: 'hourAndDay'
              });

            case 3:
              scheduler = _context9.sent;
              _context9.next = 6;
              return t.waitForAnimationFrame();

            case 6:
              spy = t.spyOn(scheduler.currentOrientation, 'onViewportResize').and.callThrough();
              t.chain({
                waitForSelector: '.b-grid-headers-normal .b-grid-header'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                return regeneratorRuntime.wrap(function _callee7$(_context7) {
                  while (1) {
                    switch (_context7.prev = _context7.next) {
                      case 0:
                        spy.reset();

                      case 1:
                      case "end":
                        return _context7.stop();
                    }
                  }
                }, _callee7);
              })), // Need to give it some time to make sure the timeline does not flickering
              {
                waitFor: 2000
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8() {
                return regeneratorRuntime.wrap(function _callee8$(_context8) {
                  while (1) {
                    switch (_context8.prev = _context8.next) {
                      case 0:
                        assertHeaders(t, 15); // Threshold is scroll bar width

                        t.expect(spy).toHaveBeenCalled('<3');

                      case 2:
                      case "end":
                        return _context8.stop();
                    }
                  }
                }, _callee8);
              })));

            case 8:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x3) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Time axis header should not update available space in infinite loop when decrease available space', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      var spy;
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              t.setWindowSize(1472, 326);
              _context12.next = 3;
              return t.getSchedulerAsync({
                columns: [{
                  text: 'Name',
                  sortable: true,
                  width: 130,
                  field: 'name',
                  locked: true
                }],
                startDate: new Date(2018, 0, 1, 6),
                endDate: new Date(2018, 0, 1, 20),
                viewPreset: 'hourAndDay'
              });

            case 3:
              scheduler = _context12.sent;
              _context12.next = 6;
              return t.waitForAnimationFrame();

            case 6:
              spy = t.spyOn(scheduler.currentOrientation, 'onViewportResize').and.callThrough();
              t.chain({
                waitForSelector: '.b-grid-headers-normal .b-grid-header'
              }, {
                drag: '.b-grid-splitter .b-grid-splitter-main',
                by: [9, 0],
                fromOffset: ['50%', 10]
              }, {
                drag: '.b-grid-splitter .b-grid-splitter-main',
                by: [1, 0],
                fromOffset: ['50%', 10]
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10() {
                return regeneratorRuntime.wrap(function _callee10$(_context10) {
                  while (1) {
                    switch (_context10.prev = _context10.next) {
                      case 0:
                        spy.reset();

                      case 1:
                      case "end":
                        return _context10.stop();
                    }
                  }
                }, _callee10);
              })), // Need to give it some time to make sure the timeline does not flickering
              {
                waitFor: 2000
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11() {
                return regeneratorRuntime.wrap(function _callee11$(_context11) {
                  while (1) {
                    switch (_context11.prev = _context11.next) {
                      case 0:
                        assertHeaders(t, DomHelper.scrollBarWidth); // Threshold is scroll bar width

                        t.expect(spy).toHaveBeenCalled('<3');

                      case 2:
                      case "end":
                        return _context11.stop();
                    }
                  }
                }, _callee11);
              })));

            case 8:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x4) {
      return _ref11.apply(this, arguments);
    };
  }()); //endregion Scroll flickering

  t.it('EventStore should fire loadDateRange events', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      var loadDateRangeEvents;
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              loadDateRangeEvents = [];
              _context13.next = 3;
              return t.getScheduler({
                viewPreset: 'hourAndDay',
                visibleDate: {
                  date: new Date(2020, 0, 1, 12),
                  block: 'center'
                },
                infiniteScroll: true
              });

            case 3:
              scheduler = _context13.sent;
              scheduler.eventStore.on({
                loadDateRange: function loadDateRange(e) {
                  loadDateRangeEvents.push(e);
                }
              });
              _context13.next = 7;
              return scheduler.timeAxisSubGrid.scrollable.scrollBy(3500);

            case 7:
              _context13.next = 9;
              return t.waitFor(function () {
                return loadDateRangeEvents.length === 1;
              });

            case 9:
              t.isDeeply(loadDateRangeEvents[0].old, {
                startDate: new Date(2019, 11, 29, 4),
                endDate: new Date(2020, 0, 4, 6)
              });
              t.isDeeply(loadDateRangeEvents[0].new, {
                startDate: new Date(2019, 11, 31, 13),
                endDate: new Date(2020, 0, 6, 16)
              }); // Scroll back beyond the left edge

              _context13.next = 13;
              return scheduler.timeAxisSubGrid.scrollable.scrollBy(4000);

            case 13:
              _context13.next = 15;
              return t.waitFor(function () {
                return loadDateRangeEvents.length === 2;
              });

            case 15:
              t.isDeeply(loadDateRangeEvents[1].old, loadDateRangeEvents[0].new);
              t.isDeeply(loadDateRangeEvents[1].new, {
                startDate: new Date(2020, 0, 2, 23),
                endDate: new Date(2020, 0, 9, 2)
              });

            case 17:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x5) {
      return _ref14.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2365

  t.it('Should maintain number of ticks in the time axis when scrolling to a date', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      var ticksBefore;
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _context14.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2017, 0, 1, 8),
                endDate: new Date(2017, 0, 1, 16),
                viewPreset: 'hourAndDay'
              });

            case 2:
              scheduler = _context14.sent;
              ticksBefore = scheduler.timeAxis.count;
              scheduler.scrollToDate(new Date(2021, 3, 17, 17, 20));
              t.is(scheduler.timeAxis.count, ticksBefore, 'Same size time axis after scrolling');

            case 6:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x6) {
      return _ref15.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2901

  DomHelper.scrollBarWidth > 0 && t.it('Should maintain focused event when clicking native scrollbar', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              scheduler = t.getScheduler({
                height: 200
              }, 1);
              _context15.next = 3;
              return t.click('.b-sch-event');

            case 3:
              t.is(document.activeElement, t.query('.b-sch-event-wrap')[0], 'event bar is focused'); // Click the scroll bar

              _context15.next = 6;
              return t.click('.b-grid-body-container.b-vertical-overflow', null, null, null, ['100%-2', 10]);

            case 6:
              t.is(document.activeElement, t.query('.b-sch-event-wrap')[0], 'event bar is still focused');

            case 7:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x7) {
      return _ref16.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2991

  t.it('Events should not disappear on viewport with few rows and low height', /*#__PURE__*/function () {
    var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      var i;
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return t.getSchedulerAsync({
                height: 200,
                events: ArrayHelper.populate(14, function (i) {
                  return {
                    id: i + 1,
                    name: "Event ".concat(i + 1),
                    startDate: '2011-01-03',
                    endDate: '2011-01-06',
                    resourceId: i + 1
                  };
                }),
                resources: ArrayHelper.populate(14, function (i) {
                  return {
                    id: i + 1,
                    name: "Resource ".concat(i + 1)
                  };
                })
              });

            case 2:
              scheduler = _context16.sent;
              i = 0;

            case 4:
              if (!(i < 2)) {
                _context16.next = 11;
                break;
              }

              scheduler.scrollTop += 150;
              _context16.next = 8;
              return t.waitForAnimationFrame();

            case 8:
              i++;
              _context16.next = 4;
              break;

            case 11:
              // Out of view
              scheduler.scrollTop -= 300;
              _context16.next = 14;
              return t.waitForAnimationFrame();

            case 14:
              // And back into view for the bug to manifest (rerendering an event released because of the vertical buffer)
              scheduler.scrollTop = 300;
              _context16.next = 17;
              return t.waitForAnimationFrame();

            case 17:
              t.selectorExists("".concat(scheduler.unreleasedEventSelector, "[data-event-id=\"9\"]"), 'Event #9 rendered');
              t.selectorExists("".concat(scheduler.unreleasedEventSelector, "[data-event-id=\"10\"]"), 'Event #10 rendered');

            case 19:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x8) {
      return _ref17.apply(this, arguments);
    };
  }());
});