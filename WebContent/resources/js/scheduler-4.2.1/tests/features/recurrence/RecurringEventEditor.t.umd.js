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
  var resourceStore, eventStore, scheduler, event1, event2, event3;

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(config) {
      var result;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync(Object.assign({
                resourceStore: resourceStore,
                eventStore: eventStore,
                eventStyle: 'border',
                enableRecurringEvents: true,
                features: {
                  eventTooltip: false,
                  eventEdit: true // is enabled by default already, but in case we change our minds...

                },
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25)
              }, config));

            case 2:
              result = _context4.sent;
              return _context4.abrupt("return", result);

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));
    return _getScheduler.apply(this, arguments);
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
              t.is(eventStore.added.count, 0, 'No records added');
              t.is(eventStore.modified.count, 0, 'No records modified');
              t.is(eventStore.removed.count, 0, 'No records removed');
              t.diag('Initial state of data');
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.notOk(event2.occurrences.length, 'event 2 has no occurrence');
              t.notOk(event3.occurrences.length, 'event 3 has no occurrences');
              _context.next = 18;
              return getScheduler();

            case 18:
              scheduler = _context.sent;
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences'); // Needed to make async beforeEach work in umd tests

              next();

            case 23:
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
      click: '.b-recurrencelegendbutton'
    }, {
      click: ':textEquals(Fri)'
    }, {
      click: '.b-recurrenceeditor .b-green'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              t.diag('Assert data is intact until we click "Save"...');
              t.is(eventStore.count, 3, 'store has correct number of records');
              t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
              t.is(event2.occurrences.length, 1, 'event 2 has 1 occurrence');
              t.is(event3.occurrences.length, 5, 'event 3 has 5 occurrences');
              t.selectorCountIs('.b-sch-event-wrap', 6);

            case 6:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    })), {
      click: ':textEquals(Save)'
    }, {
      click: ':textEquals(Yes)'
    }, // A new occurrence will be added
    {
      waitFor: function waitFor() {
        return t.query(scheduler.eventSelector).length === 7;
      }
    }, function () {
      t.is(eventStore.count, 3, 'store has correct number of records');
      t.notOk(event1.occurrences.length, 'event 1 has no occurrences');
      t.is(event2.occurrences.length, 3, 'event 2 has one more occurrence');
      t.is(event3.occurrences.length, 5, 'event 3 has proper number of occurrences');
    });
  }); // https://github.com/bryntum/support/issues/3

  t.it('Custom dialog shows up when selecting Custom in the recurrence combo', function (t) {
    t.chain({
      diag: 'Assert recurring event editing'
    }, {
      doubleclick: '.sch-event1'
    }, {
      click: '.b-recurrencecombo .b-icon-picker'
    }, {
      waitForSelector: '.b-list .b-list-item:contains(Daily)'
    }, {
      click: '.b-list-item:contains(Custom)'
    }, function () {
      scheduler.destroy();
      t.selectorNotExists('.b-widget', 'No leaked widgets');
    });
  }); // https://github.com/bryntum/support/issues/163

  t.it('Should not show recurrence UI by default', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              scheduler && scheduler.destroy();
              _context3.next = 3;
              return t.getSchedulerAsync({
                features: {
                  eventTooltip: false,
                  eventEdit: true // is enabled by default already, but in case we change our minds...

                }
              });

            case 3:
              scheduler = _context3.sent;
              t.chain({
                doubleclick: '.b-sch-event'
              }, {
                waitForSelector: '.b-eventeditor'
              }, function () {
                return t.elementIsNotVisible('[data-ref=recurrenceCombo]');
              });

            case 5:
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
  t.it('Should not show recurrence UI if enableRecurringEvents is false', function (t) {
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler({
      enableRecurringEvents: false,
      features: {
        eventTooltip: false,
        eventEdit: true // is enabled by default already, but in case we change our minds...

      }
    });
    t.chain({
      doubleclick: '.b-sch-event'
    }, {
      waitForSelector: '.b-eventeditor'
    }, function () {
      return t.elementIsNotVisible('[data-ref=recurrenceCombo]');
    });
  }); // https://github.com/bryntum/support/issues/146

  t.it('Should render occurrences for newly created recurring event', function (t) {
    scheduler.events = [];
    t.chain({
      doubleclick: '.b-sch-timeaxis-cell',
      offset: [5, 5]
    }, {
      click: '.b-recurrencecombo .b-icon-picker'
    }, {
      click: '.b-list .b-list-item:contains(Daily)'
    }, {
      click: '.b-button:textEquals(Save)'
    }, {
      waitForSelector: '.b-recurring'
    }, {
      waitForSelector: '.b-occurrence'
    });
  }); // https://github.com/bryntum/bryntum-suite/issues/2155

  t.it('Custom dialog shows up correctly when editing newly created event', function (t) {
    scheduler.events = [];
    t.chain({
      doubleclick: '.b-sch-timeaxis-cell',
      offset: [5, 5]
    }, {
      click: '.b-recurrencecombo .b-icon-picker'
    }, {
      click: '.b-list .b-list-item:contains(Custom)'
    }, {
      waitFor: function waitFor() {
        var _scheduler$features$e;

        return (_scheduler$features$e = scheduler.features.eventEdit.recurrenceEditor) === null || _scheduler$features$e === void 0 ? void 0 : _scheduler$features$e.containsFocus;
      }
    }, function (next) {
      var eventEdit = scheduler.features.eventEdit,
          recurrenceEditor = eventEdit.recurrenceEditor,
          x = recurrenceEditor.x,
          y = recurrenceEditor.y; // Find correct center

      recurrenceEditor.alignTo({
        target: window,
        align: 'c-c'
      }); // Must have been centered by our default settings.

      t.isApprox(recurrenceEditor.x, x, 1);
      t.isApprox(recurrenceEditor.y, y, 1); // The frequency has been loaded correctly

      t.is(recurrenceEditor.widgetMap.frequencyField.value, eventEdit.eventRecord.recurrenceModel.fieldMap.frequency.defaultValue);
    });
  });
  t.it('Should support multi resource assignment for recurring events', function (t) {
    var _scheduler;

    (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
    scheduler = t.getScheduler({
      enableRecurringEvents: true,
      features: {
        eventTooltip: false,
        eventEdit: true // is enabled by default already, but in case we change our minds...

      },
      startDate: '2018-06-13',
      events: [{
        id: 1,
        name: 'Foo',
        startDate: '2018-06-14',
        endDate: '2018-06-15'
      }, {
        id: 2,
        name: 'Bar',
        startDate: '2018-06-14',
        endDate: '2018-06-15',
        recurrenceRule: 'FREQ=DAILY;INTERVAL=2',
        cls: 'sch-event2'
      }],
      resources: [{
        id: 'r1',
        name: 'Resource 1'
      }, {
        id: 'r2',
        name: 'Resource 2'
      }],
      assignments: [{
        id: 1,
        eventId: 1,
        resourceId: 'r1'
      }, {
        id: 2,
        eventId: 2,
        resourceId: 'r1'
      }]
    });
    t.chain({
      doubleclick: '.sch-event2'
    }, {
      waitForSelector: '.b-eventeditor'
    }, function (next) {
      scheduler.features.eventEdit.editor.widgetMap.resourceField.value = ['r1', 'r2'];
      next();
    }, {
      click: ':textEquals(Save)'
    }, {
      click: ':textEquals(Yes)'
    }, {
      waitForSelectorNotFound: '.b-eventeditor'
    }, function () {
      return t.isDeeplyUnordered(scheduler.eventStore.getById(2).resources, _toConsumableArray(scheduler.resourceStore), 'Event has been successfully updated.');
    });
  });
});