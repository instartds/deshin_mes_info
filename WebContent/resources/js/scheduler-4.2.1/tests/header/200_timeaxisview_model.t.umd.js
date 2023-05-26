StartTest(function (t) {
  t.it('forceFit and columns need to be fitted, weekAndDayLetter', function (t) {
    var timeAxis = t.getTimeAxis(TimeAxis, PresetManager, 'weekAndDayLetter', {
      startDate: new Date(2010, 0, 11),
      endDate: DateHelper.add(new Date(2010, 0, 11), 5, 'weeks')
    });
    var viewModel = new TimeAxisViewModel({
      viewPreset: 'weekAndDayLetter',
      timeAxis: timeAxis,
      forceFit: true
    });
    viewModel.update(600);
    var colCfg = viewModel.columnConfig;
    t.is(viewModel.getDistanceBetweenDates(colCfg[1][0].start, colCfg[1][6].end), viewModel.getDistanceBetweenDates(colCfg[0][0].start, colCfg[0][0].end), 'Correct column width, weekAndDayLetter'); // this assertion breaks when `getDistanceBetweenDates` rounds the duration to smaller units then the main unit of the timeaxis
    // so that duration of the 1st interval, which is ~6.7 d is rounded to 7 days, which is equal to the duration of the 2nd interval
    // however the pixel difference is significant for such two intervals

    t.isLess(viewModel.getDistanceBetweenDates(new Date(2010, 0, 11), new Date(2010, 0, 17, 13)), viewModel.getDistanceBetweenDates(new Date(2010, 0, 11), new Date(2010, 0, 18)), 'Almost a 1 week distance is less than 1 week distance');
  });
  t.it('No forceFit, but snap. Months do not support snapping.', function (t) {
    var presetColWidth = PresetManager.getPreset('monthAndYear').tickWidth;
    var timeAxis = t.getTimeAxis(TimeAxis, PresetManager, 'monthAndYear', {
      startDate: new Date(2010, 1, 1),
      endDate: new Date(2010, 8, 1)
    });
    var viewModel = new TimeAxisViewModel({
      viewPreset: 'monthAndYear',
      timeAxis: timeAxis,
      snap: true,
      forceFit: false
    });
    viewModel.update(600);
    t.is(viewModel.tickSize, presetColWidth, 'Column width matches monthAndYear setting.');
  });
  t.it('No forceFit and no snap, and no need to expand the columns to fit the available width. Should just use the column width value from viewPreset.', function (t) {
    var presetColWidth = PresetManager.getPreset('hourAndDay').tickWidth;
    var timeAxis = t.getTimeAxis(TimeAxis, PresetManager, 'hourAndDay', {
      startDate: new Date(2010, 11, 9, 8),
      endDate: new Date(2010, 11, 9, 20)
    });
    var viewModel = new TimeAxisViewModel({
      viewPreset: 'hourAndDay',
      timeAxis: timeAxis,
      snap: false,
      forceFit: false
    });
    viewModel.update(600);
    t.is(viewModel.tickSize, presetColWidth, 'Column width matches hourAndDay setting.');
  });
  t.it("No forceFit and no snap, but columns don't consume entire available space and should grow to fit the available width", function (t) {
    var timeAxis = t.getTimeAxis(TimeAxis, PresetManager, 'hourAndDay', {
      startDate: new Date(2010, 11, 9, 8),
      endDate: new Date(2010, 11, 9, 12)
    });
    var viewModel = new TimeAxisViewModel({
      viewPreset: 'hourAndDay',
      timeAxis: timeAxis,
      snap: false,
      forceFit: false
    });
    viewModel.update(600);
    t.is(viewModel.tickSize, 150, 'Correct width when columns do not consume the whole available space');
  });
  t.it('forceFit but no snap, columns should fit in the available width.', function (t) {
    var timeAxis = t.getTimeAxis(TimeAxis, PresetManager, 'hourAndDay', {
      startDate: new Date(2010, 11, 9, 8),
      endDate: new Date(2010, 11, 9, 18)
    });
    var viewModel = new TimeAxisViewModel({
      viewPreset: 'hourAndDay',
      timeAxis: timeAxis,
      snap: false,
      forceFit: true
    });
    viewModel.update(600);
    t.is(viewModel.tickSize, 60, 'forceFit applied the correct column width');
    viewModel.availableSpace = 900;
    t.is(viewModel.tickSize, 90, 'setAvailableWidth update the column width');
  });
  t.it('no forceFit but snap and the columns do not consume the available width => they should grow', function (t) {
    PresetManager.registerPreset('workweek', {
      rowHeight: 24,
      resourceColumnWidth: 135,
      tickWidth: 115,
      displayDateFormat: 'HH:mm',
      shiftIncrement: 1,
      shiftUnit: 'week',
      timeResolution: {
        unit: 'minute',
        increment: 15
      },
      headers: [{
        unit: 'day',
        dateFormat: 'YYYY-MM-DD'
      }]
    });
    var timeAxis = t.getTimeAxis(TimeAxis, PresetManager, 'workweek', {
      startDate: new Date(2010, 11, 9),
      endDate: new Date(2010, 11, 16)
    });
    var viewModel = new TimeAxisViewModel({
      viewPreset: 'workweek',
      timeAxis: timeAxis,
      snap: true,
      forceFit: false
    });
    viewModel.update(1200); // Since columns consume all space, each day will be 1/7 of the width

    t.is(viewModel.tickSize, 1200 / 7, 'Correct column width when snap and resolution affects the column width');
    viewModel.snap = false;
    viewModel.tickSize = 200;
    t.is(viewModel.tickSize, 200, 'tickSize set ok');
  });
  t.it('no forceFit but snap and the resolution is 1 day', function (t) {
    PresetManager.registerPreset('weekAndDayLetter', {
      tickWidth: 139,
      // Something not evenly divisible by 7
      rowHeight: 24,
      resourceColumnWidth: 100,
      displayDateFormat: 'YYYY-MM-DD',
      shiftUnit: 'week',
      shiftIncrement: 1,
      defaultSpan: 10,
      timeResolution: {
        unit: 'day',
        increment: 1
      },
      headers: [{
        unit: 'week',
        dateFormat: 'ddd DD MMM YYYY',
        align: 'left'
      }, {
        unit: 'week',
        increment: 1,
        renderer: function renderer() {
          return 'foo';
        }
      }]
    });
    var timeAxis = t.getTimeAxis(TimeAxis, PresetManager, 'weekAndDayLetter', {
      startDate: new Date(2010, 0, 11),
      endDate: DateHelper.add(new Date(2010, 0, 11), 20, 'weeks')
    });
    var viewModel = new TimeAxisViewModel({
      viewPreset: 'weekAndDayLetter',
      timeAxis: timeAxis,
      snap: true,
      forceFit: false
    });
    viewModel.update(600);
    t.is(viewModel.tickSize, 139, 'Correct column width when snap and resolution affects the column width');
  });
  t.it('availableWidth getter/setter', function (t) {
    var timeAxis = t.getTimeAxis(TimeAxis, PresetManager, 'dayAndWeek', {
      startDate: new Date(2010, 0, 11),
      endDate: DateHelper.add(new Date(2010, 0, 11), 20, 'days')
    });
    var viewModel = new TimeAxisViewModel({
      viewPreset: 'dayAndWeek',
      timeAxis: timeAxis,
      forceFit: false
    });
    viewModel.availableSpace = 600;
    t.is(viewModel.availableSpace, 600, 'availableWidth getter/setter ok');
    t.firesOnce(viewModel, 'update');
    viewModel.fitToAvailableSpace();
    t.is(viewModel.tickSize, 30, 'fitToAvailableWidth ok');
  });
  t.it('Time axis with `autoAdjust : false`', function (t) {
    PresetManager.registerPreset('customPreset', {
      displayDateFormat: 'DD.MM. HH:mm',
      headers: [{
        increment: 1,
        unit: 'month',
        lign: 'center',
        dateFormat: 'MMM YYY'
      }, {
        increment: 1,
        unit: 'week',
        align: 'center',
        dateFormat: 'WW'
      }],
      timeResolution: {
        increment: 1,
        unit: 'day'
      }
    });
    var timeAxis = t.getTimeAxis(TimeAxis, PresetManager, 'customPreset', {
      autoAdjust: false,
      startDate: new Date(2013, 8, 1),
      endDate: new Date(2014, 2, 1)
    });
    var viewModel = new TimeAxisViewModel({
      viewPreset: 'customPreset',
      timeAxis: timeAxis
    });
    viewModel.update(600);
    t.is(viewModel.getPositionFromDate(new Date(2013, 8, 1)), 0, 'The time span`s start point should give 0 coordinate');
    t.is(viewModel.getDateFromPosition(0), new Date(2013, 8, 1), 'And vice versa');
  });
  t.it('Should shrink back to previous width after tickSize has been stretched (to fit container size)', function (t) {
    PresetManager.registerPreset('customPreset', {
      tickWidth: 20,
      headers: [{
        increment: 1,
        unit: 'day',
        align: 'center',
        dateFormat: 'WW'
      }],
      timeResolution: {
        increment: 1,
        unit: 'day'
      }
    });
    var timeAxis = t.getTimeAxis(TimeAxis, PresetManager, 'customPreset', {
      autoAdjust: false,
      startDate: new Date(2013, 8, 1),
      endDate: new Date(2013, 9, 1)
    });
    var viewModel = new TimeAxisViewModel({
      viewPreset: 'customPreset',
      timeAxis: timeAxis
    });
    viewModel.availableSpace = 200;
    t.is(viewModel.tickSize, 20, '30 days (600 total width) in September so no need to stretch tick width');
    viewModel.availableSpace = 900;
    t.is(viewModel.tickSize, 30, 'Container size increased 30 ticks, stretched to 900 total (each tick 30)');
    viewModel.availableSpace = 200;
    t.is(viewModel.tickSize, 20, 'Container size decreased back to 200, should shrink to original value');
    viewModel.tickSize = 40;
    t.is(viewModel.tickSize, 40, 'Tick width changed ok');
  });
});