function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, tickSize, event;
  document.body.style.width = '800px';

  function setup() {
    return _setup.apply(this, arguments);
  }

  function _setup() {
    _setup = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
      var config,
          _args3 = arguments;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              config = _args3.length > 0 && _args3[0] !== undefined ? _args3[0] : {};
              if (scheduler) scheduler.destroy();
              _context3.next = 4;
              return t.getSchedulerAsync(Object.assign({
                viewPreset: 'dayAndWeek',
                startDate: new Date(2010, 0, 6),
                endDate: new Date(2010, 2, 1),
                events: [{
                  id: 1,
                  name: 'Test event',
                  resourceId: 'r1',
                  startDate: new Date(2010, 0, 11),
                  endDate: new Date(2010, 0, 14)
                }],
                // TODO: PORT tree later
                resourceStore:
                /*config.__tree ? t.getResourceTreeStore() :*/
                t.getResourceStore(),
                features: {
                  eventDrag: {
                    showTooltip: false
                  }
                }
              }, config));

            case 4:
              scheduler = _context3.sent;
              scheduler.timeAxis.filterBy(function (tick) {
                return tick.startDate.getDay() !== 6 && tick.startDate.getDay() !== 0;
              });
              tickSize = scheduler.timeAxisViewModel.tickSize;
              event = scheduler.eventStore.first;

            case 8:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));
    return _setup.apply(this, arguments);
  }

  var getTestSteps = function getTestSteps(t) {
    return [function () {
      return scheduler.scrollEventIntoView(event);
    }, {
      drag: '.b-sch-event',
      by: function by() {
        return [-tickSize, 0];
      }
    }, function () {
      t.is(event.startDate, new Date(2010, 0, 8), "Event's start date has been changed according to the proxy element's position");
    }];
  }; // eof test steps


  t.it('Plain horizontal scheduler', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return setup();

            case 2:
              t.chain(getTestSteps(t));

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
  }()); //TODO: PORT tree later

  t.xit('Tree scheduler', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return setup({
                __tree: true
              });

            case 2:
              t.chain(getTestSteps(t));

            case 3:
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