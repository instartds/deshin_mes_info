StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    return scheduler && scheduler.destroy();
  });
  t.describe('headers configured using headers', function (t) {
    t.it('Pass anonymous preset without name', function (t) {
      scheduler = t.getScheduler({
        viewPreset: {
          tickWidth: 35,
          rowHeight: 47,
          displayDateFormat: 'HH-mm',
          shiftIncrement: 3,
          shiftUnit: 'dat',
          timeResolution: {
            unit: 'minute',
            increment: 35
          },
          defaultSpan: 24,
          headers: [{
            unit: 'hour',
            increment: 12,
            renderer: function renderer(startDate, endDate, headerConfig, cellIdx) {
              return cellIdx;
            }
          }]
        },
        startDate: new Date(2011, 0, 4),
        endDate: new Date(2011, 0, 5),
        appendTo: document.body
      });
      t.is(scheduler.timeResolution.increment, 35, 'timeResolution increment');
      t.is(scheduler.displayDateFormat, 'HH-mm', 'displayDateFormat');
    });
    t.it('Pass existing preset and modify config', function (t) {
      scheduler = t.getScheduler({
        viewPreset: {
          base: 'hourAndDay',
          headers: [{
            unit: 'hour',
            increment: 12,
            renderer: function renderer() {
              return arguments.length <= 3 ? undefined : arguments[3];
            }
          }]
        },
        startDate: new Date(2011, 0, 4),
        endDate: new Date(2011, 0, 5),
        appendTo: document.body
      });
      var myPreset = PresetManager.normalizePreset('hourAndDay');
      t.ok(myPreset, 'Could register a new preset');
      [].forEach.call(document.querySelectorAll('.b-sch-header-row-0 .b-sch-header-timeaxis-cell'), function (td, index) {
        t.like(td.innerText, index, 'Content matches cellIndex ' + index);
      });
    });
  });
});