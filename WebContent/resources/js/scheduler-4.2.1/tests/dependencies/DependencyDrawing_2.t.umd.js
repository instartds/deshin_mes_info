function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

StartTest(function (t) {
  var dependencySelector = 'polyline.b-sch-dependency:not(.b-sch-released)';
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });
  t.it('Should refresh depdencies on scheduler resize', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      // use this very specific width to start scheduler with a horizontal scrollbar
      width: 615,
      height: 400,
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

    function resizeUntilUpdateEvent(callback, decrease) {
      var counter = 0;
      scheduler.timeAxisViewModel.on({
        update: function update() {
          clearInterval(intervalId);
          scheduler.on({
            dependenciesdrawn: function dependenciesdrawn() {
              t.assertDependency(scheduler, scheduler.dependencies[0]);
              callback();
            },
            once: true
          });
        },
        once: true
      });
      var intervalId = setInterval(function () {
        if (counter++ > 22) clearInterval(intervalId);
        scheduler.element.style.width = "".concat(parseInt(scheduler.element.style.width) + 1, "px");
      }, 100);
    }

    t.chain({
      waitForDependencies: null
    }, {
      waitFor: function waitFor() {
        var eventBox = t.rect('[data-event-id="1"]'),
            _t$query = t.query('[depId="1"]'),
            _t$query2 = _slicedToArray(_t$query, 1),
            dependencyEl = _t$query2[0];

        if (eventBox && dependencyEl) {
          var box = t.getSVGBox(dependencyEl);
          return Math.abs(eventBox.right - box.left) <= 1;
        }
      }
    }, function (next) {
      t.assertDependency(scheduler, scheduler.dependencies[0]);
      resizeUntilUpdateEvent(next);
    }, resizeUntilUpdateEvent, function (next) {
      scheduler.on({
        subgridcollapse: function subgridcollapse() {
          scheduler.on({
            dependenciesdrawn: function dependenciesdrawn() {
              t.assertDependency(scheduler, scheduler.dependencies[0]);
              next();
            },
            once: true
          });
        },
        once: true
      });
    });
  });
  t.it('Should draw dependency line if dependency dates are outside of the view', function (t) {
    scheduler = t.getScheduler({
      dependencyStore: t.getDependencyStore({
        data: [{
          id: 1,
          from: 1,
          to: 2,
          fromSide: 'right',
          toSide: 'left'
        }, {
          id: 2,
          from: 1,
          to: 2,
          fromSide: 'top',
          toSide: 'top'
        }, {
          id: 3,
          from: 1,
          to: 2,
          fromSide: 'bottom',
          toSide: 'bottom'
        }]
      }),
      eventStore: t.getEventStore({
        data: [{
          id: 1,
          startDate: '2017-12-01 10:00',
          endDate: '2017-12-01 12:00',
          resourceId: 'r2'
        }, {
          id: 2,
          startDate: '2017-12-03 10:00',
          endDate: '2017-12-03 12:00',
          resourceId: 'r2'
        }]
      }),
      resourceStore: t.getResourceStore2({}, 2),
      features: {
        dependencies: {
          overCls: 'b-sch-dependency-over'
        }
      },
      viewPreset: {
        base: 'hourAndDay',
        tickWidth: 25,
        columnLinesFor: 0,
        headers: [{
          unit: 'd',
          align: 'center',
          dateFormat: 'ddd DD MMM'
        }, {
          unit: 'h',
          align: 'center',
          dateFormat: 'HH'
        }]
      },
      startDate: new Date(2017, 11, 1),
      endDate: new Date(2017, 11, 4)
    }, 2);
    var expectedRects = {};
    t.chain({
      waitForSelector: '.b-sch-dependency'
    }, function (next) {
      DomHelper.forEachSelector(document, dependencySelector, function (el) {
        expectedRects[el.getAttribute('depId')] = el.getBoundingClientRect();
      });
      t.waitForEvent(scheduler, 'dependenciesdrawn', next);
      scheduler.setTimeSpan(new Date(2017, 11, 2), new Date(2017, 11, 3));
    }, function () {
      var cellBox = document.querySelector('.b-sch-timeaxis-cell').getBoundingClientRect();
      DomHelper.forEachSelector(document, dependencySelector, function (el) {
        var id = el.getAttribute('depId'),
            gotRect = el.getBoundingClientRect();
        t.is(gotRect.top, expectedRects[id].top, "Top position is ok for dep ".concat(id));
        t.isGreater(gotRect.width, cellBox.width, 'Dep width is ok');
        t.ok(gotRect.right > cellBox.right && gotRect.left < cellBox.left, 'Dep line located correctly');
      });
    });
  });
  t.it('Should draw line to milestone', function (t) {
    scheduler = t.getScheduler({
      dependencyStore: t.getDependencyStore({
        data: [{
          id: 1,
          from: 1,
          to: 2,
          fromSide: 'right',
          toSide: 'left'
        }, {
          id: 2,
          from: 1,
          to: 2,
          fromSide: 'top',
          toSide: 'top'
        }, {
          id: 3,
          from: 1,
          to: 2,
          fromSide: 'bottom',
          toSide: 'bottom'
        }, {
          id: 4,
          from: 1,
          to: 3,
          fromSide: 'left',
          toSide: 'right'
        }, {
          id: 5,
          from: 1,
          to: 3,
          fromSide: 'top',
          toSide: 'top'
        }, {
          id: 6,
          from: 1,
          to: 3,
          fromSide: 'bottom',
          toSide: 'bottom'
        }]
      }),
      eventStore: t.getEventStore({
        data: [{
          id: 1,
          startDate: '2017-12-02 10:00',
          endDate: '2017-12-02 12:00',
          resourceId: 'r2'
        }, {
          id: 2,
          startDate: '2017-12-03 10:00',
          endDate: '2017-12-03 10:00',
          resourceId: 'r2'
        }, {
          id: 3,
          startDate: '2017-12-01 10:00',
          endDate: '2017-12-01 10:00',
          resourceId: 'r2',
          iconCls: 'b-fa b-fa-search'
        }]
      }),
      resourceStore: t.getResourceStore2({}, 2),
      features: {
        dependencies: {
          overCls: 'b-sch-dependency-over'
        }
      },
      viewPreset: {
        base: 'hourAndDay',
        tickWidth: 25,
        columnLinesFor: 0,
        headers: [{
          unit: 'd',
          align: 'center',
          dateFormat: 'ddd DD MMM'
        }, {
          unit: 'h',
          align: 'center',
          dateFormat: 'HH'
        }]
      },
      startDate: new Date(2017, 11, 1),
      endDate: new Date(2017, 11, 4)
    }, 2);
    var expectedRects = {};
    t.chain({
      waitForSelector: '.b-sch-dependency'
    }, function (next) {
      DomHelper.forEachSelector(document, dependencySelector, function (el) {
        expectedRects[el.getAttribute('depId')] = el.getBBox();
      });
      t.waitForEvent(scheduler, 'dependenciesdrawn', next);
      scheduler.setTimeSpan(new Date(2017, 11, 2), new Date(2017, 11, 3));
    }, function () {
      var cellBox = document.querySelector('.b-sch-timeaxis-cell').getBoundingClientRect(),
          eventBox = document.querySelector('.b-sch-event-wrap:not(.b-milestone-wrap) .b-sch-event').getBoundingClientRect(),
          eventCenter = (eventBox.left + eventBox.right) / 2;
      DomHelper.forEachSelector(document, dependencySelector, function (el) {
        var id = el.getAttribute('depId'),
            gotRect = el.getBBox();
        t.is(gotRect.y, expectedRects[id].y, "Top position is ok for dep ".concat(id)); // Dep now goes to the likely position outside of view, either need to hardcode expectations or
        // scale expectedRects, or do relaxed check such as this...

        t.isGreater(gotRect.width, cellBox.width / 2, 'Dep width is ok');
        t.ok(gotRect.x + gotRect.width - eventCenter < 40 || gotRect.x - eventCenter < 40, 'Dep line points from event center');
      });
    });
  });
  t.it('Should live update dependencies when dragging events', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      startDate: new Date(2018, 8, 2),
      endDate: new Date(2018, 8, 16),
      height: 200,
      enableEventAnimations: false,
      features: {
        dependencies: true
      },
      resources: [{
        id: 'r1',
        name: 'Machine'
      }],
      events: [{
        id: 1,
        resourceId: 'r1',
        name: 'A',
        startDate: new Date(2018, 8, 2),
        duration: 1,
        cls: 'event1'
      }, {
        id: 2,
        resourceId: 'r1',
        name: 'B',
        endDate: new Date(2018, 8, 8),
        duration: 1,
        cls: 'event2'
      }],
      dependencies: [{
        id: 1,
        from: 1,
        to: 2
      }]
    });
    t.chain({
      drag: '.event2',
      by: [0, 300],
      dragOnly: true
    }, {
      moveMouseBy: [100, 0]
    }, function (next) {
      t.assertDependency(scheduler, scheduler.dependencies[0]);
      next();
    }, {
      moveMouseBy: [-200, 0]
    }, function (next) {
      t.assertDependency(scheduler, scheduler.dependencies[0]);
      next();
    }, {
      moveMouseBy: [100, -300]
    }, {
      mouseUp: null
    }, function () {
      t.assertDependency(scheduler, scheduler.dependencies[0]);
    });
  });
  t.it('Should remove dependency lines when records are removed from store', function (t) {
    scheduler = t.getScheduler({
      dependencyStore: t.getDependencyStore({
        data: [{
          id: 1,
          from: 1,
          to: 2,
          fromSide: 'top',
          toSide: 'top'
        }, {
          id: 2,
          from: 1,
          to: 2,
          fromSide: 'bottom',
          toSide: 'bottom'
        }, {
          id: 3,
          from: 1,
          to: 3,
          fromSide: 'left',
          toSide: 'right'
        }]
      }),
      eventStore: t.getEventStore({
        data: [{
          id: 1,
          startDate: '2017-12-02 10:00',
          endDate: '2017-12-02 12:00',
          resourceId: 'r2'
        }, {
          id: 2,
          startDate: '2017-12-03 10:00',
          endDate: '2017-12-03 10:00',
          resourceId: 'r2'
        }, {
          id: 3,
          startDate: '2017-12-01 10:00',
          endDate: '2017-12-01 10:00',
          resourceId: 'r2'
        }]
      }),
      resourceStore: t.getResourceStore2({}, 2),
      features: {
        dependencies: {
          overCls: 'b-sch-dependency-over'
        }
      },
      startDate: new Date(2017, 11, 1),
      endDate: new Date(2017, 11, 4)
    }, 2);
    t.chain({
      waitForSelector: '.b-sch-dependency'
    }, function (next) {
      t.waitForSelectorNotFound('.b-sch-dependency', next);
      scheduler.dependencyStore.removeAll();
    }, function () {
      t.waitForEvent(scheduler, 'dependenciesdrawn', function () {
        t.selectorCountIs('.b-sch-dependency', 0, 'No dependency lines visible');
      });
      scheduler.features.dependencies.scheduleDraw();
    });
  }); // TODO : Do not understand this test...

  t.xit('Dependencies should be rendered properly after add/remove followed by redraw', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      startDate: new Date(2018, 8, 2),
      endDate: new Date(2018, 8, 16),
      features: {
        dependencies: true
      },
      resources: [{
        id: 'r1',
        name: 'Machine'
      }],
      events: [{
        id: 1,
        resourceId: 'r1',
        name: 'A',
        startDate: new Date(2018, 8, 2),
        duration: 1
      }, {
        id: 2,
        resourceId: 'r1',
        name: 'B',
        endDate: new Date(2018, 8, 8),
        duration: 1
      }],
      dependencies: []
    });
    t.chain({
      waitForSelector: '.b-sch-event'
    }, function (next) {
      // Checking if redrawing all deps works properly, when working with records directly, they are always
      // rendered, but redrawing uses cache and by doing tht we are checking if records are cached properly.
      // It occurs e.g. when user scrolls the view
      // #7009
      t.waitForEvent(scheduler, 'dependenciesdrawn', function () {
        t.waitForEvent(scheduler, 'dependenciesdrawn', next);
        scheduler.features.dependencies.scheduleDraw();
      });
      scheduler.dependencyStore.add([{
        id: 1,
        from: 1,
        to: 2,
        fromSide: 'top',
        toSide: 'top'
      }, {
        id: 2,
        from: 1,
        to: 2,
        fromSide: 'bottom',
        toSide: 'bottom'
      }]);
    }, function (next) {
      t.selectorCountIs(dependencySelector, 2, 'Dependencies are ok');
      t.waitForEvent(scheduler, 'dependenciesdrawn', function () {
        t.waitForEvent(scheduler, 'dependenciesdrawn', next);
        scheduler.features.dependencies.scheduleDraw();
      });
      scheduler.dependencyStore.add([{
        id: 3,
        from: 1,
        to: 2
      }]);
    }, function (next) {
      t.selectorCountIs(dependencySelector, 3, 'Dependencies are ok');
      t.waitForEvent(scheduler, 'dependenciesdrawn', function () {
        t.waitForEvent(scheduler, 'dependenciesdrawn', next);
        scheduler.features.dependencies.scheduleDraw();
      });
      scheduler.dependencyStore.remove([2, 3]);
    }, function (next) {
      t.selectorCountIs(dependencySelector, 1, 'Dependencies are ok');
      t.waitForEvent(scheduler, 'dependenciesdrawn', function () {
        t.waitForEvent(scheduler, 'dependenciesdrawn', next);
        scheduler.features.dependencies.scheduleDraw();
      });
      scheduler.dependencyStore.remove(1);
    }, function () {
      t.selectorCountIs(dependencySelector, 0, 'Dependencies are ok');
    });
  });
  t.it('Dependencies feature should not try to redraw upon any store changes before first render', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var depStore, oldOn, project;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              depStore = new DependencyStore({
                data: [{
                  id: 1,
                  from: 1,
                  to: 2
                }]
              }), oldOn = depStore.on, project = new ProjectModel({
                resourcesData: [{
                  id: 'r1',
                  name: 'Machine'
                }],
                eventsData: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'A',
                  startDate: new Date(2018, 8, 2),
                  duration: 1
                }, {
                  id: 2,
                  resourceId: 'r1',
                  name: 'B',
                  endDate: new Date(2018, 8, 8),
                  duration: 1
                }]
              });
              _context.next = 3;
              return t.waitForProjectReady(project);

            case 3:
              // Fire event as soon as someone listens for something
              depStore.on = function () {
                var retVal = oldOn.apply(this, arguments);
                this.first.from = 3;
                return retVal;
              };

              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2018, 8, 2),
                endDate: new Date(2018, 8, 16),
                features: {
                  dependencies: true
                },
                project: project
              });

            case 5:
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
  t.it('Dependency repainted properly when moving successor outside of the view', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var dep, event, newStart, el, box, newLeft, refreshDependencySpy;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                resources: [{
                  id: 1,
                  name: 'Foo'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  name: 'Event 1',
                  startDate: '2017-01-16',
                  endDate: '2017-01-18'
                }, {
                  id: 2,
                  resourceId: 1,
                  name: 'Event 2',
                  startDate: '2017-01-19',
                  endDate: '2017-01-21'
                }],
                dependencies: [{
                  id: 1,
                  from: 1,
                  to: 2
                }],
                startDate: '2017-01-15',
                endDate: '2017-01-30'
              });

            case 2:
              scheduler = _context4.sent;
              dep = scheduler.dependencies[0], event = scheduler.eventStore.getById(2);
              t.chain( // First dependency draw must take place for us to begin test
              {
                waitForDependencies: null
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        t.assertDependency(scheduler, dep);
                        refreshDependencySpy = t.spyOn(scheduler.features.dependencies, 'refreshDependencyOnFrame').and.callThrough();
                        newStart = new Date(2017, 0, 29);
                        _context2.next = 5;
                        return event.setStartDate(newStart);

                      case 5:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              })), {
                // Wait for the dependency to be refreshed (once per event in the row)
                waitFor: function waitFor() {
                  return refreshDependencySpy.calls.count() === 2;
                },
                desc: 'First refresh'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        el = scheduler.getElementsFromEventRecord(scheduler.events[0])[0];
                        box = el.getBoundingClientRect();
                        newLeft = scheduler.getCoordinateFromDate(newStart) + scheduler.timeAxisSubGridElement.getBoundingClientRect().left;
                        t.assertDependency(scheduler, dep, {
                          toBox: {
                            left: newLeft,
                            width: box.width,
                            top: box.top,
                            height: box.height
                          }
                        });
                        newStart = new Date(2017, 1, 10);
                        _context3.next = 7;
                        return event.setStartDate(newStart);

                      case 7:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3);
              })), {
                // Wait for the dependency to be refreshed
                waitFor: function waitFor() {
                  return refreshDependencySpy.calls.count() === 4;
                }
              }, function () {
                // New rendering positions it "correctly" outside of view
                newLeft =
                /*scheduler.timeAxisViewModel.totalSize*/
                2560 + scheduler.timeAxisSubGridElement.getBoundingClientRect().left;
                t.assertDependency(scheduler, dep, {
                  toBox: {
                    left: newLeft,
                    width: box.width,
                    top: box.top,
                    height: box.height
                  }
                });
              });

            case 5:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Should not throw when dragging task with invalid incoming/outgoing deps', function (t) {
    scheduler = t.getScheduler({
      resources: [{
        id: 1,
        name: 'Foo'
      }],
      events: [{
        id: 1,
        resourceId: 1,
        name: 'Event 1',
        startDate: '2017-01-16',
        endDate: '2017-01-18'
      }],
      dependencies: [{
        id: 1,
        from: 1,
        to: 2
      }, {
        id: 2,
        from: 3,
        to: 1
      }],
      startDate: '2017-01-15',
      endDate: '2017-01-30'
    });
    t.chain({
      waitForEventsToRender: null
    }, {
      drag: '.b-sch-event',
      by: [100, 0]
    }, function () {
      t.pass('Dragging does not throw');
    });
  });
  t.it('Should reset bounds cache if at least one draw was scheduled with relayout option', function (t) {
    scheduler = t.getScheduler({
      dependencyStore: true
    });
    var depFeature = scheduler.features.dependencies;
    t.chain({
      waitForSelector: '.b-sch-dependency'
    }, function (next) {
      t.isCalledNTimes('resetBoundsCache', depFeature, 2, 'Cache is reset');
      t.waitForEvent(scheduler, 'dependenciesdrawn', next);
      depFeature.scheduleDraw(true);
      depFeature.scheduleDraw(false);
    }, function (next) {
      t.waitForEvent(scheduler, 'dependenciesdrawn', next);
      depFeature.scheduleDraw(false);
      depFeature.scheduleDraw(true);
    });
  });
});