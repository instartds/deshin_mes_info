function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr == null ? null : typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]; if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;

  function getScheduler() {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17() {
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return t.getVerticalSchedulerAsync({
                features: {
                  eventMenu: true,
                  eventDragCreate: false,
                  // Disabled to be able to use EventDragSelect
                  eventDragSelect: true,
                  resourceTimeRanges: true,
                  timeRanges: true
                }
              });

            case 2:
              return _context17.abrupt("return", scheduler = _context17.sent);

            case 3:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.beforeEach(function () {
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });

  function assertEventElement(t, event) {
    var top = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
    var left = arguments.length > 3 ? arguments[3] : undefined;
    var width = arguments.length > 4 ? arguments[4] : undefined;
    var height = arguments.length > 5 ? arguments[5] : undefined;
    var msg = arguments.length > 6 && arguments[6] !== undefined ? arguments[6] : '';
    var selector = "[data-event-id=\"".concat(event.id, "\"]:not(.b-released)");

    if (top === null) {
      t.selectorNotExists(selector, 'Element not found ' + msg);
    } else {
      var element = document.querySelector(selector);
      t.ok(element, 'Element found ' + msg);
      var box = Rectangle.from(element, scheduler.timeAxisSubGridElement);
      t.is(box.top, top, 'Correct top');
      t.is(box.left, left, 'Correct left');
      t.is(box.width, width, 'Correct width');
      t.is(box.height, height, 'Correct height');
    }
  } // Dependencies not supported by vertical
  // DependencyEdit not supported by vertical


  t.it('EventMenu sanity', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context.sent;
              t.chain({
                rightClick: '[data-event-id="1"]'
              }, {
                waitForSelector: ':contains(Edit event)'
              });

            case 4:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }()); // EventDrag tested in VerticalEventDrag.t.js
  // EventDragCreate tested in VerticalEventDragCreate.t.js

  t.it('EventDragSelect sanity', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context2.sent;
              t.chain({
                moveMouseTo: [400, 50]
              }, {
                drag: '.b-sch-timeaxis-cell',
                offset: [50, 50],
                by: [150, 300]
              }, function () {
                t.isDeeply(scheduler.selectedEvents, scheduler.eventStore.getRange(0, 3), 'Correct selection');
                t.selectorExists('[data-event-id="1"] .b-sch-event-selected', 'Element 1 has selection cls');
                t.selectorExists('[data-event-id="2"] .b-sch-event-selected', 'Element 1 has selection cls');
                t.selectorExists('[data-event-id="3"] .b-sch-event-selected', 'Element 1 has selection cls');
              });

            case 4:
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
  t.it('EventEdit sanity', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context3.sent;
              t.chain({
                dblClick: '[data-event-id="1"]'
              }, {
                click: '[data-ref="nameField"]'
              }, {
                type: 'Hello',
                clearExisting: true
              }, {
                click: 'button:contains(Save)'
              }, function () {
                t.selectorExists('[data-event-id="1"]:textEquals(Hello)', 'Text updated');
              });

            case 4:
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
  t.it('EventFilter sanity', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context4.sent;
              t.chain({
                rightClick: '.b-resourceheader-cell'
              }, {
                moveMouseTo: '.b-menuitem:contains(Filter)'
              }, {
                click: '.b-eventfilter input'
              }, {
                type: 'Event 1[ENTER]',
                clearExisting: true
              }, function () {
                t.selectorCountIs('.b-sch-event-wrap', 1, 'Single event element visible');
              });

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }()); // EventResize is tested in VerticalEventResize.t.js

  t.it('EventTooltip sanity', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context5.sent;
              t.chain({
                moveMouseTo: '.b-sch-event'
              }, {
                waitForSelector: '.b-sch-event-tooltip'
              });

            case 4:
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
  t.it('TimeAxisHeaderMenu sanity', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context6.sent;
              t.chain({
                rightClick: '.b-resourceheader-cell'
              }, {
                waitForSelector: ':contains(Zoom)'
              });

            case 4:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref6.apply(this, arguments);
    };
  }()); // TODO: NonWorkingTime

  t.it('Pan sanity', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              scheduler = t.getVerticalScheduler({
                features: {
                  eventDragCreate: false,
                  pan: true
                }
              });
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                offset: [400, 400],
                by: [-200, -150]
              }, function () {
                t.isApproxPx(scheduler.scrollLeft, 200, 'Correct scrollLeft');
                t.isApproxPx(scheduler.scrollTop, 150, 'Correct scrollTop');
              });

            case 2:
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
  t.it('ResourceTimeRanges sanity', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var element, box;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context8.sent;
              element = document.querySelector('.b-sch-resourcetimerange'), box = Rectangle.from(element, scheduler.timeAxisSubGridElement);
              t.is(box.left, 300, 'Correct left');
              t.is(box.top, 100, 'Correct top');
              t.is(box.width, 150, 'Correct width');
              t.is(box.height, 500, 'Correct height');

            case 8:
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
  t.it('ScheduleMenu sanity', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context9.sent;
              t.chain({
                rightClick: '.b-sch-timeaxis-cell',
                offset: [200, 60]
              }, {
                click: '.b-menuitem:contains(Add event)'
              }, {
                waitFor: function waitFor() {
                  return scheduler.features.eventEdit.editor.containsFocus;
                }
              }, {
                type: 'New test event'
              }, {
                click: 'button:contains(Save)'
              }, function () {
                assertEventElement(t, scheduler.eventStore.last, 50, 150, 150, 50);
              });

            case 4:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x9) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('ScheduleTooltip sanity', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context10.sent;
              t.chain({
                moveMouseTo: [300, 100]
              }, {
                waitForSelector: '.b-sch-scheduletip'
              }, function () {
                t.selectorExists('.b-sch-clock-text:textEquals(May 27, 2019)', 'Correct text in tip');
              });

            case 4:
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
  t.it('SimpleEventEdit sanity', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context11.sent;
              scheduler && scheduler.destroy();
              scheduler = t.getVerticalScheduler({
                features: {
                  eventEdit: false,
                  simpleEventEdit: true
                }
              });
              t.chain({
                dblClick: '[data-event-id="1"]'
              }, {
                type: 'Hello[ENTER]',
                clearExisting: true
              }, function () {
                t.selectorExists('[data-event-id="1"]:textEquals(Hello)', 'Text updated');
              });

            case 6:
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
  t.it('TimeRanges sanity', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      var _Array$from$map, _Array$from$map2, headerRange, bodyRange, _Array$from$map3, _Array$from$map4, headerLine, bodyLine;

      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context12.sent;
              _Array$from$map = Array.from(document.querySelectorAll('.b-sch-range')).map(function (el) {
                return Rectangle.from(el, scheduler.timeAxisSubGridElement);
              }), _Array$from$map2 = _slicedToArray(_Array$from$map, 2), headerRange = _Array$from$map2[0], bodyRange = _Array$from$map2[1];
              _Array$from$map3 = Array.from(document.querySelectorAll('.b-sch-line')).map(function (el) {
                return Rectangle.from(el, scheduler.timeAxisSubGridElement);
              }), _Array$from$map4 = _slicedToArray(_Array$from$map3, 2), headerLine = _Array$from$map4[0], bodyLine = _Array$from$map4[1];
              t.is(headerRange.top, 150, 'Range header y correct');
              t.is(bodyRange.top, 150, 'Range body y correct');
              t.is(headerRange.height, 200, 'Range header height correct');
              t.is(bodyRange.height, 200, 'Range body height correct');
              t.is(bodyRange.width, 1350, 'Range body width correct');
              t.is(headerLine.top, 550, 'Line header y correct');
              t.is(bodyLine.top, 550, 'Line body y correct'); // Not checking header, since it has a label

              t.is(bodyLine.height, 2, 'Line body height correct');
              t.is(bodyLine.width, 1350, 'Line body width correct');

            case 14:
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
  t.it('Should show both vertical and horizontal column lines', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      var expectedInitialOffsets, initialOffsets, expectedOffsets, offsets;
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return getScheduler();

            case 2:
              scheduler = _context13.sent;
              _context13.next = 5;
              return t.waitForAnimationFrame();

            case 5:
              t.selectorCountIs('.b-column-line-major', 2);
              t.selectorCountIs('.b-column-line', 20);
              t.selectorCountIs('.b-resource-column-line', 8); // 0 - 7

              expectedInitialOffsets = [149, 299, 449, 599, 749, 899, 1049, 1199], initialOffsets = t.query('.b-resource-column-line').map(function (line) {
                return DomHelper.getTranslateX(line);
              });
              t.isDeeply(initialOffsets, expectedInitialOffsets, 'Correct positions initially');
              _context13.next = 12;
              return scheduler.scrollResourceIntoView(scheduler.resourceStore.last, {
                animate: false
              });

            case 12:
              _context13.next = 14;
              return t.waitForAnimationFrame();

            case 14:
              _context13.next = 16;
              return t.waitForAnimationFrame();

            case 16:
              // 1 - 8
              expectedOffsets = [1349, 299, 449, 599, 749, 899, 1049, 1199], offsets = t.query('.b-resource-column-line').map(function (line) {
                return DomHelper.getTranslateX(line);
              });
              t.isDeeply(offsets, expectedOffsets, 'Correct positions after scroll');

            case 18:
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
  t.it('Should support undo / redo after resource change in vertical mode with string ids', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      var stm, origLeft, newLeft;
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              scheduler = t.getScheduler({
                appendTo: document.body,
                mode: 'vertical',
                barMargin: 0,
                tbar: [{
                  type: 'undoredo'
                }],
                project: {
                  stm: {
                    autoRecord: true
                  }
                },
                resources: [{
                  id: 'r1',
                  name: 'foo'
                }, {
                  id: 'r2',
                  name: 'bar'
                }, {}, {}, {}, {}],
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  duration: 1,
                  name: 'foo'
                }]
              });
              _context14.next = 3;
              return scheduler.project.commitAsync();

            case 3:
              stm = scheduler.project.stm, origLeft = t.rect('.b-sch-event').left;
              stm.enable();
              _context14.next = 7;
              return t.dragBy('.b-sch-event:contains(foo)', [100, 0]);

            case 7:
              _context14.next = 9;
              return t.waitForAnimations();

            case 9:
              newLeft = t.rect('.b-sch-event').left;
              stm.undo();
              _context14.next = 13;
              return t.waitFor(function () {
                return t.rect('.b-sch-event').left === origLeft;
              });

            case 13:
              t.is(t.rect('.b-sch-event').left, origLeft, 'Undone paint ok');
              t.is(scheduler.eventStore.first.resourceId, 'r1', 'Undone ok');
              _context14.next = 17;
              return t.waitFor(function () {
                return stm.isReady;
              });

            case 17:
              stm.redo();
              _context14.next = 20;
              return t.waitFor(function () {
                return t.rect('.b-sch-event').left === newLeft;
              });

            case 20:
              t.is(scheduler.eventStore.first.resourceId, 'r2', 'Redone ok');
              t.is(t.rect('.b-sch-event').left, newLeft, 'Redone paint ok');

            case 22:
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
  t.it('Should support undo / redo after resource change in vertical mode with number ids', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      var stm, origLeft;
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              scheduler = t.getScheduler({
                appendTo: document.body,
                mode: 'vertical',
                barMargin: 0,
                width: 400,
                tbar: [{
                  type: 'undoredo'
                }],
                project: {
                  stm: {
                    autoRecord: true
                  }
                },
                resources: [{
                  id: 1,
                  name: 'foo'
                }, {
                  id: 2,
                  name: 'bar'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2011, 0, 4),
                  duration: 1,
                  name: 'foo'
                }]
              });
              _context15.next = 3;
              return scheduler.project.commitAsync();

            case 3:
              stm = scheduler.project.stm, origLeft = t.rect('.b-sch-event').left;
              stm.enable();
              _context15.next = 7;
              return t.dragBy('.b-sch-event:contains(foo)', [100, 0]);

            case 7:
              _context15.next = 9;
              return t.waitForAnimations();

            case 9:
              stm.undo();
              _context15.next = 12;
              return t.waitFor(function () {
                return t.rect('.b-sch-event').left === origLeft;
              });

            case 12:
              t.is(t.rect('.b-sch-event').left, origLeft, 'Undone paint ok');
              t.is(scheduler.eventStore.first.resourceId, 1, 'Undone ok');
              _context15.next = 16;
              return t.waitFor(function () {
                return stm.isReady;
              });

            case 16:
              stm.redo();
              _context15.next = 19;
              return t.waitFor(function () {
                return t.rect('.b-sch-event').left === 255;
              });

            case 19:
              t.is(scheduler.eventStore.first.resourceId, 2, 'Redone ok');
              t.is(t.rect('.b-sch-event').left, 255, 'Redone paint ok');

            case 21:
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
  t.it('Should support undo / redo after date change in vertical mode with number ids', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      var stm, origTop;
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              scheduler = t.getScheduler({
                appendTo: document.body,
                mode: 'vertical',
                barMargin: 0,
                width: 400,
                tbar: [{
                  type: 'undoredo',
                  icon: 'b-fa-undo'
                }],
                project: {
                  stm: {
                    autoRecord: true
                  }
                },
                resources: [{
                  id: 1,
                  name: 'foo'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2011, 0, 3),
                  duration: 1,
                  name: 'foo'
                }]
              });
              _context16.next = 3;
              return scheduler.project.commitAsync();

            case 3:
              stm = scheduler.project.stm, origTop = t.rect('.b-sch-event').top;
              stm.enable();
              _context16.next = 7;
              return t.dragBy('.b-sch-event:contains(foo)', [0, scheduler.tickSize]);

            case 7:
              _context16.next = 9;
              return t.waitForSelectorNotFound('.b-dragging');

            case 9:
              _context16.next = 11;
              return t.waitForAnimations();

            case 11:
              stm.undo();
              _context16.next = 14;
              return t.waitFor(function () {
                return t.rect('.b-sch-event').top === origTop;
              });

            case 14:
              t.is(t.rect('.b-sch-event').top, origTop, 'Undone paint ok');
              t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 3), 'Undone ok');
              _context16.next = 18;
              return t.waitFor(function () {
                return stm.isReady;
              });

            case 18:
              stm.redo();
              _context16.next = 21;
              return t.waitFor(function () {
                var eventEl = document.querySelector('.b-sch-event'),
                    parentEl = eventEl.closest('.b-sch-foreground-canvas');
                return Math.abs(Rectangle.from(eventEl, parentEl).y - scheduler.tickSize) < 2;
              });

            case 21:
              t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 4), 'Redone ok');

            case 22:
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