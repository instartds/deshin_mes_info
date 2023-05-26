function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  t.beforeEach(function () {
    scheduler && !scheduler.isDestroyed && scheduler.destroy();
  });
  var scheduler, tickSize;
  document.body.style.width = '500px';

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(config) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getSchedulerAsync(Object.assign({
                startDate: new Date(2009, 1, 1),
                endDate: new Date(2009, 1, 11)
              }, config));

            case 2:
              scheduler = _context3.sent;
              tickSize = scheduler.timeAxisViewModel.tickSize;

            case 4:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('should calculate the data from the X position correctly', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler();

            case 2:
              t.is(scheduler.getDateFromCoordinate(0, null, true), new Date(2009, 1, 1), 'Should find start date at point 0');
              t.is(scheduler.getDateFromCoordinate(tickSize, null, true), new Date(2009, 1, 2), 'Should find start date +1d at 1 whole tick');
              _context.next = 6;
              return scheduler.scrollHorizontallyTo(tickSize, false);

            case 6:
              t.is(scheduler.getDateFromCoordinate(document.querySelector('.b-grid-subgrid-normal').scrollLeft, 'round', true), new Date(2009, 1, 2), 'Should find start date +1d at the left edge of 2nd time column');

            case 7:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x2) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('should get correct date from a mouse event', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var reportedMouseoverDate, calculatedMouseoverDate;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getScheduler();

            case 2:
              scheduler.on('scheduleMousemove', function (_ref3) {
                var date = _ref3.date,
                    event = _ref3.event;
                reportedMouseoverDate = date;
                calculatedMouseoverDate = scheduler.getDateFromXY([event.offsetX, event.offsetY], null, true);
              });
              t.chain({
                moveMouseTo: scheduler.timeAxisSubGridElement,
                offset: [0, 50]
              }, // Mouseover pixel 0 should report the start date
              {
                waitFor: function waitFor() {
                  return reportedMouseoverDate - scheduler.timeAxis.startDate === 0 && calculatedMouseoverDate - scheduler.timeAxis.startDate === 0;
                }
              });

            case 4:
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