StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    scheduler = bryntum.query('scheduler');
  });
  t.it('Should not be able to add a new match between same teams', function (t) {
    t.chain({
      contextmenu: '.b-sch-timeaxis-cell',
      offset: [518, 38]
    }, function (next) {
      // Provision event is added , but removed on cancel
      t.firesOnce(scheduler.eventStore, 'add');
      t.firesOnce(scheduler.eventStore, 'remove');
      next();
    }, {
      click: '.b-menuitem:contains(Add)'
    }, {
      click: 'button:contains(Save)'
    }, {
      waitForEvent: [scheduler.eventStore, 'remove'],
      trigger: {
        click: 'button:contains(Cancel)'
      }
    });
  });
  t.it('Should be able to add a new match', function (t) {
    t.chain({
      contextmenu: '[data-index="1"] .b-sch-timeaxis-cell',
      offset: [518, 38]
    }, function (next) {
      t.firesOnce(scheduler.eventStore, 'add');
      next();
    }, {
      click: '.b-menuitem:contains(Add)'
    }, {
      click: '#save'
    });
  });
});