StartTest(function (t) {
  t.diag('Double clicking any time header row should fire an event');
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler({
      viewPreset: 'foo',
      zoomOnTimeAxisDoubleClick: false,
      appendTo: document.body,
      startDate: new Date(2011, 1, 1),
      endDate: new Date(2011, 1, 1, 12)
    });
  });
  PresetManager.registerPreset('foo', {
    tickWidth: 35,
    rowHeight: 32,
    displayDateFormat: 'HH:mm',
    shiftIncrement: 1,
    shiftUnit: 'day',
    timeResolution: {
      unit: 'minute',
      increment: 15
    },
    defaultSpan: 24,
    headers: [{
      unit: 'month',
      increment: 1,
      dateFormat: 'DD MMM YYYY'
    }, {
      unit: 'day',
      increment: 1,
      dateFormat: 'D MMM'
    }, {
      unit: 'hour',
      increment: 2,
      dateFormat: 'HH'
    }]
  });
  t.it('Should size tables correctly', function (t) {
    var el = scheduler.getHeaderElement(scheduler.timeAxisColumn);
    t.isGE(el.querySelectorAll('.b-sch-header-row').length, 3, '3 header rows found');
    var timeAxisColWidth = el.offsetWidth;
    var row = el.querySelector('.b-sch-header-row');
    t.isGE(row.offsetWidth, timeAxisColWidth, 'Correct width for top table');
    t.isGE(row.nextElementSibling.offsetWidth, timeAxisColWidth, 'Correct width for mid table');
    t.isGE(row.nextElementSibling.nextElementSibling.offsetWidth, timeAxisColWidth, 'Correct width for bottom table');
    var top = el.querySelector('.b-sch-header-row-0');
    t.is(top.querySelector('.b-sch-header-timeaxis-cell').offsetWidth, top.offsetWidth, 'Correct width for top header');
    var middle = el.querySelector('.b-sch-header-row-1');
    t.is(middle.querySelector('.b-sch-header-timeaxis-cell').offsetWidth, middle.offsetWidth, 'Correct width for mid table td');
  });
  t.it('Double clicks', function (t) {
    t.willFireNTimes(scheduler, 'timeaxisheaderdblclick', 3);
    t.chain(function (next) {
      scheduler.on({
        timeaxisheaderdblclick: function timeaxisheaderdblclick(_ref) {
          var source = _ref.source,
              startDate = _ref.startDate,
              endDate = _ref.endDate,
              event = _ref.event;
          t.ok(source instanceof TimeAxisColumn, 'Bottom row header ok');
          t.is(startDate, new Date(2011, 1, 1, 0), 'StartDate ok');
          t.is(endDate, new Date(2011, 1, 1, 2), 'EndDate ok');
          next();
        },
        once: true
      });
      t.doubleClick('.b-sch-header-row-2 .b-sch-header-timeaxis-cell', function () {});
    }, function (next) {
      scheduler.on({
        timeaxisheaderdblclick: function timeaxisheaderdblclick(_ref2) {
          var source = _ref2.source,
              startDate = _ref2.startDate,
              endDate = _ref2.endDate,
              event = _ref2.event;
          t.ok(source instanceof TimeAxisColumn, 'Middle row header ok');
          t.is(startDate, new Date(2011, 1, 1, 0), 'StartDate ok');
          t.is(endDate, new Date(2011, 1, 2), 'EndDate ok');
          next();
        },
        once: true
      });
      t.doubleClick('.b-sch-header-row-1 .b-sch-header-timeaxis-cell', function () {});
    }, function (next) {
      scheduler.on({
        timeaxisheaderdblclick: function timeaxisheaderdblclick(_ref3) {
          var source = _ref3.source,
              startDate = _ref3.startDate,
              endDate = _ref3.endDate,
              event = _ref3.event;
          t.ok(source instanceof TimeAxisColumn, 'Top row header ok');
          t.is(startDate, new Date(2011, 1, 1, 0), 'StartDate ok');
          t.is(endDate, new Date(2011, 1, 2), 'EndDate ok');
          next();
        },
        once: true
      });
      t.doubleClick('.b-sch-header-row-0 .b-sch-header-timeaxis-cell', function () {});
    });
  });
});