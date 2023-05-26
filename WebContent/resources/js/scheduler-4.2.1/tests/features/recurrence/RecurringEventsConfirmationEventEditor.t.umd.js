function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  // The test checks that clicking "Save" button in event editor shows recurrence confirmation dialog
  // and assert the confirmation buttons
  var resourceStore, eventStore, scheduler, confirmationPopup, event1, event2, event3;

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(config) {
      var result;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getSchedulerAsync(Object.assign({
                resourceStore: resourceStore,
                eventStore: eventStore,
                enableRecurringEvents: true,
                features: {
                  eventTooltip: false,
                  eventEdit: true // is enabled by default already, but in case we change our minds...

                },
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25),
                appendTo: document.body
              }, config));

            case 2:
              result = _context6.sent;
              return _context6.abrupt("return", result);

            case 4:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));
    return _getScheduler.apply(this, arguments);
  }

  function getConfirmationButtons() {
    if (!confirmationPopup) {
      confirmationPopup = scheduler.features.eventEdit.recurrenceConfirmation;
    }

    return confirmationPopup.queryAll(function (w) {
      return w.type === 'button' && w.isVisible;
    });
  }

  t.beforeEach( /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t, next) {
      var _eventStore, _eventStore2;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              Base.destroy(scheduler);
              resourceStore = new ResourceStore({
                data: [{
                  id: 'r1'
                }]
              });
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Foo',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  cls: 'sch-event1'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  name: 'Bar',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1',
                  cls: 'sch-event2'
                }, {
                  id: 3,
                  resourceId: 'r1',
                  name: 'Baz',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=2',
                  cls: 'sch-event3'
                }]
              });
              _eventStore = eventStore;
              _eventStore2 = _slicedToArray(_eventStore, 3);
              event1 = _eventStore2[0];
              event2 = _eventStore2[1];
              event3 = _eventStore2[2];
              t.diag('Initial state of data');
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.notOk(event2.occurrences.length, 'event 2 has no occurrence');
              t.notOk(event3.occurrences.length, 'event 3 has no occurrences');
              _context.next = 15;
              return getScheduler();

            case 15:
              scheduler = _context.sent;
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences'); // Needed to make async beforeEach work in umd tests

              next();

            case 21:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x2, _x3) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Confirmation shows up on recurring event editing in event editor', function (t) {
    t.chain({
      diag: 'Assert recurring event editing'
    }, {
      doubleclick: '.sch-event2'
    }, {
      waitForElementVisible: '.b-eventeditor',
      desc: 'Event editor showed up'
    }, {
      type: '06/15/2018',
      target: 'input[name=startDate]',
      clearExisting: true
    }, {
      click: 'input[name=endDate]'
    }, {
      type: '06/16/2018',
      target: 'input[name=endDate]',
      clearExisting: true
    }, {
      click: 'button:contains(Save)',
      desc: '"Save" clicked'
    }, {
      waitForElementVisible: '.b-sch-recurrenceconfirmation',
      desc: 'Confirmation showed up'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      var buttons;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              buttons = getConfirmationButtons();
              t.is(buttons.length, 2, '2 visible buttons found');
              t.is(buttons[0].text, 'Yes', '"Yes" button found');
              t.is(buttons[1].text, 'Cancel', '"Cancel" button found');

            case 4:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    })), {
      click: '.b-sch-recurrenceconfirmation button:contains(Cancel)',
      desc: 'Clicked "Cancel"'
    }, {
      waitFor: function waitFor() {
        return !t.$('.b-sch-recurrenceconfirmation')[0];
      },
      desc: 'Confirmation closed'
    }, {
      click: 'button:contains(Cancel)'
    }, {
      waitFor: function waitFor() {
        return !t.$('.b-eventeditor')[0];
      },
      desc: 'Event editor closed'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              t.diag('Make sure data is intact');
              t.isDeeply(eventStore.modified.values, [], 'store has correct number of records');
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');

            case 6:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    })), {
      diag: 'Assert occurrence editing'
    }, {
      doubleclick: '.sch-event3.b-occurrence'
    }, {
      waitForElementVisible: '.b-eventeditor',
      desc: 'Event editor showed up'
    }, {
      type: '06/15/2018',
      target: 'input[name=startDate]',
      clearExisting: true
    }, {
      click: 'input[name=endDate]'
    }, {
      type: '06/16/2018',
      target: 'input[name=endDate]',
      clearExisting: true
    }, {
      click: 'button:contains(Save)',
      desc: '"Save" clicked'
    }, {
      waitForElementVisible: '.b-sch-recurrenceconfirmation',
      desc: 'Confirmation showed up'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
      var buttons;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              buttons = getConfirmationButtons();
              t.is(buttons.length, 3, '3 visible buttons found');
              t.is(buttons[0].text, 'All Future Events', '"All Future Events" button found');
              t.is(buttons[1].text, 'Only This Event', '"Only This Event" button found');
              t.is(buttons[2].text, 'Cancel', '"Cancel" button found');

            case 5:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    })), {
      click: '.b-sch-recurrenceconfirmation button:contains(Cancel)',
      desc: 'Clicked "Cancel"'
    }, {
      waitFor: function waitFor() {
        return !t.$('.b-sch-recurrenceconfirmation')[0];
      },
      desc: 'Confirmation closed'
    }, {
      click: 'button:contains(Cancel)'
    }, {
      waitFor: function waitFor() {
        return !t.$('.b-eventeditor')[0];
      },
      desc: 'Event editor closed'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              t.diag('Make sure data is intact');
              t.isDeeply(eventStore.modified.values, [], 'store has correct number of records');
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');

            case 6:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    })), {
      diag: 'Assert non recurring event editing'
    }, {
      doubleclick: '.sch-event1'
    }, {
      waitForElementVisible: '.b-eventeditor',
      desc: 'Event editor showed up'
    }, {
      type: '06/15/2018',
      target: 'input[name=startDate]',
      clearExisting: true
    }, {
      click: 'input[name=endDate]'
    }, {
      type: '06/16/2018',
      target: 'input[name=endDate]',
      clearExisting: true
    }, {
      click: 'button:contains(Save)',
      desc: '"Save" clicked'
    }, {
      waitFor: 1000,
      desc: 'Waited for some long enough timeout to make sure that confirmation didn`t appear'
    }, function () {
      t.selectorNotExists('.b-sch-recurrenceconfirmation:not(.b-hidden)', 'Confirmation did not show up');
      t.isDeeply(_toConsumableArray(eventStore.modified), [event1], 'event 1 was resized');
      t.is(eventStore.count, 3, 'store has correct number of records');
      t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
      t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
      t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
    });
  });
  t.it('"Yes" button click causes occurrences regeneration', function (t) {
    t.chain({
      doubleclick: '.sch-event2'
    }, {
      waitForElementVisible: '.b-eventeditor',
      desc: 'Event editor showed up'
    }, {
      type: '06/15/2018',
      target: 'input[name=startDate]',
      clearExisting: true
    }, {
      click: 'input[name=endDate]'
    }, {
      type: '06/16/2018',
      target: 'input[name=endDate]',
      clearExisting: true
    }, {
      click: 'button:contains(Save)',
      desc: '"Save" clicked'
    }, {
      waitForElementVisible: '.b-sch-recurrenceconfirmation',
      desc: 'Confirmation showed up'
    }, {
      click: 'button:contains(Yes)'
    }, {
      waitFor: function waitFor() {
        return !(event2.startDate - new Date(2018, 5, 15));
      },
      desc: 'event 2 moved'
    }, function () {
      t.is(event2.startDate, new Date(2018, 5, 15), 'event 2 moved');
      t.is(event2.occurrences[0].startDate, new Date(2018, 5, 22), 'event 2 occurrence moved');
      t.isDeeplyUnordered(_toConsumableArray(eventStore.modified), [event2], 'proper set of modified records');
      t.is(eventStore.count, 3, 'store has correct number of records');
      t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
      t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
      t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
    });
  });
  t.it('"All Future Events" button click causes further occurrences regeneration', function (t) {
    var occurrence = event3.occurrences[1];
    t.chain({
      doubleclick: function doubleclick() {
        return scheduler.getElementFromEventRecord(occurrence);
      }
    }, {
      waitForElementVisible: '.b-eventeditor',
      desc: 'Event editor showed up'
    }, {
      type: '06/19/2018',
      target: 'input[name=startDate]',
      clearExisting: true
    }, {
      click: 'input[name=endDate]'
    }, {
      type: '06/20/2018',
      target: 'input[name=endDate]',
      clearExisting: true
    }, {
      click: 'button:contains(Save)',
      desc: '"Save" clicked'
    }, {
      waitForElementVisible: '.b-sch-recurrenceconfirmation',
      desc: 'Confirmation showed up'
    }, {
      click: 'button:contains(All Future Events)'
    }, {
      waitFor: function waitFor() {
        return !occurrence.isOccurrence;
      },
      desc: '"occurrence" is no longer an occurrence'
    }, function () {
      t.notOk(occurrence.isOccurrence, '"occurrence" is no longer an occurrence');
      t.ok(occurrence.isRecurring, '"occurrence" is a new independent recurring event');
      t.isDeeply(_toConsumableArray(eventStore.modified), [event3], 'proper modified bag');
      t.isDeeply(_toConsumableArray(eventStore.added), [occurrence], '"occurrence" is considered as added because it has been turned into master event and has a generated ID');
      t.is(eventStore.count, 4, 'store has correct number of records');
      t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
      t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
      t.is(event3.occurrences.length, 1, 'event 3 has 3 occurrences');
      t.ok(event3.endDate < occurrence.startDate, 'event 3 recurrence stops before the "occurrence" starts');
      t.is(occurrence.occurrences.length, 3, '"occurrence" has 2 occurrences');
      t.is(occurrence.startDate, new Date(2018, 5, 19), '"occurrence" has correct start date');
      t.is(occurrence.occurrences[0].startDate, new Date(2018, 5, 21), '"occurrence" occurrence 0 has correct start date');
      t.is(occurrence.occurrences[1].startDate, new Date(2018, 5, 23), '"occurrence" occurrence 1 has correct start date');
      t.is(occurrence.occurrences[2].startDate, new Date(2018, 5, 25), '"occurrence" occurrence 1 has correct start date');
    });
  });
  t.it('"Only This Event" button click works properly', function (t) {
    var occurrence = event3.occurrences[1],
        occurrenceStartDate = occurrence.startDate;
    t.chain({
      doubleclick: function doubleclick() {
        return scheduler.getElementFromEventRecord(occurrence);
      }
    }, {
      waitForElementVisible: '.b-eventeditor',
      desc: 'Event editor showed up'
    }, {
      type: '06/19/2018',
      target: 'input[name=startDate]',
      clearExisting: true
    }, {
      click: 'input[name=endDate]'
    }, {
      type: '06/20/2018',
      target: 'input[name=endDate]',
      clearExisting: true
    }, {
      click: 'button:contains(Save)',
      desc: '"Save" clicked'
    }, {
      waitForElementVisible: '.b-sch-recurrenceconfirmation',
      desc: 'Confirmation showed up'
    }, {
      click: 'button:contains(Only This Event)'
    }, {
      waitFor: function waitFor() {
        return !occurrence.isOccurrence;
      },
      desc: '"occurrence" is no longer an occurrence'
    }, {
      waitFor: function waitFor() {
        return event3.occurrences[0].endDate.getTime() === new Date(2018, 5, 17).getTime();
      }
    }, function () {
      t.notOk(occurrence.isOccurrence, '"occurrence" is no longer an occurrence');
      t.notOk(occurrence.isRecurring, '"occurrence" is not a recurring event');
      t.is(occurrence.startDate, new Date(2018, 5, 19), '"occurrence" start date is correct');
      t.isDeeply(_toConsumableArray(eventStore.modified), [event3], 'proper modified bag');
      t.isDeeply(_toConsumableArray(eventStore.added), [occurrence], '"occurrence" is considered as added because it has been turned into master event and has a generated ID');
      t.is(eventStore.count, 4, 'store has correct number of records');
      t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
      t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
      t.ok(event3.hasException(occurrenceStartDate), 'event 3 has "occurrence" start date in the exception dates list');
      var occurrencesDates = event3.occurrences.map(function (occurrence) {
        return {
          start: occurrence.startDate,
          end: occurrence.endDate
        };
      });
      t.isDeeply(occurrencesDates, [{
        start: new Date(2018, 5, 16),
        end: new Date(2018, 5, 17)
      }, {
        start: new Date(2018, 5, 20),
        end: new Date(2018, 5, 21)
      }, {
        start: new Date(2018, 5, 22),
        end: new Date(2018, 5, 23)
      }, {
        start: new Date(2018, 5, 24),
        end: new Date(2018, 5, 25)
      }], 'event 3 occurrences dates are correct');
    });
  });
});