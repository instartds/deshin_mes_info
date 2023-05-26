function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  //region Data
  var eventsData = [{
    id: 1,
    name: 'Event 1',
    startDate: new Date(2020, 0, 17),
    duration: 2,
    durationUnit: 'd'
  }, {
    id: 2,
    name: 'Event 2',
    startDate: new Date(2020, 0, 18),
    duration: 2,
    durationUnit: 'd'
  }, {
    id: 3,
    name: 'Event 3',
    startDate: new Date(2020, 0, 19),
    endDate: new Date(2020, 0, 22)
  }],
      singleEventsData = [{
    id: 1,
    resourceId: 1,
    name: 'Event 1',
    startDate: new Date(2020, 0, 17),
    duration: 2,
    durationUnit: 'd'
  }, {
    id: 2,
    resourceId: 2,
    name: 'Event 2',
    startDate: new Date(2020, 0, 18),
    duration: 2,
    durationUnit: 'd'
  }, {
    id: 3,
    resourceId: 2,
    name: 'Event 3',
    startDate: new Date(2020, 0, 19),
    duration: 3,
    durationUnit: 'd'
  }],
      resourcesData = [{
    id: 1,
    name: 'Resource 1'
  }, {
    id: 2,
    name: 'Resource 2'
  }],
      assignmentsData = [{
    id: 1,
    eventId: 1,
    resourceId: 1
  }, {
    id: 2,
    eventId: 1,
    resourceId: 2
  }, {
    id: 3,
    eventId: 2,
    resourceId: 2
  }],
      newEventsData = [{
    id: 4,
    name: 'New event 4',
    startDate: new Date(2020, 0, 17),
    duration: 2,
    durationUnit: 'd'
  }],
      newAssignmentsData = [{
    id: 1,
    eventId: 4,
    resourceId: 1
  }]; //endregion
  //region Setup

  var scheduler, scheduler2;
  t.beforeEach(function (t) {
    Scheduler.destroy(scheduler, scheduler2);
    scheduler = scheduler2 = null;
  });

  function assertScheduler(t) {
    var assertContent = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : true;
    var _scheduler = scheduler,
        project = _scheduler.project,
        eventStore = _scheduler.eventStore,
        assignmentStore = _scheduler.assignmentStore,
        resourceStore = _scheduler.resourceStore;
    t.diag('Data layer');
    t.ok(project instanceof ProjectModel, 'Scheduler has project');
    t.ok(assignmentStore instanceof AssignmentStore, 'Scheduler has AssignmentStore');
    t.ok(eventStore instanceof EventStore, 'Scheduler has EventStore');
    t.ok(resourceStore instanceof ResourceStore, 'Scheduler has ResourceStore');
    t.is(assignmentStore, project.assignmentStore, 'AssignmentStore supplied by project');
    t.is(eventStore, project.eventStore, 'EventStore supplied by project');
    t.is(resourceStore, project.resourceStore, 'ResourceStore supplied by project');

    if (assertContent) {
      t.is(assignmentStore.count, 3, 'Assignments loaded');
      t.is(eventStore.count, 3, 'Events loaded');
      t.is(resourceStore.count, 2, 'Resources loaded');
      t.is(eventStore.first.endDate, new Date(2020, 0, 19), 'Engine calculated endDate');
      t.is(eventStore.first.data.endDate, new Date(2020, 0, 19), 'endDate written back to record');
      t.is(eventStore.last.duration, 3, 'Engine calculated duration');
      t.is(eventStore.last.data.duration, 3, 'duration written back to record');
      t.diag('Rendering');
      t.selectorCountIs(scheduler.unreleasedEventSelector, 3, 'Events rendered');
    }
  }

  function createScheduler() {
    var config = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
    return new Scheduler(Object.assign({
      appendTo: document.body,
      useInitialAnimation: false,
      enableEventAnimations: false,
      startDate: new Date(2020, 0, 17)
    }, config));
  }

  function setupScheduler(_x) {
    return _setupScheduler.apply(this, arguments);
  } //endregion


  function _setupScheduler() {
    _setupScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee46(t) {
      var config,
          assert,
          _args46 = arguments;
      return regeneratorRuntime.wrap(function _callee46$(_context46) {
        while (1) {
          switch (_context46.prev = _context46.next) {
            case 0:
              config = _args46.length > 1 && _args46[1] !== undefined ? _args46[1] : {};
              assert = _args46.length > 2 && _args46[2] !== undefined ? _args46[2] : true;
              scheduler = createScheduler(config); // await initial propagation here when it is used

              if (!Object.keys(config).length) {
                _context46.next = 6;
                break;
              }

              _context46.next = 6;
              return t.waitForProjectReady(scheduler);

            case 6:
              if (assert) {
                assertScheduler(t, Object.keys(config).length);
              }

            case 7:
            case "end":
              return _context46.stop();
          }
        }
      }, _callee46);
    }));
    return _setupScheduler.apply(this, arguments);
  }

  t.it('Empty scheduler should have a project + stores', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return setupScheduler(t);

            case 2:
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
  t.it('Scheduler should accept stores', function (t) {
    t.it('Multi assignment', function (t) {
      t.it('With store configs', /*#__PURE__*/function () {
        var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
          return regeneratorRuntime.wrap(function _callee2$(_context2) {
            while (1) {
              switch (_context2.prev = _context2.next) {
                case 0:
                  _context2.next = 2;
                  return setupScheduler(t, {
                    eventStore: {
                      data: eventsData
                    },
                    resourceStore: {
                      data: resourcesData
                    },
                    assignmentStore: {
                      data: assignmentsData
                    }
                  });

                case 2:
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
      t.it('With store instances', /*#__PURE__*/function () {
        var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
          return regeneratorRuntime.wrap(function _callee3$(_context3) {
            while (1) {
              switch (_context3.prev = _context3.next) {
                case 0:
                  _context3.next = 2;
                  return setupScheduler(t, {
                    eventStore: new EventStore({
                      data: eventsData
                    }),
                    resourceStore: new ResourceStore({
                      data: resourcesData
                    }),
                    assignmentStore: new AssignmentStore({
                      data: assignmentsData
                    })
                  });

                case 2:
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
      t.it('With inline data', /*#__PURE__*/function () {
        var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
          return regeneratorRuntime.wrap(function _callee4$(_context4) {
            while (1) {
              switch (_context4.prev = _context4.next) {
                case 0:
                  _context4.next = 2;
                  return setupScheduler(t, {
                    events: eventsData,
                    resources: resourcesData,
                    assignments: assignmentsData
                  });

                case 2:
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
      t.it('With remote data', /*#__PURE__*/function () {
        var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
          return regeneratorRuntime.wrap(function _callee5$(_context5) {
            while (1) {
              switch (_context5.prev = _context5.next) {
                case 0:
                  t.mockUrl('events.json', {
                    responseText: JSON.stringify(eventsData)
                  });
                  t.mockUrl('resources.json', {
                    responseText: JSON.stringify(resourcesData)
                  });
                  t.mockUrl('assignments.json', {
                    responseText: JSON.stringify(assignmentsData)
                  });
                  _context5.next = 5;
                  return setupScheduler(t, {
                    eventStore: {
                      readUrl: 'events.json'
                    },
                    resourceStore: {
                      readUrl: 'resources.json'
                    },
                    assignmentStore: {
                      readUrl: 'assignments.json'
                    }
                  }, false);

                case 5:
                  scheduler.eventStore.load();
                  scheduler.resourceStore.load();
                  scheduler.assignmentStore.load();
                  _context5.next = 10;
                  return t.waitForSelector(scheduler.unreleasedEventSelector);

                case 10:
                  assertScheduler(t);

                case 11:
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
    });
    t.it('Single assignment', function (t) {
      t.it('With store configs', /*#__PURE__*/function () {
        var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
          return regeneratorRuntime.wrap(function _callee6$(_context6) {
            while (1) {
              switch (_context6.prev = _context6.next) {
                case 0:
                  _context6.next = 2;
                  return setupScheduler(t, {
                    eventStore: {
                      data: singleEventsData
                    },
                    resourceStore: {
                      data: resourcesData
                    }
                  });

                case 2:
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
      t.it('With store instances', /*#__PURE__*/function () {
        var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
          return regeneratorRuntime.wrap(function _callee7$(_context7) {
            while (1) {
              switch (_context7.prev = _context7.next) {
                case 0:
                  _context7.next = 2;
                  return setupScheduler(t, {
                    eventStore: new EventStore({
                      data: singleEventsData
                    }),
                    resourceStore: new ResourceStore({
                      data: resourcesData
                    })
                  });

                case 2:
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
      t.it('With inline data', /*#__PURE__*/function () {
        var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
          return regeneratorRuntime.wrap(function _callee8$(_context8) {
            while (1) {
              switch (_context8.prev = _context8.next) {
                case 0:
                  _context8.next = 2;
                  return setupScheduler(t, {
                    events: singleEventsData,
                    resources: resourcesData
                  });

                case 2:
                case "end":
                  return _context8.stop();
              }
            }
          }, _callee8);
        }));

        return function (_x9) {
          return _ref8.apply(this, arguments);
        };
      }());
      t.it('With remote data', /*#__PURE__*/function () {
        var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
          return regeneratorRuntime.wrap(function _callee10$(_context10) {
            while (1) {
              switch (_context10.prev = _context10.next) {
                case 0:
                  t.mockUrl('events.json', {
                    responseText: JSON.stringify(singleEventsData)
                  });
                  t.mockUrl('resources.json', {
                    responseText: JSON.stringify(resourcesData)
                  });
                  _context10.next = 4;
                  return setupScheduler(t, {
                    eventStore: {
                      readUrl: 'events.json'
                    },
                    resourceStore: {
                      readUrl: 'resources.json'
                    }
                  }, false);

                case 4:
                  scheduler.eventStore.load();
                  scheduler.resourceStore.load();
                  t.chain({
                    waitForSelector: scheduler.unreleasedEventSelector
                  }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9() {
                    return regeneratorRuntime.wrap(function _callee9$(_context9) {
                      while (1) {
                        switch (_context9.prev = _context9.next) {
                          case 0:
                            assertScheduler(t);

                          case 1:
                          case "end":
                            return _context9.stop();
                        }
                      }
                    }, _callee9);
                  })));

                case 7:
                case "end":
                  return _context10.stop();
              }
            }
          }, _callee10);
        }));

        return function (_x10) {
          return _ref9.apply(this, arguments);
        };
      }());
    });
  });
  t.it('Scheduler should accept project config', function (t) {
    t.it('Multi assignment', function (t) {
      t.it('With store configs', /*#__PURE__*/function () {
        var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
          return regeneratorRuntime.wrap(function _callee11$(_context11) {
            while (1) {
              switch (_context11.prev = _context11.next) {
                case 0:
                  _context11.next = 2;
                  return setupScheduler(t, {
                    project: {
                      eventStore: {
                        data: eventsData
                      },
                      resourceStore: {
                        data: resourcesData
                      },
                      assignmentStore: {
                        data: assignmentsData
                      }
                    }
                  });

                case 2:
                case "end":
                  return _context11.stop();
              }
            }
          }, _callee11);
        }));

        return function (_x11) {
          return _ref11.apply(this, arguments);
        };
      }());
      t.it('With store instances', /*#__PURE__*/function () {
        var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
          return regeneratorRuntime.wrap(function _callee12$(_context12) {
            while (1) {
              switch (_context12.prev = _context12.next) {
                case 0:
                  _context12.next = 2;
                  return setupScheduler(t, {
                    project: {
                      eventStore: new EventStore({
                        data: eventsData
                      }),
                      resourceStore: new ResourceStore({
                        data: resourcesData
                      }),
                      assignmentStore: new AssignmentStore({
                        data: assignmentsData
                      })
                    }
                  });

                case 2:
                case "end":
                  return _context12.stop();
              }
            }
          }, _callee12);
        }));

        return function (_x12) {
          return _ref12.apply(this, arguments);
        };
      }());
      t.it('With inline data', /*#__PURE__*/function () {
        var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
          return regeneratorRuntime.wrap(function _callee13$(_context13) {
            while (1) {
              switch (_context13.prev = _context13.next) {
                case 0:
                  _context13.next = 2;
                  return setupScheduler(t, {
                    project: {
                      eventsData: eventsData,
                      resourcesData: resourcesData,
                      assignmentsData: assignmentsData
                    }
                  });

                case 2:
                case "end":
                  return _context13.stop();
              }
            }
          }, _callee13);
        }));

        return function (_x13) {
          return _ref13.apply(this, arguments);
        };
      }());
    });
    t.it('Single assignment', function (t) {
      t.it('With store configs', /*#__PURE__*/function () {
        var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
          return regeneratorRuntime.wrap(function _callee14$(_context14) {
            while (1) {
              switch (_context14.prev = _context14.next) {
                case 0:
                  _context14.next = 2;
                  return setupScheduler(t, {
                    project: {
                      eventStore: {
                        data: singleEventsData
                      },
                      resourceStore: {
                        data: resourcesData
                      }
                    }
                  });

                case 2:
                case "end":
                  return _context14.stop();
              }
            }
          }, _callee14);
        }));

        return function (_x14) {
          return _ref14.apply(this, arguments);
        };
      }());
      t.it('With store instances', /*#__PURE__*/function () {
        var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
          return regeneratorRuntime.wrap(function _callee15$(_context15) {
            while (1) {
              switch (_context15.prev = _context15.next) {
                case 0:
                  _context15.next = 2;
                  return setupScheduler(t, {
                    project: {
                      eventStore: new EventStore({
                        data: singleEventsData
                      }),
                      resourceStore: new ResourceStore({
                        data: resourcesData
                      })
                    }
                  });

                case 2:
                case "end":
                  return _context15.stop();
              }
            }
          }, _callee15);
        }));

        return function (_x15) {
          return _ref15.apply(this, arguments);
        };
      }());
      t.it('With inline data', /*#__PURE__*/function () {
        var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
          return regeneratorRuntime.wrap(function _callee16$(_context16) {
            while (1) {
              switch (_context16.prev = _context16.next) {
                case 0:
                  _context16.next = 2;
                  return setupScheduler(t, {
                    project: {
                      eventsData: singleEventsData,
                      resourcesData: resourcesData
                    }
                  });

                case 2:
                case "end":
                  return _context16.stop();
              }
            }
          }, _callee16);
        }));

        return function (_x16) {
          return _ref16.apply(this, arguments);
        };
      }());
    });
  });
  t.it('Scheduler should accept project instance', function (t) {
    t.it('Multi assignment', function (t) {
      t.it('With store configs', /*#__PURE__*/function () {
        var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
          return regeneratorRuntime.wrap(function _callee17$(_context17) {
            while (1) {
              switch (_context17.prev = _context17.next) {
                case 0:
                  _context17.next = 2;
                  return setupScheduler(t, {
                    project: new ProjectModel({
                      eventStore: {
                        data: eventsData
                      },
                      resourceStore: {
                        data: resourcesData
                      },
                      assignmentStore: {
                        data: assignmentsData
                      }
                    })
                  });

                case 2:
                case "end":
                  return _context17.stop();
              }
            }
          }, _callee17);
        }));

        return function (_x17) {
          return _ref17.apply(this, arguments);
        };
      }());
      t.it('With store instances', /*#__PURE__*/function () {
        var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
          return regeneratorRuntime.wrap(function _callee18$(_context18) {
            while (1) {
              switch (_context18.prev = _context18.next) {
                case 0:
                  _context18.next = 2;
                  return setupScheduler(t, {
                    project: new ProjectModel({
                      eventStore: new EventStore({
                        data: eventsData
                      }),
                      resourceStore: new ResourceStore({
                        data: resourcesData
                      }),
                      assignmentStore: new AssignmentStore({
                        data: assignmentsData
                      })
                    })
                  });

                case 2:
                case "end":
                  return _context18.stop();
              }
            }
          }, _callee18);
        }));

        return function (_x18) {
          return _ref18.apply(this, arguments);
        };
      }());
      t.it('With inline data', /*#__PURE__*/function () {
        var _ref19 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t) {
          return regeneratorRuntime.wrap(function _callee19$(_context19) {
            while (1) {
              switch (_context19.prev = _context19.next) {
                case 0:
                  _context19.next = 2;
                  return setupScheduler(t, {
                    project: new ProjectModel({
                      eventsData: eventsData,
                      resourcesData: resourcesData,
                      assignmentsData: assignmentsData
                    })
                  });

                case 2:
                case "end":
                  return _context19.stop();
              }
            }
          }, _callee19);
        }));

        return function (_x19) {
          return _ref19.apply(this, arguments);
        };
      }());
    });
    t.it('Single assignment', function (t) {
      t.it('With store configs', /*#__PURE__*/function () {
        var _ref20 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(t) {
          return regeneratorRuntime.wrap(function _callee20$(_context20) {
            while (1) {
              switch (_context20.prev = _context20.next) {
                case 0:
                  _context20.next = 2;
                  return setupScheduler(t, {
                    project: new ProjectModel({
                      eventStore: {
                        data: singleEventsData
                      },
                      resourceStore: {
                        data: resourcesData
                      }
                    })
                  });

                case 2:
                case "end":
                  return _context20.stop();
              }
            }
          }, _callee20);
        }));

        return function (_x20) {
          return _ref20.apply(this, arguments);
        };
      }());
      t.it('With store instances', /*#__PURE__*/function () {
        var _ref21 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21(t) {
          return regeneratorRuntime.wrap(function _callee21$(_context21) {
            while (1) {
              switch (_context21.prev = _context21.next) {
                case 0:
                  _context21.next = 2;
                  return setupScheduler(t, {
                    project: new ProjectModel({
                      eventStore: new EventStore({
                        data: singleEventsData
                      }),
                      resourceStore: new ResourceStore({
                        data: resourcesData
                      })
                    })
                  });

                case 2:
                case "end":
                  return _context21.stop();
              }
            }
          }, _callee21);
        }));

        return function (_x21) {
          return _ref21.apply(this, arguments);
        };
      }());
      t.it('With inline data', /*#__PURE__*/function () {
        var _ref22 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
          return regeneratorRuntime.wrap(function _callee22$(_context22) {
            while (1) {
              switch (_context22.prev = _context22.next) {
                case 0:
                  _context22.next = 2;
                  return setupScheduler(t, {
                    project: new ProjectModel({
                      eventsData: singleEventsData,
                      resourcesData: resourcesData
                    })
                  });

                case 2:
                case "end":
                  return _context22.stop();
              }
            }
          }, _callee22);
        }));

        return function (_x22) {
          return _ref22.apply(this, arguments);
        };
      }());
    });
  });
  t.it('Should be able to replace project', /*#__PURE__*/function () {
    var _ref23 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23(t) {
      return regeneratorRuntime.wrap(function _callee23$(_context23) {
        while (1) {
          switch (_context23.prev = _context23.next) {
            case 0:
              _context23.next = 2;
              return setupScheduler(t, {
                project: {
                  eventsData: eventsData,
                  resourcesData: resourcesData,
                  assignmentsData: assignmentsData
                }
              }, false);

            case 2:
              scheduler.project = new ProjectModel({
                eventsData: newEventsData,
                resourcesData: [{
                  id: 1,
                  name: 'New resource 1'
                }],
                assignmentsData: newAssignmentsData
              });
              _context23.next = 5;
              return t.waitForProjectReady(scheduler);

            case 5:
              assertScheduler(t, false);
              t.is(scheduler.assignmentStore.count, 1, 'Assignments loaded');
              t.is(scheduler.eventStore.count, 1, 'Events loaded');
              t.is(scheduler.resourceStore.count, 1, 'Resources loaded');
              t.diag('Rendering');
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Event rendered');

            case 11:
            case "end":
              return _context23.stop();
          }
        }
      }, _callee23);
    }));

    return function (_x23) {
      return _ref23.apply(this, arguments);
    };
  }());
  t.it('Should be able to replace project stores', function (t) {
    t.it('Directly on project', /*#__PURE__*/function () {
      var _ref24 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee24(t) {
        return regeneratorRuntime.wrap(function _callee24$(_context24) {
          while (1) {
            switch (_context24.prev = _context24.next) {
              case 0:
                _context24.next = 2;
                return setupScheduler(t, {
                  project: {
                    eventsData: eventsData,
                    resourcesData: resourcesData,
                    assignmentsData: assignmentsData
                  }
                }, false);

              case 2:
                scheduler.project.setEventStore(new EventStore({
                  data: newEventsData
                }));
                _context24.next = 5;
                return t.waitForProjectReady(scheduler);

              case 5:
                t.selectorNotExists(scheduler.unreleasedEventSelector, 'No events rendered');
                scheduler.project.setAssignmentStore(new AssignmentStore({
                  data: newAssignmentsData
                }));
                _context24.next = 9;
                return t.waitForProjectReady(scheduler);

              case 9:
                t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Event rendered');
                scheduler.project.setResourceStore(new ResourceStore({
                  data: [{
                    id: 1
                  }]
                }));
                _context24.next = 13;
                return t.waitForProjectReady(scheduler);

              case 13:
                t.selectorCountIs('.b-grid-row', 1, 'Single resource rendered');
                t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Event still rendered');

              case 15:
              case "end":
                return _context24.stop();
            }
          }
        }, _callee24);
      }));

      return function (_x24) {
        return _ref24.apply(this, arguments);
      };
    }());
    t.it('Relayed from scheduler', /*#__PURE__*/function () {
      var _ref25 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee28(t) {
        return regeneratorRuntime.wrap(function _callee28$(_context28) {
          while (1) {
            switch (_context28.prev = _context28.next) {
              case 0:
                _context28.next = 2;
                return setupScheduler(t, {
                  events: eventsData,
                  resources: resourcesData,
                  assignments: assignmentsData
                }, false);

              case 2:
                scheduler.eventStore = new EventStore({
                  data: newEventsData
                });
                t.chain({
                  waitForSelectorNotFound: scheduler.unreleasedEventSelector,
                  desc: 'No events rendered'
                }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee25() {
                  return regeneratorRuntime.wrap(function _callee25$(_context25) {
                    while (1) {
                      switch (_context25.prev = _context25.next) {
                        case 0:
                          return _context25.abrupt("return", scheduler.assignmentStore = new AssignmentStore({
                            data: newAssignmentsData
                          }));

                        case 1:
                        case "end":
                          return _context25.stop();
                      }
                    }
                  }, _callee25);
                })), {
                  waitFor: function waitFor() {
                    return document.querySelectorAll(scheduler.unreleasedEventSelector).length === 1;
                  },
                  desc: 'Single event rendered'
                }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee26() {
                  return regeneratorRuntime.wrap(function _callee26$(_context26) {
                    while (1) {
                      switch (_context26.prev = _context26.next) {
                        case 0:
                          return _context26.abrupt("return", scheduler.resourceStore = new ResourceStore({
                            data: [{
                              id: 1
                            }]
                          }));

                        case 1:
                        case "end":
                          return _context26.stop();
                      }
                    }
                  }, _callee26);
                })), {
                  waitFor: function waitFor() {
                    return document.querySelectorAll('.b-grid-row').length === 1;
                  },
                  desc: 'Single resource rendered'
                }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee27() {
                  return regeneratorRuntime.wrap(function _callee27$(_context27) {
                    while (1) {
                      switch (_context27.prev = _context27.next) {
                        case 0:
                          return _context27.abrupt("return", t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Event still rendered'));

                        case 1:
                        case "end":
                          return _context27.stop();
                      }
                    }
                  }, _callee27);
                })));

              case 4:
              case "end":
                return _context28.stop();
            }
          }
        }, _callee28);
      }));

      return function (_x25) {
        return _ref25.apply(this, arguments);
      };
    }());
  });
  t.it('Schedulers should be able to share project', function (t) {
    t.it('Multi assignment', /*#__PURE__*/function () {
      var _ref29 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee29(t) {
        var project;
        return regeneratorRuntime.wrap(function _callee29$(_context29) {
          while (1) {
            switch (_context29.prev = _context29.next) {
              case 0:
                project = new ProjectModel({
                  eventsData: eventsData,
                  resourcesData: resourcesData,
                  assignmentsData: assignmentsData
                });
                _context29.next = 3;
                return setupScheduler(t, {
                  height: '50%',
                  project: project
                }, false);

              case 3:
                scheduler2 = new Scheduler({
                  appendTo: document.body,
                  height: '50%',
                  startDate: new Date(2020, 0, 17),
                  project: project
                });
                t.selectorCountIs("#".concat(scheduler.id, " ").concat(scheduler.unreleasedEventSelector), 3, 'Scheduler 1 events rendered');
                t.selectorCountIs("#".concat(scheduler2.id, " ").concat(scheduler.unreleasedEventSelector), 3, 'Scheduler 2 events rendered');

              case 6:
              case "end":
                return _context29.stop();
            }
          }
        }, _callee29);
      }));

      return function (_x26) {
        return _ref29.apply(this, arguments);
      };
    }());
    t.it('Single assignment', /*#__PURE__*/function () {
      var _ref30 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee30(t) {
        var project;
        return regeneratorRuntime.wrap(function _callee30$(_context30) {
          while (1) {
            switch (_context30.prev = _context30.next) {
              case 0:
                project = new ProjectModel({
                  eventsData: singleEventsData,
                  resourcesData: resourcesData
                });
                _context30.next = 3;
                return setupScheduler(t, {
                  height: '50%',
                  project: project
                }, false);

              case 3:
                scheduler2 = new Scheduler({
                  appendTo: document.body,
                  height: '50%',
                  startDate: new Date(2020, 0, 17),
                  project: project
                });
                t.selectorCountIs("#".concat(scheduler.id, " ").concat(scheduler.unreleasedEventSelector), 3, 'Scheduler 1 events rendered');
                t.selectorCountIs("#".concat(scheduler2.id, " ").concat(scheduler.unreleasedEventSelector), 3, 'Scheduler 2 events rendered');

              case 6:
              case "end":
                return _context30.stop();
            }
          }
        }, _callee30);
      }));

      return function (_x27) {
        return _ref30.apply(this, arguments);
      };
    }());
  });
  t.it('Schedulers should be able to share (all) stores', function (t) {
    t.it('Multi assignment', /*#__PURE__*/function () {
      var _ref31 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee31(t) {
        return regeneratorRuntime.wrap(function _callee31$(_context31) {
          while (1) {
            switch (_context31.prev = _context31.next) {
              case 0:
                _context31.next = 2;
                return setupScheduler(t, {
                  height: '50%',
                  events: eventsData,
                  resources: resourcesData,
                  assignments: assignmentsData
                }, false);

              case 2:
                scheduler2 = createScheduler({
                  height: '50%',
                  eventStore: scheduler.eventStore,
                  resourceStore: scheduler.resourceStore,
                  assignmentStore: scheduler.assignmentStore
                });
                t.is(scheduler.project, scheduler2.project, 'Project shared');
                t.selectorCountIs("#".concat(scheduler.id, " ").concat(scheduler.unreleasedEventSelector), 3, 'Scheduler 1 events rendered');
                t.selectorCountIs("#".concat(scheduler2.id, " ").concat(scheduler.unreleasedEventSelector), 3, 'Scheduler 2 events rendered');

              case 6:
              case "end":
                return _context31.stop();
            }
          }
        }, _callee31);
      }));

      return function (_x28) {
        return _ref31.apply(this, arguments);
      };
    }());
    t.it('Single assignment', /*#__PURE__*/function () {
      var _ref32 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee32(t) {
        return regeneratorRuntime.wrap(function _callee32$(_context32) {
          while (1) {
            switch (_context32.prev = _context32.next) {
              case 0:
                _context32.next = 2;
                return setupScheduler(t, {
                  height: '50%',
                  events: singleEventsData,
                  resources: resourcesData
                }, false);

              case 2:
                scheduler2 = createScheduler({
                  height: '50%',
                  eventStore: scheduler.eventStore,
                  resourceStore: scheduler.resourceStore
                });
                t.is(scheduler.project, scheduler2.project, 'Project shared');
                t.selectorCountIs("#".concat(scheduler.id, " ").concat(scheduler.unreleasedEventSelector), 3, 'Scheduler 1 events rendered');
                t.selectorCountIs("#".concat(scheduler2.id, " ").concat(scheduler.unreleasedEventSelector), 3, 'Scheduler 2 events rendered');

              case 6:
              case "end":
                return _context32.stop();
            }
          }
        }, _callee32);
      }));

      return function (_x29) {
        return _ref32.apply(this, arguments);
      };
    }());
  });
  t.it('Should be able to use CrudManager', function (t) {
    function assertCrudManager(_x30) {
      return _assertCrudManager.apply(this, arguments);
    }

    function _assertCrudManager() {
      _assertCrudManager = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee41(t) {
        var _scheduler2, crudManager;

        return regeneratorRuntime.wrap(function _callee41$(_context41) {
          while (1) {
            switch (_context41.prev = _context41.next) {
              case 0:
                _scheduler2 = scheduler, crudManager = _scheduler2.crudManager;
                _context41.next = 3;
                return crudManager.await('load');

              case 3:
                t.is(crudManager.eventStore, scheduler.eventStore, 'EventStores match ');
                t.is(crudManager.resourceStore, scheduler.resourceStore, 'ResourceStores match ');
                t.is(crudManager.assignmentStore, scheduler.assignmentStore, 'AssignmentStores match ');

              case 6:
              case "end":
                return _context41.stop();
            }
          }
        }, _callee41);
      }));
      return _assertCrudManager.apply(this, arguments);
    }

    t.it('Multi assignment', function (t) {
      t.mockUrl('multi.json', {
        delay: 10,
        responseText: JSON.stringify({
          success: true,
          resources: {
            rows: resourcesData
          },
          events: {
            rows: eventsData
          },
          assignments: {
            rows: assignmentsData
          }
        })
      });
      t.it('CrudManager config, autoLoad', /*#__PURE__*/function () {
        var _ref33 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee33(t) {
          return regeneratorRuntime.wrap(function _callee33$(_context33) {
            while (1) {
              switch (_context33.prev = _context33.next) {
                case 0:
                  _context33.next = 2;
                  return setupScheduler(t, {
                    crudManager: {
                      autoLoad: true,
                      transport: {
                        load: {
                          url: 'multi.json'
                        }
                      }
                    }
                  }, false);

                case 2:
                  _context33.next = 4;
                  return assertCrudManager(t);

                case 4:
                  t.chain({
                    waitForSelector: scheduler.unreleasedEventSelector
                  }, function () {
                    assertScheduler(t);
                  });

                case 5:
                case "end":
                  return _context33.stop();
              }
            }
          }, _callee33);
        }));

        return function (_x31) {
          return _ref33.apply(this, arguments);
        };
      }());
      t.it('CrudManager instance, autoLoad', /*#__PURE__*/function () {
        var _ref34 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee34(t) {
          return regeneratorRuntime.wrap(function _callee34$(_context34) {
            while (1) {
              switch (_context34.prev = _context34.next) {
                case 0:
                  _context34.next = 2;
                  return setupScheduler(t, {
                    crudManager: new CrudManager({
                      autoLoad: true,
                      transport: {
                        load: {
                          url: 'multi.json'
                        }
                      }
                    })
                  }, false);

                case 2:
                  _context34.next = 4;
                  return assertCrudManager(t);

                case 4:
                  t.chain({
                    waitForSelector: scheduler.unreleasedEventSelector
                  }, function () {
                    assertScheduler(t);
                  });

                case 5:
                case "end":
                  return _context34.stop();
              }
            }
          }, _callee34);
        }));

        return function (_x32) {
          return _ref34.apply(this, arguments);
        };
      }());
      t.it('CrudManager config, no autoLoad', /*#__PURE__*/function () {
        var _ref35 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee35(t) {
          return regeneratorRuntime.wrap(function _callee35$(_context35) {
            while (1) {
              switch (_context35.prev = _context35.next) {
                case 0:
                  _context35.next = 2;
                  return setupScheduler(t, {
                    crudManager: {
                      autoLoad: false,
                      transport: {
                        load: {
                          url: 'multi.json'
                        }
                      }
                    }
                  }, false);

                case 2:
                  scheduler.crudManager.load();
                  _context35.next = 5;
                  return assertCrudManager(t);

                case 5:
                  t.chain({
                    waitForSelector: scheduler.unreleasedEventSelector
                  }, function () {
                    assertScheduler(t);
                  });

                case 6:
                case "end":
                  return _context35.stop();
              }
            }
          }, _callee35);
        }));

        return function (_x33) {
          return _ref35.apply(this, arguments);
        };
      }());
      t.it('CrudManager instance, no autoLoad', /*#__PURE__*/function () {
        var _ref36 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee36(t) {
          return regeneratorRuntime.wrap(function _callee36$(_context36) {
            while (1) {
              switch (_context36.prev = _context36.next) {
                case 0:
                  _context36.next = 2;
                  return setupScheduler(t, {
                    crudManager: new CrudManager({
                      autoLoad: false,
                      transport: {
                        load: {
                          url: 'multi.json'
                        }
                      }
                    })
                  }, false);

                case 2:
                  scheduler.crudManager.load();
                  _context36.next = 5;
                  return assertCrudManager(t);

                case 5:
                  t.chain({
                    waitForSelector: scheduler.unreleasedEventSelector
                  }, function () {
                    assertScheduler(t);
                  });

                case 6:
                case "end":
                  return _context36.stop();
              }
            }
          }, _callee36);
        }));

        return function (_x34) {
          return _ref36.apply(this, arguments);
        };
      }());
      t.it('CrudManager config, with store configs', /*#__PURE__*/function () {
        var _ref37 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee37(t) {
          return regeneratorRuntime.wrap(function _callee37$(_context37) {
            while (1) {
              switch (_context37.prev = _context37.next) {
                case 0:
                  _context37.next = 2;
                  return setupScheduler(t, {
                    crudManager: {
                      autoLoad: true,
                      transport: {
                        load: {
                          url: 'multi.json'
                        }
                      },
                      eventStore: {
                        fields: ['extraE']
                      },
                      resourceStore: {
                        fields: ['extraR']
                      },
                      assignmentStore: {
                        fields: ['extraA']
                      }
                    }
                  }, false);

                case 2:
                  _context37.next = 4;
                  return assertCrudManager(t);

                case 4:
                  t.chain({
                    waitForSelector: scheduler.unreleasedEventSelector
                  }, function () {
                    assertScheduler(t);
                    t.ok(scheduler.eventStore.first.getFieldDefinition('extraE'), 'EventStore config applied');
                    t.ok(scheduler.resourceStore.first.getFieldDefinition('extraR'), 'ResourceStore config applied');
                    t.ok(scheduler.assignmentStore.first.getFieldDefinition('extraA'), 'AssignmentStore config applied');
                  });

                case 5:
                case "end":
                  return _context37.stop();
              }
            }
          }, _callee37);
        }));

        return function (_x35) {
          return _ref37.apply(this, arguments);
        };
      }());
      t.it('CrudManager instance, already loaded', /*#__PURE__*/function () {
        var _ref38 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee38(t) {
          var crudManager;
          return regeneratorRuntime.wrap(function _callee38$(_context38) {
            while (1) {
              switch (_context38.prev = _context38.next) {
                case 0:
                  crudManager = new CrudManager({
                    autoLoad: true,
                    transport: {
                      load: {
                        url: 'multi.json'
                      }
                    }
                  });
                  _context38.next = 3;
                  return crudManager.await('load');

                case 3:
                  _context38.next = 5;
                  return setupScheduler(t, {
                    crudManager: crudManager
                  }, true);

                case 5:
                case "end":
                  return _context38.stop();
              }
            }
          }, _callee38);
        }));

        return function (_x36) {
          return _ref38.apply(this, arguments);
        };
      }());
    });
    t.it('Single assignment', function (t) {
      t.mockUrl('single.json', {
        responseText: JSON.stringify({
          success: true,
          resources: {
            rows: resourcesData
          },
          events: {
            rows: singleEventsData
          }
        })
      });
      t.it('CrudManager config', /*#__PURE__*/function () {
        var _ref39 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee39(t) {
          return regeneratorRuntime.wrap(function _callee39$(_context39) {
            while (1) {
              switch (_context39.prev = _context39.next) {
                case 0:
                  _context39.next = 2;
                  return setupScheduler(t, {
                    crudManager: {
                      autoLoad: true,
                      transport: {
                        load: {
                          url: 'single.json'
                        }
                      }
                    }
                  }, false);

                case 2:
                  _context39.next = 4;
                  return assertCrudManager(t);

                case 4:
                  t.chain({
                    waitForSelector: scheduler.unreleasedEventSelector
                  }, function () {
                    assertScheduler(t);
                  });

                case 5:
                case "end":
                  return _context39.stop();
              }
            }
          }, _callee39);
        }));

        return function (_x37) {
          return _ref39.apply(this, arguments);
        };
      }());
      t.it('CrudManager instance', /*#__PURE__*/function () {
        var _ref40 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee40(t) {
          return regeneratorRuntime.wrap(function _callee40$(_context40) {
            while (1) {
              switch (_context40.prev = _context40.next) {
                case 0:
                  _context40.next = 2;
                  return setupScheduler(t, {
                    crudManager: new CrudManager({
                      autoLoad: true,
                      transport: {
                        load: {
                          url: 'single.json'
                        }
                      }
                    })
                  }, false);

                case 2:
                  _context40.next = 4;
                  return assertCrudManager(t);

                case 4:
                  t.chain({
                    waitForSelector: scheduler.unreleasedEventSelector
                  }, function () {
                    assertScheduler(t);
                  });

                case 5:
                case "end":
                  return _context40.stop();
              }
            }
          }, _callee40);
        }));

        return function (_x38) {
          return _ref40.apply(this, arguments);
        };
      }());
    });
  });
  t.it('Should be able to retrieve and consume JSON', /*#__PURE__*/function () {
    var _ref41 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee42(t) {
      var dependenciesData, project, json;
      return regeneratorRuntime.wrap(function _callee42$(_context42) {
        while (1) {
          switch (_context42.prev = _context42.next) {
            case 0:
              dependenciesData = [{
                id: 1,
                from: 1,
                to: 2
              }];
              project = new ProjectModel({
                eventsData: eventsData,
                assignmentsData: assignmentsData,
                resourcesData: resourcesData,
                dependenciesData: dependenciesData
              });
              _context42.next = 4;
              return project.commitAsync();

            case 4:
              json = project.json;
              _context42.next = 7;
              return project.loadInlineData({
                eventsData: [],
                assignmentsData: [],
                resourcesData: [],
                dependenciesData: []
              });

            case 7:
              project.json = json;
              _context42.next = 10;
              return project.commitAsync();

            case 10:
              t.is(project.eventStore.count, eventsData.length, 'Correct event count');
              t.is(project.assignmentStore.count, assignmentsData.length, 'Correct assignment count');
              t.is(project.resourceStore.count, resourcesData.length, 'Correct resource count');
              t.is(project.dependencyStore.count, dependenciesData.length, 'Correct dependency count');

            case 14:
            case "end":
              return _context42.stop();
          }
        }
      }, _callee42);
    }));

    return function (_x39) {
      return _ref41.apply(this, arguments);
    };
  }());
  t.it('Should consume JSON from config', /*#__PURE__*/function () {
    var _ref42 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee43(t) {
      var project;
      return regeneratorRuntime.wrap(function _callee43$(_context43) {
        while (1) {
          switch (_context43.prev = _context43.next) {
            case 0:
              project = new ProjectModel({
                json: "{\n                \"eventsData\" : [\n                    { \"id\" : 1, \"name\" : \"Event 1\" }\n                ],\n                \"resourcesData\" : [\n                    { \"id\" : 1, \"name\" : \"Resource 1\" }\n                ],\n                \"assignmentsData\" : [\n                    { \"id\" : 1, \"event\" : 1, \"resource\" : 1 }\n                ]\n            }"
              });
              _context43.next = 3;
              return project.commitAsync();

            case 3:
              t.is(project.eventStore.count, 1, 'Correct event count');
              t.is(project.resourceStore.count, 1, 'Correct resource count');
              t.is(project.assignmentStore.count, 1, 'Correct assignment count');
              t.is(project.eventStore.first.resource, project.resourceStore.first, 'Data linked up');

            case 7:
            case "end":
              return _context43.stop();
          }
        }
      }, _callee43);
    }));

    return function (_x40) {
      return _ref42.apply(this, arguments);
    };
  }());
  t.it('Should use correct EventStore class', function (t) {
    var MyEventStore = /*#__PURE__*/function (_EventStore) {
      _inherits(MyEventStore, _EventStore);

      var _super = _createSuper(MyEventStore);

      function MyEventStore() {
        _classCallCheck(this, MyEventStore);

        return _super.apply(this, arguments);
      }

      return MyEventStore;
    }(EventStore);

    t.it('Configured on project', function (t) {
      var project = new ProjectModel({
        eventStoreClass: MyEventStore
      });
      t.ok(project.eventStore instanceof MyEventStore, 'Correct storeClass used');
    });
    t.it('Configured on project as eventStore', function (t) {
      var project = new ProjectModel({
        eventStore: {
          storeClass: MyEventStore
        }
      });
      t.ok(project.eventStore instanceof MyEventStore, 'Correct storeClass used');
    });
    t.it('Subclassed project', function (t) {
      var MyProject = /*#__PURE__*/function (_ProjectModel) {
        _inherits(MyProject, _ProjectModel);

        var _super2 = _createSuper(MyProject);

        function MyProject() {
          _classCallCheck(this, MyProject);

          return _super2.apply(this, arguments);
        }

        _createClass(MyProject, null, [{
          key: "defaultConfig",
          get: function get() {
            return {
              eventStoreClass: MyEventStore
            };
          }
        }]);

        return MyProject;
      }(ProjectModel);

      var project = new MyProject();
      t.ok(project.eventStore instanceof MyEventStore, 'Correct storeClass used');
    });
  });
  t.it('Should use correct EventModel class', function (t) {
    var MyEvent = /*#__PURE__*/function (_EventModel) {
      _inherits(MyEvent, _EventModel);

      var _super3 = _createSuper(MyEvent);

      function MyEvent() {
        _classCallCheck(this, MyEvent);

        return _super3.apply(this, arguments);
      }

      return MyEvent;
    }(EventModel);

    t.it('Configured on project', function (t) {
      var project = new ProjectModel({
        eventModelClass: MyEvent
      });
      t.is(Object.getPrototypeOf(project.eventStore.modelClass), MyEvent, 'Correct modelClass');
    });
    t.it('Configured on projects storeClass', function (t) {
      var MyEventStore = /*#__PURE__*/function (_EventStore2) {
        _inherits(MyEventStore, _EventStore2);

        var _super4 = _createSuper(MyEventStore);

        function MyEventStore() {
          _classCallCheck(this, MyEventStore);

          return _super4.apply(this, arguments);
        }

        _createClass(MyEventStore, null, [{
          key: "defaultConfig",
          get: function get() {
            return {
              modelClass: MyEvent
            };
          }
        }]);

        return MyEventStore;
      }(EventStore);

      var project = new ProjectModel({
        eventStoreClass: MyEventStore
      });
      t.is(Object.getPrototypeOf(project.eventStore.modelClass), MyEvent, 'Correct modelClass');
    });
    t.it('Configured on projects eventStore config', function (t) {
      var project = new ProjectModel({
        eventStore: {
          modelClass: MyEvent
        }
      });
      t.is(Object.getPrototypeOf(project.eventStore.modelClass), MyEvent, 'Correct modelClass');
    });
  });
  t.it('Should use correct ResourceModel class', function (t) {
    var MyResource = /*#__PURE__*/function (_ResourceModel) {
      _inherits(MyResource, _ResourceModel);

      var _super5 = _createSuper(MyResource);

      function MyResource() {
        _classCallCheck(this, MyResource);

        return _super5.apply(this, arguments);
      }

      return MyResource;
    }(ResourceModel);

    t.it('Configured on project', function (t) {
      var project = new ProjectModel({
        resourceModelClass: MyResource
      });
      t.is(Object.getPrototypeOf(project.resourceStore.modelClass), MyResource, 'Correct modelClass');
    });
    t.it('Configured on projects storeClass', function (t) {
      var MyResourceStore = /*#__PURE__*/function (_ResourceStore) {
        _inherits(MyResourceStore, _ResourceStore);

        var _super6 = _createSuper(MyResourceStore);

        function MyResourceStore() {
          _classCallCheck(this, MyResourceStore);

          return _super6.apply(this, arguments);
        }

        _createClass(MyResourceStore, null, [{
          key: "defaultConfig",
          get: function get() {
            return {
              modelClass: MyResource
            };
          }
        }]);

        return MyResourceStore;
      }(ResourceStore);

      var project = new ProjectModel({
        resourceStoreClass: MyResourceStore
      });
      t.is(Object.getPrototypeOf(project.resourceStore.modelClass), MyResource, 'Correct modelClass');
    });
    t.it('Configured on projects resourceStore config', function (t) {
      var project = new ProjectModel({
        resourceStore: {
          modelClass: MyResource
        }
      });
      t.is(Object.getPrototypeOf(project.resourceStore.modelClass), MyResource, 'Correct modelClass');
    });
  });
  t.it('Should use correct AssignmentModel class', function (t) {
    var MyAssignment = /*#__PURE__*/function (_AssignmentModel) {
      _inherits(MyAssignment, _AssignmentModel);

      var _super7 = _createSuper(MyAssignment);

      function MyAssignment() {
        _classCallCheck(this, MyAssignment);

        return _super7.apply(this, arguments);
      }

      return MyAssignment;
    }(AssignmentModel);

    t.it('Configured on project', function (t) {
      var project = new ProjectModel({
        assignmentModelClass: MyAssignment
      });
      t.is(Object.getPrototypeOf(project.assignmentStore.modelClass), MyAssignment, 'Correct modelClass');
    });
    t.it('Configured on projects storeClass', function (t) {
      var MyAssignmentStore = /*#__PURE__*/function (_AssignmentStore) {
        _inherits(MyAssignmentStore, _AssignmentStore);

        var _super8 = _createSuper(MyAssignmentStore);

        function MyAssignmentStore() {
          _classCallCheck(this, MyAssignmentStore);

          return _super8.apply(this, arguments);
        }

        _createClass(MyAssignmentStore, null, [{
          key: "defaultConfig",
          get: function get() {
            return {
              modelClass: MyAssignment
            };
          }
        }]);

        return MyAssignmentStore;
      }(AssignmentStore);

      var project = new ProjectModel({
        assignmentStoreClass: MyAssignmentStore
      });
      t.is(Object.getPrototypeOf(project.assignmentStore.modelClass), MyAssignment, 'Correct modelClass');
    });
    t.it('Configured on projects assignmentStore config', function (t) {
      var project = new ProjectModel({
        assignmentStore: {
          modelClass: MyAssignment
        }
      });
      t.is(Object.getPrototypeOf(project.assignmentStore.modelClass), MyAssignment, 'Correct modelClass');
    });
  });
  t.it('Should be able to get/set inlineData on project', function (t) {
    scheduler = createScheduler();
    var testData = {
      resourcesData: [{
        id: 1,
        name: 'resource 1'
      }, {
        id: 2,
        name: 'resource 2'
      }, {
        id: 3,
        name: 'resource 3'
      }, {
        id: 4,
        name: 'resource 4'
      }, {
        id: 5,
        name: 'resource 5'
      }],
      eventsData: [{
        id: 1,
        name: 'event 1'
      }, {
        id: 2,
        name: 'event 2'
      }, {
        id: 3,
        name: 'event 3'
      }, {
        id: 4,
        name: 'event 4'
      }, {
        id: 5,
        name: 'event 5'
      }, {
        id: 6,
        name: 'event 6'
      }, {
        id: 7,
        name: 'event 7'
      }, {
        id: 8,
        name: 'event 8'
      }],
      assignmentsData: [{
        id: 1,
        eventId: 1,
        resourceId: 1
      }, {
        id: 2,
        eventId: 1,
        resourceId: 2
      }, {
        id: 3,
        eventId: 1,
        resourceId: 5
      }, {
        id: 4,
        eventId: 2,
        resourceId: 2
      }, {
        id: 5,
        eventId: 3,
        resourceId: 3
      }, {
        id: 6,
        eventId: 4,
        resourceId: 3
      }, {
        id: 7,
        eventId: 5,
        resourceId: 3
      }, {
        id: 8,
        eventId: 5,
        resourceId: 4
      }, {
        id: 9,
        eventId: 6,
        resourceId: 2
      }, {
        id: 10,
        eventId: 7,
        resourceId: 5
      }, {
        id: 11,
        eventId: 8,
        resourceId: 4
      }],
      dependenciesData: [{
        id: 1,
        from: 1,
        to: 5
      }, {
        id: 2,
        from: 2,
        to: 4
      }]
    }; // Populate the stores

    scheduler.project.inlineData = testData; // Get data back

    var inlineData = scheduler.project.inlineData; // Check data

    t.isDeeply(inlineData.eventsData.map(function (event) {
      return {
        id: event.id,
        name: event.name
      };
    }), testData.eventsData, 'Events OK');
    t.isDeeply(inlineData.resourcesData, testData.resourcesData, 'Resources OK');
    t.isDeeply(inlineData.assignmentsData.map(function (assignment) {
      return {
        id: assignment.id,
        eventId: assignment.eventId,
        event: assignment.eventId,
        resourceId: assignment.resourceId,
        resource: assignment.resourceId
      };
    }), testData.assignmentsData, 'Assignments OK');
    t.isDeeply(inlineData.dependenciesData.map(function (dependency) {
      return {
        id: dependency.id,
        from: dependency.from,
        fromEvent: dependency.from,
        to: dependency.to,
        toEvent: dependency.to
      };
    }), testData.dependenciesData, 'Dependencies OK');
  }); // https://github.com/bryntum/support/issues/2644

  t.it('Should support configuring `timeRangeStore` on Scheduler', /*#__PURE__*/function () {
    var _ref43 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee44(t) {
      var MyTimeRangeStore;
      return regeneratorRuntime.wrap(function _callee44$(_context44) {
        while (1) {
          switch (_context44.prev = _context44.next) {
            case 0:
              MyTimeRangeStore = /*#__PURE__*/function (_RecurringTimeSpansMi) {
                _inherits(MyTimeRangeStore, _RecurringTimeSpansMi);

                var _super9 = _createSuper(MyTimeRangeStore);

                function MyTimeRangeStore() {
                  _classCallCheck(this, MyTimeRangeStore);

                  return _super9.apply(this, arguments);
                }

                return MyTimeRangeStore;
              }(RecurringTimeSpansMixin(Store));

              _context44.next = 3;
              return setupScheduler(t, {
                timeRangeStore: new MyTimeRangeStore()
              }, false);

            case 3:
              t.isInstanceOf(scheduler.timeRangeStore, MyTimeRangeStore, 'Scheduler#timeRangeStore property correct');
              t.isInstanceOf(scheduler.project.timeRangeStore, MyTimeRangeStore, 'Project#timeRangeStore property correct');

            case 5:
            case "end":
              return _context44.stop();
          }
        }
      }, _callee44);
    }));

    return function (_x41) {
      return _ref43.apply(this, arguments);
    };
  }());
  t.it('Should not trigger batchedUpdate during calculations', /*#__PURE__*/function () {
    var _ref44 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee45(t) {
      var project;
      return regeneratorRuntime.wrap(function _callee45$(_context45) {
        while (1) {
          switch (_context45.prev = _context45.next) {
            case 0:
              project = new ProjectModel({
                eventsData: [{
                  id: 1,
                  name: 'Derp',
                  startDate: '2020-05-20',
                  endDate: '2020-05-21'
                }]
              });
              t.wontFire(project.eventStore, 'batchedUpdate');
              _context45.next = 4;
              return project.commitAsync();

            case 4:
              project.eventStore.first.duration = 100;
              _context45.next = 7;
              return project.commitAsync();

            case 7:
            case "end":
              return _context45.stop();
          }
        }
      }, _callee45);
    }));

    return function (_x42) {
      return _ref44.apply(this, arguments);
    };
  }());
});