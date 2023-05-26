function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  PresetManager.registerPreset('second', {
    displayDateFormat: 'MM:mm:ss',
    shiftIncrement: 1,
    shiftUnit: 'day',
    timeResolution: {
      unit: 'day',
      increment: 1
    },
    headers: [{
      unit: 'day',
      dateFormat: 'mm:ss'
    }]
  });
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });
  t.it('Should draw single header', function (t) {
    document.body.style.width = '500px';
    scheduler = t.getScheduler({
      viewPreset: 'second',
      appendTo: document.body,
      columns: [{
        text: 'Name',
        sortable: true,
        width: 100,
        field: 'name',
        locked: true
      }, {
        text: 'Id',
        sortable: true,
        width: 100,
        hidden: true,
        field: 'id',
        locked: true
      }]
    });
    var headerScrollerElement = document.querySelector('.b-grid-header-scroller-normal'),
        headerRow = document.querySelector('.b-sch-header-row');
    t.isGreater(headerRow.offsetWidth, headerScrollerElement.offsetWidth, 'Time axis has expanded horizontally');
    t.isApprox(headerScrollerElement.offsetHeight, headerRow.offsetHeight, 'Height of the timeaxis matches header container');
  });
  t.it('Time axis header should fill header container', function (t) {
    scheduler = t.getScheduler({
      appendTo: document.body,
      viewPreset: 'second',
      columns: [{
        field: 'name',
        text: 'Name' //,
        //items     : [{ xtype : 'textfield' }] // not available in vanilla

      }]
    });
    t.isApprox(document.querySelector('.b-sch-header-timeaxis-cell').offsetHeight, document.querySelector('.b-sch-header-row').offsetHeight, 'Height of the timeaxis matches header container'); // scheduler.headerHeight = 60;
    // t.isApprox(document.querySelector('.b-sch-header-timeaxis-cell').offsetHeight, 60, 'Height of the timeaxis matches header container');
    // scheduler.headerHeight = 80;
    // t.isApprox(document.querySelector('.b-sch-header-timeaxis-cell').offsetHeight, 80, 'Height of the timeaxis matches header container');
  });
  t.it('Two level time axis header should fill header container', function (t) {
    scheduler = t.getScheduler({
      appendTo: document.body,
      columns: [{
        field: 'name',
        text: 'Name',
        width: 100
      }]
    });

    var validateHeaderHeight = function validateHeaderHeight() {
      t.isApprox(document.querySelector('.b-sch-header-row-1 .b-sch-header-timeaxis-cell').offsetHeight, Math.floor(scheduler.headerHeight / 2), 1, 'Height of the timeaxis matches top header container');
      t.isApprox(document.querySelector('.b-sch-header-row-0 .b-sch-header-timeaxis-cell').offsetHeight, Math.floor(scheduler.headerHeight / 2), 1, 'Height of the timeaxis matches middle header container');
    }; // validateHeaderHeight();
    // scheduler.headerHeight = 60;
    // validateHeaderHeight();
    // scheduler.headerHeight = 80;


    validateHeaderHeight();
  });
  t.it('Should zoom on timeaxis header dblclick', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = t.getScheduler({
                startDate: new Date(2018, 1, 1),
                viewPreset: 'dayAndWeek',
                appendTo: document.body,
                width: 500,
                columns: [{
                  text: 'Name',
                  sortable: true,
                  width: 100,
                  field: 'name',
                  locked: true
                }]
              });
              t.chain({
                doubleClick: '.b-sch-header-row-1 .b-sch-header-timeaxis-cell'
              }, {
                waitForSelector: '.b-sch-header-row-0 .b-sch-header-timeaxis-cell:contains(Thu 02/01)',
                desc: 'Zoomed and showed correct day'
              }); // TODO verify on the data level that visible date range is correct
              // t.isApprox(scheduler.visibleDateRange.startDate, new Date(2018, 1, 1));

            case 2:
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
});