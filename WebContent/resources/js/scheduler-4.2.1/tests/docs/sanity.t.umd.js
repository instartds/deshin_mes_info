StartTest(function (t) {
  t.it('Live landing demo looks sane', function (t) {
    t.chain({
      waitForSelector: '#tree .b-grid-cell',
      desc: 'Navigation tree rendered'
    }, {
      waitForSelector: '#content .b-scheduler .b-grid-cell',
      desc: 'Demo grid rendered'
    }, function () {
      var fiddlePanelResultEl = document.querySelector('.b-fiddlepanel .fiddlePanelResult'),
          schedulerEl = document.querySelector('.b-scheduler'),
          style = window.getComputedStyle(fiddlePanelResultEl),
          sidePadding = parseInt(style.getPropertyValue('padding-left'), 10);
      t.isApprox(fiddlePanelResultEl.offsetWidth, 650, 50, 'Sane width for fiddle panel');
      t.isApprox(fiddlePanelResultEl.offsetHeight, 650, 50, 'Sane height for fiddle panel');
      t.isApprox(schedulerEl.offsetWidth, fiddlePanelResultEl.offsetWidth - 2 * sidePadding, 5, 'Scheduler has expected width');
      t.isApprox(schedulerEl.offsetHeight, fiddlePanelResultEl.offsetHeight - 2 * sidePadding, 5, 'Scheduler has expected height');
    });
  });
  t.it('Live demo in class doc looks sane', function (t) {
    t.global.location.hash = '#Scheduler/feature/GroupSummary';
    t.chain({
      waitForSelector: '.b-sch-event:contains(First)',
      desc: 'Demo scheduler rendered'
    }, {
      waitForSelector: '.b-timeaxis-summary-value',
      desc: 'Summary rendered'
    }, function () {
      var fiddlePanelResultEl = document.querySelector('.b-fiddlepanel .fiddlePanelResult'),
          schedulerEl = document.querySelector('.b-scheduler'),
          style = window.getComputedStyle(fiddlePanelResultEl),
          sidePadding = parseInt(style.getPropertyValue('padding-left'), 10);
      t.isApprox(fiddlePanelResultEl.offsetWidth, 650, 50, 'Sane width for fiddle panel');
      t.isApprox(fiddlePanelResultEl.offsetHeight, 720, 50, 'Sane height for fiddle panel');
      t.isApprox(schedulerEl.offsetWidth, fiddlePanelResultEl.offsetWidth - 2 * sidePadding, 5, 'Scheduler has expected width');
      t.isApprox(schedulerEl.offsetHeight, 540, 40, 'Scheduler has expected height');
    });
  });
  t.it('Should navigate to Grid guide even if it is not in docs Tree', function (t) {
    t.global.location.hash = '#Grid/guides/customization/contextmenu.md';
    t.chain({
      waitForSelector: '#content[data-id="Grid/guides/customization/contextmenu.md"]'
    });
  });
});