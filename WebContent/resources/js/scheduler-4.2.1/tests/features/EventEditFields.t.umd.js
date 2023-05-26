StartTest(function (t) {
  Object.assign(window, {
    Scheduler: Scheduler,
    EventStore: EventStore,
    ResourceStore: ResourceStore
  });
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
    scheduler = null;
  }); // https://github.com/bryntum/support/issues/1093

  t.it('Event editor start and end date fields should respect weekStartDay config', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventEdit: true
      },
      weekStartDay: 1
    });
    t.chain({
      doubleClick: '.b-sch-event'
    }, {
      click: '[data-ref="startDateField"] .b-icon-calendar'
    }, {
      waitForSelector: '.b-calendar-day-header[data-column-index="0"][data-cell-day="1"]',
      desc: 'Start date picker week starts with correct day'
    }, {
      type: '[ESC]'
    }, {
      click: '[data-ref="endDateField"] .b-icon-calendar'
    }, {
      waitForSelector: '.b-calendar-day-header[data-column-index="0"][data-cell-day="1"]',
      desc: 'End date picker week starts with correct day'
    });
  });
  t.it('Event editor start and end date fields should respect DateHelper.weekStartDay config', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventEdit: true
      }
    });
    t.chain({
      doubleClick: '.b-sch-event'
    }, {
      click: '[data-ref="startDateField"] .b-icon-calendar'
    }, {
      waitForSelector: '.b-calendar-day-header[data-column-index="0"][data-cell-day="0"]',
      desc: 'Start date picker week starts with correct day'
    }, {
      type: '[ESC]'
    }, {
      click: '[data-ref="endDateField"] .b-icon-calendar'
    }, {
      waitForSelector: '.b-calendar-day-header[data-column-index="0"][data-cell-day="0"]',
      desc: 'End date picker week starts with correct day'
    });
  });
});