function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var topScheduler, bottomScheduler;
  t.beforeEach(function () {
    topScheduler && topScheduler.destroy();
    bottomScheduler && bottomScheduler.destroy();
  });
  t.it('Should sync zoom level', function (t) {
    topScheduler = new Scheduler({
      appendTo: document.body,
      startDate: '2010-01-01',
      width: 800,
      height: 300
    });
    bottomScheduler = new Scheduler({
      appendTo: document.body,
      partner: topScheduler,
      hideHeaders: true,
      width: 800,
      height: 300
    });
    var stepsIn = [],
        stepsOut = [];

    function buildStep() {
      var zoomIn = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : true;
      return [/*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
        return regeneratorRuntime.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                t.diag("Zooming ".concat(zoomIn && 'in' || 'out', " from level ").concat(topScheduler.zoomLevel));
                topScheduler[zoomIn && 'zoomIn' || 'zoomOut']();

              case 2:
              case "end":
                return _context.stop();
            }
          }
        }, _callee);
      })), {
        waitFor: function waitFor() {
          return Math.abs(topScheduler.scrollLeft - bottomScheduler.scrollLeft) < 1 && Math.abs(topScheduler.timeAxisViewModel.totalSize - bottomScheduler.timeAxisViewModel.totalSize) < 1;
        },
        desc: 'Waiting for scroll to sync'
      }];
    }

    for (var i = 0, l = topScheduler.presets.count; i < l - 1; i++) {
      stepsIn.push.apply(stepsIn, buildStep());
      stepsOut.push.apply(stepsOut, buildStep(false));
    }

    t.chain(function (next) {
      t.waitForEvent(topScheduler.timeAxisSubGrid.scrollable, 'scrollEnd', next);
      topScheduler.zoomOutFull();
    }, stepsIn, stepsOut);
  });
});