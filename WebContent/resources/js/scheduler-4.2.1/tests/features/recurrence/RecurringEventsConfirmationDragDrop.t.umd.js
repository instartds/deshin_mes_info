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
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(config) {
      var scheduler;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              scheduler = t.getScheduler(Object.assign({
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25),
                enableRecurringEvents: true,
                features: {
                  eventTooltip: false
                },
                resourceStore: resourceStore,
                eventStore: eventStore
              }, config));
              recurrenceConfirmationPopup = scheduler.recurrenceConfirmationPopup;
              _context8.next = 4;
              return scheduler.project.commitAsync();

            case 4:
              return _context8.abrupt("return", scheduler);

            case 5:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('Confirmation shows up on recurring event or its occurrence drag`n`drop', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context.sent;
              t.chain(function (next) {
                t.diag('Initial state of data');
                t.notOk(eventStore.modified.values.length, 'store has no modified records');
                t.is(eventStore.count, 3, 'store has correct number of records');
                t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
                t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
                t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
                next();
              }, {
                drag: '.sch-event2',
                by: [100, 0]
              }, {
                waitForSelector: '.b-sch-recurrenceconfirmation:not(.b-hidden)',
                desc: 'Confirmation showed up'
              }, function (next) {
                var buttons = getConfirmationButtons();
                t.is(buttons.length, 2, '2 visible buttons found');
                t.is(buttons[0].text, 'Yes', '"Yes" button found');
                t.is(buttons[1].text, 'Cancel', '"Cancel" button found');
                next();
              }, {
                click: 'button:contains(Cancel)',
                desc: 'Clicked "Cancel"'
              }, {
                waitForSelectorNotFound: '.b-sch-recurrenceconfirmation:not(.b-hidden)'
              }, function (next) {
                t.diag('Make sure data is intact');
                t.notOk(eventStore.modified.values.length, 'store has correct number of records');
                t.is(eventStore.count, 3, 'store has correct number of records');
                t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
                t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
                t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
                next();
              }, {
                drag: '.sch-event3.b-occurrence',
                by: [100, 0]
              }, {
                waitForSelector: '.b-sch-recurrenceconfirmation:not(.b-hidden)',
                desc: 'Confirmation showed up'
              }, function (next) {
                var buttons = getConfirmationButtons();
                t.is(buttons.length, 3, '3 visible buttons found');
                t.is(buttons[0].text, 'All Future Events', '"All Future Events" button found');
                t.is(buttons[1].text, 'Only This Event', '"Only This Event" button found');
                t.is(buttons[2].text, 'Cancel', '"Cancel" button found');
                next();
              }, {
                click: 'button:contains(Cancel)',
                desc: 'Clicked "Cancel"'
              }, {
                waitForSelectorNotFound: '.b-sch-recurrenceconfirmation:not(.b-hidden)'
              }, function (next) {
                t.diag('Make sure data is intact');
                t.notOk(eventStore.modified.values.length, 'store has correct number of records');
                t.is(eventStore.count, 3, 'store has correct number of records');
                t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
                t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
                t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
                next();
              }, {
                drag: '.sch-event1',
                by: [100, 0]
              }, {
                waitFor: 1000,
                desc: 'Waited for some long enough timeout to make sure that confirmation never appear'
              }, function (next) {
                t.selectorNotExists('.b-sch-recurrenceconfirmation:not(.b-hidden)', 'Confirmation did not show up');
                t.isDeeply(eventStore.modified.values, [event1], 'event 1 was resized');
                t.is(eventStore.count, 3, 'store has correct number of records');
                t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
                t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
                t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
              });

            case 4:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x2) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('"Yes" button click causes occurrences regeneration', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context2.sent;
              t.chain(function (next) {
                t.diag('Initial state of data');
                t.notOk(eventStore.modified.values.length, 'no modified records');
                t.notOk(eventStore.added.count, 'no added records');
                t.notOk(eventStore.removed.count, 'no added records');
                t.is(eventStore.count, 3, 'store has correct number of records');
                t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
                t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
                t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
                next();
              }, {
                drag: '.sch-event2',
                by: [100, 0]
              }, {
                waitForSelector: '.b-sch-recurrenceconfirmation:not(.b-hidden)',
                desc: 'Confirmation showed up'
              }, {
                click: 'button:contains(Yes)'
              }, // Wait for event move
              {
                waitFor: function waitFor() {
                  return !(event2.startDate - new Date(2018, 5, 15));
                }
              }, {
                waitForProjectReady: scheduler
              }, function () {
                t.is(event2.startDate, new Date(2018, 5, 15), 'event 2 moved');
                t.is(event2.occurrences[0].startDate, new Date(2018, 5, 22), 'event 2 occurrence moved');
                t.isDeeplyUnordered(eventStore.modified.values, [event2], 'proper set of modified records');
                t.is(eventStore.count, 3, 'store has correct number of records');
                t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
                t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
                t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
              });

            case 4:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('"All Future Events" button click causes further occurrences regeneration', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var occurrence;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getScheduler({
                width: 1500
              });

            case 2:
              scheduler = _context3.sent;
              t.diag('Initial state of data');
              t.notOk(eventStore.modified.values.length, 'no modified records');
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
              occurrence = event3.occurrences[1];
              t.chain({
                drag: "[data-event-id=\"".concat(occurrence.id, "\"]"),
                by: [scheduler.tickSize, 0]
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
              }, {
                waitForProjectReady: scheduler
              }, function () {
                t.notOk(occurrence.isOccurrence, '"occurrence" is no longer an occurrence');
                t.ok(occurrence.isRecurring, '"occurrence" is a new independent recurring event');
                t.isDeeply(_toConsumableArray(eventStore.added), [occurrence], '"ex-occurrence" is in store.added');
                t.isDeeply(_toConsumableArray(eventStore.modified), [event3], 'event3 is in store.modified');
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

            case 11:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x4) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('"Only This Event" button click works properly', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var occurrence, occurrenceStartDate;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return getScheduler({
                width: 1500
              });

            case 2:
              scheduler = _context4.sent;
              t.diag('Initial state of data');
              t.notOk(eventStore.modified.values.length, 'no modified records');
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
              occurrence = event3.occurrences[1], occurrenceStartDate = occurrence.startDate;
              t.chain({
                drag: "[data-event-id=\"".concat(occurrence.id, "\"]"),
                by: [100, 0]
              }, {
                waitForSelector: '.b-sch-recurrenceconfirmation:not(.b-hidden)',
                desc: 'Confirmation showed up'
              }, {
                click: 'button:contains(Only This Event)'
              }, {
                waitFor: function waitFor() {
                  return !occurrence.isOccurrence;
                },
                desc: '"occurrence" is no longer an occurrence'
              }, {
                waitForProjectReady: scheduler
              }, function () {
                t.notOk(occurrence.isOccurrence, '"occurrence" is no longer an occurrence');
                t.notOk(occurrence.isRecurring, '"occurrence" is not a recurring event');
                t.is(occurrence.startDate, new Date(2018, 5, 19), '"occurrence" start date is correct');
                t.isDeeply(_toConsumableArray(eventStore.modified), [event3], 'proper "modified" bag');
                t.isDeeply(_toConsumableArray(eventStore.added), [occurrence], 'proper "added" bag');
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

            case 11:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x5) {
      return _ref4.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/bryntum-suite/issues/175

  t.it('Close tool in header should behave as Cancel button', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context5.sent;
              t.chain({
                drag: '.sch-event2',
                by: [100, 0]
              }, {
                waitForSelector: '.b-sch-recurrenceconfirmation:not(.b-hidden)',
                desc: 'Confirmation showed up'
              }, {
                click: '.b-popup-close',
                desc: 'Click [X] in the header'
              }, {
                waitForSelectorNotFound: '.b-sch-recurrenceconfirmation:not(.b-hidden)'
              }, function () {
                t.notOk(scheduler.features.eventDrag.drag.context, 'Context should be cleaned up since drag operation is finished');
                t.notOk(eventStore.modified.values.length, 'Records are not modified');
              });

            case 4:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x6) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Dragging events to span the TimeAxis start to change all events', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var _scheduler, eventStore, event1;

      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2018, 4, 1),
                viewPreset: 'weekAndDayLetter',
                renderTo: document.body,
                enableRecurringEvents: true,
                features: {
                  eventTooltip: false
                },
                resources: [{
                  name: 'Row one',
                  id: 1
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  name: '3 days/week, max 5 occurrences ',
                  startDate: '2018-01-01',
                  endDate: '2018-01-14',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=3;BYDAY=MO,TU,WE;COUNT=5'
                }]
              });

            case 2:
              scheduler = _context6.sent;
              _scheduler = scheduler, eventStore = _scheduler.eventStore, event1 = eventStore.first;
              t.is(eventStore.count, 1, 'store has correct number of records');
              t.is(event1.occurrences.length, 4, 'event 1 has 4 occurrences');
              t.chain({
                drag: function drag() {
                  return '[data-event-id="1"]';
                },
                // Drag it back to the *Sunday the 24th*.
                // This is not on its recurrence timeline BYDAY=MO,TU,WE
                // So it must snap to the 25th
                by: [-scheduler.tickSize * 8, 0]
              }, {
                click: '[data-ref="changeMultipleButton"]'
              }, {
                waitForProjectReady: scheduler
              }, function () {
                // Start date has been corrected in line with the BYDAY rule
                t.is(event1.startDate, new Date(2017, 11, 25)); // The 4 occurrences comply with the rule

                t.is(event1.occurrences[0].startDate, new Date(2017, 11, 26));
                t.is(event1.occurrences[1].startDate, new Date(2017, 11, 27));
                t.is(event1.occurrences[2].startDate, new Date(2018, 0, 15));
                t.is(event1.occurrences[3].startDate, new Date(2018, 0, 16));
              });

            case 7:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x7) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Dragging events to span the TimeAxis start to create exception', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var _scheduler2, eventStore, event1, event2;

      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2018, 4, 1),
                viewPreset: 'weekAndDayLetter',
                enableRecurringEvents: true,
                features: {
                  eventTooltip: false
                },
                resources: [{
                  name: 'Row one',
                  id: 1
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  name: '3 days/week, max 5 occurrences ',
                  startDate: '2018-01-01',
                  endDate: '2018-01-14',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=3;BYDAY=MO,TU,WE;COUNT=5'
                }]
              });

            case 2:
              scheduler = _context7.sent;
              _scheduler2 = scheduler, eventStore = _scheduler2.eventStore, event1 = eventStore.first, event2 = event1.occurrences[0];
              t.is(eventStore.count, 1, 'store has correct number of records');
              t.is(event1.occurrences.length, 4, 'event 1 has 4 occurrences');
              t.chain({
                drag: function drag() {
                  return scheduler.getElementFromEventRecord(event2);
                },
                // Drag it back to the Sunday the 24th.
                by: [-scheduler.tickSize * 9, 0]
              }, {
                click: '[data-ref="changeSingleButton"]'
              }, {
                waitForProjectReady: scheduler
              }, function () {
                t.is(eventStore.count, 2, 'store has correct number of records');
                t.is(event1.occurrences.length, 3, 'event 1 has 4 occurrences'); // Start date correct

                t.is(event2.startDate, new Date(2017, 11, 24));
                t.is(event1.startDate, new Date(2018, 0, 1)); // The 4 occurrences comply with the rule

                t.is(event1.occurrences[0].startDate, new Date(2018, 0, 3));
                t.is(event1.occurrences[1].startDate, new Date(2018, 0, 22));
                t.is(event1.occurrences[2].startDate, new Date(2018, 0, 23));
              });

            case 7:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x8) {
      return _ref7.apply(this, arguments);
    };
  }());
});