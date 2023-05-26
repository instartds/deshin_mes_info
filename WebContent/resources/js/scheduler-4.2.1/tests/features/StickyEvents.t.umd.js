function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });
  t.it('horizontal', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var _scheduler2, timeAxisSubGrid, scrollable, timeAxisViewport, checkElementsContent;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = t.getScheduler({
                startDate: '2011-01-03',
                endDate: '2011-01-23',
                resourceStore: t.getResourceStore2({}, 25)
              }, 200);
              _scheduler2 = scheduler, timeAxisSubGrid = _scheduler2.timeAxisSubGrid, scrollable = timeAxisSubGrid.scrollable;
              timeAxisViewport = timeAxisSubGrid.element.getBoundingClientRect();
              scheduler.eventStore.add({
                startDate: '2011-01-13',
                endDate: '2011-01-18',
                name: 'Check vertical scroll',
                resourceId: 'r20'
              });

              checkElementsContent = function checkElementsContent() {
                t.query("".concat(scheduler.unreleasedEventSelector), timeAxisSubGrid.element).forEach(function (e) {
                  var ebox = e.getBoundingClientRect(),
                      c = e.querySelector('.b-sch-event-content'),
                      cbox = c.getBoundingClientRect(),
                      cmargins = DomHelper.getEdgeSize(c, 'margin'); // If the event bar is showing enough, check that the content is fully visible

                  if (ebox.right - (cbox.width + cmargins.width) > timeAxisViewport.left + 2) {
                    t.isGreaterOrEqual(c.getBoundingClientRect().left - cmargins.left, timeAxisViewport.left);
                  }
                });
              };

              scrollable.on({
                scroll: checkElementsContent
              });
              _context.next = 8;
              return scrollable.scrollTo(scrollable.maxX, null, {
                animate: {
                  duration: 2000
                }
              });

            case 8:
              _context.next = 10;
              return scrollable.scrollTo(null, scrollable.maxY, {
                animate: {
                  duration: 2000
                }
              });

            case 10:
              // check 'Check vertical scroll' event after scroll down
              // https://github.com/bryntum/support/issues/2666
              checkElementsContent();
              _context.next = 13;
              return scrollable.scrollTo(0, 0);

            case 13:
              _context.next = 15;
              return t.waitForAnimationFrame();

            case 15:
              // After scrolling back, the elements must be in place
              t.query("".concat(scheduler.unreleasedEventSelector, " > * > .b-sch-event-content"), timeAxisSubGrid.element).forEach(function (e) {
                t.isGreater(e.getBoundingClientRect().left, e.parentNode.parentNode.getBoundingClientRect().left);
              });
              _context.next = 18;
              return t.dragBy('.b-sch-event-wrap:contains(Assignment 1)', [-200, 0], null, null, null, true);

            case 18:
              // After dragging, the elements must be in place
              t.query("".concat(scheduler.unreleasedEventSelector, " > * > .b-sch-event-content"), timeAxisSubGrid.element).forEach(function (e) {
                t.isGreater(e.getBoundingClientRect().left, e.parentNode.parentNode.getBoundingClientRect().left);
              });

            case 19:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('vertical', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var _scheduler3, timeAxisSubGrid, scrollable, timeAxisViewport;

      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler = t.getScheduler({
                mode: 'vertical',
                startDate: '2011-01-03',
                endDate: '2011-01-23',
                resourceStore: t.getResourceStore2({}, 10)
              }, 200);
              _scheduler3 = scheduler, timeAxisSubGrid = _scheduler3.timeAxisSubGrid, scrollable = timeAxisSubGrid.scrollable;
              timeAxisViewport = timeAxisSubGrid.element.getBoundingClientRect();
              scrollable.on({
                scroll: function scroll() {
                  t.query("".concat(scheduler.unreleasedEventSelector), timeAxisSubGrid.element).forEach(function (e) {
                    var ebox = e.getBoundingClientRect(),
                        c = e.querySelector('.b-sch-event-content'),
                        cbox = c.getBoundingClientRect(),
                        cmargins = DomHelper.getEdgeSize(c, 'margin'); // If the event bar is showing enough, check that the content is fully visible

                    if (ebox.right - (cbox.height + cmargins.height) > timeAxisViewport.top + 2) {
                      t.isGreaterOrEqual(c.getBoundingClientRect().top - cmargins.top, timeAxisViewport.top);
                    }
                  });
                }
              });
              _context2.next = 6;
              return scrollable.scrollTo(null, scrollable.maxY, {
                animate: {
                  duration: 2000
                }
              });

            case 6:
              _context2.next = 8;
              return scrollable.scrollTo(null, 0);

            case 8:
              // After scrolling back, the elements must be in place
              t.query("".concat(scheduler.unreleasedEventSelector, " > * > .b-sch-event-content"), timeAxisSubGrid.element).forEach(function (e) {
                t.isGreater(e.getBoundingClientRect().top, e.parentNode.parentNode.getBoundingClientRect().top);
              });

            case 9:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Should not crash if events have no content', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var _scheduler4, timeAxisSubGrid, scrollable;

      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              scheduler = t.getScheduler({
                eventRenderer: function eventRenderer() {}
              }, 1);
              _scheduler4 = scheduler, timeAxisSubGrid = _scheduler4.timeAxisSubGrid, scrollable = timeAxisSubGrid.scrollable;
              t.waitForEvent(scrollable, 'scrollEnd');
              _context3.next = 5;
              return scrollable.scrollTo(scrollable.maxX, null);

            case 5:
              t.pass('No crash');

            case 6:
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
  t.it('Content should be shifted on initial render', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var _scheduler5, timeAxisSubGrid, scrollable, timeAxisViewport;

      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              scheduler = t.getScheduler({
                startDate: '2011-01-03',
                endDate: '2011-01-23',
                resourceStore: t.getResourceStore2({}, 250),
                height: 700,
                width: 1000,
                events: function () {
                  var result = [];

                  for (var i = 0; i < 250; i++) {
                    result.push({
                      id: i,
                      name: "This is event ".concat(i + 1),
                      resourceId: "r".concat(i + 1),
                      startDate: '2010-12-01',
                      endDate: '2011-12-31'
                    });
                  }

                  return result;
                }()
              });
              _scheduler5 = scheduler, timeAxisSubGrid = _scheduler5.timeAxisSubGrid, scrollable = _scheduler5.scrollable;
              timeAxisViewport = Rectangle.from(timeAxisSubGrid.element).intersect(Rectangle.from(scheduler.scrollable.element));
              scrollable.on({
                scroll: function scroll() {
                  t.query("".concat(scheduler.unreleasedEventSelector), timeAxisSubGrid.element).forEach(function (e) {
                    var ebox = e.getBoundingClientRect(),
                        c = e.querySelector('.b-sch-event-content'),
                        cbox = c.getBoundingClientRect(),
                        cmargins = DomHelper.getEdgeSize(c, 'margin'); // If the event bar is showing enough, check that the content is fully visible

                    if (ebox.right - (cbox.width + cmargins.width) > timeAxisViewport.left + 2) {
                      if (c.getBoundingClientRect().left - cmargins.left < timeAxisViewport.left) {
                        t.isGreaterOrEqual(c.getBoundingClientRect().left - cmargins.left, timeAxisViewport.left, "Content visible for #".concat(e.textContent));
                      }
                    }
                  });
                }
              });
              _context4.next = 6;
              return scrollable.scrollTo(null, scrollable.maxY, {
                animate: {
                  duration: 3500
                }
              });

            case 6:
              _context4.next = 8;
              return scrollable.scrollTo(0);

            case 8:
              // After scrolling back, the elements must be in place
              t.query("".concat(scheduler.unreleasedEventSelector, " > * > .b-sch-event-content"), timeAxisSubGrid.element).forEach(function (e) {
                t.isGreater(e.getBoundingClientRect().left, e.parentNode.parentNode.getBoundingClientRect().left, "Content visible for #".concat(e.textContent));
              });

            case 9:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should support opt out of stickiness', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              scheduler = t.getScheduler({
                startDate: new Date(2011, 0, 5),
                endDate: new Date(2011, 0, 26),
                visibleDate: {
                  date: new Date(2011, 0, 10),
                  block: 'start'
                },
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  stickyContents: false,
                  startDate: new Date(2011, 0, 6, 10),
                  duration: 5,
                  name: 'non sticky'
                }]
              }, 1);
              _context5.next = 3;
              return t.waitForSelector(scheduler.unreleasedEventSelector);

            case 3:
              t.isLess(t.query('.b-sch-event-content')[0].getBoundingClientRect().left, scheduler.timeAxisSubGridElement.getBoundingClientRect().left, 'Event content out of view');

            case 4:
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
});