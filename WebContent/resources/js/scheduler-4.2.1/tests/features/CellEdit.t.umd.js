function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    var _scheduler$destroy;

    return scheduler === null || scheduler === void 0 ? void 0 : (_scheduler$destroy = scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(scheduler);
  });
  t.it('Should align editor correctly when previous edit changed row height', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                columns: [{
                  field: 'rowHeight',
                  text: 'Height'
                }]
              });

            case 2:
              _context.next = 4;
              return t.doubleClick('.b-grid-cell');

            case 4:
              _context.next = 6;
              return t.type(null, '100[ENTER]');

            case 6:
              _context.next = 8;
              return t.waitForSelector('.b-cell-editor');

            case 8:
              t.isApproxPx(t.rect('.b-cell-editor').top, 146, 'Editor positioned correctly');

            case 9:
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