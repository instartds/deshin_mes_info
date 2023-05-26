function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
    document.body.innerHTML = '';
  });

  function assertEventElement(t, eventId) {
    var top = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : null;
    var left = arguments.length > 3 ? arguments[3] : undefined;
    var width = arguments.length > 4 ? arguments[4] : undefined;
    var height = arguments.length > 5 ? arguments[5] : undefined;
    var msg = arguments.length > 6 && arguments[6] !== undefined ? arguments[6] : '';
    var selector = "[data-event-id=\"".concat(eventId, "\"]:not(.b-released)");

    if (top === null) {
      t.selectorNotExists(selector, 'Element not found');
    } else {
      var element = document.querySelector(selector);
      t.ok(element, "Element found ".concat(msg));
      var box = Rectangle.from(element, scheduler.timeAxisSubGridElement);
      t.isApprox(box.top, top, 0.1, 'Correct top');
      t.is(box.left, left, 'Correct left');
      t.is(box.width, width, 'Correct width');
      t.is(box.height, height, 'Correct height');
      t.contentLike(element, "Event ".concat(eventId), 'Correct text');
    }
  }

  t.it('Valid drag', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getVerticalSchedulerAsync();

            case 2:
              scheduler = _context.sent;
              t.chain({
                drag: '[data-event-id="1"]',
                by: [150, 0],
                desc: 'Dragging right'
              }, function (next) {
                assertEventElement(t, 1, 100, 150, 150, 100);
                assertEventElement(t, 2, 150, 0, 150, 200);
                next();
              }, {
                drag: '[data-event-id="1"]',
                by: [0, 200],
                desc: 'Dragging down'
              }, function (next) {
                assertEventElement(t, 1, 300, 225, 75, 100);
                assertEventElement(t, 3, 300, 150, 75, 200);
                next();
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
  }());
  t.it('Drag triggering scroll', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var element;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getVerticalSchedulerAsync();

            case 2:
              scheduler = _context2.sent;
              element = scheduler.getElementFromEventRecord(scheduler.eventStore.first);
              t.chain({
                drag: '[data-event-id="1"]',
                to: '.b-grid-body-container',
                toOffset: [200, '100%-10'],
                desc: 'Dragging far down',
                dragOnly: true
              }, {
                waitFor: function waitFor() {
                  return scheduler.scrollTop > 400;
                }
              }, function (next) {
                t.ok(element.parentElement.retainElement, 'Flagged with retainElement');
                t.ok(element.parentElement.classList.contains('b-dragging'), 'Styled as drag proxy');
                next();
              }, {
                waitFor: function waitFor() {
                  return scheduler.scrollTop > 700;
                }
              }, function (next) {
                t.ok(element.parentElement.retainElement, 'Flagged with retainElement');
                t.ok(element.parentElement.classList.contains('b-dragging'), 'Styled as drag proxy');
                next();
              }, {
                mouseUp: null
              }, function () {
                var element = scheduler.getElementFromEventRecord(scheduler.eventStore.first);
                t.ok(element, 'Element found');
                t.notOk(element.parentElement.retainElement, 'Not flagged with retainElement');
                t.notOk(element.parentElement.classList.contains('b-dragging'), 'Not styled as drag proxy');
              });

            case 5:
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
  t.it('Multi drag', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var event1, event2;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getVerticalSchedulerAsync({
                multiEventSelect: true
              });

            case 2:
              scheduler = _context3.sent;
              event1 = scheduler.eventStore.getById(1), event2 = scheduler.eventStore.getById(2);
              t.chain(function (next) {
                t.ok(event1.resource === scheduler.resourceStore.getAt(0));
                t.ok(event2.resource === scheduler.resourceStore.getAt(0));
                next();
              }, {
                click: '[data-event-id="1"]'
              }, {
                click: '[data-event-id="2"]',
                options: {
                  ctrlKey: true
                }
              }, function (next) {
                t.is(scheduler.selectedEvents.length, 2);
                next();
              }, {
                drag: '[data-event-id="2"]',
                by: [200, 0],
                desc: 'Dragging right'
              }, function () {
                assertEventElement(t, 1, 100, 300, 75, 100);
                assertEventElement(t, 2, 150, 375, 75, 200);
                t.ok(event1.resource === scheduler.resourceStore.getAt(2));
                t.ok(event2.resource === scheduler.resourceStore.getAt(2));
              });

            case 5:
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
  t.it('Should support constrainDragToResource', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getVerticalSchedulerAsync({
                features: {
                  eventDrag: {
                    constrainDragToResource: true
                  }
                }
              });

            case 2:
              scheduler = _context4.sent;
              t.wontFire(scheduler.eventStore, 'change');
              t.chain({
                drag: '[data-event-id="2"]',
                by: [150, 0],
                desc: 'Dragging right'
              });

            case 5:
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
  t.it('Multi drag including events below the rendered block', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var event1, event1001;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return t.getVerticalSchedulerAsync({
                multiEventSelect: true,
                endDate: new Date(2019, 6, 30)
              });

            case 2:
              scheduler = _context5.sent;
              event1 = scheduler.eventStore.getById(1), event1001 = scheduler.eventStore.getById(1001);
              t.chain(function () {
                return scheduler.scrollEventIntoView(event1001);
              }, {
                click: '[data-event-id="1001"]'
              }, function () {
                return scheduler.scrollEventIntoView(event1);
              }, {
                click: '[data-event-id="1"]',
                options: {
                  ctrlKey: true
                }
              }, function (next) {
                t.is(scheduler.selectedEvents.length, 2);
                next();
              }, // https://github.com/bryntum/support/issues/120 threw on start drag
              {
                drag: '[data-event-id="1"]',
                by: [200, 0],
                desc: 'Dragging right'
              }, function (next) {
                // Element snap into position under "Resource 2"
                assertEventElement(t, 1, 100, 150, 150, 100); // The one way down outside the tendered block is no longer there

                assertEventElement(t, 1001, null); // Elements are correctly assigned to "Resource 2"

                t.ok(event1.resource === scheduler.resourceStore.getAt(1), 'Event correctly assigned to "Resource 2"');
                t.ok(event1001.resource === scheduler.resourceStore.getAt(1), 'Event correctly assigned to "Resource 2"');
              });

            case 5:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x5) {
      return _ref5.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1009

  t.it('Should work on scrolled page', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var _scheduler$eventStore, event1, event2;

      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              document.body.innerHTML = '<div style="height : 1000px"></div><div id="container"></div>';
              _context7.next = 3;
              return t.getVerticalSchedulerAsync({
                appendTo: 'container',
                width: 1024,
                height: 768
              });

            case 3:
              scheduler = _context7.sent;
              window.scroll(0, 500);
              _scheduler$eventStore = _slicedToArray(scheduler.eventStore, 2), event1 = _scheduler$eventStore[0], event2 = _scheduler$eventStore[1];
              t.chain({
                drag: '[data-event-id="1"]',
                by: [150, 0]
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6() {
                return regeneratorRuntime.wrap(function _callee6$(_context6) {
                  while (1) {
                    switch (_context6.prev = _context6.next) {
                      case 0:
                        t.is(event1.resourceId, 'r2', 'Horizontal drag worked');

                      case 1:
                      case "end":
                        return _context6.stop();
                    }
                  }
                }, _callee6);
              })), // Use offset to avoid going into scroll area by mistake
              {
                drag: '[data-event-id="2"]',
                by: [0, -50],
                offset: ['50%', '80%']
              }, function () {
                t.is(event2.startDate, new Date(2019, 4, 28), 'Vertical drag worked');
              });

            case 7:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x6) {
      return _ref6.apply(this, arguments);
    };
  }());
});