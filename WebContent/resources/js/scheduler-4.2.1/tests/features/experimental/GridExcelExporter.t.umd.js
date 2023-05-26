function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

/*global zipcelx:true*/

/*eslint no-undef: "error"*/

/*eslint no-unused-vars: ["error", { "vars": "local" }]*/
StartTest(function (t) {
  t.expectGlobals('zipcelx');
  var grid;
  Object.assign(window, {
    Grid: Grid,
    DataGenerator: DataGenerator
  });
  t.beforeEach(function () {
    return grid && grid.destroy();
  });
  t.it('Exporting a grouped Grid should work', function (t) {
    window.zipcelx = function (obj) {
      // 1 for each row, + 1 group header for each row, + column header row
      t.is(obj.sheet.data.length, 7);
      t.is(obj.sheet.data[1][0].value, 'Arcady (1)');
      t.is(obj.sheet.data[1][1].value, '');
    };

    grid = t._getGrid({
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
      data: [{
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
      }]
    });
    grid.features.excelExporter.export();
  });
  t.it('Exporting a grouped Grid with collapsed row should work', function (t) {
    window.zipcelx = function (obj) {
      // 1 for each row, + 1 group header for each row, + column header row
      t.is(obj.sheet.data.length, 6);
      t.is(obj.sheet.data[1][0].value, 'Arcady (1)');
      t.is(obj.sheet.data[1][1].value, '');
      t.is(obj.sheet.data[2][0].value, 'Johan (1)');
      t.is(obj.sheet.data[2][1].value, '');
    };

    grid = t._getGrid({
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
      data: [{
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
      }]
    });
    grid.features.group.toggleCollapse(grid.store.first);
    grid.features.excelExporter.export();
  });
  t.it('Exporting a checkbox column should produce checkmark unicode symbol', function (t) {
    window.zipcelx = function (obj) {
      // 1 for each row + header
      t.is(obj.sheet.data.length, 4);
      var rows = obj.sheet.data.map(function (row) {
        return row.map(function (cell) {
          return String(cell.value);
        });
      });
      t.isDeeply(rows, [['Name', 'Swede?'], ['Johan', '✓'], ['Mats', '✓'], ['Arcady', '']]);
    };

    grid = t._getGrid({
      columns: [{
        text: 'Name',
        field: 'name'
      }, {
        text: 'Swede?',
        type: 'check',
        field: 'swede'
      }],
      features: {
        excelExporter: true
      },
      store: {
        fields: ['name', {
          name: 'swede',
          type: 'boolean'
        }],
        data: [{
          id: 1,
          name: 'Johan',
          swede: true
        }, {
          id: 2,
          name: 'Mats',
          swede: true
        }, {
          id: 3,
          name: 'Arcady',
          swede: false
        }]
      }
    });
    grid.features.excelExporter.export();
  });
  t.it('Exporting a grouped Grid with renderer function returning content should work', function (t) {
    window.zipcelx = function (obj) {
      // 1 for each row, + 1 group header for each row, + column header row
      t.is(obj.sheet.data.length, 7);
      t.is(obj.sheet.data[1][0].value, 'foo Arcady (1)');
      t.is(obj.sheet.data[1][1].value, '');
    };

    grid = t._getGrid({
      columns: [{
        text: 'Name',
        field: 'name',
        groupRenderer: function groupRenderer(_ref) {
          var groupRowFor = _ref.groupRowFor,
              record = _ref.record;
          return "foo ".concat(groupRowFor, " (").concat(record.meta.childCount, ")");
        }
      }, {
        text: 'Country',
        field: 'country'
      }],
      features: {
        group: 'name',
        excelExporter: true
      },
      data: [{
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
      }]
    });
    grid.features.excelExporter.export();
  });
  t.it('Exporting a grouped Grid with renderer function changing cell element should work', function (t) {
    window.zipcelx = function (obj) {
      // 1 for each row, + 1 group header for each row, + column header row
      t.is(obj.sheet.data.length, 7);
      t.is(obj.sheet.data[1][0].value, 'foo Arcady (1)');
      t.is(obj.sheet.data[1][1].value, '');
    };

    grid = t._getGrid({
      columns: [{
        text: 'Name',
        field: 'name',
        groupRenderer: function groupRenderer(_ref2) {
          var cellElement = _ref2.cellElement,
              groupRowFor = _ref2.groupRowFor,
              record = _ref2.record;
          cellElement.innerHTML = "foo ".concat(groupRowFor, " (").concat(record.meta.childCount, ")");
        }
      }, {
        text: 'Country',
        field: 'country'
      }],
      features: {
        group: 'name',
        excelExporter: true
      },
      data: [{
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
      }]
    });
    grid.features.excelExporter.export();
  });
  t.it('Date is formatted during export', function (t) {
    var expected;

    window.zipcelx = function (_ref3) {
      var sheet = _ref3.sheet;
      t.is(sheet.data[1][0].value, expected, 'Date is exported in correct format');
    };

    grid = new Grid({
      appendTo: document.body,
      store: {
        fields: [{
          name: 'name',
          type: 'string'
        }, {
          name: 'age',
          type: 'number'
        }, {
          name: 'date',
          type: 'date'
        }, {
          name: 'processed',
          type: 'boolean'
        }],
        data: [{
          name: 'Andy',
          age: '30',
          date: '2019-09-02',
          processed: true
        }]
      },
      features: {
        excelExporter: true
      },
      columns: [{
        text: 'Name',
        field: 'name'
      }, {
        text: 'Age',
        field: 'age'
      }, {
        text: 'Age (ignored)',
        field: 'age',
        exportable: false
      }, {
        text: 'Date',
        field: 'date',
        type: 'date',
        format: 'DD-MM-YYYY'
      }, {
        text: 'Processed',
        field: 'processed'
      }]
    });
    expected = '2019';
    grid.features.excelExporter.export({
      exporterConfig: {
        columns: ['date']
      },
      dateFormat: 'YYYY'
    });
    expected = '2019-09-02';
    grid.features.excelExporter.export({
      exporterConfig: {
        columns: ['date']
      }
    });
    expected = '02-09-2019';
    grid.features.excelExporter.export({
      exporterConfig: {
        columns: ['date'],
        exportDateAsInstance: false
      }
    });
  }); // https://github.com/bryntum/support/issues/1763

  t.it('Should export the columns correctly according with configs defined on call export function', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              window.zipcelx = function (obj) {
                // 1 for each row, + 1 group header for each row, + column header row
                t.is(obj.filename, 'Custom export', 'Custom filename is correct');
                t.is(obj.sheet.cols.length, 2, 'Total columns to export is correct');
                t.is(obj.sheet.data[1][1].value, '02/09/2020 10:30', 'dateFormat config was applied');
                t.is(obj.sheet.cols[1].value, 'Date Custom', 'Column custom text applied');
              };

              grid = t._getGrid({
                store: {
                  fields: [{
                    name: 'name',
                    type: 'string'
                  }, {
                    name: 'date',
                    type: 'date'
                  }],
                  data: [{
                    id: 1,
                    name: 'Johan',
                    country: 'Sweden',
                    date: '2020-09-02 10:30:40'
                  }, {
                    id: 2,
                    name: 'Mats',
                    country: 'Sweden',
                    date: '2020-09-03 10:40:40'
                  }, {
                    id: 3,
                    name: 'Arcady',
                    country: 'Russia',
                    date: '2020-09-04 10:50:40'
                  }]
                },
                columns: [{
                  text: 'Name',
                  field: 'name'
                }, {
                  text: 'Country',
                  field: 'country'
                }],
                features: {
                  excelExporter: true
                }
              });
              grid.features.excelExporter.export({
                filename: 'Custom export',
                dateFormat: 'DD/MM/YYYY HH:mm',
                exporterConfig: {
                  columns: [{
                    text: 'Name Custom',
                    field: 'name'
                  }, {
                    text: 'Date Custom',
                    field: 'date'
                  }]
                }
              });

            case 3:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref4.apply(this, arguments);
    };
  }());
});