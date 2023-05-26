StartTest(function (t) {
  t.it('Should be able to exclude days from the time axis', function (t) {
    var timeAxis = new TimeAxis({
      include: {
        day: {
          from: 1,
          to: 6
        }
      }
    });
    timeAxis.reconfigure({
      unit: 'day',
      startDate: new Date(2019, 0, 21),
      endDate: new Date(2019, 1, 4)
    });
    t.is(timeAxis.count, 10, 'Correct tick count');
    var days = timeAxis.map(function (tick) {
      return tick.startDate.getDay();
    });
    t.isDeeply(days, [1, 2, 3, 4, 5, 1, 2, 3, 4, 5], 'Correct days 1-5');
    timeAxis.include = {
      day: {
        from: 2,
        to: 4
      }
    };
    t.is(timeAxis.count, 4, 'Correct tick count');
    days = timeAxis.map(function (tick) {
      return tick.startDate.getDay();
    });
    t.isDeeply(days, [2, 3, 2, 3], 'Correct days 2-4');
    timeAxis.include = {
      day: {
        from: 0,
        to: 1
      }
    };
  });
  t.it('Should be able to exclude hours from the time axis', function (t) {
    var timeAxis = new TimeAxis({
      include: {
        hour: {
          from: 11,
          to: 15
        }
      }
    });
    timeAxis.reconfigure({
      unit: 'hour',
      startDate: new Date(2019, 0, 21),
      endDate: new Date(2019, 0, 23)
    });
    t.is(timeAxis.count, 8, 'Correct tick count');
    var hours = timeAxis.map(function (tick) {
      return tick.startDate.getHours();
    });
    t.isDeeply(hours, [11, 12, 13, 14, 11, 12, 13, 14], 'Correct hours 11 - 15');
  });
  t.it('A rule for hours should modify day ticks', function (t) {
    var timeAxis = new TimeAxis({
      include: {
        hour: {
          from: 11,
          to: 15
        }
      }
    });
    timeAxis.reconfigure({
      unit: 'day',
      startDate: new Date(2019, 0, 21),
      endDate: new Date(2019, 1, 4)
    });
    t.is(timeAxis.count, 14, 'Correct tick count');
    t.ok(timeAxis.records.every(function (tick) {
      return tick.startDate.getHours() === 11;
    }), 'All startDates correct');
    t.ok(timeAxis.records.every(function (tick) {
      return tick.endDate.getHours() === 15;
    }), 'All endDates correct');
  });
  t.it('Should exclude on "smaller" units', function (t) {
    var timeAxis = new TimeAxis({
      include: {
        day: {
          from: 1,
          to: 6
        }
      }
    });
    t.diag('Hour');
    timeAxis.reconfigure({
      unit: 'hour',
      startDate: new Date(2019, 0, 25),
      // Friday
      endDate: new Date(2019, 0, 27)
    });
    t.is(timeAxis.count, 24, 'Correct tick count');
    var allFriday = timeAxis.records.every(function (tick) {
      return tick.startDate.getDay() === 5;
    });
    t.ok(allFriday, 'No ticks during weekend');
    t.diag('Minute');
    timeAxis.reconfigure({
      unit: 'minute',
      startDate: new Date(2019, 0, 25),
      // Friday
      endDate: new Date(2019, 0, 27)
    });
    allFriday = timeAxis.records.every(function (tick) {
      return tick.startDate.getDay() === 5;
    });
    t.ok(allFriday, 'No ticks during weekend');
  });
});