function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, renderCount, releaseCount;
  t.beforeEach(function (t) {
    scheduler && !scheduler.isDestroyed && scheduler.destroy();
    renderCount = 0;
    releaseCount = 0;
  });

  function getScheduler() {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17() {
      var config,
          _args17 = arguments;
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              config = _args17.length > 0 && _args17[0] !== undefined ? _args17[0] : {};
              _context17.next = 3;
              return t.getVerticalSchedulerAsync(Object.assign({
                listeners: {
                  renderEvent: function renderEvent() {
                    renderCount++;
                  },
                  releaseEvent: function releaseEvent() {
                    releaseCount++;
                  }
                }
              }, config));

            case 3:
              scheduler = _context17.sent;

            case 4:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));
    return _getScheduler.apply(this, arguments);
  }

  function assertEventElement(t, eventId) {
    var x = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
    var y = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : null;
    var width = arguments.length > 4 && arguments[4] !== undefined ? arguments[4] : null;
    var height = arguments.length > 5 && arguments[5] !== undefined ? arguments[5] : null;
    var msg = arguments.length > 6 && arguments[6] !== undefined ? arguments[6] : '';
    var selector = "[data-event-id=\"".concat(eventId, "\"]:not(.b-released)");

    if (x === null) {
      t.selectorNotExists(selector, "Element not found for ".concat(eventId, " ").concat(msg));
    } else {
      var element = document.querySelector(selector);
      t.ok(element, "Element found for ".concat(eventId, " ").concat(msg));
      var box = Rectangle.from(element, scheduler.timeAxisSubGridElement);
      t.isApprox(box.left, x, 2, 'Correct left');
      t.isApprox(box.top, y, 2, 'Correct top');
      t.isApprox(box.width, width, 2, 'Correct width');
      t.isApprox(box.height, height, 2, 'Correct height');
      t.contentLike(element, "Event ".concat(eventId), 'Correct text');
    }
  }

  function assertHeaderElement(t, resourceId) {
    var left = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
    var msg = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : '';
    var headerElement = document.querySelector(".b-resourceheader-cell[data-resource-id=\"".concat(resourceId, "\"]"));

    if (left === null) {
      t.notOk(headerElement, "Header element not found ".concat(msg));
    } else {
      t.ok(headerElement, "Header element found ".concat(msg));
      headerElement && t.is(Rectangle.from(headerElement, scheduler.timeAxisSubGridElement).left, left, 'At correct x');
    }
  }

  t.it('Initial render', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler();

            case 2:
              t.selectorCountIs(scheduler.eventSelector, 5, 'Five events rendered initially');
              t.is(renderCount, 5, 'Triggered 5 renderEvent initially');
              t.is(releaseCount, 0, 'Triggered 0 releaseEvent initially');
              assertEventElement(t, 1, 0, 100, 75, 100);
              assertEventElement(t, 2, 75, 150, 75, 200);
              assertEventElement(t, 3, 150, 300, 150, 200);
              assertEventElement(t, 4, 300, 500, 150, 250);
              assertEventElement(t, 5, 450, 650, 150, 100);
              assertEventElement(t, 6);
              assertEventElement(t, 7);
              assertEventElement(t, 8);
              assertHeaderElement(t, 'r1', 0);
              assertHeaderElement(t, 'r2', 150);
              assertHeaderElement(t, 'r3', 300);
              assertHeaderElement(t, 'r4', 450);
              assertHeaderElement(t, 'r5', 600);
              assertHeaderElement(t, 'r6', 750);
              assertHeaderElement(t, 'r7', 900);
              assertHeaderElement(t, 'r8', 1050);
              assertHeaderElement(t, 'r9');

            case 22:
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
  t.it('Initial render with rendering after instantiation', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getScheduler({
                appendTo: null
              });

            case 2:
              scheduler.render(document.body);
              t.selectorCountIs(scheduler.eventSelector, 5, 'Five events rendered initially');
              t.is(renderCount, 5, 'Triggered 5 renderEvent initially');
              t.is(releaseCount, 0, 'Triggered 0 releaseEvent initially');
              assertEventElement(t, 1, 0, 100, 75, 100);
              assertEventElement(t, 2, 75, 150, 75, 200);
              assertEventElement(t, 3, 150, 300, 150, 200);
              assertEventElement(t, 4, 300, 500, 150, 250);
              assertEventElement(t, 5, 450, 650, 150, 100);
              assertEventElement(t, 6);
              assertEventElement(t, 7);
              assertEventElement(t, 8);
              assertHeaderElement(t, 'r1', 0);
              assertHeaderElement(t, 'r2', 150);
              assertHeaderElement(t, 'r3', 300);
              assertHeaderElement(t, 'r4', 450);
              assertHeaderElement(t, 'r5', 600);
              assertHeaderElement(t, 'r6', 750);
              assertHeaderElement(t, 'r7', 900);
              assertHeaderElement(t, 'r8', 1050);
              assertHeaderElement(t, 'r9');

            case 23:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8972-crash-in-vertical-mode-if-a-resource-has-no-name-defined/details#

  t.it('Should not crash if a resource has no name', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getScheduler({
                resourceImagePath: './',
                resources: [{}]
              });

            case 2:
              t.pass('rendered ok');

            case 3:
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
  t.it('Scrolling vertically', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return getScheduler();

            case 2:
              scheduler.scrollTop = 1000; // Need to wait for scroll event, events are updated by that

              _context4.next = 5;
              return scheduler.await('scroll');

            case 5:
              t.selectorCountIs(scheduler.eventSelector + ':not(.b-released)', 2, 'Two events rendered after scroll');
              assertEventElement(t, 1);
              assertEventElement(t, 2);
              assertEventElement(t, 3);
              assertEventElement(t, 4);
              assertEventElement(t, 5);
              assertEventElement(t, 6, 0, 1250, 150, 100);
              assertEventElement(t, 7, 0, 1500, 150, 100);
              assertEventElement(t, 8);
              assertHeaderElement(t, 'r1', 0);
              assertHeaderElement(t, 'r2', 150);
              assertHeaderElement(t, 'r3', 300);
              assertHeaderElement(t, 'r4', 450);
              assertHeaderElement(t, 'r5', 600);
              assertHeaderElement(t, 'r6', 750);
              assertHeaderElement(t, 'r7', 900);
              assertHeaderElement(t, 'r8', 1050);
              assertHeaderElement(t, 'r9');

            case 23:
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
  t.it('Scrolling horizontally', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return getScheduler();

            case 2:
              scheduler.scrollTop = 1000;
              _context5.next = 5;
              return scheduler.await('scroll');

            case 5:
              scheduler.scrollLeft = 1000;
              _context5.next = 8;
              return scheduler.await('horizontalscroll');

            case 8:
              t.selectorCountIs(scheduler.eventSelector + ':not(.b-released)', 1, 'One event rendered after scroll');
              t.is(renderCount, 8, 'All 8 events rendered once along the way');
              t.is(releaseCount, 7, '7 of them released');
              assertEventElement(t, 1);
              assertEventElement(t, 2);
              assertEventElement(t, 3);
              assertEventElement(t, 4);
              assertEventElement(t, 5);
              assertEventElement(t, 6);
              assertEventElement(t, 7);
              assertEventElement(t, 8, 1200, 1500, 150, 100);
              assertHeaderElement(t, 'r1');
              assertHeaderElement(t, 'r2', 150);
              assertHeaderElement(t, 'r3', 300);
              assertHeaderElement(t, 'r4', 450);
              assertHeaderElement(t, 'r5', 600);
              assertHeaderElement(t, 'r6', 750);
              assertHeaderElement(t, 'r7', 900);
              assertHeaderElement(t, 'r8', 1050);
              assertHeaderElement(t, 'r9', 1200);

            case 28:
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
  t.it('Resizing viewport', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return getScheduler();

            case 2:
              t.chain(function (next) {
                t.diag('Going small');
                t.waitForGridEvent(scheduler, 'timelineViewportResize', next);
                t.setWindowSize(200, 200);
              }, {
                waitForSelectorNotFound: '[data-event-id="3"]:not(.b-released)'
              }, function (next) {
                assertEventElement(t, 1, 0, 100, 75, 100);
                assertEventElement(t, 2, 75, 150, 75, 200);
                assertEventElement(t, 3);
                assertEventElement(t, 4);
                assertEventElement(t, 5);
                assertEventElement(t, 6);
                assertEventElement(t, 7);
                assertEventElement(t, 8);
                assertEventElement(t, 1, 0, 100, 75, 100);
                assertEventElement(t, 2, 75, 150, 75, 200);
                assertEventElement(t, 3);
                assertEventElement(t, 4);
                assertEventElement(t, 5);
                assertEventElement(t, 6);
                assertEventElement(t, 7);
                assertEventElement(t, 8);
                t.diag('Going big');
                t.waitForGridEvent(scheduler, 'timelineViewportResize', next);
                t.setWindowSize(1024, 768);
              }, {
                waitForSelector: '[data-event-id="3"]:not(.b-released)'
              }, function () {
                assertEventElement(t, 1, 0, 100, 75, 100);
                assertEventElement(t, 2, 75, 150, 75, 200);
                assertEventElement(t, 3, 150, 300, 150, 200);
                assertEventElement(t, 4, 300, 500, 150, 250);
                assertEventElement(t, 5, 450, 650, 150, 100);
                assertEventElement(t, 6);
                assertEventElement(t, 7);
                assertEventElement(t, 8);
                assertHeaderElement(t, 'r1', 0);
                assertHeaderElement(t, 'r2', 150);
                assertHeaderElement(t, 'r3', 300);
                assertHeaderElement(t, 'r4', 450);
                assertHeaderElement(t, 'r5', 600);
                assertHeaderElement(t, 'r6', 750);
                assertHeaderElement(t, 'r7', 900);
                assertHeaderElement(t, 'r8', 1050);
                assertHeaderElement(t, 'r9');
              });

            case 3:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Extending timespan', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return getScheduler();

            case 2:
              t.diag('Extending end');
              scheduler.setTimeSpan(new Date(2019, 5, 1), new Date(2019, 7, 1));
              t.isApprox(scheduler.timeAxisSubGridElement.offsetHeight, 3501, 'Correct height');
              scheduler.scrollable.y = scheduler.scrollable.maxY;
              _context7.next = 8;
              return scheduler.await('scroll');

            case 8:
              assertEventElement(t, 1001, 0, 2750, 150, 100);
              t.diag('Extending start');
              scheduler.setTimeSpan(new Date(2019, 4, 1), new Date(2019, 7, 1));
              t.isApprox(scheduler.timeAxisSubGridElement.offsetHeight, 4900, 'Correct height');
              scheduler.scrollable.y = 0;
              _context7.next = 15;
              return scheduler.await('scroll');

            case 15:
              assertEventElement(t, 1000, 0, 600, 150, 100);

            case 16:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x7) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Complex scenario', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return getScheduler({
                eventStyle: 'border',
                events: [{
                  id: 1,
                  name: 'Event 1',
                  resourceId: 'r1',
                  startDate: new Date(2019, 4, 27),
                  duration: 8
                }, {
                  id: 2,
                  name: 'Event 2',
                  resourceId: 'r1',
                  startDate: new Date(2019, 4, 28),
                  duration: 9
                }, {
                  id: 3,
                  name: 'Event 3',
                  resourceId: 'r1',
                  startDate: new Date(2019, 4, 29),
                  duration: 5
                }, {
                  id: 4,
                  name: 'Event 4',
                  resourceId: 'r1',
                  startDate: new Date(2019, 5, 3),
                  duration: 7
                }]
              });

            case 2:
              assertEventElement(t, 1, 0, 50, 50, 400);
              assertEventElement(t, 2, 50, 100, 50, 450);
              assertEventElement(t, 3, 100, 150, 50, 250);
              assertEventElement(t, 4, 100, 400, 50, 350);

            case 6:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x8) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Complex scenario, with barMargin', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return getScheduler({
                barMargin: 5,
                events: [{
                  id: 1,
                  name: 'Event 1',
                  resourceId: 'r1',
                  startDate: new Date(2019, 4, 27),
                  duration: 8
                }, {
                  id: 2,
                  name: 'Event 2',
                  resourceId: 'r1',
                  startDate: new Date(2019, 4, 28),
                  duration: 9
                }, {
                  id: 3,
                  name: 'Event 3',
                  resourceId: 'r1',
                  startDate: new Date(2019, 4, 29),
                  duration: 5
                }, {
                  id: 4,
                  name: 'Event 4',
                  resourceId: 'r1',
                  startDate: new Date(2019, 5, 3),
                  duration: 7
                }]
              });

            case 2:
              assertEventElement(t, 1, 5, 50, 43, 400);
              assertEventElement(t, 2, 53, 100, 43, 450);
              assertEventElement(t, 3, 101, 150, 43, 250);
              assertEventElement(t, 4, 101, 400, 43, 350);

            case 6:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x9) {
      return _ref9.apply(this, arguments);
    };
  }()); // pack is the default and tested in all other tests, no need to test here again...

  t.it('eventLayout: none', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return getScheduler({
                eventLayout: 'none'
              });

            case 2:
              assertEventElement(t, 1, 0, 100, 150, 100);
              assertEventElement(t, 2, 0, 150, 150, 200); // Should not change

              assertEventElement(t, 3, 150, 300, 150, 200); // Should not change

              scheduler.eventStore.first.resourceId = 'r2';
              scheduler.eventStore.first.startDate = new Date(2019, 4, 31);
              _context10.next = 9;
              return t.waitForProjectReady();

            case 9:
              assertEventElement(t, 1, 150, 250, 150, 100);
              assertEventElement(t, 2, 0, 150, 150, 200);
              assertEventElement(t, 3, 150, 300, 150, 200);

            case 12:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x10) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('eventLayout: mixed', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              t.diag('Initial');
              _context11.next = 3;
              return getScheduler({
                eventLayout: 'mixed'
              });

            case 3:
              // E1 & E2 overlaps
              assertEventElement(t, 1, 0, 100, 150, 100);
              assertEventElement(t, 2, 15, 150, 135, 200);
              assertEventElement(t, 3, 150, 300, 150, 200);
              t.diag('Overlap');
              scheduler.eventStore.first.resourceId = 'r2';
              scheduler.eventStore.first.startDate = new Date(2019, 4, 31);
              _context11.next = 11;
              return scheduler.project.commitAsync();

            case 11:
              // E1 & E3 overlaps
              assertEventElement(t, 1, 150, 250, 150, 100);
              assertEventElement(t, 2, 0, 150, 150, 200);
              assertEventElement(t, 3, 165, 300, 135, 200);
              t.diag('Pack');
              scheduler.eventStore.getAt(1).resourceId = 'r2';
              _context11.next = 18;
              return scheduler.project.commitAsync();

            case 18:
              // All 3 overlaps = pack
              assertEventElement(t, 1, 200, 250, 50, 100);
              assertEventElement(t, 2, 150, 150, 50, 200);
              assertEventElement(t, 3, 250, 300, 50, 200);
              t.diag('Overlap');
              scheduler.eventStore.getAt(2).remove();
              _context11.next = 25;
              return scheduler.project.commitAsync();

            case 25:
              // Back to overlap
              assertEventElement(t, 1, 165, 250, 135, 100);
              assertEventElement(t, 2, 150, 150, 150, 200);
              assertEventElement(t, 3);

            case 28:
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
  t.it('resourceMargin', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              t.it('Only resourceMargin', /*#__PURE__*/function () {
                var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
                  return regeneratorRuntime.wrap(function _callee12$(_context12) {
                    while (1) {
                      switch (_context12.prev = _context12.next) {
                        case 0:
                          _context12.next = 2;
                          return getScheduler({
                            resourceMargin: 10
                          });

                        case 2:
                          assertEventElement(t, 1, 10, 100, 65, 100);
                          assertEventElement(t, 2, 75, 150, 65, 200);
                          assertEventElement(t, 3, 160, 300, 130, 200);

                        case 5:
                        case "end":
                          return _context12.stop();
                      }
                    }
                  }, _callee12);
                }));

                return function (_x13) {
                  return _ref13.apply(this, arguments);
                };
              }());
              t.it('resourceMargin + barMargin', /*#__PURE__*/function () {
                var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
                  return regeneratorRuntime.wrap(function _callee13$(_context13) {
                    while (1) {
                      switch (_context13.prev = _context13.next) {
                        case 0:
                          _context13.next = 2;
                          return getScheduler({
                            resourceMargin: 10,
                            barMargin: 5
                          });

                        case 2:
                          assertEventElement(t, 1, 10, 100, 62.5, 100);
                          assertEventElement(t, 2, 77.5, 150, 62.5, 200);
                          assertEventElement(t, 3, 160, 300, 130, 200);

                        case 5:
                        case "end":
                          return _context13.stop();
                      }
                    }
                  }, _callee13);
                }));

                return function (_x14) {
                  return _ref14.apply(this, arguments);
                };
              }());

            case 2:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x12) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('Should adjust canvas height when suppressing fit and not filling height', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return getScheduler({
                startDate: new Date(2019, 4, 28, 7),
                // 3 ticks
                endDate: new Date(2019, 4, 28, 10),
                viewPreset: 'hourAndDay',
                tickSize: 80,
                suppressFit: true
              });

            case 2:
              t.is(scheduler.foregroundCanvas.offsetHeight, 3 * 80, 'Canvas has correct height');
              scheduler.tickSize = 100;
              t.is(scheduler.foregroundCanvas.offsetHeight, 3 * 100, 'Canvas has correct height');

            case 5:
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
  t.it('Should return visible resources', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return getScheduler({
                width: 500
              });

            case 2:
              t.isDeeply(scheduler.visibleResources, {
                first: scheduler.resourceStore.first,
                last: scheduler.resourceStore.getAt(2)
              }, 'All resources visible');
              scheduler.width = 200;
              _context16.next = 6;
              return t.waitFor(function () {
                return scheduler.visibleResources.first === scheduler.visibleResources.last;
              });

            case 6:
              t.isDeeply(scheduler.visibleResources, {
                first: scheduler.resourceStore.first,
                last: scheduler.resourceStore.first
              }, 'First resource visible only');
              scheduler.scrollLeft = 5000;
              _context16.next = 10;
              return t.waitFor(function () {
                return scheduler.visibleResources.first === scheduler.resourceStore.last;
              });

            case 10:
              t.isDeeply(scheduler.visibleResources, {
                first: scheduler.resourceStore.last,
                last: scheduler.resourceStore.last
              }, 'Last resource visible only');

            case 11:
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