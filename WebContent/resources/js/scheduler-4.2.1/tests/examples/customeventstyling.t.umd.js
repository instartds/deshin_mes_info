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
  }); // Monkey-found bug

  t.it('Should run this monkey-test sequence with no errors', function (t) {
    t.chain({
      action: 'drag',
      target: [274, 329],
      to: [987, 346]
    }, {
      doubleclick: [835, 159]
    }, {
      doubleclick: [694, 603]
    });
  });
});