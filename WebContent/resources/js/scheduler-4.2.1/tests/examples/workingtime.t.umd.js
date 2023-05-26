function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.it('sanity', function (t) {
    t.chain({
      waitForSelector: '.b-sch-foreground-canvas'
    }, function (next, el) {
      scheduler = bryntum.fromElement(el[0], 'scheduler');
      next();
    }, function () {
      return t.checkGridSanity(scheduler);
    });
  }); // https://github.com/bryntum/support/issues/639

  t.it('Should update working time', function (t) {
    t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.isDeeply(scheduler.workingTime, {
                fromHour: 8,
                toHour: 17,
                fromDay: 1,
                toDay: 6
              }, 'Working time is correct');

            case 1:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    })), {
      click: '[data-ref="workingTimeBtn"]'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              t.notOk(scheduler.workingTime, 'Working time is not set');

            case 1:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    })), {
      click: '[data-ref="workingTimeBtn"]'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              t.isDeeply(scheduler.workingTime, {
                fromHour: 8,
                toHour: 17,
                fromDay: 1,
                toDay: 6
              }, 'Working time is correct');

            case 1:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    })));
  }); // Code editor not supported with umd bundle

  if (t.getMode() !== 'umd' && t.browser.chrome) {
    t.it('Code editor', function (t) {
      t.chain({
        click: '[data-ref=codeButton]'
      }, {
        waitForSelector: 'pre:contains(refreshWorkingTime)',
        desc: 'JS loaded'
      }, {
        click: function click() {
          return window.shared.codeEditor.widgetMap.autoApply.element;
        }
      }, function (next) {
        document.querySelector('code[data-owner-cmp]').innerHTML = '';
        next();
      }, {
        click: function click() {
          return window.shared.codeEditor.widgetMap.applyButton.element;
        }
      }, {
        waitForSelectorNotFound: '[data-reference=outer]',
        desc: 'Old elements removed'
      });
    });
  }
});