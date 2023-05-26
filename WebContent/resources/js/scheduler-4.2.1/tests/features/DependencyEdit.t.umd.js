function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
    scheduler = null;
  });

  function setup(_x) {
    return _setup.apply(this, arguments);
  }

  function _setup() {
    _setup = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var config,
          _args8 = arguments;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              config = _args8.length > 1 && _args8[1] !== undefined ? _args8[1] : {};
              scheduler && scheduler.destroy();
              scheduler = t.getScheduler(Object.assign({
                startDate: new Date(2018, 8, 20),
                endDate: new Date(2018, 9, 30),
                viewPreset: 'weekAndMonth',
                resources: [{
                  id: 1
                }, {
                  id: 2
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2018, 9, 20),
                  duration: 2,
                  name: 'task 1'
                }, {
                  id: 2,
                  resourceId: 1,
                  startDate: new Date(2018, 9, 24),
                  duration: 2,
                  name: 'task 2'
                }],
                dependencies: [{
                  id: 1,
                  from: 1,
                  to: 2,
                  type: 2
                }],
                features: {
                  dependencies: {
                    showTooltip: false
                  },
                  eventTooltip: false,
                  dependencyEdit: true
                }
              }, config));
              _context8.next = 5;
              return t.waitForDependencies();

            case 5:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));
    return _setup.apply(this, arguments);
  }

  t.it('Should show editor on dblclick on dependency', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return setup(t);

            case 2:
              t.firesOnce(scheduler, 'beforeDependencyEdit');
              t.chain({
                dblclick: '.b-sch-dependency'
              }, {
                waitForSelector: '.b-popup .b-header-title:contains(Edit dependency)',
                desc: 'Popup shown with correct title'
              }, function () {
                var depFeature = scheduler.features.dependencyEdit;
                t.hasValue(depFeature.fromNameField, 'task 1');
                t.hasValue(depFeature.toNameField, 'task 2');
                t.hasValue(depFeature.typeField, 2);
                t.is(depFeature.typeField.inputValue, 'End to Start');
                t.selectorNotExists('label:contains(Lag)', 'Lag field should not exist by default');
              });

            case 4:
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
  t.it('Should delete dependency on Delete click', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return setup(t);

            case 2:
              t.firesOnce(scheduler.dependencyStore, 'remove');
              t.firesOnce(scheduler, 'beforeDependencyDelete');
              t.firesOnce(scheduler, 'beforeDependencyEdit');
              t.chain({
                dblclick: '.b-sch-dependency'
              }, {
                click: '.b-popup button:textEquals(Delete)'
              }, {
                waitForSelectorNotFound: '.b-sch-dependency'
              });

            case 6:
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
  t.it('Should change nothing on Cancel and close popup', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return setup(t);

            case 2:
              t.wontFire(scheduler.dependencyStore, 'change');
              t.firesOnce(scheduler, 'beforeDependencyEdit');
              t.chain({
                dblclick: '.b-sch-dependency'
              }, {
                click: '.b-popup button:textEquals(Cancel)'
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
  t.it('Should repaint and update model when changing type', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return setup(t);

            case 2:
              // TODO: Revisit when engine integration is complete
              //        t.firesOnce(scheduler.dependencyStore, 'update');
              t.firesOnce(scheduler, 'beforeDependencyEdit');
              t.firesOnce(scheduler, 'beforeDependencyEditShow');
              t.firesOnce(scheduler, 'afterDependencySave');
              t.chain({
                dblclick: '.b-sch-dependency'
              }, function (next) {
                var depFeature = scheduler.features.dependencyEdit;
                depFeature.typeField.value = 0;
                next();
              }, {
                click: '.b-popup button:textEquals(Save)'
              }, function () {
                t.is(scheduler.dependencyStore.first.type, 0, 'Type updated');
              });

            case 6:
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
  t.it('Should not show if scheduler is readOnly', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return setup(t, {
                readOnly: true
              });

            case 2:
              t.wontFire(scheduler, 'beforeDependencyEdit');
              t.chain({
                dblclick: '.b-sch-dependency'
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
  t.it('Should be possible to show editor programmatically', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return setup(t, {
                height: 300
              });

            case 2:
              scheduler.features.dependencyEdit.editDependency(scheduler.dependencyStore.first);
              t.chain({
                waitForSelector: '.b-dependencyeditor'
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
  t.it('Should support disabling', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return setup(t);

            case 2:
              scheduler.features.dependencyEdit.disabled = true;
              t.firesOk(scheduler, {
                beforeDependencyEdit: 1
              });
              t.chain({
                dblclick: '.b-sch-dependency'
              }, function (next) {
                t.selectorNotExists('.b-popup.b-dependencyeditor');
                scheduler.features.dependencyEdit.disabled = false;
                next();
              }, {
                dblclick: '.b-sch-dependency'
              }, function () {
                t.selectorExists('.b-popup.b-dependencyeditor');
              });

            case 5:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x8) {
      return _ref7.apply(this, arguments);
    };
  }());
});