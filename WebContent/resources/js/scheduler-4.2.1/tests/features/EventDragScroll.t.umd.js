function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });

  function isMaxYScroll(element) {
    // element.scrollTop is 0 for safari but visually is correct
    var scrollTop = Math.max(scheduler.bodyContainer.offsetTop, element.scrollTop);
    return element.scrollHeight - scrollTop - element.clientHeight <= 1;
  }

  function isMaxXScroll(element) {
    return element.scrollWidth - element.scrollLeft - element.clientWidth <= 1;
  }

  t.it('Should scroll when dragging event (horizontal first)', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var horizontalScrollable, verticalScrollable, eventBox, horizontalBox;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                height: 300,
                width: 300,
                events: [{
                  id: 1,
                  resourceId: 'r2',
                  startDate: '2011-01-03',
                  endDate: '2011-01-04'
                }],
                features: {
                  eventResize: false
                }
              });

            case 2:
              scheduler = _context.sent;
              _context.next = 5;
              return t.waitForSelector('.b-sch-event');

            case 5:
              horizontalScrollable = scheduler.timeAxisSubGrid.scrollable.element, verticalScrollable = scheduler.scrollable.element;
              _context.next = 8;
              return t.dragTo({
                source: '.b-sch-event',
                sourceOffset: ['100%-1', '100%-1'],
                target: verticalScrollable,
                targetOffset: ['100%-30', '50%'],
                dragOnly: true
              });

            case 8:
              _context.next = 10;
              return t.waitFor({
                method: function method() {
                  return isMaxXScroll(horizontalScrollable);
                },
                description: 'Scrolled to the right edge'
              });

            case 10:
              _context.next = 12;
              return t.moveMouseTo({
                target: verticalScrollable,
                offset: ['100%-30', '100%']
              });

            case 12:
              _context.next = 14;
              return t.waitFor({
                method: function method() {
                  return isMaxYScroll(verticalScrollable, t);
                },
                description: 'Scrolled to the bottom edge'
              });

            case 14:
              eventBox = t.rect('.b-sch-event'), horizontalBox = t.rect(horizontalScrollable);
              t.isApprox(eventBox.right, horizontalBox.right, 50, 'Event right coordinate is ok');
              t.isApprox(eventBox.bottom, horizontalBox.bottom, 50, 'Event bottom coordinate is ok');
              _context.next = 19;
              return t.mouseUp();

            case 19:
              t.is(scheduler.eventStore.first.resourceId, 'r6', 'Resource is correct');
              t.isGreater(scheduler.eventStore.first.startDate, new Date(2011, 0, 11), 'Start date is ok');

            case 21:
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
  t.it('Should scroll when dragging event (vertical first)', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var horizontalScrollable, verticalScrollable, eventBox, horizontalBox;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getSchedulerAsync({
                height: 300,
                width: 300,
                events: [{
                  id: 1,
                  resourceId: 'r2',
                  startDate: '2011-01-03',
                  endDate: '2011-01-04'
                }],
                features: {
                  eventResize: false
                }
              });

            case 2:
              scheduler = _context2.sent;
              _context2.next = 5;
              return t.waitForSelector('.b-sch-event');

            case 5:
              horizontalScrollable = scheduler.timeAxisSubGrid.scrollable.element, verticalScrollable = scheduler.scrollable.element;
              _context2.next = 8;
              return t.dragTo({
                source: '.b-sch-event',
                sourceOffset: ['100%-1', '100%-1'],
                target: verticalScrollable,
                targetOffset: ['60%', '100%'],
                dragOnly: true
              });

            case 8:
              _context2.next = 10;
              return t.waitFor({
                method: function method() {
                  return isMaxYScroll(verticalScrollable);
                },
                description: 'Scrolled to the bottom edge'
              });

            case 10:
              _context2.next = 12;
              return t.moveMouseTo({
                target: verticalScrollable,
                offset: ['100%-30', '100%']
              });

            case 12:
              _context2.next = 14;
              return t.waitFor({
                method: function method() {
                  return isMaxXScroll(horizontalScrollable);
                },
                description: 'Scrolled to the right edge'
              });

            case 14:
              eventBox = t.rect('.b-sch-event'), horizontalBox = t.rect(horizontalScrollable);
              t.isApprox(eventBox.right, horizontalBox.right, 50, 'Event right coordinate is ok');
              t.isApprox(eventBox.bottom, horizontalBox.bottom, 50, 'Event bottom coordinate is ok');
              _context2.next = 19;
              return t.mouseUp();

            case 19:
              t.is(scheduler.eventStore.first.resourceId, 'r6', 'Resource is correct');
              t.isGreater(scheduler.eventStore.first.startDate, new Date(2011, 0, 11), 'Start date is ok');

            case 21:
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
});