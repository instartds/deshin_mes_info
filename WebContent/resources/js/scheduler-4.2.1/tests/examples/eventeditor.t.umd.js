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