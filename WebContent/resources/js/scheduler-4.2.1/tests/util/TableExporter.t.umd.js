function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, exporter;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
    exporter && exporter.destroy();
  });
  t.it('Should export events', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var _exporter$export, rows, columns;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: '2019-09-01',
                columns: [{
                  text: 'Name',
                  field: 'name'
                }],
                resources: [{
                  id: 1,
                  name: 'Albert'
                }, {
                  id: 2,
                  name: 'Ben'
                }],
                events: [{
                  resourceId: 1,
                  name: 'Task 1',
                  startDate: '2019-09-05',
                  endDate: '2019-09-07'
                }, {
                  resourceId: 1,
                  name: 'Task 2',
                  startDate: '2019-09-06',
                  endDate: '2019-09-07'
                }, {
                  resourceId: 2,
                  name: 'Task 3',
                  startDate: '2019-09-07',
                  endDate: '2019-09-09'
                }, {
                  resourceId: 2,
                  name: 'Task 4',
                  startDate: '2019-09-08',
                  endDate: '2019-09-09'
                }]
              });
              exporter = new ScheduleTableExporter({
                target: scheduler
              });
              _context.next = 4;
              return t.waitForProjectReady();

            case 4:
              _exporter$export = exporter.export(), rows = _exporter$export.rows, columns = _exporter$export.columns;
              rows = rows.map(function (row) {
                return row.map(function (cell) {
                  return cell instanceof Date ? DateHelper.format(cell, 'YYYY-MM-DD') : cell;
                });
              });
              t.isDeeply(rows, [['Albert', 'Task 1', '2019-09-05', '2019-09-07'], ['Albert', 'Task 2', '2019-09-06', '2019-09-07'], ['Ben', 'Task 3', '2019-09-07', '2019-09-09'], ['Ben', 'Task 4', '2019-09-08', '2019-09-09']], 'Rows are ok');
              t.isDeeply(columns, [{
                field: 'name',
                value: 'Name',
                width: 100,
                type: 'string'
              }, {
                field: 'name',
                value: 'Task',
                eventColumn: true,
                width: 100,
                type: 'string'
              }, {
                field: 'startDate',
                value: 'Starts',
                eventColumn: true,
                width: 140,
                type: 'date'
              }, {
                field: 'endDate',
                value: 'Ends',
                eventColumn: true,
                width: 140,
                type: 'date'
              }], 'Columns are ok');

            case 8:
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
  t.it('Exporting unassigned events', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var _exporter$export2, rows, columns, _exporter$export3;

      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                columns: [{
                  text: 'Name',
                  field: 'name'
                }],
                resources: [{
                  id: 1,
                  name: 'Albert'
                }, {
                  id: 2,
                  name: 'Ben'
                }],
                events: [{
                  resourceId: 1,
                  name: 'Task 1',
                  startDate: '2019-09-05',
                  endDate: '2019-09-07'
                }, {
                  resourceId: 2,
                  name: 'Task 2',
                  startDate: '2019-09-06',
                  endDate: '2019-09-07'
                }, {
                  name: 'Task 3',
                  startDate: '2019-09-07',
                  endDate: '2019-09-09'
                }, {
                  name: 'Task 4',
                  startDate: '2019-09-08',
                  endDate: '2019-09-09'
                }]
              });
              exporter = new ScheduleTableExporter({
                target: scheduler
              });
              _context2.next = 4;
              return t.waitForProjectReady();

            case 4:
              _exporter$export2 = exporter.export({
                includeUnassigned: false
              }), rows = _exporter$export2.rows, columns = _exporter$export2.columns;
              rows = rows.map(function (row) {
                return row.map(function (cell) {
                  return cell instanceof Date ? DateHelper.format(cell, 'YYYY-MM-DD') : cell;
                });
              });
              t.isDeeply(rows, [['Albert', 'Task 1', '2019-09-05', '2019-09-07'], ['Ben', 'Task 2', '2019-09-06', '2019-09-07']], 'Rows are ok');
              t.isDeeply(columns, [{
                field: 'name',
                value: 'Name',
                width: 100,
                type: 'string'
              }, {
                field: 'name',
                value: 'Task',
                eventColumn: true,
                width: 100,
                type: 'string'
              }, {
                field: 'startDate',
                value: 'Starts',
                eventColumn: true,
                width: 140,
                type: 'date'
              }, {
                field: 'endDate',
                value: 'Ends',
                eventColumn: true,
                width: 140,
                type: 'date'
              }], 'Columns are ok');
              _exporter$export3 = exporter.export();
              rows = _exporter$export3.rows;
              columns = _exporter$export3.columns;
              rows = rows.map(function (row) {
                return row.map(function (cell) {
                  return cell instanceof Date ? DateHelper.format(cell, 'YYYY-MM-DD') : cell;
                });
              });
              t.isDeeply(rows, [['Albert', 'Task 1', '2019-09-05', '2019-09-07'], ['Ben', 'Task 2', '2019-09-06', '2019-09-07'], ['', 'No resource assigned'], ['', 'Task 3', '2019-09-07', '2019-09-09'], ['', 'Task 4', '2019-09-08', '2019-09-09']], 'Rows are ok');
              t.isDeeply(columns, [{
                field: 'name',
                value: 'Name',
                width: 100,
                type: 'string'
              }, {
                field: 'name',
                value: 'Task',
                eventColumn: true,
                width: 100,
                type: 'string'
              }, {
                field: 'startDate',
                value: 'Starts',
                eventColumn: true,
                width: 140,
                type: 'date'
              }, {
                field: 'endDate',
                value: 'Ends',
                eventColumn: true,
                width: 140,
                type: 'date'
              }], 'Columns are ok');

            case 14:
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
});