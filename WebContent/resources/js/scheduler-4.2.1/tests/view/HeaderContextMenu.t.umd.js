StartTest(function (t) {
  t.spyOn(VersionHelper, 'deprecate').and.callFake(function () {});
  var scheduler, today;
  t.beforeEach(function () {
    scheduler && scheduler.destroy(); // After scheduler destroy, all menuitems must also have been destroyed

    t.is(bryntum.queryAll('menuitem').length, 0, 'Menu items all destroyed');
    today = DateHelper.clearTime(new Date());
    scheduler = t.getScheduler({
      features: {
        contextMenu: true,
        headerContextMenu: true,
        timeRanges: {
          showCurrentTimeLine: true,
          showHeaderElements: true
        },
        eventTooltip: false
      },
      viewPreset: 'dayAndWeek',
      startDate: DateHelper.add(today, -1, 'day'),
      endDate: DateHelper.add(today, 1, 'day'),
      appendTo: document.body,
      events: [{
        id: 1,
        resourceId: 'r1',
        name: 'Meeting #1',
        cls: 'event1',
        startDate: DateHelper.add(today, 1, 'hour'),
        endDate: DateHelper.add(today, 6, 'hour')
      }, {
        id: 2,
        resourceId: 'r2',
        name: 'Meeting #2',
        cls: 'event2',
        startDate: DateHelper.add(today, 1, 'hour'),
        endDate: DateHelper.add(today, 6, 'hour')
      }]
    });
  });
  t.it('LEGACY: Should show/hide current time line', function (t) {
    t.chain({
      waitForSelector: '.b-sch-current-time',
      desc: 'Current time line is visible'
    }, {
      contextmenu: '.b-sch-header-timeaxis-cell'
    }, {
      click: ':textEquals(Show current timeline)'
    }, {
      waitForSelectorNotFound: '.b-sch-current-time',
      desc: 'Current time line is hidden'
    }, {
      click: ':textEquals(Show current timeline)'
    }, {
      waitForSelector: '.b-sch-current-time',
      desc: 'Current time line is visible'
    });
  });
  t.it('LEGACY: Should filter events', function (t) {
    t.chain({
      waitForElementVisible: '.event2',
      desc: 'Event 2 is visible'
    }, {
      contextmenu: '.b-sch-header-timeaxis-cell'
    }, {
      moveCursorTo: ':textEquals(Filter tasks)'
    }, {
      click: '.b-textfield'
    }, {
      type: '#1[ENTER]'
    }, {
      waitForElementNotVisible: '.event2',
      desc: 'Event 2 is hidden'
    });
  });
  t.it('LEGACY: Should show zoom picker', function (t) {
    t.chain({
      contextmenu: '.b-sch-header-timeaxis-cell'
    }, {
      moveCursorTo: ':textEquals(Zoom)'
    }, {
      click: '.b-slider',
      desc: 'Zoom picker is available'
    });
  });
  t.it('LEGACY: Should change start/end date', function (t) {
    var originalStart = scheduler.startDate,
        originalEnd = scheduler.endDate;
    t.willFireNTimes(scheduler, 'timeAxisChange', 3);
    t.chain({
      contextmenu: '.b-sch-header-timeaxis-cell'
    }, {
      moveCursorTo: ':textEquals(Date range)'
    }, {
      click: '.b-datefield :textEquals(Start date)',
      desc: 'Start picker is available'
    }, {
      click: '.b-datefield :textEquals(End date)',
      desc: 'End picker is available'
    }, {
      click: '.b-left-nav-btn',
      desc: 'Left button is available'
    }, function (next) {
      t.is(scheduler.startDate, DateHelper.add(originalStart, -1, 'day'), 'Start date is correct after left shifting');
      t.is(scheduler.endDate, DateHelper.add(originalEnd, -1, 'day'), 'End date is correct after left shifting');
      next();
    }, {
      click: '.b-right-nav-btn',
      desc: 'Right button is available'
    }, function (next) {
      t.is(scheduler.startDate, originalStart, 'Start date is correct after right shifting');
      t.is(scheduler.endDate, originalEnd, 'End date is correct after right shifting');
      next();
    }, {
      click: '.b-today-nav-btn',
      desc: 'Today button is available'
    }, function (next) {
      t.is(scheduler.startDate, today, 'Start date is correct after today click');
      t.is(scheduler.endDate, DateHelper.add(today, 1, 'day'), 'End date is correct after today click');
    });
  }); // https://app.assembla.com/spaces/bryntum/tickets/6783

  t.it('LEGACY: Should shift by one day even if picker submenu was shown and hidden few times', function (t) {
    var originalStart = scheduler.startDate,
        originalEnd = scheduler.endDate;
    t.willFireNTimes(scheduler, 'timeAxisChange', 1);
    t.chain({
      contextmenu: '.b-sch-header-timeaxis-cell'
    }, {
      moveCursorTo: ':textEquals(Date range)'
    }, {
      moveCursorTo: ':textEquals(Zoom)'
    }, {
      moveCursorTo: ':textEquals(Date range)'
    }, {
      moveCursorTo: ':textEquals(Zoom)'
    }, {
      moveCursorTo: ':textEquals(Date range)',
      offset: ['100%-1', '50%']
    }, {
      moveCursorTo: '.b-datefield :textEquals(Start date)'
    }, {
      click: '.b-left-nav-btn'
    }, function (next) {
      t.is(scheduler.startDate, DateHelper.add(originalStart, -1, 'day'), 'Start date is correct after left shifting');
      t.is(scheduler.endDate, DateHelper.add(originalEnd, -1, 'day'), 'End date is correct after left shifting');
    });
  });
  t.it('LEGACY: Should filter events once', function (t) {
    t.willFireNTimes(scheduler.eventStore, 'filter', 1);
    t.chain({
      contextmenu: '.b-sch-header-timeaxis-cell'
    }, {
      moveCursorTo: ':textEquals(Filter tasks)'
    }, {
      moveCursorTo: ':textEquals(Zoom)'
    }, {
      moveCursorTo: ':textEquals(Filter tasks)'
    }, {
      moveCursorTo: ':textEquals(Zoom)'
    }, {
      moveCursorTo: ':textEquals(Filter tasks)'
    }, {
      click: '.b-textfield'
    }, {
      type: '#1[ENTER]'
    });
  });
});