function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler = bryntum.query('schedule'),
      equipment = bryntum.query('equipmentgrid'); //  TODO remove when this is fixed: https://app.assembla.com/spaces/bryntum/tickets/8772-scheduletooltip-should-reposition-itself-upon-hover-over-it/details#

  scheduler.features.scheduleTooltip.disabled = true;
  t.it('sanity', function (t) {
    t.chain(function () {
      return t.checkGridSanity(scheduler);
    });
  });
  t.it('Should be able to drag equipment from grid onto a task', function (t) {
    var equipmentStore = equipment.store;
    var eventStore = scheduler.eventStore;
    t.chain( // Wait for initial data is set to stores (otherwise 'change' event is fired with 'dataset' action in IE11)
    {
      waitFor: function waitFor() {
        return eventStore.count === 6 && equipmentStore.count === 9;
      }
    }, {
      waitForSelector: scheduler.eventSelector + '[data-event-id="r3"]'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.willFireNTimes(eventStore, 'change', 2);
              t.wontFire(equipmentStore, 'change');

            case 2:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    })), {
      drag: '.b-equipment:contains(Video camera)',
      to: scheduler.eventSelector + '[data-event-id="r3"]'
    }, {
      drag: '.b-equipment:contains(Microphone)',
      to: scheduler.eventSelector + '[data-event-id="r3"]'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              t.selectorExists(scheduler.eventSelector + '[data-event-id="r3"] .b-fa.b-fa-video', 'Video icon rendered');
              t.selectorExists(scheduler.eventSelector + '[data-event-id="r3"] .b-fa.b-fa-microphone', 'Microphone icon rendered');

            case 2:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    })), {
      dblClick: '[data-event-id="r3"]'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
      var equipmentCombo;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              equipmentCombo = scheduler.features.eventEdit.getEditor().widgetMap.equipment;
              t.is(equipmentCombo.store.count, 9, 'Equipment store has correct contents');

            case 2:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    })), {
      click: '.b-button:contains(Cancel)'
    });
  });
  t.it('Dragging to invalid place should have no side effect on data', function (t) {
    var equipmentStore = equipment.store;
    var eventStore = scheduler.eventStore;
    t.wontFire(equipmentStore, 'change');
    t.wontFire(eventStore, 'change');
    t.chain({
      drag: '[data-ref=equipment] .b-grid-cell',
      to: '[data-ref=schedule] .b-grid-row:nth-child(6) .b-sch-timeaxis-cell'
    });
  });
  t.it('Should not crash when filtering equipment grid and dragging onto task', function (t) {
    var eventStore = scheduler.eventStore;
    t.chain({
      click: '.b-filter-bar-field'
    }, {
      type: 'tool',
      target: '.b-filter-bar-field'
    }, {
      waitForSelector: '[data-ref=equipment] .b-grid-row[data-index="0"] .b-grid-cell:contains(Toolbox)'
    }, {
      drag: '[data-ref=equipment] .b-grid-cell',
      to: scheduler.eventSelector + ':contains(CLASSIFIED)'
    }, function () {
      var classifiedEvent = eventStore.getById('r3');
      t.is(classifiedEvent.equipment.length, 4, '4 items added to event');
    });
  });
});