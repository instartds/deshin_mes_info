function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, resourceStore;

  function createScheduler(_x) {
    return _createScheduler.apply(this, arguments);
  } // async beforeEach doesn't work in umd


  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee24(config) {
      return regeneratorRuntime.wrap(function _callee24$(_context24) {
        while (1) {
          switch (_context24.prev = _context24.next) {
            case 0:
              _context24.next = 2;
              return t.getVerticalSchedulerAsync(Object.assign({
                resourceColumns: {
                  fillWidth: false,
                  fitWidth: false
                }
              }, config));

            case 2:
              scheduler = _context24.sent;
              resourceStore = scheduler.resourceStore;

            case 4:
            case "end":
              return _context24.stop();
          }
        }
      }, _callee24);
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
      t.selectorNotExists(selector, "Element found for event ".concat(eventId, " ").concat(msg));
    } else {
      var element = document.querySelector(selector),
          box = element && Rectangle.from(element, scheduler.timeAxisSubGridElement);

      if (element) {
        t.selectorExists(selector, "Element found for event ".concat(eventId, " ").concat(msg));
        t.is(box.top, y, 'Correct top');
        t.is(box.left, x, 'Correct left');
        t.is(box.width, width, 'Correct width');
        t.is(box.height, height, 'Correct height');
      } else {
        t.fail("Element for event ".concat(eventId, " not found"));
      }
    }
  }

  function assertHeaderElement(t, resourceId) {
    var left = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
    var msg = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : '';
    var headerElement = document.querySelector(".b-resourceheader-cell[data-resource-id=\"".concat(resourceId, "\"]"));

    if (left === null) {
      t.notOk(headerElement, 'Header element not found ' + msg);
    } else {
      t.ok(headerElement, 'Header element found ' + msg);
      headerElement && t.isApprox(Rectangle.from(headerElement, scheduler.timeAxisSubGridElement).left, left, 0.5, 'At correct x');
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
                  renderEvent: 5,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                    return regeneratorRuntime.wrap(function _callee2$(_context2) {
                      while (1) {
                        switch (_context2.prev = _context2.next) {
                          case 0:
                            resourceStore.insert(0, {
                              id: 'r100',
                              name: 'Resource 100'
                            });
                            _context2.next = 3;
                            return scheduler.project.commitAsync();

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
              assertHeaderElement(t, 'r100', 0);
              assertEventElement(t, 1, 'r1', 150, 100, 75, 100);
              t.diag('Add outside of view');
              _context4.next = 8;
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
                            resourceStore.add({
                              id: 'r101',
                              name: 'Resource 101'
                            });
                            _context3.next = 3;
                            return scheduler.project.commitAsync();

                          case 3:
                          case "end":
                            return _context3.stop();
                        }
                      }
                    }, _callee3);
                  }))();
                }
              });

            case 8:
              assertHeaderElement(t, 'r101');
              assertEventElement(t, 1, 'r1', 150, 100, 75, 100); // Did not move

              t.chain(function (next) {
                t.waitForEvent(scheduler, 'horizontalscroll', next);
                scheduler.scrollLeft = 1000;
              }, function () {
                assertHeaderElement(t, 'r101', 1500, 'after scroll');
              });

            case 11:
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
                  renderEvent: 3,
                  releaseEvent: 2
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
                    return regeneratorRuntime.wrap(function _callee5$(_context5) {
                      while (1) {
                        switch (_context5.prev = _context5.next) {
                          case 0:
                            resourceStore.first.remove();
                            _context5.next = 3;
                            return scheduler.project.commitAsync();

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
              assertHeaderElement(t, 'r1');
              assertEventElement(t, 1, 'r1');
              assertEventElement(t, 3, 'r2', 0, 300, 150, 200);
              t.diag('Remove from outside of view');
              _context7.next = 9;
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
                            resourceStore.remove('r9');
                            _context6.next = 3;
                            return scheduler.project.commitAsync();

                          case 3:
                          case "end":
                            return _context6.stop();
                        }
                      }
                    }, _callee6);
                  }))();
                }
              });

            case 9:
              scheduler.scrollLeft = 1000;
              _context7.next = 12;
              return scheduler.await('horizontalscroll');

            case 12:
              assertHeaderElement(t, 'r9', null, ' after scroll');
              assertEventElement(t, 8, 'r9');

            case 14:
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
                            resourceStore.removeAll();
                            _context8.next = 3;
                            return scheduler.project.commitAsync();

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
              t.selectorNotExists('.b-sch-event-wrap:not(.b-released)', 'No event elements visible');
              t.selectorNotExists('.b-resourceheader-cell:not(b-released)', 'No resource headers visible');

            case 4:
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
  t.it('CRUD - Update', /*#__PURE__*/function () {
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
                  renderEvent: 0,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10() {
                    return regeneratorRuntime.wrap(function _callee10$(_context10) {
                      while (1) {
                        switch (_context10.prev = _context10.next) {
                          case 0:
                            resourceStore.first.name = 'First';

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
              t.selectorExists('[data-resource-id="r1"]:contains(First)', 'Updated');
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
                            resourceStore.last.name = 'Last';

                          case 1:
                          case "end":
                            return _context11.stop();
                        }
                      }
                    }, _callee11);
                  }))();
                }
              });

            case 7:
              scheduler.scrollResourceIntoView(resourceStore.last); // Need to wait for scroll event, events are updated by that

              _context12.next = 10;
              return scheduler.await('horizontalscroll');

            case 10:
              t.selectorExists('[data-resource-id="r9"]:contains(Last)', 'Element found after scroll');

            case 11:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x7) {
      return _ref5.apply(this, arguments);
    };
  }()); // TODO: Nick

  t.it('CRUD - Replace', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _context14.next = 2;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 0,
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13() {
                    return regeneratorRuntime.wrap(function _callee13$(_context13) {
                      while (1) {
                        switch (_context13.prev = _context13.next) {
                          case 0:
                            resourceStore.add({
                              id: 'r1',
                              name: 'Replaced'
                            });
                            _context13.next = 3;
                            return scheduler.project.commitAsync();

                          case 3:
                          case "end":
                            return _context13.stop();
                        }
                      }
                    }, _callee13);
                  }))();
                }
              });

            case 2:
              t.selectorExists('[data-resource-id="r1"]:contains(Replaced)', 'Updated');

            case 3:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x8) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('CRUD - Changing id', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              scheduler.resourceStore.first.id = 'r5000';
              _context15.next = 3;
              return t.waitForProjectReady(scheduler);

            case 3:
              t.selectorExists('.b-resourceheader-cell[data-resource-id="r5000"]:contains(Resource 1)', 'Header updated'); // Should be gone

              assertEventElement(t, 1, 'r1');
              assertEventElement(t, 2, 'r1'); // Should instead find

              assertEventElement(t, 1, 'r5000', 0, 100, 75, 100);
              assertEventElement(t, 2, 'r5000', 75, 150, 75, 200);

            case 8:
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
  t.it('Filtering', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              t.diag('Applying filter');
              _context18.next = 3;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 1,
                  // Event on r4 moves to the left when r3 hides
                  releaseEvent: 1 // Event on r3 hides

                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16() {
                    return regeneratorRuntime.wrap(function _callee16$(_context16) {
                      while (1) {
                        switch (_context16.prev = _context16.next) {
                          case 0:
                            resourceStore.filter(function (r) {
                              return ['r1', 'r2', 'r4'].includes(r.id);
                            });

                          case 1:
                          case "end":
                            return _context16.stop();
                        }
                      }
                    }, _callee16);
                  }))();
                }
              });

            case 3:
              assertEventElement(t, 3, 'r2', 150, 300, 150, 200);
              assertEventElement(t, 4, 'r3');
              assertEventElement(t, 5, 'r4', 300, 650, 150, 100);
              assertHeaderElement(t, 'r1', 0);
              assertHeaderElement(t, 'r2', 150);
              assertHeaderElement(t, 'r4', 300);
              t.diag('Removing filters');
              _context18.next = 12;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 2,
                  // Event on r4 moves to the right when r3 is shown + event on r3
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17() {
                    return regeneratorRuntime.wrap(function _callee17$(_context17) {
                      while (1) {
                        switch (_context17.prev = _context17.next) {
                          case 0:
                            resourceStore.clearFilters();

                          case 1:
                          case "end":
                            return _context17.stop();
                        }
                      }
                    }, _callee17);
                  }))();
                }
              });

            case 12:
              assertEventElement(t, 4, 'r3', 300, 500, 150, 250);
              assertHeaderElement(t, 'r1', 0);
              assertHeaderElement(t, 'r2', 150);
              assertHeaderElement(t, 'r3', 300);
              assertHeaderElement(t, 'r4', 450);

            case 17:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    }));

    return function (_x10) {
      return _ref8.apply(this, arguments);
    };
  }()); // TODO: Nick

  t.it('Change ResourceStore', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(t) {
      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              _context20.next = 2;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 1,
                  releaseEvent: 4
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19() {
                    return regeneratorRuntime.wrap(function _callee19$(_context19) {
                      while (1) {
                        switch (_context19.prev = _context19.next) {
                          case 0:
                            scheduler.resourceStore = new ResourceStore({
                              data: [{
                                id: 'r2',
                                name: 'New 1'
                              }]
                            });
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

            case 2:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Single event visible');
              assertHeaderElement(t, 'r2', 0);
              assertEventElement(t, 3, 'r2', 0, 300, 150, 200);

            case 5:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    }));

    return function (_x11) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Sorting', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
      return regeneratorRuntime.wrap(function _callee22$(_context22) {
        while (1) {
          switch (_context22.prev = _context22.next) {
            case 0:
              _context22.next = 2;
              return t.firesOk({
                observable: scheduler,
                events: {
                  renderEvent: 4,
                  // r3 is unaffected by the sort, thus not 5
                  releaseEvent: 0
                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21() {
                    return regeneratorRuntime.wrap(function _callee21$(_context21) {
                      while (1) {
                        switch (_context21.prev = _context21.next) {
                          case 0:
                            scheduler.resourceStore.sort('location');

                          case 1:
                          case "end":
                            return _context21.stop();
                        }
                      }
                    }, _callee21);
                  }))();
                }
              });

            case 2:
              t.chain(function (next) {
                assertHeaderElement(t, 'r8', 0);
                assertHeaderElement(t, 'r1', 150);
                assertHeaderElement(t, 'r3', 300);
                assertHeaderElement(t, 'r5', 450);
                assertHeaderElement(t, 'r7', 600);
                assertHeaderElement(t, 'r9', 750);
                assertHeaderElement(t, 'r2', 900);
                assertHeaderElement(t, 'r4', 1050);
                assertHeaderElement(t, 'r6'); // Out of view, not yet rendered

                scheduler.scrollResourceIntoView(scheduler.resourceStore.getById('r6'));
                next();
              }, {
                waitForEvent: [scheduler, 'horizontalscroll']
              }, function () {
                assertHeaderElement(t, 'r8'); // Out of view, released

                assertHeaderElement(t, 'r1', 150);
                assertHeaderElement(t, 'r3', 300);
                assertHeaderElement(t, 'r5', 450);
                assertHeaderElement(t, 'r7', 600);
                assertHeaderElement(t, 'r9', 750);
                assertHeaderElement(t, 'r2', 900);
                assertHeaderElement(t, 'r4', 1050);
                assertHeaderElement(t, 'r6', 1200);
              });

            case 3:
            case "end":
              return _context22.stop();
          }
        }
      }, _callee22);
    }));

    return function (_x12) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Grouping not yet supported', function (t) {
    t.throwsOk(function () {
      scheduler.resourceStore.group('location');
    }, 'Grouping of resources not supported in vertical mode');
  }); // https://github.com/bryntum/support/issues/2519

  t.it('Should clear view completely if filter includes no resources', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23(t) {
      return regeneratorRuntime.wrap(function _callee23$(_context23) {
        while (1) {
          switch (_context23.prev = _context23.next) {
            case 0:
              _context23.next = 2;
              return t.waitForSelector('.b-resourceheader-cell');

            case 2:
              scheduler.resourceStore.filter(function () {
                return false;
              });
              t.selectorNotExists('.b-resourceheader-cell', 'No resources rendered');
              scheduler.resourceStore.clearFilters();
              t.selectorCountIs('.b-resourceheader', 1, 'Resource header rendered');
              t.selectorCountIs('.b-resourceheader-cell', 8, 'Resource cells rendered');

            case 7:
            case "end":
              return _context23.stop();
          }
        }
      }, _callee23);
    }));

    return function (_x13) {
      return _ref11.apply(this, arguments);
    };
  }());
});