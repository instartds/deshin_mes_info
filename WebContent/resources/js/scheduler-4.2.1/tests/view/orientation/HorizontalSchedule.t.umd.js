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
    return scheduler && scheduler.destroy();
  });
  t.it('Removing a resource should translate other events to correct positions', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var targetY, targetX;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync();

            case 2:
              scheduler = _context.sent;
              targetY = DomHelper.getTranslateY(document.querySelector('.event2')), targetX = DomHelper.getTranslateX(document.querySelector('.event3')); // should still have this x

              scheduler.resourceStore.getAt(1).remove();
              t.chain({
                waitFor: function waitFor() {
                  return DomHelper.getTranslateY(document.querySelector('.event3')) === targetY;
                },
                desc: 'Event moved to correct y'
              }, function () {
                t.is(DomHelper.getTranslateX(document.querySelector('.event3')), targetX, 'Also at correct x');
              });

            case 6:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7421

  t.it('Adding an event should not use another events element', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var firstEventElement;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getSchedulerAsync({
                events: [{
                  id: 'e1',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  duration: 1
                }]
              });

            case 2:
              scheduler = _context2.sent;
              firstEventElement = document.querySelector(scheduler.eventSelector);
              scheduler.eventStore.add({
                id: 'e2',
                resourceId: 'r1',
                startDate: new Date(2011, 0, 4),
                duration: 1
              });
              _context2.next = 7;
              return t.waitForProjectReady();

            case 7:
              t.is(firstEventElement.dataset.eventId, 'e1', 'Element still used for same event');

            case 8:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7263

  t.it('Assigning an unassigned event should not use another events element', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var firstEventElement, _scheduler$eventStore, _scheduler$eventStore2, e2;

      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getSchedulerAsync({
                events: [{
                  id: 'e1',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  duration: 1
                }]
              });

            case 2:
              scheduler = _context3.sent;
              firstEventElement = document.querySelector(scheduler.eventSelector);
              _scheduler$eventStore = scheduler.eventStore.add({
                id: 'e2',
                startDate: new Date(2011, 0, 4),
                duration: 1
              }), _scheduler$eventStore2 = _slicedToArray(_scheduler$eventStore, 1), e2 = _scheduler$eventStore2[0];
              e2.resourceId = 'r1';
              _context3.next = 8;
              return t.waitForProjectReady();

            case 8:
              t.is(firstEventElement.dataset.eventId, 'e1', 'Element still used for same event');

            case 9:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8365

  t.it('Style should be cleared on element reusage', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2011, 0, 1),
                endDate: new Date(2011, 1, 31),
                events: [{
                  id: 'e1',
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  duration: 1,
                  style: 'background-color : red'
                }, {
                  id: 'e2',
                  resourceId: 'r1',
                  startDate: new Date(2011, 1, 20),
                  duration: 1
                }]
              });

            case 2:
              scheduler = _context4.sent;
              t.chain({
                waitForSelector: scheduler.unreleasedEventSelector
              }, function () {
                var async = t.beginAsync(); // Cannot jump there directly, does not reproduce the bug

                function scroll() {
                  scheduler.subGrids.normal.scrollable.x += 400;

                  if (scheduler.subGrids.normal.scrollable.x < 4800) {
                    requestAnimationFrame(scroll);
                  } else {
                    t.notOk(document.querySelector('.b-sch-event').style.backgroundColor, 'Style not set');
                    t.endAsync(async);
                  }
                }

                requestAnimationFrame(scroll);
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
  }());
  t.it('Should derender horizontally early when not using labels or milestones', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return t.getSchedulerAsync({
                width: 400
              });

            case 2:
              scheduler = _context5.sent;
              scheduler.scrollLeft = 330;
              _context5.next = 6;
              return t.waitForAnimationFrame();

            case 6:
              t.selectorNotExists('$event=1', 'Event derendered early');

            case 7:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x5) {
      return _ref5.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1873

  t.it('Should not derender horizontally too eagerly when using labels', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getSchedulerAsync({
                features: {
                  labels: {
                    right: 'name'
                  }
                },
                width: 400
              });

            case 2:
              scheduler = _context6.sent;
              scheduler.scrollLeft = 330;
              _context6.next = 6;
              return t.waitForAnimationFrame();

            case 6:
              t.selectorExists('$event=1 .b-sch-label-right', 'Label still rendered when event is scrolled out of view');
              scheduler.scrollLeft = 480;
              _context6.next = 10;
              return t.waitForAnimationFrame();

            case 10:
              t.selectorNotExists('$event=1 .b-sch-label-right', 'Now it is properly gone');

            case 11:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref6.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1873

  t.it('Should not derender horizontally too eagerly when using milestones', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return t.getSchedulerAsync({
                width: 400
              });

            case 2:
              scheduler = _context7.sent;
              scheduler.eventStore.first.duration = 0;
              _context7.next = 6;
              return scheduler.project.commitAsync();

            case 6:
              scheduler.scrollLeft = 110;
              _context7.next = 9;
              return t.waitForAnimationFrame();

            case 9:
              t.selectorExists('$event=1', 'Milestone still rendered');
              scheduler.scrollLeft = 260;
              _context7.next = 13;
              return t.waitForAnimationFrame();

            case 13:
              t.selectorNotExists('$event=1', 'Now it is properly gone');

            case 14:
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
  t.it('Should refresh UI correctly when setting empty array as assignments', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              scheduler = t.getScheduler({
                startDate: new Date(2017, 0, 1),
                endDate: new Date(2017, 0, 2),
                resources: [{
                  id: 'r1',
                  name: 'Celia',
                  city: 'Barcelona'
                }, {
                  id: 'r2',
                  name: 'Lee',
                  city: 'London'
                }],
                events: [{
                  id: 1,
                  startDate: new Date(2017, 0, 1, 10),
                  endDate: new Date(2017, 0, 1, 12),
                  name: 'Multi assigned',
                  iconCls: 'b-fa b-fa-users'
                }],
                assignments: [{
                  id: 1,
                  resourceId: 'r1',
                  eventId: 1
                }, {
                  id: 2,
                  resourceId: 'r2',
                  eventId: 1
                }]
              });
              _context8.next = 3;
              return t.waitForSelector(scheduler.unreleasedEventSelector);

            case 3:
              scheduler.assignments = [];
              _context8.next = 6;
              return t.waitForSelectorNotFound(scheduler.unreleasedEventSelector);

            case 6:
              t.pass('Events derendered');

            case 7:
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
  t.it('Should enable stickyHeader by default', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var textNode;
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              scheduler = t.getScheduler({
                startDate: new Date(2021, 0, 1),
                endDate: new Date(2021, 2, 1)
              });
              _context9.next = 3;
              return t.waitForSelector('.b-sch-header-text.b-sticky-header');

            case 3:
              _context9.next = 5;
              return scheduler.scrollToDate(new Date(2021, 0, 8), {
                block: 'start'
              });

            case 5:
              textNode = t.query('.b-sch-header-text.b-sticky-header')[0];
              t.is(window.getComputedStyle(textNode).position, 'sticky', 'Sticky header enabled');
              t.elementIsTopElement('.b-sch-header-text.b-sticky-header:contains(w.01 Jan 2021)', 'Header cell is sticky');

            case 8:
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
  t.it('Should support disabling stickyHeader', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var textNode;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              scheduler = t.getScheduler({
                startDate: new Date(2021, 0, 1),
                endDate: new Date(2021, 2, 1),
                stickyHeaders: false
              });
              _context10.next = 3;
              return t.waitForSelector('.b-sch-header-text');

            case 3:
              _context10.next = 5;
              return scheduler.scrollToDate(new Date(2021, 0, 8), {
                block: 'start'
              });

            case 5:
              t.selectorNotExists('.b-sticky-header');
              textNode = t.query('.b-sch-header-text')[0];
              t.is(window.getComputedStyle(textNode).position, 'static', 'Sticky header disabled');
              t.elementIsNotTopElement('.b-sch-header-text:contains(w.01 Jan 2021)', 'Header cell is not sticky');

            case 9:
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
  t.it('Should return visible resources', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return t.getSchedulerAsync({
                minHeight: null
              });

            case 2:
              scheduler = _context11.sent;
              t.isDeeply(scheduler.visibleResources, {
                first: scheduler.resourceStore.first,
                last: scheduler.resourceStore.last
              }, 'All resources visible');
              scheduler.height = 80;
              _context11.next = 7;
              return t.waitFor(function () {
                return scheduler.visibleResources.first === scheduler.visibleResources.last;
              });

            case 7:
              t.isDeeply(scheduler.visibleResources, {
                first: scheduler.resourceStore.first,
                last: scheduler.resourceStore.first
              }, 'First resource visible only');
              scheduler.scrollTop = 500;
              _context11.next = 11;
              return t.waitFor(function () {
                return scheduler.visibleResources.first === scheduler.resourceStore.last;
              });

            case 11:
              t.isDeeply(scheduler.visibleResources, {
                first: scheduler.resourceStore.last,
                last: scheduler.resourceStore.last
              }, 'Last resource visible only');

            case 12:
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
  t.it('Should not render events for rows far out of view', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      var event;
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return t.getSchedulerAsync({
                events: ArrayHelper.populate(100, function (i) {
                  return {
                    id: i + 1,
                    resourceId: i % 20 + 1,
                    name: "Event ".concat(i + 1),
                    startDate: '2021-05-03',
                    duration: 48
                  };
                }),
                resources: ArrayHelper.populate(20, function (i) {
                  return {
                    id: i + 1,
                    name: "Resource ".concat(i + 1)
                  };
                }),
                startDate: '2021-05-03'
              });

            case 2:
              scheduler = _context12.sent;
              event = scheduler.unreleasedEventSelector;
              t.selectorNotExists("".concat(event, "[data-resource-id=\"6\"]"), 'No events rendered for resource 6');
              _context12.next = 7;
              return scheduler.scrollRowIntoView(6);

            case 7:
              _context12.next = 9;
              return t.waitForAnimationFrame();

            case 9:
              t.selectorExists("".concat(event, "[data-resource-id=\"6\"]"), 'Events rendered for resource 6 after scroll');
              t.selectorExists("".concat(event, "[data-resource-id=\"7\"]"), 'Events rendered for resource 7');
              t.selectorNotExists("".concat(event, "[data-resource-id=\"8\"]"), 'No events rendered for resource 8');
              t.selectorNotExists("".concat(event, "[data-resource-id=\"1\"]"), 'No events rendered for resource 1');

            case 13:
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
});