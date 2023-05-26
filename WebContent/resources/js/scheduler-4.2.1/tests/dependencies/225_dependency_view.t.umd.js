function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });

  var injectDependencyStyle = function injectDependencyStyle() {
    var style = document.createElement('style');
    style.innerHTML = "\n            polyline {\n                stroke-width: 15 !important;\n            }";
    document.head.appendChild(style);
    return style;
  },
      applyPointerHook = function applyPointerHook() {
    // Can't find a simple way to trigger hover perfect across browsers since SVG impl is different
    // Force pointer events to all to get reliable hover triggering
    Array.from(scheduler.element.querySelectorAll('.b-sch-dependency')).forEach(function (node) {
      node.style['pointer-events'] = 'all';
    });
  };

  t.it('Should maintain a steady number of drawn dependencies on scroll', function (t) {
    var dependencySelector = 'polyline.b-sch-dependency:not(.b-sch-released)';
    var eventStore = new EventStore({
      data: ArrayHelper.populate(1000, function (i) {
        return {
          id: i,
          cls: 'event' + i,
          resourceId: 'r' + i,
          name: 'Assignment ' + i,
          startDate: new Date(2011, 0, 4),
          endDate: new Date(2011, 0, 6)
        };
      })
    });
    scheduler = t.getScheduler({
      eventStore: eventStore,
      dependencyStore: true,
      startDate: new Date(2011, 0, 3),
      endDate: new Date(2011, 0, 13),
      resourceStore: t.getResourceStore2({}, 2500)
    }, 1000);
    var scroller = scheduler.scrollable;
    var lineCount, drawnDepLen; // The line count must remain stable during scroll

    t.chain({
      waitForDependencies: null
    }, // Scroll to where we have dependencies spilling out both top and bottom of scheduler's scrolling viewport.
    // From here, the number of dependencies should remain stable to within a tolerance of 2 on scroll.
    // Depending upon the exact scroll position, there may be 2 more or fewer lines.
    {
      waitForEvent: [scroller, 'scrollend'],
      trigger: function trigger() {
        scheduler.scrollEventIntoView(scheduler.eventStore.getAt(30));
      },
      desc: 'Scrolled to Event 30'
    }, {
      waitForAnimationFrame: null
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              lineCount = t.query(dependencySelector).length;
              drawnDepLen = scheduler.features.dependencies.drawnDependencies.length;

            case 2:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    })), {
      waitForEvent: [scroller, 'scrollend'],
      trigger: function trigger() {
        scheduler.scrollEventIntoView(scheduler.eventStore.getAt(40));
      },
      desc: 'Scrolled to Event 40'
    }, {
      waitForAnimationFrame: null
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              t.isApprox(t.query(dependencySelector).length, lineCount, 2, "Number of lines is correct: ".concat(lineCount));
              t.isApprox(scheduler.features.dependencies.drawnDependencies.length, drawnDepLen, 2, "Number of drawn dependencies is correct: ".concat(drawnDepLen));

            case 2:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    })), {
      waitForEvent: [scroller, 'scrollend'],
      trigger: function trigger() {
        scheduler.scrollEventIntoView(scheduler.eventStore.getAt(60));
      },
      desc: 'Scrolled to Event 60'
    }, {
      waitForAnimationFrame: null
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              t.isApprox(t.query(dependencySelector).length, lineCount, 2, "Number of lines is correct: ".concat(lineCount));
              t.isApprox(scheduler.features.dependencies.drawnDependencies.length, drawnDepLen, 2, "Number of drawn dependencies is correct: ".concat(drawnDepLen));

            case 2:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    })), {
      waitForEvent: [scroller, 'scrollend'],
      trigger: function trigger() {
        scheduler.scrollEventIntoView(scheduler.eventStore.getAt(200));
      },
      desc: 'Scrolled to Event 200'
    }, {
      waitForAnimationFrame: null
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              t.isApprox(t.query(dependencySelector).length, lineCount, 2, "Number of lines is correct: ".concat(lineCount));
              t.isApprox(scheduler.features.dependencies.drawnDependencies.length, drawnDepLen, 2, "Number of drawn dependencies is correct: ".concat(drawnDepLen));

            case 2:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    })), {
      waitForEvent: [scroller, 'scrollend'],
      trigger: function trigger() {
        scheduler.scrollEventIntoView(scheduler.eventStore.getAt(300));
      },
      desc: 'Scrolled to Event 300'
    }, {
      waitForAnimationFrame: null
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              t.isApprox(t.query(dependencySelector).length, lineCount, 2, "Number of lines is correct: ".concat(lineCount));
              t.isApprox(scheduler.features.dependencies.drawnDependencies.length, drawnDepLen, 2, "Number of drawn dependencies is correct: ".concat(drawnDepLen));

            case 2:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    })), {
      waitForEvent: [scroller, 'scrollend'],
      trigger: function trigger() {
        scheduler.scrollEventIntoView(scheduler.eventStore.getAt(900));
      },
      desc: 'Scrolled to Event 900'
    }, {
      waitForAnimationFrame: null
    }, function () {
      t.isApprox(t.query(dependencySelector).length, lineCount, 2, "Number of lines is correct: ".concat(lineCount));
      t.isApprox(scheduler.features.dependencies.drawnDependencies.length, drawnDepLen, 2, "Number of drawn dependencies is correct: ".concat(drawnDepLen));
    });
  });
  !BrowserHelper.isIE11 && t.it('Should fire dependencymouseover/dependencymouseout events', function (t) {
    scheduler = t.getScheduler({
      dependencyStore: true,
      resourceStore: t.getResourceStore2({}, 2),
      features: {
        eventTooltip: false,
        dependencies: {
          overCls: 'b-sch-dependency-over',
          showTooltip: true
        }
      }
    }, 2);
    t.firesAtLeastNTimes(scheduler, 'dependencymouseover', 1);
    t.firesAtLeastNTimes(scheduler, 'dependencymouseout', 1);
    t.chain({
      waitForSelector: '.b-sch-dependency'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6() {
      var lineElement;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              lineElement = document.querySelector('.b-sch-dependency');
              lineElement.style.transition = 'none';
              lineElement.style.strokeWidth = '10px';
              _context6.next = 5;
              return scheduler.nextAnimationFrame();

            case 5:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    })), {
      moveCursorTo: '.b-sch-dependency',
      offset: [-5, '50%']
    }, {
      moveMouseTo: '.b-sch-event'
    }, {
      waitForSelectorNotFound: '.b-sch-dependency-over'
    });
  }); // #3243

  t.it('Dependency painted ok on the last rendered row', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return t.getSchedulerAsync({
                events: [],
                resources: ArrayHelper.populate(50, function (i) {
                  return {
                    id: i + 1,
                    name: i + 1
                  };
                }),
                dependencies: [],
                features: {
                  eventTooltip: false,
                  dependencies: true
                }
              });

            case 2:
              scheduler = _context7.sent;
              // Add two events so only one is rendered and link them with dependency
              scheduler.eventStore.add([{
                id: 1,
                name: 'Realized',
                resourceId: 10,
                startDate: '2011-01-06',
                endDate: '2011-01-08'
              }, {
                id: 2,
                name: 'Unrealized',
                resourceId: 25,
                startDate: '2011-01-06',
                endDate: '2011-01-08'
              }]);
              scheduler.dependencyStore.add({
                from: 1,
                to: 2
              }); // Add two records to stretch row vertically, to make things more fun and complex

              scheduler.eventStore.add([{
                startDate: '2011-01-06',
                endDate: '2011-01-08',
                resourceId: 2
              }, {
                startDate: '2011-01-06',
                endDate: '2011-01-08',
                resourceId: 2
              }]);
              _context7.next = 8;
              return t.waitForProjectReady();

            case 8:
              t.chain({
                waitForDependencies: null
              }, {
                waitFor: function waitFor() {
                  var dependency = document.querySelector('.b-sch-dependency'),
                      svg = document.querySelector('svg'),
                      record = scheduler.eventStore.first,
                      eventBox = scheduler.getElementsFromEventRecord(record)[0].getBoundingClientRect();
                  return dependency && dependency.getBBox().y + svg.getBoundingClientRect().top - (eventBox.top + eventBox.height / 2) <= 2;
                }
              }, function () {
                t.pass('Horizontal line placed ok');
              });

            case 9:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Should not draw dependency to missing event', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventTooltip: false,
                  dependencies: true
                },
                dependencies: [{
                  from: 1,
                  to: 2
                }],
                resources: [{
                  id: 1,
                  name: 'Dude'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  name: 'A',
                  startDate: '2011-01-06',
                  endDate: '2011-01-08'
                }, {
                  id: 2,
                  resourceId: 1,
                  name: 'B',
                  startDate: '2011-01-10',
                  endDate: '2011-01-12'
                }]
              }, 25);

            case 2:
              scheduler = _context9.sent;
              t.chain({
                waitForDependencies: null
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8() {
                return regeneratorRuntime.wrap(function _callee8$(_context8) {
                  while (1) {
                    switch (_context8.prev = _context8.next) {
                      case 0:
                        scheduler.features.dependencies.dependencyStore.first.to = 3;

                      case 1:
                      case "end":
                        return _context8.stop();
                    }
                  }
                }, _callee8);
              })), {
                waitForSelectorNotFound: '.b-sch-dependency:not(.b-sch-released)',
                desc: 'Dependency not drawn'
              });

            case 4:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x2) {
      return _ref8.apply(this, arguments);
    };
  }());
  !BrowserHelper.isIE11 && t.it('Should show tooltip when hovering a dependency line', function (t) {
    var style = injectDependencyStyle();
    scheduler = t.getScheduler({
      dependencyStore: true,
      resourceStore: t.getResourceStore2({}, 2),
      features: {
        eventTooltip: false,
        scheduleTooltip: false,
        dependencies: {
          overCls: 'b-sch-dependency-over',
          showTooltip: true
        }
      }
    }, 2);
    t.chain({
      moveCursorTo: [0, 0]
    }, {
      waitForDependencies: null
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10() {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              return _context10.abrupt("return", applyPointerHook);

            case 1:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    })), {
      moveCursorTo: '.b-sch-dependency',
      offset: ['50%-3', '50%-3']
    }, // (next) => {
    //     // With SVG, triggering of mouseover is not reliable x-browser
    //     t.simulateEvent('.b-sch-dependency', 'mouseover');
    //
    //     next();
    // },
    {
      waitForSelector: '.b-sch-dependency-tooltip:contains(From: Assignment 1)'
    }, {
      waitForSelector: '.b-sch-dependency-tooltip:contains(To: Assignment 2)'
    }, {
      moveMouseBy: [0, 50]
    }, {
      waitForSelectorNotFound: '.b-tooltip'
    }, function () {
      document.head.removeChild(style);
    });
  });
  t.it('Should not crash nor draw dependency to event of non-existing resource', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventTooltip: false,
        dependencies: true
      },
      dependencies: [{
        from: 1,
        to: 2
      }],
      resources: [{
        id: 1,
        name: 'Dude'
      }, {
        id: 2,
        name: 'Other Dude'
      }],
      events: [{
        id: 1,
        resourceId: 1,
        name: 'A',
        startDate: '2011-01-06',
        endDate: '2011-01-08'
      }, {
        id: 2,
        resourceId: 2,
        name: 'A',
        startDate: '2011-01-06',
        endDate: '2011-01-08'
      }]
    });
    t.chain({
      waitForDependencies: null
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11() {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              scheduler.eventStore.first.resourceId = 'blargh';

            case 1:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    })), {
      waitForSelectorNotFound: '.b-sch-dependency:not(.b-sch-released)',
      desc: 'Dependency not drawn'
    });
  });
  t.it('Should be possible to disable creating dependencies while still drawing them', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventTooltip: false,
        dependencies: {
          allowCreate: false
        }
      },
      resources: [{
        id: 1,
        name: 'Dude'
      }],
      events: [{
        id: 1,
        resourceId: 1,
        cls: 'foo',
        startDate: '2011-01-06',
        endDate: '2011-01-08'
      }, {
        id: 2,
        resourceId: 1,
        cls: 'bar',
        startDate: '2011-01-06',
        endDate: '2011-01-08'
      }]
    });
    t.chain({
      moveCursorTo: '.b-sch-event.foo'
    }, {
      waitForSelectorNotFound: '.b-sch-terminal',
      desc: 'Dependency terminals not shown'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12() {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              scheduler.features.dependencies.allowCreate = true;

            case 1:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    })), {
      moveCursorTo: '.b-sch-event.bar'
    }, {
      waitForSelector: '.b-sch-terminal',
      desc: 'Dependency terminals hown'
    });
  });
  t.it('Should respect Scheduler readOnly state', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventTooltip: false,
        dependencies: {
          allowCreate: true
        }
      },
      resources: [{
        id: 1,
        name: 'Dude'
      }],
      events: [{
        id: 1,
        resourceId: 1,
        cls: 'foo',
        startDate: '2011-01-06',
        endDate: '2011-01-08'
      }, {
        id: 2,
        resourceId: 1,
        cls: 'bar',
        startDate: '2011-01-06',
        endDate: '2011-01-08'
      }]
    });
    t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13() {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              scheduler.readOnly = true;

            case 1:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    })), {
      moveCursorTo: '.b-sch-event.foo'
    }, {
      waitForSelectorNotFound: '.b-sch-terminal',
      desc: 'Dependency terminals not shown when Scheduler is readOnly'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14() {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              scheduler.readOnly = false;

            case 1:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    })), {
      moveCursorTo: '.b-sch-event.bar'
    }, {
      waitForSelector: '.b-sch-terminal',
      desc: 'Dependency terminals shown when Scheduler is not readOnly'
    });
  });
  t.it('Should respect feature disabled state', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventTooltip: false,
        dependencies: {
          allowCreate: true
        }
      },
      resources: [{
        id: 1,
        name: 'Dude'
      }],
      events: [{
        id: 1,
        resourceId: 1,
        cls: 'foo',
        startDate: '2011-01-06',
        endDate: '2011-01-08'
      }, {
        id: 2,
        resourceId: 1,
        cls: 'bar',
        startDate: '2011-01-06',
        endDate: '2011-01-08'
      }]
    });
    t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15() {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              scheduler.features.dependencies.disabled = true;

            case 1:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    })), {
      moveCursorTo: '.b-sch-event.foo'
    }, {
      waitForSelectorNotFound: '.b-sch-terminal',
      desc: 'Dependency terminals not shown when Scheduler is readOnly'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16() {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              scheduler.features.dependencies.disabled = false;

            case 1:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    })), {
      moveCursorTo: '.b-sch-event.bar'
    }, {
      waitForSelector: '.b-sch-terminal',
      desc: 'Dependency terminals shown when Scheduler is not readOnly'
    });
  }); // https://app.assembla.com/spaces/bryntum/tickets/9093

  t.it('Should clear dependencies when event store is cleared', function (t) {
    scheduler = t.getScheduler({
      dependencies: [{
        from: 1,
        to: 2
      }, {
        from: 2,
        to: 3
      }, {
        from: 3,
        to: 4
      }, {
        from: 4,
        to: 5
      }]
    });
    t.chain({
      waitForDependencies: null
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17() {
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              scheduler.eventStore.removeAll();

            case 1:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    })), {
      waitForSelectorNotFound: '.b-sch-dependency'
    }, function (next) {
      scheduler.eventStore.add({
        resourceId: 'r1',
        startDate: '2011-01-04',
        endDate: '2011-01-06'
      });
      scheduler.eventStore.add({
        resourceId: 'r2',
        startDate: '2011-01-04',
        endDate: '2011-01-06'
      });
      scheduler.features.dependencies.scheduleDraw();
      t.waitForEvent(scheduler, 'dependenciesdrawn', next);
    }, function () {
      t.selectorCountIs('.b-sch-dependency', 0, 'No dependencies rendered');
    });
  });
  t.it('Should not be affected by XSS injection', function (t) {
    var style = injectDependencyStyle();
    scheduler = t.getScheduler({
      dependencies: [{
        id: 1,
        from: 1,
        to: 2
      }, {
        id: 2,
        from: 3,
        to: 1
      }]
    });
    t.injectXSS(scheduler);
    t.chain({
      waitForDependencies: null
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18() {
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              return _context18.abrupt("return", applyPointerHook);

            case 1:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    })), {
      moveCursorTo: '.b-sch-dependency[depId="1"]',
      offset: [0, '50%']
    }, {
      moveCursorTo: '.b-sch-dependency[depId="2"]',
      offset: [0, '50%']
    }, function () {
      return document.head.removeChild(style);
    });
  });
});