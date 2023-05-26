StartTest(function (t) {
  var scheduler = bryntum.query('scheduler');
  t.it('sanity', function (t) {
    t.chain({
      waitForSelector: '.b-sch-foreground-canvas'
    }, function () {
      return t.checkGridSanity(scheduler);
    });
  }); // https://app.assembla.com/spaces/bryntum/tickets/6848

  t.it('Should create events with no errors', function (t) {
    t.chain({
      dblclick: '.b-grid-subgrid-normal .b-grid-cell'
    }, {
      click: '.b-eventeditor .b-combo:nth-of-type(1) .b-icon'
    }, {
      click: '.b-list-item[data-id=plain]'
    }, {
      click: '.b-eventeditor .b-combo:nth-of-type(2) .b-icon'
    }, {
      click: '.b-list-item[data-id=red]'
    }, {
      click: '.b-button.b-green'
    });
  });
  t.browser.chrome && t.it('Picking a custom color', function (t) {
    t.chain({
      click: '[data-ref="colorCombo"]'
    }, {
      click: '.b-sch-custom'
    }, {
      type: '#333[TAB]',
      target: '[data-ref="customColor"]'
    }, {
      waitFor: function waitFor() {
        var style = t.global.getComputedStyle(scheduler.getElementFromEventRecord(scheduler.eventStore.first));
        return style.color === 'rgb(51, 51, 51)';
      },
      desc: 'Custom color applied'
    });
  });
});