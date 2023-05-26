StartTest(function (t) {
  var scheduler = window.scheduler;
  t.it('sanity', function (t) {
    t.chain({
      waitForSelector: '.b-sch-foreground-canvas'
    }, function () {
      return t.checkGridSanity(scheduler);
    });
  });
  t.it('should work ok when doing many mass updates', function (t) {
    t.firesAtLeastNTimes(scheduler.eventStore, 'change', 5);
    t.chain( // click mass update 6 times
    {
      click: 'button:contains(update)'
    }, {
      click: 'button:contains(update)'
    }, {
      click: 'button:contains(update)'
    }, {
      click: 'button:contains(update)'
    }, {
      click: 'button:contains(update)'
    }, {
      click: 'button:contains(update)'
    }, function (next) {
      var eventElements = Array.from(document.querySelectorAll('.b-sch-event:not(.b-sch-released)'));
      eventElements.forEach(function (element) {
        t.ok(scheduler.resolveResourceRecord(element), 'Event element matched to resource record');
      });
      next();
    }, // click mass update 2 times more, should not crash
    {
      click: 'button:contains(update)'
    }, {
      click: 'button:contains(update)'
    });
  });
  t.it('should reschedule meetings when clicking button', function (t) {
    t.chain( // click mass update 6 times
    {
      click: 'button:contains(After)'
    }, function () {
      scheduler.eventStore.query(function (task) {
        return task.eventType === 'Meeting';
      }).forEach(function (task) {
        t.isGreaterOrEqual(task.startDate, scheduler.timeRanges[0].endDate);
      });
    });
  });
  t.it('should limit meetings to 1 hr when clicking button', function (t) {
    t.chain({
      click: 'button:contains(Max 1hr)'
    }, {
      waitForProjectReady: scheduler
    }, function () {
      scheduler.eventStore.query(function (task) {
        return task.eventType === 'Meeting';
      }).forEach(function (task) {
        t.isLessOrEqual(task.duration, 1);
        t.is(DateHelper.normalizeUnit(task.durationUnit), 'hour');
      });
    });
  });
});