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
  t.it('Found by monkeys', function (t) {
    t.chain({
      'click': [826, 220]
    }, {
      'type': ",)rqkv[DELETE]uSo\\'O&j/"
    }, {
      'rightclick': [954, 178]
    });
  });
});