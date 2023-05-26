function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler = bryntum.query('scheduler');
  t.it('sanity', function (t) {
    t.chain({
      waitForSelector: '.b-sch-foreground-canvas'
    }, function () {
      return t.checkGridSanity(scheduler);
    });
  }); // https://app.assembla.com/spaces/bryntum/tickets/7620

  t.it('Events should have correct position after collapse', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.waitForProjectReady(scheduler);

            case 2:
              scheduler.features.groupSummary.collapseToHeader = false;
              t.chain({
                waitForSelector: '.b-sch-event'
              }, function () {
                return scheduler.scrollable.scrollTo(0, scheduler.scrollable.maxY - 100);
              }, {
                waitForAnimationFrame: null
              }, {
                click: '.b-group-title:contains("Sales (1)")'
              }, {
                waitFor: function waitFor() {
                  var box = Rectangle.from(document.querySelector('[data-event-id=e3]'), scheduler.bodyContainer);
                  return Math.abs(box.top - 1016) < 15;
                },
                desc: 'Event element at correct location'
              }, function () {
                return t.selectorExists('.b-resource-info:contains(Brett Hornbach)', 'Cell contents cleared correctly when using GroupSummary + ResourceInfo column combo, see Row#renderCell for comments');
              });

            case 4:
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