function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

StartTest(function (t) {
  var resourceStore, eventStore, scheduler, recurrenceConfirmationPopup, event1, event2, event3;

  function getConfirmationButtons() {
    return recurrenceConfirmationPopup.queryAll(function (w) {
      return w.type === 'button' && w.isVisible;
    });
  }

  t.beforeEach(function () {
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
    var _eventStore = eventStore;

    var _eventStore2 = _slicedToArray(_eventStore, 3);

    event1 = _eventStore2[0];
    event2 = _eventStore2[1];
    event3 = _eventStore2[2];
  });

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(config) {
      var result;
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return t.getSchedulerAsync(Object.assign({
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25),
                renderTo: document.body,
                enableRecurringEvents: true,
                features: {
                  eventTooltip: false
                },
                resourceStore: resourceStore,
                eventStore: eventStore
              }, config));

            case 2:
              result = _context9.sent;
              recurrenceConfirmationPopup = result.recurrenceConfirmationPopup;
              return _context9.abrupt("return", result);

            case 5:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('Confirmation shows up on recurring event or its occurrence resize', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context5.sent;
              t.diag('Initial state of data');
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
              t.chain({
                moveCursorTo: '.sch-event2'
              }, {
                drag: '.sch-event2',
                offset: ['100%-3', '50%'],
                by: [100, 0]
              }, {
                waitForSelector: '.b-sch-recurrenceconfirmation:not(.b-hidden)',
                desc: 'Confirmation showed up'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                var buttons;
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        buttons = getConfirmationButtons();
                        t.is(buttons.length, 2, '2 visible buttons found');
                        t.is(buttons[0].text, 'Yes', '"Yes" button found');
                        t.is(buttons[1].text, 'Cancel', '"Cancel" button found');

                      case 4:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })), {
                moveMouseTo: 'button:contains(Cancel)'
              }, {
                click: 'button:contains(Cancel)',
                desc: 'Clicked "Cancel"'
              }, {
                waitForSelectorNotFound: '.b-sch-recurrenceconfirmation:not(.b-hidden)'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        t.diag('Make sure data is intact');
                        t.isDeeply(eventStore.modified.values, [], 'store has correct number of records');
                        t.is(eventStore.count, 3, 'store has correct number of records');
                        t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
                        t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
                        t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');

                      case 6:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              })), {
                moveCursorTo: '.b-occurrence'
              }, {
                drag: '.b-occurrence',
                offset: ['100%-3', '50%'],
                by: [100, 0]
              }, {
                waitForSelector: '.b-sch-recurrenceconfirmation:not(.b-hidden)',
                desc: 'Confirmation showed up'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                var buttons;
                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        buttons = getConfirmationButtons();
                        t.is(buttons.length, 3, '3 visible buttons found');
                        t.is(buttons[0].text, 'All Future Events', '"All Future Events" button found');
                        t.is(buttons[1].text, 'Only This Event', '"Only This Event" button found');
                        t.is(buttons[2].text, 'Cancel', '"Cancel" button found');

                      case 5:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3);
              })), {
                click: 'button:contains(Cancel)',
                desc: 'Clicked "Cancel"'
              }, {
                waitForSelectorNotFound: '.b-sch-recurrenceconfirmation:not(.b-hidden)'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
                return regeneratorRuntime.wrap(function _callee4$(_context4) {
                  while (1) {
                    switch (_context4.prev = _context4.next) {
                      case 0:
                        t.diag('Make sure data is intact');
                        t.isDeeply(eventStore.modified.values, [], 'store has correct number of records');
                        t.is(eventStore.count, 3, 'store has correct number of records');
                        t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
                        t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
                        t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');

                      case 6:
                      case "end":
                        return _context4.stop();
                    }
                  }
                }, _callee4);
              })), {
                moveCursorTo: '.sch-event1',
                desc: 'Moved cursor over the event #1 (not recurring one)'
              }, {
                drag: '.sch-event1',
                offset: ['100%-3', '50%'],
                by: [100, 0]
              }, {
                waitFor: 1000,
                desc: 'Waited for some long enough timeout to make sure that confirmation never appear'
              }, function () {
                t.selectorNotExists('.b-sch-recurrenceconfirmation:not(.b-hidden)', 'Confirmation has not showed up');
                t.isDeeply(_toConsumableArray(eventStore.modified), [event1], 'proper modified bag');
                t.is(eventStore.count, 3, 'store has correct number of records');
                t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
                t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
                t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
              });

            case 9:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x2) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('"Yes" button click causes occurrences regeneration', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context6.sent;
              t.diag('Initial state of data');
              t.isDeeply(eventStore.modified.values, [], 'no modified records');
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
              t.chain({
                moveCursorTo: '.sch-event2'
              }, {
                drag: '.sch-event2',
                offset: ['100%-3', '50%'],
                by: [100, 0]
              }, {
                waitForSelector: '.b-sch-recurrenceconfirmation:not(.b-hidden)',
                desc: 'Confirmation showed up'
              }, {
                click: 'button:contains(Yes)'
              }, {
                waitFor: function waitFor() {
                  return eventStore.modified.count === 1 && eventStore.modified.values[0] === event2;
                },
                desc: 'event 2 was modified'
              }, function () {
                t.isDeeply(_toConsumableArray(eventStore.modified), [event2], 'event 2 was resized and its occurrence was rebuilt in turn');
                t.is(eventStore.count, 3, 'store has correct number of records');
                t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
                t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
                t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
              });

            case 10:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x3) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('"All Future Events" button click causes further occurrences regeneration', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var occurrence, occurrenceEl;
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context7.sent;
              t.diag('Initial state of data');
              t.isDeeply(eventStore.modified.values, [], 'no modified records');
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
              occurrence = event3.occurrences[2], occurrenceEl = scheduler.getElementFromEventRecord(occurrence);
              t.chain({
                moveCursorTo: function moveCursorTo() {
                  return occurrenceEl;
                }
              }, {
                drag: function drag() {
                  return occurrenceEl;
                },
                offset: ['100%-3', '50%'],
                by: [-50, 0]
              }, {
                waitForSelector: '.b-sch-recurrenceconfirmation:not(.b-hidden)',
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
                t.isDeeply(_toConsumableArray(eventStore.added), [occurrence], 'proper added bag');
                t.isDeeply(_toConsumableArray(eventStore.modified), [event3], 'proper modified bag');
                t.is(eventStore.count, 4, 'store has correct number of records');
                t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
                t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
                t.is(event3.occurrences.length, 2, 'event 3 has 2 occurrences');
                t.ok(event3.endDate < occurrence.startDate, 'event 3 recurrence stops before the "occurrence" starts');
                t.ok(event3.occurrences[1].endDate < occurrence.startDate, 'The last occurrence of "event 3" stops before the "occurrence" starts');
                t.is(occurrence.occurrences.length, 2, '"occurrence" has 2 occurrences');
              });

            case 11:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x4) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('"Only This Event" button click works properly', function (t) {
    var occurrenceEl, occurrence;
    t.chain( // to avoid scrolling while resizing events
    {
      setWindowSize: [1600, 500]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8() {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return getScheduler({
                width: 1500
              });

            case 2:
              scheduler = _context8.sent;

            case 3:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    })), function (next) {
      t.diag('Initial state of data');
      t.isDeeply(eventStore.modified.values, [], 'no modified records');
      t.is(eventStore.count, 3, 'store has correct number of records');
      t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
      t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
      t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
      occurrence = event3.occurrences[2];
      occurrenceEl = scheduler.getElementsFromEventRecord(occurrence)[0];
      next();
    }, {
      moveCursorTo: function moveCursorTo() {
        return occurrenceEl;
      }
    }, {
      drag: function drag() {
        return occurrenceEl;
      },
      offset: ['100%-3', '50%'],
      by: [100, 0]
    }, {
      waitForSelector: '.b-sch-recurrenceconfirmation:not(.b-hidden)',
      desc: 'Confirmation showed up'
    }, {
      click: 'button:contains(Only This Event)'
    }, {
      waitForSelectorNotFound: '.b-sch-recurrenceconfirmation:not(.b-hidden)',
      desc: 'Confirmation hidden'
    }, function () {
      t.notOk(occurrence.isOccurrence, '"occurrence" is no longer an occurrence');
      t.notOk(occurrence.isRecurring, '"occurrence" is not a recurring event');
      t.is(occurrence.endDate, new Date(2018, 5, 22), '"occurrence" end date is correct');
      t.isDeeply(eventStore.modified.values, [event3], 'proper modified bag');
      t.isDeeply(eventStore.added.values, [occurrence], 'proper added bag');
      t.is(eventStore.count, 4, 'store has correct number of records');
      t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
      t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
      t.ok(event3.hasException(occurrence.startDate), 'event 3 has "occurrence" start date in the exception dates list');
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
        start: new Date(2018, 5, 18),
        end: new Date(2018, 5, 19)
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