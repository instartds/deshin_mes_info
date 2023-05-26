StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    return scheduler && scheduler.destroy();
  });
  Object.assign(window, {
    Scheduler: Scheduler,
    EventStore: EventStore,
    ResourceStore: ResourceStore
  }); // https://github.com/bryntum/support/issues/1067

  t.it('Header should be not focusable', function (t) {
    scheduler = t.getScheduler({
      mode: 'vertical'
    });
    t.chain({
      click: '.b-grid-header-scroller-locked'
    }, {
      waitForSelectorNotFound: '.b-grid-header-scroller-locked.b-contains-focus'
    });
  });
  t.it('Header vertical axis column should render with a filter bar field and an input field', function (t) {
    scheduler = t.getScheduler({
      mode: 'vertical',
      features: {
        filterBar: true
      },
      verticalTimeAxisColumn: {
        text: 'Event',
        filterable: true
      }
    });
    t.chain({
      waitForSelector: '.b-grid-header-scroller-locked .b-grid-header-text-content:textEquals(Event)',
      desc: 'The vertical axis column text was rendered with the correct text'
    }, {
      waitForSelector: '.b-filter-bar-field-input',
      desc: 'The vertical axis column filter bar with the input field was rendered'
    });
  });
});