StartTest(function (t) {
  var scheduler = bryntum.query('scheduler'); // TODO: Should use demos UI to change tickSize, or move test elsewhere

  t.it('Should be possible to change tick size to minimal value', function (t) {
    t.checkGridSanity(scheduler);
    scheduler.suppressFit = true;
    scheduler.tickSize = 40;
    t.is(scheduler.tickSize, 40, 'Tick size has been changed to proposed value');
  });
});