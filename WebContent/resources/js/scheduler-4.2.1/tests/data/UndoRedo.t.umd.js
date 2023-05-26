function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    var _scheduler;

    (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
    scheduler = null;
  });
  t.it('Should react to CTRL-Z when configured with enableUndoRedoKeys', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var stm;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                enableUndoRedoKeys: true,
                startDate: new Date(2021, 2, 22),
                resources: [{
                  id: 1,
                  name: 'Resource'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  name: 'foo',
                  startDate: new Date(2021, 2, 22),
                  duration: 1
                }],
                project: {
                  stm: {
                    autoRecord: true
                  }
                },
                tbar: [{
                  type: 'undoredo',
                  icon: 'b-fa-undo'
                }]
              });
              _context.next = 3;
              return scheduler.project.commitAsync();

            case 3:
              stm = scheduler.project.stm;
              stm.enable();
              _context.next = 7;
              return t.dragBy('.b-sch-event', [100, 0]);

            case 7:
              _context.next = 9;
              return t.waitFor(function () {
                return stm.canUndo;
              });

            case 9:
              t.ok(stm.canUndo, 'Undo possible'); // UNDO

              _context.next = 12;
              return t.type(null, 'Z', null, null, {
                ctrlKey: !BrowserHelper.isMac,
                metaKey: BrowserHelper.isMac
              });

            case 12:
              _context.next = 14;
              return t.waitFor(function () {
                return stm.canRedo;
              });

            case 14:
              t.notOk(stm.canUndo, 'Undo queue empty');
              t.is(scheduler.eventStore.changes, null, 'Undid changes'); // REDO

              _context.next = 18;
              return t.type(null, 'Z', null, null, {
                shiftKey: true,
                ctrlKey: !BrowserHelper.isMac,
                metaKey: BrowserHelper.isMac
              });

            case 18:
              _context.next = 20;
              return t.waitFor(function () {
                return stm.canUndo;
              });

            case 20:
              t.notOk(stm.canRedo, 'Redo queue empty');
              t.ok(stm.canUndo, 'Undo queue populated');
              t.ok(scheduler.eventStore.changes, 'Changes redone');

            case 23:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2880

  t.it('Should not duplicate event when undoing after deleting it', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var stm;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2021, 2, 22),
                resources: [{
                  id: 1,
                  name: 'Resource'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  name: 'foo',
                  startDate: new Date(2021, 2, 22),
                  duration: 1
                }],
                project: {
                  stm: {
                    autoRecord: true
                  }
                }
              });
              _context2.next = 3;
              return scheduler.project.commitAsync();

            case 3:
              stm = scheduler.project.stm;
              stm.enable();
              scheduler.eventStore.first.remove();
              t.waitForSelectorNotFound(scheduler.unreleasedEventSelector);
              stm.undo();
              _context2.next = 10;
              return stm.await('restoringStop');

            case 10:
              _context2.next = 12;
              return scheduler.project.commitAsync();

            case 12:
              t.waitForSelector(scheduler.unreleasedEventSelector);
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Just one event rendered');

            case 14:
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
});