StartTest(function (t) {
  var timeAxis;
  t.beforeEach(function () {
    return timeAxis && timeAxis.destroy();
  });
  t.it('Should not crash on shiftNext()', function (t) {
    timeAxis = new TimeAxis();
    timeAxis.reconfigure({
      unit: 'day',
      shiftUnit: 'day',
      startDate: new Date(2019, 2, 17),
      endDate: new Date(2019, 2, 24)
    });
    timeAxis.filter(function (tick) {
      return tick.startDate.getDay() !== 0 && tick.startDate.getDay() !== 6;
    });

    for (var i = 0; i < 5; i++) {
      timeAxis.shiftNext();
      t.is(timeAxis.count, 5, 'Correct tick count #' + (i + 1));
    }

    for (var _i = 5; _i < 10; _i++) {
      timeAxis.shiftPrevious();
      t.is(timeAxis.count, 5, 'Correct tick count #' + (_i + 1));
    }
  });
});