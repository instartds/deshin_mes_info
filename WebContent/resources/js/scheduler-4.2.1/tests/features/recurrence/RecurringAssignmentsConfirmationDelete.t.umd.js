function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });
  t.it('Should remove occurrences when assignmentStore is used', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var event, occurrenceId;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                enableRecurringEvents: true,
                events: [{
                  id: 1,
                  startDate: '2011-01-03 12:00',
                  endDate: '2011-01-03 18:00',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
                  cls: 'event1'
                }],
                assignments: [{
                  id: 1,
                  resourceId: 'r1',
                  eventId: 1
                }]
              });

            case 2:
              scheduler = _context.sent;
              event = scheduler.eventStore.first, occurrenceId = event.occurrences[1].id;
              t.chain({
                click: "[data-event-id=\"".concat(occurrenceId, "\"]")
              }, {
                type: '[DELETE]'
              }, {
                click: '.b-popup button:contains(Only)'
              }, {
                waitForSelectorNotFound: "".concat(scheduler.unreleasedEventSelector, "[data-event-id=\"").concat(occurrenceId, "\"]"),
                desc: 'Occurrence removed'
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
  t.it('Should handle deleting a mix of occurrences and regular assignments', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getSchedulerAsync({
                enableRecurringEvents: true,
                multiEventSelect: true,
                events: [{
                  id: 1,
                  startDate: '2011-01-03 12:00',
                  endDate: '2011-01-03 18:00',
                  cls: 'event1'
                }, {
                  id: 2,
                  startDate: '2011-01-03 12:00',
                  endDate: '2011-01-03 18:00',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
                  cls: 'event2'
                }, {
                  id: 3,
                  startDate: '2011-01-03 12:00',
                  endDate: '2011-01-03 18:00',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=2',
                  cls: 'event3'
                }],
                assignments: [{
                  id: 1,
                  resourceId: 'r1',
                  eventId: 1
                }, {
                  id: 2,
                  resourceId: 'r2',
                  eventId: 2
                }, {
                  id: 3,
                  resourceId: 'r3',
                  eventId: 3
                }]
              });

            case 2:
              scheduler = _context2.sent;
              _context2.next = 5;
              return t.click('.event1');

            case 5:
              _context2.next = 7;
              return t.click('.event2', null, null, {
                ctrlKey: true
              });

            case 7:
              _context2.next = 9;
              return t.click('.event3', null, null, {
                ctrlKey: true
              });

            case 9:
              scheduler.removeEvents(scheduler.selectedAssignments);
              _context2.next = 12;
              return t.click('button:contains(Yes)');

            case 12:
              _context2.next = 14;
              return t.waitForSelectorNotFound('.b-sch-recurrenceconfirmation');

            case 14:
              _context2.next = 16;
              return t.waitForSelectorNotFound('.b-sch-event1, .b-sch-event2, .b-sch-event3');

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