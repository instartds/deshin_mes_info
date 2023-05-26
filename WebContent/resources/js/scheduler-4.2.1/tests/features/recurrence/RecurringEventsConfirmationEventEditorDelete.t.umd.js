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
  // The test checks that clicking "Delete" button in event editor shows recurrence confirmation dialog
  // and assert the confirmation buttons
  var resourceStore, eventStore, scheduler, recurrenceConfirmationPopup, event1, event2, event3;

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(config) {
      var result;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
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
              result = _context2.sent;
              recurrenceConfirmationPopup = result.features.eventEdit.recurrenceConfirmation;
              return _context2.abrupt("return", result);

            case 5:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));
    return _getScheduler.apply(this, arguments);
  }

  function getRemovedRecords() {
    var store = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : eventStore;
    return store.removed.values;
  }

  function getConfirmationButtons() {
    return recurrenceConfirmationPopup.queryAll(function (w) {
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
              scheduler && !scheduler.isDestroyed && scheduler.destroy();
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
              _context.next = 10;
              return getScheduler();

            case 10:
              scheduler = _context.sent;
              t.diag('Initial state of data');
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences'); // Needed to make async beforeEach work in umd tests

              next();

            case 17:
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
  t.it('Confirmation shows up on recurring event deleting in event editor', function (t) {
    t.chain({
      diag: 'Assert recurring event editing'
    }, {
      doubleclick: '.sch-event2'
    }, {
      waitForElementVisible: '.b-eventeditor',
      desc: 'Event editor showed up'
    }, {
      click: 'button:contains(Delete)',
      desc: '"Delete" clicked'
    }, {
      waitForElementVisible: '.b-sch-recurrenceconfirmation',
      desc: 'Confirmation showed up'
    }, function (next) {
      var buttons = getConfirmationButtons();
      t.is(buttons.length, 2, '2 visible buttons found');
      t.is(buttons[0].text, 'Yes', '"Yes" button found');
      t.is(buttons[1].text, 'Cancel', '"Cancel" button found');
      next();
    }, {
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
    }, function (next) {
      t.diag('Make sure data is intact');
      t.isDeeply(eventStore.modified.values, [], 'store has correct number of records');
      t.is(eventStore.count, 3, 'store has correct number of records');
      t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
      t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
      t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
      next();
    }, {
      diag: 'Assert occurrence editing'
    }, {
      doubleclick: '.sch-event3.b-occurrence'
    }, {
      waitForElementVisible: '.b-eventeditor',
      desc: 'Event editor showed up'
    }, {
      click: 'button:contains(Delete)',
      desc: '"Delete" clicked'
    }, {
      waitForElementVisible: '.b-sch-recurrenceconfirmation',
      desc: 'Confirmation showed up'
    }, function (next) {
      var buttons = getConfirmationButtons();
      t.is(buttons.length, 3, '3 visible buttons found');
      t.is(buttons[0].text, 'Delete All Future Events', '"All Future Events" button found');
      t.is(buttons[1].text, 'Delete Only This Event', '"Only This Event" button found');
      t.is(buttons[2].text, 'Cancel', '"Cancel" button found');
      next();
    }, {
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
    }, function (next) {
      t.diag('Make sure data is intact');
      t.isDeeply(eventStore.modified.values, [], 'store has correct number of records');
      t.is(eventStore.count, 3, 'store has correct number of records');
      t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
      t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
      t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
      next();
    }, {
      diag: 'Assert non recurring event editing'
    }, {
      doubleclick: '.sch-event1'
    }, {
      waitForElementVisible: '.b-eventeditor',
      desc: 'Event editor showed up'
    }, {
      click: 'button:contains(Delete)',
      desc: '"Delete" clicked'
    }, {
      waitFor: 1000,
      desc: 'Waited for some long enough timeout to make sure that confirmation never appear'
    }, function () {
      // TODO: report to Siesta
      // t.elementIsNotVisible('.b-sch-recurrenceconfirmation', 'Confirmation did not show up');
      t.selectorNotExists('.b-sch-recurrenceconfirmation:not(.b-hidden)', 'Confirmation did not show up');
      t.isDeeply(getRemovedRecords(), [event1], 'event 1 was removed');
      t.is(eventStore.count, 2, 'store has correct number of records');
      t.notOk(eventStore.getById(1), 'no event 1');
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
      click: 'button:contains(Delete)',
      desc: '"Delete" clicked'
    }, {
      waitForElementVisible: '.b-sch-recurrenceconfirmation',
      desc: 'Confirmation showed up'
    }, function (next) {
      t.waitForEvent(eventStore, 'remove', next);
      t.click('button:contains(Yes)');
    }, function () {
      t.isDeeply(eventStore.removed.values, [event2], 'proper removed bag');
      t.is(eventStore.count, 2, 'store has correct number of records');
      t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
      t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
    });
  });
  t.it('"Delete All Future Events" button click causes further occurrences removal', function (t) {
    var event3Occurrences = event3.occurrences,
        occurrence = event3Occurrences[1],
        startDate = occurrence.startDate;
    t.chain({
      doubleclick: function doubleclick() {
        return scheduler.getElementFromEventRecord(occurrence);
      }
    }, {
      waitForElementVisible: '.b-eventeditor',
      desc: 'Event editor showed up'
    }, {
      click: 'button:contains(Delete)',
      desc: '"Delete" clicked'
    }, {
      waitForElementVisible: '.b-sch-recurrenceconfirmation',
      desc: 'Confirmation showed up'
    }, {
      click: 'button:contains(Delete All Future Events)'
    }, {
      waitForSelectorNotFound: '.b-eventeditor',
      desc: 'Event editor closed'
    }, function () {
      t.isDeeply(_toConsumableArray(eventStore.modified), [event3], 'proper modified bag');
      t.is(eventStore.count, 3, 'store has correct number of records');
      t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
      t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
      t.is(event3.occurrences.length, 1, 'event 3 has 3 occurrences');
      t.ok(event3.endDate < startDate, 'event 3 recurrence stops before the "occurrence" started');
    });
  });
  t.it('"Delete Only This Event" button click works properly', function (t) {
    var event3Occurrences = event3.occurrences,
        occurrence = event3Occurrences[1],
        startDate = occurrence.startDate;
    t.chain({
      doubleclick: function doubleclick() {
        return scheduler.getElementFromEventRecord(occurrence);
      }
    }, {
      waitForElementVisible: '.b-eventeditor',
      desc: 'Event editor showed up'
    }, {
      click: 'button:contains(Delete)',
      desc: '"Delete" clicked'
    }, {
      waitForElementVisible: '.b-sch-recurrenceconfirmation',
      desc: 'Confirmation showed up'
    }, {
      click: 'button:contains(Delete Only This Event)'
    }, {
      waitForSelectorNotFound: '.b-eventeditor',
      desc: 'Event editor closed'
    }, function () {
      t.isDeeplyUnordered(_toConsumableArray(eventStore.modified), [event3], 'proper modified bag');
      t.is(eventStore.count, 3, 'store has correct number of records');
      t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
      t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
      t.ok(event3.hasException(startDate), 'event 3 has "occurrence" start date in the exception dates list');
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