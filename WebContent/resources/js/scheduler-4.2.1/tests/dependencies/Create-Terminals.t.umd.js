function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var labelsConfig = {
    // using field as label (will first look in event and then in resource)
    top: {
      field: 'fullDuration',
      editor: {
        type: 'durationfield',
        width: 110
      },
      renderer: function renderer(_ref) {
        var eventRecord = _ref.eventRecord;
        return 'At the very least, ' + eventRecord.duration + ' ' + DateHelper.getLocalizedNameOfUnit(eventRecord.durationUnit, eventRecord.duration !== 1);
      }
    },
    // using renderer
    bottom: {
      field: 'fullDuration',
      editor: {
        type: 'durationfield',
        width: 110
      },
      renderer: function renderer(_ref2) {
        var eventRecord = _ref2.eventRecord;
        return eventRecord.duration + ' ' + DateHelper.getLocalizedNameOfUnit(eventRecord.durationUnit, eventRecord.duration !== 1);
      }
    }
  };
  var scheduler;

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(config) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              scheduler && scheduler.destroy();
              scheduler = t.getScheduler(Object.assign({
                dependencyStore: new DependencyStore(),
                resourceStore: t.getResourceStore2({}, 10)
              }, config), 10);
              _context5.next = 4;
              return t.waitForProjectReady(scheduler);

            case 4:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('Terminals should not be found from start', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler();

            case 2:
              t.selectorNotExists('.b-sch-terminal-top', 'Top terminal is hidden');
              t.selectorNotExists('.b-sch-terminal-right', 'Right terminal is hidden');
              t.selectorNotExists('.b-sch-terminal-bottom', 'Bottom terminal is hidden');
              t.selectorNotExists('.b-sch-terminal-left', 'Left terminal is hidden');

            case 6:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x2) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Terminals should be visible on hover, and hide on mouseleave', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getScheduler();

            case 2:
              t.chain({
                setCursorPosition: [1, 1]
              }, {
                moveCursorTo: '.b-sch-event:contains(Assignment 1)'
              }, function (next) {
                t.elementIsVisible('.b-sch-event-hover .b-sch-terminal-top', 'Top terminal is visible');
                t.elementIsVisible('.b-sch-event-hover .b-sch-terminal-right', 'Right terminal is visible');
                t.elementIsVisible('.b-sch-event-hover .b-sch-terminal-bottom', 'Bottom terminal is visible');
                t.elementIsVisible('.b-sch-event-hover .b-sch-terminal-left', 'Left terminal is visible');
                next();
              }, {
                moveCursorTo: '.b-sch-event:contains(Assignment 1)',
                offset: ['110%', '50%']
              }, function (next) {
                t.selectorNotExists('.b-sch-event-hover .b-sch-terminal-top', 'Top terminal is hidden');
                t.selectorNotExists('.b-sch-event-hover .b-sch-terminal-right', 'Right terminal is hidden');
                t.selectorNotExists('.b-sch-event-hover .b-sch-terminal-bottom', 'Bottom terminal is hidden');
                t.selectorNotExists('.b-sch-event-hover .b-sch-terminal-left', 'Left terminal is hidden');
                next();
              });

            case 3:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Only specified terminals should be visible on hover', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getScheduler({
                features: {
                  dependencies: {
                    terminalSides: ['left', 'right']
                  }
                }
              });

            case 2:
              t.chain({
                setCursorPosition: [1, 1]
              }, {
                moveCursorTo: '.b-sch-event:contains(Assignment 1)'
              }, function (next) {
                t.selectorNotExists('.b-sch-event-hover .b-sch-terminal-top', 'Top terminal not rendered');
                t.elementIsVisible('.b-sch-event-hover .b-sch-terminal-right', 'Right terminal is visible');
                t.selectorNotExists('.b-sch-event-hover .b-sch-terminal-bottom', 'Bottom terminal not rendered');
                t.elementIsVisible('.b-sch-event-hover .b-sch-terminal-left', 'Left terminal is visible');
                next();
              });

            case 3:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x4) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Terminals should be visible on hover, and hide on mouseleave with labels', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var eventEl, wrap;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return getScheduler({
                rowHeight: 85,
                features: {
                  labels: labelsConfig,
                  eventTooltip: false
                }
              });

            case 2:
              eventEl = scheduler.getElementFromEventRecord(scheduler.eventStore.first), wrap = eventEl.parentNode;
              t.chain({
                setCursorPosition: [1, 1]
              }, {
                moveCursorTo: eventEl
              }, function (next) {
                t.elementIsVisible('.b-sch-event-hover .b-sch-terminal-top', 'Top terminal is visible');
                t.elementIsVisible('.b-sch-event-hover .b-sch-terminal-right', 'Right terminal is visible');
                t.elementIsVisible('.b-sch-event-hover .b-sch-terminal-bottom', 'Bottom terminal is visible');
                t.elementIsVisible('.b-sch-event-hover .b-sch-terminal-left', 'Left terminal is visible');
                next();
              }, // Mouseout into a label, voiding the terminal.
              // Should trigger an eventMouseLeave which hides the terminals
              {
                moveCursorTo: wrap.querySelector('.' + scheduler.features.labels.labelCls),
                offset: ['90%', '50%']
              }, function () {
                t.selectorNotExists('.b-sch-event-hover .b-sch-terminal-top', 'Top terminal is hidden');
                t.selectorNotExists('.b-sch-event-hover .b-sch-terminal-right', 'Right terminal is hidden');
                t.selectorNotExists('.b-sch-event-hover .b-sch-terminal-bottom', 'Bottom terminal is hidden');
                t.selectorNotExists('.b-sch-event-hover .b-sch-terminal-left', 'Left terminal is hidden');
              });

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x5) {
      return _ref6.apply(this, arguments);
    };
  }());
});