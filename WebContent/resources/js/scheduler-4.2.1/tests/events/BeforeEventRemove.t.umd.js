function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  // https://github.com/bryntum/support/issues/1892
  t.it('Scheduler eventStore should fire beforeRemove event and cancel event removal', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var scheduler, eventCount, beforeRemoveCount;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = t.getScheduler({
                createEventOnDblClick: true,
                features: {
                  eventEdit: true
                }
              }), eventCount = scheduler.eventStore.records.length;
              beforeRemoveCount = 0;
              scheduler.eventStore.on('beforeRemove', function () {
                beforeRemoveCount++;
                return false;
              });
              _context.next = 5;
              return t.waitForEventsToRender();

            case 5:
              _context.next = 7;
              return t.rightClick('.b-sch-event');

            case 7:
              _context.next = 9;
              return t.click('.b-menuitem:contains(Delete event)');

            case 9:
              t.is(beforeRemoveCount, 1, 'beforeRemove fired once');
              t.is(scheduler.eventStore.records.length, eventCount, 'No events were removed');

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
});