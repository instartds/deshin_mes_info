function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr == null ? null : typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]; if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, firstRec, lastRec;
  t.beforeEach(function () {
    var _scheduler, _scheduler$destroy;

    (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : (_scheduler$destroy = _scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(_scheduler);
  });

  function setup() {
    return _setup.apply(this, arguments);
  }

  function _setup() {
    _setup = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee56() {
      var config,
          editRecords,
          _args56 = arguments;
      return regeneratorRuntime.wrap(function _callee56$(_context56) {
        while (1) {
          switch (_context56.prev = _context56.next) {
            case 0:
              config = _args56.length > 0 && _args56[0] !== undefined ? _args56[0] : {};
              editRecords = _args56.length > 1 && _args56[1] !== undefined ? _args56[1] : true;
              _context56.next = 4;
              return t.getSchedulerAsync(Object.assign({
                features: {
                  eventTooltip: false,
                  eventEdit: true // is enabled by default already, but in case we change our minds...

                },
                allowOverlap: false,
                forceFit: true,
                enableEventAnimations: false
              }, config));

            case 4:
              scheduler = _context56.sent;
              firstRec = scheduler.eventStore.first;
              lastRec = scheduler.eventStore.last;

              if (!(editRecords && firstRec && lastRec)) {
                _context56.next = 14;
                break;
              }

              firstRec.cls = 'FOO';
              lastRec.cls = 'BAR';
              lastRec.assign(firstRec.resource);
              lastRec.startDate = firstRec.endDate;
              _context56.next = 14;
              return scheduler.project.commitAsync();

            case 14:
            case "end":
              return _context56.stop();
          }
        }
      }, _callee56);
    }));
    return _setup.apply(this, arguments);
  }

  t.it('Delete should move focus immediately', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return setup();

            case 2:
              t.chain({
                click: '.b-sch-event'
              }, // The LEFT should not attempt to navigate from a deleted event.
              // No error should be thrown.
              {
                type: '[DELETE][LEFT]'
              }, function () {
                t.pass('No exception thrown');
              });

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
  }());
  t.it('Show add and remove the b-editing class', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var eventEl;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return setup();

            case 2:
              eventEl = scheduler.getElementFromEventRecord(scheduler.eventStore.first);
              t.chain({
                dblclick: function dblclick() {
                  return eventEl;
                }
              }, function (next) {
                t.hasCls(eventEl, 'b-editing', 'b-editing added correctly');
                next();
              }, {
                click: 'button:contains(Cancel)'
              }, // https://github.com/bryntum/support/issues/1630
              // The transitionend handler must have removed the editor from the DOM
              {
                waitForSelectorNotFound: '.b-eventeditor'
              }, function () {
                t.hasNotCls(eventEl, 'b-editing', 'b-editing removed correctly');
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
  t.it('Should not have any invalid fields upon first show of the editor', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return setup();

            case 2:
              t.chain(scheduler.eventStore.map(function (event) {
                return [function (next) {
                  scheduler.editEvent(event);
                  next();
                }, {
                  waitForElementVisible: '.b-eventeditor'
                }, // The min/max checking must not invalidate
                // valid field values.
                function (next) {
                  // Check that the title has been translated.
                  t.notOk(scheduler.features.eventEdit.editor.title.includes('{'), 'Localized property has been translated');
                  t.selectorNotExists('.b-invalid');
                  next();
                }, {
                  type: '[ESC]'
                }, // https://github.com/bryntum/support/issues/1630
                // The transitionend handler must have removed the editor from the DOM
                {
                  waitForSelectorNotFound: '.b-eventeditor'
                }];
              }));

            case 3:
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
  t.it('Should show editor on double click', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return setup();

            case 2:
              t.firesOnce(scheduler, 'eventEditBeforeSetRecord');
              scheduler.on('eventEditBeforeSetRecord', function (_ref5) {
                var record = _ref5.record;
                t.is(record.name, 'Assignment 1', 'record param passed correctly');
              });
              t.is(scheduler.features.eventEdit.isEditing, false, 'Not editing');
              t.chain({
                doubleClick: '.FOO'
              }, {
                waitForElementVisible: '.b-eventeditor'
              }, function () {
                t.is(scheduler.features.eventEdit.isEditing, true, 'Editing'); // check editor contents

                t.is(document.querySelector('input[name=name]').value, firstRec.name, 'Name correct');
                t.is(document.querySelector('input[name=resource]').value, firstRec.resource.name, 'Resource correct');
                t.is(document.querySelector('.b-datefield input[name=startDate]').value, '01/04/2011', 'Start date correct');
                t.is(document.querySelector('.b-datefield input[name=endDate]').value, '01/06/2011', 'End date correct');
                t.is(document.querySelector('.b-timefield input[name=startDate]').value, '12:00 AM', 'Start time correct');
                t.is(document.querySelector('.b-timefield input[name=endDate]').value, '12:00 AM', 'End time correct'); // exposes fields?

                var editor = scheduler.features.eventEdit;
                t.ok(editor.nameField, 'name field exposed');
                t.ok(editor.resourceField, 'resource field exposed');
                t.ok(editor.startDateField, 'startDate field exposed');
                t.ok(editor.endDateField, 'endDate field exposed');
                t.ok(editor.startTimeField, 'startTime field exposed');
                t.ok(editor.endTimeField, 'endTime field exposed');
                var buttons = document.querySelectorAll('.b-eventeditor .b-bottom-toolbar button');
                t.isApprox(buttons[0].offsetWidth, buttons[1].offsetWidth, 2, 'Delete button width is ok');
                t.isApprox(buttons[0].offsetWidth, buttons[2].offsetWidth, 2, 'Cancel button width is ok');
              });

            case 6:
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
  t.it('Should show editor for other task on double click, even if it is already visible', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return setup();

            case 2:
              t.chain({
                doubleClick: '.FOO'
              }, {
                waitForElementVisible: '.b-eventeditor'
              }, {
                doubleClick: '.BAR'
              }, {
                waitForElementVisible: '.b-eventeditor'
              }, function (next) {
                t.is(document.querySelectorAll('.b-eventeditor').length, 1, 'Only one event editor open');
                next();
              });

            case 3:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x5) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Should update record (+ DOM) after save', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return setup();

            case 2:
              t.chain({
                doubleClick: '.FOO'
              }, {
                waitForSelector: '.b-eventeditor:not(.b-hidden)'
              }, function (next) {
                scheduler.features.eventEdit.nameField.value = '';
                next();
              }, {
                click: 'input[name=name]'
              }, {
                type: 'test1234'
              }, {
                click: 'button:contains(Save)'
              }, {
                waitForSelectorNotFound: '.b-eventeditor'
              }, function (next) {
                t.is(scheduler.eventStore.first.name, 'test1234', 'Record was updated ok');
                t.like(document.querySelector('.FOO').innerHTML, 'test1234', 'Element was refreshed ok');
                next();
              }, {
                waitForSelectorNotFound: '.b-eventeditor:not(.b-hidden)'
              });

            case 3:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Should save and close on enter', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return setup();

            case 2:
              t.chain({
                doubleClick: '.FOO'
              }, {
                waitForSelector: '.b-eventeditor:not(.b-hidden)'
              }, function (next) {
                scheduler.features.eventEdit.nameField.value = '';
                next();
              }, {
                click: 'input[name=name]'
              }, {
                type: 'test1234[ENTER]'
              }, function (next) {
                t.is(scheduler.eventStore.first.name, 'test1234', 'Record was updated ok');
                t.like(document.querySelector('.FOO').innerHTML, 'test1234', 'Element was refreshed ok');
                next();
              }, {
                waitForSelectorNotFound: '.b-eventeditor:not(.b-hidden)'
              });

            case 3:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x7) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Should delete (triggers clear DOM) after delete', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return setup();

            case 2:
              t.chain({
                doubleClick: '.FOO'
              }, {
                waitForSelector: '.b-eventeditor:not(.b-hidden)'
              }, // Testing deleting of existing event
              {
                click: 'button:contains(Delete)'
              }, function (next) {
                t.is(scheduler.eventStore.indexOf(firstRec), -1, 'Record no longer in the store');
                next();
              }, {
                waitForSelectorNotFound: ':not(.b-released) > .FOO'
              });

            case 3:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x8) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Should show editor after dragging in the schedule', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return setup();

            case 2:
              t.chain(function (next) {
                scheduler.eventStore.removeAll();
                next();
              }, // Testing creating a new event
              {
                drag: '.b-sch-timeaxis-cell',
                offset: [12, 12],
                by: [100, 0]
              }, {
                waitForSelector: '.b-eventeditor:not(.b-hidden)'
              }, {
                click: 'input[name=name]'
              }, {
                type: 'foo[ENTER]'
              }, function (next) {
                t.is(scheduler.eventStore.count, 1, '1 record was added to the store');
                t.is(scheduler.eventStore.last.name, 'foo', 'Correct name for new event');
                next();
              }, {
                waitForSelectorNotFound: '.b-eventeditor:not(.b-hidden)'
              });

            case 3:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x9) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Should validate start & end date values', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var editFeature, record, DH;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return setup();

            case 2:
              DH = DateHelper;
              t.chain({
                doubleClick: '.FOO'
              }, {
                waitForSelector: '.b-eventeditor:not(.b-hidden)'
              }, function (next) {
                editFeature = scheduler.features.eventEdit;
                record = editFeature.eventRecord;
                var startDate = editFeature.startDateField.value,
                    endDate = editFeature.endDateField.value;
                var startTime = editFeature.startTimeField.value,
                    endTime = editFeature.endTimeField.value;
                t.is(startDate, record.get('startDate'), 'Startdate is correct');
                t.is(endDate, editFeature.endDateField.value, 'Enddate is correct');
                t.is(editFeature.endTimeField.min, null, 'Endtime min is correctly set to null');
                t.is(editFeature.startTimeField.max, null, 'Starttime max is correctly set to null');
                t.is(startTime, new Date(2020, 0, 1, 0, 0), 'StartTime is correctly set');
                t.is(endTime, new Date(2020, 0, 1, 0, 0), 'EndTime is correctly set');
                var values = editFeature.values;
                var duration = DH.getDurationInUnit(values.startDate, values.endDate, 'minutes');
                t.is(duration, 2 * 24 * 60, 'Duration is ok');
                t.is(editFeature.isValid, true, 'Editor is validated');
                startDate = DH.add(startDate, 2, 'day');
                endDate = DH.add(startDate, 2, 'day');
                editFeature.startDateField.value = startDate;
                t.is(endDate, editFeature.endDateField.value, 'Enddate is correct');
                values = editFeature.values;
                duration = DH.getDurationInUnit(values.startDate, values.endDate, 'minutes');
                t.is(duration, 2 * 24 * 60, 'Duration is ok');
                editFeature.endDateField.value = startDate;
                t.is(editFeature.endTimeField.min, editFeature.startTimeField.value, 'Endtime min is correctly set when start and end date on same day');
                editFeature.endTimeField.value = new Date(2020, 0, 1, 0, 30);
                editFeature.endDateField.value = endDate;
                t.is(editFeature.isValid, true, 'Editor is validated');
                t.is(editFeature.endTimeField.min, null, 'Endtime min is correctly set to null');
                t.is(editFeature.startTimeField.max, null, 'Starttime max is correctly set to null');
                editFeature.startTimeField.value = new Date(2020, 0, 1, 0, 30);
                t.is(editFeature.endTimeField.value, new Date(2020, 0, 1, 0, 30), '');
                editFeature.endDateField.value = editFeature.startDateField.value;
                t.is(editFeature.endTimeField.min, editFeature.startTimeField.value, 'Endtime max is correctly set when start and end date on same day');
                editFeature.startTimeField.value = new Date(2020, 0, 1, 0, 30);
                t.is(editFeature.endTimeField.min, editFeature.startTimeField.value, 'Endtime max is correctly set when start and end date on same day');
                editFeature.endTimeField.value = new Date(2020, 0, 1, 0, 0);
                t.is(editFeature.isValid, false, 'Editor is falsely validated');
                next();
              }, {
                click: 'button:contains(Save)'
              }, function () {
                t.is(editFeature.editor.isVisible, true, 'Editor is still open');
              });

            case 4:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x10) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Should show editor in readOnly mode if readOnly', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return setup({
                enableRecurringEvents: true,
                readOnly: true
              });

            case 2:
              // We are testing the recurrence editor for readOnlyness
              scheduler.eventStore.first.recurrenceRule = 'FREQ=DAILY;COUNT=6';
              t.chain({
                dblClick: '.b-sch-event'
              }, {
                waitForSelector: '.b-eventeditor'
              }, function (next) {
                t.selectorExists('.b-eventeditor.b-readonly', 'Editor has b-readonly');
                t.selectorNotExists('.b-field:not(.b-readonly)', 'No non-readonly field found');
                t.selectorNotExists('.b-toolbar .b-button:visible:not(:contains(Daily))', 'No visible update buttons found');
                next();
              }, // Show the recurrence editor to test its readOnly state
              {
                click: 'button:contains(Daily)'
              }, function (next) {
                t.selectorExists('.b-recurrenceeditor.b-readonly', 'RecurrenceEditor has b-readonly');
                t.selectorNotExists('.b-field:not(.b-buttongroup):not(.b-readonly)', 'No non-readonly field found');
                t.selectorNotExists('.b-toolbar .b-button:visible:not(:contains(Daily))', 'No visible update buttons found');
                next();
              }, {
                type: '[ESCAPE]'
              }, {
                waitFor: function waitFor() {
                  return scheduler.features.eventEdit.editor.containsFocus;
                }
              }, // Go back to the event name field because we are going to test the ENTER key
              {
                click: '[data-ref="nameField"] input'
              }, function (next) {
                scheduler.features.eventEdit.editor.widgetMap.nameField.value = 'Changed Programatically';
                next();
              }, {
                type: '[ENTER]'
              }, // ENTER should do nothing if we're readOnly
              function (next) {
                t.selectorExists('.b-eventeditor', 'Editor still present');
                next();
              }, {
                type: '[ESCAPE]',
                target: null
              }, // ESCAPE should hide it
              {
                waitForSelectorNotFound: '.b-eventeditor'
              });

            case 4:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x11) {
      return _ref12.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/6848

  t.it('Should create new record even if resource field is not shown in Editor', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return setup({
                features: {
                  eventTooltip: false,
                  eventEdit: {
                    showResourceField: false
                  }
                }
              }, false);

            case 2:
              t.chain({
                dblclick: '.b-grid-subgrid-normal .b-grid-cell'
              }, {
                type: 'test',
                target: '.b-eventeditor .b-textfield input'
              }, {
                click: '.b-button.b-green'
              }, {
                waitFor: function waitFor() {
                  return scheduler.eventStore.count === 6;
                }
              }, function () {
                var rec = scheduler.eventStore.last;
                t.is(rec.name, 'test');
                t.is(rec.resource.name, 'Mike');
              });

            case 3:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x12) {
      return _ref13.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/6803

  t.it('Should adjust the duration model field on setting end date/time', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return setup({
                features: {
                  eventTooltip: false,
                  eventEdit: true
                }
              }, false);

            case 2:
              t.is(firstRec.durationUnit, 'day');
              t.is(firstRec.duration, 2);
              t.chain({
                dblclick: '[data-event-id=1]'
              }, {
                click: '.b-datefield input[name=endDate]'
              }, // HACK for IE11: it somehow hangs when we just try to type to field after dblclick
              // In order to fix that action we only type last digit in the test (for field listeners to activate)
              // and complete editing right after. This problem is reproducible in eventeditor also if you remove the value
              // from this field, switch to another and then try to type. Very difficult to debug because browser hangs.
              // At the same time normal usage seems to work.
              function (next) {
                document.querySelector('.b-datefield input[name=endDate]').value = '01/07/201';
                next();
              }, {
                type: '1[ENTER]'
              }, function () {
                t.is(firstRec.durationUnit, 'day');
                t.is(firstRec.duration, 3);
              });

            case 5:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x13) {
      return _ref14.apply(this, arguments);
    };
  }()); // region https://app.assembla.com/spaces/bryntum/tickets/6912

  t.it('Should move event if change start time by typing and pressing Enter', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _context14.next = 2;
              return setup({
                features: {
                  eventTooltip: false,
                  eventEdit: true
                }
              }, false);

            case 2:
              t.chain({
                dblclick: '[data-event-id=1]'
              }, {
                dblclick: '.b-timefield input[name=startDate]'
              }, {
                type: '10:00 AM[ENTER]',
                target: '.b-timefield input[name=startDate]'
              }, function () {
                t.isDateEqual(firstRec.endDate, new Date(2011, 0, 6, 10));
              });

            case 3:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x14) {
      return _ref15.apply(this, arguments);
    };
  }());
  t.it('Should move event if change start time by typing and click Save', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return setup({
                features: {
                  eventTooltip: false,
                  eventEdit: true
                }
              }, false);

            case 2:
              t.chain({
                dblclick: '[data-event-id=1]'
              }, {
                dblclick: '.b-timefield input[name=startDate]'
              }, {
                type: '10:00 AM',
                target: '.b-timefield input[name=startDate]'
              }, {
                click: '.b-button.b-green'
              }, function () {
                t.isDateEqual(firstRec.endDate, new Date(2011, 0, 6, 10));
              });

            case 3:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x15) {
      return _ref16.apply(this, arguments);
    };
  }());
  t.it('Should move event if change start time by typing, then click a field and click Save', /*#__PURE__*/function () {
    var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return setup({
                features: {
                  eventTooltip: false,
                  eventEdit: true
                }
              }, false);

            case 2:
              t.chain({
                dblclick: '[data-event-id=1]'
              }, {
                dblclick: '.b-timefield input[name=startDate]'
              }, {
                type: '10:00 AM',
                target: '.b-timefield input[name=startDate]'
              }, {
                click: '.b-textfield input[name=name]'
              }, {
                click: '.b-button.b-green'
              }, function () {
                t.isDateEqual(firstRec.endDate, new Date(2011, 0, 6, 10));
              });

            case 3:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x16) {
      return _ref17.apply(this, arguments);
    };
  }()); // endregion https://app.assembla.com/spaces/bryntum/tickets/6912

  t.it('Should support creating a new Event on the fly (that is not in the EventStore yet) and editing it', /*#__PURE__*/function () {
    var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      var event;
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return setup({
                events: [],
                features: {
                  eventTooltip: false,
                  eventEdit: true
                }
              }, false);

            case 2:
              // NOTE: Had to add endDate here, since normalization happens in engine now
              event = new EventModel({
                resourceId: scheduler.resourceStore.first.id,
                startDate: scheduler.startDate,
                duration: 1,
                durationUnit: 'd',
                endDate: DateHelper.add(scheduler.startDate, 1, 'd'),
                name: 'New task'
              });
              scheduler.editEvent(event);
              t.chain({
                click: '.b-button:textEquals(Save)'
              }, function () {
                t.selectorCountIs('.b-sch-event', 1, '1 event created');
              });

            case 5:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x17) {
      return _ref18.apply(this, arguments);
    };
  }());
  t.it('Should calculate end date if editing a new Event with start date + duration defined', /*#__PURE__*/function () {
    var _ref19 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
      var event;
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              _context18.next = 2;
              return setup({
                events: [],
                features: {
                  eventTooltip: false,
                  eventEdit: true
                }
              }, false);

            case 2:
              event = new EventModel({
                resourceId: scheduler.resourceStore.first.id,
                startDate: scheduler.startDate,
                duration: 1,
                durationUnit: 'd',
                name: 'New task'
              });
              _context18.next = 5;
              return scheduler.editEvent(event);

            case 5:
              t.is(scheduler.features.eventEdit.getEditor().widgetMap.endDateField.value, new Date(2011, 0, 4), 'End date calculated');

            case 6:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    }));

    return function (_x18) {
      return _ref19.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7511-group-summary-rows-visible-in-resource-combo-of-event-editor/details#

  t.it('Should not include special rows (grouping, summary) in resource combo', /*#__PURE__*/function () {
    var _ref20 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t) {
      var event;
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              _context19.next = 2;
              return setup({
                events: [],
                features: {
                  group: 'name',
                  groupSummary: {
                    summaries: [{
                      label: 'Summary',
                      renderer: function renderer() {
                        return '';
                      }
                    }]
                  }
                }
              }, false);

            case 2:
              event = new EventModel({
                resourceId: scheduler.resourceStore.first.id,
                startDate: new Date(),
                endDate: new Date()
              });
              scheduler.editEvent(event);
              t.is(scheduler.features.eventEdit.resourceField.store.count, 6, 'No group header records or summary row records in the Store');

            case 5:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    }));

    return function (_x19) {
      return _ref20.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7560

  t.it('Resource combo should show all resources', /*#__PURE__*/function () {
    var _ref21 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(t) {
      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              _context20.next = 2;
              return setup({
                features: {
                  group: 'name',
                  eventEdit: true,
                  eventTooltip: false
                }
              });

            case 2:
              scheduler.collapseAll();
              t.chain({
                click: '.b-group-row'
              }, {
                dblclick: '[data-index="1"] .b-sch-timeaxis-cell',
                offset: [10, 10]
              }, {
                waitFor: function waitFor() {
                  return scheduler.features.eventEdit.editor.containsFocus;
                }
              }, {
                type: 'New test event'
              }, {
                click: 'button:contains(Save)'
              }, {
                click: '.b-group-row[data-index="2"]'
              }, {
                dblclick: '[data-index="3"] .b-sch-timeaxis-cell',
                offset: [10, 10]
              }, function () {
                t.is(scheduler.eventEdit.resourceField.store.count, 6, 'All resources in store');
              });

            case 4:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    }));

    return function (_x20) {
      return _ref21.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/123

  t.it('Should show full list of resources in Event Editor when resource store is filtered', /*#__PURE__*/function () {
    var _ref22 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21(t) {
      var count;
      return regeneratorRuntime.wrap(function _callee21$(_context21) {
        while (1) {
          switch (_context21.prev = _context21.next) {
            case 0:
              _context21.next = 2;
              return setup();

            case 2:
              count = scheduler.resourceStore.count;
              scheduler.resourceStore.filter('name', 'Linda');
              t.chain({
                dblclick: '[data-event-id="2"]'
              }, {
                click: '[data-ref="resourceField"] .b-fieldtrigger'
              }, {
                waitForSelector: '.b-list-item'
              }, function () {
                t.selectorCountIs('.b-list-item', count, 'Full list of resources shown');
              });

            case 5:
            case "end":
              return _context21.stop();
          }
        }
      }, _callee21);
    }));

    return function (_x21) {
      return _ref22.apply(this, arguments);
    };
  }());
  t.it('Should show full list of resources in Event Editor when resource store is a tree store and it is filtered', /*#__PURE__*/function () {
    var _ref23 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
      var getChildren, count;
      return regeneratorRuntime.wrap(function _callee22$(_context22) {
        while (1) {
          switch (_context22.prev = _context22.next) {
            case 0:
              getChildren = function _getChildren() {
                var char = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : 'r';
                var resources = [];

                for (var i = 1; i < 10; i++) {
                  var id = char + i;
                  resources.push({
                    id: id,
                    name: id
                  });
                }

                return resources;
              };

              _context22.next = 3;
              return setup({
                features: {
                  tree: true
                },
                resourceStore: new ResourceStore({
                  tree: true,
                  data: [{
                    id: 1000,
                    name: 'Foo',
                    expanded: true,
                    children: getChildren()
                  }, {
                    id: 2000,
                    name: 'Bar',
                    expanded: true,
                    children: getChildren('b')
                  }]
                }),
                columns: [{
                  type: 'tree',
                  field: 'name'
                }]
              });

            case 3:
              count = scheduler.resourceStore.count;
              scheduler.resourceStore.filter('name', 'r2');
              t.chain({
                dblclick: '[data-event-id="2"]'
              }, {
                click: '[data-ref="resourceField"] .b-fieldtrigger'
              }, {
                waitForSelector: '.b-list-item'
              }, function () {
                t.selectorCountIs('.b-list-item', count, 'Full list of resources shown');
              });

            case 6:
            case "end":
              return _context22.stop();
          }
        }
      }, _callee22);
    }));

    return function (_x22) {
      return _ref23.apply(this, arguments);
    };
  }());
  t.it('Should show full list of resources in Event Editor when resource store is a tree store and some of resources are collapsed', /*#__PURE__*/function () {
    var _ref24 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23(t) {
      var getChildren, count;
      return regeneratorRuntime.wrap(function _callee23$(_context23) {
        while (1) {
          switch (_context23.prev = _context23.next) {
            case 0:
              getChildren = function _getChildren2() {
                var char = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : 'r';
                var resources = [];

                for (var i = 1; i < 10; i++) {
                  var id = char + i;
                  resources.push({
                    id: id,
                    name: id
                  });
                }

                return resources;
              };

              _context23.next = 3;
              return setup({
                features: {
                  tree: true
                },
                resourceStore: new ResourceStore({
                  tree: true,
                  data: [{
                    id: 1000,
                    name: 'Foo',
                    expanded: true,
                    children: getChildren()
                  }, {
                    id: 2000,
                    name: 'Bar',
                    expanded: true,
                    children: getChildren('b')
                  }]
                }),
                columns: [{
                  type: 'tree',
                  field: 'name'
                }]
              });

            case 3:
              count = scheduler.resourceStore.count;
              t.chain(function () {
                return scheduler.collapse(scheduler.resourceStore.getById(2000));
              }, {
                dblclick: '[data-event-id="2"]'
              }, {
                click: '[data-ref="resourceField"] .b-fieldtrigger'
              }, {
                waitForSelector: '.b-list-item'
              }, function () {
                t.selectorCountIs('.b-list-item', count, 'Full list of resources shown');
              });

            case 5:
            case "end":
              return _context23.stop();
          }
        }
      }, _callee23);
    }));

    return function (_x23) {
      return _ref24.apply(this, arguments);
    };
  }());
  t.it('Time field step value should match current timeaxis time resolution', /*#__PURE__*/function () {
    var _ref25 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee24(t) {
      return regeneratorRuntime.wrap(function _callee24$(_context24) {
        while (1) {
          switch (_context24.prev = _context24.next) {
            case 0:
              _context24.next = 2;
              return setup({
                events: [{
                  name: 'Test event',
                  resourceId: 'r1',
                  id: 1,
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 5)
                }],
                features: {
                  eventEdit: true,
                  eventTooltip: false
                }
              }, false);

            case 2:
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                click: '.b-timefield .b-align-end.b-icon-angle-right'
              }, {
                click: 'button:textEquals(Save)'
              }, function () {
                t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 4, 1), 'Bumped +1h');
              });

            case 3:
            case "end":
              return _context24.stop();
          }
        }
      }, _callee24);
    }));

    return function (_x24) {
      return _ref25.apply(this, arguments);
    };
  }());
  t.it('Should support readOnly mode', /*#__PURE__*/function () {
    var _ref26 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee25(t) {
      return regeneratorRuntime.wrap(function _callee25$(_context25) {
        while (1) {
          switch (_context25.prev = _context25.next) {
            case 0:
              _context25.next = 2;
              return setup({
                features: {
                  eventEdit: {
                    readOnly: true
                  }
                }
              }, false);

            case 2:
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                waitForSelector: '.b-eventeditor'
              }, function () {
                t.selectorExists('.b-eventeditor.b-readonly', 'Editor has b-readonly');
                t.selectorNotExists('.b-field:not(.b-readonly)', 'No none-readonly field found');
                t.selectorNotExists('.b-button:not(.b-hidden)', 'No visible button found');
              });

            case 3:
            case "end":
              return _context25.stop();
          }
        }
      }, _callee25);
    }));

    return function (_x25) {
      return _ref26.apply(this, arguments);
    };
  }());
  t.it('Should support disabling', /*#__PURE__*/function () {
    var _ref27 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee26(t) {
      return regeneratorRuntime.wrap(function _callee26$(_context26) {
        while (1) {
          switch (_context26.prev = _context26.next) {
            case 0:
              _context26.next = 2;
              return setup({
                features: {
                  columnLines: false // Weird NaN fail otherwise in background image

                }
              });

            case 2:
              scheduler.features.eventEdit.disabled = true;
              t.chain({
                dblclick: '.b-sch-event'
              }, function (next) {
                t.selectorNotExists('.b-eventeditor', 'No editor');
                scheduler.features.eventEdit.disabled = false;
                next();
              }, {
                dblclick: '.b-sch-event'
              }, function () {
                t.selectorExists('.b-eventeditor', 'Editor shown');
              });

            case 4:
            case "end":
              return _context26.stop();
          }
        }
      }, _callee26);
    }));

    return function (_x26) {
      return _ref27.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/65

  t.it('Should position event correctly after changing resource and time', /*#__PURE__*/function () {
    var _ref28 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee27(t) {
      return regeneratorRuntime.wrap(function _callee27$(_context27) {
        while (1) {
          switch (_context27.prev = _context27.next) {
            case 0:
              scheduler = t.getScheduler({
                enableEventAnimations: false,
                features: {
                  eventEdit: true
                }
              });
              t.chain({
                dblClick: '[data-event-id="1"]'
              }, {
                type: '[DOWN]',
                target: '[name=resource]'
              }, {
                waitForElementVisible: '.b-list'
              }, {
                type: '[DOWN][ENTER]',
                target: '[name=resource]'
              }, {
                type: '01/05/2011[ENTER]',
                target: '[name=startDate]',
                clearExisting: true
              }, function () {
                var box = Rectangle.from(document.querySelector('[data-event-id="1"]'), scheduler.timeAxisSubGridElement);
                t.isApprox(box.left, 200, 1, 'Correct X');
                t.isApprox(box.top, 56, 1, 'Correct Y');
              });

            case 2:
            case "end":
              return _context27.stop();
          }
        }
      }, _callee27);
    }));

    return function (_x27) {
      return _ref28.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/9456

  t.it('Repeat field should be hidden when RecurringEvents feature is disabled', /*#__PURE__*/function () {
    var _ref29 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee28(t) {
      return regeneratorRuntime.wrap(function _callee28$(_context28) {
        while (1) {
          switch (_context28.prev = _context28.next) {
            case 0:
              _context28.next = 2;
              return setup({
                enableRecurringEvents: false
              });

            case 2:
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                waitForSelector: '.b-eventeditor'
              }, function () {
                t.elementIsNotTopElement('[data-ref="recurrenceCombo"]', 'Repeat field is hidden');
                t.elementIsNotTopElement('[data-ref="editRecurrenceButton"]', 'Repeat button is hidden');
              });

            case 3:
            case "end":
              return _context28.stop();
          }
        }
      }, _callee28);
    }));

    return function (_x28) {
      return _ref29.apply(this, arguments);
    };
  }());
  t.it('Should hide repeat field when disable RecurringEvents', /*#__PURE__*/function () {
    var _ref30 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee29(t) {
      return regeneratorRuntime.wrap(function _callee29$(_context29) {
        while (1) {
          switch (_context29.prev = _context29.next) {
            case 0:
              _context29.next = 2;
              return setup({
                enableRecurringEvents: true
              });

            case 2:
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                waitForSelector: '.b-eventeditor'
              }, function (next) {
                t.elementIsTopElement('[data-ref="recurrenceCombo"]', 'Repeat field is visible');
                next();
              }, {
                click: ':textEquals(Cancel)'
              }, {
                waitForSelectorNotFound: '.b-eventeditor'
              }, function (next) {
                scheduler.enableRecurringEvents = false;
                next();
              }, {
                dblclick: '.b-sch-event'
              }, {
                waitForSelector: '.b-eventeditor'
              }, function () {
                t.elementIsNotTopElement('[data-ref="recurrenceCombo"]', 'Repeat field is hidden');
                t.elementIsNotTopElement('[data-ref="editRecurrenceButton"]', 'Repeat button is hidden');
              });

            case 3:
            case "end":
              return _context29.stop();
          }
        }
      }, _callee29);
    }));

    return function (_x29) {
      return _ref30.apply(this, arguments);
    };
  }());
  t.it('UI should be locked when Scheduler is readOnly', /*#__PURE__*/function () {
    var _ref31 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee30(t) {
      return regeneratorRuntime.wrap(function _callee30$(_context30) {
        while (1) {
          switch (_context30.prev = _context30.next) {
            case 0:
              _context30.next = 2;
              return setup({
                readOnly: true,
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25),
                enableRecurringEvents: true,
                features: {
                  eventEdit: true
                },
                resources: [{
                  id: 'r1',
                  name: 'test'
                }],
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Bar',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1',
                  cls: 'sch-event2'
                }]
              });

            case 2:
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                waitForSelector: '.b-eventeditor'
              }, // Check first occurrence is in sync with state of Scheduler
              function (next) {
                var editor = scheduler.features.eventEdit.editor; // UI must be locked

                var inputs = editor.queryAll(function (w) {
                  return w.isField;
                });
                inputs.forEach(function (input) {
                  return t.ok(input.readOnly);
                });
                scheduler.readOnly = false;
                next();
              }, // Check it unlocks
              function (next) {
                var editor = scheduler.features.eventEdit.editor; // UI must be locked

                var inputs = editor.queryAll(function (w) {
                  return w.isField;
                });
                inputs.forEach(function (input) {
                  return t.notOk(input.readOnly);
                });
                scheduler.readOnly = true;
                next();
              }, // Check it locks again
              function () {
                var editor = scheduler.features.eventEdit.editor; // UI must be locked

                var inputs = editor.queryAll(function (w) {
                  return w.isField;
                });
                inputs.forEach(function (input) {
                  return t.ok(input.readOnly);
                });
                scheduler.readOnly = false;
              });

            case 3:
            case "end":
              return _context30.stop();
          }
        }
      }, _callee30);
    }));

    return function (_x30) {
      return _ref31.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2337

  t.it('Should be possible to disable recurrenceCombo in Editor', /*#__PURE__*/function () {
    var _ref32 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee31(t) {
      return regeneratorRuntime.wrap(function _callee31$(_context31) {
        while (1) {
          switch (_context31.prev = _context31.next) {
            case 0:
              _context31.next = 2;
              return setup({
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25),
                enableRecurringEvents: true,
                features: {
                  eventEdit: {
                    items: {
                      recurrenceCombo: null,
                      editRecurrenceButton: null
                    }
                  }
                },
                resources: [{
                  id: 'r1',
                  name: 'test'
                }],
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Bar',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1'
                }]
              });

            case 2:
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                waitForSelector: '.b-eventeditor'
              }, function () {
                t.selectorNotExists('[data-ref="recurrenceCombo"]', 'Repeat combo is disabled');
                t.selectorNotExists('[data-ref="editRecurrenceButton"]', 'Repeat button is disabled');
              });

            case 3:
            case "end":
              return _context31.stop();
          }
        }
      }, _callee31);
    }));

    return function (_x31) {
      return _ref32.apply(this, arguments);
    };
  }());
  t.it('Should not show editRecurrenceButton for non-repeating events when recurrenceCombo is disabled', /*#__PURE__*/function () {
    var _ref33 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee32(t) {
      return regeneratorRuntime.wrap(function _callee32$(_context32) {
        while (1) {
          switch (_context32.prev = _context32.next) {
            case 0:
              _context32.next = 2;
              return setup({
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25),
                enableRecurringEvents: true,
                features: {
                  eventEdit: {
                    items: {
                      recurrenceCombo: null
                    }
                  }
                },
                resources: [{
                  id: 'r1',
                  name: 'test'
                }],
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Bar',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15'
                }]
              });

            case 2:
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                waitForSelector: '.b-eventeditor'
              }, function () {
                t.selectorNotExists('[data-ref="recurrenceCombo"]', 'Repeat combo is disabled');
                t.elementIsNotTopElement('[data-ref="editRecurrenceButton"]', 'Repeat button is hidden');
              });

            case 3:
            case "end":
              return _context32.stop();
          }
        }
      }, _callee32);
    }));

    return function (_x32) {
      return _ref33.apply(this, arguments);
    };
  }());
  t.it('Should show editRecurrenceButton for repeating events when recurrenceCombo is disabled', /*#__PURE__*/function () {
    var _ref34 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee33(t) {
      return regeneratorRuntime.wrap(function _callee33$(_context33) {
        while (1) {
          switch (_context33.prev = _context33.next) {
            case 0:
              _context33.next = 2;
              return setup({
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25),
                enableRecurringEvents: true,
                features: {
                  eventEdit: {
                    items: {
                      recurrenceCombo: null
                    }
                  }
                },
                resources: [{
                  id: 'r1',
                  name: 'test'
                }],
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Bar',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1'
                }]
              });

            case 2:
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                waitForSelector: '.b-eventeditor'
              }, function () {
                t.selectorNotExists('[data-ref="recurrenceCombo"]', 'Repeat combo is disabled');
                t.elementIsTopElement('[data-ref="editRecurrenceButton"]', 'Repeat button is shown');
              });

            case 3:
            case "end":
              return _context33.stop();
          }
        }
      }, _callee33);
    }));

    return function (_x33) {
      return _ref34.apply(this, arguments);
    };
  }());
  t.it('Should show recurrenceCombo when editRecurrenceButton is disabled', /*#__PURE__*/function () {
    var _ref35 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee34(t) {
      return regeneratorRuntime.wrap(function _callee34$(_context34) {
        while (1) {
          switch (_context34.prev = _context34.next) {
            case 0:
              _context34.next = 2;
              return setup({
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25),
                enableRecurringEvents: true,
                features: {
                  eventEdit: {
                    items: {
                      editRecurrenceButton: null
                    }
                  }
                },
                resources: [{
                  id: 'r1',
                  name: 'test'
                }],
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Bar',
                  startDate: '2018-06-14',
                  endDate: '2018-06-15',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1'
                }]
              });

            case 2:
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                waitForSelector: '.b-eventeditor'
              }, function () {
                t.elementIsTopElement('[data-ref="recurrenceCombo"]', 'Repeat combo is shown');
                t.selectorNotExists('[data-ref="editRecurrenceButton"]', 'Repeat button is disabled');
              });

            case 3:
            case "end":
              return _context34.stop();
          }
        }
      }, _callee34);
    }));

    return function (_x34) {
      return _ref35.apply(this, arguments);
    };
  }());
  t.it('Repeat field should be hidden when editor.showRecurringUI is false', /*#__PURE__*/function () {
    var _ref36 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee35(t) {
      return regeneratorRuntime.wrap(function _callee35$(_context35) {
        while (1) {
          switch (_context35.prev = _context35.next) {
            case 0:
              _context35.next = 2;
              return setup({
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25),
                enableRecurringEvents: true,
                features: {
                  eventEdit: {
                    showRecurringUI: false
                  }
                },
                resources: [{
                  id: 'r1',
                  name: 'test'
                }],
                events: [{
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

            case 2:
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                waitForSelector: '.b-eventeditor'
              }, function () {
                t.elementIsNotTopElement('[data-ref="recurrenceCombo"]', 'Repeat field is hidden');
                t.elementIsNotTopElement('[data-ref="editRecurrenceButton"]', 'Repeat button is hidden');
              });

            case 3:
            case "end":
              return _context35.stop();
          }
        }
      }, _callee35);
    }));

    return function (_x35) {
      return _ref36.apply(this, arguments);
    };
  }());
  t.it('Repeat field should be hidden no matter that editor.showRecurringUI is true', /*#__PURE__*/function () {
    var _ref37 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee36(t) {
      return regeneratorRuntime.wrap(function _callee36$(_context36) {
        while (1) {
          switch (_context36.prev = _context36.next) {
            case 0:
              _context36.next = 2;
              return setup({
                startDate: new Date(2018, 5, 11),
                endDate: new Date(2018, 5, 25),
                enableRecurringEvents: false,
                features: {
                  eventEdit: {
                    showRecurringUI: true
                  }
                },
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1',
                    name: 'test'
                  }]
                }),
                eventStore: new EventStore({
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
                })
              });

            case 2:
              t.chain({
                dblclick: '.b-sch-event'
              }, {
                waitForSelector: '.b-eventeditor'
              }, function () {
                t.elementIsNotTopElement('[data-ref="recurrenceCombo"]', 'Repeat field is hidden');
                t.elementIsNotTopElement('[data-ref="editRecurrenceButton"]', 'Repeat button is hidden');
              });

            case 3:
            case "end":
              return _context36.stop();
          }
        }
      }, _callee36);
    }));

    return function (_x36) {
      return _ref37.apply(this, arguments);
    };
  }());
  t.it('Should create correctly while dragging at the top of a row', /*#__PURE__*/function () {
    var _ref38 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee37(t) {
      return regeneratorRuntime.wrap(function _callee37$(_context37) {
        while (1) {
          switch (_context37.prev = _context37.next) {
            case 0:
              scheduler = t.getScheduler({
                events: [],
                features: {
                  eventEdit: {
                    autoClose: false
                  }
                }
              });
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                fromOffset: [2, 2],
                by: [50, 0]
              }, {
                dblclick: '.b-sch-timeaxis-cell',
                offset: [100, 2]
              }, {
                dblclick: '.b-sch-timeaxis-cell',
                offset: [300, 2]
              }, function () {
                return t.selectorCountIs('.b-sch-event-wrap', 1);
              });

            case 2:
            case "end":
              return _context37.stop();
          }
        }
      }, _callee37);
    }));

    return function (_x37) {
      return _ref38.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/346

  t.it('Should be possible to enable fields which are initially disabled', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventEdit: {
          resourceFieldConfig: {
            disabled: true
          }
        }
      }
    });
    t.chain({
      dblclick: '.b-sch-event-wrap[data-event-id="1"]'
    }, {
      waitForSelector: '.b-combo[data-ref="resourceField"]'
    }, function (next) {
      var resourceField = scheduler.features.eventEdit.editor.widgetMap.resourceField;
      t.ok(resourceField.disabled, 'Resource is disabled');
      resourceField.disabled = false;
      t.notOk(resourceField.disabled, 'Resource is not disabled');
      t.notOk(resourceField.readOnly, 'Resource is not read only');
      next();
    }, {
      click: '.b-combo[data-ref="resourceField"] .b-fieldtrigger'
    }, {
      click: '.b-list-item[data-id="r3"]'
    }, {
      click: '.b-button[data-ref="saveButton"]'
    }, function () {
      var rec = scheduler.eventStore.getById(1);
      t.ok(rec.isModified, 'Record is updated');
      t.is(rec.resourceId, 'r3', 'Resource is Don');
    });
  });
  t.it('Should not crash if clicking next/prev time arrows with empty date field', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventEdit: true
      }
    });
    t.chain({
      dblclick: '.b-sch-event-wrap[data-event-id="1"]'
    }, function (next) {
      scheduler.features.eventEdit.editor.widgetMap.startDateField.value = null;
      scheduler.features.eventEdit.editor.widgetMap.endDateField.value = null;
      next();
    }, {
      click: '.b-timefield .b-icon-angle-left'
    }, {
      click: '.b-timefield .b-icon-angle-right'
    });
  }); // https://github.com/bryntum/support/issues/554

  t.it('Should display correct time in event editor', /*#__PURE__*/function () {
    var _ref39 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee38(t) {
      return regeneratorRuntime.wrap(function _callee38$(_context38) {
        while (1) {
          switch (_context38.prev = _context38.next) {
            case 0:
              setup({
                events: [{
                  id: 1,
                  name: 'foo',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 5, 10),
                  endDate: new Date(2011, 0, 5, 23)
                }]
              }, false);
              t.chain({
                doubleClick: '.b-sch-event'
              }, {
                waitForElementVisible: '.b-eventeditor'
              }, function () {
                var editor = scheduler.features.eventEdit;
                t.is(editor.startTimeField.inputValue, '10:00 AM');
                t.is(editor.endTimeField.inputValue, '11:00 PM');
              });

            case 2:
            case "end":
              return _context38.stop();
          }
        }
      }, _callee38);
    }));

    return function (_x38) {
      return _ref39.apply(this, arguments);
    };
  }());
  t.it('Should be possible to hide Delete button in `beforeEventEditShow` listener', /*#__PURE__*/function () {
    var _ref40 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee39(t) {
      return regeneratorRuntime.wrap(function _callee39$(_context39) {
        while (1) {
          switch (_context39.prev = _context39.next) {
            case 0:
              _context39.next = 2;
              return setup({
                listeners: {
                  beforeEventEditShow: function beforeEventEditShow(_ref41) {
                    var eventRecord = _ref41.eventRecord,
                        editor = _ref41.editor,
                        eventEdit = _ref41.eventEdit;
                    editor.widgetMap.deleteButton.hidden = true;
                  }
                },
                events: [{
                  id: 1,
                  name: 'foo',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 5, 10),
                  endDate: new Date(2011, 0, 5, 23)
                }]
              }, false);

            case 2:
              _context39.next = 4;
              return scheduler.editEvent(scheduler.eventStore.first);

            case 4:
              t.elementIsNotVisible('.b-button:textEquals(Delete)', 'Delete button hidden');

            case 5:
            case "end":
              return _context39.stop();
          }
        }
      }, _callee39);
    }));

    return function (_x39) {
      return _ref40.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1373

  t.it('Should not affect time of previously edited events', /*#__PURE__*/function () {
    var _ref42 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee41(t) {
      var _scheduler$eventStore, event1, event2;

      return regeneratorRuntime.wrap(function _callee41$(_context41) {
        while (1) {
          switch (_context41.prev = _context41.next) {
            case 0:
              _context41.next = 2;
              return setup({
                viewPreset: 'hourAndDay',
                events: [{
                  id: 1,
                  name: 'E1',
                  startDate: '2011-01-03T02:00',
                  duration: 2,
                  durationUnit: 'h',
                  resourceId: 'r1'
                }, {
                  id: 2,
                  name: 'E2',
                  startDate: '2011-01-03T02:00',
                  duration: 2,
                  durationUnit: 'h',
                  resourceId: 'r2'
                }, {
                  id: 3,
                  name: 'E3',
                  startDate: '2011-01-03T02:00',
                  duration: 2,
                  durationUnit: 'h',
                  resourceId: 'r3'
                }],
                startDate: '2011-01-03',
                endDate: '2011-01-04'
              }, false);

            case 2:
              _scheduler$eventStore = _slicedToArray(scheduler.eventStore, 2), event1 = _scheduler$eventStore[0], event2 = _scheduler$eventStore[1];
              _context41.next = 5;
              return scheduler.editEvent(event1);

            case 5:
              t.chain({
                type: '08:00[ENTER]',
                target: '[data-ref=startTimeField] input',
                clearExisting: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee40() {
                return regeneratorRuntime.wrap(function _callee40$(_context40) {
                  while (1) {
                    switch (_context40.prev = _context40.next) {
                      case 0:
                        return _context40.abrupt("return", scheduler.editEvent(event2));

                      case 1:
                      case "end":
                        return _context40.stop();
                    }
                  }
                }, _callee40);
              })), {
                type: '09:00[ENTER]',
                target: '[data-ref=startTimeField] input',
                clearExisting: true
              }, function () {
                t.is(event1.startDate, new Date(2011, 0, 3, 8), 'Correct time for E1');
                t.is(event2.startDate, new Date(2011, 0, 3, 9), 'Correct time for E2');
              });

            case 6:
            case "end":
              return _context41.stop();
          }
        }
      }, _callee41);
    }));

    return function (_x40) {
      return _ref42.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1529

  t.it('Initially blank fields should not appear as invalid immediately', /*#__PURE__*/function () {
    var _ref44 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee42(t) {
      return regeneratorRuntime.wrap(function _callee42$(_context42) {
        while (1) {
          switch (_context42.prev = _context42.next) {
            case 0:
              _context42.next = 2;
              return setup({
                viewPreset: 'hourAndDay',
                events: [{
                  id: 1,
                  name: '',
                  startDate: '2011-01-03T02:00',
                  duration: 2,
                  durationUnit: 'h',
                  resourceId: 'r1'
                }],
                startDate: '2011-01-03',
                endDate: '2011-01-04'
              }, false);

            case 2:
              t.chain({
                dblclick: '.b-sch-event-wrap'
              }, {
                waitFor: function waitFor() {
                  var _scheduler$features$e;

                  return (_scheduler$features$e = scheduler.features.eventEdit.editor) === null || _scheduler$features$e === void 0 ? void 0 : _scheduler$features$e.containsFocus;
                }
              }, function (next) {
                // Name field must not be flagged as invalid
                t.hasNotCls(scheduler.features.eventEdit.editor.widgetMap.nameField.element, 'b-invalid');
                next();
              }, {
                type: '[TAB]'
              }, function () {
                // Name field must now be flagged as invalid
                t.hasCls(scheduler.features.eventEdit.editor.widgetMap.nameField.element, 'b-invalid');
              });

            case 3:
            case "end":
              return _context42.stop();
          }
        }
      }, _callee42);
    }));

    return function (_x41) {
      return _ref44.apply(this, arguments);
    };
  }());

  if (t.browser.firefox) {
    // https://github.com/bryntum/support/issues/1611
    t.it('FireFox: Should not be draggable when field is focused', /*#__PURE__*/function () {
      var _ref45 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee43(t) {
        return regeneratorRuntime.wrap(function _callee43$(_context43) {
          while (1) {
            switch (_context43.prev = _context43.next) {
              case 0:
                _context43.next = 2;
                return setup();

              case 2:
                _context43.next = 4;
                return scheduler.editEvent(scheduler.eventStore.first);

              case 4:
                _context43.next = 6;
                return t.click('input');

              case 6:
                t.selectorNotExists('[draggable]', 'Not draggable');
                _context43.next = 9;
                return t.click('.b-field label');

              case 9:
                t.selectorExists('[draggable]', 'Draggable');

              case 10:
              case "end":
                return _context43.stop();
            }
          }
        }, _callee43);
      }));

      return function (_x42) {
        return _ref45.apply(this, arguments);
      };
    }());
  }

  t.it('Event name must not be able to be saved as blank', /*#__PURE__*/function () {
    var _ref46 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee44(t) {
      var name, keys;
      return regeneratorRuntime.wrap(function _callee44$(_context44) {
        while (1) {
          switch (_context44.prev = _context44.next) {
            case 0:
              _context44.next = 2;
              return setup();

            case 2:
              name = scheduler.eventStore.first.name, keys = _toConsumableArray(name).map(function (c) {
                return '[BACKSPACE]';
              }).join('');
              t.chain({
                dblclick: '.b-sch-event-wrap'
              }, {
                waitFor: function waitFor() {
                  var _scheduler$features$e2;

                  return (_scheduler$features$e2 = scheduler.features.eventEdit.editor) === null || _scheduler$features$e2 === void 0 ? void 0 : _scheduler$features$e2.containsFocus;
                }
              }, // Use erase in case we decide to not use clearable:true
              // Note that { type : '', clearExisting : true } doesn't trigger the
              // field's change handling and validation pathway, but typing
              // multiple backspaces does.
              {
                type: keys
              }, {
                click: 'button:contains(Save)'
              }, // Editor must still be visible with the name field invalid
              function () {
                var _scheduler$features$e3;

                t.ok((_scheduler$features$e3 = scheduler.features.eventEdit.editor) === null || _scheduler$features$e3 === void 0 ? void 0 : _scheduler$features$e3.containsFocus);
                t.notOk(scheduler.features.eventEdit.editor.widgetMap.nameField.isValid);
              });

            case 4:
            case "end":
              return _context44.stop();
          }
        }
      }, _callee44);
    }));

    return function (_x43) {
      return _ref46.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1911

  t.it('Should not throw error for disabled startTimeField and endTimeField', /*#__PURE__*/function () {
    var _ref47 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee45(t) {
      return regeneratorRuntime.wrap(function _callee45$(_context45) {
        while (1) {
          switch (_context45.prev = _context45.next) {
            case 0:
              _context45.next = 2;
              return setup({
                features: {
                  eventEdit: {
                    items: {
                      startTimeField: false,
                      endTimeField: false
                    }
                  }
                }
              });

            case 2:
              t.doubleClick('.b-sch-event-wrap');

            case 3:
            case "end":
              return _context45.stop();
          }
        }
      }, _callee45);
    }));

    return function (_x44) {
      return _ref47.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1752

  t.it('Should not throw error when disable date and time fields', /*#__PURE__*/function () {
    var _ref48 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee46(t) {
      return regeneratorRuntime.wrap(function _callee46$(_context46) {
        while (1) {
          switch (_context46.prev = _context46.next) {
            case 0:
              _context46.next = 2;
              return setup({
                features: {
                  eventEdit: {
                    items: {
                      startDateField: false,
                      startTimeField: false,
                      endDateField: false,
                      endTimeField: false
                    }
                  }
                }
              });

            case 2:
              t.doubleClick('.b-sch-event-wrap');

            case 3:
            case "end":
              return _context46.stop();
          }
        }
      }, _callee46);
    }));

    return function (_x45) {
      return _ref48.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1752

  t.it('Should not throw error when disable only startDateField', /*#__PURE__*/function () {
    var _ref49 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee47(t) {
      return regeneratorRuntime.wrap(function _callee47$(_context47) {
        while (1) {
          switch (_context47.prev = _context47.next) {
            case 0:
              _context47.next = 2;
              return setup({
                features: {
                  eventEdit: {
                    items: {
                      startDateField: false
                    }
                  }
                }
              });

            case 2:
              t.doubleClick('.b-sch-event-wrap');

            case 3:
            case "end":
              return _context47.stop();
          }
        }
      }, _callee47);
    }));

    return function (_x46) {
      return _ref49.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1752

  t.it('Should not throw error when disable only startTimeField', /*#__PURE__*/function () {
    var _ref50 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee48(t) {
      return regeneratorRuntime.wrap(function _callee48$(_context48) {
        while (1) {
          switch (_context48.prev = _context48.next) {
            case 0:
              _context48.next = 2;
              return setup({
                features: {
                  eventEdit: {
                    items: {
                      startTimeField: false
                    }
                  }
                }
              });

            case 2:
              t.doubleClick('.b-sch-event-wrap');

            case 3:
            case "end":
              return _context48.stop();
          }
        }
      }, _callee48);
    }));

    return function (_x47) {
      return _ref50.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1752

  t.it('Should not throw error when disable only endDateField', /*#__PURE__*/function () {
    var _ref51 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee49(t) {
      return regeneratorRuntime.wrap(function _callee49$(_context49) {
        while (1) {
          switch (_context49.prev = _context49.next) {
            case 0:
              _context49.next = 2;
              return setup({
                features: {
                  eventEdit: {
                    items: {
                      endDateField: false
                    }
                  }
                }
              });

            case 2:
              t.doubleClick('.b-sch-event-wrap');

            case 3:
            case "end":
              return _context49.stop();
          }
        }
      }, _callee49);
    }));

    return function (_x48) {
      return _ref51.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1752

  t.it('Should not throw error when disable only endTimeField', /*#__PURE__*/function () {
    var _ref52 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee50(t) {
      return regeneratorRuntime.wrap(function _callee50$(_context50) {
        while (1) {
          switch (_context50.prev = _context50.next) {
            case 0:
              _context50.next = 2;
              return setup({
                features: {
                  eventEdit: {
                    items: {
                      endTimeField: false
                    }
                  }
                }
              });

            case 2:
              t.doubleClick('.b-sch-event-wrap');

            case 3:
            case "end":
              return _context50.stop();
          }
        }
      }, _callee50);
    }));

    return function (_x49) {
      return _ref52.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2030

  t.it('Should handle returning false from beforeEventAdd', /*#__PURE__*/function () {
    var _ref53 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee51(t) {
      return regeneratorRuntime.wrap(function _callee51$(_context51) {
        while (1) {
          switch (_context51.prev = _context51.next) {
            case 0:
              _context51.next = 2;
              return setup({
                events: [],
                listeners: {
                  beforeEventAdd: function beforeEventAdd() {
                    return false;
                  },
                  once: true
                }
              });

            case 2:
              _context51.next = 4;
              return t.doubleClick('.b-sch-timeaxis-cell');

            case 4:
              _context51.next = 6;
              return t.type(null, 'foo[ENTER][ESC]');

            case 6:
              t.selectorNotExists(scheduler.unreleasedEventSelector, 'beforeEventAdd blocked the add');
              t.is(scheduler.eventStore.count, 0, 'No event record added');
              t.is(scheduler.assignmentStore.count, 0, 'No assignment record added');
              _context51.next = 11;
              return t.doubleClick('.b-sch-timeaxis-cell');

            case 11:
              _context51.next = 13;
              return t.type(null, 'bar[ENTER]');

            case 13:
              t.selectorExists(scheduler.unreleasedEventSelector + ':contains(bar)', 'Event added normally');

            case 14:
            case "end":
              return _context51.stop();
          }
        }
      }, _callee51);
    }));

    return function (_x50) {
      return _ref53.apply(this, arguments);
    };
  }());
  t.it('Should close editor if edited Event is removed while editing', /*#__PURE__*/function () {
    var _ref54 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee52(t) {
      return regeneratorRuntime.wrap(function _callee52$(_context52) {
        while (1) {
          switch (_context52.prev = _context52.next) {
            case 0:
              _context52.next = 2;
              return setup({}, false);

            case 2:
              _context52.next = 4;
              return scheduler.editEvent(scheduler.eventStore.first);

            case 4:
              scheduler.eventStore.first.remove();
              _context52.next = 7;
              return t.waitFor(function () {
                return !scheduler.features.eventEdit.editor.isVisible;
              });

            case 7:
            case "end":
              return _context52.stop();
          }
        }
      }, _callee52);
    }));

    return function (_x51) {
      return _ref54.apply(this, arguments);
    };
  }());
  t.it('Should fire just add event after creating new event', /*#__PURE__*/function () {
    var _ref55 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee53(t) {
      return regeneratorRuntime.wrap(function _callee53$(_context53) {
        while (1) {
          switch (_context53.prev = _context53.next) {
            case 0:
              _context53.next = 2;
              return setup({}, false);

            case 2:
              t.firesOnce(scheduler.eventStore, 'add');
              t.firesOnce(scheduler.eventStore, 'update');
              t.wontFire(scheduler.eventStore, 'remove');
              _context53.next = 7;
              return t.doubleClick('.b-grid-subgrid-normal .b-sch-timeaxis-cell');

            case 7:
              _context53.next = 9;
              return t.type(null, 'foo');

            case 9:
              _context53.next = 11;
              return t.click('button:contains(Save)');

            case 11:
            case "end":
              return _context53.stop();
          }
        }
      }, _callee53);
    }));

    return function (_x52) {
      return _ref55.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2340

  t.it('Should remove event when all resources are removed for multi assigned task', /*#__PURE__*/function () {
    var _ref56 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee54(t) {
      return regeneratorRuntime.wrap(function _callee54$(_context54) {
        while (1) {
          switch (_context54.prev = _context54.next) {
            case 0:
              _context54.next = 2;
              return setup({
                events: [{
                  id: 1,
                  startDate: '2011-01-04',
                  endDate: '2011-01-05',
                  name: 'Multi assigned A'
                }, {
                  id: 2,
                  startDate: '2011-01-06',
                  endDate: '2011-01-07',
                  name: 'Multi assigned B'
                }],
                assignments: [{
                  id: 1,
                  resourceId: 'r1',
                  eventId: 1
                }, {
                  id: 2,
                  resourceId: 'r3',
                  eventId: 1
                }, {
                  id: 3,
                  resourceId: 'r5',
                  eventId: 1
                }, {
                  id: 4,
                  resourceId: 'r2',
                  eventId: 2
                }, {
                  id: 5,
                  resourceId: 'r4',
                  eventId: 2
                }]
              });

            case 2:
              t.chain({
                dblclick: '.b-sch-event-wrap[data-event-id="1"]'
              }, {
                waitFor: function waitFor() {
                  var _scheduler$features$e4;

                  return (_scheduler$features$e4 = scheduler.features.eventEdit.editor) === null || _scheduler$features$e4 === void 0 ? void 0 : _scheduler$features$e4.containsFocus;
                }
              }, {
                click: '[data-id="r1"] .b-icon-clear'
              }, {
                click: '[data-id="r3"] .b-icon-clear'
              }, {
                click: '[data-id="r5"] .b-icon-clear'
              }, {
                click: 'button:contains(Save)'
              }, {
                waitFor: function waitFor() {
                  return !scheduler.eventStore.getById(1);
                },
                desc: 'All resources were removed from event and the event was removed'
              });

            case 3:
            case "end":
              return _context54.stop();
          }
        }
      }, _callee54);
    }));

    return function (_x53) {
      return _ref56.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/3021

  t.it('Should invalidate field / editor when end date is before start date', /*#__PURE__*/function () {
    var _ref57 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee55(t) {
      var editFeature;
      return regeneratorRuntime.wrap(function _callee55$(_context55) {
        while (1) {
          switch (_context55.prev = _context55.next) {
            case 0:
              _context55.next = 2;
              return setup();

            case 2:
              editFeature = scheduler.features.eventEdit;
              t.chain({
                doubleClick: '.FOO'
              }, {
                waitForSelector: '.b-eventeditor:not(.b-hidden)'
              }, {
                type: '01/05/2010[ENTER]',
                target: '[name=endDate]',
                clearExisting: true
              }, {
                click: 'button:contains(Save)'
              }, function () {
                t.is(editFeature.endDateField.isValid, false, 'End date field is invalid');
                t.is(editFeature.editor.isVisible, true, 'Editor is still open');
              });

            case 4:
            case "end":
              return _context55.stop();
          }
        }
      }, _callee55);
    }));

    return function (_x54) {
      return _ref57.apply(this, arguments);
    };
  }());
});