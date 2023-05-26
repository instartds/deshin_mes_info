function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });
  Object.assign(window, {
    Scheduler: Scheduler,
    EventStore: EventStore,
    ResourceStore: ResourceStore,
    DependencyStore: DependencyStore,
    PresetManager: PresetManager
  });
  t.it('Should validate time range in dialog', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler = t.getScheduler({
                startDate: new Date(2020, 6, 19),
                endDate: new Date(2020, 6, 26),
                features: {
                  pdfExport: {
                    exportServer: '/export'
                  }
                }
              });
              _context2.next = 3;
              return scheduler.features.pdfExport.showExportDialog();

            case 3:
              t.chain({
                click: '.b-schedulerangecombo'
              }, {
                click: 'div:contains(Date range)'
              }, {
                waitForSelector: '[data-ref="rangeStartField"]'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                var startDateField, endDateField;
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        startDateField = document.querySelector('[data-ref="rangeStartField"] .b-field-inner'), endDateField = document.querySelector('[data-ref="rangeEndField"] .b-field-inner');
                        t.isGreaterOrEqual(startDateField.offsetWidth, 80, 'Start date field has some width');
                        t.isGreaterOrEqual(endDateField.offsetWidth, 80, 'End date field has some width');

                      case 3:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })), {
                click: '[data-ref="rangeStartField"] .b-icon-calendar',
                desc: 'Expand first picker'
              }, {
                waitForSelector: '.b-calendar-cell.b-out-of-range:contains(26)',
                desc: 'Max value is set'
              }, {
                click: '[data-ref="rangeEndField"] .b-icon-calendar',
                desc: 'Expand second picker'
              }, {
                waitForSelector: '.b-calendar-cell.b-out-of-range:contains(17)',
                desc: 'Min value is set'
              }, {
                click: '.b-calendar-cell:contains(23)',
                desc: 'Change end date, this should set new max'
              }, {
                click: '[data-ref="rangeStartField"] .b-icon-calendar'
              }, {
                waitForSelector: '.b-calendar-cell.b-out-of-range:contains(23)',
                desc: 'Max value is updated'
              }, {
                click: '.b-calendar-cell:contains(21)',
                desc: 'Change start date, this should set new min'
              }, {
                click: '[data-ref="rangeEndField"] .b-icon-calendar'
              }, {
                waitForSelector: '.b-calendar-cell.b-out-of-range:contains(21)',
                desc: 'Min value is updated'
              });

            case 4:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Hidden columns should not be selected', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              scheduler = t.getScheduler({
                startDate: new Date(2020, 6, 19),
                endDate: new Date(2020, 6, 26),
                features: {
                  pdfExport: {
                    exportServer: '/export'
                  }
                },
                columns: [{
                  field: 'name',
                  id: 'name',
                  text: 'name'
                }, {
                  field: 'color',
                  id: 'color',
                  text: 'color'
                }, {
                  field: 'age',
                  id: 'age',
                  text: 'age',
                  hidden: true
                }]
              });
              _context3.next = 3;
              return scheduler.features.pdfExport.showExportDialog();

            case 3:
              _context3.next = 5;
              return t.waitForSelector('.b-chip');

            case 5:
              t.selectorCountIs('.b-chip[data-id="age"]', 0, 'Age column is not available for export');
              _context3.next = 8;
              return t.click('.b-fieldtrigger');

            case 8:
              _context3.next = 10;
              return t.waitForSelector('.b-list-item:contains(age)');

            case 10:
              _context3.next = 12;
              return t.click('button:contains(Cancel)');

            case 12:
              scheduler.columns.getAt(1).hidden = true;
              _context3.next = 15;
              return scheduler.features.pdfExport.showExportDialog();

            case 15:
              _context3.next = 17;
              return t.waitForSelector('.b-chip');

            case 17:
              t.selectorCountIs('.b-chip[data-id="color"]', 0, 'Color column is not available for export');
              t.selectorCountIs('.b-chip[data-id="age"]', 0, 'Age column is not available for export');
              _context3.next = 21;
              return t.click('.b-fieldtrigger');

            case 21:
              _context3.next = 23;
              return t.waitForSelector('.b-list-item:contains(color)');

            case 23:
              _context3.next = 25;
              return t.waitForSelector('.b-list-item:contains(age)');

            case 25:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x2) {
      return _ref3.apply(this, arguments);
    };
  }());
});