function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

/*global zipcelx:true*/

/*eslint no-undef: "error"*/

/*eslint no-unused-vars: ["error", { "vars": "local" }]*/
StartTest(function (t) {
  t.expectGlobals('zipcelx');
  var scheduler;
  t.beforeEach(function () {
    return scheduler && scheduler.destroy();
  });

  function setup() {
    return _setup.apply(this, arguments);
  }

  function _setup() {
    _setup = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8() {
      var cfg,
          _args8 = arguments;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              cfg = _args8.length > 0 && _args8[0] !== undefined ? _args8[0] : {};
              _context8.next = 3;
              return t.getSchedulerAsync(Object.assign({
                columns: [{
                  text: 'Name',
                  field: 'name'
                }, {
                  text: 'Country',
                  field: 'country'
                }],
                features: {
                  group: 'name',
                  excelExporter: true
                },
                resources: [{
                  id: 1,
                  name: 'Johan',
                  country: 'Sweden'
                }, {
                  id: 2,
                  name: 'Mats',
                  country: 'Sweden'
                }, {
                  id: 3,
                  name: 'Arcady',
                  country: 'Russia'
                }],
                startDate: new Date(2017, 1, 7),
                endDate: new Date(2017, 1, 9),
                events: [{
                  resourceId: 1,
                  name: 'Prepare campaign',
                  startDate: '2017-02-07 12:00',
                  duration: 3,
                  durationUnit: 'h'
                }, {
                  resourceId: 'nonexisting',
                  name: 'Foo',
                  startDate: '2017-02-07 12:00',
                  duration: 3,
                  durationUnit: 'h'
                }]
              }, cfg));

            case 3:
              scheduler = _context8.sent;

            case 4:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));
    return _setup.apply(this, arguments);
  }

  t.it('Exporting a grouped Grid should work', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              window.zipcelx = function (obj) {
                // 1 for each row, + 1 group header for each row, + column header row
                t.is(obj.sheet.data.length, 9);
                t.is(obj.sheet.data[1][0].value, 'Arcady (1)');
                t.is(obj.sheet.data[1][1].value, '');
                t.is(obj.sheet.data[7][2].value, 'No resource assigned');
                t.is(obj.sheet.data[8][2].value, 'Foo');
              };

              _context.next = 3;
              return setup();

            case 3:
              scheduler.features.excelExporter.export();

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
  t.it('Exporting a Grid with group summaries should work', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              window.zipcelx = function (obj) {
                // 1 for each row, + 1 group header for each row, + column header row
                t.is(obj.sheet.data.length, 9);
                t.is(obj.sheet.data[1][0].value, 'Arcady (1)');
                t.is(obj.sheet.data[1][1].value, '');
                t.is(obj.sheet.data[7][2].value, 'No resource assigned');
                t.is(obj.sheet.data[8][2].value, 'Foo');
              };

              _context2.next = 3;
              return setup({
                features: {
                  group: 'name',
                  excelExporter: true,
                  groupSummary: {
                    summaries: [{
                      label: 'Count',
                      renderer: function renderer(_ref3) {
                        var events = _ref3.events;
                        return events.length;
                      }
                    }]
                  }
                }
              });

            case 3:
              scheduler.features.excelExporter.export();

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
  t.it('Exporting a grouped Grid with collapsed row should work', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              window.zipcelx = function (obj) {
                // 1 for each row, + 1 group header for each row, + column header row
                t.is(obj.sheet.data.length, 8);
                t.is(obj.sheet.data[3][0].value, 'Johan (1)');
                t.is(obj.sheet.data[3][1].value, '');
                t.is(obj.sheet.data[4][0].value, 'Mats (1)');
                t.is(obj.sheet.data[4][1].value, '');
                t.is(obj.sheet.data[6][2].value, 'No resource assigned');
                t.is(obj.sheet.data[7][2].value, 'Foo');
              };

              _context3.next = 3;
              return setup();

            case 3:
              // collapse row with event
              scheduler.features.group.toggleCollapse(scheduler.store.getAt(2));
              scheduler.features.excelExporter.export();

            case 5:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should not export not assigned events', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              window.zipcelx = function (obj) {
                // 1 for each row, + 1 group header for each row, + column header row
                t.is(obj.sheet.data.length, 7);
                t.is(obj.sheet.data[5][0].value, 'Mats (1)');
                t.is(obj.sheet.data[5][1].value, '');
              };

              _context4.next = 3;
              return setup({
                features: {
                  group: 'name',
                  excelExporter: {
                    exporterConfig: {
                      includeUnassigned: false
                    }
                  }
                }
              });

            case 3:
              scheduler.features.excelExporter.export();

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Exporting a grouped Scheduler with renderer function returning content should work', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              window.zipcelx = function (obj) {
                // 1 for each row, + 1 group header for each row, + column header row
                t.is(obj.sheet.data.length, 9);
                t.is(obj.sheet.data[1][0].value, 'foo Arcady (1)');
                t.is(obj.sheet.data[1][1].value, '');
              };

              _context5.next = 3;
              return setup({
                columns: [{
                  text: 'Name',
                  field: 'name',
                  groupRenderer: function groupRenderer(_ref7) {
                    var groupRowFor = _ref7.groupRowFor,
                        record = _ref7.record;
                    return "foo ".concat(groupRowFor, " (").concat(record.meta.childCount, ")");
                  }
                }, {
                  text: 'Country',
                  field: 'country'
                }]
              });

            case 3:
              scheduler.features.excelExporter.export();

            case 4:
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
  t.it('Exporting a grouped Grid with renderer function changing cell element should work', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              window.zipcelx = function (obj) {
                // 1 for each row, + 1 group header for each row, + column header row
                t.is(obj.sheet.data.length, 9);
                t.is(obj.sheet.data[1][0].value, 'foo Arcady (1)');
                t.is(obj.sheet.data[1][1].value, '');
              };

              _context6.next = 3;
              return setup({
                columns: [{
                  text: 'Name',
                  field: 'name',
                  groupRenderer: function groupRenderer(_ref9) {
                    var cellElement = _ref9.cellElement,
                        groupRowFor = _ref9.groupRowFor,
                        record = _ref9.record;
                    cellElement.innerHTML = "foo ".concat(groupRowFor, " (").concat(record.meta.childCount, ")");
                  }
                }, {
                  text: 'Country',
                  field: 'country'
                }]
              });

            case 3:
              scheduler.features.excelExporter.export();

            case 4:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref8.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1763

  t.it('Should export the columns correctly according with configs defined on call export function', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              window.zipcelx = function (obj) {
                // 1 for each row, + 1 group header for each row, + column header row
                t.is(obj.filename, 'Custom export', 'Custom filename is correct');
                t.is(obj.sheet.cols.length, 4, 'Total columns to export is correct');
                t.is(obj.sheet.data[1][2].value, '07/02/2017 12:00', 'dateFormat config was applied');
                t.is(obj.sheet.cols[0].value, 'Resource Custom', 'Resource column custom text applied');
                t.is(obj.sheet.cols[1].value, 'Task Custom', 'Event column custom text applied');
              };

              _context7.next = 3;
              return setup({
                features: {
                  group: false,
                  excelExporter: true
                }
              });

            case 3:
              scheduler.features.excelExporter.export({
                filename: 'Custom export',
                dateFormat: 'DD/MM/YYYY HH:mm',
                exporterConfig: {
                  columns: [{
                    text: 'Resource Custom',
                    field: 'name'
                  }],
                  eventColumns: [{
                    text: 'Task Custom',
                    field: 'name'
                  }, {
                    text: 'Starts',
                    field: 'startDate'
                  }, {
                    text: 'Ends',
                    field: 'endDate'
                  }]
                }
              });

            case 4:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x7) {
      return _ref10.apply(this, arguments);
    };
  }());
});