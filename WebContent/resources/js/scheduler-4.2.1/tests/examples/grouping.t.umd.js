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
  });
  t.it('Found by monkeys, crashed on group collapse in IE11', function (t) {
    t.chain({
      click: '.b-grid-cell.b-group-title'
    });
  });
});