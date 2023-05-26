function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    return scheduler && scheduler.destroy();
  });

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee32(t) {
      var config,
          scheduler,
          _args32 = arguments;
      return regeneratorRuntime.wrap(function _callee32$(_context32) {
        while (1) {
          switch (_context32.prev = _context32.next) {
            case 0:
              config = _args32.length > 1 && _args32[1] !== undefined ? _args32[1] : {};
              scheduler = t.getScheduler(config);
              _context32.next = 4;
              return t.waitForProjectReady();

            case 4:
              return _context32.abrupt("return", scheduler);

            case 5:
            case "end":
              return _context32.stop();
          }
        }
      }, _callee32);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('Should display resize handles on hover', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler(t);

            case 2:
              scheduler = _context.sent;
              t.chain({
                moveMouseTo: '.b-sch-event'
              }, function (next, el) {
                // detect pseudo elements used for resize handles
                var startHandle = window.getComputedStyle(el, ':before');
                t.is(startHandle.width, '4px', 'startHandle.width correct');
                t.is(startHandle.borderLeftWidth, '1px', 'startHandle.borderLeftWidth correct');
                t.is(startHandle.borderRightWidth, '1px', 'startHandle.borderRightWidth correct');
                var endHandle = window.getComputedStyle(el, ':after');
                t.is(endHandle.width, '4px', 'endHandle.width correct');
                t.is(endHandle.borderLeftWidth, '1px', 'endHandle.borderLeftWidth correct');
                t.is(endHandle.borderRightWidth, '1px', 'endHandle.borderRightWidth correct');
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
  t.it('Should resize', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var counter, evt;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              counter = 0;
              _context2.next = 3;
              return getScheduler(t, {
                features: {
                  eventResize: {
                    validatorFn: function validatorFn(_ref3, event) {
                      var resourceRecord = _ref3.resourceRecord,
                          eventRecord = _ref3.eventRecord,
                          startDate = _ref3.startDate,
                          endDate = _ref3.endDate;

                      if (counter % 10 === 0) {
                        t.ok(resourceRecord instanceof ResourceModel && eventRecord instanceof EventModel && startDate instanceof Date && endDate instanceof Date && (event ? event instanceof Event : true), 'Correct function arguments');
                      }

                      counter++;
                      return endDate < new Date(2011, 0, 8);
                    }
                  }
                },
                events: [{
                  id: 1,
                  name: 'Event',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }]
              });

            case 3:
              scheduler = _context2.sent;
              evt = scheduler.eventStore.first;
              t.wontFire(scheduler, 'eventclick');
              t.chain({
                moveCursorTo: '.b-sch-event'
              }, function (next) {
                var transitionCount = 0; // The two drag operations should cause only two width transitions - that's at the mouseup.
                // The width changing during the drag must not be animated.

                scheduler.contentElement.addEventListener('transitionstart', function (_ref4) {
                  var target = _ref4.target,
                      propertyName = _ref4.propertyName;

                  if (target.matches('.b-sch-event-wrap') && propertyName === 'width') {
                    if (++transitionCount > 2) {
                      t.fail('Only two event width animations should be started');
                    }
                  }
                });
                next();
              }, {
                drag: '.b-sch-event',
                offset: ['100%-3', 5],
                by: [53, 0],
                dragOnly: true
              }, function (next) {
                t.ok(evt.meta.isResizing, 'isResizing flag set correctly');
                next();
              }, {
                moveCursorBy: [45, 0]
              }, {
                mouseUp: null
              }, function (next) {
                t.isGreaterOrEqual(evt.endDate, new Date(2011, 0, 7), 'Existing event resized correctly');
                t.notOk(evt.meta.isResizing, 'isResizing flag cleared correctly');
                next();
              }, // Over-drag, then the validator will veto
              {
                drag: '.b-sch-event',
                offset: ['100%-3', 5],
                by: [110, 0]
              }, function () {
                t.isLess(evt.endDate, new Date(2011, 0, 8), 'Existing event not resized.');
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
  }());
  t.it('Should fire eventresizeend once when operation is invalid', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getScheduler(t, {
                features: {
                  eventResize: {
                    validatorFn: function validatorFn() {
                      return false;
                    }
                  }
                },
                events: [{
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }]
              });

            case 2:
              scheduler = _context3.sent;
              t.firesOnce(scheduler, 'eventresizeend');
              t.chain({
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                offset: ['100%-3', 5],
                by: [100, 0]
              });

            case 5:
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
  t.it('Should resize with showExactResizePosition w/o snapRelativeToEventStartDate', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var tickSize, record;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return getScheduler(t, {
                startDate: new Date(2011, 0, 3),
                viewPreset: 'hourAndDay',
                events: [{
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 3, 4, 13, 18),
                  endDate: new Date(2011, 0, 3, 6)
                }],
                features: {
                  eventResize: {
                    showExactResizePosition: true
                  }
                }
              });

            case 2:
              scheduler = _context4.sent;
              tickSize = scheduler.timeAxisViewModel.tickSize, record = scheduler.eventStore.first;
              t.chain( // resizing start
              {
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                offset: [5, 5],
                by: [-0.2 * tickSize, 0]
              }, function (next) {
                t.is(record.startDate, new Date(2011, 0, 3, 4), 'Event wasn\'t resized');
                next();
              }, {
                moveCursorTo: '.b-sch-event',
                offset: ['100%+10', 0]
              }, {
                drag: '.b-sch-event',
                offset: [5, 5],
                by: [-0.5 * tickSize, 0]
              }, function (next) {
                t.is(record.startDate, new Date(2011, 0, 3, 3, 30), 'Event resized');
                next();
              }, {
                moveCursorTo: '.b-sch-event',
                offset: ['100%+10', 0]
              }, {
                drag: '.b-sch-event',
                offset: [5, 5],
                by: [-0.2 * tickSize, 0]
              }, function (next) {
                t.is(record.startDate, new Date(2011, 0, 3, 3, 30), 'Event wasn\'t resized');
                next();
              }, // resizing end
              {
                moveCursorTo: '.b-sch-event',
                offset: ['100%+10', 0]
              }, {
                drag: '.b-sch-event',
                offset: ['100%-5', 5],
                by: [0.2 * tickSize, 0]
              }, function (next) {
                t.is(record.endDate, new Date(2011, 0, 3, 6), 'Event wasn\'t resized');
                next();
              }, {
                moveCursorTo: '.b-sch-event',
                offset: ['100%+10', 0]
              }, {
                drag: '.b-sch-event',
                offset: ['100%-5', 5],
                by: [0.5 * tickSize, 0]
              }, function (next) {
                t.is(record.endDate, new Date(2011, 0, 3, 6, 30), 'Event resized');
                next();
              }, {
                moveCursorTo: '.b-sch-event',
                offset: ['100%+10', 0]
              }, {
                drag: '.b-sch-event',
                offset: ['100%-5', 5],
                by: [0.2 * tickSize, 0]
              }, function (next) {
                t.is(record.endDate, new Date(2011, 0, 3, 6, 30), 'Event wasn\'t resized');
                next();
              });

            case 5:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x5) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Should resize with showExactResizePosition w/ snapRelativeToEventStartDate', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var tickSize, record;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return getScheduler(t, {
                startDate: new Date(2011, 0, 3),
                viewPreset: 'hourAndDay',
                events: [{
                  id: 1,
                  name: 'Event',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 3, 4, 13, 18),
                  endDate: new Date(2011, 0, 3, 6, 16, 23)
                }],
                snapRelativeToEventStartDate: true,
                features: {
                  eventResize: {
                    showExactResizePosition: true
                  }
                }
              });

            case 2:
              scheduler = _context5.sent;
              tickSize = scheduler.timeAxisViewModel.tickSize, record = scheduler.eventStore.first;
              t.chain({
                moveCursorTo: '.b-sch-event'
              }, // resizing start
              {
                drag: '.b-sch-event',
                offset: [5, 5],
                by: [-0.2 * tickSize, 0]
              }, function (next) {
                t.is(record.startDate, new Date(2011, 0, 3, 4, 13, 18), 'Event wasn\'t resized');
                next();
              }, {
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                offset: [5, 5],
                by: [-0.5 * tickSize, 0]
              }, function (next) {
                t.is(record.startDate, new Date(2011, 0, 3, 3, 43, 18), 'Event resized');
                next();
              }, {
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                offset: [5, 5],
                by: [-0.2 * tickSize, 0]
              }, function (next) {
                t.is(record.startDate, new Date(2011, 0, 3, 3, 43, 18), 'Event wasn\'t resized');
                next();
              }, // resizing end
              {
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                offset: ['100%-5', 5],
                by: [0.2 * tickSize, 0]
              }, function (next) {
                t.is(record.endDate, new Date(2011, 0, 3, 6, 16, 23), 'Event wasn\'t resized');
                next();
              }, {
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                offset: ['100%-5', 5],
                by: [0.5 * tickSize, 0]
              }, function (next) {
                t.is(record.endDate, new Date(2011, 0, 3, 6, 46, 23), 'Event resized');
                next();
              }, {
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                offset: ['100%-5', 5],
                by: [0.2 * tickSize, 0]
              }, function () {
                t.is(record.endDate, new Date(2011, 0, 3, 6, 46, 23), 'Event wasn\'t resized');
              });

            case 5:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x6) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Resizing event should not move vertically (horizontal scheduler)', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var el, y, relativeY;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return getScheduler(t, {
                startDate: new Date(2011, 0, 3),
                viewPreset: 'hourAndDay',
                resourceStore: t.getResourceStore2({}, 30),
                events: [{
                  id: 1,
                  name: 'Event1',
                  cls: 'b-sch-event1',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 3, 4, 13, 18),
                  endDate: new Date(2011, 0, 3, 6, 16, 23)
                }, {
                  id: 2,
                  name: 'Event2',
                  cls: 'b-sch-event2',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 3, 5, 13, 18),
                  endDate: new Date(2011, 0, 3, 7, 16, 23)
                }],
                features: {
                  eventResize: true
                }
              });

            case 2:
              scheduler = _context6.sent;
              t.chain( // resizing start
              function (next) {
                el = document.querySelector('.b-sch-event1');
                relativeY = DomHelper.getTranslateY(el) - DomHelper.getTranslateY(el.parentElement);
                next();
              }, {
                moveMouseTo: '.b-sch-event1'
              }, {
                drag: '.b-sch-event1',
                offset: ['100%-5', 5],
                by: [20, 0],
                dragOnly: true
              }, function (next) {
                t.selectorExists('.b-resizing-event', 'Resizing CSS class added');
                el = document.querySelector('.b-sch-event1');
                y = DomHelper.getTranslateY(el);
                scheduler.bodyContainer.scrollTop = 100;
                next();
              }, function (next) {
                t.is(DomHelper.getTranslateY(el) - DomHelper.getTranslateY(el.parentElement), relativeY, 'Cell-relative position hasn\'t changed');
                t.is(DomHelper.getTranslateY(el), y, 'First event scheduler position hasn\'t changed');
                next();
              }, {
                action: 'mouseUp'
              }, function (next) {
                scheduler.bodyContainer.scrollTop = 10;
                next();
              }, // drag second
              {
                moveCursorTo: '.b-sch-event2'
              }, function (next) {
                el = document.querySelector('.b-sch-event2');
                relativeY = DomHelper.getTranslateY(el) - DomHelper.getTranslateY(el.parentElement);
                next();
              }, {
                moveMouseTo: '.b-sch-event1'
              }, {
                moveMouseTo: '.b-sch-event2'
              }, {
                drag: '.b-sch-event2',
                offset: ['100%-5', 5],
                by: [20, 0],
                dragOnly: true
              }, function (next) {
                el = document.querySelector('.b-sch-event2');
                y = DomHelper.getTranslateY(el);
                scheduler.bodyContainer.scrollTop = 100;
                next();
              }, function (next) {
                t.is(DomHelper.getTranslateY(el) - DomHelper.getTranslateY(el.parentElement), relativeY, 'Cell-relative position hasn\'t changed');
                t.is(DomHelper.getTranslateY(el), y, 'Second event\' position hasn\'t changed');
                next();
              }, {
                action: 'mouseUp'
              });

            case 4:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x7) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('DOM element of target being resized should be above any other event DOM elements', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return getScheduler(t, {
                startDate: new Date(2011, 0, 3),
                viewPreset: 'hourAndDay',
                features: {
                  eventResize: {
                    showTooltip: false
                  }
                },
                events: [{
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 3, 4),
                  endDate: new Date(2011, 0, 3, 4, 50),
                  cls: 'foo'
                }, {
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 3, 5),
                  endDate: new Date(2011, 0, 3, 5, 50),
                  cls: 'bar'
                }]
              });

            case 2:
              scheduler = _context7.sent;
              // for edge, siesta does not like fractional heights
              scheduler.headerContainer.style.height = '60px';
              t.willFireNTimes(scheduler, 'beforeeventresize', 2);
              t.willFireNTimes(scheduler, 'eventresizestart', 2);
              t.firesAtLeastNTimes(scheduler, 'eventpartialresize', 1);
              t.willFireNTimes(scheduler, 'eventresizeend', 2);
              t.chain({
                moveCursorTo: '.foo'
              }, {
                drag: '.foo',
                offset: ['100%-5', 10],
                by: [50, 0],
                dragOnly: true
              }, function (next) {
                var resizeElZIndex = window.getComputedStyle(document.querySelector(scheduler.eventSelector + '.b-sch-event-wrap-resizing'))['z-index'],
                    otherElZIndex = window.getComputedStyle(document.querySelector(scheduler.eventSelector + ':not(.b-sch-event-wrap-resizing)'))['z-index'];
                t.isGreater(Number(resizeElZIndex), Number(otherElZIndex), 'Active resize target should be above any event in the z-index stack', true);
                next();
              }, {
                moveCursorBy: [-50, 0]
              }, {
                mouseUp: null
              }, {
                moveCursorTo: '.bar'
              }, {
                drag: '.bar',
                offset: [5, '50%'],
                by: [-50, 0],
                dragOnly: true
              }, function (next) {
                var resizeElZIndex = window.getComputedStyle(document.querySelector(scheduler.eventSelector + '.b-sch-event-wrap-resizing'))['z-index'],
                    otherElZIndex = window.getComputedStyle(document.querySelector(scheduler.eventSelector + ':not(.b-sch-event-wrap-resizing)'))['z-index'];
                t.isGreater(Number(resizeElZIndex), Number(otherElZIndex), 'Active resize target should be above any event in the z-index stack', true);
                next();
              }, {
                mouseUp: null
              }, {
                waitForSelector: '.bar',
                desc: 'bar element rendered'
              }, {
                waitForSelector: '.foo',
                desc: 'foo element rendered'
              });

            case 9:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x8) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Clock in tooltip is updated on resize', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var assertClock, step;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              assertClock = function _assertClock(t, hour, minute, side) {
                var hourIndicator = document.querySelector(".b-sch-tip-valid .b-sch-tooltip-".concat(side, "date .b-sch-hour-indicator")),
                    minuteIndicator = document.querySelector(".b-sch-tip-valid .b-sch-tooltip-".concat(side, "date .b-sch-minute-indicator"));
                t.is(hourIndicator.style.transform, "rotate(".concat(hour * 30, "deg)"), 'Hour indicator is ok');
                t.is(minuteIndicator.style.transform, "rotate(".concat(minute * 6, "deg)"), 'Minute indicator is ok');
              };

              _context8.next = 3;
              return getScheduler(t, {
                viewPreset: 'hourAndDay',
                startDate: new Date(2018, 3, 27),
                endDate: new Date(2018, 3, 30),
                eventStore: t.getEventStore({
                  data: [{
                    startDate: '2018-04-27T00:00',
                    endDate: '2018-04-27T01:00',
                    id: 1,
                    resourceId: 'r1'
                  }]
                })
              });

            case 3:
              scheduler = _context8.sent;
              step = scheduler.timeAxisViewModel.tickSize / 2;
              t.chain({
                drag: '.b-sch-event',
                fromOffset: ['100%-5', '50%'],
                by: [[step, 0]],
                dragOnly: true
              }, {
                waitForSelector: '.b-sch-tip-valid'
              }, function (next, el) {
                assertClock(t, 1, 30, 'end');
                next();
              }, {
                moveMouseBy: [step, 0]
              }, {
                waitFor: 100
              }, function (next) {
                assertClock(t, 2, 0, 'end');
                next();
              }, {
                moveMouseBy: [step, 0]
              }, function (next) {
                assertClock(t, 2, 30, 'end');
                next();
              }, {
                mouseUp: null
              }, {
                drag: '.b-sch-event',
                fromOffset: [5, '50%'],
                by: [[step, 0]],
                dragOnly: true
              }, {
                waitForSelector: '.b-sch-tip-valid'
              }, function (next, el) {
                assertClock(t, 0, 30, 'start');
                next();
              }, {
                moveMouseBy: [step, 0]
              }, function (next) {
                assertClock(t, 1, 0, 'start');
                next();
              }, {
                moveMouseBy: [step, 0]
              }, function (next) {
                assertClock(t, 1, 30, 'start');
                next();
              }, {
                mouseUp: null
              });

            case 6:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x9) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Should not allow resizing if readOnly', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var width;
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return getScheduler(t, {
                features: {
                  eventResize: true
                },
                readOnly: true
              });

            case 2:
              scheduler = _context9.sent;
              width = document.querySelector('.b-sch-event').offsetWidth;
              t.wontFire(scheduler, 'beforeeventresize');
              t.wontFire(scheduler, 'eventresizestart');
              t.chain({
                drag: '.b-sch-event',
                offset: ['100%', 10],
                by: [-30, 0]
              }, function () {
                t.is(document.querySelector('.b-sch-event').offsetWidth, width, 'Event not resized');
              });

            case 7:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x10) {
      return _ref11.apply(this, arguments);
    };
  }()); // Test tooltip alignment when the document is scrolled.
  // https://app.assembla.com/spaces/bryntum/tickets/6740

  if (document.scrollingElement) {
    t.it('Tooltip should align correctly', /*#__PURE__*/function () {
      var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
        var step, eventEl;
        return regeneratorRuntime.wrap(function _callee10$(_context10) {
          while (1) {
            switch (_context10.prev = _context10.next) {
              case 0:
                _context10.next = 2;
                return getScheduler(t, {
                  viewPreset: 'hourAndDay',
                  startDate: new Date(2018, 3, 27),
                  endDate: new Date(2018, 3, 30),
                  eventStore: t.getEventStore({
                    data: [{
                      startDate: '2018-04-27',
                      endDate: '2018-04-27 01:00',
                      id: 1,
                      resourceId: 'r1'
                    }]
                  })
                });

              case 2:
                scheduler = _context10.sent;
                // Visually the look should be the same, but the document is scrolled.
                document.scrollingElement.style.paddingTop = '1000px';
                document.scrollingElement.scrollTop = 1000;
                step = scheduler.timeAxisViewModel.tickSize / 2, eventEl = scheduler.getElementsFromEventRecord(scheduler.eventStore.getAt(0))[0];
                t.chain({
                  drag: '.b-sch-event',
                  fromOffset: ['100%-5', '50%'],
                  by: [[step, 0]],
                  dragOnly: true
                }, {
                  waitForSelector: '.b-sch-tip-valid'
                }, function (next) {
                  var tip = scheduler.features.eventResize.tip;
                  t.isApprox(tip.element.getBoundingClientRect().top, eventEl.getBoundingClientRect().bottom + tip.anchorSize[1], 'Resize tip is aligned just below the event');
                  next();
                }, {
                  mouseUp: null
                }, function () {
                  document.scrollingElement.style.paddingTop = '0px';
                  document.scrollingElement.scrollTop = 0;
                });

              case 7:
              case "end":
                return _context10.stop();
            }
          }
        }, _callee10);
      }));

      return function (_x11) {
        return _ref12.apply(this, arguments);
      };
    }());
  }

  t.it('Should show message and block drop if validator returns object with `valid` false', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return getScheduler(t, {
                features: {
                  eventResize: {
                    validatorFn: function validatorFn(_ref14, event) {
                      var resourceRecord = _ref14.resourceRecord,
                          eventRecord = _ref14.eventRecord,
                          start = _ref14.start,
                          end = _ref14.end;
                      return {
                        valid: false,
                        message: 'msg'
                      };
                    }
                  }
                },
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }]
              });

            case 2:
              scheduler = _context11.sent;
              t.wontFire(scheduler.eventStore, 'change');
              t.chain({
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                offset: ['100%-3', 5],
                by: [100, 0],
                dragOnly: true
              }, {
                waitForSelector: '.b-tooltip .b-sch-tip-message:textEquals(msg)'
              }, {
                mouseUp: null
              });

            case 5:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x12) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('Should not show message if validator returns object with `valid` true', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return getScheduler(t, {
                features: {
                  eventResize: {
                    validatorFn: function validatorFn(_ref16, event) {
                      var resourceRecord = _ref16.resourceRecord,
                          eventRecord = _ref16.eventRecord,
                          start = _ref16.start,
                          end = _ref16.end;
                      return {
                        valid: true
                      };
                    }
                  }
                },
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }]
              });

            case 2:
              scheduler = _context12.sent;
              t.firesOnce(scheduler.eventStore, 'change');
              t.chain({
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                offset: ['100%-3', 5],
                by: [100, 0],
                dragOnly: true
              }, {
                waitForSelector: '.b-tooltip .b-sch-tip-message:empty'
              }, {
                mouseUp: null
              });

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
  t.it('Should consider undefined return value as valid action', /*#__PURE__*/function () {
    var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return getScheduler(t, {
                features: {
                  eventResize: {
                    validatorFn: function validatorFn(_ref18, event) {
                      var resourceRecord = _ref18.resourceRecord,
                          eventRecord = _ref18.eventRecord,
                          start = _ref18.start,
                          end = _ref18.end;
                    }
                  }
                },
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }]
              });

            case 2:
              scheduler = _context13.sent;
              t.firesOnce(scheduler.eventStore, 'change');
              t.chain({
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                offset: ['100%-3', 5],
                by: [100, 0]
              });

            case 5:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x14) {
      return _ref17.apply(this, arguments);
    };
  }());
  t.it('Should show same end date, as in calendar icon', /*#__PURE__*/function () {
    var _ref19 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _context14.next = 2;
              return getScheduler(t, {
                viewPreset: 'weekAndDayLetter',
                events: [{
                  id: 1,
                  name: 'Event',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }]
              });

            case 2:
              scheduler = _context14.sent;
              t.chain({
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                offset: ['100%-3', 5],
                by: [90, 0],
                dragOnly: true
              }, {
                waitForSelector: '.b-sch-clock-day.b-sch-tooltip-enddate .b-sch-clock-text:textEquals(Jan 7, 2011)'
              }, {
                waitForSelector: '.b-sch-clock-day.b-sch-tooltip-enddate .b-sch-clock:contains(7)'
              }, {
                mouseUp: null
              });

            case 4:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x15) {
      return _ref19.apply(this, arguments);
    };
  }());
  t.it('Should respect Scheduler#getDateConstraints', /*#__PURE__*/function () {
    var _ref20 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      var called;
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              called = false;
              _context15.next = 3;
              return getScheduler(t, {
                resources: [{
                  id: 'r1',
                  name: 'Resource 1'
                }],
                getDateConstraints: function getDateConstraints(resourceRecord, eventRecord) {
                  t.ok(resourceRecord instanceof scheduler.resourceStore.modelClass, 'resourceRecord arg has correct type');
                  t.ok(eventRecord instanceof scheduler.eventStore.modelClass, 'eventRecord arg has correct type');
                  called = true;
                  return {
                    start: new Date(2011, 0, 4),
                    end: new Date(2011, 0, 6)
                  };
                }
              });

            case 3:
              scheduler = _context15.sent;
              t.chain({
                drag: '.b-sch-event',
                offset: ['100%-3', 10],
                by: [200, 0]
              }, function () {
                t.ok(called, 'getDateConstraints() was called');
                t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 4), 'Correct startDate');
                t.is(scheduler.eventStore.first.endDate, new Date(2011, 0, 6), 'Correct endDate');
              });

            case 5:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x16) {
      return _ref20.apply(this, arguments);
    };
  }());
  t.it('Should respect Scheduler#getDateConstraints & showExactResizePosition', /*#__PURE__*/function () {
    var _ref21 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return getScheduler(t, {
                features: {
                  eventResize: {
                    showExactResizePosition: true
                  }
                },
                resources: [{
                  id: 'r1',
                  name: 'Resource 1'
                }],
                getDateConstraints: function getDateConstraints() {
                  return {
                    start: new Date(2011, 0, 4),
                    end: new Date(2011, 0, 6)
                  };
                }
              });

            case 2:
              scheduler = _context16.sent;
              t.chain({
                drag: '.b-sch-event',
                offset: ['100%-3', 10],
                by: [200, 0],
                dragOnly: true
              }, function (next) {
                t.isApprox(document.querySelector('.b-sch-event:not(.b-sch-released)').offsetWidth, 200, 'Width limited by constraint');
                next();
              }, {
                mouseUp: null
              }, function () {
                t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 4), 'Correct startDate');
                t.is(scheduler.eventStore.first.endDate, new Date(2011, 0, 6), 'Correct endDate');
              });

            case 4:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x17) {
      return _ref21.apply(this, arguments);
    };
  }());
  t.it('Should add/remove b-sch-terminals-visible class to/from event inner', /*#__PURE__*/function () {
    var _ref22 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      var eventInner, eventWrap;
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return getScheduler(t, {
                features: {
                  eventResize: {
                    showExactResizePosition: true
                  },
                  dependencies: true
                },
                resources: [{
                  id: 'r1',
                  name: 'Resource 1'
                }],
                getDateConstraints: function getDateConstraints() {
                  return {
                    start: new Date(2011, 0, 4),
                    end: new Date(2011, 0, 6)
                  };
                }
              });

            case 2:
              scheduler = _context17.sent;
              eventInner = scheduler.getElementFromEventRecord(scheduler.eventStore.first), eventWrap = eventInner.parentNode;
              t.chain({
                moveMouseTo: eventInner,
                offset: [4, 10]
              }, function (next) {
                t.ok(!eventWrap.classList.contains('b-sch-terminals-visible'));
                t.ok(eventInner.classList.contains('b-sch-terminals-visible'));
                next();
              }, {
                drag: eventInner,
                offset: [4, 10],
                by: [2, 0]
              }, function (next) {
                t.ok(!eventWrap.classList.contains('b-sch-terminals-visible'));
                t.ok(eventInner.classList.contains('b-sch-terminals-visible'));
                next();
              }, {
                mouseUp: null
              });

            case 5:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x18) {
      return _ref22.apply(this, arguments);
    };
  }());
  t.it('Mouseout through a dep terminal should correctly remove resizing class', /*#__PURE__*/function () {
    var _ref23 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
      var eventInner, eventWrap;
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              _context18.next = 2;
              return getScheduler(t, {
                features: {
                  eventResize: {
                    showExactResizePosition: true
                  },
                  dependencies: true
                },
                resources: [{
                  id: 'r1',
                  name: 'Resource 1'
                }],
                getDateConstraints: function getDateConstraints() {
                  return {
                    start: new Date(2011, 0, 4),
                    end: new Date(2011, 0, 6)
                  };
                }
              });

            case 2:
              scheduler = _context18.sent;
              eventInner = scheduler.getElementFromEventRecord(scheduler.eventStore.first), eventWrap = eventInner.parentNode;
              t.chain({
                moveMouseTo: eventInner,
                offset: [4, '50%']
              }, // Inner and outer get their correct classes
              function (next) {
                t.ok(eventWrap.classList.contains('b-over-resize-handle'));
                t.ok(eventInner.classList.contains('b-resize-handle'));
                next();
              }, // Exit through the dep terminal
              {
                moveMouseBy: [-20, 0]
              }, // Inner and outer get the resizing classes removed
              function () {
                t.notOk(eventWrap.classList.contains('b-over-resize-handle'));
                t.notOk(eventInner.classList.contains('b-resize-handle'));
              });

            case 5:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    }));

    return function (_x19) {
      return _ref23.apply(this, arguments);
    };
  }());
  t.it('Should abort on ESC key', /*#__PURE__*/function () {
    var _ref24 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t) {
      var evt;
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              _context19.next = 2;
              return getScheduler(t, {
                events: [{
                  id: 1,
                  name: 'Event',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }]
              });

            case 2:
              scheduler = _context19.sent;
              evt = scheduler.eventStore.first;
              t.firesOnce(scheduler, 'eventResizeEnd');
              t.chain({
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                offset: ['100%-3', 5],
                by: [100, 0],
                dragOnly: true
              }, function (next) {
                t.ok(evt.meta.isResizing, 'isResizing flag set correctly');
                next();
              }, {
                type: '[ESCAPE]'
              }, function () {
                t.selectorNotExists('.b-resizing-event', 'not resizing anymore');
                t.notOk(evt.meta.isResizing, 'isResizing flag cleared correctly');
              });

            case 6:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    }));

    return function (_x20) {
      return _ref24.apply(this, arguments);
    };
  }());
  t.it('Should respect `allowOverlap` setting on Scheduler', /*#__PURE__*/function () {
    var _ref25 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(t) {
      var originalWidth;
      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              _context20.next = 2;
              return getScheduler(t, {
                allowOverlap: false,
                events: [{
                  id: 1,
                  name: 'Event',
                  resourceId: 'r1',
                  cls: 'one',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }, {
                  id: 2,
                  name: 'Event 2',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 7),
                  endDate: new Date(2011, 0, 8)
                }]
              });

            case 2:
              scheduler = _context20.sent;
              t.wontFire(scheduler.eventStore, 'update');
              originalWidth = document.querySelector('.one').offsetWidth;
              t.chain({
                moveCursorTo: '.b-sch-event'
              }, {
                drag: '.b-sch-event',
                offset: ['100%-3', 5],
                by: [200, 0]
              }, {
                waitFor: function waitFor() {
                  return document.querySelector('.one').offsetWidth === originalWidth;
                }
              });

            case 6:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    }));

    return function (_x21) {
      return _ref25.apply(this, arguments);
    };
  }());
  t.it('Should have completed context on a non-resize', /*#__PURE__*/function () {
    var _ref26 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21(t) {
      return regeneratorRuntime.wrap(function _callee21$(_context21) {
        while (1) {
          switch (_context21.prev = _context21.next) {
            case 0:
              _context21.next = 2;
              return getScheduler(t, {
                events: [{
                  id: 1,
                  name: 'Event',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }]
              });

            case 2:
              scheduler = _context21.sent;
              t.wontFire(scheduler, 'eventResizeEnd');
              t.chain({
                moveCursorTo: '.b-sch-event'
              }, // Resize by less than the starting threshold. Which is zero by default
              // so drag by zero pixels.
              // resizeEnd should still be able to read off the record we dragged.
              {
                drag: '.b-sch-event',
                offset: [10, '50%'],
                by: [0, 0]
              }, function () {
                t.selectorNotExists('.b-resizing-event', 'not resizing anymore');
              });

            case 5:
            case "end":
              return _context21.stop();
          }
        }
      }, _callee21);
    }));

    return function (_x22) {
      return _ref26.apply(this, arguments);
    };
  }());
  t.it('Should support disabling', /*#__PURE__*/function () {
    var _ref27 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
      return regeneratorRuntime.wrap(function _callee22$(_context22) {
        while (1) {
          switch (_context22.prev = _context22.next) {
            case 0:
              _context22.next = 2;
              return getScheduler(t);

            case 2:
              scheduler = _context22.sent;
              scheduler.features.eventResize.disabled = true;
              t.chain({
                drag: '.b-sch-event',
                offset: [3, 10],
                by: [50, 0],
                dragOnly: true
              }, function (next) {
                t.selectorNotExists('.b-sch-event-resizing', 'Not resizing');
                scheduler.features.eventResize.disabled = false;
                next();
              }, {
                mouseUp: null
              }, {
                drag: '.b-sch-event',
                offset: [3, 10],
                by: [50, 0],
                dragOnly: true
              }, function (next) {
                t.selectorExists('.b-sch-event-resizing', 'Resizing');
                next();
              }, {
                mouseUp: null
              });

            case 5:
            case "end":
              return _context22.stop();
          }
        }
      }, _callee22);
    }));

    return function (_x23) {
      return _ref27.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1198

  t.it('Resizing left handle outside schedule area to the left should not stretch event width', /*#__PURE__*/function () {
    var _ref28 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee25(t) {
      var eventLength;
      return regeneratorRuntime.wrap(function _callee25$(_context25) {
        while (1) {
          switch (_context25.prev = _context25.next) {
            case 0:
              _context25.next = 2;
              return getScheduler(t, {
                startDate: new Date(2011, 0, 4)
              });

            case 2:
              scheduler = _context25.sent;
              t.chain({
                waitForSelector: '.b-sch-event-wrap[data-event-id="1"]'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23() {
                return regeneratorRuntime.wrap(function _callee23$(_context23) {
                  while (1) {
                    switch (_context23.prev = _context23.next) {
                      case 0:
                        eventLength = t.rect('.b-sch-event-wrap[data-event-id="1"]').width;

                      case 1:
                      case "end":
                        return _context23.stop();
                    }
                  }
                }, _callee23);
              })), {
                drag: '.b-sch-event-wrap[data-event-id="1"]',
                offset: [5, 10],
                by: [-200, 0],
                dragOnly: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee24() {
                return regeneratorRuntime.wrap(function _callee24$(_context24) {
                  while (1) {
                    switch (_context24.prev = _context24.next) {
                      case 0:
                        t.is(t.rect('.b-sch-event-wrap-resizing').width, eventLength, 'Proxy element should not be increased since there is no place to drag left');

                      case 1:
                      case "end":
                        return _context24.stop();
                    }
                  }
                }, _callee24);
              })), {
                mouseUp: null
              });

            case 4:
            case "end":
              return _context25.stop();
          }
        }
      }, _callee25);
    }));

    return function (_x24) {
      return _ref28.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2082

  t.it('Should accept a tip config object', /*#__PURE__*/function () {
    var _ref31 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee26(t) {
      return regeneratorRuntime.wrap(function _callee26$(_context26) {
        while (1) {
          switch (_context26.prev = _context26.next) {
            case 0:
              _context26.next = 2;
              return getScheduler(t, {
                features: {
                  eventResize: {
                    tip: {
                      cls: 'foo'
                    }
                  }
                }
              });

            case 2:
              scheduler = _context26.sent;
              t.chain({
                drag: '.b-sch-event',
                fromOffset: ['100%-5', '50%'],
                by: [50, 0],
                dragOnly: true
              }, function () {
                t.selectorExists('.b-tooltip.foo', 'Tip was configured properly');
              });

            case 4:
            case "end":
              return _context26.stop();
          }
        }
      }, _callee26);
    }));

    return function (_x25) {
      return _ref31.apply(this, arguments);
    };
  }());
  t.it('Should accept a tip instance', /*#__PURE__*/function () {
    var _ref32 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee27(t) {
      return regeneratorRuntime.wrap(function _callee27$(_context27) {
        while (1) {
          switch (_context27.prev = _context27.next) {
            case 0:
              _context27.next = 2;
              return getScheduler(t, {
                features: {
                  eventResize: {
                    tip: new Tooltip({
                      html: 'foo'
                    })
                  }
                }
              });

            case 2:
              scheduler = _context27.sent;
              t.chain({
                drag: '.b-sch-event',
                fromOffset: ['100%-5', '50%'],
                by: [50, 0],
                dragOnly: true
              }, function () {
                t.selectorExists('.b-tooltip:contains(foo)', 'Tip was configured properly');
              });

            case 4:
            case "end":
              return _context27.stop();
          }
        }
      }, _callee27);
    }));

    return function (_x26) {
      return _ref32.apply(this, arguments);
    };
  }());
  t.it('Should handle event being removed while resizing', /*#__PURE__*/function () {
    var _ref33 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee29(t) {
      return regeneratorRuntime.wrap(function _callee29$(_context29) {
        while (1) {
          switch (_context29.prev = _context29.next) {
            case 0:
              _context29.next = 2;
              return getScheduler(t);

            case 2:
              scheduler = _context29.sent;
              t.firesOnce(scheduler.eventStore, 'update');
              t.chain({
                drag: scheduler.unreleasedEventSelector,
                fromOffset: ['100%-5', '50%'],
                by: [50, 0],
                dragOnly: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee28() {
                return regeneratorRuntime.wrap(function _callee28$(_context28) {
                  while (1) {
                    switch (_context28.prev = _context28.next) {
                      case 0:
                        scheduler.eventStore.first.remove();

                      case 1:
                      case "end":
                        return _context28.stop();
                    }
                  }
                }, _callee28);
              })), {
                mouseUp: null
              }, {
                waitForSelectorNotFound: "".concat(scheduler.unreleasedEventSelector, ":contains(Assignment 1)")
              }, {
                drag: scheduler.unreleasedEventSelector,
                fromOffset: ['100%-5', '50%'],
                by: [50, 0]
              });

            case 5:
            case "end":
              return _context29.stop();
          }
        }
      }, _callee29);
    }));

    return function (_x27) {
      return _ref33.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2497

  t.it('Should never derender an event while resizing', /*#__PURE__*/function () {
    var _ref35 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee30(t) {
      var event, eventEl, targetScrollDate;
      return regeneratorRuntime.wrap(function _callee30$(_context30) {
        while (1) {
          switch (_context30.prev = _context30.next) {
            case 0:
              _context30.next = 2;
              return getScheduler(t, {
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 30)
              });

            case 2:
              scheduler = _context30.sent;
              event = scheduler.eventStore.first, eventEl = scheduler.getEventElement(event), targetScrollDate = new Date(2011, 0, 22);
              _context30.next = 6;
              return t.dragBy({
                source: eventEl,
                delta: [600, 0],
                dragOnly: true,
                offset: ['100%-5', '50%']
              });

            case 6:
              _context30.next = 8;
              return t.waitFor(function () {
                return scheduler.visibleDateRange.endDate >= targetScrollDate;
              });

            case 8:
              // Must not have been derendered
              t.elementIsVisible(eventEl);
              _context30.next = 11;
              return t.mouseUp();

            case 11:
            case "end":
              return _context30.stop();
          }
        }
      }, _callee30);
    }));

    return function (_x28) {
      return _ref35.apply(this, arguments);
    };
  }());
  t.it('Should support using tooltipTemplate', /*#__PURE__*/function () {
    var _ref36 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee31(t) {
      return regeneratorRuntime.wrap(function _callee31$(_context31) {
        while (1) {
          switch (_context31.prev = _context31.next) {
            case 0:
              _context31.next = 2;
              return t.getScheduler({
                appendTo: document.body,
                features: {
                  eventResize: {
                    tooltipTemplate: function tooltipTemplate(_ref37) {
                      var record = _ref37.record,
                          startDate = _ref37.startDate,
                          endDate = _ref37.endDate;
                      var eventRecord = scheduler.eventStore.first;
                      t.is(record, eventRecord, 'record date ok');
                      t.is(startDate, eventRecord.startDate, 'Start date ok');
                      t.isGreaterOrEqual(endDate, eventRecord.endDate, 'End date ok');
                      return eventRecord.name;
                    }
                  }
                }
              });

            case 2:
              scheduler = _context31.sent;
              t.chain({
                moveCursorTo: '[data-event-id=1]'
              }, {
                drag: '[data-event-id=1]',
                offset: ['100%-1', '50%'],
                by: [100, 0],
                dragOnly: true
              }, function () {
                return t.selectorExists('.b-tooltip:contains(Assignment 1)');
              });

            case 4:
            case "end":
              return _context31.stop();
          }
        }
      }, _callee31);
    }));

    return function (_x29) {
      return _ref36.apply(this, arguments);
    };
  }());
});