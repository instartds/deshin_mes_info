StartTest(function (t) {
  t.it('Should support dragging right splitter', function (t) {
    var scheduler = window.scheduler;
    t.firesAtLeastNTimes(scheduler.timeAxisSubGrid, 'resize', 1);
    t.chain({
      drag: '.b-grid-splitter[data-region=normal]',
      by: [-100, 0]
    });
  });
});