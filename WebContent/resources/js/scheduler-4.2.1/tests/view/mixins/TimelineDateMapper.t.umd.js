function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && !scheduler.isDestroyed && scheduler.destroy();
  }); // Scheduler's timeResolution config applied incorrectly (https://github.com/bryntum/support/issues/564)

  t.it('Should accept timeResolution config as Object', function (t) {
    scheduler = new Scheduler({
      viewPreset: 'dayAndWeek',
      timeResolution: {
        unit: 'minute',
        increment: 10
      }
    });
    t.is(scheduler.timeResolution.unit, 'minute', 'Correct timeResolution unit');
    t.is(scheduler.timeResolution.increment, 10, 'Correct timeResolution increment');
  }); // Scheduler's timeResolution config applied incorrectly (https://github.com/bryntum/support/issues/564)

  t.it('Should accept timeResolution config as Number', function (t) {
    scheduler = new Scheduler({
      viewPreset: 'dayAndWeek',
      timeResolution: 15
    });
    t.is(scheduler.timeResolution.unit, 'hour', 'Correct timeResolution unit');
    t.is(scheduler.timeResolution.increment, 15, 'Correct timeResolution increment');
  }); // https://github.com/bryntum/support/issues/1552

  t.it('Should map date when positioned on fractional x', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var timelineStart;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync();

            case 2:
              scheduler = _context.sent;
              scheduler.element.style.left = '0.1px';
              timelineStart = scheduler.timeAxisSubGridElement.getBoundingClientRect().left;
              t.is(scheduler.getDateFromXY([timelineStart, 100], 'floor', false), new Date(2011, 0, 3));

            case 6:
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