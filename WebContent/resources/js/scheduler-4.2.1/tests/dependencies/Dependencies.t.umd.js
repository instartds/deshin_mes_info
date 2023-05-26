function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && !scheduler.isDestroyed && scheduler.destroy();
  });
  t.it('Should add `cls` from data to rendered dependency element', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2018, 9, 19),
                endDate: new Date(2018, 9, 31),
                columns: [{
                  field: 'name',
                  text: 'Name'
                }],
                features: {
                  dependencies: true
                },
                resources: ArrayHelper.fill(50, {}, function (resource, i) {
                  return Object.assign(resource, {
                    id: i + 1,
                    name: 'Resource ' + (i + 1)
                  });
                }),
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2018, 9, 20),
                  duration: 2
                }, {
                  id: 2,
                  resourceId: 1,
                  startDate: new Date(2018, 9, 24),
                  duration: 2
                }],
                dependencies: [{
                  id: 1,
                  from: 1,
                  to: 2,
                  cls: 'foo'
                }]
              });
              t.chain({
                waitForDependencies: null
              }, function () {
                var dependencyEls = document.querySelectorAll('polyline');
                t.is(dependencyEls.length, 1, 'One dependency drawn');
                t.ok(dependencyEls[0].classList.contains('foo'), 'cls field added');
              });

            case 2:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/6723/details

  t.it('Should not draw dependencies for removed event when scrolling', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2018, 9, 19),
                endDate: new Date(2018, 9, 31),
                columns: [{
                  field: 'name',
                  text: 'Name'
                }],
                features: {
                  dependencies: true
                },
                resources: ArrayHelper.fill(50, {}, function (resource, i) {
                  return Object.assign(resource, {
                    id: i + 1,
                    name: 'Resource ' + (i + 1)
                  });
                }),
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2018, 9, 20),
                  duration: 2
                }, {
                  id: 2,
                  resourceId: 1,
                  startDate: new Date(2018, 9, 24),
                  duration: 2
                }],
                dependencies: [{
                  id: 1,
                  from: 1,
                  to: 2
                }]
              });
              t.chain({
                waitForAnimationFrame: null,
                desc: 'Initial rendering is done'
              }, {
                waitForSelector: '.b-sch-dependency',
                desc: 'Dependency is drawn'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        t.selectorCountIs('.b-sch-dependency', 1, 'One dependency drawn');
                        scheduler.eventStore.first.remove();
                        t.selectorCountIs('.b-sch-dependency', 0, 'No dependencies drawn');
                        _context2.next = 5;
                        return scheduler.scrollable.scrollBy(0, 5);

                      case 5:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              })), {
                waitForSelectorNotFound: '.b-sch-dependency',
                desc: 'No dependencies drawn'
              });

            case 2:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Enable / disable', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      startDate: new Date(2018, 9, 19),
      endDate: new Date(2018, 9, 31),
      columns: [{
        field: 'name',
        text: 'Name'
      }],
      features: {
        dependencies: true
      },
      resources: ArrayHelper.fill(50, {}, function (resource, i) {
        return Object.assign(resource, {
          id: i + 1,
          name: 'Resource ' + (i + 1)
        });
      }),
      events: [{
        id: 1,
        resourceId: 1,
        startDate: new Date(2018, 9, 20),
        duration: 2
      }, {
        id: 2,
        resourceId: 1,
        startDate: new Date(2018, 9, 24),
        duration: 2
      }],
      dependencies: [{
        id: 1,
        from: 1,
        to: 2
      }]
    });
    t.chain({
      waitForAnimationFrame: null,
      desc: 'Initial rendering is done'
    }, {
      waitForSelector: '.b-sch-dependency',
      desc: 'Dependency is drawn'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              scheduler.features.dependencies.disabled = true;

            case 1:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    })), {
      waitForSelectorNotFound: '.b-sch-dependency',
      desc: 'No dependencies drawn'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              scheduler.features.dependencies.disabled = false;

            case 1:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    })), {
      waitForSelector: '.b-sch-dependency',
      desc: 'Dependency is drawn'
    });
  });
  t.it('Should not throw for invalid assignments', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                features: {
                  dependencies: true
                },
                resources: [{
                  id: 1,
                  name: 'Albert'
                }],
                events: [{
                  id: 1,
                  startDate: '2017-01-16',
                  endDate: '2017-01-18'
                }],
                assignments: [{
                  id: 1,
                  resourceId: 1,
                  eventId: 1
                }],
                startDate: new Date(2017, 0, 16),
                endDate: new Date(2017, 0, 20),
                columns: [{
                  field: 'name',
                  text: 'Name'
                }]
              });
              _context6.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.livesOk(function () {
                scheduler.assignmentStore.add([{
                  id: 2,
                  resourceId: 1,
                  eventId: 2
                }, {
                  id: 3,
                  resourceId: 2,
                  eventId: 1
                }, {
                  id: 4,
                  resourceId: 2,
                  eventId: 2
                }]);
              }, 'Lives ok when adding assignment to non existent dependency');

            case 4:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x3) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Should not throw an exception when mouse is moved out from event which is fading out due to its removing when dependencies enabled', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var r1, e1;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              if (!BrowserHelper.isIE11) {
                _context8.next = 2;
                break;
              }

              return _context8.abrupt("return");

            case 2:
              // Make a long transition so we can determine that it removes slowly
              CSSHelper.insertRule('#animation-state-test-scheduler .b-sch-event-wrap { transition-duration: 0.5s !important; }');
              scheduler = new Scheduler({
                appendTo: document.body,
                id: 'animation-state-test-scheduler',
                transitionDuration: 500,
                enableEventAnimations: true,
                useInitialAnimation: false,
                startDate: new Date(2018, 9, 19),
                endDate: new Date(2018, 9, 31),
                columns: [{
                  field: 'name',
                  text: 'Name'
                }],
                features: {
                  dependencies: true
                },
                resources: ArrayHelper.fill(50, {}, function (resource, i) {
                  return Object.assign(resource, {
                    id: i + 1,
                    name: 'Resource ' + (i + 1)
                  });
                }),
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2018, 9, 20),
                  duration: 2
                }, {
                  id: 2,
                  resourceId: 1,
                  startDate: new Date(2018, 9, 24),
                  duration: 2,
                  cls: 'event2'
                }],
                dependencies: [{
                  id: 1,
                  from: 1,
                  to: 2,
                  cls: 'foo'
                }]
              });
              _context8.next = 6;
              return t.waitForProjectReady(scheduler);

            case 6:
              // Store element for simulator here because event would be removed during test
              r1 = scheduler.eventStore.getAt(1), e1 = scheduler.getElementFromEventRecord(r1);
              t.chain( // Required in EDGE, otherwise click happens before initial scheduler drawing is fully finished
              // and document.activeElement is .b-grid-body-container.b-widget-scroller
              {
                waitForAnimationFrame: null,
                desc: 'Initial rendering is done'
              }, {
                waitForDependencies: null
              }, {
                click: '.event2'
              }, {
                click: '.event2',
                desc: 'Click event to select it'
              }, {
                type: '[DELETE]',
                desc: 'Remove event'
              }, // Events removing happens with a delay (see EventNavigation.onDeleteKeyBuffer),
              // so need to wait when animation starts.
              {
                waitFor: function waitFor() {
                  return scheduler.isAnimating;
                },
                desc: 'Event element starts disappearing'
              },
              /*#__PURE__*/
              // This step is required to reproduce the bug, no extra mouse movement needed
              _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                return regeneratorRuntime.wrap(function _callee7$(_context7) {
                  while (1) {
                    switch (_context7.prev = _context7.next) {
                      case 0:
                        // The bug happens when the element becomes pointer-events:none due to being
                        // put into an animated removing state. Mouseout is triggered in a real UI,
                        // so we have to explicitly fire one here.
                        t.simulator.simulateEvent(e1, 'mouseout');

                      case 1:
                      case "end":
                        return _context7.stop();
                    }
                  }
                }, _callee7);
              })), {
                waitForSelectorNotFound: scheduler.unreleasedEventSelector + '.event2',
                desc: 'Event is removed'
              });

            case 8:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x4) {
      return _ref7.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/9009-dependency-terminals-visible-after-event-resize-with---39-allowcreate--39--set/details#

  t.it('Should not show terminals after resizing if creation is not allowed', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      startDate: new Date(2018, 9, 19),
      endDate: new Date(2018, 9, 31),
      columns: [{
        field: 'name',
        text: 'Name'
      }],
      features: {
        dependencies: {
          allowCreate: false
        }
      },
      resources: ArrayHelper.fill(2, {}, function (resource, i) {
        return Object.assign(resource, {
          id: i + 1,
          name: 'Resource ' + (i + 1)
        });
      }),
      events: [{
        id: 1,
        resourceId: 1,
        startDate: new Date(2018, 9, 20),
        duration: 2
      }]
    });
    t.chain( // resizing start
    {
      moveCursorTo: '.b-sch-event'
    }, {
      drag: '.b-sch-event',
      offset: ['100%-5', 5],
      by: [100, 0]
    }, function () {
      t.selectorNotExists('.b-sch-terminal', 'Terminals not visible');
    });
  }); // https://github.com/bryntum/support/issues/384

  t.it('Should not paint dependencies in collapsed rows on scroll or zoom', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      startDate: new Date(2020, 2, 1),
      endDate: new Date(2020, 6, 1),
      columns: [{
        field: 'name',
        text: 'Name'
      }],
      features: {
        dependencies: true,
        group: 'name'
      },
      resources: [{
        id: 1,
        name: 'Resource 1'
      }],
      events: [{
        id: 1,
        resourceId: 1,
        startDate: new Date(2020, 2, 4),
        duration: 2
      }, {
        id: 2,
        resourceId: 1,
        startDate: new Date(2020, 2, 10),
        duration: 2
      }],
      dependencies: [{
        id: 1,
        from: 1,
        to: 2
      }]
    });
    t.chain({
      waitForDependencies: null
    }, function (next) {
      t.selectorCountIs('.b-sch-dependency', 1, 'One dependency line is visible');
      t.waitForEvent(scheduler, 'dependenciesdrawn', next);
      scheduler.features.group.toggleCollapse(scheduler.resourceStore.groupRecords[0]);
    }, function (next) {
      t.selectorNotExists('.b-sch-dependency', 'No lines found when collapsed');
      t.waitForEvent(scheduler, 'dependenciesdrawn', next);
      scheduler.subGrids.normal.scrollable.x += 10;
    }, function (next) {
      t.selectorNotExists('.b-sch-dependency', 'No lines found when scrolled');
      t.waitForEvent(scheduler, 'dependenciesdrawn', next);
      scheduler.zoomIn();
    }, function () {
      t.selectorNotExists('.b-sch-dependency', 'No lines found when zoomed');
    });
  }); // https://github.com/bryntum/support/issues/464

  t.it('Should refresh dependencies after filtering with schedule region collapsed', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      startDate: new Date(2020, 2, 1),
      endDate: new Date(2020, 6, 1),
      columns: [{
        field: 'name',
        text: 'Name'
      }],
      features: {
        dependencies: true
      },
      resources: [{
        id: 1,
        name: 'Resource 1'
      }, {
        id: 2,
        name: 'Resource 2'
      }],
      events: [{
        id: 1,
        resourceId: 1,
        startDate: new Date(2020, 2, 4),
        duration: 2
      }, {
        id: 2,
        resourceId: 1,
        startDate: new Date(2020, 2, 10),
        duration: 2
      }, {
        id: 3,
        resourceId: 2,
        startDate: new Date(2020, 2, 4),
        duration: 2
      }, {
        id: 4,
        resourceId: 2,
        startDate: new Date(2020, 2, 10),
        duration: 2
      }],
      dependencies: [{
        id: 1,
        from: 1,
        to: 2
      }, {
        id: 2,
        from: 3,
        to: 4
      }]
    });
    t.chain(function () {
      return scheduler.subGrids.normal.collapse();
    }, function (next) {
      scheduler.resourceStore.filter('name', 'Resource 1');
      next();
    }, function () {
      return scheduler.subGrids.normal.expand();
    }, {
      waitFor: function waitFor() {
        return document.querySelectorAll('.b-sch-dependency').length === 1;
      },
      desc: 'One dependency line is visible'
    });
  });
  t.it('Should refresh dependencies after project change', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                enableEventAnimations: false,
                features: {
                  dependencies: true
                },
                resources: [{
                  id: 1,
                  name: 'Albert'
                }],
                events: [{
                  id: 1,
                  startDate: '2017-01-16',
                  endDate: '2017-01-18'
                }, {
                  id: 2,
                  startDate: '2017-01-20',
                  endDate: '2017-01-22'
                }],
                assignments: [{
                  id: 1,
                  resourceId: 1,
                  eventId: 1
                }, {
                  id: 2,
                  resourceId: 1,
                  eventId: 2
                }],
                dependencies: [{
                  id: 1,
                  fromEvent: 1,
                  toEvent: 2
                }],
                startDate: new Date(2017, 0, 16),
                endDate: new Date(2017, 0, 20),
                columns: [{
                  field: 'name',
                  text: 'Name'
                }]
              });
              _context9.next = 3;
              return t.waitForProjectReady();

            case 3:
              _context9.next = 5;
              return t.waitForSelector('.b-sch-dependency');

            case 5:
              scheduler.project = {
                resourcesData: [{
                  id: 1,
                  name: 'Ben'
                }],
                eventsData: [{
                  id: 1,
                  name: 'Source',
                  startDate: '2017-01-16',
                  endDate: '2017-01-17'
                }, {
                  id: 2,
                  name: 'Target',
                  startDate: '2017-01-18',
                  endDate: '2017-01-19'
                }],
                assignmentsData: [{
                  id: 1,
                  resourceId: 1,
                  eventId: 1
                }, {
                  id: 2,
                  resourceId: 1,
                  eventId: 2
                }],
                dependenciesData: [{
                  id: 1,
                  fromEvent: 1,
                  toEvent: 2
                }]
              };
              _context9.next = 8;
              return t.waitForProjectReady(scheduler);

            case 8:
              _context9.next = 10;
              return t.waitForAnimationFrame();

            case 10:
              t.assertDependency(scheduler, scheduler.dependencyStore.first);

            case 11:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x5) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Should ignore store events when assigning project with feature disabled', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                enableEventAnimations: false,
                useInitialAnimation: false,
                features: {
                  dependencies: {
                    disabled: true
                  }
                },
                startDate: new Date(2017, 0, 16),
                endDate: new Date(2017, 0, 20),
                columns: [{
                  field: 'name',
                  text: 'Name'
                }]
              });
              _context10.next = 3;
              return t.waitForProjectReady(scheduler);

            case 3:
              t.isntCalled('onEventChange', scheduler.features.dependencies);
              scheduler.project = new ProjectModel({
                resourcesData: [{
                  id: 1,
                  name: 'Albert'
                }],
                eventsData: [{
                  id: 1,
                  startDate: '2017-01-16',
                  endDate: '2017-01-18'
                }, {
                  id: 2,
                  startDate: '2017-01-20',
                  endDate: '2017-01-22'
                }],
                assignmentsData: [{
                  id: 1,
                  resourceId: 1,
                  eventId: 1
                }, {
                  id: 2,
                  resourceId: 1,
                  eventId: 2
                }],
                dependenciesData: [{
                  id: 1,
                  fromEvent: 1,
                  toEvent: 2
                }]
              });
              scheduler.eventStore.first.name = 'Prince';

            case 6:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x6) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Should highlight dependent tasks + dependency lines if configured to do so', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                enableEventAnimations: false,
                useInitialAnimation: false,
                features: {
                  dependencies: true
                },
                highlightSuccessors: true,
                startDate: new Date(2017, 0, 10),
                endDate: new Date(2017, 0, 30),
                columns: [{
                  field: 'name',
                  text: 'Name'
                }]
              });
              _context11.next = 3;
              return t.waitForProjectReady(scheduler);

            case 3:
              scheduler.project = new ProjectModel({
                resourcesData: [{
                  id: 1,
                  name: 'Albert'
                }],
                eventsData: [{
                  id: 1,
                  startDate: '2017-01-16',
                  endDate: '2017-01-18'
                }, {
                  id: 2,
                  startDate: '2017-01-20',
                  endDate: '2017-01-22'
                }, {
                  id: 3,
                  startDate: '2017-01-25',
                  endDate: '2017-01-25'
                }],
                assignmentsData: [{
                  id: 1,
                  resourceId: 1,
                  eventId: 1
                }, {
                  id: 2,
                  resourceId: 1,
                  eventId: 2
                }, {
                  id: 3,
                  resourceId: 1,
                  eventId: 3
                }],
                dependenciesData: [{
                  id: 1,
                  fromEvent: 1,
                  toEvent: 2
                }, {
                  id: 2,
                  fromEvent: 2,
                  toEvent: 3
                }]
              });
              _context11.next = 6;
              return t.click('[data-assignment-id="1"]');

            case 6:
              t.selectorCountIs('.b-sch-event.b-highlight', 3, 'task + successor tasks highlighted');
              t.selectorCountIs('.b-sch-dependency.b-highlight', 2, 'Dependencies connecting highlighted tasks also highlighted');
              _context11.next = 10;
              return t.click('.b-sch-timeaxis-cell', null, null, null, [5, 5]);

            case 10:
              t.selectorCountIs('.b-sch-event.b-highlight', 0, 'Highlighting removed');
              t.selectorCountIs('.b-sch-dependency.b-highlight', 0, 'Dependencies unhighlighted');
              scheduler.highlightSuccessors = false;
              scheduler.highlightPredecessors = true;
              _context11.next = 16;
              return t.click('[data-assignment-id="3"]');

            case 16:
              t.selectorCountIs('.b-sch-event.b-highlight', 3, 'task + predecessor tasks highlighted');
              t.selectorCountIs('.b-sch-dependency.b-highlight', 2, 'Dependencies connecting highlighted tasks also highlighted');

            case 18:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x7) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Should clear all dependencies if setting empty array', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                features: {
                  dependencies: true
                },
                startDate: new Date(2020, 2, 1),
                endDate: new Date(2020, 2, 30),
                resources: [{
                  id: 1,
                  name: 'Resource 1'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2020, 2, 4),
                  duration: 2
                }, {
                  id: 2,
                  resourceId: 1,
                  startDate: new Date(2020, 2, 10),
                  duration: 2
                }],
                dependencies: [{
                  id: 1,
                  from: 1,
                  to: 2
                }]
              });
              _context12.next = 3;
              return t.waitForSelector('.b-sch-dependency');

            case 3:
              scheduler.dependencies = [];
              _context12.next = 6;
              return t.waitForSelectorNotFound('.b-sch-dependency');

            case 6:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x8) {
      return _ref12.apply(this, arguments);
    };
  }());
});