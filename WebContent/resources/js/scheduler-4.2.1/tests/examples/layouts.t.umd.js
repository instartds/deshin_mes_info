StartTest(function (t) {
  var scheduler;
  t.it('sanity', function (t) {
    t.chain({
      waitForSelector: '.b-sch-event'
    }, function (next, el) {
      scheduler = bryntum.fromElement(el[0], 'scheduler');
      next();
    }, function () {
      return t.checkGridSanity(scheduler);
    });
  });
  t.it('Should not crash when toggling layout', function (t) {
    t.chain( // should not crash
    {
      click: 'button:contains(Overlap)'
    }, {
      click: 'button:contains(Pack)'
    }, {
      click: 'button:contains(Stack)'
    });
  });
  t.it('Custom sorter should be applied', function (t) {
    t.chain({
      click: '[data-ref=customButton]'
    }, {
      waitFor: function waitFor() {
        var box = Rectangle.from(document.querySelector('[data-event-id="3"]'), bryntum.query('scheduler').timeAxisSubGridElement);
        return box.top === 1;
      },
      desc: 'Meeting #3 moved to top'
    });
  });
});