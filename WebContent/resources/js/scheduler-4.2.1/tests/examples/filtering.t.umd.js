StartTest(function (t) {
  var scheduler = bryntum.query('scheduler');
  t.it('should filter events', function (t) {
    t.chain({
      type: 's',
      target: '[data-ref=filterByName] input'
    }, {
      waitForElementNotVisible: '.b-sch-event:contains(marketing)'
    }, function (next) {
      t.selectorCountIs(scheduler.unreleasedEventSelector, 4, 'Events filtered out');
      next();
    }, {
      type: '[ESC]'
    }, {
      waitForElementVisible: '.b-sch-event:contains(marketing)'
    }, function () {
      return t.selectorCountIs(scheduler.unreleasedEventSelector, 7, 'Events unfiltered');
    });
  });
  t.it('should highlight events', function (t) {
    t.chain({
      click: '[data-ref=highlight] input'
    }, {
      type: 's'
    }, {
      waitForSelector: '.b-match'
    }, function (next) {
      t.selectorCountIs('.b-match', 4, 'Events highlighted');
      next();
    }, {
      type: '[ESC]'
    }, {
      waitForSelectorNotFound: '.b-match',
      desc: 'Events unhighlighted'
    });
  });
});