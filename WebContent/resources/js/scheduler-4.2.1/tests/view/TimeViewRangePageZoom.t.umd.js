function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  // TODO: Ask Max to check
  t.it('Should update view range correctly on page zoom', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var scheduler, levels;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getSchedulerAsync({
                width: 400,
                height: 300
              });

            case 2:
              scheduler = _context2.sent;
              // Browser zoom levels
              levels = ['0.33', '0.5', '0.67', '0.75', '0.8', '0.9', '1', '1.1', '1.25', '1.5', '1.75'];
              t.chain({
                waitForSelector: '.b-sch-event'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                var i, l, scrollable, zoom;
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        i = 0, l = levels.length;

                      case 1:
                        if (!(i < l)) {
                          _context.next = 14;
                          break;
                        }

                        scrollable = scheduler.timeAxisSubGrid.scrollable, zoom = levels[i];
                        document.body.style.zoom = zoom;
                        _context.next = 6;
                        return scheduler.await('visibleRangeChange');

                      case 6:
                        _context.next = 8;
                        return scrollable.scrollTo(scrollable.maxX);

                      case 8:
                        _context.next = 10;
                        return t.waitFor(function () {
                          return !(scheduler.timeView.endDate - scheduler.endDate);
                        });

                      case 10:
                        t.is(scheduler.timeView.endDate, scheduler.endDate, "View range end is ok on page zoom ".concat(zoom));

                      case 11:
                        i++;
                        _context.next = 1;
                        break;

                      case 14:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })));

            case 5:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
});