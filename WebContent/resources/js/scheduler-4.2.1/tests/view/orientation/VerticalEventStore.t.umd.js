function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, eventStore;

  function createScheduler(_x) {
    return _createScheduler.apply(this, arguments);
  } // async beforeEach doesn't work in umd


  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee31(config) {
      return regeneratorRuntime.wrap(function _callee31$(_context31) {
        while (1) {
          switch (_context31.prev = _context31.next) {
            case 0:
              _context31.next = 2;
              return t.getVerticalSchedulerAsync(config);

            case 2:
              scheduler = _context31.sent;
              eventStore = scheduler.eventStore;

            case 4:
            case "end":
              return _context31.stop();
          }
        }
      }, _callee31);
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

  function assertEventElement(t, eventId, resourceId) {
    var x = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : null;
    var y = arguments.length > 4 ? arguments[4] : undefined;
    var width = arguments.length > 5 ? arguments[5] : undefined;
    var height = arguments.length > 6 ? arguments[6] : undefined;
    var msg = arguments.length > 7 && arguments[7] !== undefined ? arguments[7] : '';
    var selector = "[data-resource-id=\"".concat(resourceId, "\"][data-event-id=\"").concat(eventId, "\"]:not(.b-released)");

    if (x === null) {
      t.selectorNotExists(selector, 'Element not found');
    } else {
      t.selectorExists(selector, 'Element found ' + msg);
      var box = Rectangle.from(document.querySelector(selector), scheduler.timeAxisSubGridElement);
      t.isApproxPx(box.top, y, 'Correct top');
      t.isApproxPx(box.left, x, 'Correct left');
      t.isApproxPx(box.width, width, 'Correct width');
      t.isApproxPx(box.height, height, 'Correct height');
    }
  }

  t.it('CRUD - Add', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              t.diag('Add in view');
              _context4.next = 3;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 2,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                    return regeneratorRuntime.wrap(function _callee2$(_context2) {
                      while (1) {
                        switch (_context2.prev = _context2.next) {
                          case 0:
                            eventStore.add({
                              id: 100,
                              name: 'New event 100',
                              startDate: new Date(2019, 4, 27),
                              duration: 3,
                              resourceId: 'r4'
                            });
                            _context2.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context2.stop();
                        }
                      }
                    }, _callee2);
                  }))();
                }
              });

            case 3:
              t.selectorExists('[data-resource-id="r4"][data-event-id="100"]', 'Element found');
              t.diag('Add outside of view');
              _context4.next = 7;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                    return regeneratorRuntime.wrap(function _callee3$(_context3) {
                      while (1) {
                        switch (_context3.prev = _context3.next) {
                          case 0:
                            eventStore.add({
                              id: 101,
                              name: 'New event 101',
                              startDate: new Date(2019, 5, 30),
                              duration: 3,
                              resourceId: 'r4'
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

            case 7:
              t.selectorNotExists('[data-resource-id="r4"][data-event-id="101"]', 'Element not found');
              scheduler.scrollable.scrollTo(0, scheduler.scrollable.maxY);
              t.waitForSelector('[data-resource-id="r4"][data-event-id="101"]'); // TODO: Add multiple

            case 10:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('CRUD - Remove', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              t.diag('Remove from view');
              _context7.next = 3;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 1,
                  // Event 2 shares width with Event 1 and will be rerendered
                  releaseEvent: 1
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
                    return regeneratorRuntime.wrap(function _callee5$(_context5) {
                      while (1) {
                        switch (_context5.prev = _context5.next) {
                          case 0:
                            eventStore.remove(1);
                            _context5.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context5.stop();
                        }
                      }
                    }, _callee5);
                  }))();
                }
              });

            case 3:
              t.selectorNotExists('[data-resource-id="r1"][data-event-id="1"]:not(.b-released)');
              t.diag('Remove from outside of view');
              _context7.next = 7;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6() {
                    return regeneratorRuntime.wrap(function _callee6$(_context6) {
                      while (1) {
                        switch (_context6.prev = _context6.next) {
                          case 0:
                            eventStore.remove(7);
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

            case 7:
              scheduler.scrollable.scrollTo(0, 1000);
              t.waitForSelector('[data-resource-id="r1"][data-event-id="6"]', function () {
                t.selectorNotExists('[data-resource-id="r1"][data-event-id="7"]', 'Element not found after scroll');
              });

            case 9:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x5) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('CRUD - Remove all', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 5
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8() {
                    return regeneratorRuntime.wrap(function _callee8$(_context8) {
                      while (1) {
                        switch (_context8.prev = _context8.next) {
                          case 0:
                            eventStore.removeAll();
                            _context8.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context8.stop();
                        }
                      }
                    }, _callee8);
                  }))();
                }
              });

            case 2:
              t.selectorNotExists('.b-sch-event-wrap:not(.b-released)', 'No elements visible');

            case 3:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x6) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('CRUD - Update "internal"', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              t.diag('Update name in view');
              _context12.next = 3;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 1,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10() {
                    return regeneratorRuntime.wrap(function _callee10$(_context10) {
                      while (1) {
                        switch (_context10.prev = _context10.next) {
                          case 0:
                            eventStore.first.name = 'New name';

                          case 1:
                          case "end":
                            return _context10.stop();
                        }
                      }
                    }, _callee10);
                  }))();
                }
              });

            case 3:
              t.selectorExists('[data-resource-id="r1"][data-event-id="1"]:contains(New name)', 'Updated');
              t.diag('Update name outside of view');
              _context12.next = 7;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11() {
                    return regeneratorRuntime.wrap(function _callee11$(_context11) {
                      while (1) {
                        switch (_context11.prev = _context11.next) {
                          case 0:
                            eventStore.getById(7).name = 'New name 2';
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

            case 7:
              t.selectorNotExists('[data-resource-id="r1"][data-event-id="7"]:contains(New name 2)', 'Element not found');
              scheduler.scrollEventIntoView(eventStore.getById(7)); // Need to wait for scroll event, events are updated by that

              _context12.next = 11;
              return scheduler.await('scroll');

            case 11:
              t.selectorExists('[data-resource-id="r1"][data-event-id="7"]:contains(New name 2)', 'Element found after scroll');

            case 12:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x7) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('CRUD - Update affecting pos', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              t.diag('Update pos in view');
              _context17.next = 3;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 2,
                  // Moved event + event that it shared width with
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13() {
                    return regeneratorRuntime.wrap(function _callee13$(_context13) {
                      while (1) {
                        switch (_context13.prev = _context13.next) {
                          case 0:
                            eventStore.first.startDate = new Date(2019, 5, 3);
                            _context13.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context13.stop();
                        }
                      }
                    }, _callee13);
                  }))();
                }
              });

            case 3:
              assertEventElement(t, 1, 'r1', 0, 400, 150, 100);
              t.diag('Update pos out of view -> into view');
              _context17.next = 7;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 1,
                  // Moved event
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14() {
                    return regeneratorRuntime.wrap(function _callee14$(_context14) {
                      while (1) {
                        switch (_context14.prev = _context14.next) {
                          case 0:
                            eventStore.getById(7).startDate = new Date(2019, 4, 27);
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

            case 7:
              assertEventElement(t, 7, 'r1', 0, 50, 150, 100);
              t.diag('Update pos out of view -> out of view');
              _context17.next = 11;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15() {
                    return regeneratorRuntime.wrap(function _callee15$(_context15) {
                      while (1) {
                        switch (_context15.prev = _context15.next) {
                          case 0:
                            eventStore.getById(6).startDate = new Date(2019, 5, 23);
                            _context15.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context15.stop();
                        }
                      }
                    }, _callee15);
                  }))();
                }
              });

            case 11:
              assertEventElement(t, 6, 'r1', undefined, null);
              scheduler.scrollEventIntoView(eventStore.getById(6)); // Need to wait for scroll event, events are updated by that

              _context17.next = 15;
              return scheduler.await('scroll');

            case 15:
              assertEventElement(t, 6, 'r1', 0, 1400, 150, 100, 'after scroll');
              t.diag('Update pos in view -> out of view');
              _context17.next = 19;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 1
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16() {
                    return regeneratorRuntime.wrap(function _callee16$(_context16) {
                      while (1) {
                        switch (_context16.prev = _context16.next) {
                          case 0:
                            eventStore.getById(6).startDate = new Date(2019, 4, 28);
                            _context16.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context16.stop();
                        }
                      }
                    }, _callee16);
                  }))();
                }
              });

            case 19:
              assertEventElement(t, 6, 'r1');
              scheduler.scrollToTop();
              t.waitForSelector('[data-resource-id="r1"][data-event-id="6"]:not(.b-released)', function () {
                assertEventElement(t, 6, 'r1', 75, 100, 75, 100, 'after scroll');
              });

            case 22:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x8) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('CRUD - Update affecting resourceId', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
      return regeneratorRuntime.wrap(function _callee22$(_context22) {
        while (1) {
          switch (_context22.prev = _context22.next) {
            case 0:
              t.diag('Move in view -> in view');
              _context22.next = 3;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 2,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18() {
                    return regeneratorRuntime.wrap(function _callee18$(_context18) {
                      while (1) {
                        switch (_context18.prev = _context18.next) {
                          case 0:
                            eventStore.first.resourceId = 'r2';
                            _context18.next = 3;
                            return scheduler.project.commitAsync();

                          case 3:
                          case "end":
                            return _context18.stop();
                        }
                      }
                    }, _callee18);
                  }))();
                }
              });

            case 3:
              assertEventElement(t, 1, 'r2', 150, 100, 150, 100);
              t.diag('Move in view -> outside of view');
              _context22.next = 7;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 1
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19() {
                    return regeneratorRuntime.wrap(function _callee19$(_context19) {
                      while (1) {
                        switch (_context19.prev = _context19.next) {
                          case 0:
                            eventStore.first.resourceId = 'r9';
                            _context19.next = 3;
                            return scheduler.project.commitAsync();

                          case 3:
                          case "end":
                            return _context19.stop();
                        }
                      }
                    }, _callee19);
                  }))();
                }
              });

            case 7:
              assertEventElement(t, 1, 'r9');
              _context22.next = 10;
              return scheduler.scrollEventIntoView(eventStore.getById(1));

            case 10:
              assertEventElement(t, 1, 'r9', 1200, 100, 150, 100);
              t.diag('Move outside of view -> outside of view');
              _context22.next = 14;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20() {
                    return regeneratorRuntime.wrap(function _callee20$(_context20) {
                      while (1) {
                        switch (_context20.prev = _context20.next) {
                          case 0:
                            eventStore.getById(6).resourceId = 'r2';
                            _context20.next = 3;
                            return scheduler.project.commitAsync();

                          case 3:
                          case "end":
                            return _context20.stop();
                        }
                      }
                    }, _callee20);
                  }))();
                }
              });

            case 14:
              assertEventElement(t, 6, 'r2');
              _context22.next = 17;
              return scheduler.scrollEventIntoView(eventStore.getById(6));

            case 17:
              assertEventElement(t, 6, 'r2', 150, 1250, 150, 100);
              t.diag('Unassign');
              _context22.next = 21;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 1
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21() {
                    return regeneratorRuntime.wrap(function _callee21$(_context21) {
                      while (1) {
                        switch (_context21.prev = _context21.next) {
                          case 0:
                            eventStore.getById(6).resourceId = null;
                            _context21.next = 3;
                            return scheduler.project.commitAsync();

                          case 3:
                          case "end":
                            return _context21.stop();
                        }
                      }
                    }, _callee21);
                  }))();
                }
              });

            case 21:
              assertEventElement(t, 6, 'r2');

            case 22:
            case "end":
              return _context22.stop();
          }
        }
      }, _callee22);
    }));

    return function (_x9) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('CRUD - Replace', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee24(t) {
      return regeneratorRuntime.wrap(function _callee24$(_context24) {
        while (1) {
          switch (_context24.prev = _context24.next) {
            case 0:
              _context24.next = 2;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: '<=5',
                  // Event 2 rerenders, Event 1 changes resource, Event 1 moves in time
                  releaseEvent: '<=1' // TODO: Should be 0, but feel not worth spending time on

                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23() {
                    return regeneratorRuntime.wrap(function _callee23$(_context23) {
                      while (1) {
                        switch (_context23.prev = _context23.next) {
                          case 0:
                            eventStore.add({
                              id: 1,
                              resourceId: 'r2',
                              name: 'Event 1',
                              startDate: new Date(2019, 4, 29),
                              duration: 2
                            });
                            _context23.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context23.stop();
                        }
                      }
                    }, _callee23);
                  }))();
                }
              });

            case 2:
              assertEventElement(t, 1, 'r1');
              assertEventElement(t, 1, 'r2', 150, 150, 150, 100);

            case 4:
            case "end":
              return _context24.stop();
          }
        }
      }, _callee24);
    }));

    return function (_x10) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('CRUD - Changing id', function (t) {
    scheduler.eventStore.first.id = 5000;
    t.selectorExists('[data-event-id="5000"]', 'New id found in DOM');
    t.selectorNotExists('[data-event-id="1"]', 'Old id gone from DOM');
  });
  t.it('Filtering', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee27(t) {
      return regeneratorRuntime.wrap(function _callee27$(_context27) {
        while (1) {
          switch (_context27.prev = _context27.next) {
            case 0:
              t.diag('Applying filter');
              _context27.next = 3;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 2
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee25() {
                    return regeneratorRuntime.wrap(function _callee25$(_context25) {
                      while (1) {
                        switch (_context25.prev = _context25.next) {
                          case 0:
                            eventStore.filter(function (r) {
                              return r.id < 4;
                            });

                          case 1:
                          case "end":
                            return _context25.stop();
                        }
                      }
                    }, _callee25);
                  }))();
                }
              });

            case 3:
              assertEventElement(t, 1, 'r1', 0, 100, 75, 100, ', not filtered out');
              assertEventElement(t, 5, 'r4');
              t.diag('Removing filters');
              _context27.next = 8;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 2,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee26() {
                    return regeneratorRuntime.wrap(function _callee26$(_context26) {
                      while (1) {
                        switch (_context26.prev = _context26.next) {
                          case 0:
                            eventStore.clearFilters();

                          case 1:
                          case "end":
                            return _context26.stop();
                        }
                      }
                    }, _callee26);
                  }))();
                }
              });

            case 8:
              assertEventElement(t, 5, 'r4', 450, 650, 150, 100);

            case 9:
            case "end":
              return _context27.stop();
          }
        }
      }, _callee27);
    }));

    return function (_x11) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Change EventStore', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee29(t) {
      return regeneratorRuntime.wrap(function _callee29$(_context29) {
        while (1) {
          switch (_context29.prev = _context29.next) {
            case 0:
              _context29.next = 2;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 1,
                  releaseEvent: 5 // All assignments are released

                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee28() {
                    return regeneratorRuntime.wrap(function _callee28$(_context28) {
                      while (1) {
                        switch (_context28.prev = _context28.next) {
                          case 0:
                            scheduler.eventStore = new EventStore({
                              data: [{
                                id: 999,
                                name: 'Event 1',
                                resourceId: 'r2',
                                startDate: new Date(2019, 4, 28),
                                duration: 2
                              }]
                            });
                            _context28.next = 3;
                            return t.waitForProjectReady();

                          case 3:
                          case "end":
                            return _context28.stop();
                        }
                      }
                    }, _callee28);
                  }))();
                }
              });

            case 2:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Single event visible');
              assertEventElement(t, 999, 'r2', 150, 100, 150, 100);

            case 4:
            case "end":
              return _context29.stop();
          }
        }
      }, _callee29);
    }));

    return function (_x12) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Should handle batch changes', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee30(t) {
      return regeneratorRuntime.wrap(function _callee30$(_context30) {
        while (1) {
          switch (_context30.prev = _context30.next) {
            case 0:
              eventStore.beginBatch();
              eventStore.first.name = 'Changed';
              eventStore.getById(2).resourceId = 'r2';
              eventStore.endBatch();
              _context30.next = 6;
              return t.waitForProjectReady();

            case 6:
              assertEventElement(t, 1, 'r1', 0, 100, 150, 100);
              assertEventElement(t, 2, 'r2', 150, 150, 75, 200);
              t.selectorExists('[data-event-id="1"]:textEquals(Changed)', 'Text changed');

            case 9:
            case "end":
              return _context30.stop();
          }
        }
      }, _callee30);
    }));

    return function (_x13) {
      return _ref11.apply(this, arguments);
    };
  }());
});