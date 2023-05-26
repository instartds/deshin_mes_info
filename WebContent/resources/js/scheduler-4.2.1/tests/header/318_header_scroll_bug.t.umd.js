function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  t.diag('Bug with scrollToDate after setTimeSpan');
  var scheduler = t.getScheduler({
    viewPreset: 'weekAndDay',
    weekStartDay: 1,
    startDate: new Date(2011, 0, 1),
    endDate: new Date(2011, 0, 20)
  });
  var expectedHeaderX;
  t.chain({
    waitForProjectReady: scheduler
  }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
    var targetDate, datePos;
    return regeneratorRuntime.wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            targetDate = new Date(2011, 0, 14);
            scheduler.setTimeSpan(new Date(2011, 0, 2), new Date(2011, 0, 11)); // Calculate the scroll position to bring the whole tick into view.

            datePos = scheduler.getCoordinateFromDate(targetDate, true);
            expectedHeaderX = datePos - scheduler.timeAxisSubGridElement.offsetWidth + scheduler.timeAxisViewModel.tickSize;
            _context.next = 6;
            return scheduler.scrollToDate(targetDate);

          case 6:
          case "end":
            return _context.stop();
        }
      }
    }, _callee);
  })), // Wait for UI to catch up
  {
    waitFor: function waitFor() {
      var headerX = scheduler.timeAxisSubGrid.header.scrollable.x,
          scrollX = scheduler.timeAxisSubGrid.scrollable.x;
      return headerX === expectedHeaderX && headerX === scrollX;
    }
  });
});