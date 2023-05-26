function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _createForOfIteratorHelper(o, allowArrayLike) { var it = typeof Symbol !== "undefined" && o[Symbol.iterator] || o["@@iterator"]; if (!it) { if (Array.isArray(o) || (it = _unsupportedIterableToArray(o)) || allowArrayLike && o && typeof o.length === "number") { if (it) o = it; var i = 0; var F = function F() {}; return { s: F, n: function n() { if (i >= o.length) return { done: true }; return { done: false, value: o[i++] }; }, e: function e(_e) { throw _e; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var normalCompletion = true, didErr = false, err; return { s: function s() { it = it.call(o); }, n: function n() { var step = it.next(); normalCompletion = step.done; return step; }, e: function e(_e2) { didErr = true; err = _e2; }, f: function f() { try { if (!normalCompletion && it.return != null) it.return(); } finally { if (didErr) throw err; } } }; }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

StartTest(function (t) {
  var scheduler, instances, count;
  t.beforeEach(function () {
    var _scheduler, _scheduler$destroy;

    (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : (_scheduler$destroy = _scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(_scheduler);
    instances = new Set();
    count = 0;
  });

  var Over = /*#__PURE__*/function () {
    function Over() {
      _classCallCheck(this, Over);
    }

    _createClass(Over, [{
      key: "construct",
      value: function construct() {
        var _this$_overridden$con;

        this.__count = count++;

        var result = (_this$_overridden$con = this._overridden.construct).call.apply(_this$_overridden$con, [this].concat(Array.prototype.slice.call(arguments)));

        instances.add(this);
        return result;
      }
    }], [{
      key: "target",
      get: function get() {
        return {
          class: Base
        };
      }
    }]);

    return Over;
  }();

  Override.apply(Over); // https://github.com/bryntum/support/issues/2575

  t.it('Should destroy all stores / project when destroying Scheduler when destroyStores is set', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var _scheduler2, timeAxis, timeAxisViewModel, unjoinedStores, timeRangeStore, project, eventStore, resourceStore, dependencyStore, assignmentStore, calendarManagerStore, resourceTimeRangeStore;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                resources: [{}],
                columns: [{}],
                destroyStores: true,
                features: {
                  timeRanges: true,
                  resourceTimeRanges: true
                }
              });
              _scheduler2 = scheduler, timeAxis = _scheduler2.timeAxis, timeAxisViewModel = _scheduler2.timeAxisViewModel, unjoinedStores = timeAxis.first.unjoinedStores, timeRangeStore = scheduler.features.timeRanges.store, project = scheduler.project, eventStore = project.eventStore, resourceStore = project.resourceStore, dependencyStore = project.dependencyStore, assignmentStore = project.assignmentStore, calendarManagerStore = project.calendarManagerStore, resourceTimeRangeStore = scheduler.features.resourceTimeRanges.store;
              t.is(scheduler.project.resourceTimeRangeStore, resourceTimeRangeStore, 'resourceTimeRangeStore is as expected');
              scheduler.destroy();
              t.is(scheduler.isDestroyed, true, 'Destroyed');
              t.is(timeAxis.isDestroyed, true, 'timeAxis Destroyed');
              t.is(timeAxisViewModel.isDestroyed, true, 'timeAxisViewModel Destroyed');
              t.is(project.isDestroyed, true, 'project Destroyed');
              t.is(unjoinedStores.length, 0, 'Records not added to unjoinedStores when the store is being destroyed');
              t.is(eventStore.isDestroyed, true, 'eventStore Destroyed');
              t.is(resourceStore.isDestroyed, true, 'resourceStore Destroyed');
              t.is(dependencyStore.isDestroyed, true, 'dependencyStore Destroyed');
              t.is(assignmentStore.isDestroyed, true, 'assignmentStore Destroyed');
              t.is(calendarManagerStore.isDestroyed, true, 'calendarManagerStore Destroyed');
              t.is(timeRangeStore.isDestroyed, true, 'timeRanges.store Destroyed');
              t.is(resourceTimeRangeStore.isDestroyed, true, 'resourceTimeRanges.store Destroyed');

            case 16:
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
  t.it('Should not find arrays / objects having member count growing with amount of operations performed', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var i, maxFails, count, _iterator, _step, bryntumInstance, name, value, skip, entries;

      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2020, 1, 1),
                endDate: new Date(2020, 2, 1),
                columns: [{
                  field: 'name'
                }],
                project: {},
                features: {
                  dependencies: true,
                  timeRanges: true,
                  resourceTimeRanges: true
                }
              });
              scheduler.resourceStore.id = Math.PI;
              scheduler.eventStore.id = Math.PI;
              scheduler.dependencyStore.id = Math.PI;
              scheduler.assignmentStore.id = Math.PI;
              scheduler.project.id = Math.PI;

              for (i = 1; i < 110; i++) {
                scheduler.shiftNext();
                scheduler.shiftPrevious();
                scheduler.project = {
                  listeners: {
                    load: function load() {},
                    thisObj: scheduler
                  },
                  calendarManagerStore: {
                    data: [{
                      id: i
                    }],
                    listeners: {
                      load: function load() {}
                    }
                  },
                  assignmentStore: {
                    data: [{
                      id: i,
                      eventId: i,
                      resourceId: i
                    }, {
                      id: i + 1,
                      eventId: i + 1,
                      resourceId: i
                    }]
                  },
                  resourceStore: {
                    data: [{
                      id: i,
                      name: 'foo'
                    }]
                  },
                  eventStore: {
                    data: [{
                      id: i,
                      startDate: new Date(2020, 1, 1),
                      duration: i
                    }, {
                      id: i + 1,
                      startDate: new Date(2020, 1, 11),
                      duration: i + 1
                    }]
                  },
                  dependencyStore: {
                    data: [{
                      id: i,
                      from: i,
                      to: i + 1
                    }]
                  }
                };
                Object.assign(scheduler, {
                  timeRanges: {
                    data: [{
                      id: i,
                      startDate: new Date(2020, 1, 1),
                      endDate: new Date(2020, 1, 2)
                    }]
                  },
                  resourceTimeRanges: {
                    data: [{
                      id: i,
                      resourceId: i,
                      startDate: new Date(2020, 1, 1),
                      endDate: new Date(2020, 1, 2)
                    }]
                  } // timeRangeStore : {
                  //     data : [{
                  //         id        : i,
                  //         startDate : new Date(2020, 1, 1),
                  //         endDate   : new Date(2020, 1, 2)
                  //     }]
                  // },
                  // resourceTimeRangeStore : {
                  //     data : [{
                  //         id         : i,
                  //         resourceId : i,
                  //         startDate  : new Date(2020, 1, 1),
                  //         endDate    : new Date(2020, 1, 2)
                  //     }]
                  // }

                });
                scheduler.resourceStore.first.name = String(i);
              }

              maxFails = 10;
              count = 0; // Look for arrays or objects with members growing in size

              _iterator = _createForOfIteratorHelper(instances);
              _context2.prev = 10;

              _iterator.s();

            case 12:
              if ((_step = _iterator.n()).done) {
                _context2.next = 19;
                break;
              }

              bryntumInstance = _step.value;

              for (name in bryntumInstance) {
                value = bryntumInstance[name], skip = {
                  configDone: 1
                }, entries = value && !(name in skip) && (Array.isArray(value) ? value : _typeof(value) === 'object' && !value.$$name && Object.keys(value));

                if ((entries === null || entries === void 0 ? void 0 : entries.length) > 100) {
                  t.fail(bryntumInstance.$$name + ' ' + name + ': ' + entries.length);
                  count++;
                }
              }

              if (!(count >= maxFails)) {
                _context2.next = 17;
                break;
              }

              return _context2.abrupt("break", 19);

            case 17:
              _context2.next = 12;
              break;

            case 19:
              _context2.next = 24;
              break;

            case 21:
              _context2.prev = 21;
              _context2.t0 = _context2["catch"](10);

              _iterator.e(_context2.t0);

            case 24:
              _context2.prev = 24;

              _iterator.f();

              return _context2.finish(24);

            case 27:
              if (!t.isFailed()) {
                t.pass('No leaks detected');
              }

            case 28:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2, null, [[10, 21, 24, 27]]);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Should not find references to old replaced project / store instances', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var drawCount, cls;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2020, 1, 1),
                endDate: new Date(2020, 2, 1),
                columns: [{
                  field: 'name',
                  type: 'tree'
                }],
                project: {
                  stm: {
                    autoRecord: true
                  }
                },
                features: {
                  pdfExport: true,
                  dependencies: true,
                  dependencyEdit: true,
                  eventFilter: true,
                  timeRanges: true,
                  resourceTimeRanges: true,
                  filterBar: true,
                  tree: true,
                  summary: {
                    renderer: function renderer() {
                      return '';
                    }
                  },
                  rowReorder: true,
                  quickFind: true,
                  search: true,
                  stripe: true,
                  labels: true,
                  nonWorkingTime: true,
                  pan: true,
                  headerZoom: true
                }
              });
              scheduler.resourceStore.add({
                id: Math.PI,
                name: 'before'
              });
              scheduler.assignmentStore.add([{
                id: Math.PI,
                eventId: Math.PI,
                resourceId: Math.PI
              }, {
                id: 1,
                eventId: 2,
                resourceId: Math.PI
              }]);
              scheduler.eventStore.add([{
                id: Math.PI,
                startDate: new Date(2020, 1, 1),
                duration: 1
              }, {
                id: 2,
                startDate: new Date(2020, 1, 11),
                duration: 2
              }]);
              scheduler.dependencyStore.add({
                id: Math.PI,
                from: Math.PI,
                to: 2
              });
              scheduler.resourceStore.id = Math.PI;
              scheduler.eventStore.id = Math.PI;
              scheduler.dependencyStore.id = Math.PI;
              scheduler.assignmentStore.id = Math.PI;
              scheduler.project.id = Math.PI; // Some interaction

              scheduler.selectedRecord = scheduler.resourceStore.first;
              scheduler.selectedEvents = scheduler.eventStore.records;
              _context3.next = 14;
              return t.moveCursorTo('.b-sch-event');

            case 14:
              _context3.next = 16;
              return t.waitForSelector('.b-sch-event-tooltip');

            case 16:
              _context3.next = 18;
              return t.dragBy({
                source: '.b-sch-event',
                delta: [100, 0],
                offset: ['100%-5', '50%']
              });

            case 18:
              _context3.next = 20;
              return t.doubleClick('.b-sch-event');

            case 20:
              _context3.next = 22;
              return t.dragBy({
                source: '.b-sch-timeaxis-cell',
                delta: [100, 0],
                offset: [5, 10]
              });

            case 22:
              _context3.next = 24;
              return t.click('.b-popup-close');

            case 24:
              // Replace project, no references to initial project should remain
              scheduler.project = {
                listeners: {
                  thisObj: scheduler
                },
                calendarManagerStore: {
                  data: [{
                    id: 1
                  }]
                },
                assignmentStore: {
                  data: [{
                    id: 1,
                    eventId: 1,
                    resourceId: 1
                  }, {
                    id: 2,
                    eventId: 2,
                    resourceId: 1
                  }]
                },
                resourceStore: {
                  data: [{
                    id: 1,
                    name: 'foo'
                  }]
                },
                eventStore: {
                  data: [{
                    id: 1,
                    startDate: new Date(2020, 1, 1),
                    duration: 1
                  }, {
                    id: 2,
                    startDate: new Date(2020, 1, 11),
                    duration: 2
                  }]
                },
                dependencyStore: {
                  data: [{
                    id: 1,
                    from: 1,
                    to: 2
                  }]
                }
              };
              Object.assign(scheduler, {
                timeRanges: {
                  data: [{
                    id: 1,
                    startDate: new Date(2020, 1, 1),
                    endDate: new Date(2020, 1, 2)
                  }]
                },
                resourceTimeRanges: {
                  data: [{
                    id: 1,
                    resourceId: 1,
                    startDate: new Date(2020, 1, 1),
                    endDate: new Date(2020, 1, 2)
                  }]
                }
              });
              drawCount = 0;
              scheduler.features.dependencies.draw(); // Force a few dependency redraws to have it flush its old state me.oldDrawnDependencies and me.drawnDependencies

              scheduler.on('dependenciesDrawn', function () {
                drawCount++;

                if (drawCount === 1) {
                  scheduler.features.dependencies.draw();
                }
              });
              _context3.next = 31;
              return t.waitFor(function () {
                return drawCount >= 2;
              });

            case 31:
              // Look for references to old project / stores in Scheduler
              t.findValue(scheduler, Math.PI, 'Scheduler'); // Look for references to old project / stores in all class symbols

              for (cls in Bundle) {
                t.findValue(Bundle[cls], Math.PI, cls.$$name);
              }

              if (!t.isFailed()) {
                t.pass('No leaks detected');
              }

            case 34:
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
  t.it('Should not retain references to old records after reloading store / crudManager', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var cls;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              t.mockUrl('read', {
                responseText: JSON.stringify({
                  success: true,
                  assignments: {
                    rows: [{
                      id: Math.PI,
                      eventId: Math.PI,
                      resourceId: Math.PI
                    }, {
                      id: 2,
                      eventId: 2,
                      resourceId: Math.PI
                    }]
                  },
                  resources: {
                    rows: [{
                      id: Math.PI,
                      name: 'foo'
                    }]
                  },
                  events: {
                    rows: [{
                      id: Math.PI,
                      startDate: new Date(2020, 1, 1),
                      duration: Math.PI
                    }, {
                      id: 2,
                      startDate: new Date(2020, 1, 1),
                      duration: 2
                    }]
                  },
                  dependencies: {
                    rows: [{
                      id: Math.PI,
                      from: Math.PI,
                      to: 2
                    }]
                  }
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2020, 1, 1),
                endDate: new Date(2020, 2, 1),
                columns: [{
                  field: 'name',
                  type: 'tree'
                }],
                crudManager: {
                  transport: {
                    load: {
                      url: 'read'
                    }
                  }
                }
              }); // Reload project, no references to initial project should remain

              _context4.next = 4;
              return scheduler.crudManager.load();

            case 4:
              scheduler.selectedRecord = scheduler.resourceStore.first;
              scheduler.selectedEvents = scheduler.eventStore.records;
              _context4.next = 8;
              return t.moveCursorTo('.b-sch-event');

            case 8:
              _context4.next = 10;
              return t.waitForSelector('.b-sch-event-tooltip');

            case 10:
              _context4.next = 12;
              return t.click('.b-grid-cell');

            case 12:
              t.mockUrl('read', {
                responseText: JSON.stringify({
                  success: true,
                  assignments: {
                    rows: []
                  },
                  resources: {
                    rows: []
                  },
                  events: {
                    rows: []
                  },
                  dependencies: {
                    rows: []
                  }
                })
              });
              _context4.next = 15;
              return scheduler.crudManager.load();

            case 15:
              // Look for references to old project / stores in Scheduler
              t.findValue(scheduler, Math.PI, 'Scheduler'); // Look for references to old project / stores in all class symbols

              for (cls in Bundle) {
                t.findValue(Bundle[cls], Math.PI, cls.$$name);
              }

              if (!t.isFailed()) {
                t.pass('No leaks detected');
              }

            case 18:
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
  t.it('Should destroy class instances created by Scheduler (THIS t.it SHOULD RUN LAST)', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                project: {
                  calendarManagerStore: {
                    data: [{}]
                  },
                  assignmentStore: {
                    data: [{}]
                  },
                  resourceStore: {
                    data: [{}]
                  },
                  eventStore: {
                    data: [{}]
                  },
                  dependencyStore: {
                    data: [{}]
                  }
                },
                columns: [{}],
                destroyStores: true,
                features: {
                  timeRanges: true,
                  resourceTimeRanges: true
                }
              });
              _context5.next = 3;
              return scheduler.project.commitAsync();

            case 3:
              // destroy shared tooltip
              Scheduler.tooltip.destroy();
              scheduler.destroy();
              PresetManager.destroy();
              instances.forEach(function (instance) {
                if (!instance.isDestroyed && !instance.isModel && instance.doDestroy !== Base.prototype.doDestroy && instance.$$name !== 'Ripple') {
                  // console.log(instance.__count, instance.$$name);
                  t.fail(instance.$$name + ' not destroyed');
                }
              });

              if (!t.isFailed()) {
                t.pass('No leaks detected');
              }

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
});