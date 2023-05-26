function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, event, start, end; // So that we can t.iit certain tests

  t.beforeEach( /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = bryntum.query('scheduler');
              _context.next = 3;
              return t.waitForEventsToRender();

            case 3:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('sanity', function (t) {
    t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              t.checkGridSanity(scheduler); // Disable tooltips to do not cover event elements

              scheduler.features.eventTooltip.disabled = true;
              scheduler.features.scheduleTooltip.disabled = true;

            case 3:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    })));
  });
  t.it('Confirmation button should enable confirmation', function (t) {
    event = scheduler.eventStore.getById(1);
    start = event.startDate;
    t.chain({
      click: '[data-ref="confirmationBtn"]'
    }, {
      drag: '[data-event-id="1"]',
      offset: [15, 10],
      by: [-1 * scheduler.tickSize, 0]
    }, {
      click: '[data-ref="okButton"]'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              t.is(event.resourceId, 'a', 'Assigned to correct resource');
              t.ok(start - event.startDate, 'Start time is changed');

            case 2:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    })), {
      click: '[data-ref="confirmationBtn"]'
    });
  });
  t.it('ReadOnly button should lock modifications', function (t) {
    event = scheduler.eventStore.getById(1);
    start = event.startDate;
    t.chain({
      click: '[data-ref="lockBtn"]'
    }, {
      drag: '[data-event-id="1"]',
      offset: [15, 10],
      by: [scheduler.tickSize, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              t.is(event.resourceId, 'a', 'Assigned to correct resource');
              t.notOk(start - event.startDate, 'Start time is the same');

            case 2:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    })), {
      click: '[data-ref="lockBtn"]'
    }, {
      drag: '[data-event-id="1"]',
      offset: [15, 10],
      by: [scheduler.tickSize, 0]
    }, function () {
      t.is(event.resourceId, 'a', 'Assigned to correct resource');
      t.ok(start - event.startDate, 'Start time is changed');
    });
  });
  t.it('Dragging Scrum task to non-Developer resource should not be allowed', function (t) {
    t.chain({
      drag: '[data-event-id="1"]',
      offset: [15, 10],
      by: [0, scheduler.rowHeight]
    }, function () {
      t.is(scheduler.eventStore.getById(1).resourceId, 'a', 'Assigned to correct resource');
    });
  });
  t.it('Dragging CannotDrag task is not allowed', function (t) {
    event = scheduler.eventStore.getById(2);
    start = event.startDate;
    t.chain({
      drag: '[data-event-id="2"]',
      offset: [15, 10],
      by: [-4 * scheduler.tickSize, scheduler.rowHeight]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              t.is(event.resourceId, 'a', 'Assigned to correct resource');

            case 1:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    })), {
      drag: '[data-event-id="2"]',
      offset: [15, 10],
      by: [scheduler.tickSize, 0]
    }, function () {
      t.notOk(start - event.startDate, 'Start time is the same');
    });
  });
  t.it('Dragging PrepareCampaign task to non-Sales resource should not be allowed', function (t) {
    t.chain({
      drag: '[data-event-id="3"]',
      offset: [15, 10],
      by: [-4 * scheduler.tickSize, scheduler.rowHeight]
    }, function () {
      t.is(scheduler.eventStore.getById(3).resourceId, 'b', 'Assigned to correct resource');
    });
  });
  t.it('Dragging MarketingMeeting task to another resource should not be allowed', function (t) {
    t.chain({
      drag: '[data-event-id="4"]',
      offset: [15, 10],
      by: [0, scheduler.rowHeight]
    }, function () {
      t.is(scheduler.eventStore.getById(4).resourceId, 'c', 'Assigned to correct resource');
    });
  });
  t.it('Dragging CodingSession task to non-Developer resource should not be allowed', function (t) {
    t.chain({
      drag: '[data-event-id="5"]',
      offset: [15, 10],
      by: [0, -scheduler.rowHeight]
    }, function () {
      t.is(scheduler.eventStore.getById(5).resourceId, 'd', 'Assigned to correct resource');
    });
  });
  t.it('Dragging UXImprovements task to non-Developer resource should not be allowed', function (t) {
    t.chain({
      drag: '[data-event-id="6"]',
      offset: [15, 10],
      by: [0, -2 * scheduler.rowHeight]
    }, function () {
      t.is(scheduler.eventStore.getById(6).resourceId, 'e', 'Assigned to correct resource');
    });
  });
  t.it('Dragging FixedTime task to another time should not be allowed', function (t) {
    t.chain({
      drag: '[data-event-id="7"]',
      offset: [15, 10],
      by: [3 * scheduler.tickSize, 0]
    }, function () {
      t.is(scheduler.eventStore.getById(7).resourceId, 'e', 'Assigned to correct resource');
    });
  });
  t.it('Dragging first Golf task to non-CEO resource should not be allowed', function (t) {
    t.chain({
      drag: '[data-event-id="8"]',
      offset: [15, 10],
      by: [2 * scheduler.tickSize, -2 * scheduler.rowHeight]
    }, function () {
      t.is(scheduler.eventStore.getById(8).resourceId, 'g', 'Assigned to correct resource');
    });
  });
  t.it('Dragging second Golf task to non-CTO resource should not be allowed', function (t) {
    t.chain({
      drag: '[data-event-id="9"]',
      offset: [15, 10],
      by: [2 * scheduler.tickSize, -3 * scheduler.rowHeight]
    }, function () {
      t.is(scheduler.eventStore.getById(9).resourceId, 'h', 'Assigned to correct resource');
    });
  });
  t.it('Dragging Scrum task to another Developer resource should be allowed', function (t) {
    event = scheduler.eventStore.getById(1);
    start = event.startDate;
    t.chain({
      drag: '[data-event-id="1"]',
      offset: [15, 10],
      by: [3 * scheduler.tickSize, 3 * scheduler.rowHeight]
    }, function () {
      t.is(scheduler.eventStore.getById(1).resourceId, 'd', 'Assigned to correct resource');
      t.ok(start - event.startDate, 'Start time is changed');
    });
  });
  t.it('Dragging PrepareCampaign task to another time should be allowed', function (t) {
    event = scheduler.eventStore.getById(3);
    start = event.startDate;
    t.chain({
      drag: '[data-event-id="3"]',
      offset: [15, 10],
      by: [scheduler.tickSize, 0]
    }, function () {
      t.ok(start - event.startDate, 'Start time is changed');
    });
  });
  t.it('Dragging MarketingMeeting task to another time should be allowed', function (t) {
    event = scheduler.eventStore.getById(4);
    start = event.startDate;
    t.chain({
      drag: '[data-event-id="4"]',
      offset: [15, 10],
      by: [scheduler.tickSize, 0]
    }, function () {
      t.ok(start - event.startDate, 'Start time is changed');
    });
  });
  t.it('Dragging CodingSession task to another Developer resource and another time should be allowed', function (t) {
    event = scheduler.eventStore.getById(5);
    start = event.startDate;
    t.chain({
      drag: '[data-event-id="5"]',
      offset: [15, 10],
      by: [scheduler.tickSize, -3 * scheduler.rowHeight]
    }, function () {
      t.is(event.resourceId, 'a', 'Assigned to correct resource');
      t.ok(start - event.startDate, 'Start time is changed');
    });
  });
  t.it('Dragging UXImprovements task to another time should be allowed', function (t) {
    event = scheduler.eventStore.getById(6);
    start = event.startDate;
    t.chain({
      drag: '[data-event-id="6"]',
      offset: [15, 10],
      by: [5 * scheduler.tickSize, 0]
    }, function () {
      t.ok(start - event.startDate, 'Start time is changed');
    });
  });
  t.it('Dragging FixedTime task to another Developer resource but the same time should be allowed', function (t) {
    event = scheduler.eventStore.getById(7);
    start = event.startDate;
    t.chain({
      drag: '[data-event-id="7"]',
      offset: [15, 10],
      by: [-1 * scheduler.tickSize, -1 * scheduler.rowHeight]
    }, function () {
      t.is(event.resourceId, 'd', 'Assigned to correct resource');
      t.notOk(start - event.startDate, 'Start time is the same');
    });
  });
  t.it('Dragging first Golf task to CTO resource should be allowed', function (t) {
    event = scheduler.eventStore.getById(8);
    start = event.startDate;
    t.chain({
      drag: '[data-event-id="8"]',
      offset: [15, 10],
      by: [7 * scheduler.tickSize, scheduler.rowHeight]
    }, function () {
      t.is(event.resourceId, 'h', 'Assigned to correct resource');
      t.ok(start - event.startDate, 'Start time is changed');
    });
  });
  t.it('Dragging second Golf task to CEO resource should be allowed', function (t) {
    event = scheduler.eventStore.getById(9);
    start = event.startDate;
    t.chain({
      drag: '[data-event-id="9"]',
      offset: [15, 10],
      by: [scheduler.tickSize, -1 * scheduler.rowHeight]
    }, function () {
      t.is(event.resourceId, 'g', 'Assigned to correct resource');
      t.ok(start - event.startDate, 'Start time is changed');
    });
  });
  t.it('Resizing Scrum task in both directions should be allowed', function (t) {
    event = scheduler.eventStore.getById(1);
    start = event.startDate;
    end = event.endDate;
    t.chain(function () {
      return scheduler.scrollEventIntoView(event, {
        block: 'center'
      });
    }, {
      drag: '[data-event-id="1"]',
      offset: [5, '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6() {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              t.ok(start - event.startDate, 'Start time is changed');

            case 1:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    })), {
      drag: '[data-event-id="1"]',
      offset: [5, '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              t.notOk(start - event.startDate, 'Start time is back');

            case 1:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    })), {
      drag: '[data-event-id="1"]',
      offset: ['100%-5', '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8() {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              t.ok(end - event.endDate, 'End time is changed');

            case 1:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    })), {
      drag: '[data-event-id="1"]',
      offset: ['100%-5', '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, function () {
      t.notOk(end - event.endDate, 'End time is back');
    });
  });
  t.it('Resizing CannotDrag task in both directions should be allowed', function (t) {
    event = scheduler.eventStore.getById(2);
    start = event.startDate;
    end = event.endDate;
    t.chain(function () {
      return scheduler.scrollEventIntoView(event, {
        block: 'center'
      });
    }, {
      drag: '[data-event-id="2"]',
      offset: [5, '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9() {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              t.ok(start - event.startDate, 'Start time is changed');

            case 1:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    })), {
      drag: '[data-event-id="2"]',
      offset: [5, '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10() {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              t.notOk(start - event.startDate, 'Start time is back');

            case 1:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    })), {
      drag: '[data-event-id="2"]',
      offset: ['100%-5', '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11() {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              t.ok(end - event.endDate, 'End time is changed');

            case 1:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    })), {
      drag: '[data-event-id="2"]',
      offset: ['100%-5', '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, function () {
      t.notOk(end - event.endDate, 'End time is back');
    });
  });
  t.it('Resizing PrepareCampaign task in both directions should be allowed', function (t) {
    event = scheduler.eventStore.getById(3);
    start = event.startDate;
    end = event.endDate;
    t.chain(function () {
      return scheduler.scrollEventIntoView(event, {
        block: 'center'
      });
    }, {
      drag: '[data-event-id="3"]',
      offset: [5, '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12() {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              t.ok(start - event.startDate, 'Start time is changed');

            case 1:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    })), {
      drag: '[data-event-id="3"]',
      offset: [5, '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13() {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              t.notOk(start - event.startDate, 'Start time is back');

            case 1:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    })), {
      drag: '[data-event-id="3"]',
      offset: ['100%-5', '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14() {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              t.ok(end - event.endDate, 'End time is changed');

            case 1:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    })), {
      drag: '[data-event-id="3"]',
      offset: ['100%-5', '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, function () {
      t.notOk(end - event.endDate, 'End time is back');
    });
  });
  t.it('Resizing MarketingMeeting task in both directions should be allowed', function (t) {
    event = scheduler.eventStore.getById(4);
    start = event.startDate;
    end = event.endDate;
    t.chain(function () {
      return scheduler.scrollEventIntoView(event, {
        block: 'center'
      });
    }, {
      drag: '[data-event-id="4"]',
      offset: [5, '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15() {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              t.ok(start - event.startDate, 'Start time is changed');

            case 1:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    })), {
      drag: '[data-event-id="4"]',
      offset: [5, '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16() {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              t.notOk(start - event.startDate, 'Start time is back');

            case 1:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    })), {
      drag: '[data-event-id="4"]',
      offset: ['100%-5', '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17() {
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              t.ok(end - event.endDate, 'End time is changed');

            case 1:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    })), {
      drag: '[data-event-id="4"]',
      offset: ['100%-5', '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, function () {
      t.notOk(end - event.endDate, 'End time is back');
    });
  });
  t.it('Resizing CodingSession task in both directions should be allowed but the task cannot be shortened', function (t) {
    event = scheduler.eventStore.getById(5);
    start = event.startDate;
    end = event.endDate;
    t.chain(function () {
      return scheduler.scrollEventIntoView(event, {
        block: 'center'
      });
    }, {
      drag: '[data-event-id="5"]',
      offset: [5, '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18() {
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              t.ok(start - event.startDate, 'Start time is changed');

            case 1:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    })), {
      drag: '[data-event-id="5"]',
      offset: [5, '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19() {
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              t.ok(start - event.startDate, 'Start time is not back');

            case 1:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    })), {
      drag: '[data-event-id="5"]',
      offset: ['100%-5', '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20() {
      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              t.notOk(end - event.endDate, 'End time is not changed');

            case 1:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    })), {
      drag: '[data-event-id="5"]',
      offset: ['100%-5', '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, function () {
      t.ok(end - event.endDate, 'End time is changed');
    });
  });
  t.it('Resizing UXImprovements task in both directions should be allowed but the task cannot be shortened', function (t) {
    event = scheduler.eventStore.getById(6);
    start = event.startDate;
    end = event.endDate;
    t.chain(function () {
      return scheduler.scrollEventIntoView(event, {
        block: 'center'
      });
    }, {
      drag: '[data-event-id="6"]',
      offset: [5, '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21() {
      return regeneratorRuntime.wrap(function _callee21$(_context21) {
        while (1) {
          switch (_context21.prev = _context21.next) {
            case 0:
              t.ok(start - event.startDate, 'Start time is changed');

            case 1:
            case "end":
              return _context21.stop();
          }
        }
      }, _callee21);
    })), {
      drag: '[data-event-id="6"]',
      offset: [5, '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22() {
      return regeneratorRuntime.wrap(function _callee22$(_context22) {
        while (1) {
          switch (_context22.prev = _context22.next) {
            case 0:
              t.ok(start - event.startDate, 'Start time is not back');

            case 1:
            case "end":
              return _context22.stop();
          }
        }
      }, _callee22);
    })), {
      drag: '[data-event-id="6"]',
      offset: ['100%-5', '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23() {
      return regeneratorRuntime.wrap(function _callee23$(_context23) {
        while (1) {
          switch (_context23.prev = _context23.next) {
            case 0:
              t.notOk(end - event.endDate, 'End time is not changed');

            case 1:
            case "end":
              return _context23.stop();
          }
        }
      }, _callee23);
    })), {
      drag: '[data-event-id="6"]',
      offset: ['100%-5', '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, function () {
      t.ok(end - event.endDate, 'End time is changed');
    });
  });
  t.it('Resizing FixedTime task in both directions should not be allowed', function (t) {
    event = scheduler.eventStore.getById(7);
    start = event.startDate;
    end = event.endDate;
    t.chain(function () {
      return scheduler.scrollEventIntoView(event, {
        block: 'center'
      });
    }, {
      drag: '[data-event-id="7"]',
      offset: [5, '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee24() {
      return regeneratorRuntime.wrap(function _callee24$(_context24) {
        while (1) {
          switch (_context24.prev = _context24.next) {
            case 0:
              t.notOk(start - event.startDate, 'Start time is not changed');

            case 1:
            case "end":
              return _context24.stop();
          }
        }
      }, _callee24);
    })), {
      drag: '[data-event-id="7"]',
      offset: [5, '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee25() {
      return regeneratorRuntime.wrap(function _callee25$(_context25) {
        while (1) {
          switch (_context25.prev = _context25.next) {
            case 0:
              t.notOk(start - event.startDate, 'Start time is not changed');

            case 1:
            case "end":
              return _context25.stop();
          }
        }
      }, _callee25);
    })), {
      drag: '[data-event-id="7"]',
      offset: ['100%-5', '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee26() {
      return regeneratorRuntime.wrap(function _callee26$(_context26) {
        while (1) {
          switch (_context26.prev = _context26.next) {
            case 0:
              t.notOk(end - event.endDate, 'End time is not changed');

            case 1:
            case "end":
              return _context26.stop();
          }
        }
      }, _callee26);
    })), {
      drag: '[data-event-id="7"]',
      offset: ['100%-5', '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, function () {
      t.notOk(end - event.endDate, 'End time is not changed');
    });
  });
  t.it('Resizing first Golf task in both directions should not be allowed', function (t) {
    event = scheduler.eventStore.getById(8);
    start = event.startDate;
    end = event.endDate;
    t.chain(function () {
      scheduler.zoomOut();
      return scheduler.scrollEventIntoView(event, {
        block: 'center'
      });
    }, {
      drag: '[data-event-id="8"]',
      offset: [5, '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee27() {
      return regeneratorRuntime.wrap(function _callee27$(_context27) {
        while (1) {
          switch (_context27.prev = _context27.next) {
            case 0:
              t.notOk(start - event.startDate, 'Start time is not changed');

            case 1:
            case "end":
              return _context27.stop();
          }
        }
      }, _callee27);
    })), {
      drag: '[data-event-id="8"]',
      offset: [5, '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee28() {
      return regeneratorRuntime.wrap(function _callee28$(_context28) {
        while (1) {
          switch (_context28.prev = _context28.next) {
            case 0:
              t.notOk(start - event.startDate, 'Start time is not changed');

            case 1:
            case "end":
              return _context28.stop();
          }
        }
      }, _callee28);
    })), function () {
      return scheduler.scrollEventIntoView(event, {
        block: 'end',
        edgeOffset: 3 * scheduler.tickSize
      });
    }, {
      drag: '[data-event-id="8"]',
      offset: ['100%-5', '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee29() {
      return regeneratorRuntime.wrap(function _callee29$(_context29) {
        while (1) {
          switch (_context29.prev = _context29.next) {
            case 0:
              t.notOk(end - event.endDate, 'End time is not changed');

            case 1:
            case "end":
              return _context29.stop();
          }
        }
      }, _callee29);
    })), {
      drag: '[data-event-id="8"]',
      offset: ['100%-5', '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, function () {
      t.notOk(end - event.endDate, 'End time is not changed');
    });
  });
  t.it('Resizing second Golf task in both directions should not be allowed', function (t) {
    event = scheduler.eventStore.getById(9);
    start = event.startDate;
    end = event.endDate;
    t.chain(function () {
      return scheduler.scrollEventIntoView(event, {
        block: 'center'
      });
    }, {
      drag: '[data-event-id="9"]',
      offset: [5, '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee30() {
      return regeneratorRuntime.wrap(function _callee30$(_context30) {
        while (1) {
          switch (_context30.prev = _context30.next) {
            case 0:
              t.notOk(start - event.startDate, 'Start time is not changed');

            case 1:
            case "end":
              return _context30.stop();
          }
        }
      }, _callee30);
    })), {
      drag: '[data-event-id="9"]',
      offset: [5, '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee31() {
      return regeneratorRuntime.wrap(function _callee31$(_context31) {
        while (1) {
          switch (_context31.prev = _context31.next) {
            case 0:
              t.notOk(start - event.startDate, 'Start time is not changed');

            case 1:
            case "end":
              return _context31.stop();
          }
        }
      }, _callee31);
    })), {
      drag: '[data-event-id="9"]',
      offset: ['100%-5', '50%'],
      by: [-1 * scheduler.tickSize / 2, 0]
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee32() {
      return regeneratorRuntime.wrap(function _callee32$(_context32) {
        while (1) {
          switch (_context32.prev = _context32.next) {
            case 0:
              t.notOk(end - event.endDate, 'End time is not changed');

            case 1:
            case "end":
              return _context32.stop();
          }
        }
      }, _callee32);
    })), {
      drag: '[data-event-id="9"]',
      offset: ['100%-5', '50%'],
      by: [scheduler.tickSize / 2, 0]
    }, function () {
      t.notOk(end - event.endDate, 'End time is not changed');
    });
  });
  t.it('Should not fail on dbl click to create event', function (t) {
    t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee33() {
      return regeneratorRuntime.wrap(function _callee33$(_context33) {
        while (1) {
          switch (_context33.prev = _context33.next) {
            case 0:
              return _context33.abrupt("return", scheduler.timeAxisSubGrid.scrollable.x = 0);

            case 1:
            case "end":
              return _context33.stop();
          }
        }
      }, _callee33);
    })), {
      dblClick: '[data-region="normal"] .b-grid-row',
      offset: [10, '50%'],
      desc: 'Create new event with dbl click'
    });
  });
});