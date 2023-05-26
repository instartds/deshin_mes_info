function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach( /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.waitForSelector('.b-sch-event-wrap');

            case 2:
              scheduler = bryntum.query('scheduler');

            case 3:
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
  t.it('sanity', function (t) {
    t.chain(function (next, el) {
      // Make test work.
      // TODO: Fix summary feature leaving cached bodyHeight stale.
      // https://github.com/bryntum/bryntum-suite/issues/631
      scheduler.onHeightChange();
      next();
    }, function () {
      return t.checkGridSanity(scheduler);
    });
  });
  t.it('Sticky centered text', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var _scheduler, timeAxisSubGrid, scrollable, timeAxisViewport, checkElementsContent;

      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _scheduler = scheduler, timeAxisSubGrid = _scheduler.timeAxisSubGrid, scrollable = timeAxisSubGrid.scrollable, timeAxisViewport = timeAxisSubGrid.element.getBoundingClientRect();

              checkElementsContent = function checkElementsContent() {
                t.query("".concat(scheduler.unreleasedEventSelector), timeAxisSubGrid.element).forEach(function (e) {
                  var ebox = e.getBoundingClientRect(),
                      c = e.querySelector('.b-sch-event-content'),
                      cbox = c.getBoundingClientRect(),
                      cmargins = DomHelper.getEdgeSize(c, 'margin'); // If the event bar is showing enough, check that the content is fully visible

                  if (ebox.right - (cbox.width + cmargins.width) > timeAxisViewport.left + 2) {
                    t.isGreaterOrEqual(c.getBoundingClientRect().left - cmargins.left, timeAxisViewport.left);
                  }
                });
              };

              _context2.next = 4;
              return scrollable.scrollTo(scrollable.maxX, null, {
                animate: {
                  duration: 2000
                }
              });

            case 4:
              checkElementsContent();
              _context2.next = 7;
              return scrollable.scrollTo(0, 0);

            case 7:
              _context2.next = 9;
              return t.waitForAnimationFrame();

            case 9:
              _context2.next = 11;
              return t.dragBy('.b-sch-event-wrap[data-event-id="2"]', [-800, 0], null, null, null, true, ['100%-50', '50%']);

            case 11:
              // After dragging, the elements must be in place
              t.query("".concat(scheduler.unreleasedEventSelector, " > * > .b-sch-event-content"), timeAxisSubGrid.element).forEach(function (e) {
                t.isGreater(e.getBoundingClientRect().left, e.parentNode.parentNode.getBoundingClientRect().left);
              });
              _context2.next = 14;
              return t.mouseUp();

            case 14:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }()); // Sequence fails with very quick (faster than a human can do) click sequence after a delete.

  t.it('Monkey-discovered failure vector', function (t) {
    // This should not throw
    t.chain({
      rightclick: [919, 206]
    }, {
      click: [532, 602]
    }, {
      type: '[LEFT][DELETE]'
    }, {
      click: [435, 658]
    });
  });
});