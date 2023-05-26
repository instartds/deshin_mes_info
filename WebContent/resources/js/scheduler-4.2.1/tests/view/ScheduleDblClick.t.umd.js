function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    return scheduler && scheduler.destroy();
  });
  t.it('Should create event and show event editor', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: true
                },
                viewPreset: 'hourAndDay',
                startDate: new Date(2018, 2, 1, 8),
                endDate: new Date(2018, 2, 1, 19)
              });

            case 2:
              scheduler = _context.sent;
              t.chain({
                dblClick: '.b-timeline-subgrid .b-grid-cell',
                offset: ['50%+1', '50%']
              }, {
                waitForSelector: '.b-sch-dirty-new',
                desc: 'Event element created'
              }, {
                waitForSelector: '.b-eventeditor',
                desc: 'Editor shown'
              }, {
                waitForSelectorNotFound: '.b-sch-event-tooltip',
                desc: 'event tooltip not triggered'
              }, function (next) {
                t.selectorNotExists('.b-sch-event-tooltip', 'event tooltip not triggered');
                var record = scheduler.features.eventEdit.eventRecord;
                t.is(record.startDate, new Date(2018, 2, 1, 13, 30), 'Start date is correct');
                t.is(record.endDate, new Date(2018, 2, 1, 14, 30), 'End date is correct');
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
  t.it('Should create event but should not show event editor if no editors specified', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: false
                },
                viewPreset: 'hourAndDay',
                startDate: new Date(2018, 2, 1, 8),
                endDate: new Date(2018, 2, 1, 19)
              });

            case 2:
              scheduler = _context2.sent;
              t.chain({
                dblClick: '.b-timeline-subgrid .b-grid-cell'
              }, {
                waitForSelector: '.b-sch-event',
                desc: 'Event created'
              }, {
                waitForSelectorNotFound: '.b-eventeditor',
                desc: 'Editor not shown'
              });

            case 4:
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
  t.it('Should not create event and show event editor if scheduler in read only mode', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: true
                },
                readOnly: true,
                viewPreset: 'hourAndDay',
                startDate: new Date(2018, 2, 1, 8),
                endDate: new Date(2018, 2, 1, 19)
              });

            case 2:
              scheduler = _context3.sent;
              t.chain({
                dblClick: '.b-timeline-subgrid .b-grid-cell'
              }, {
                waitForSelectorNotFound: '.b-sch-dirty-new',
                desc: 'New event element not created'
              }, {
                waitForSelectorNotFound: '.b-eventeditor',
                desc: 'Editor not shown'
              });

            case 4:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should not create event and show event editor if this option is turned off', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: true
                },
                readOnly: false,
                createEventOnDblClick: false,
                viewPreset: 'hourAndDay',
                startDate: new Date(2018, 2, 1, 8),
                endDate: new Date(2018, 2, 1, 19)
              });

            case 2:
              scheduler = _context4.sent;
              t.chain({
                dblClick: '.b-timeline-subgrid .b-grid-cell'
              }, {
                waitForSelectorNotFound: '.b-sch-dirty-new',
                desc: 'Event element not created'
              }, {
                waitForSelectorNotFound: '.b-eventeditor',
                desc: 'Editor not shown'
              });

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }());
});