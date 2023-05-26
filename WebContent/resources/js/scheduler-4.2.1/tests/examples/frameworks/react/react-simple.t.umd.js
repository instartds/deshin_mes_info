/**
 * Custom simple test
 */
StartTest(function (t) {
  t.it('Rendering', function (t) {
    t.chain( // basic rendering
    {
      waitForSelector: '.b-timelinebase'
    }, {
      waitForSelector: '.b-checkbox'
    });
  });
  t.it('Features', function (t) {
    t.chain( // stripe feature
    {
      waitForSelectorNotFound: '.b-even'
    }, {
      click: '.b-checkbox :contains(Stripe)'
    }, {
      waitForSelector: '.b-even'
    }, // columnLines feature
    {
      waitForSelector: '.b-columnlines'
    }, {
      click: '.b-checkbox :contains(Column Lines)'
    }, {
      waitForSelectorNotFound: '.b-columnlines'
    });
  });
});