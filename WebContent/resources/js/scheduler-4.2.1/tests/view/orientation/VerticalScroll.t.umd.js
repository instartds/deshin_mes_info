function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;

  function createScheduler(config) {
    scheduler = t.getVerticalScheduler(config);
  }

  t.beforeEach(function (t, next) {
    scheduler && scheduler.destroy();
    createScheduler(); // wait till scheduler gets rendered before launching a sub-test

    t.waitFor(function () {
      return scheduler.rendered;
    }, next);
  });
  t.it('scrollToDate', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return scheduler.scrollToDate(new Date(2019, 5, 16));

            case 2:
              t.is(scheduler.scrollLeft, 0, 'Not scrolled horizontally');
              t.isApprox(scheduler.scrollTop, 377, 'Scrolled vertically');
              _context.next = 6;
              return scheduler.scrollToDate(new Date(2019, 4, 28));

            case 6:
              t.is(scheduler.scrollLeft, 0, 'Not scrolled horizontally');
              t.isApprox(scheduler.scrollTop, 100, 'Scrolled vertically');

            case 8:
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
  t.it('Vertical scroll should not change when view is focused', function (t) {
    t.chain(function () {
      scheduler.scrollable.y = scheduler.scrollable.maxY;
      return scheduler.scrollable.await('scrollEnd');
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              return _context2.abrupt("return", t.wontFire(scheduler.scrollable, 'scrollStart'));

            case 1:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    })), {
      click: '.b-last'
    }, {
      waitForSelectorNotFound: '.b-scrolling'
    }, function () {
      t.isApprox(scheduler.scrollable.y, scheduler.scrollable.maxY, 1, 'Top scroll position is correct');
    });
  }); // https://github.com/bryntum/support/issues/1416

  t.it('Should be no errors when set timespan out of rendered bounds', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var date, commonStartDate, commonEndDate;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              date = new Date(2019, 10, 10);
              scheduler.zoomLevel = 17;
              commonStartDate = new Date(date.getFullYear(), date.getMonth(), 1, 0), commonEndDate = new Date(date.getFullYear(), date.getMonth() + 1, 0, 24);
              scheduler.setTimeSpan(commonStartDate, commonEndDate);
              scheduler.scrollable.y = scheduler.scrollable.maxY;
              _context3.next = 7;
              return scheduler.scrollable.await('scrollEnd');

            case 7:
              commonStartDate = new Date(date.getFullYear(), date.getMonth(), 12, 0);
              commonEndDate = new Date(date.getFullYear(), date.getMonth() + 1, 0, 24);
              scheduler.setTimeSpan(commonStartDate, commonEndDate);

            case 10:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x2) {
      return _ref3.apply(this, arguments);
    };
  }());
});