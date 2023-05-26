function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
    scheduler = null;
  });
  t.it('Should show editor on event dblclick', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: false,
                  simpleEventEdit: true
                },
                events: [{
                  resourceId: 'r1'
                }]
              });

            case 2:
              scheduler = _context.sent;
              scheduler.eventStore.first.startDate = scheduler.startDate;
              scheduler.eventStore.first.duration = 1;
              t.firesOnce(scheduler.features.simpleEventEdit, 'beforestart');
              t.firesOnce(scheduler.features.simpleEventEdit, 'start');
              t.firesOnce(scheduler.features.simpleEventEdit, 'beforecomplete');
              t.firesOnce(scheduler.features.simpleEventEdit, 'complete');
              t.chain({
                dblclick: '.b-sch-event'
              }, // This is a test for a bug which was masked by turbo mode.
              // Focus would bounce out of the editor due to the Navigator mistaking
              // focusing the editor for a TAB out.  Give it a chance to exhibit bad behaviour.
              // Focus should remain in the editor.
              {
                waitFor: 500
              }, {
                waitFor: function waitFor() {
                  var _scheduler$features$s;

                  return (_scheduler$features$s = scheduler.features.simpleEventEdit.editor) === null || _scheduler$features$s === void 0 ? void 0 : _scheduler$features$s.containsFocus;
                }
              }, {
                type: 'Foo[ENTER]'
              }, function () {
                t.is(scheduler.eventStore.first.name, 'Foo', 'Name set');
              });

            case 10:
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
  t.it('Should start edit on Enter', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: false,
                  simpleEventEdit: true
                },
                events: [{
                  resourceId: 'r1'
                }]
              });

            case 2:
              scheduler = _context2.sent;
              scheduler.eventStore.first.startDate = scheduler.startDate;
              scheduler.eventStore.first.duration = 1;
              t.willFireNTimes(scheduler.features.simpleEventEdit, 'beforestart', 2);
              t.willFireNTimes(scheduler.features.simpleEventEdit, 'start', 2);
              t.willFireNTimes(scheduler.features.simpleEventEdit, 'beforecomplete', 2);
              t.willFireNTimes(scheduler.features.simpleEventEdit, 'complete', 2);
              t.chain({
                click: '.b-sch-event'
              }, {
                type: '[ENTER]'
              }, // This is a test for a bug which was masked by turbo mode.
              // Focus would bounce out of the editor due to the Navigator mistaking
              // focusing the editor for a TAB out.  Give it a chance to exhibit bad behaviour.
              // Focus should remain in the editor.
              {
                waitFor: 500
              }, {
                waitForSelector: '.b-editor input:focus'
              }, {
                type: 'foo[ENTER]'
              }, function (next) {
                t.selectorNotExists('.b-sch-dragcreator-proxy');
                t.is(scheduler.eventStore.first.name, 'foo', 'Name set');
                next();
              }, {
                type: '[ENTER]'
              }, {
                waitForSelector: '.b-editor input:focus'
              }, {
                type: 'bar[ENTER]'
              }, function () {
                t.selectorNotExists('.b-sch-dragcreator-proxy');
                t.is(scheduler.eventStore.first.name, 'foobar', 'Name updated');
              });

            case 10:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Should edit name on dblclick', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: false,
                  simpleEventEdit: true
                },
                events: []
              });

            case 2:
              scheduler = _context3.sent;
              t.firesOnce(scheduler.features.simpleEventEdit, 'beforestart');
              t.firesOnce(scheduler.features.simpleEventEdit, 'start');
              t.firesOnce(scheduler.features.simpleEventEdit, 'beforecomplete');
              t.firesOnce(scheduler.features.simpleEventEdit, 'complete');
              t.chain({
                dblclick: '.b-sch-timeaxis-cell'
              }, // This is a test for a bug which was masked by turbo mode.
              // Focus would bounce out of the editor due to the Navigator mistaking
              // focusing the editor for a TAB out.  Give it a chance to exhibit bad behaviour.
              // Focus should remain in the editor.
              {
                waitFor: 500
              }, {
                type: 'Foo[ENTER]'
              }, function () {
                t.selectorNotExists('.b-sch-dragcreator-proxy');
                t.is(scheduler.eventStore.count, 1);
                t.is(scheduler.eventStore.first.name, 'Foo');
              });

            case 8:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should not edit name on dblclick if readOnly', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                readOnly: true,
                features: {
                  eventEdit: false,
                  simpleEventEdit: true
                },
                events: []
              });

            case 2:
              scheduler = _context4.sent;
              t.chain({
                dblclick: '.b-sch-timeaxis-cell'
              }, // Nothing should happen so we cannot wait for an event
              {
                waitFor: 300
              }, function () {
                t.selectorNotExists('.b-editor', 'Editor correctly not started');
              });

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should edit name on drag create', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: false,
                  simpleEventEdit: true
                },
                events: []
              });

            case 2:
              scheduler = _context5.sent;
              t.firesOnce(scheduler.features.simpleEventEdit, 'beforestart');
              t.firesOnce(scheduler.features.simpleEventEdit, 'start');
              t.firesOnce(scheduler.features.simpleEventEdit, 'beforecomplete');
              t.firesOnce(scheduler.features.simpleEventEdit, 'complete');
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                by: [100, 0]
              }, {
                waitForSelector: '.b-editor input:focus'
              }, {
                type: 'bar[ENTER]'
              }, function () {
                t.selectorNotExists('.b-sch-dragcreator-proxy');
                t.is(scheduler.eventStore.count, 1);
                t.is(scheduler.eventStore.first.name, 'bar');
              });

            case 8:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x5) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should cancel on Escape', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: false,
                  simpleEventEdit: true
                },
                events: []
              });

            case 2:
              scheduler = _context6.sent;
              t.firesOnce(scheduler.features.simpleEventEdit, 'beforestart');
              t.firesOnce(scheduler.features.simpleEventEdit, 'start');
              t.firesOnce(scheduler.features.simpleEventEdit, 'beforecancel');
              t.firesOnce(scheduler.features.simpleEventEdit, 'cancel');
              t.chain({
                dblclick: '.b-sch-timeaxis-cell'
              }, {
                type: 'Foo[ESCAPE]'
              }, function () {
                t.selectorNotExists('.b-sch-dragcreator-proxy');
              });

            case 8:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Should support disabling', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: false,
                  simpleEventEdit: true
                }
              });

            case 2:
              scheduler = _context7.sent;
              scheduler.features.simpleEventEdit.disabled = true;
              t.chain({
                dblClick: '.b-sch-event'
              }, function (next) {
                t.selectorNotExists('input', 'Not editing');
                scheduler.features.simpleEventEdit.disabled = false;
                next();
              }, {
                dblClick: '.b-sch-event'
              }, // https://github.com/bryntum/support/issues/292
              {
                type: '[RIGHT]',
                target: 'input:focus'
              }, function () {
                t.selectorExists('input', 'Editing');
              });

            case 5:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x7) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Event should be removed upon cancel', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'hourAndDay',
                features: {
                  eventEdit: false,
                  simpleEventEdit: true
                },
                events: []
              });

            case 2:
              scheduler = _context8.sent;
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                offset: [100, '50%'],
                by: [60, 0]
              }, {
                waitForSelector: '.b-editor input:focus',
                desc: 'Editor is visible'
              }, {
                type: '[ESCAPE]'
              }, {
                waitForSelectorNotFound: '.b-sch-event-wrap:not(.b-released)'
              }, function () {
                t.notOk(scheduler.eventStore.count, 'Event not finally added');
              });

            case 4:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x8) {
      return _ref8.apply(this, arguments);
    };
  }());
});