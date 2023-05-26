function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest({
  defaultTimeout: 90000
}, function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });
  t.it('TOUCH: Touch drag should work', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var event;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync(null, 1);

            case 2:
              scheduler = _context.sent;
              event = scheduler.eventStore.first;
              t.firesOnce(scheduler.eventStore, 'update');
              _context.next = 7;
              return t.delayedTouchDragBy('.b-sch-event:contains(Assignment 1)', [100, 100]);

            case 7:
              _context.next = 9;
              return t.waitForSelectorNotFound('.b-dragging');

            case 9:
              _context.next = 11;
              return t.waitForProjectReady();

            case 11:
              t.is(event.startDate, new Date(2011, 0, 5), 'Event moved in time');
              t.is(event.resource.name, 'Don', 'Event moved vertically');

            case 13:
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
});