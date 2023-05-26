describe('It should support passing start + end date as params', function (t) {
  t.it('Should support `passStartEndParameters` with autoLoad config', function (t) {
    var callCount = 0,
        startDate = new Date(2010, 1, 1, 12),
        endDate = new Date(2010, 1, 2, 12);

    AjaxHelper.get = function (url) {
      callCount++;
      t.like(url, "foo=".concat(encodeURIComponent("2010-02-01T12:00:00".concat(DateHelper.getGMTOffset(startDate)))), 'correct start param name + value');
      t.like(url, "bar=".concat(encodeURIComponent("2010-02-02T12:00:00".concat(DateHelper.getGMTOffset(endDate)))), 'correct end param name + value');
      return new Promise(function () {});
    };

    t.getScheduler({
      passStartEndParameters: true,
      viewPreset: 'hourAndDay',
      startParamName: 'foo',
      endParamName: 'bar',
      startDate: startDate,
      endDate: endDate,
      eventStore: {
        readUrl: 'read.js',
        autoLoad: true
      }
    });
    t.is(callCount, 1);
  });
  t.it('Should support `passStartEndParameters` with autoLoad false', function (t) {
    var callCount = 0,
        startDate = new Date(2010, 1, 1, 12),
        endDate = new Date(2010, 1, 2, 12);

    AjaxHelper.get = function (url) {
      callCount++;
      t.like(url, "foo=".concat(encodeURIComponent("2010-02-01T12:00:00".concat(DateHelper.getGMTOffset(startDate)))), 'correct start param name + value');
      t.like(url, "bar=".concat(encodeURIComponent("2010-02-02T12:00:00".concat(DateHelper.getGMTOffset(endDate)))), 'correct end param name + value');
      return new Promise(function () {});
    };

    var scheduler = t.getScheduler({
      passStartEndParameters: true,
      viewPreset: 'hourAndDay',
      startParamName: 'foo',
      endParamName: 'bar',
      startDate: startDate,
      endDate: endDate,
      eventStore: {
        readUrl: 'read.js',
        autoLoad: false
      }
    });
    scheduler.eventStore.load();
    t.is(callCount, 1);
  });
});