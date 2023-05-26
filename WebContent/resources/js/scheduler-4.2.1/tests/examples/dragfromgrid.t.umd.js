function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler = bryntum.query('schedule'),
      grid = bryntum.query('unplannedgrid'),
      resourceStore = scheduler.resourceStore,
      eventStore = scheduler.eventStore; // Avoid scrolling triggered in test

  scheduler.timeAxisViewModel.forceFit = true;
  t.it('Should be able to drag a task from grid onto the schedule', function (t) {
    // Cell width is not equal to dragging event width so using fixed offset in pixels to check cursor position later
    var offsetPx = 10;
    t.chain({
      drag: '.b-grid-cell:textEquals(Fun task)',
      fromOffset: [offsetPx, '50%'],
      to: '.b-grid-row[data-index=4] .b-sch-timeaxis-cell',
      toOffset: ['50%', '50%'],
      dragOnly: true
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
      var el;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              el = document.querySelector(scheduler.eventSelector + '.b-dragging');
              t.isApproxPx(el.getBoundingClientRect().left - el.style.paddingLeft + offsetPx, t.currentPosition[0], 1, 'Proxy is at cursor');

            case 2:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    })), {
      mouseUp: null
    }, {
      waitForSelectorNotFound: '[data-ref=unplanned] .b-grid-row .b-grid-cell:textEquals(Fun task)'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      var maxim;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              maxim = resourceStore.getAt(4);
              t.is(maxim.events.length, 1);
              t.is(maxim.events[0].name, 'Fun task');

            case 3:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    })), {
      contextmenu: scheduler.eventSelector + ':contains(Fun task)'
    }, {
      click: '.b-menuitem:contains(Unassign)'
    }, {
      waitForSelector: '[data-ref=unplanned] .b-grid-row .b-grid-cell:textEquals(Fun task)'
    }, function () {
      var maxim = resourceStore.getAt(4);
      t.is(maxim.events.length, 0);
    });
  });
  t.it('Dropping on an existing event should work', function (t) {
    t.chain({
      waitForSelector: scheduler.eventSelector + '[data-event-id="r1"]'
    }, {
      drag: '.b-grid-cell:textEquals(Fun task)',
      fromOffset: ['5%', '50%'],
      to: scheduler.eventSelector + '[data-event-id="r1"]'
    }, function () {
      var arcady = resourceStore.first;
      t.is(arcady.events.length, 3, 'Arcady now assigned 3 events');
    });
  });
  t.it('Dragging to invalid place should have no side effect on data', function (t) {
    var store = grid.store;
    t.wontFire(store, 'change');
    t.chain({
      drag: '[data-ref=unplanned] .b-grid-cell',
      fromOffset: ['5%', '50%'],
      to: '.demo-header'
    });
  });
  t.it('Should reschedule tasks when there is an overlap (based on button pressed state)', function (t) {
    var droppedOnTask = eventStore.find(function (event) {
      return event.name.match('Conference');
    }),
        startDate = droppedOnTask.startDate; // Trying to fix test, not sure why it does not reschedule

    scheduler.autoRescheduleTasks = true;
    t.firesOnce(eventStore, 'refreshPreCommit');
    t.wontFire(eventStore, 'addPreCommit', 'Should batch store changes'); // Removed `wontFire('update')`, since ending the batch makes engine normalize changes, which triggers 'update'

    var eventElCount = scheduler.timeAxisSubGridElement.querySelectorAll(scheduler.unreleasedEventSelector).length;
    t.chain({
      click: '.reschedule-button'
    }, {
      waitForSelector: scheduler.eventSelector + ':contains(Conference prep)'
    }, {
      // No longer redrawn from batch on `refresh`, but instead on following record updates
      waitForEvent: [eventStore, 'update'],
      trigger: {
        drag: '[data-ref=unplanned] .b-grid-cell:textEquals(Gym)',
        to: scheduler.eventSelector + ':contains(Conference prep)',
        fromOffset: ['5%', '50%'],
        toOffset: ['5%', '50%']
      }
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
      var draggedTask;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              draggedTask = eventStore.find(function (event) {
                return event.name === 'Gym';
              });
              t.expect(draggedTask.startDate).toEqual(startDate);
              t.expect(droppedOnTask.startDate).toEqual(draggedTask.endDate); // https://app.assembla.com/spaces/bryntum/tickets/8663
              // No duplicate elements.

              t.selectorCountIs(scheduler.unreleasedEventSelector, scheduler.timeAxisSubGridElement, eventElCount + 1);

            case 4:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    })), {
      click: '.reschedule-button',
      desc: 'Restore button state'
    });
  });
  t.it('Should NOT reschedule tasks when there is an overlap if button is not pressed', function (t) {
    var droppedOnTask = eventStore.find(function (event) {
      return event.name.match('Arrange');
    }); // For normalization

    t.firesOnce(eventStore, 'update');
    t.chain({
      waitForSelector: scheduler.eventSelector + ':contains(Arrange)'
    }, {
      drag: '[data-ref=unplanned] .b-grid-cell:contains(boring)',
      to: scheduler.eventSelector + ':contains(Arrange)',
      fromOffset: ['5%', '50%'],
      toOffset: ['5%', '50%']
    }, function () {
      var draggedTask = eventStore.find(function (event) {
        return event.name.match('boring');
      });
      t.expect(draggedTask.startDate).toEqual(droppedOnTask.startDate);
    });
  });
  t.it('Should scroll timeline when task is dragged from external grid', function (t) {
    t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              scheduler.timeAxisViewModel.forceFit = false;
              t.firesAtLeastNTimes(scheduler.timeAxisSubGrid.scrollable, 'scroll', 1);

            case 2:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    })), {
      drag: '[data-ref=unplanned] .b-grid-cell',
      to: '.b-scheduler',
      toOffset: ['100%-20', '50%'],
      dragOnly: true
    }, {
      waitFor: function waitFor() {
        return t.samePx(scheduler.timeAxisSubGrid.scrollable.x, scheduler.timeAxisSubGrid.scrollable.maxX);
      }
    }, {
      mouseUp: null
    }, function () {
      // Restore for further tests
      scheduler.timeAxisViewModel.forceFit = true;
    });
  });
  t.it('Should use correct store & model classes', function (t) {
    t.ok(scheduler.eventStore.isTaskStore, 'Correct EventStore class');
    t.ok(scheduler.eventStore.modelClass.isTask, 'Correct EventStore modelClass');
    t.ok(grid.store.modelClass.isTask, 'Correct grid modelClass');
  }); // https://github.com/bryntum/support/issues/1464

  t.it('Unassigning new event should keep data', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var count;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              count = grid.store.count;
              _context5.next = 3;
              return t.doubleClick('[data-id="12"] .b-sch-timeaxis-cell');

            case 3:
              _context5.next = 5;
              return t.click('button:textEquals(Save)');

            case 5:
              scheduler.eventStore.last.unassign();
              _context5.next = 8;
              return t.waitFor(function () {
                return grid.store.count > count;
              });

            case 8:
              t.is(grid.store.last.name, 'New event', 'Correct name on unassigned event');
              t.is(grid.store.last.duration, 1, 'Correct duration on unassigned event');
              t.is(grid.store.last.durationUnit, 'h', 'Correct durationUnit on unassigned event');

            case 11:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x) {
      return _ref5.apply(this, arguments);
    };
  }());
});