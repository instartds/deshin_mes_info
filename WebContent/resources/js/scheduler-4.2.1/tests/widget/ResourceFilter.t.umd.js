function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  Object.assign(window, {
    Scheduler: Scheduler,
    EventStore: EventStore,
    ResourceStore: ResourceStore,
    PresetManager: PresetManager
  });
  var scheduler, filter;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
    filter && filter.destroy();
    scheduler = t.getScheduler({
      height: 200
    });
  });
  t.it('Should filter eventStore when toggling list items', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              filter = new ResourceFilter({
                eventStore: scheduler.eventStore,
                appendTo: document.body
              });
              _context.next = 3;
              return t.click('.b-resourcefilter .b-list-item:contains(Mike)');

            case 3:
              _context.next = 5;
              return t.waitForSelectorNotFound("".concat(scheduler.unreleasedEventSelector, ":contains(Assignment 1)"));

            case 5:
              t.ok(scheduler.eventStore.isFiltered);
              _context.next = 8;
              return t.click('.b-resourcefilter .b-list-item:contains(Mike)');

            case 8:
              _context.next = 10;
              return t.waitForSelector("".concat(scheduler.unreleasedEventSelector, ":contains(Assignment 1)"));

            case 10:
              t.notOk(scheduler.eventStore.isFiltered);

            case 11:
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
  t.it('Should toggle all items if CTRL is pressed', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              filter = new ResourceFilter({
                eventStore: scheduler.eventStore,
                appendTo: document.body
              });
              _context2.next = 3;
              return t.click('.b-resourcefilter .b-list-item:contains(Mike)', null, null, {
                ctrlKey: true
              });

            case 3:
              _context2.next = 5;
              return t.waitForSelectorNotFound(".b-resourcefilter .b-list-item.b-selected");

            case 5:
              _context2.next = 7;
              return t.waitForSelectorNotFound(scheduler.unreleasedEventSelector);

            case 7:
              t.ok(scheduler.eventStore.isFiltered);
              _context2.next = 10;
              return t.click('.b-resourcefilter .b-list-item:contains(Mike)', null, null, {
                ctrlKey: true
              });

            case 10:
              _context2.next = 12;
              return t.waitForSelectorNotFound(".b-resourcefilter .b-list-item:not(.b-selected)");

            case 12:
              _context2.next = 14;
              return t.waitForSelector("".concat(scheduler.unreleasedEventSelector));

            case 14:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 5);
              t.notOk(scheduler.eventStore.isFiltered);

            case 16:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
});