function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  t.it('Should remove newly created event on cancel', function (t) {
    t.chain({
      waitForSelector: '.b-sch-event'
    }, {
      doubleClick: '[data-id=r6] .b-sch-timeaxis-cell',
      offset: [50, 20]
    }, {
      waitFor: function waitFor() {
        return t.query('input[name=resourceId]')[0].value === 'Peter';
      }
    }, function (next) {
      t.pass('Correct resource in editor');
      t.elementIsNotVisible('.x-button:textEquals(Delete)', 'Delete button not shown');
      next();
    }, {
      click: '.x-button:textEquals(Cancel)'
    }, function () {
      t.selectorNotExists('.b-sch-event-wrap:textEquals(New event)', 'Event removed');
    });
  });
  t.it('Should not remove existing edited event on cancel', function (t) {
    t.chain({
      doubleClick: '.b-sch-event-wrap:textEquals(Task 2)'
    }, {
      waitFor: function waitFor() {
        return t.query('input[name=resourceId]')[0].value === 'Linda';
      }
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.pass('Correct resource in editor');
              t.elementIsVisible('.x-button:textEquals(Delete)', 'Delete button shown');

            case 2:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    })), {
      click: '.x-button:textEquals(Cancel)'
    }, function () {
      t.selectorExists('.b-sch-event-wrap:textEquals(Task 2)', 'Event not removed');
    });
  });
});