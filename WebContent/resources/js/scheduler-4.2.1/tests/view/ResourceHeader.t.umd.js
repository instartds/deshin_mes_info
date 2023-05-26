function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
  });

  function waitForHeader(_x, _x2, _x3) {
    return _waitForHeader.apply(this, arguments);
  }

  function _waitForHeader() {
    _waitForHeader = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t, resourceId, left) {
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return t.waitFor(function () {
                var headerElement = document.querySelector(".b-resourceheader-cell[data-resource-id=\"".concat(resourceId, "\"]:not(.b-released)")),
                    box = Rectangle.from(headerElement, scheduler.timeAxisColumn.element);
                return Math.abs(box.left - left) <= 1;
              });

            case 2:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));
    return _waitForHeader.apply(this, arguments);
  }

  function assertHeaderElement(t, resourceId) {
    var left = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
    var width = arguments.length > 3 ? arguments[3] : undefined;
    var headerElement = document.querySelector(".b-resourceheader-cell[data-resource-id=\"".concat(resourceId, "\"]:not(.b-released)"));

    if (left === null) {
      t.notOk(headerElement, 'Header element not found for ' + resourceId);
    } else {
      var resourceRecord = scheduler.resourceStore.getById(resourceId);
      t.ok(headerElement, 'Header element found for ' + resourceId);
      var box = Rectangle.from(headerElement, scheduler.timeAxisColumn.element);
      t.isApproxPx(box.left, left, 1, 'At correct x');
      t.isApproxPx(box.width, width, 1, 'Correct width');
      t.contentLike(headerElement, resourceRecord.name, 'Correct text');
    }
  }

  function assertEventElement(t, eventId) {
    var x = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
    var y = arguments.length > 3 ? arguments[3] : undefined;
    var width = arguments.length > 4 ? arguments[4] : undefined;
    var height = arguments.length > 5 ? arguments[5] : undefined;
    var selector = "[data-event-id=\"".concat(eventId, "\"]:not(.b-released)");

    if (x === null) {
      t.selectorNotExists(selector, 'Element not found for event ' + eventId);
    } else {
      var element = document.querySelector(selector);
      t.ok(element, 'Element found for event ' + eventId);
      var box = Rectangle.from(element, scheduler.timeAxisSubGridElement);
      t.isApproxPx(box.x, x, 1, 'Correct x');
      t.isApproxPx(box.y, y, 1, 'Correct y');
      t.isApproxPx(box.width, width, 1, 'Correct width');
      t.isApproxPx(box.height, height, 1, 'Correct height');
    }
  }

  t.it('Initial render', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var i, _i;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getVerticalSchedulerAsync();

            case 2:
              scheduler = _context.sent;

              // 8 initially visible
              for (i = 0; i < 8; i++) {
                assertHeaderElement(t, 'r' + (i + 1), i * 150, 150);
              } // 2 not visible = not rendered


              for (_i = 8; _i < 10; _i++) {
                assertHeaderElement(t, 'r' + (_i + 1));
              }

            case 5:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x4) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Scrolled view', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var i;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getVerticalSchedulerAsync();

            case 2:
              scheduler = _context2.sent;
              scheduler.scrollLeft = 1000;
              _context2.next = 6;
              return scheduler.await('horizontalscroll');

            case 6:
              assertHeaderElement(t, 'r1'); // the rest visible

              for (i = 1; i < 9; i++) {
                assertHeaderElement(t, 'r' + (i + 1), i * 150, 150);
              }

            case 8:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x5) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Displaying icon', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getVerticalSchedulerAsync({
                resources: [{
                  id: 'r1',
                  iconCls: 'b-fa b-fa-bus',
                  name: 'Bus'
                }, {
                  id: 'r2',
                  iconCls: 'b-fa b-fa-car',
                  name: 'Car'
                }]
              });

            case 2:
              scheduler = _context3.sent;
              t.selectorExists('[data-resource-id="r1"] i.b-fa-bus', 'Icon applied to header 1');
              t.selectorExists('[data-resource-id="r2"] i.b-fa-car', 'Icon applied to header 2');
              scheduler.resourceStore.first.iconCls = 'b-fa b-fa-truck';
              t.selectorExists('[data-resource-id="r1"] i.b-fa-truck', 'Icon changed for header 1');

            case 7:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x6) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('columnWidth config', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getVerticalSchedulerAsync({
                resourceColumns: {
                  columnWidth: 50,
                  fillWidth: false
                }
              });

            case 2:
              scheduler = _context4.sent;
              assertHeaderElement(t, 'r2', 50, 50);
              assertEventElement(t, 1, 0, 100, 25, 100);
              scheduler.resourceColumns.columnWidth = 100;
              assertHeaderElement(t, 'r2', 100, 100);
              assertEventElement(t, 1, 0, 100, 50, 100);

            case 8:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x7) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('headerRenderer config, altering config object', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var calledFor, headerEl;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              calledFor = [];
              _context5.next = 3;
              return t.getVerticalSchedulerAsync({
                resourceColumns: {
                  headerRenderer: function headerRenderer(_ref6) {
                    var elementConfig = _ref6.elementConfig,
                        resourceRecord = _ref6.resourceRecord;
                    elementConfig.html = "R".concat(resourceRecord.id);
                    elementConfig.style.backgroundColor = 'rgb(0,0,255)';
                    calledFor.push(resourceRecord);
                  }
                }
              });

            case 3:
              scheduler = _context5.sent;
              t.isDeeply(calledFor, scheduler.resourceStore.getRange(0, 8), 'Called for correct resources');
              headerEl = document.querySelector('.b-resourceheader-cell[data-resource-id="r5"]');
              t.is(headerEl.innerText, 'Rr5', 'Correct text');
              t.is(DomHelper.getStyleValue(headerEl, 'backgroundColor'), 'rgb(0, 0, 255)', 'Correct custom style applied');
              t.is(DomHelper.getStyleValue(headerEl, 'left'), '600px', 'Correct original style applied');

            case 9:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x8) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('headerRenderer config, as template', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var headerEl;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getVerticalSchedulerAsync({
                resourceColumns: {
                  headerRenderer: function headerRenderer(_ref8) {
                    var resourceRecord = _ref8.resourceRecord;
                    return "<div>".concat(resourceRecord.id, "</div>");
                  }
                }
              });

            case 2:
              scheduler = _context6.sent;
              headerEl = document.querySelector('.b-resourceheader-cell[data-resource-id="r5"]');
              t.is(headerEl.innerHTML, '<div>r5</div>', 'Correct html');

            case 5:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x9) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Filling available width', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              if (!(t.browser.msie && new Date() < new Date(2021, 1, 1))) {
                _context8.next = 2;
                break;
              }

              return _context8.abrupt("return");

            case 2:
              t.browser.msie && t.fail('IE11 snoozed test woke up');
              t.setWindowSize(1024 + DomHelper.scrollBarWidth, 768);
              _context8.next = 6;
              return t.getVerticalSchedulerAsync({
                resources: [{
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
              });

            case 6:
              scheduler = _context8.sent;
              t.diag('Fitting to 1024'); //////////////////////////

              assertHeaderElement(t, 'r2', 184, 184);
              assertEventElement(t, 3, 184, 300, 184, 200);
              t.chain( // FFs ResizeObserver seems to be triggered async somehow, have to give it time to settle
              {
                waitFor: 100
              }, function (next) {
                t.diag('Fitting to 1200');
                t.waitForGridEvent(scheduler, 'timelineViewportResize', next);
                t.setWindowSize(1200 + DomHelper.scrollBarWidth, 768);
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                return regeneratorRuntime.wrap(function _callee7$(_context7) {
                  while (1) {
                    switch (_context7.prev = _context7.next) {
                      case 0:
                        _context7.next = 2;
                        return waitForHeader(t, 'r2', 219);

                      case 2:
                        // Wait for animation frame to get rid of Safari ResizeObserver exception
                        //await t.animationFrame();
                        assertHeaderElement(t, 'r2', 219, 219);
                        assertEventElement(t, 3, 219, 300, 219, 200);
                        scheduler.resourceColumns.columnWidth = 100;

                      case 5:
                      case "end":
                        return _context7.stop();
                    }
                  }
                }, _callee7);
              })), function (next) {
                t.diag('Fitting to 400'); /////////////////////////
                // For FFs ResizeObserver to not get mad...

                t.waitForGridEvent(scheduler, 'timelineViewportResize', next);
                t.setWindowSize(400, 768);
              }, function (next) {
                assertHeaderElement(t, 'r2', 100, 100);
                assertEventElement(t, 3, 100, 300, 100, 200); // For FFs ResizeObserver to not get mad...

                t.waitForGridEvent(scheduler, 'timelineViewportResize', next);
                t.setWindowSize(1024, 768);
              });

            case 11:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x10) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Toggling fillWidth', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              t.setWindowSize(1024 + DomHelper.scrollBarWidth, 768);
              _context9.next = 3;
              return t.getVerticalSchedulerAsync({
                resourceColumns: {
                  fillWidth: false
                },
                resources: [{
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
              });

            case 3:
              scheduler = _context9.sent;
              assertHeaderElement(t, 'r2', 150, 150);
              scheduler.resourceColumns.fillWidth = true;
              assertHeaderElement(t, 'r2', 184, 184);
              scheduler.resourceColumns.fillWidth = false;
              assertHeaderElement(t, 'r2', 150, 150);
              t.setWindowSize(1024, 768);

            case 10:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x11) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Fitting available width', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              t.setWindowSize(1024 + DomHelper.scrollBarWidth, 768);
              _context10.next = 3;
              return t.getVerticalSchedulerAsync({
                resourceColumns: {
                  fitWidth: true
                }
              });

            case 3:
              scheduler = _context10.sent;
              t.diag('Initial');
              assertHeaderElement(t, 'r9', 817, 102);
              assertEventElement(t, 3, 102, 300, 102, 200);
              t.diag('Removed one');
              scheduler.resourceStore.first.remove();
              _context10.next = 11;
              return t.waitForProjectReady();

            case 11:
              assertHeaderElement(t, 'r9', 798, 114);
              assertEventElement(t, 3, 0, 300, 114, 200);
              t.diag('Added two');
              scheduler.resourceStore.add([{
                id: 'r10',
                name: 'Resource 10'
              }, {
                id: 'r11',
                name: 'Resource 11'
              }]);
              _context10.next = 17;
              return t.waitForProjectReady();

            case 17:
              assertHeaderElement(t, 'r11', 819, 91);
              assertEventElement(t, 4, 91, 500, 91, 250);
              t.diag('Filtered');
              scheduler.resourceStore.filter(function (r) {
                return parseInt(r.id.substring(1)) < 10;
              });
              assertHeaderElement(t, 'r9', 798, 114);
              assertEventElement(t, 3, 0, 300, 114, 200);
              t.setWindowSize(1024, 768);

            case 24:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x12) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('Toggling fitWidth', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              t.setWindowSize(1024 + DomHelper.scrollBarWidth, 768);
              _context11.next = 3;
              return t.getVerticalSchedulerAsync({
                resourceColumns: {
                  fillWidth: false,
                  fitWidth: false
                }
              });

            case 3:
              scheduler = _context11.sent;
              assertHeaderElement(t, 'r2', 150, 150);
              scheduler.resourceColumns.fitWidth = true;
              assertHeaderElement(t, 'r2', 102, 102);
              scheduler.resourceColumns.fitWidth = false;
              assertHeaderElement(t, 'r2', 150, 150);
              t.setWindowSize(1024, 768);

            case 10:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x13) {
      return _ref13.apply(this, arguments);
    };
  }()); // CRUD is asserted elsewhere

  t.it('Should not instantly reload images with invalid resourceImagePath or defaultResourceImageName', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      var errorCount, checkResourceImages, validPath;
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              errorCount = 0;
              EventHelper.on({
                element: window,
                error: function error() {
                  return errorCount++;
                },
                capture: true
              });

              checkResourceImages = function checkResourceImages(resourceImagePath, defaultResourceImageName, resourceImageExtension, resourceName, checkImageName, expectedNbrOfErrorEvents) {
                return [/*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12() {
                  return regeneratorRuntime.wrap(function _callee12$(_context12) {
                    while (1) {
                      switch (_context12.prev = _context12.next) {
                        case 0:
                          errorCount = 0;
                          _context12.next = 3;
                          return t.getVerticalSchedulerAsync({
                            resources: [{
                              name: resourceName
                            }],
                            defaultResourceImageName: defaultResourceImageName,
                            resourceImagePath: resourceImagePath,
                            resourceImageExtension: resourceImageExtension
                          });

                        case 3:
                          scheduler = _context12.sent;
                          t.diag("path=\"".concat(resourceImagePath, "\" default=\"").concat(defaultResourceImageName, "\" extension=\"").concat(resourceImageExtension, "\" name=\"").concat(resourceName, "\" => ").concat(expectedNbrOfErrorEvents, " error(s)"));

                        case 5:
                        case "end":
                          return _context12.stop();
                      }
                    }
                  }, _callee12);
                })), // If both the resource image and default image fail to load, we show resource initials
                expectedNbrOfErrorEvents === 2 || !defaultResourceImageName && expectedNbrOfErrorEvents === 1 ? {
                  waitForSelector: ".b-resource-initials:contains(".concat(resourceName[0], ")")
                } : {
                  waitForSelector: "img[src=\"".concat(checkImageName, "\"]"),
                  desc: "".concat(checkImageName, " image found")
                }, {
                  waitFor: function waitFor() {
                    return errorCount === expectedNbrOfErrorEvents;
                  },
                  desc: "Expected amount of errors = ".concat(expectedNbrOfErrorEvents)
                }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13() {
                  return regeneratorRuntime.wrap(function _callee13$(_context13) {
                    while (1) {
                      switch (_context13.prev = _context13.next) {
                        case 0:
                          scheduler.destroy();
                          scheduler = null;

                        case 2:
                        case "end":
                          return _context13.stop();
                      }
                    }
                  }, _callee13);
                }))];
              }; // Each resource tries to load image by name and if it fails then loads default one
              // Error count depends on name image and default image existence


              validPath = '../examples/_shared/images/users/';
              t.chain(checkResourceImages(validPath, 'none.png', '.jpg', 'Kate', validPath + 'kate.jpg', 0), checkResourceImages(validPath, 'none.png', '.png', 'Kate', validPath + 'none.png', 1), checkResourceImages(validPath, 'none.png', '.jpg', 'Foo', validPath + 'none.png', 1), checkResourceImages(validPath, 'bad.jpg', '.jpg', 'Foo', validPath + 'bad.jpg', 2), checkResourceImages('', 'none.png', '.jpg', 'Foo', '/none.png', 2), checkResourceImages('..', 'none.png', '.jpg', 'Foo', '../none.png', 2), checkResourceImages('../', 'none.png', '.jpg', 'Foo', '../none.png', 2), checkResourceImages(validPath, 'none.jpg', '.png', 'None', validPath + 'none.png', 0), checkResourceImages('', null, '.png', 'Foo', '/foo.png', 1), checkResourceImages('', undefined, '.png', 'Foo', '/foo.png', 1), checkResourceImages('', '', '.png', 'Foo', '/foo.png', 1));

            case 5:
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
  t.it('Should show image by image and imageUrl resource fields', /*#__PURE__*/function () {
    var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return t.getVerticalSchedulerAsync({
                resourceImagePath: '../examples/_shared/images/users/',
                resources: [{
                  name: 'resource 1',
                  image: 'team.jpg'
                }, {
                  name: 'resource 2',
                  imageUrl: '../examples/_shared/images/users/amit.jpg'
                }],
                columns: [{
                  type: 'resourceInfo'
                }]
              }, 1);

            case 2:
              scheduler = _context15.sent;
              t.chain({
                waitForSelector: 'img[src*="examples/_shared/images/users/team.jpg"]'
              }, {
                waitForSelector: 'img[src*="examples/_shared/images/users/amit.jpg"]'
              });

            case 4:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x15) {
      return _ref17.apply(this, arguments);
    };
  }());
  t.it('Should fire mouse events when clicking a header cell element', function (t) {
    scheduler = t.getVerticalScheduler();
    t.firesOnce(scheduler, 'resourceheaderdblclick');
    t.firesOnce(scheduler, 'resourceheadercontextmenu');
    scheduler.on('resourceheaderclick', function (event) {
      t.is(event.resourceRecord, scheduler.resourceStore.getAt(1));
      t.isInstanceOf(event.event, MouseEvent);
    });
    t.chain({
      dblclick: '.b-resourceheader-cell:contains(Resource 2)'
    }, {
      contextmenu: '.b-resourceheader-cell:contains(Resource 2)'
    }, function (next) {
      t.firesOnce(scheduler, 'resourceheaderclick');
      next();
    }, {
      click: '.b-resourceheader-cell:contains(Resource 2)'
    });
  });
  t.it('Should render initials if resource image fails to load', /*#__PURE__*/function () {
    var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      var eventCount, listener;
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              eventCount = 0, listener = function listener() {
                return eventCount++;
              };
              document.documentElement.addEventListener('error', listener, true);
              scheduler = t.getVerticalScheduler({
                resources: [{
                  name: 'John Wayne'
                }, {
                  name: 'Lil Wayne'
                }, {
                  name: 'Dan'
                }],
                resourceImagePath: '../examples/_shared/images/users/'
              });
              scheduler.resourceStore.first.name = 'John Wayne';
              _context16.next = 6;
              return t.waitForSelector('.b-resource-avatar.b-resource-initials:contains(JW)');

            case 6:
              _context16.next = 8;
              return t.waitForSelector('.b-resource-avatar.b-resource-initials:contains(LW)');

            case 8:
              t.is(eventCount, 2, '2 error events');
              document.documentElement.removeEventListener('error', listener, true);

            case 10:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x16) {
      return _ref18.apply(this, arguments);
    };
  }());
});