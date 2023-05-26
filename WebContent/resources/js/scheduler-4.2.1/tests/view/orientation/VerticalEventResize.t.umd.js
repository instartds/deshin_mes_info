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
              _context.next = 3;
              return t.getVerticalSchedulerAsync();

            case 3:
              scheduler = _context.sent;
              next();

            case 5:
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
      t.ok(element, "Element found ".concat(msg));
      var box = Rectangle.from(element, scheduler.timeAxisSubGridElement);
      t.is(box.top, top, 'Correct top');
      t.is(box.left, left, 'Correct left');
      t.is(box.width, width, 'Correct width');
      t.is(box.height, height, 'Correct height');
      t.contentLike(element, "Event ".concat(eventId), 'Correct text');
    }
  }

  t.it('Should display resize handles on hover', function (t) {
    function assertHandles(el, msg) {
      t.diag(msg); // detect pseudo elements used for resize handles

      var startHandle = window.getComputedStyle(el, ':before');
      t.is(startHandle.height, '4px', 'startHandle.height correct');
      t.is(startHandle.borderTopWidth, '1px', 'startHandle.borderTopWidth correct');
      t.is(startHandle.borderBottomWidth, '1px', 'startHandle.borderBottomWidth correct');
      var endHandle = window.getComputedStyle(el, ':after');
      t.is(endHandle.height, '4px', 'endHandle.height correct');
      t.is(endHandle.borderTopWidth, '1px', 'endHandle.borderTopWidth correct');
      t.is(endHandle.borderBottomWidth, '1px', 'endHandle.borderBottomWidth correct');
    }

    var el = document.querySelector('.b-sch-event');
    t.chain({
      moveMouseTo: el
    }, function (next) {
      assertHandles(el, 'Hovering event');
      next();
    }, {
      moveMouseTo: '.b-sch-event',
      offset: ['50%', 3]
    }, function (next) {
      assertHandles(el, 'Hovering handle');
      next();
    }, {
      drag: '.b-sch-event',
      offset: ['50%', 3],
      by: [0, -20],
      dragOnly: true
    }, function (next) {
      assertHandles(el, 'Dragging handle');
      next();
    }, {
      moveMouseBy: [100, -10]
    }, function (next) {
      assertHandles(el, 'Dragging handle outside of event');
      next();
    }, {
      mouseUp: null
    });
  });
  t.it('Basic resize', function (t) {
    t.chain({
      drag: '[data-event-id="1"]',
      offset: ['50%', '100%-3'],
      by: [0, 100],
      desc: 'Dragging bottom edge down'
    }, function (next) {
      assertEventElement(t, 1, 100, 0, 75, 200);
      t.is(scheduler.eventStore.first.startDate, new Date(2019, 4, 28), 'Start date not updated');
      t.is(scheduler.eventStore.first.endDate, new Date(2019, 5, 1), 'End date updated correctly');
      next();
    }, {
      moveMouseBy: [0, 20]
    }, // It misses the handle otherwise
    {
      drag: '[data-event-id="1"]',
      offset: ['50%', '100%-3'],
      by: [0, -150],
      desc: 'Dragging bottom edge up'
    }, function (next) {
      assertEventElement(t, 1, 100, 0, 150, 50);
      assertEventElement(t, 2, 150, 0, 150, 200);
      t.is(scheduler.eventStore.first.startDate, new Date(2019, 4, 28), 'Start date not updated');
      t.is(scheduler.eventStore.first.endDate, new Date(2019, 4, 29), 'End date updated correctly');
      next();
    }, {
      drag: '[data-event-id="2"]',
      offset: [10, 3],
      by: [0, -50],
      desc: 'Dragging top edge up'
    }, function () {
      assertEventElement(t, 1, 100, 75, 75, 50);
      assertEventElement(t, 2, 100, 0, 75, 250);
      t.is(scheduler.eventStore.getById(2).startDate, new Date(2019, 4, 28), 'Start date not updated');
      t.is(scheduler.eventStore.getById(2).endDate, new Date(2019, 5, 2), 'End date updated correctly');
    });
  }); // https://app.assembla.com/spaces/bryntum/tickets/8946

  t.it('Should not start drag operation', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler.viewPreset = 'hourAndDay';
              scheduler.barMargin = 50;
              scheduler.events = [{
                startDate: scheduler.startDate,
                duration: 1,
                durationUnit: 'h',
                resourceId: 'r2',
                name: '<div><br>bar<br>foo<br>bar</div>'
              }];
              t.firesOnce(scheduler, 'eventresizestart');
              t.wontFire(scheduler, 'eventdragstart');
              _context2.next = 7;
              return scheduler.scrollToTop();

            case 7:
              t.chain({
                drag: '.b-sch-event',
                offset: ['50%', '100%-3'],
                by: [0, 50],
                desc: 'Dragging bottom edge down'
              });

            case 8:
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
});