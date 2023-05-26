function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && !scheduler.isDestroyed && scheduler.destroy();
  });
  t.it('TimeAxis header should render correctly after a long, animated scroll', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var f, l;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              PresetManager.registerPreset('dayNightShift', {
                name: 'Day/night shift (custom)',
                tickWidth: 35,
                rowHeight: 32,
                displayDateFormat: 'HH:mm',
                shiftIncrement: 1,
                shiftUnit: 'day',
                timeResolution: {
                  unit: 'minute',
                  increment: 15
                },
                defaultSpan: 24,
                mainHeaderLevel: 1,
                headers: [{
                  unit: 'day',
                  increment: 1,
                  dateFormat: 'MMMM Do YYYY'
                }, {
                  unit: 'hour',
                  increment: 12,
                  renderer: function renderer(startDate, endDate, headerConfig, cellIdx) {
                    if (startDate.getHours() === 0) {
                      // Setting a custom CSS on the header cell element
                      headerConfig.headerCellCls = 'b-fa b-fa-moon';
                      return DateHelper.format(startDate, 'MMM DD') + ' Night Shift';
                    } else {
                      // Setting a custom CSS on the header cell element
                      headerConfig.headerCellCls = 'b-fa b-fa-sun';
                      return DateHelper.format(startDate, 'MMM DD') + ' Day Shift';
                    }
                  }
                }, {
                  unit: 'hour',
                  increment: 1,
                  dateFormat: 'H'
                }]
              });
              _context3.next = 3;
              return t.getSchedulerAsync({
                viewPreset: 'dayNightShift',
                startDate: new Date(2019, 0, 1),
                endDate: new Date(2019, 0, 6),
                appendTo: document.body,
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Meeting #1',
                  cls: 'event1',
                  startDate: new Date(2019, 0, 1, 8),
                  endDate: new Date(2019, 0, 1, 24)
                }, {
                  id: 2,
                  resourceId: 'r1',
                  name: 'Meeting #2',
                  cls: 'event2',
                  startDate: new Date(2019, 0, 5, 0),
                  endDate: new Date(2019, 0, 5, 17)
                }]
              });

            case 3:
              scheduler = _context3.sent;
              f = scheduler.assignmentStore.first, l = scheduler.assignmentStore.last;
              t.chain({
                waitForRowsVisible: scheduler
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        _context.next = 2;
                        return scheduler.navigateTo(l);

                      case 2:
                        return _context.abrupt("return", _context.sent);

                      case 3:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })), /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        t.is(scheduler.activeAssignment, l, 'Navigation worked');
                        t.is(Rectangle.from(scheduler.getElementFromAssignmentRecord(l, true)).roundPx().right, Rectangle.from(scheduler.timeAxisSubGridElement).right - 20, 'Scrolled with correct 20px edgeOffset');
                        _context2.next = 4;
                        return scheduler.navigateTo(f);

                      case 4:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              })), {
                waitForEvent: [scheduler.navigator, 'navigate'],
                trigger: function trigger() {
                  return scheduler.navigateTo(f);
                }
              }, function () {
                t.is(scheduler.activeAssignment, f, 'Navigation worked');
                t.is(Rectangle.from(scheduler.getElementFromAssignmentRecord(f, true)).roundPx().left, Rectangle.from(scheduler.timeAxisSubGridElement).left + 20, 'Scrolled with correct 20px edgeOffset');
                var cell = document.elementFromPoint(285, 55).closest('.b-sch-header-timeaxis-cell');
                t.ok(cell.classList.contains('b-sch-header-timeaxis-cell'), 'Cell in place');
                t.is(cell.textContent, '12', 'Cell content correct');
              });

            case 6:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
});