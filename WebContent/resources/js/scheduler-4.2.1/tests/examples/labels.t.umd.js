StartTest(function (t) {
  var scheduler = bryntum.query('scheduler');
  t.it('sanity', function (t) {
    t.chain({
      waitForSelector: '.b-sch-foreground-canvas'
    }, function () {
      return t.checkGridSanity(scheduler);
    });
  });
  t.it('Toggle layout modes', function (t) {
    scheduler.enableEventAnimations = false; // To get different results for estimate & measure

    scheduler.eventStore.first.startDate = new Date(2020, 0, 8, 12);
    t.chain({
      click: 'button[data-ref=default]'
    }, function (next) {
      t.isApprox(t.rect('.b-grid-row[data-id=r4]').height, 61, 'Overlapping r4');
      t.isApprox(t.rect('.b-grid-row[data-id=r1]').height, 61, 'Overlapping r1');
      next();
    }, {
      click: 'button[data-ref=estimate]'
    }, function (next) {
      t.isApprox(t.rect('.b-grid-row[data-id=r4]').height, 181, 'Stacked r4');
      t.isApprox(t.rect('.b-grid-row[data-id=r1]').height, 121, 'Stacked r1');
      next();
    }, {
      click: 'button[data-ref=measure]'
    }, function () {
      t.isApprox(t.rect('.b-grid-row[data-id=r4]').height, 181, 'Stacked r4');
      t.isApprox(t.rect('.b-grid-row[data-id=r1]').height, 61, 'No stacking for r1');
      scheduler.enableEventAnimations = true;
    });
  });
  t.it('Edit the duration', function (t) {
    var scheduler, event, duration;
    t.chain({
      waitForSelector: '.b-sch-event-wrap'
    }, function (next) {
      scheduler = bryntum.query('scheduler');
      event = scheduler.eventStore.findByField('name', 'Out of office')[0].data;
      duration = event.duration;
      next();
    }, {
      dblclick: ".b-sch-event-wrap:contains(Out of office) .b-sch-label-left"
    }, // Wait to focus the label feature's left editor
    {
      waitFor: function waitFor() {
        return document.activeElement === scheduler.features.labels.left.editor.inputField.input;
      }
    }, // Spin up
    function (next) {
      t.click(scheduler.features.labels.left.editor.inputField.triggers.spin.upButton, next);
    }, {
      type: '[ENTER]'
    }, function () {
      t.is(event.duration, duration + 1);
    });
  });
});