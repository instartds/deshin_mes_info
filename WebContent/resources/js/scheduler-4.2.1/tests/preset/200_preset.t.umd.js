function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

StartTest(function (t) {
  t.ok(PresetManager, 'PresetManager exists');
  /* Properties each preset should have
      tickWidth : 60,
      rowHeight: 24,
      resourceColumnWidth : 100,
      displayDateFormat : 'G:i',
      shiftIncrement : 1,
      shiftUnit : "DAY",
      defaultSpan : 12,
      timeResolution : {
          unit : "MINUTE",
          increment : 15
      }
  */

  t.it('Predefined presets', function (t) {
    PresetManager.forEach(function (preset) {
      t.it(preset.name, function (t) {
        t.ok(_typeof(preset) === 'object', 'Found preset');
        t.ok(typeof preset.tickWidth === 'number', 'tickWidth found');
        t.ok(typeof preset.displayDateFormat === 'string', 'displayDateFormat found');
        t.ok(typeof preset.shiftIncrement === 'number', 'shiftIncrement found');
        t.ok(typeof preset.shiftUnit === 'string', 'shiftUnit found');
        t.ok(typeof preset.defaultSpan === 'number', 'defaultSpan found');
        t.ok(_typeof(preset.timeResolution) === 'object', 'timeResolution found');
        t.ok(typeof preset.timeResolution.unit === 'string', 'timeResolution unit found');
        t.ok(typeof preset.timeResolution.increment === 'number', 'timeResolution increment found');
        t.ok(_typeof(preset.headerConfig) === 'object', 'headerConfig found');
        t.ok(_typeof(preset.headerConfig.middle) === 'object', 'headerConfig.middle found');
      });
    });
  });
  t.it('Preset manipulation', function (t) {
    PresetManager.deletePreset('hourAndDay');
    t.notOk(PresetManager.getPreset('hourAndDay'), 'Could delete a preset');
    PresetManager.registerPreset('hourAndDay2', {
      tickWidth: 35,
      displayDateFormat: 'HH:mm',
      shiftIncrement: 1,
      shiftUnit: 'day',
      timeResolution: {
        unit: 'minute',
        increment: 15
      },
      defaultSpan: 24,
      headers: [{
        unit: 'day',
        increment: 1,
        dateFormat: 'DD MM YYYY'
      }, {
        unit: 'hour',
        increment: 12,
        renderer: function renderer(startDate, endDate, headerConfig, cellIdx) {}
      }, {
        unit: 'hour',
        increment: 1,
        dateFormat: 'HH'
      }]
    });
    t.ok(PresetManager.getPreset('hourAndDay2'), 'Could register a new preset');
  });
});