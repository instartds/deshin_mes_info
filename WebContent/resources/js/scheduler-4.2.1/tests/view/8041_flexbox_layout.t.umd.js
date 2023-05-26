function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  }); // https://app.assembla.com/spaces/bryntum/tickets/8041

  t.it('Scheduler should be stretched inside flexbox container', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              document.body.innerHTML = "\n            <div style=\"height: 300px; width: 400px; background: tomato; display: flex; flex-flow: row nowrap; align-items: stretch;\">\n                <div style=\"background: purple; flex: 1;\"></div>\n                <div id=\"sch\" style=\"flex: 1; display: flex; flex-flow: column nowrap; align-items: stretch; overflow-x: hidden\"></div>\n            </div>";
              _context.next = 3;
              return t.getSchedulerAsync({
                appendTo: 'sch',
                startDate: new Date(2019, 3, 14),
                endDate: new Date(2019, 3, 21)
              });

            case 3:
              scheduler = _context.sent;
              t.is(scheduler.element.getBoundingClientRect().width, 200, 'Scheduler is stretched correctly');

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