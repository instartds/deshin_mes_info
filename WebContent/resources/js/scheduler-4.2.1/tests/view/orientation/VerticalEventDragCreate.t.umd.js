function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler; // async beforeEach doesn't work in umd

  t.beforeEach( /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t, next) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler && scheduler.destroy();
              document.body.innerHTML = '';
              _context.next = 4;
              return t.getVerticalSchedulerAsync({
                features: {
                  eventEdit: false
                }
              });

            case 4:
              scheduler = _context.sent;
              next();

            case 6:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x, _x2) {
      return _ref.apply(this, arguments);
    };
  }());

  function assertEventElement(t, eventId) {
    var top = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
    var left = arguments.length > 3 ? arguments[3] : undefined;
    var width = arguments.length > 4 ? arguments[4] : undefined;
    var height = arguments.length > 5 ? arguments[5] : undefined;
    var msg = arguments.length > 6 && arguments[6] !== undefined ? arguments[6] : "for event ".concat(eventId);
    var selector = "[data-event-id=\"".concat(eventId, "\"]:not(.b-released)");

    if (top === null) {
      t.selectorNotExists(selector, 'Element not found');
    } else {
      var element = document.querySelector(selector);
      t.ok(element, 'Element found ' + msg);
      var box = Rectangle.from(element, scheduler.timeAxisSubGridElement);
      t.isApprox(box.top, top, 0.1, 'Correct top');
      t.is(box.left, left, 'Correct left');
      t.is(box.width, width, 'Correct width');
      t.is(box.height, height, 'Correct height');
    }
  }

  t.it('Basic drag creation', function (t) {
    t.chain({
      drag: '.b-sch-timeaxis-cell',
      by: [10, 100],
      offset: [10, 50]
    }, function () {
      t.is(scheduler.eventStore.last.startDate, new Date(2019, 4, 27), 'Correct startDate');
      t.is(scheduler.eventStore.last.endDate, new Date(2019, 4, 29), 'Correct endDate');
      assertEventElement(t, 1, 100, 75, 75, 100);
      assertEventElement(t, 2, 150, 0, 75, 200);
      assertEventElement(t, scheduler.eventStore.last.id, 50, 0, 75, 100);
    });
  });
  t.it('Drag creation triggering scroll', function (t) {
    scheduler.eventStore.removeAll();
    t.chain({
      drag: '.b-sch-timeaxis-cell',
      fromOffset: [10, 400],
      to: '.b-scheduler',
      toOffset: [140, '100%-25']
    }, {
      waitForSelector: '.b-sch-event'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      var event, box;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              event = scheduler.eventStore.last;
              t.is(event.startDate, new Date(2019, 5, 3), 'Correct startDate');
              t.isGreater(event.endDate, new Date(2019, 5, 15), 'Likely correct endDate');
              box = Rectangle.from(document.querySelector("[data-event-id=\"".concat(event.id, "\"]:not(.b-released)")), scheduler.timeAxisSubGridElement);
              t.is(box.top, 400, 'Correct top');
              t.is(box.left, 0, 'Correct left');
              t.is(box.width, 150, 'Correct width');
              t.isGreater(box.height, 600, 'Likely correct height');

            case 8:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    })), {
      drag: '.b-sch-timeaxis-cell',
      fromOffset: ['50%', '100%'],
      to: '.b-grid-body-container',
      toOffset: ['100%-30', '50%'],
      dragOnly: true
    }, {
      waitFor: 500
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              t.is(scheduler.timeAxisSubGrid.scrollable.x, 0, 'Horizontal scroll is intact');
              return _context3.abrupt("return", t.mouseUp());

            case 2:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    })));
  });
  t.it('Drag creation in a scrolled view', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              scheduler.scrollLeft = 300;
              scheduler.scrollTop = 300;
              _context4.next = 4;
              return scheduler.await('scroll');

            case 4:
              _context4.next = 6;
              return scheduler.await('horizontalScroll');

            case 6:
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                by: [10, 100],
                offset: [310, 350]
              }, function () {
                t.is(scheduler.eventStore.last.startDate, new Date(2019, 5, 2), 'Correct startDate');
                t.is(scheduler.eventStore.last.endDate, new Date(2019, 5, 4), 'Correct endDate');
                assertEventElement(t, scheduler.eventStore.last.id, 350, 300, 150, 100);
              });

            case 7:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x3) {
      return _ref4.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1009

  t.it('Should work on scrolled page', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              scheduler.destroy();
              document.body.innerHTML = '<div style="height : 1000px"></div><div id="container"></div>';
              _context5.next = 4;
              return t.getVerticalSchedulerAsync({
                appendTo: 'container',
                width: 1024,
                height: 768,
                features: {
                  eventEdit: false
                }
              });

            case 4:
              scheduler = _context5.sent;
              window.scroll(0, 500);
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                by: [10, 100],
                offset: [310, 350]
              }, function (next) {
                t.is(scheduler.eventStore.last.startDate, new Date(2019, 5, 2), 'Correct startDate');
                t.is(scheduler.eventStore.last.endDate, new Date(2019, 5, 4), 'Correct endDate');
                assertEventElement(t, scheduler.eventStore.last.id, 350, 300, 150, 100);
                next();
              }, // https://github.com/bryntum/support/issues/3081
              {
                drag: '.b-sch-timeaxis-cell',
                offset: [680, 240],
                by: [0, -241]
              }, function () {
                t.is(scheduler.eventStore.last.startDate, new Date(2019, 4, 26), 'Correct startDate');
                t.is(scheduler.eventStore.last.endDate, new Date(2019, 4, 31), 'Correct endDate');
                assertEventElement(t, scheduler.eventStore.last.id, 0, 600, 150, 250);
              });

            case 7:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x4) {
      return _ref5.apply(this, arguments);
    };
  }());
});