function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  var DependencyModelType = DependencyModel.Type;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler({
      features: {
        dependencies: {
          allowDropOnEventBar: false,
          // the legacy behavior
          showTooltip: false
        },
        eventTooltip: false,
        scheduleTooltip: false
      },
      dependencyStore: new DependencyStore(),
      resourceStore: t.getResourceStore2({}, 10)
    }, 10);
  });
  t.it('Should create an End-To-Start dependency in the store after successful drop', function (t) {
    t.firesOk(scheduler, {
      beforedependencycreatedrag: 1,
      dependencycreatedragstart: 1,
      dependencycreatedrop: 1
    });
    t.chain({
      moveCursorTo: '[data-event-id="1"]'
    }, {
      mousedown: '[data-event-id="1"] .b-sch-terminal-right'
    }, {
      moveCursorTo: '[data-event-id="2"]'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:textEquals(To:)'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.is(scheduler.features.dependencies.creationTooltip.constrainTo, null, 'Tooltip not constrained');

            case 1:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    })), {
      moveCursorTo: '[data-event-id="2"] .b-sch-terminal-left'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:textEquals(To: Assignment 2)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:first-child .b-sch-box.b-right'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:last-child .b-sch-box.b-left'
    }, {
      mouseup: '[data-event-id="2"] .b-sch-terminal-left'
    }, {
      waitForDependencies: null
    }, function () {
      var dep = scheduler.dependencyStore.first;
      t.expect(dep.fromEvent.name).toBe('Assignment 1');
      t.expect(dep.toEvent.name).toBe('Assignment 2');
      t.expect(dep.type).toBe(DependencyModelType.EndToStart);
      t.expect(dep.fromSide).toBe('right');
      t.expect(dep.toSide).toBe('left');
    });
  });
  t.it('Should create an End-to-End dependency in the store after successful drop', function (t) {
    t.firesOk(scheduler, {
      beforedependencycreatedrag: 1,
      dependencycreatedragstart: 1,
      dependencycreatedrop: 1
    });
    t.chain({
      moveCursorTo: '[data-event-id="1"]'
    }, {
      mousedown: '[data-event-id="1"] .b-sch-terminal-right'
    }, {
      moveCursorTo: '[data-event-id="2"]'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:textEquals(To:)'
    }, function (next) {
      t.is(scheduler.features.dependencies.creationTooltip.constrainTo, null, 'Tooltip not constrained');
      next();
    }, {
      moveCursorTo: '[data-event-id="2"] .b-sch-terminal-right'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:textEquals(To: Assignment 2)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:first-child .b-sch-box.b-right'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:last-child .b-sch-box.b-right'
    }, {
      mouseup: '[data-event-id="2"] .b-sch-terminal-right'
    }, {
      waitForDependencies: null
    }, function () {
      var dep = scheduler.dependencyStore.first;
      t.expect(dep.fromEvent.name).toBe('Assignment 1');
      t.expect(dep.toEvent.name).toBe('Assignment 2');
      t.expect(dep.type).toBe(3);
      t.expect(dep.fromSide).toBe('right');
      t.expect(dep.toSide).toBe('right');
    });
  });
  t.it('Should not create a dependency if view returns false on beforedrag', function (t) {
    t.firesOk(scheduler, {
      beforedependencycreatedrag: 1,
      dependencycreatedragstart: 0,
      dependencycreatedrop: 0
    });
    scheduler.on('beforedependencycreatedrag', function () {
      return false;
    });
    t.chain({
      moveCursorTo: '.b-sch-event:contains(Assignment 1)'
    }, {
      mousedown: '.b-sch-event:contains(Assignment 1) .b-sch-terminal-right'
    }, {
      moveCursorTo: '.b-sch-event:contains(Assignment 2)'
    }, {
      moveCursorTo: '.b-sch-event:contains(Assignment 2) .b-sch-terminal-left'
    }, {
      mouseup: null
    });
  });
  t.it('Terminals should be hidden in read only mode', function (t) {
    scheduler.readOnly = true;
    t.chain({
      moveCursorTo: '.b-sch-event'
    }, function () {
      t.selectorNotExists('.b-sch-event .b-sch-terminal', 'No terminals');
    });
  });
  t.it('Should not start dependency creation when right clicking on a terminal', function (t) {
    t.firesOk(scheduler, {
      beforedependencycreatedrag: 0,
      dependencycreatedragstart: 0,
      dependencycreatedrop: 0
    });
    t.chain({
      setCursorPosition: [1, 1]
    }, {
      moveCursorTo: '[data-event-id="1"]'
    }, {
      mousedown: '[data-event-id="1"] .b-sch-terminal-right',
      options: {
        button: 2
      }
    }, {
      moveCursorTo: '[data-event-id="2"]'
    }, {
      moveCursorTo: '[data-event-id="2"] .b-sch-terminal-left'
    }, {
      mouseup: '[data-event-id="2"] .b-sch-terminal-left'
    }, function () {
      t.notOk(scheduler.dependencyStore.first, 'no dependencies made');
    });
  });
  t.it('Should not raise an exception when left-clicked start terminal and right-clicked end terminal', function (t) {
    t.firesOk(scheduler, {
      beforedependencycreatedrag: 1,
      dependencycreatedragstart: 1,
      dependencycreatedrop: 1
    });
    t.chain({
      moveCursorTo: '[data-event-id="1"]'
    }, {
      mousedown: '[data-event-id="1"] .b-sch-terminal-right'
    }, {
      moveCursorTo: '[data-event-id="2"]'
    }, {
      moveCursorTo: '[data-event-id="2"] .b-sch-terminal-left'
    }, {
      mousedown: '[data-event-id="2"] .b-sch-terminal-left',
      options: {
        button: 2
      },
      desc: 'rightclicked on end terminal'
    }, {
      mouseup: '[data-event-id="2"] .b-sch-terminal-left'
    }, function () {
      var dep = scheduler.dependencyStore.first;
      t.expect(dep.fromEvent.name).toBe('Assignment 1');
      t.expect(dep.toEvent.name).toBe('Assignment 2');
      t.expect(dep.type).toBe(DependencyModelType.EndToStart);
      t.expect(dep.fromSide).toBe('right');
      t.expect(dep.toSide).toBe('left');
    });
  });
  t.it('View should be scrolled when dependency is dragged to the edge', function (t) {
    scheduler.width = scheduler.height = 400;
    var lineLength;
    var verticalScroller = scheduler.scrollable.element,
        horizontalScroller = scheduler.subGrids.normal.scrollable.element,
        // caching scrollWidth for edge
    horizontalScrollWidth = horizontalScroller.scrollWidth;
    t.chain({
      moveCursorTo: '.b-scheduler'
    }, // For IE, terminals gets lost somehow when resizing and mouse already over event
    {
      moveCursorTo: '[data-event-id="1"]'
    }, {
      mousedown: '[data-event-id="1"] .b-sch-terminal-bottom'
    }, {
      moveMouseTo: '.b-grid-body-container',
      offset: ['50%', '100%-10']
    }, {
      waitFor: function waitFor() {
        return verticalScroller.scrollTop + verticalScroller.clientHeight === verticalScroller.scrollHeight;
      }
    }, {
      moveMouseTo: '.b-grid-body-container',
      offset: ['100%-100', '50%']
    }, function (next) {
      lineLength = document.querySelector('.b-sch-dependency-connector').clientWidth;
      next();
    }, {
      moveMouseTo: '.b-grid-body-container',
      offset: ['100%-30', '50%']
    }, {
      waitFor: function waitFor() {
        return horizontalScroller.scrollLeft + horizontalScroller.clientWidth === horizontalScrollWidth;
      }
    }, function (next) {
      t.isGreater(document.querySelector('.b-sch-dependency-connector').clientWidth, lineLength * 2, 'Line width updated during scrolling');
      next();
    }, {
      moveMouseBy: [[-50, 0]]
    }, {
      moveMouseTo: '.event6',
      offset: ['100%-10', '50%']
    }, {
      moveMouseTo: '.event6 .b-sch-terminal-right'
    }, {
      mouseUp: '.event6 .b-sch-terminal-right'
    }, function () {
      var dep = scheduler.dependencyStore.first;
      t.expect(dep.fromEvent.name).toBe('Assignment 1');
      t.expect(dep.toEvent.name).toBe('Assignment 6');
      t.expect(dep.fromSide).toBe('bottom');
      t.expect(dep.toSide).toBe('right');
    });
  }); // https://github.com/bryntum/support/issues/2323

  t.it('Should not generate error when hovering in/out of terminals', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.moveCursorTo('.b-sch-event:textEquals(Assignment 1)');

            case 2:
              _context2.next = 4;
              return t.dragTo('.b-sch-event:textEquals(Assignment 1) [data-side="right"]', '.b-sch-event:textEquals(Assignment 2)', null, null, null, true);

            case 4:
              _context2.next = 6;
              return t.moveCursorTo('.b-sch-event:textEquals(Assignment 2) [data-side="right"]');

            case 6:
              _context2.next = 8;
              return t.moveCursorTo('.b-sch-event:textEquals(Assignment 1)');

            case 8:
              _context2.next = 10;
              return t.moveCursorTo('.b-sch-event:textEquals(Assignment 1) [data-side="right"]');

            case 10:
              _context2.next = 12;
              return t.moveCursorBy([50, 0]);

            case 12:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Should include correct event params', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              scheduler.on({
                beforedependencycreatedrag: function beforedependencycreatedrag(_ref4) {
                  var data = _ref4.data,
                      source = _ref4.source;
                  t.diag('beforedependencycreatedrag');
                  t.is(source.name, 'Assignment 1', 'source param');
                  t.is(data.source, source, 'Backwards compat');
                },
                dependencycreatedragstart: function dependencycreatedragstart(_ref5) {
                  var data = _ref5.data,
                      source = _ref5.source;
                  t.diag('dependencycreatedragstart');
                  t.is(source.name, 'Assignment 1', 'source param');
                  t.ok(data, 'Backwards compat');
                },
                dependencyValidationStart: function dependencyValidationStart(_ref6) {
                  var data = _ref6.data,
                      source = _ref6.source,
                      target = _ref6.target,
                      dependencyType = _ref6.dependencyType;
                  t.diag('dependencyValidationStart');
                  t.is(source.name, 'Assignment 1', 'source param');
                  t.is(target.name, 'Assignment 2', 'target param');
                  t.is(dependencyType, DependencyModelType.EndToStart, 'dependencyType param');
                  t.ok(data, 'Backwards compat');
                },
                dependencyValidationComplete: function dependencyValidationComplete(_ref7) {
                  var data = _ref7.data,
                      source = _ref7.source,
                      target = _ref7.target,
                      dependencyType = _ref7.dependencyType;
                  t.diag('dependencyValidationComplete');
                  t.is(source.name, 'Assignment 1', 'source param');
                  t.is(target.name, 'Assignment 2', 'target param');
                  t.is(dependencyType, DependencyModelType.EndToStart, 'dependencyType param');
                  t.ok(data, 'Backwards compat');
                },
                dependencycreatedrop: function dependencycreatedrop(_ref8) {
                  var data = _ref8.data,
                      source = _ref8.source,
                      target = _ref8.target,
                      dependency = _ref8.dependency;
                  t.diag('dependencycreatedrop');
                  t.is(source.name, 'Assignment 1', 'source param');
                  t.is(target.name, 'Assignment 2', 'target param');
                  t.isInstanceOf(dependency, DependencyModel, 'dependency param');
                  t.ok(data, 'Backwards compat');
                },
                afterDependencyCreateDrop: function afterDependencyCreateDrop(_ref9) {
                  var data = _ref9.data,
                      source = _ref9.source,
                      target = _ref9.target,
                      dependency = _ref9.dependency;
                  t.diag('afterDependencyCreateDrop');
                  t.is(source.name, 'Assignment 1', 'source param');
                  t.is(target.name, 'Assignment 2', 'target param');
                  t.isInstanceOf(dependency, DependencyModel, 'dependency param');
                  t.ok(data, 'Backwards compat');
                }
              });
              t.chain({
                moveCursorTo: '.b-sch-event:contains(Assignment 1)'
              }, {
                mousedown: '.b-sch-event:contains(Assignment 1) .b-sch-terminal-right'
              }, {
                moveCursorTo: '.b-sch-event:contains(Assignment 2)'
              }, {
                moveCursorTo: '.b-sch-event:contains(Assignment 2) .b-sch-terminal-left'
              }, {
                mouseup: null
              });

            case 2:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x2) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should create a dependency after drop on event element, not on terminal', function (t) {
    scheduler.features.dependencies.allowDropOnEventBar = true;
    t.chain({
      moveCursorTo: '[data-event-id="1"]'
    }, {
      mousedown: '[data-event-id="1"] .b-sch-terminal-right'
    }, {
      moveCursorTo: '[data-event-id="2"]'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(To: Assignment 2)'
    }, {
      mouseUp: null
    }, function () {
      var dep = scheduler.dependencyStore.first;
      t.expect(dep.fromEvent.name).toBe('Assignment 1');
      t.expect(dep.toEvent.name).toBe('Assignment 2');
      t.expect(dep.type).toBe(2);
      t.expect(dep.fromSide).toBe('right');
      t.expect(dep.toSide).toBe('left');
    });
  });
  t.it('Should create a dependency after drop on event element if allowDropOnEventBar is set, with modifed default type', function (t) {
    DependencyModel.fieldMap.type.defaultValue = DependencyModelType.EndToEnd;
    scheduler.features.dependencies.allowDropOnEventBar = true;
    t.chain({
      moveCursorTo: '[data-event-id="1"]'
    }, {
      mousedown: '[data-event-id="1"] .b-sch-terminal-right'
    }, {
      moveCursorTo: '[data-event-id="2"]'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(To: Assignment 2)'
    }, {
      waitForSelector: '.b-sch-terminal[data-side=right].b-valid'
    }, {
      mouseUp: null
    }, function () {
      var dep = scheduler.dependencyStore.first;
      t.expect(dep.fromEvent.name).toBe('Assignment 1');
      t.expect(dep.toEvent.name).toBe('Assignment 2');
      t.expect(dep.type).toBe(DependencyModelType.EndToEnd);
      t.expect(dep.fromSide).toBe('right');
      t.expect(dep.toSide).toBe('right');
      DependencyModel.fieldMap.type.defaultValue = DependencyModelType.EndToStart;
    });
  });
  t.it('Should support async finalization using beforeDependencyCreateFinalize event', function (t) {
    scheduler.on('beforeDependencyCreateFinalize', /*#__PURE__*/function () {
      var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(_ref10) {
        var source, target, fromSide, toSide, result;
        return regeneratorRuntime.wrap(function _callee4$(_context4) {
          while (1) {
            switch (_context4.prev = _context4.next) {
              case 0:
                source = _ref10.source, target = _ref10.target, fromSide = _ref10.fromSide, toSide = _ref10.toSide;
                t.is(source.id, 1, 'Correct from task');
                t.is(target.id, 2, 'Correct to task');
                t.is(fromSide, 'right', 'Correct fromSide');
                t.is(toSide, 'left', 'Correct toSide');
                _context4.next = 7;
                return MessageDialog.confirm({
                  title: 'Please confirm',
                  message: 'Did you want to create?'
                });

              case 7:
                result = _context4.sent;
                return _context4.abrupt("return", result === MessageDialog.yesButton);

              case 9:
              case "end":
                return _context4.stop();
            }
          }
        }, _callee4);
      }));

      return function (_x3) {
        return _ref11.apply(this, arguments);
      };
    }());
    scheduler.features.dependencies.allowDropOnEventBar = true;
    t.chain({
      moveCursorTo: '[data-event-id="1"]'
    }, {
      mousedown: '[data-event-id="1"] .b-sch-terminal-right'
    }, {
      moveCursorTo: '[data-event-id="2"]'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(To: Assignment 2)'
    }, {
      mouseUp: null
    }, {
      click: 'button:contains(OK)'
    }, function () {
      var dep = scheduler.dependencyStore.first;
      t.expect(dep.fromEvent.name).toBe('Assignment 1');
      t.expect(dep.toEvent.name).toBe('Assignment 2');
      t.expect(dep.type).toBe(DependencyModelType.EndToStart);
      t.expect(dep.fromSide).toBe('right');
      t.expect(dep.toSide).toBe('left');
    });
  });
  t.it('Should create no dependencies when not dropping on a task', function (t) {
    t.wontFire(scheduler.dependencyStore, 'add');
    t.chain({
      moveCursorTo: '[data-event-id="1"]'
    }, {
      mousedown: '[data-event-id="1"] .b-sch-terminal-right'
    }, {
      moveCursorTo: '[data-event-id="2"]'
    }, {
      moveCursorTo: '[data-event-id="2"] .b-sch-terminal-right'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(To: Assignment 2)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip .b-header-title:textEquals(Valid)'
    }, {
      waitForSelector: '.b-sch-dependency-connector.b-valid'
    }, // Move cursor away from any task bar
    {
      moveCursorBy: [100, 0]
    }, // Should not show any target task, + mark as invalid
    {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:textEquals(To:)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip .b-header-title:textEquals(Invalid)'
    }, {
      waitForSelector: '.b-sch-dependency-connector:not(.b-valid)'
    }, // Back to valid target task, + mark as valid
    {
      moveCursorTo: '[data-event-id="2"]'
    }, {
      moveCursorTo: '[data-event-id="2"] .b-sch-terminal-right'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(To: Assignment 2)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip .b-header-title:textEquals(Valid)'
    }, {
      waitForSelector: '.b-sch-dependency-connector.b-valid'
    }, // Should not show any target task, + mark as invalid
    {
      moveCursorBy: [100, 0]
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:textEquals(To:)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip .b-header-title:textEquals(Invalid)'
    }, {
      waitForSelector: '.b-sch-dependency-connector:not(.b-valid)'
    }, {
      mouseUp: null
    }, {
      waitForSelectorNotFound: '.b-sch-dependency-creation-tooltip'
    });
  });
  t.it('Should mark drop position as invalid if not hovering a target terminal by default', function (t) {
    t.chain({
      moveCursorTo: '[data-event-id="1"]'
    }, {
      mousedown: '[data-event-id="1"] .b-sch-terminal-right'
    }, {
      moveCursorTo: '[data-event-id="2"]'
    }, {
      moveCursorTo: '[data-event-id="2"] .b-sch-terminal-right'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(To: Assignment 2)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip .b-header-title:textEquals(Valid)'
    }, {
      waitForSelector: '.b-sch-dependency-connector.b-valid'
    }, // Move cursor to center of task bar => invalid
    {
      moveCursorTo: '[data-event-id="2"]'
    }, // Should not show any target task, + mark as invalid
    {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:textEquals(To:)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip .b-header-title:textEquals(Invalid)'
    }, {
      waitForSelector: '.b-sch-dependency-connector:not(.b-valid)'
    }, // Back to valid terminal task => mark as valid
    {
      moveCursorTo: '[data-event-id="2"] .b-sch-terminal-right'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip tr:contains(To: Assignment 2)'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip .b-header-title:textEquals(Valid)'
    }, {
      waitForSelector: '.b-sch-dependency-connector.b-valid'
    });
  });
});