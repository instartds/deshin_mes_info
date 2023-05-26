StartTest(function (t) {
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
  }); // https://github.com/bryntum/support/issues/346

  t.it('Should be possible to change value in Rooms combo', function (t) {
    t.chain({
      dblclick: '.b-sch-event-wrap[data-event-id="1"]'
    }, {
      click: '.b-combo[data-ref="roomCombo"]'
    }, {
      click: '.b-list-item[data-id="307"]'
    }, {
      click: '.b-button[data-ref="saveButton"]'
    }, function () {
      var rec = scheduler.eventStore.getById(1);
      t.ok(rec.isModified, 'Record is updated');
      t.is(rec.room, 307, 'Room is 307');
    });
  }); // https://github.com/bryntum/support/issues/2021

  t.it('Should not throw exception on create task if no resource is available', function (t) {
    t.chain({
      waitForSelector: '.b-sch-foreground-canvas'
    }, function (next) {
      scheduler.resourceStore.removeAll();
      next();
    }, {
      click: '.b-icon-add.b-icon'
    });
  });
});