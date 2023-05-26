function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    return scheduler && !scheduler.isDestroyed && scheduler.destroy();
  });

  function setupScheduler(_x) {
    return _setupScheduler.apply(this, arguments);
  }

  function _setupScheduler() {
    _setupScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee36(t) {
      var config,
          _args36 = arguments;
      return regeneratorRuntime.wrap(function _callee36$(_context36) {
        while (1) {
          switch (_context36.prev = _context36.next) {
            case 0:
              config = _args36.length > 1 && _args36[1] !== undefined ? _args36[1] : {};
              scheduler = new Scheduler(Object.assign({
                appendTo: document.body,
                startDate: new Date(2019, 2, 10),
                endDate: new Date(2019, 2, 17),
                features: {
                  dependencies: true
                },
                resources: ArrayHelper.populate(10, function (i) {
                  return {
                    id: 'r' + (i + 1),
                    name: 'Resource ' + (i + 1)
                  };
                }),
                events: [{
                  id: 'e1',
                  startDate: new Date(2019, 2, 10),
                  duration: 2,
                  name: 'Single'
                }, {
                  id: 'e2',
                  startDate: new Date(2019, 2, 14),
                  duration: 2,
                  name: 'Multi A'
                }, {
                  id: 'e3',
                  startDate: new Date(2019, 2, 10),
                  duration: 1,
                  name: 'Multi B'
                }],
                assignments: [{
                  id: 'a1',
                  eventId: 'e1',
                  resourceId: 'r2'
                }, // Single
                {
                  id: 'a2',
                  eventId: 'e2',
                  resourceId: 'r2'
                }, // Multi A
                {
                  id: 'a3',
                  eventId: 'e2',
                  resourceId: 'r5'
                }, // Multi A
                {
                  id: 'a4',
                  eventId: 'e2',
                  resourceId: 'r6'
                }, // Multi A
                {
                  id: 'a5',
                  eventId: 'e3',
                  resourceId: 'r4'
                }, // Multi B
                {
                  id: 'a6',
                  eventId: 'e3',
                  resourceId: 'r5'
                } // Multi B
                ],
                useInitialAnimation: false,
                enableEventAnimations: false
              }, config));
              _context36.next = 4;
              return t.waitForProjectReady(scheduler.project);

            case 4:
              if (!scheduler.dependencies.length) {
                _context36.next = 7;
                break;
              }

              _context36.next = 7;
              return t.waitForDependencies();

            case 7:
            case "end":
              return _context36.stop();
          }
        }
      }, _callee36);
    }));
    return _setupScheduler.apply(this, arguments);
  }

  function assertDepEndToStart(_x2, _x3, _x4) {
    return _assertDepEndToStart.apply(this, arguments);
  }

  function _assertDepEndToStart() {
    _assertDepEndToStart = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee37(t, from, to) {
      var flip,
          depSelector,
          depLine,
          fromElement,
          toElement,
          maxTop,
          minTop,
          _args37 = arguments;
      return regeneratorRuntime.wrap(function _callee37$(_context37) {
        while (1) {
          switch (_context37.prev = _context37.next) {
            case 0:
              flip = _args37.length > 3 && _args37[3] !== undefined ? _args37[3] : false;
              depSelector = "[fromId=\"".concat(from, "\"][toId=\"").concat(to, "\"]");
              _context37.next = 4;
              return t.waitForSelector(depSelector);

            case 4:
              depLine = t.getSVGBox(document.querySelector(depSelector)), fromElement = document.querySelector("[data-assignment-id=\"".concat(flip ? to : from, "\"]")).getBoundingClientRect(), toElement = document.querySelector("[data-assignment-id=\"".concat(flip ? from : to, "\"]")).getBoundingClientRect();
              t.diag("From ".concat(from, " to ").concat(to));
              t.isApprox(depLine.left, fromElement.right, 'Line from right edge of source event');
              t.isApprox(depLine.right, toElement.left, 'Line to left edge of target event');
              maxTop = Math.max(fromElement.top, toElement.top), minTop = Math.min(fromElement.top, toElement.top); // Dependency line has an arrow which is 6px high, also there's a gap on top. Setting threshold to 3px + extra 2px
              // It looks centered

              t.isApprox(depLine.top, minTop + fromElement.height / 2, 5, 'Top');
              t.isApprox(depLine.bottom, maxTop + fromElement.height / 2, 5, 'Bottom');

            case 11:
            case "end":
              return _context37.stop();
          }
        }
      }, _callee37);
    }));
    return _assertDepEndToStart.apply(this, arguments);
  }

  function assertDepNotFound(_x5, _x6, _x7) {
    return _assertDepNotFound.apply(this, arguments);
  }

  function _assertDepNotFound() {
    _assertDepNotFound = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee38(t, from, to) {
      return regeneratorRuntime.wrap(function _callee38$(_context38) {
        while (1) {
          switch (_context38.prev = _context38.next) {
            case 0:
              _context38.next = 2;
              return t.selectorNotExists("[fromId=\"".concat(from, "\"][toId=\"").concat(to, "\"]"));

            case 2:
            case "end":
              return _context38.stop();
          }
        }
      }, _callee38);
    }));
    return _assertDepNotFound.apply(this, arguments);
  }

  function assertAllDeps(_x8) {
    return _assertAllDeps.apply(this, arguments);
  }

  function _assertAllDeps() {
    _assertAllDeps = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee39(t) {
      return regeneratorRuntime.wrap(function _callee39$(_context39) {
        while (1) {
          switch (_context39.prev = _context39.next) {
            case 0:
              _context39.next = 2;
              return assertDepEndToStart(t, 'a1', 'a2');

            case 2:
              _context39.next = 4;
              return assertDepEndToStart(t, 'a1', 'a3');

            case 4:
              _context39.next = 6;
              return assertDepEndToStart(t, 'a1', 'a4');

            case 6:
              _context39.next = 8;
              return assertDepEndToStart(t, 'a5', 'a2');

            case 8:
              _context39.next = 10;
              return assertDepEndToStart(t, 'a5', 'a3');

            case 10:
              _context39.next = 12;
              return assertDepEndToStart(t, 'a5', 'a4');

            case 12:
              _context39.next = 14;
              return assertDepEndToStart(t, 'a6', 'a2');

            case 14:
              _context39.next = 16;
              return assertDepEndToStart(t, 'a6', 'a3');

            case 16:
              _context39.next = 18;
              return assertDepEndToStart(t, 'a6', 'a4');

            case 18:
            case "end":
              return _context39.stop();
          }
        }
      }, _callee39);
    }));
    return _assertAllDeps.apply(this, arguments);
  }

  t.it('Basic drawing', function (t) {
    t.it('Should draw correctly for single to multi', /*#__PURE__*/function () {
      var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
        return regeneratorRuntime.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                _context.next = 2;
                return setupScheduler(t, {
                  dependencies: [{
                    id: 'd1',
                    from: 'e1',
                    to: 'e2'
                  }]
                });

              case 2:
                _context.next = 4;
                return assertDepEndToStart(t, 'a1', 'a2');

              case 4:
                _context.next = 6;
                return assertDepEndToStart(t, 'a1', 'a3');

              case 6:
                _context.next = 8;
                return assertDepEndToStart(t, 'a1', 'a4');

              case 8:
              case "end":
                return _context.stop();
            }
          }
        }, _callee);
      }));

      return function (_x9) {
        return _ref.apply(this, arguments);
      };
    }());
    t.it('Should draw correctly for multi to single', /*#__PURE__*/function () {
      var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
        return regeneratorRuntime.wrap(function _callee2$(_context2) {
          while (1) {
            switch (_context2.prev = _context2.next) {
              case 0:
                _context2.next = 2;
                return setupScheduler(t, {
                  dependencies: [{
                    id: 'd1',
                    from: 'e2',
                    to: 'e1',
                    fromSide: 'left',
                    toSide: 'right'
                  }]
                });

              case 2:
                _context2.next = 4;
                return assertDepEndToStart(t, 'a2', 'a1', true);

              case 4:
                _context2.next = 6;
                return assertDepEndToStart(t, 'a3', 'a1', true);

              case 6:
                _context2.next = 8;
                return assertDepEndToStart(t, 'a4', 'a1', true);

              case 8:
              case "end":
                return _context2.stop();
            }
          }
        }, _callee2);
      }));

      return function (_x10) {
        return _ref2.apply(this, arguments);
      };
    }());
    t.it('Should draw correctly for multi to multi', /*#__PURE__*/function () {
      var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
        return regeneratorRuntime.wrap(function _callee3$(_context3) {
          while (1) {
            switch (_context3.prev = _context3.next) {
              case 0:
                _context3.next = 2;
                return setupScheduler(t, {
                  dependencies: [{
                    id: 'd1',
                    from: 'e3',
                    to: 'e2'
                  }]
                });

              case 2:
                _context3.next = 4;
                return assertDepEndToStart(t, 'a5', 'a2');

              case 4:
                _context3.next = 6;
                return assertDepEndToStart(t, 'a5', 'a3');

              case 6:
                _context3.next = 8;
                return assertDepEndToStart(t, 'a5', 'a4');

              case 8:
                _context3.next = 10;
                return assertDepEndToStart(t, 'a6', 'a2');

              case 10:
                _context3.next = 12;
                return assertDepEndToStart(t, 'a6', 'a3');

              case 12:
                _context3.next = 14;
                return assertDepEndToStart(t, 'a6', 'a4');

              case 14:
              case "end":
                return _context3.stop();
            }
          }
        }, _callee3);
      }));

      return function (_x11) {
        return _ref3.apply(this, arguments);
      };
    }());
  });
  t.it('Event CRUD', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return setupScheduler(t, {
                dependencies: [{
                  id: 'd1',
                  from: 'e1',
                  to: 'e2'
                }, {
                  id: 'd2',
                  from: 'e3',
                  to: 'e2'
                }],
                enableEventAnimations: false
              });

            case 2:
              t.chain(function (next) {
                t.waitForEvent(scheduler, 'dependenciesdrawn', next); // Update

                scheduler.eventStore.getById('e2').startDate = new Date(2019, 2, 15);
                scheduler.project.commitAsync();
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
                return regeneratorRuntime.wrap(function _callee4$(_context4) {
                  while (1) {
                    switch (_context4.prev = _context4.next) {
                      case 0:
                        _context4.next = 2;
                        return assertAllDeps(t);

                      case 2:
                        // Remove
                        scheduler.eventStore.getById('e3').remove();
                        _context4.next = 5;
                        return scheduler.project.commitAsync();

                      case 5:
                        _context4.next = 7;
                        return assertDepEndToStart(t, 'a1', 'a2');

                      case 7:
                        _context4.next = 9;
                        return assertDepEndToStart(t, 'a1', 'a3');

                      case 9:
                        _context4.next = 11;
                        return assertDepEndToStart(t, 'a1', 'a4');

                      case 11:
                        _context4.next = 13;
                        return assertDepNotFound(t, 'a5', 'a2');

                      case 13:
                        _context4.next = 15;
                        return assertDepNotFound(t, 'a5', 'a3');

                      case 15:
                        _context4.next = 17;
                        return assertDepNotFound(t, 'a5', 'a4');

                      case 17:
                        _context4.next = 19;
                        return assertDepNotFound(t, 'a6', 'a2');

                      case 19:
                        _context4.next = 21;
                        return assertDepNotFound(t, 'a6', 'a3');

                      case 21:
                        _context4.next = 23;
                        return assertDepNotFound(t, 'a6', 'a4');

                      case 23:
                      case "end":
                        return _context4.stop();
                    }
                  }
                }, _callee4);
              })));

            case 3:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x12) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Event filtering', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return setupScheduler(t, {
                dependencies: [{
                  id: 'd1',
                  from: 'e1',
                  to: 'e2'
                }, {
                  id: 'd2',
                  from: 'e3',
                  to: 'e2'
                }]
              });

            case 2:
              scheduler.eventStore.filterBy(function (event) {
                return event.id !== 'e1';
              });
              t.chain({
                waitForAnimationFrame: null
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6() {
                return regeneratorRuntime.wrap(function _callee6$(_context6) {
                  while (1) {
                    switch (_context6.prev = _context6.next) {
                      case 0:
                        _context6.next = 2;
                        return assertDepNotFound(t, 'a1', 'a2');

                      case 2:
                        _context6.next = 4;
                        return assertDepNotFound(t, 'a1', 'a3');

                      case 4:
                        _context6.next = 6;
                        return assertDepNotFound(t, 'a1', 'a4');

                      case 6:
                        _context6.next = 8;
                        return assertDepEndToStart(t, 'a5', 'a2');

                      case 8:
                        _context6.next = 10;
                        return assertDepEndToStart(t, 'a5', 'a3');

                      case 10:
                        _context6.next = 12;
                        return assertDepEndToStart(t, 'a5', 'a4');

                      case 12:
                        _context6.next = 14;
                        return assertDepEndToStart(t, 'a6', 'a2');

                      case 14:
                        _context6.next = 16;
                        return assertDepEndToStart(t, 'a6', 'a3');

                      case 16:
                        _context6.next = 18;
                        return assertDepEndToStart(t, 'a6', 'a4');

                      case 18:
                        scheduler.eventStore.clearFilters();

                      case 19:
                      case "end":
                        return _context6.stop();
                    }
                  }
                }, _callee6);
              })), {
                waitForAnimationFrame: null
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                return regeneratorRuntime.wrap(function _callee7$(_context7) {
                  while (1) {
                    switch (_context7.prev = _context7.next) {
                      case 0:
                        return _context7.abrupt("return", assertAllDeps(t));

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

    return function (_x13) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Resource CRUD', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return setupScheduler(t, {
                dependencies: [{
                  id: 'd1',
                  from: 'e1',
                  to: 'e2'
                }, {
                  id: 'd2',
                  from: 'e3',
                  to: 'e2'
                }]
              });

            case 2:
              t.chain( // Add
              {
                waitForEvent: [scheduler, 'dependenciesDrawn'],
                trigger: function trigger() {
                  return scheduler.resourceStore.insert(3, {
                    id: 'r20'
                  });
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9() {
                return regeneratorRuntime.wrap(function _callee9$(_context9) {
                  while (1) {
                    switch (_context9.prev = _context9.next) {
                      case 0:
                        return _context9.abrupt("return", assertAllDeps(t));

                      case 1:
                      case "end":
                        return _context9.stop();
                    }
                  }
                }, _callee9);
              })), // Remove empty resource in the middle
              {
                waitForEvent: [scheduler, 'dependenciesDrawn'],
                trigger: function trigger() {
                  return scheduler.resourceStore.remove('r3');
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10() {
                return regeneratorRuntime.wrap(function _callee10$(_context10) {
                  while (1) {
                    switch (_context10.prev = _context10.next) {
                      case 0:
                        return _context10.abrupt("return", assertAllDeps(t));

                      case 1:
                      case "end":
                        return _context10.stop();
                    }
                  }
                }, _callee10);
              })), // Remove resource with events
              {
                waitForEvent: [scheduler, 'dependenciesDrawn'],
                trigger: function trigger() {
                  scheduler.resourceStore.remove('r2');
                }
              }, // Some weird timing thing going on, ends up correct
              {
                waitForAnimationFrame: null
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11() {
                return regeneratorRuntime.wrap(function _callee11$(_context11) {
                  while (1) {
                    switch (_context11.prev = _context11.next) {
                      case 0:
                        _context11.next = 2;
                        return assertDepNotFound(t, 'a1', 'a2');

                      case 2:
                        _context11.next = 4;
                        return assertDepNotFound(t, 'a1', 'a3');

                      case 4:
                        _context11.next = 6;
                        return assertDepNotFound(t, 'a1', 'a4');

                      case 6:
                        _context11.next = 8;
                        return assertDepNotFound(t, 'a5', 'a2');

                      case 8:
                        _context11.next = 10;
                        return assertDepEndToStart(t, 'a5', 'a3');

                      case 10:
                        _context11.next = 12;
                        return assertDepEndToStart(t, 'a5', 'a4');

                      case 12:
                        _context11.next = 14;
                        return assertDepNotFound(t, 'a6', 'a2');

                      case 14:
                        _context11.next = 16;
                        return assertDepEndToStart(t, 'a6', 'a3');

                      case 16:
                        _context11.next = 18;
                        return assertDepEndToStart(t, 'a6', 'a4');

                      case 18:
                      case "end":
                        return _context11.stop();
                    }
                  }
                }, _callee11);
              })));

            case 3:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x14) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Resource filtering', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return setupScheduler(t, {
                dependencies: [{
                  id: 'd1',
                  from: 'e1',
                  to: 'e2'
                }, {
                  id: 'd2',
                  from: 'e3',
                  to: 'e2'
                }]
              });

            case 2:
              scheduler.resourceStore.filterBy(function (resource) {
                return resource.id !== 'r2';
              });
              t.chain({
                waitForAnimationFrame: null
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13() {
                return regeneratorRuntime.wrap(function _callee13$(_context13) {
                  while (1) {
                    switch (_context13.prev = _context13.next) {
                      case 0:
                        _context13.next = 2;
                        return assertDepNotFound(t, 'a1', 'a2');

                      case 2:
                        _context13.next = 4;
                        return assertDepNotFound(t, 'a1', 'a3');

                      case 4:
                        _context13.next = 6;
                        return assertDepNotFound(t, 'a1', 'a4');

                      case 6:
                        _context13.next = 8;
                        return assertDepNotFound(t, 'a5', 'a2');

                      case 8:
                        _context13.next = 10;
                        return assertDepEndToStart(t, 'a5', 'a3');

                      case 10:
                        _context13.next = 12;
                        return assertDepEndToStart(t, 'a5', 'a4');

                      case 12:
                        _context13.next = 14;
                        return assertDepNotFound(t, 'a6', 'a2');

                      case 14:
                        _context13.next = 16;
                        return assertDepEndToStart(t, 'a6', 'a3');

                      case 16:
                        _context13.next = 18;
                        return assertDepEndToStart(t, 'a6', 'a4');

                      case 18:
                        scheduler.resourceStore.clearFilters();

                      case 19:
                      case "end":
                        return _context13.stop();
                    }
                  }
                }, _callee13);
              })), {
                waitForAnimationFrame: null
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14() {
                return regeneratorRuntime.wrap(function _callee14$(_context14) {
                  while (1) {
                    switch (_context14.prev = _context14.next) {
                      case 0:
                        _context14.next = 2;
                        return assertAllDeps(t);

                      case 2:
                        return _context14.abrupt("return", _context14.sent);

                      case 3:
                      case "end":
                        return _context14.stop();
                    }
                  }
                }, _callee14);
              })));

            case 4:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x15) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('Assignment CRUD', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t) {
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              _context19.next = 2;
              return setupScheduler(t, {
                dependencies: [{
                  id: 'd1',
                  from: 'e1',
                  to: 'e2'
                }, {
                  id: 'd2',
                  from: 'e3',
                  to: 'e2'
                }]
              });

            case 2:
              t.chain(function (next) {
                t.waitForEvent(scheduler, 'dependenciesdrawn', next); // Add

                scheduler.assignmentStore.add({
                  id: 'a7',
                  resourceId: 'r1',
                  eventId: 'e2'
                });
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16() {
                return regeneratorRuntime.wrap(function _callee16$(_context16) {
                  while (1) {
                    switch (_context16.prev = _context16.next) {
                      case 0:
                        _context16.next = 2;
                        return assertAllDeps(t);

                      case 2:
                        _context16.next = 4;
                        return assertDepEndToStart(t, 'a1', 'a7');

                      case 4:
                        // Remove
                        scheduler.assignmentStore.remove('a2');

                      case 5:
                      case "end":
                        return _context16.stop();
                    }
                  }
                }, _callee16);
              })), {
                waitForProjectReady: scheduler
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17() {
                return regeneratorRuntime.wrap(function _callee17$(_context17) {
                  while (1) {
                    switch (_context17.prev = _context17.next) {
                      case 0:
                        _context17.next = 2;
                        return assertDepNotFound(t, 'a1', 'a2');

                      case 2:
                        _context17.next = 4;
                        return assertDepEndToStart(t, 'a1', 'a3');

                      case 4:
                        _context17.next = 6;
                        return assertDepEndToStart(t, 'a1', 'a4');

                      case 6:
                        _context17.next = 8;
                        return assertDepNotFound(t, 'a5', 'a2');

                      case 8:
                        _context17.next = 10;
                        return assertDepEndToStart(t, 'a5', 'a3');

                      case 10:
                        _context17.next = 12;
                        return assertDepEndToStart(t, 'a5', 'a4');

                      case 12:
                        _context17.next = 14;
                        return assertDepNotFound(t, 'a6', 'a2');

                      case 14:
                        _context17.next = 16;
                        return assertDepEndToStart(t, 'a6', 'a3');

                      case 16:
                        _context17.next = 18;
                        return assertDepEndToStart(t, 'a6', 'a4');

                      case 18:
                      case "end":
                        return _context17.stop();
                    }
                  }
                }, _callee17);
              })), function (next) {
                t.waitForEvent(scheduler, 'dependenciesdrawn', next); // Update

                scheduler.assignmentStore.getById('a3').resourceId = 'r10'; // TODO: The line above does not invalidate the graph, making the code below fail
              }, {
                waitForProjectReady: scheduler
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18() {
                return regeneratorRuntime.wrap(function _callee18$(_context18) {
                  while (1) {
                    switch (_context18.prev = _context18.next) {
                      case 0:
                        _context18.next = 2;
                        return assertDepEndToStart(t, 'a1', 'a3');

                      case 2:
                        _context18.next = 4;
                        return assertDepEndToStart(t, 'a5', 'a3');

                      case 4:
                        _context18.next = 6;
                        return assertDepEndToStart(t, 'a6', 'a3');

                      case 6:
                      case "end":
                        return _context18.stop();
                    }
                  }
                }, _callee18);
              })));

            case 3:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    }));

    return function (_x16) {
      return _ref16.apply(this, arguments);
    };
  }());
  t.it('Assignment filtering', /*#__PURE__*/function () {
    var _ref20 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
      return regeneratorRuntime.wrap(function _callee22$(_context22) {
        while (1) {
          switch (_context22.prev = _context22.next) {
            case 0:
              _context22.next = 2;
              return setupScheduler(t, {
                dependencies: [{
                  id: 'd1',
                  from: 'e1',
                  to: 'e2'
                }, {
                  id: 'd2',
                  from: 'e3',
                  to: 'e2'
                }]
              });

            case 2:
              scheduler.assignmentStore.filterBy(function (assignment) {
                return assignment.resourceId !== 'r2';
              });
              t.chain({
                waitForAnimationFrame: null
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20() {
                return regeneratorRuntime.wrap(function _callee20$(_context20) {
                  while (1) {
                    switch (_context20.prev = _context20.next) {
                      case 0:
                        _context20.next = 2;
                        return assertDepNotFound(t, 'a1', 'a2');

                      case 2:
                        _context20.next = 4;
                        return assertDepNotFound(t, 'a1', 'a3');

                      case 4:
                        _context20.next = 6;
                        return assertDepNotFound(t, 'a1', 'a4');

                      case 6:
                        _context20.next = 8;
                        return assertDepNotFound(t, 'a5', 'a2');

                      case 8:
                        _context20.next = 10;
                        return assertDepEndToStart(t, 'a5', 'a3');

                      case 10:
                        _context20.next = 12;
                        return assertDepEndToStart(t, 'a5', 'a4');

                      case 12:
                        _context20.next = 14;
                        return assertDepNotFound(t, 'a6', 'a2');

                      case 14:
                        _context20.next = 16;
                        return assertDepEndToStart(t, 'a6', 'a3');

                      case 16:
                        _context20.next = 18;
                        return assertDepEndToStart(t, 'a6', 'a4');

                      case 18:
                        scheduler.assignmentStore.clearFilters();

                      case 19:
                      case "end":
                        return _context20.stop();
                    }
                  }
                }, _callee20);
              })), {
                waitForAnimationFrame: null
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21() {
                return regeneratorRuntime.wrap(function _callee21$(_context21) {
                  while (1) {
                    switch (_context21.prev = _context21.next) {
                      case 0:
                        _context21.next = 2;
                        return assertAllDeps(t);

                      case 2:
                        return _context21.abrupt("return", _context21.sent);

                      case 3:
                      case "end":
                        return _context21.stop();
                    }
                  }
                }, _callee21);
              })));

            case 4:
            case "end":
              return _context22.stop();
          }
        }
      }, _callee22);
    }));

    return function (_x17) {
      return _ref20.apply(this, arguments);
    };
  }());
  t.it('Dependency CRUD', /*#__PURE__*/function () {
    var _ref23 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee27(t) {
      return regeneratorRuntime.wrap(function _callee27$(_context27) {
        while (1) {
          switch (_context27.prev = _context27.next) {
            case 0:
              _context27.next = 2;
              return setupScheduler(t, {
                dependencies: [{
                  id: 'd1',
                  from: 'e1',
                  to: 'e2'
                }]
              });

            case 2:
              t.chain( // Add
              {
                waitForEvent: [scheduler, 'dependenciesDrawn'],
                trigger: function trigger() {
                  return scheduler.dependencyStore.add({
                    id: 'd2',
                    from: 'e3',
                    to: 'e2'
                  });
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23() {
                return regeneratorRuntime.wrap(function _callee23$(_context23) {
                  while (1) {
                    switch (_context23.prev = _context23.next) {
                      case 0:
                        _context23.next = 2;
                        return assertAllDeps(t);

                      case 2:
                        return _context23.abrupt("return", _context23.sent);

                      case 3:
                      case "end":
                        return _context23.stop();
                    }
                  }
                }, _callee23);
              })), // Remove
              {
                waitForEvent: [scheduler, 'dependenciesDrawn'],
                trigger: function trigger() {
                  return scheduler.dependencyStore.first.remove();
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee24() {
                return regeneratorRuntime.wrap(function _callee24$(_context24) {
                  while (1) {
                    switch (_context24.prev = _context24.next) {
                      case 0:
                        _context24.next = 2;
                        return assertDepNotFound(t, 'a1', 'a2');

                      case 2:
                        _context24.next = 4;
                        return assertDepNotFound(t, 'a1', 'a3');

                      case 4:
                        _context24.next = 6;
                        return assertDepNotFound(t, 'a1', 'a4');

                      case 6:
                      case "end":
                        return _context24.stop();
                    }
                  }
                }, _callee24);
              })), // Update
              {
                waitForEvent: [scheduler, 'dependenciesDrawn'],
                trigger: function trigger() {
                  return scheduler.dependencyStore.first.from = 'e1';
                }
              }, {
                waitForSelector: '.b-sch-dependency'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee25() {
                return regeneratorRuntime.wrap(function _callee25$(_context25) {
                  while (1) {
                    switch (_context25.prev = _context25.next) {
                      case 0:
                        _context25.next = 2;
                        return assertDepEndToStart(t, 'a1', 'a2');

                      case 2:
                        _context25.next = 4;
                        return assertDepEndToStart(t, 'a1', 'a3');

                      case 4:
                        _context25.next = 6;
                        return assertDepEndToStart(t, 'a1', 'a4');

                      case 6:
                        _context25.next = 8;
                        return assertDepNotFound(t, 'a5', 'a2');

                      case 8:
                        _context25.next = 10;
                        return assertDepNotFound(t, 'a5', 'a3');

                      case 10:
                        _context25.next = 12;
                        return assertDepNotFound(t, 'a5', 'a4');

                      case 12:
                        _context25.next = 14;
                        return assertDepNotFound(t, 'a6', 'a2');

                      case 14:
                        _context25.next = 16;
                        return assertDepNotFound(t, 'a6', 'a3');

                      case 16:
                        _context25.next = 18;
                        return assertDepNotFound(t, 'a6', 'a4');

                      case 18:
                        // // Remove all
                        scheduler.dependencyStore.removeAll();

                      case 19:
                      case "end":
                        return _context25.stop();
                    }
                  }
                }, _callee25);
              })), {
                waitForSelectorNotFound: '.b-sch-dependency'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee26() {
                return regeneratorRuntime.wrap(function _callee26$(_context26) {
                  while (1) {
                    switch (_context26.prev = _context26.next) {
                      case 0:
                        _context26.next = 2;
                        return assertDepNotFound(t, 'a1', 'a2');

                      case 2:
                        _context26.next = 4;
                        return assertDepNotFound(t, 'a1', 'a3');

                      case 4:
                        _context26.next = 6;
                        return assertDepNotFound(t, 'a1', 'a4');

                      case 6:
                        _context26.next = 8;
                        return assertDepNotFound(t, 'a5', 'a2');

                      case 8:
                        _context26.next = 10;
                        return assertDepNotFound(t, 'a5', 'a3');

                      case 10:
                        _context26.next = 12;
                        return assertDepNotFound(t, 'a5', 'a4');

                      case 12:
                        _context26.next = 14;
                        return assertDepNotFound(t, 'a6', 'a2');

                      case 14:
                        _context26.next = 16;
                        return assertDepNotFound(t, 'a6', 'a3');

                      case 16:
                        _context26.next = 18;
                        return assertDepNotFound(t, 'a6', 'a4');

                      case 18:
                      case "end":
                        return _context26.stop();
                    }
                  }
                }, _callee26);
              })));

            case 3:
            case "end":
              return _context27.stop();
          }
        }
      }, _callee27);
    }));

    return function (_x18) {
      return _ref23.apply(this, arguments);
    };
  }());
  t.it('Dependency filtering', /*#__PURE__*/function () {
    var _ref28 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee30(t) {
      return regeneratorRuntime.wrap(function _callee30$(_context30) {
        while (1) {
          switch (_context30.prev = _context30.next) {
            case 0:
              _context30.next = 2;
              return setupScheduler(t, {
                dependencies: [{
                  id: 'd1',
                  from: 'e1',
                  to: 'e2'
                }, {
                  id: 'd2',
                  from: 'e3',
                  to: 'e2'
                }]
              });

            case 2:
              scheduler.dependencyStore.filterBy(function (dependency) {
                return dependency.id !== 'd2';
              });
              t.chain({
                waitForAnimationFrame: null
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee28() {
                return regeneratorRuntime.wrap(function _callee28$(_context28) {
                  while (1) {
                    switch (_context28.prev = _context28.next) {
                      case 0:
                        _context28.next = 2;
                        return assertDepEndToStart(t, 'a1', 'a2');

                      case 2:
                        _context28.next = 4;
                        return assertDepEndToStart(t, 'a1', 'a3');

                      case 4:
                        _context28.next = 6;
                        return assertDepEndToStart(t, 'a1', 'a4');

                      case 6:
                        _context28.next = 8;
                        return assertDepNotFound(t, 'a5', 'a2');

                      case 8:
                        _context28.next = 10;
                        return assertDepNotFound(t, 'a5', 'a3');

                      case 10:
                        _context28.next = 12;
                        return assertDepNotFound(t, 'a5', 'a4');

                      case 12:
                        _context28.next = 14;
                        return assertDepNotFound(t, 'a6', 'a2');

                      case 14:
                        _context28.next = 16;
                        return assertDepNotFound(t, 'a6', 'a3');

                      case 16:
                        _context28.next = 18;
                        return assertDepNotFound(t, 'a6', 'a4');

                      case 18:
                        scheduler.dependencyStore.clearFilters();

                      case 19:
                      case "end":
                        return _context28.stop();
                    }
                  }
                }, _callee28);
              })), {
                waitForAnimationFrame: null
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee29() {
                return regeneratorRuntime.wrap(function _callee29$(_context29) {
                  while (1) {
                    switch (_context29.prev = _context29.next) {
                      case 0:
                        _context29.next = 2;
                        return assertAllDeps(t);

                      case 2:
                        return _context29.abrupt("return", _context29.sent);

                      case 3:
                      case "end":
                        return _context29.stop();
                    }
                  }
                }, _callee29);
              })));

            case 4:
            case "end":
              return _context30.stop();
          }
        }
      }, _callee30);
    }));

    return function (_x19) {
      return _ref28.apply(this, arguments);
    };
  }());
  t.it('Event drag', /*#__PURE__*/function () {
    var _ref31 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee32(t) {
      return regeneratorRuntime.wrap(function _callee32$(_context32) {
        while (1) {
          switch (_context32.prev = _context32.next) {
            case 0:
              _context32.next = 2;
              return setupScheduler(t, {
                dependencies: [{
                  id: 'd1',
                  from: 'e1',
                  to: 'e2'
                }]
              });

            case 2:
              t.chain({
                drag: '[data-assignment-id="a3"]',
                by: [-146, -60]
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee31() {
                return regeneratorRuntime.wrap(function _callee31$(_context31) {
                  while (1) {
                    switch (_context31.prev = _context31.next) {
                      case 0:
                        _context31.next = 2;
                        return assertDepEndToStart(t, 'a1', 'a2');

                      case 2:
                        _context31.next = 4;
                        return assertDepEndToStart(t, 'a1', 'a3');

                      case 4:
                        _context31.next = 6;
                        return assertDepEndToStart(t, 'a1', 'a4');

                      case 6:
                      case "end":
                        return _context31.stop();
                    }
                  }
                }, _callee31);
              })));

            case 3:
            case "end":
              return _context32.stop();
          }
        }
      }, _callee32);
    }));

    return function (_x20) {
      return _ref31.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7980

  t.it('Abort should not throw error', /*#__PURE__*/function () {
    var _ref33 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee33(t) {
      return regeneratorRuntime.wrap(function _callee33$(_context33) {
        while (1) {
          switch (_context33.prev = _context33.next) {
            case 0:
              _context33.next = 2;
              return setupScheduler(t);

            case 2:
              t.chain({
                moveMouseTo: '.b-sch-event'
              }, // Mousedown and mouseup with no drag aborts the dep create operation.
              {
                click: '.b-sch-event .b-sch-terminal-bottom'
              }, function () {
                t.pass('No error thrown');
              });

            case 3:
            case "end":
              return _context33.stop();
          }
        }
      }, _callee33);
    }));

    return function (_x21) {
      return _ref33.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8272

  t.it('Vertical re-sort should not leave orphaned lines', /*#__PURE__*/function () {
    var _ref34 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee34(t) {
      var event;
      return regeneratorRuntime.wrap(function _callee34$(_context34) {
        while (1) {
          switch (_context34.prev = _context34.next) {
            case 0:
              _context34.next = 2;
              return setupScheduler(t, {
                dependencies: [{
                  id: 'd1',
                  from: 'e1',
                  to: 'e2'
                }]
              });

            case 2:
              event = scheduler.eventStore.getById('e3'); //
              // // Want it to sort first on overlap

              event.name = 'A';
              event.duration = 2; // Put it below multi assigned event
              // [Multi A]
              //     [A      ]

              event.startDate = new Date(2019, 2, 15);
              scheduler.assignmentStore.getById('a6').resourceId = 'r6';
              t.chain({
                waitForProjectReady: scheduler
              }, // Let view refresh before moving again
              {
                waitForAnimationFrame: null
              }, function (next) {
                // Move it to same start, triggering vertical re-sort
                // [Multi A]          -->  [A      ]
                // <---[A      ]           [Multi A]
                event.startDate = new Date(2019, 2, 14);
                next();
              }, {
                waitForProjectReady: scheduler
              }, // Let view refresh before evaluating
              {
                waitForAnimationFrame: null
              }, function () {
                // Should line up with bottom event
                var depBox = Rectangle.from(document.querySelector('[depId=d1][toId=a4]'), scheduler.timeAxisSubGridElement),
                    eventBox = Rectangle.from(document.querySelector('[data-assignment-id=a4]'), scheduler.timeAxisSubGridElement),
                    markerHeight = Number(t.query('marker')[0].getAttribute('markerHeight'));
                t.isApprox(depBox.bottom - markerHeight / 2, eventBox.top + eventBox.height / 2, 7, 'Aligned correctly'); // const depBox = Rectangle.from(document.querySelector('[depId=d1][toId=a4]'), scheduler.timeAxisSubGridElement);
                // const eventBox = Rectangle.from(document.querySelector('[data-assignment-id=a4]'), scheduler.timeAxisSubGridElement);
                //
                // t.isApprox(depBox.bottom, eventBox.top + eventBox.height / 2, 5, 'Aligned correctly');
              });

            case 8:
            case "end":
              return _context34.stop();
          }
        }
      }, _callee34);
    }));

    return function (_x22) {
      return _ref34.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1384

  t.it('Should draw dependencies for new assignment', /*#__PURE__*/function () {
    var _ref35 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee35(t) {
      return regeneratorRuntime.wrap(function _callee35$(_context35) {
        while (1) {
          switch (_context35.prev = _context35.next) {
            case 0:
              _context35.next = 2;
              return setupScheduler(t, {
                dependencies: [{
                  id: 'd1',
                  from: 'e1',
                  to: 'e2'
                }]
              });

            case 2:
              _context35.next = 4;
              return scheduler.editEvent(scheduler.eventStore.getById('e2'));

            case 4:
              t.chain({
                type: 'r[ENTER][ESC][ENTER]',
                target: 'input[name=resource]'
              }, {
                waitFor: function waitFor() {
                  return t.query("polyline[toId=".concat(scheduler.assignmentStore.last.id, "]"));
                },
                desc: 'New line drawn'
              });

            case 5:
            case "end":
              return _context35.stop();
          }
        }
      }, _callee35);
    }));

    return function (_x23) {
      return _ref35.apply(this, arguments);
    };
  }());
});