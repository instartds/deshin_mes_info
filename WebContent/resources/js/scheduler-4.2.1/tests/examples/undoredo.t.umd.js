StartTest(function (t) {
  var combo = bryntum.query('combo');
  var scheduler;
  t.it('sanity', function (t) {
    t.chain({
      waitForSelector: '.b-sch-foreground-canvas'
    }, function (next, el) {
      scheduler = bryntum.fromElement(el[0], 'scheduler');
      next();
    }, function () {
      return t.checkGridSanity(scheduler);
    });
  });
  t.it('Should be able to reschedule an event whose dependent event is unrendered due to tree collapsing', function (t) {
    t.chain({
      drag: '.b-sch-event:contains(Krasnodar)',
      by: [100, 50]
    }, {
      waitForSelector: '[data-ref=undoBtn][data-badge="1"]'
    }, {
      waitForSelector: '[data-ref=redoBtn][data-badge=""]'
    }, function (next) {
      t.is(combo.inputValue, '1 undo actions / 0 redo actions');
      next();
    }, {
      click: '[data-ref=undoBtn][data-badge="1"]'
    }, {
      waitForSelector: '[data-ref=redoBtn][data-badge="1"]'
    }, {
      waitForSelector: '[data-ref=undoBtn][data-badge=""]'
    }, function (next) {
      t.is(combo.inputValue, '0 undo actions / 1 redo actions');
      next();
    }, {
      click: '[data-ref=redoBtn][data-badge="1"]'
    }, {
      waitForSelector: '[data-ref=redoBtn][data-badge=""]'
    }, {
      waitForSelector: '[data-ref=undoBtn][data-badge="1"]'
    });
  });
});