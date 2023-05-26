function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    if (scheduler) {
      scheduler.destroy();
      scheduler = null;
    }
  });

  function getScheduler() {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12() {
      var config,
          _args12 = arguments;
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              config = _args12.length > 0 && _args12[0] !== undefined ? _args12[0] : {};
              _context12.next = 3;
              return t.getSchedulerAsync(Object.assign({
                startDate: '2011-01-03',
                endDate: '2011-01-09',
                features: {
                  dependencies: true
                },
                columns: [],
                events: [{
                  id: 1,
                  name: 'Event 1',
                  startDate: '2011-01-04',
                  duration: 2
                }, {
                  id: 2,
                  name: 'Event 2',
                  startDate: '2011-01-05 23:00:00',
                  duration: 2
                }, {
                  id: 3,
                  name: 'Event 3',
                  startDate: '2011-01-04',
                  duration: 2
                }, {
                  id: 4,
                  name: 'Event 4',
                  startDate: '2011-01-05',
                  duration: 2
                }],
                assignments: [{
                  id: 1,
                  event: 1,
                  resource: 'r2'
                }, {
                  id: 2,
                  event: 2,
                  resource: 'r2'
                }, {
                  id: 3,
                  event: 3,
                  resource: 'r4'
                }, {
                  id: 4,
                  event: 4,
                  resource: 'r4'
                }, {
                  id: 5,
                  event: 1,
                  resource: 'r6'
                }],
                dependencies: [{
                  id: 1,
                  from: 1,
                  to: 4
                }]
              }, config));

            case 3:
              return _context12.abrupt("return", _context12.sent);

            case 4:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('Scheduler should draw dependencies loaded via CRUD-manager', function (t) {
    var depsDrawn = 0;
    scheduler = new Scheduler({
      appendTo: document.body,
      width: 615,
      height: 400,
      columns: [{
        field: 'name',
        text: 'Name'
      }],
      features: {
        dependencies: true
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
      endDate: new Date(2017, 11, 3),
      crudManager: {
        autoLoad: true,
        transport: {
          load: {
            url: 'dependencies/data/227_dependency_drawing_3.json'
          }
        }
      },
      listeners: {
        dependenciesDrawn: function dependenciesDrawn() {
          depsDrawn++;
        }
      }
    });
    t.chain({
      waitForEventsToRender: null
    }, {
      waitFor: function waitFor() {
        return depsDrawn > 0;
      }
    }, {
      waitForSelector: '.b-sch-dependency'
    });
  });
  t.it('Should clear dependency from cache when assignment is removed (w/o CrudManager)', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                events: [{
                  id: 1,
                  startDate: '2011-01-04',
                  endDate: '2011-01-05',
                  name: 'Multi assigned A'
                }, {
                  id: 2,
                  startDate: '2011-01-06',
                  endDate: '2011-01-07',
                  name: 'Multi assigned B'
                }],
                assignments: [{
                  id: 1,
                  resourceId: 'r1',
                  eventId: 1
                }, {
                  id: 2,
                  resourceId: 'r3',
                  eventId: 1
                }, {
                  id: 3,
                  resourceId: 'r5',
                  eventId: 1
                }, {
                  id: 4,
                  resourceId: 'r2',
                  eventId: 2
                }, {
                  id: 5,
                  resourceId: 'r4',
                  eventId: 2
                }],
                dependencies: [{
                  id: 1,
                  from: 1,
                  to: 2
                }]
              });

            case 2:
              scheduler = _context.sent;
              _context.next = 5;
              return t.waitForSelector('.b-sch-dependency');

            case 5:
              scheduler.assignments[0].remove();
              scheduler.features.dependencies.scheduleDraw();
              _context.next = 9;
              return scheduler.await('dependenciesdrawn');

            case 9:
              t.selectorCountIs('.b-sch-dependency', 4, 'Correct amount of dependency lines drawn');

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
  t.it('Should clear dependency from cache when assignment is removed (w/ CrudManager)', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  resources: {
                    rows: [{
                      id: 'r1',
                      name: 'Resource 1'
                    }, {
                      id: 'r2',
                      name: 'Resource 2'
                    }, {
                      id: 'r3',
                      name: 'Resource 3'
                    }, {
                      id: 'r4',
                      name: 'Resource 4'
                    }, {
                      id: 'r5',
                      name: 'Resource 5'
                    }]
                  },
                  events: {
                    rows: [{
                      id: 1,
                      startDate: '2011-01-04',
                      endDate: '2011-01-05',
                      name: 'Multi assigned A'
                    }, {
                      id: 2,
                      startDate: '2011-01-06',
                      endDate: '2011-01-07',
                      name: 'Multi assigned B'
                    }]
                  },
                  assignments: {
                    rows: [{
                      id: 1,
                      resourceId: 'r1',
                      eventId: 1
                    }, {
                      id: 2,
                      resourceId: 'r3',
                      eventId: 1
                    }, {
                      id: 3,
                      resourceId: 'r5',
                      eventId: 1
                    }, {
                      id: 4,
                      resourceId: 'r2',
                      eventId: 2
                    }, {
                      id: 5,
                      resourceId: 'r4',
                      eventId: 2
                    }]
                  },
                  dependencies: {
                    rows: [{
                      id: 1,
                      from: 1,
                      to: 2
                    }]
                  }
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                width: 600,
                height: 400,
                startDate: '2011-01-02',
                endDate: '2011-01-07',
                features: {
                  dependencies: true
                },
                crudManager: {
                  autoLoad: true,
                  transport: {
                    load: {
                      url: 'load'
                    }
                  }
                }
              });
              _context2.next = 4;
              return t.waitForProjectReady(scheduler);

            case 4:
              _context2.next = 6;
              return t.waitForSelector('.b-sch-dependency');

            case 6:
              scheduler.assignments[0].remove();
              scheduler.features.dependencies.scheduleDraw();
              _context2.next = 10;
              return scheduler.await('dependenciesdrawn');

            case 10:
              t.selectorCountIs('.b-sch-dependency', 4, 'Correct amount of dependency lines drawn');

            case 11:
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
  t.it('Should align dependency line with row boundary during dragdrop', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context8.sent;
              t.chain({
                waitForSelector: '.b-sch-dependency'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        t.assertHorizontalBreakOnRowBorder(scheduler, {
                          dependencyId: 1,
                          rowId: 'r2',
                          assignmentData: {
                            from: {
                              id: 1
                            },
                            to: {
                              id: 4
                            }
                          }
                        });
                        t.assertHorizontalBreakOnRowBorder(scheduler, {
                          dependencyId: 1,
                          rowId: 'r5',
                          assignmentData: {
                            from: {
                              id: 5
                            },
                            to: {
                              id: 4
                            }
                          }
                        });

                      case 2:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3);
              })), {
                drag: '[data-assignment-id="1"]',
                by: [-100, 0],
                dragOnly: true,
                desc: 'Drag event in a same row'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
                return regeneratorRuntime.wrap(function _callee4$(_context4) {
                  while (1) {
                    switch (_context4.prev = _context4.next) {
                      case 0:
                        t.assertHorizontalBreakOnRowBorder(scheduler, {
                          dependencyId: 1,
                          rowId: 'r2',
                          assignmentData: {
                            from: {
                              id: 1
                            },
                            to: {
                              id: 4
                            }
                          }
                        });

                      case 1:
                      case "end":
                        return _context4.stop();
                    }
                  }
                }, _callee4);
              })), {
                moveMouseBy: [0, 80],
                desc: 'Drag event to new row'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
                return regeneratorRuntime.wrap(function _callee5$(_context5) {
                  while (1) {
                    switch (_context5.prev = _context5.next) {
                      case 0:
                        t.assertHorizontalBreakOnRowBorder(scheduler, {
                          dependencyId: 1,
                          rowId: 'r3',
                          assignmentData: {
                            from: {
                              id: 1
                            },
                            to: {
                              id: 4
                            }
                          }
                        });

                      case 1:
                      case "end":
                        return _context5.stop();
                    }
                  }
                }, _callee5);
              })), {
                moveMouseBy: [-80, 0],
                desc: 'Drag event to the left, it should not have extra segments'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6() {
                return regeneratorRuntime.wrap(function _callee6$(_context6) {
                  while (1) {
                    switch (_context6.prev = _context6.next) {
                      case 0:
                        t.assertHorizontalBreakOnRowBorder(scheduler, {
                          dependencyId: 1,
                          rowId: 'r3',
                          assignmentData: {
                            from: {
                              id: 1
                            },
                            to: {
                              id: 4
                            }
                          }
                        });

                      case 1:
                      case "end":
                        return _context6.stop();
                    }
                  }
                }, _callee6);
              })), {
                mouseUp: null
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                return regeneratorRuntime.wrap(function _callee7$(_context7) {
                  while (1) {
                    switch (_context7.prev = _context7.next) {
                      case 0:
                        t.assertHorizontalBreakOnRowBorder(scheduler, {
                          dependencyId: 1,
                          rowId: 'r3',
                          assignmentData: {
                            from: {
                              id: 1
                            },
                            to: {
                              id: 4
                            }
                          }
                        });

                      case 1:
                      case "end":
                        return _context7.stop();
                    }
                  }
                }, _callee7);
              })));

            case 4:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should draw line correctly on row height change', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      var assertDependencies, _assertDependencies;

      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _assertDependencies = function _assertDependencies3() {
                _assertDependencies = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10() {
                  return regeneratorRuntime.wrap(function _callee10$(_context10) {
                    while (1) {
                      switch (_context10.prev = _context10.next) {
                        case 0:
                          t.assertHorizontalBreakOnRowBorder(scheduler, {
                            dependencyId: 1,
                            rowId: 'r2',
                            assignmentData: {
                              from: {
                                id: 1
                              },
                              to: {
                                id: 4
                              }
                            }
                          });
                          t.assertHorizontalBreakOnRowBorder(scheduler, {
                            dependencyId: 1,
                            rowId: 'r5',
                            assignmentData: {
                              from: {
                                id: 5
                              },
                              to: {
                                id: 4
                              }
                            }
                          });

                        case 2:
                        case "end":
                          return _context10.stop();
                      }
                    }
                  }, _callee10);
                }));
                return _assertDependencies.apply(this, arguments);
              };

              assertDependencies = function _assertDependencies2() {
                return _assertDependencies.apply(this, arguments);
              };

              _context11.next = 4;
              return getScheduler();

            case 4:
              scheduler = _context11.sent;
              t.chain({
                waitForSelector: '.b-sch-dependency'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9() {
                return regeneratorRuntime.wrap(function _callee9$(_context9) {
                  while (1) {
                    switch (_context9.prev = _context9.next) {
                      case 0:
                        _context9.next = 2;
                        return assertDependencies();

                      case 2:
                        scheduler.rowHeight += 20;
                        _context9.next = 5;
                        return scheduler.await('dependenciesdrawn');

                      case 5:
                        _context9.next = 7;
                        return assertDependencies();

                      case 7:
                        scheduler.rowHeight -= 35;
                        _context9.next = 10;
                        return scheduler.await('dependenciesdrawn');

                      case 10:
                        _context9.next = 12;
                        return assertDependencies();

                      case 12:
                      case "end":
                        return _context9.stop();
                    }
                  }
                }, _callee9);
              })));

            case 6:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x4) {
      return _ref9.apply(this, arguments);
    };
  }());
});