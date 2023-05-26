function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var undoRedoWidget;
  t.beforeEach(function (t) {
    var _undoRedoWidget;

    (_undoRedoWidget = undoRedoWidget) === null || _undoRedoWidget === void 0 ? void 0 : _undoRedoWidget.destroy();
  });
  t.it('Should have disabled buttons when no changes have been made', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var project;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              project = new ProjectModel({
                stm: {
                  autoRecord: true
                }
              });
              project.stm.enable();
              undoRedoWidget = new UndoRedo({
                project: project,
                appendTo: document.body
              });
              t.is(undoRedoWidget.widgetMap.undoBtn.disabled, true, 'Undo initially disabled');
              t.is(undoRedoWidget.widgetMap.redoBtn.disabled, true, 'Undo initially disabled');
              project.eventStore.add({
                name: 'foo'
              });
              _context.next = 8;
              return t.waitFor(function () {
                return !undoRedoWidget.widgetMap.undoBtn.disabled;
              });

            case 8:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2953

  t.it('Should have enabled buttons when undo widget is created when changes have already been made', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var project;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              project = new ProjectModel({
                stm: {
                  autoRecord: true
                }
              });
              project.stm.enable();
              project.eventStore.add({
                name: 'foo'
              });
              _context2.next = 5;
              return t.waitFor(function () {
                return project.stm.isReady;
              });

            case 5:
              undoRedoWidget = new UndoRedo({
                project: project,
                appendTo: document.body
              });
              t.is(undoRedoWidget.widgetMap.undoBtn.disabled, false, 'Undo initially enabled');
              t.is(undoRedoWidget.widgetMap.redoBtn.disabled, true, 'Undo initially disabled');

            case 8:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2834

  t.it('Should use icons defined with b-icon', function (t) {
    var project = new ProjectModel({
      stm: {
        autoRecord: true
      }
    });
    project.stm.enable();
    new UndoRedo({
      appendTo: document.body,
      project: project,
      items: {
        transactionsCombo: null
      }
    });
    t.chain({
      waitForElementVisible: '.b-icon-undo',
      desc: 'b-icon applied for the button undo'
    }, {
      waitForElementVisible: '.b-icon-redo',
      desc: 'b-icon applied for the button redo'
    }, function () {
      t.elementIsVisible('.b-icon-undo', 'Icon undo is visible');
      t.elementIsVisible('.b-icon-redo', 'Icon redo is visible');
    });
  });
});