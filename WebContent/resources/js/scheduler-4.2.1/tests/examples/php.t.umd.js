function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  // Use unique cookie session ID per test
  t.setRandomPHPSession();
  var scheduler = bryntum.query('scheduler');
  t.beforeEach( /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t, next) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.click('[data-ref=resetButton]');

            case 2:
              t.waitForProjectReady(scheduler, next);

            case 3:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x, _x2) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('sanity', function (t) {
    t.checkGridSanity(scheduler);
  }); // https://app.assembla.com/spaces/bryntum/tickets/8819

  t.it('Editing an event and changing resource should work', function (t) {
    t.chain({
      dblclick: '.b-sch-event'
    }, {
      click: '.b-icon-picker'
    }, {
      click: '.b-list-item:contains(BMW M3)'
    }, {
      waitForEvent: [scheduler.eventStore, 'commit'],
      trigger: function trigger() {
        t.click('button:contains(Save)');
      }
    }, function () {
      t.is(scheduler.eventStore.first.resourceId, 3, 'Successfully edited');
      t.selectorCountIs('.b-sch-event', '.b-scheduler', 9, 'Rendered elements match real number in the store');
    });
  });
  t.it('Dragging to a different resource should work', function (t) {
    t.chain({
      waitForEvent: [scheduler.eventStore, 'commit'],
      trigger: function trigger() {
        t.dragBy('.b-sch-event', [0, scheduler.rowHeight * 2]);
      }
    }, {
      waitFor: function waitFor() {
        return scheduler.eventStore.first.resourceId === 3;
      },
      desc: 'Successfully dragged'
    }, function () {
      t.selectorCountIs('.b-sch-event', '.b-scheduler', 9, 'Rendered elements match real number in the store');
    });
  });
  t.it('Dragging to the same resource should work', function (t) {
    t.chain({
      waitForEvent: [scheduler.eventStore, 'commit'],
      trigger: function trigger() {
        t.dragBy('.b-sch-event', [-scheduler.tickSize, 0]);
      }
    }, {
      waitFor: function waitFor() {
        return scheduler.eventStore.first.startDate - new Date(2018, 4, 21, 7) === 0;
      },
      desc: 'Successfully dragged'
    }, function () {
      t.selectorCountIs('.b-sch-event', '.b-scheduler', 9, 'Rendered elements match real number in the store');
    });
  }); // https://app.assembla.com/spaces/bryntum/tickets/8818
  // https://app.assembla.com/spaces/bryntum/tickets/9111

  t.it('Creating a new event should work', function (t) {
    var elements = Array.from(document.querySelectorAll('.b-sch-event-wrap')),
        elementIds = elements.map(function (el) {
      return el.dataset.eventId;
    });
    t.chain({
      drag: '.b-sch-timeaxis-cell',
      fromOffset: [2, 2],
      by: [50, 0]
    }, {
      waitFor: function waitFor() {
        var _scheduler$features$e;

        return (_scheduler$features$e = scheduler.features.eventEdit.editor) === null || _scheduler$features$e === void 0 ? void 0 : _scheduler$features$e.containsFocus;
      }
    }, {
      type: 'Test'
    }, {
      waitForEvent: [scheduler.eventStore, 'commit'],
      trigger: function trigger() {
        t.click('button:contains(Save)');
      }
    }, function () {
      var newRecord = scheduler.eventStore.last;
      t.is(newRecord.name, 'Test', 'New record correctly appended');
      t.is(newRecord.isModified, false, 'New record is unmodified after commit');
      t.is(scheduler.eventStore.modified.count, 0, 'No modified records after commit');
      t.is(scheduler.eventStore.allCount, 10, 'Successfully created');
      var currentElementIds = elements.map(function (el) {
        return el.dataset.eventId;
      });
      t.isDeeply(elementIds, currentElementIds, 'All elements should still belong to their initial event');
    });
  });
  t.it('Deleting an event should work', function (t) {
    t.chain({
      contextmenu: scheduler.unreleasedEventSelector
    }, {
      waitForEvent: [scheduler.eventStore, 'commit'],
      trigger: function trigger() {
        t.click('.b-menuitem:contains(Delete event)');
      }
    }, function () {
      t.is(scheduler.eventStore.allCount, 8, 'Successfully deleted');
    });
  });
  t.it('Deleting a resource should work', function (t) {
    t.chain({
      waitForEvent: [scheduler.resourceStore, 'commit'],
      trigger: function trigger() {
        scheduler.resourceStore.first.remove();
      }
    }, function () {
      t.is(scheduler.resourceStore.allCount, 4, 'Successfully deleted');
    });
  }); // Tickets #8893, #8894

  t.it('Creating a new event, modifying and removing it and existing one should work', function (t) {
    var store = scheduler.eventStore;
    t.chain( // Create Event
    {
      drag: '.b-sch-timeaxis-cell',
      fromOffset: [2, 260],
      by: [100, 0]
    }, {
      type: 'Test'
    }, {
      waitForEvent: [store, 'commitAdded'],
      trigger: function trigger() {
        t.click('button:contains(Save)');
      }
    }, function (next) {
      t.is(store.modified.count, 0, 'Store is unmodified after commit');
      t.ok(store.getById(11), 'New event has correct id');
      t.is(Object.keys(store.getById(11).meta.modified).length, 0, 'New record is unmodified after commit');
      next();
    }, // Drag created event
    {
      waitForEvent: [store, 'commitModified'],
      trigger: function trigger() {
        t.dragBy(':not(.b-released)[data-event-id=11]', [50, 0]);
      }
    }, function (next) {
      t.is(store.getById(11).startDate, new Date(2018, 4, 21, 6, 30), 'Correct date after drag');
      next();
    }, // Modify created event
    {
      doubleClick: ':not(.b-released)[data-event-id=11]'
    }, {
      type: ' Updated'
    }, {
      waitForEvent: [store, 'commitModified'],
      trigger: function trigger() {
        t.click('button:contains(Save)');
      }
    }, function (next) {
      t.is(store.getById(11).name, 'Test Updated', 'Correct name after update');
      next();
    }, // Drag existing event
    {
      waitForEvent: [store, 'commitModified'],
      trigger: function trigger() {
        t.dragBy('[data-event-id=7]', [50, 0]);
      }
    }, function (next) {
      t.is(store.getById(7).startDate, new Date(2018, 4, 21, 9, 30), 'Correct date after drag');
      next();
    }, // Modify existing event
    {
      doubleClick: '[data-event-id=7]'
    }, {
      type: ' Updated'
    }, {
      waitForEvent: [store, 'commitModified'],
      trigger: function trigger() {
        t.click('button:contains(Save)');
      }
    }, function (next) {
      t.is(store.getById(7).name, 'Replace airbag Updated', 'Correct name after update');
      next();
    }, // Delete new event
    {
      rightClick: ':not(.b-released)[data-event-id=11]'
    }, {
      waitForEvent: [store, 'commitRemoved'],
      trigger: function trigger() {
        t.click('.b-menu-text:contains(Delete event)');
      }
    }, function (next) {
      t.notOk(store.getById(11), 'New event has been removed');
      next();
    }, // Delete existing event
    {
      rightClick: '[data-event-id=7]'
    }, {
      waitForEvent: [store, 'commitRemoved'],
      trigger: function trigger() {
        t.click('.b-menu-text:contains(Delete event)');
      }
    }, function () {
      t.notOk(store.getById(7), 'Existing event has been removed');
    });
  });
});