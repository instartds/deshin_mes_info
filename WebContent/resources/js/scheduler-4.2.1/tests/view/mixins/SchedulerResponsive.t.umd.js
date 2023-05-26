function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.it('Should apply configs from responsiveLevels', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2011, 0, 3),
                endDate: new Date(2011, 0, 20),
                responsiveLevels: {
                  small: {
                    levelWidth: 400,
                    barMargin: 0
                  },
                  normal: {
                    levelWidth: '*',
                    barMargin: 10
                  }
                }
              });

            case 2:
              scheduler = _context.sent;
              t.is(scheduler.barMargin, 10, 'Initial barMargin correct');
              t.chain( // FF, give ResizeObserver time to settle down...
              {
                waitFor: 100
              }, {
                waitForEvent: [window, 'resize'],
                trigger: function trigger() {
                  t.setWindowSize(300, 768);
                }
              }, // FF, give ResizeObserver time to settle down...
              {
                waitFor: 100
              }, {
                waitFor: function waitFor() {
                  return scheduler.responsiveLevel === 'small';
                }
              }, function (next) {
                t.is(scheduler.barMargin, 0, 'Correct barMargin after shrink');
                next();
              }, {
                waitForEvent: [window, 'resize'],
                trigger: function trigger() {
                  t.setWindowSize(500, 768);
                }
              }, // FF, give ResizeObserver time to settle down...
              {
                waitFor: 100
              }, {
                waitFor: function waitFor() {
                  return scheduler.responsiveLevel === 'normal';
                }
              }, function () {
                t.is(scheduler.barMargin, 10, 'Correct barMargin after grow');
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
  }());
});