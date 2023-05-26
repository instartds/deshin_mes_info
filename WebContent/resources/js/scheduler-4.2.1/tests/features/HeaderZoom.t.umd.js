StartTest({
  defaultTimeout: 90000
}, function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });

  var getScheduler = function getScheduler(config) {
    return t.getScheduler(Object.assign({
      appendTo: document.body,
      features: {
        headerZoom: true
      }
    }, config));
  };

  t.it('Should zoom when dragging in header', function (t) {
    scheduler = window.scheduler = getScheduler({
      events: []
    });
    t.firesOnce(scheduler, 'beforePresetChange');
    t.firesOnce(scheduler, 'presetChange');
    t.chain({
      drag: '.b-sch-header-timeaxis-cell:textEquals(Tu 04)',
      fromOffset: [0, '50%'],
      to: '.b-sch-header-timeaxis-cell:textEquals(We 05)',
      toOffset: ['100%', '50%'],
      dragOnly: true
    }, function (next) {
      var headerEl = scheduler.subGrids.normal.header.element,
          zoomDragProxyRect = document.querySelector('.b-headerzoom-rect').getBoundingClientRect();
      t.isApprox(zoomDragProxyRect.left - headerEl.getBoundingClientRect().left, scheduler.timeAxisViewModel.tickSize, 'Correct left pos');
      t.isApprox(zoomDragProxyRect.width, scheduler.timeAxisViewModel.tickSize * 2, 2, 'Correct width');
      t.isApprox(zoomDragProxyRect.height, headerEl.offsetHeight, 2, 'Correct height');
      next();
    }, {
      mouseUp: null
    }, function () {
      var visibleRange = scheduler.visibleDateRange,
          fifteenMinutesInMs = 1000 * 60 * 15;
      t.isApprox(visibleRange.startDate, new Date(2011, 0, 4), fifteenMinutesInMs, 'Zoomed to correct start date');
      t.isApprox(visibleRange.endDate, new Date(2011, 0, 6), fifteenMinutesInMs, 'Zoomed to correct end date');
    });
  });
  t.it('Should support disabling', function (t) {
    scheduler = getScheduler();
    scheduler.features.headerZoom.disabled = true;
    t.chain({
      drag: '.b-sch-header-timeaxis-cell:textEquals(Tu 04)',
      to: '.b-sch-header-timeaxis-cell:textEquals(We 05)',
      dragOnly: true
    }, function (next) {
      t.selectorNotExists('.b-headerzoom-rect', 'No proxy');
      scheduler.features.headerZoom.disabled = false;
      next();
    }, {
      mouseUp: null
    }, {
      drag: '.b-sch-header-timeaxis-cell:textEquals(Tu 04)',
      to: '.b-sch-header-timeaxis-cell:textEquals(We 05)',
      dragOnly: true
    }, function (next) {
      t.selectorExists('.b-headerzoom-rect', 'Proxy found');
      next();
    }, {
      mouseUp: null
    });
  });
});