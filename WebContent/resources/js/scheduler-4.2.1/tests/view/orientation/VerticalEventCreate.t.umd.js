function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
  });
  t.it('Should create event on dblclick on schedule', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getVerticalSchedulerAsync({
                startDate: new Date(2019, 0, 1, 6),
                endDate: new Date(2019, 0, 1, 18),
                viewPreset: 'hourAndDay',
                events: [],
                features: {
                  eventEdit: false
                }
              });

            case 2:
              scheduler = _context.sent;
              t.chain({
                dblClick: '.b-sch-timeaxis-cell',
                offset: [100, 100]
              }, {
                waitForSelector: '.b-sch-event'
              }, function (next) {
                t.is(scheduler.eventStore.first.startDate, new Date(2019, 0, 1, 7, 30), 'Correct start date');
                t.is(scheduler.eventStore.first.resource, scheduler.resourceStore.first, 'Correct resource');
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
  t.it('Should properly append event', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getVerticalSchedulerAsync({
                startDate: new Date(2019, 0, 1, 6),
                endDate: new Date(2019, 0, 1, 18),
                viewPreset: 'hourAndDay',
                events: [{
                  id: 1,
                  name: 'Event 1',
                  resourceId: 'r4',
                  startDate: new Date(2019, 0, 1, 10),
                  endDate: new Date(2019, 0, 1, 12)
                }],
                width: 400,
                resourceColumns: {
                  columnWidth: 100
                }
              });

            case 2:
              scheduler = _context3.sent;
              t.chain({
                waitForSelector: '.b-sch-event'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        scheduler.subGrids.locked.width = 200;

                      case 1:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              })), {
                waitForSelector: '.b-released'
              }, {
                dblClick: '.b-sch-timeaxis-cell',
                offset: [50, 100]
              }, {
                waitFor: function waitFor() {
                  return scheduler.features.eventEdit.editor.containsFocus;
                }
              }, {
                type: 'New test event'
              }, {
                type: '[ENTER]'
              }, {
                waitForSelector: '.b-sch-event'
              }, function (next) {
                t.is(scheduler.eventStore.last.startDate, new Date(2019, 0, 1, 7, 30), 'Correct start date');
                t.is(scheduler.eventStore.last.resource, scheduler.resourceStore.first, 'Correct resource');
              });

            case 4:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Dragcreate proxy should be removed if event is edited to be outside of time axis', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var editorWidgetMap;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getVerticalSchedulerAsync({
                startDate: new Date(2019, 0, 1, 6),
                endDate: new Date(2019, 0, 1, 18),
                viewPreset: 'hourAndDay',
                events: []
              });

            case 2:
              scheduler = _context4.sent;
              t.chain({
                dblclick: '.b-grid-cell.b-sch-timeaxis-cell',
                offset: [75, 45]
              }, {
                waitFor: function waitFor() {
                  editorWidgetMap = scheduler.features.eventEdit.editor.widgetMap;
                  return editorWidgetMap.nameField.containsFocus;
                }
              }, {
                type: 'New Event'
              }, {
                click: function click() {
                  return editorWidgetMap.startDateField.input;
                }
              }, // Make it far into the future, outside the timeAxis
              {
                type: '31/12/2030',
                clearExisting: true
              }, // Save it
              {
                click: function click() {
                  return scheduler.features.eventEdit.editor.widgetMap.saveButton.element;
                }
              }, // Wait for editor to have gone
              {
                waitFor: function waitFor() {
                  return !scheduler.features.eventEdit.editor.isVisible;
                }
              }, function () {
                // The event is in the store
                t.is(scheduler.eventStore.count, 1); // But it's outside the visible timeaxis, so there must be no rendered event elements.

                t.is(scheduler.timeAxisSubGridElement.querySelectorAll(scheduler.eventSelector).length, 0);
              });

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x3) {
      return _ref4.apply(this, arguments);
    };
  }());
});