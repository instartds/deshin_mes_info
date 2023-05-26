function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, assignmentStore;

  function createScheduler(_x) {
    return _createScheduler.apply(this, arguments);
  } // async beforeEach doesn't work in umd


  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(config) {
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              _context19.next = 2;
              return t.getVerticalSchedulerMultiAsync(Object.assign({
                resourceColumns: {
                  fillWidth: false,
                  fitWidth: false
                }
              }, config));

            case 2:
              scheduler = _context19.sent;
              assignmentStore = scheduler.assignmentStore;

            case 4:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    }));
    return _createScheduler.apply(this, arguments);
  }

  t.beforeEach( /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t, next) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler && scheduler.destroy();
              _context.next = 3;
              return createScheduler();

            case 3:
              next();

            case 4:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x2, _x3) {
      return _ref.apply(this, arguments);
    };
  }());

  function assertEventElement(t, assignmentId) {
    var x = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
    var y = arguments.length > 3 ? arguments[3] : undefined;
    var width = arguments.length > 4 ? arguments[4] : undefined;
    var height = arguments.length > 5 ? arguments[5] : undefined;
    var msg = arguments.length > 6 && arguments[6] !== undefined ? arguments[6] : '';
    // Need to use scheduler.assignmentStore and not shortcut assignmentStore since one test creates a new store
    var assignment = _typeof(assignmentId) !== 'object' ? scheduler.assignmentStore.getById(assignmentId) : assignmentId;
    var selector = "[data-event-id=\"".concat(assignment.eventId, "\"][data-resource-id=\"").concat(assignment.resourceId, "\"]:not(.b-released)");

    if (_typeof(assignmentId) !== 'object') {
      selector = "[data-sync-id=\"".concat(assignmentId, "\"]").concat(selector);
    }

    if (x === null) {
      t.selectorNotExists(selector, 'Element not found ' + msg);
    } else {
      t.selectorExists(selector, 'Element found ' + msg);
      var box = Rectangle.from(document.querySelector(selector), scheduler.timeAxisSubGridElement);
      t.is(box.top, y, 'Correct top');
      t.is(box.left, x, 'Correct left');
      t.is(box.width, width, 'Correct width');
      t.is(box.height, height, 'Correct height');
    }
  }

  t.it('Renders correctly using AssignmentStore', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              assertEventElement(t, 'a1', 0, 100, 75, 100);
              assertEventElement(t, 'a2', 75, 150, 75, 200);
              assertEventElement(t, 'a3', 0, 300, 75, 200);
              assertEventElement(t, 'a4', 0, 500, 150, 250);
              assertEventElement(t, 'a5', 150, 100, 75, 100);
              assertEventElement(t, 'a6', 225, 150, 75, 200);
              assertEventElement(t, 'a7', 300, 500, 75, 250);
              assertEventElement(t, 'a8', 375, 650, 75, 100);
              assertEventElement(t, 'a9');
              assertEventElement(t, 'a10', 450, 100, 150, 100);
              assertEventElement(t, 'a11');
              assertEventElement(t, 'a12');
              assertEventElement(t, 'a13');
              assertEventElement(t, 'a14');
              assertEventElement(t, 'a15');

            case 15:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x4) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Resolves element <-> record', function (t) {
    var element = document.querySelector('.b-sch-event-wrap .b-sch-event'),
        eventRecord = scheduler.resolveEventRecord(element),
        resourceRecord = scheduler.resolveResourceRecord(element),
        assignmentRecord = scheduler.resolveAssignmentRecord(element);
    t.is(eventRecord, scheduler.eventStore.first, 'Event record resolved from element');
    t.is(resourceRecord, scheduler.resourceStore.first, 'Resource record resolved from element');
    t.is(assignmentRecord, scheduler.assignmentStore.first, 'Assignment record resolved from element');
    var eventElement = scheduler.getElementFromEventRecord(eventRecord, resourceRecord),
        assignmentElement = scheduler.getElementFromAssignmentRecord(assignmentRecord);
    t.is(eventElement, element, 'Event element resolved from event record');
    t.is(assignmentElement, element, 'Event element resolved from assignment record');
  });
  t.it('CRUD - Add', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              t.diag('Add in view');
              _context5.next = 3;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 1,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                    return regeneratorRuntime.wrap(function _callee3$(_context3) {
                      while (1) {
                        switch (_context3.prev = _context3.next) {
                          case 0:
                            assignmentStore.add({
                              id: 'a100',
                              resourceId: 'r5',
                              eventId: 1
                            });
                            _context3.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context3.stop();
                        }
                      }
                    }, _callee3);
                  }))();
                }
              });

            case 3:
              assertEventElement(t, 'a100', 600, 100, 150, 100);
              t.diag('Add outside of view');
              _context5.next = 7;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
                    return regeneratorRuntime.wrap(function _callee4$(_context4) {
                      while (1) {
                        switch (_context4.prev = _context4.next) {
                          case 0:
                            assignmentStore.add({
                              id: 'a101',
                              resourceId: 'r5',
                              eventId: 6
                            });
                            _context4.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context4.stop();
                        }
                      }
                    }, _callee4);
                  }))();
                }
              });

            case 7:
              assertEventElement(t, 'a101');
              scheduler.scrollTop = 1000;
              _context5.next = 11;
              return scheduler.await('scroll');

            case 11:
              assertEventElement(t, 'a101', 600, 1250, 150, 100);

            case 12:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x5) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('CRUD - Remove', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              t.diag('Remove from view');
              _context8.next = 3;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 2,
                  // Affects layout of event 2 & 3 also
                  releaseEvent: 1
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6() {
                    return regeneratorRuntime.wrap(function _callee6$(_context6) {
                      while (1) {
                        switch (_context6.prev = _context6.next) {
                          case 0:
                            assignmentStore.first.remove();
                            _context6.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context6.stop();
                        }
                      }
                    }, _callee6);
                  }))();
                }
              });

            case 3:
              assertEventElement(t, {
                resourceId: 'r1',
                eventId: 1
              });
              assertEventElement(t, 'a2', 0, 150, 75, 200);
              t.diag('Remove from outside of view');
              _context8.next = 8;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                    return regeneratorRuntime.wrap(function _callee7$(_context7) {
                      while (1) {
                        switch (_context7.prev = _context7.next) {
                          case 0:
                            assignmentStore.last.remove();
                            _context7.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context7.stop();
                        }
                      }
                    }, _callee7);
                  }))();
                }
              });

            case 8:
              scheduler.scrollLeft = 1000;
              _context8.next = 11;
              return scheduler.await('horizontalscroll');

            case 11:
              assertEventElement(t, {
                resourceId: 9,
                eventId: 1
              });

            case 12:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x6) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('CRUD - Remove all', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 9
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9() {
                    return regeneratorRuntime.wrap(function _callee9$(_context9) {
                      while (1) {
                        switch (_context9.prev = _context9.next) {
                          case 0:
                            assignmentStore.removeAll();
                            _context9.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context9.stop();
                        }
                      }
                    }, _callee9);
                  }))();
                }
              });

            case 2:
              t.selectorNotExists('.b-sch-event-wrap:not(.b-released)', 'No event elements visible');

            case 3:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x7) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('CRUD - Update', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 4,
                  // Event 2 & 3 from old location, 4 & self from new
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11() {
                    return regeneratorRuntime.wrap(function _callee11$(_context11) {
                      while (1) {
                        switch (_context11.prev = _context11.next) {
                          case 0:
                            assignmentStore.first.eventId = 5;
                            _context11.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context11.stop();
                        }
                      }
                    }, _callee11);
                  }))();
                }
              });

            case 2:
              assertEventElement(t, 'a1', 75, 650, 75, 100);
              _context13.next = 5;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 2,
                  // Event 4 from old location, self in new
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12() {
                    return regeneratorRuntime.wrap(function _callee12$(_context12) {
                      while (1) {
                        switch (_context12.prev = _context12.next) {
                          case 0:
                            assignmentStore.first.resourceId = 'r2';
                            _context12.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context12.stop();
                        }
                      }
                    }, _callee12);
                  }))();
                }
              });

            case 5:
              assertEventElement(t, {
                resourceId: 'r1',
                eventId: 5
              });
              assertEventElement(t, 'a1', 150, 650, 150, 100);

            case 7:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x8) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('CRUD - Replace', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 3,
                  // Event 2 & 3 from old location, self in new
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14() {
                    return regeneratorRuntime.wrap(function _callee14$(_context14) {
                      while (1) {
                        switch (_context14.prev = _context14.next) {
                          case 0:
                            assignmentStore.add({
                              id: 'a1',
                              eventId: 5,
                              resourceId: 'r2'
                            });
                            _context14.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context14.stop();
                        }
                      }
                    }, _callee14);
                  }))();
                }
              });

            case 2:
              t.selectorNotExists('[data-assignment-id="a1"][data-resource-id="r1"][data-event-id="1"]', 'Old assignment gone from DOM');
              assertEventElement(t, 'a1', 150, 650, 150, 100);

            case 4:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x9) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('CRUD - Changing id', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              scheduler.assignmentStore.first.id = 'a5000';
              _context16.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.selectorNotExists('[data-event-id="a1"]', 'Old id gone from DOM');
              assertEventElement(t, 'a5000', 0, 100, 75, 100);

            case 5:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x10) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Filtering', function (t) {
    t.diag('Applying filter to assignments');
    t.firesOk({
      observable: scheduler,
      events: {
        renderEvent: 0,
        releaseEvent: 2
      },
      during: function during() {
        assignmentStore.filter(function (a) {
          return ['r1', 'r2', 'r4'].includes(a.resourceId);
        });
      }
    });
    assertEventElement(t, 'a1', 0, 100, 75, 100);
    assertEventElement(t, 'a2', 75, 150, 75, 200);
    assertEventElement(t, 'a3', 0, 300, 75, 200);
    assertEventElement(t, 'a4', 0, 500, 150, 250);
    assertEventElement(t, 'a5', 150, 100, 75, 100);
    assertEventElement(t, 'a6', 225, 150, 75, 200);
    assertEventElement(t, 'a7');
    assertEventElement(t, 'a8');
    assertEventElement(t, 'a9');
    assertEventElement(t, 'a10', 450, 100, 150, 100);
    assertEventElement(t, 'a11');
    assertEventElement(t, 'a12');
    assertEventElement(t, 'a13');
    assertEventElement(t, 'a14');
    assertEventElement(t, 'a15');
    t.diag('Removing filters');
    t.firesOk({
      observable: scheduler,
      events: {
        renderEvent: 2,
        releaseEvent: 0
      },
      during: function during() {
        assignmentStore.clearFilters();
      }
    });
    assertEventElement(t, 'a7', 300, 500, 75, 250);
    assertEventElement(t, 'a8', 375, 650, 75, 100);
    t.diag('Applying filter to resources');
    t.firesOk({
      observable: scheduler,
      events: {
        renderEvent: 1,
        // r4 moves to the left
        releaseEvent: 2
      },
      during: function during() {
        scheduler.resourceStore.filter(function (r) {
          return ['r1', 'r2', 'r4'].includes(r.id);
        });
      }
    });
    assertEventElement(t, 'a1', 0, 100, 75, 100);
    assertEventElement(t, 'a2', 75, 150, 75, 200);
    assertEventElement(t, 'a3', 0, 300, 75, 200);
    assertEventElement(t, 'a4', 0, 500, 150, 250);
    assertEventElement(t, 'a5', 150, 100, 75, 100);
    assertEventElement(t, 'a6', 225, 150, 75, 200);
    assertEventElement(t, 'a7');
    assertEventElement(t, 'a8');
    assertEventElement(t, 'a9');
    assertEventElement(t, 'a10', 300, 100, 150, 100);
    assertEventElement(t, 'a11');
    assertEventElement(t, 'a12');
    assertEventElement(t, 'a13');
    assertEventElement(t, 'a14');
    assertEventElement(t, 'a15');
  });
  t.it('Change AssignmentStore', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              _context18.next = 2;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 1,
                  releaseEvent: 8
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17() {
                    return regeneratorRuntime.wrap(function _callee17$(_context17) {
                      while (1) {
                        switch (_context17.prev = _context17.next) {
                          case 0:
                            scheduler.assignmentStore = new AssignmentStore({
                              data: [{
                                id: 'a1',
                                eventId: 1,
                                resourceId: 'r6'
                              }]
                            });
                            _context17.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context17.stop();
                        }
                      }
                    }, _callee17);
                  }))();
                }
              });

            case 2:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Single event visible');
              assertEventElement(t, 'a1', 750, 100, 150, 100);

            case 4:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    }));

    return function (_x11) {
      return _ref9.apply(this, arguments);
    };
  }());
});