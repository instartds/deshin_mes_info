function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest({
  defaultTimeout: 90000
}, function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(config) {
      var scheduler;
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              scheduler = t.getScheduler(Object.assign({
                features: {
                  eventDragCreate: false,
                  eventDragSelect: true
                }
              }, config));
              _context7.next = 3;
              return t.waitForProjectReady();

            case 3:
              return _context7.abrupt("return", scheduler);

            case 4:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('Should select events during drag', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler({
                events: [{
                  id: 1,
                  cls: 'one',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }, {
                  id: 2,
                  cls: 'two',
                  resourceId: 'r3',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }]
              });

            case 2:
              scheduler = _context.sent;
              t.willFireNTimes(scheduler, 'eventselectionchange', 3);
              t.chain({
                drag: '.two',
                fromOffset: ['0%-20', '100%+10'],
                by: [50, -50],
                dragOnly: true
              }, function (next) {
                t.is(scheduler.selectedEvents.length, 1);
                t.is(scheduler.selectedEvents[0].id, 2);
                next();
              }, {
                moveCursorTo: '.one'
              }, function (next) {
                t.is(scheduler.selectedEvents.length, 2);
                next();
              }, {
                moveCursorTo: '.two'
              }, function (next) {
                t.is(scheduler.selectedEvents.length, 1);
                t.is(scheduler.selectedEvents[0].id, 2);
                next();
              }, {
                mouseUp: null
              }, function (next) {
                t.is(scheduler.selectedEvents.length, 1);
                t.is(scheduler.selectedEvents[0].id, 2);
              });

            case 5:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x2) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Should deselect selected events during drag', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getScheduler({
                events: [{
                  id: 1,
                  cls: 'one',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }, {
                  id: 2,
                  cls: 'two',
                  resourceId: 'r3',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 7)
                }]
              });

            case 2:
              scheduler = _context2.sent;
              t.willFireNTimes(scheduler, 'eventselectionchange', 6);
              t.chain({
                drag: '.two',
                fromOffset: ['0%-20', '100%+10'],
                by: [50, -50],
                dragOnly: true
              }, function (next) {
                t.is(scheduler.selectedEvents.length, 1);
                t.is(scheduler.selectedEvents[0].id, 2);
                next();
              }, {
                moveCursorBy: [-50, 50]
              }, function (next) {
                t.is(scheduler.selectedEvents.length, 0);
                next();
              }, {
                mouseUp: null
              }, // Move the scheduler down and scroll the page:
              function (next) {
                scheduler.element.style['margin-top'] = '200px';
                DomHelper.up(scheduler.element, 'html').scrollTop = 150;
                next();
              }, // drag right to get both events and up well above the grid to test clipping of drag rect:
              {
                drag: '.two',
                fromOffset: ['0%-20', '100%+10'],
                by: [50, -175],
                dragOnly: true
              }, function (next) {
                var events = scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }).sort();
                t.expect(events).toEqual([1, 2]);
                var dragRect = scheduler.features.eventDragSelect.element.getBoundingClientRect();
                var gridRect = scheduler.timeAxisSubGrid.element.getBoundingClientRect(); // tops should match... give or take fractional pixels

                t.isApprox(dragRect.top, gridRect.top, 1, 'Drag can reach top of grid');
                next();
              }, {
                moveCursorBy: [-50, 50]
              }, function (next) {
                t.is(scheduler.selectedEvents.length, 0);
                next();
              }, {
                mouseUp: null
              });

            case 5:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Should support disabling', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getScheduler({
                events: []
              });

            case 2:
              scheduler = _context3.sent;
              scheduler.features.eventDragSelect.disabled = true;
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                by: [50, 50],
                dragOnly: true
              }, function (next) {
                t.selectorNotExists('.b-dragselect-rect', 'Not selecting');
                scheduler.features.eventDragSelect.disabled = false;
                next();
              }, {
                mouseUp: null
              }, {
                drag: '.b-sch-timeaxis-cell',
                by: [50, 50],
                dragOnly: true
              }, function (next) {
                t.selectorExists('.b-dragselect-rect', 'Selecting');
                next();
              }, {
                mouseUp: null
              });

            case 5:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x4) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should not trigger selection when dragging outside schedule area', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return getScheduler({});

            case 2:
              scheduler = _context4.sent;
              t.wontFire(scheduler, 'eventselectionchange');
              t.chain({
                drag: '.b-grid-cell:contains(Mike)',
                by: [200, 100],
                dragOnly: true
              }, function () {
                return t.selectorNotExists('.b-dragselecting');
              });

            case 5:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x5) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should focus last selected event on mouse up', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context5.sent;
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                by: [200, 100],
                offset: [1, 1]
              }, function () {
                return t.selectorExists('.b-sch-event-wrap.b-active:contains(Assignment 2)');
              });

            case 4:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x6) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should be possible to click-select an event after a drag select with mouse up outside schedule element', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return getScheduler({});

            case 2:
              scheduler = _context6.sent;
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                to: [1, 1],
                offset: [1, 1]
              }, {
                click: '.b-sch-event:contains(Assignment 1)'
              }, function () {
                return t.is(scheduler.selectedEvents.length, 1, '1 event selected');
              });

            case 4:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x7) {
      return _ref6.apply(this, arguments);
    };
  }());
});