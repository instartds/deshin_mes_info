StartTest(function (t) {
  //const scheduler = bryntum.query('scheduler');
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
  t.it('First tab', function (t) {
    // Check demo specific time axis customization
    t.selectorNotExists('[data-ref=custom1] .b-sch-header-timeaxis-cell:textEquals(7)', 'No header for 7');

    for (var i = 8; i < 22; i++) {
      t.selectorExists("[data-ref=custom1] .b-sch-header-timeaxis-cell:textEquals(".concat(i, ")"), 'Header for ' + i);
    }

    t.selectorNotExists('[data-ref=custom1] .b-sch-header-timeaxis-cell:textEquals(22)', 'No header for 22');
  });
  t.it('Second tab', function (t) {
    t.chain({
      click: '.b-tabpanel-tab[data-index="1"]'
    }, function () {
      var dayElements = Array.from(document.querySelectorAll('.sch-hdr-startend'));

      var getText = function getText(i) {
        return dayElements[i].innerText.replace(/\n/g, '');
      };

      t.selectorCountIs('[data-ref=custom2] .b-sch-header-timeaxis-cell', 10, 'Correct header cell count');
      t.is(dayElements.length, 5, 'Correct day header count');
      t.is(getText(0), '816', 'Correct text in day header');
      t.is(getText(1), '816', 'Correct text in day header');
      t.is(getText(2), '816', 'Correct text in day header');
      t.is(getText(3), '816', 'Correct text in day header');
      t.is(getText(4), '1016', 'Correct text in day header');
    });
  });
  t.it('Third tab', function (t) {
    t.chain({
      click: '.b-tabpanel-tab[data-index="2"]'
    }, function () {
      var texts = Array.from(document.querySelectorAll('[data-ref=filterable] .b-sch-header-row-2 .b-sch-header-timeaxis-cell')).map(function (el) {
        return el.innerText.trim();
      });
      t.is(texts[0], '1', 'Correct sum for sunday');
      t.is(texts[1], '0', 'Correct sum for monday');
      t.is(texts[2], '0', 'Correct sum for tuesday');
      t.is(texts[3], '0', 'Correct sum for wednesday');
      t.is(texts[4], '0', 'Correct sum for thursday');
      t.is(texts[5], '1', 'Correct sum for friday');
      t.is(texts[6], '1', 'Correct sum for saturday');
    });
  });
  t.it('Fourth tab', function (t) {
    t.chain({
      click: '.b-tabpanel-tab[data-index="3"]'
    }, function () {
      var texts = Array.from(document.querySelectorAll('[data-ref=filterable] .b-sch-header-row-2 .b-sch-header-timeaxis-cell')).map(function (el) {
        return el.innerText.trim();
      });
      t.is(texts[0], '1', 'Correct sum for sunday');
      t.is(texts[1], '0', 'Correct sum for monday');
      t.is(texts[2], '0', 'Correct sum for tuesday');
      t.is(texts[3], '0', 'Correct sum for wednesday');
      t.is(texts[4], '0', 'Correct sum for thursday');
      t.is(texts[5], '1', 'Correct sum for friday');
      t.is(texts[6], '1', 'Correct sum for saturday');
    });
  });
});