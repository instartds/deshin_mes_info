function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler({
      features: {
        eventDrag: {
          showTooltip: false
        }
      }
    });
  });
  t.it('Should not change a record after trying to drag it outside of the chart', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var element, startRect;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.wontFire(scheduler.eventStore, 'update');
              _context.next = 3;
              return t.waitForProjectReady(scheduler);

            case 3:
              element = document.querySelector('[data-event-id="1"]'), startRect = element.getBoundingClientRect();
              t.chain({
                drag: element,
                to: [5, 5]
              }, {
                waitFor: function waitFor() {
                  return t.sameRect(element.getBoundingClientRect(), startRect);
                },
                desc: 'Event returned to initial position'
              });

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
  t.it('Event shouldn\'t disappear after drag aborted with ESC (Bug #62)', function (t) {
    t.chain({
      waitForEventsToRender: null
    }, {
      drag: '[data-event-id="1"]',
      by: [200, 0],
      dragOnly: true
    }, {
      type: '[ESC]'
    }, {
      waitFor: 500
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler.refresh();

            case 1:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    })), {
      waitForElementVisible: '[data-event-id="1"]'
    });
  });
});