function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) { symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); } keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest({
  defaultTimeout: 90000
}, function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
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
              return t.getSchedulerAsync(_objectSpread({
                features: {
                  eventDrag: true
                }
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

  t.it('Should not deselect events on multi event drag with Ctrl', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var _scheduler$eventStore, e1, e2, e3, e1StartDate, e2StartDate, e3StartDate;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler({
                multiEventSelect: true
              });

            case 2:
              scheduler = _context.sent;
              _scheduler$eventStore = _slicedToArray(scheduler.eventStore, 3), e1 = _scheduler$eventStore[0], e2 = _scheduler$eventStore[1], e3 = _scheduler$eventStore[2], e1StartDate = e1.startDate.valueOf(), e2StartDate = e2.startDate.valueOf(), e3StartDate = e3.startDate.valueOf();
              t.chain({
                click: '[data-event-id=3]'
              }, {
                click: '[data-event-id=2]',
                options: {
                  ctrlKey: true
                }
              }, function (next) {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2], 'Correct selection initially');
                next();
              }, {
                drag: '[data-event-id=1]',
                options: {
                  ctrlKey: true
                },
                by: [50, 0],
                dragOnly: true
              }, function (next) {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2, 1], 'Correct selection');
                next();
              }, {
                mouseUp: null
              }, {
                waitForSelectorNotFound: '.b-dragging'
              }, function () {
                // All should have been dragged right by same amount
                t.is(e1.startDate.valueOf(), e1StartDate + 43200000);
                t.is(e2.startDate.valueOf(), e2StartDate + 43200000);
                t.is(e3.startDate.valueOf(), e3StartDate + 43200000);
              });

            case 5:
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
  t.it('Should drag multi events to the same resource if unifiedDrag : true', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var _scheduler$eventStore2, e1, e2, e3, targetResource, targetResourceRow, targetDate;

      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getScheduler({
                multiEventSelect: true,
                features: {
                  eventDrag: {
                    unifiedDrag: true
                  }
                }
              });

            case 2:
              scheduler = _context2.sent;
              _scheduler$eventStore2 = _slicedToArray(scheduler.eventStore, 3), e1 = _scheduler$eventStore2[0], e2 = _scheduler$eventStore2[1], e3 = _scheduler$eventStore2[2], targetResource = scheduler.resourceStore.getAt(4), targetResourceRow = scheduler.getRowFor(targetResource).elements.normal, targetDate = DateHelper.add(scheduler.timeAxis.startDate, 1, 'day');
              t.chain({
                click: '[data-event-id=3]'
              }, {
                click: '[data-event-id=2]',
                options: {
                  ctrlKey: true
                }
              }, function (next) {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2], 'Correct selection initially');
                next();
              }, {
                drag: '[data-event-id=1]',
                options: {
                  ctrlKey: true
                },
                to: targetResourceRow,
                fromOffset: [15, 5],
                toOffset: [scheduler.timeAxisViewModel.getSingleUnitInPixels('day') + 15, '50%'],
                dragOnly: true
              }, function (next) {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2, 1], 'Correct selection');
                next();
              }, {
                mouseUp: null
              }, {
                waitForSelectorNotFound: '.b-dragging'
              }, function () {
                // All should have been dragged to same resource
                t.is(e1.resource, targetResource);
                t.is(e2.resource, targetResource);
                t.is(e3.resource, targetResource); // And all dragged to 1 day in from the timeAxis start

                t.is(e1.startDate, targetDate);
                t.is(e2.startDate, targetDate);
                t.is(e3.startDate, targetDate);
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
  t.it('Should drag multi events to the same resource if unifiedDrag : true and the resource row of the dragged event has not changed', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var _scheduler$eventStore3, e1, e2, e3, e1Rectangle, targetResource, targetDate, targetX;

      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getScheduler({
                multiEventSelect: true,
                features: {
                  eventDrag: {
                    unifiedDrag: true
                  }
                }
              });

            case 2:
              scheduler = _context3.sent;
              _scheduler$eventStore3 = _slicedToArray(scheduler.eventStore, 3), e1 = _scheduler$eventStore3[0], e2 = _scheduler$eventStore3[1], e3 = _scheduler$eventStore3[2], e1Rectangle = Rectangle.from(scheduler.getElementFromEventRecord(e1)), targetResource = scheduler.resourceStore.getAt(0), targetDate = DateHelper.add(scheduler.timeAxis.startDate, 3, 'day'), targetX = scheduler.getCoordinateFromDate(targetDate, false);
              t.chain({
                click: '[data-event-id=3]'
              }, {
                click: '[data-event-id=2]',
                options: {
                  ctrlKey: true
                }
              }, function (next) {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2], 'Correct selection initially');
                next();
              }, {
                drag: '[data-event-id=1]',
                options: {
                  ctrlKey: true
                },
                offset: [20, e1Rectangle.height / 2],
                by: [targetX - e1Rectangle.x, 0],
                dragOnly: true
              }, function (next) {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2, 1], 'Correct selection');
                next();
              }, {
                mouseUp: null
              }, {
                waitForSelectorNotFound: '.b-dragging'
              }, function () {
                // All should have been dragged to same resource
                t.is(e1.resource, targetResource);
                t.is(e2.resource, targetResource);
                t.is(e3.resource, targetResource); // And all dragged to 1 day in from the timeAxis start

                t.is(e1.startDate, targetDate);
                t.is(e2.startDate, targetDate);
                t.is(e3.startDate, targetDate);
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
  t.it('Should drag multi events to the same resource if unifiedDrag : true when scrolling down the dataset', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var resources, events, i, _i2, schedulerRectangle, _scheduler$eventStore4, e1, e2, e3, targetResource, targetDate;

      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              t.waitForAnimations = function (callback) {
                return callback();
              };

              resources = [], events = [{
                id: 1,
                resourceId: 'r1',
                name: 'Drag Event',
                startDate: new Date(2011, 0, 4),
                endDate: new Date(2011, 0, 6)
              }];

              for (i = 1; i < 117; i++) {
                events.push({
                  id: i + 1,
                  resourceId: "r".concat(i + 1),
                  name: "Event ".concat(i + 1),
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                });
              }

              for (_i2 = 0; _i2 < 200; _i2++) {
                resources.push({
                  id: "r".concat(_i2 + 1),
                  name: "Resource ".concat(_i2 + 1)
                });
              }

              _context4.next = 6;
              return getScheduler({
                multiEventSelect: true,
                features: {
                  eventDrag: {
                    unifiedDrag: true,
                    showTooltip: false
                  },
                  eventTooltip: false,
                  scheduleTooltip: false
                },
                resources: resources,
                events: events
              });

            case 6:
              scheduler = _context4.sent;
              schedulerRectangle = Rectangle.from(scheduler.element), _scheduler$eventStore4 = _slicedToArray(scheduler.eventStore, 3), e1 = _scheduler$eventStore4[0], e2 = _scheduler$eventStore4[1], e3 = _scheduler$eventStore4[2], targetResource = scheduler.resourceStore.getAt(119), targetDate = DateHelper.add(scheduler.timeAxis.startDate, 1, 'day');
              t.chain({
                click: '[data-event-id=3]'
              }, {
                click: '[data-event-id=2]',
                options: {
                  ctrlKey: true
                }
              }, function (next) {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2], 'Correct selection initially');
                next();
              }, {
                mouseDown: '[data-event-id=1]',
                options: {
                  ctrlKey: true
                },
                offset: [15, 5]
              }, // Begin the drag to create the proxy
              {
                moveMouseBy: [0, 10]
              }, function (next) {
                t.is(scheduler.features.eventDrag.dragData.eventBarEls.length, 3);
                t.is(scheduler.features.eventDrag.dragData.draggedRecords.length, 3);
                next();
              }, // This will kick off scrolling
              function (next) {
                t.moveMouseTo(document.body, next, null, [scheduler.features.eventDrag.drag.startEvent.pageX, schedulerRectangle.bottom - 20]);
              }, // Drag until we're over the targetResource
              function (next) {
                var detacher = scheduler.on({
                  eventDrag: function eventDrag(context) {
                    if (context.newResource === targetResource) {
                      detacher();
                      t.mouseUp().then(next);
                    }
                  },
                  detachable: true
                });
              }, function () {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2, 1], 'Correct selection'); // All should have been dragged to same resource

                t.is(e1.resource, targetResource);
                t.is(e2.resource, targetResource);
                t.is(e3.resource, targetResource); // And all dragged to 1 day in from the timeAxis start

                t.is(e1.startDate, targetDate);
                t.is(e2.startDate, targetDate);
                t.is(e3.startDate, targetDate);
              });

            case 9:
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
  t.it('Should drag multi events by same row offset if unifiedDrag is not set', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var e1, e2, e3, e1StartDate, e2StartDate, e3StartDate, e1TargetResource, e2TargetResource, e3TargetResource;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return getScheduler({
                multiEventSelect: true
              });

            case 2:
              scheduler = _context5.sent;
              e1 = scheduler.eventStore.getById(1), e2 = scheduler.eventStore.getById(2), e3 = scheduler.eventStore.getById(3), e1StartDate = e1.startDate.valueOf(), e2StartDate = e2.startDate.valueOf(), e3StartDate = e3.startDate.valueOf(), e1TargetResource = scheduler.resourceStore.getAt(1), e2TargetResource = scheduler.resourceStore.getAt(2), e3TargetResource = scheduler.resourceStore.getAt(3);
              t.chain({
                click: '[data-event-id=3]'
              }, {
                click: '[data-event-id=2]',
                options: {
                  ctrlKey: true
                }
              }, function (next) {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2], 'Correct selection initially');
                next();
              }, {
                drag: '[data-event-id=1]',
                options: {
                  ctrlKey: true
                },
                by: [0, scheduler.rowHeight],
                dragOnly: true
              }, function (next) {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2, 1], 'Correct selection');
                next();
              }, {
                mouseUp: null
              }, {
                waitForSelectorNotFound: '.b-dragging'
              }, function () {
                // All should have been dragged to same offset from their start row
                t.is(e1.resource, e1TargetResource);
                t.is(e2.resource, e2TargetResource);
                t.is(e3.resource, e3TargetResource); // And all stay at same time

                t.is(e1.startDate, e1StartDate);
                t.is(e2.startDate, e2StartDate);
                t.is(e3.startDate, e3StartDate);
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
  }());
  t.it('Should drag multi events to the same resource if unifiedDrag is not set when scrolling down the dataset', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var resources, events, schedulerRectangle, e1, e2, e3, e1StartDate, e2StartDate, e3StartDate, e1TargetResource, e2TargetResource, e3TargetResource, dragElMutationObserver, eventDrag;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              resources = ArrayHelper.populate(200, function (i) {
                return {
                  id: "r".concat(i + 1),
                  name: "Resource ".concat(i + 1)
                };
              }), events = ArrayHelper.populate(116, function (i) {
                return {
                  id: i + 2,
                  resourceId: "r".concat(i + 2),
                  name: "Event ".concat(i + 2),
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                };
              });
              events.unshift({
                id: 1,
                resourceId: 'r1',
                name: 'Drag Event',
                startDate: new Date(2011, 0, 4),
                endDate: new Date(2011, 0, 6)
              });
              _context6.next = 4;
              return getScheduler({
                multiEventSelect: true,
                features: {
                  eventDrag: {
                    showTooltip: false
                  },
                  eventTooltip: false,
                  scheduleTooltip: false
                },
                resources: resources,
                events: events
              });

            case 4:
              scheduler = _context6.sent;
              schedulerRectangle = Rectangle.from(scheduler.element), e1 = scheduler.eventStore.getById(1), e2 = scheduler.eventStore.getById(2), e3 = scheduler.eventStore.getById(3), e1StartDate = e1.startDate.valueOf(), e2StartDate = e2.startDate.valueOf(), e3StartDate = e3.startDate.valueOf(), e1TargetResource = scheduler.resourceStore.getAt(119), e2TargetResource = scheduler.resourceStore.getAt(120), e3TargetResource = scheduler.resourceStore.getAt(121);
              eventDrag = scheduler.features.eventDrag;
              t.chain({
                click: '[data-event-id=3]'
              }, {
                click: '[data-event-id=2]',
                options: {
                  ctrlKey: true
                }
              }, function (next) {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2], 'Correct selection initially');
                next();
              }, {
                mouseDown: '[data-event-id=1]',
                options: {
                  ctrlKey: true
                },
                offset: [15, 5]
              }, // Begin the drag to create the proxy
              {
                moveMouseBy: [0, 10]
              }, function (next) {
                t.is(eventDrag.dragData.eventBarEls.length, 3);
                t.is(eventDrag.dragData.draggedRecords.length, 3); // Ensure that during the drag, the dragged elements do not get mutated

                eventDrag.dragData.eventBarEls.forEach(function (dragEl) {
                  dragElMutationObserver = new MutationObserver(function () {
                    dragElMutationObserver.disconnect();
                    t.fail('Dragged element got mutated during drag');
                  });
                  dragElMutationObserver.observe(dragEl, {
                    characterData: true,
                    childList: true
                  });
                });
                next();
              }, // This will kick off scrolling
              function (next) {
                t.moveMouseTo(document.body, next, null, [eventDrag.drag.startEvent.pageX, schedulerRectangle.bottom - 20]);
              }, // Drag until we're over the targetResource
              function (next) {
                var detacher = scheduler.on({
                  eventDrag: function eventDrag(context) {
                    if (context.newResource === e1TargetResource) {
                      detacher();
                      t.mouseUp().then(next);
                    }
                  }
                });
              }, function () {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2, 1], 'Correct selection'); // All should have been dragged to same offset from their start row

                t.is(e1.resource, e1TargetResource);
                t.is(e2.resource, e2TargetResource);
                t.is(e3.resource, e3TargetResource); // And all stay at same time

                t.is(e1.startDate, e1StartDate);
                t.is(e2.startDate, e2StartDate);
                t.is(e3.startDate, e3StartDate);
              });

            case 8:
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
  t.it('Should not include events with `draggable` set to false when dragging multiple events', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return getScheduler({
                multiEventSelect: true
              });

            case 2:
              scheduler = _context7.sent;
              scheduler.eventStore.forEach(function (ev) {
                return ev.draggable = false;
              });
              t.wontFire(scheduler.eventStore, 'change');
              t.chain({
                click: '[data-event-id=3]'
              }, {
                click: '[data-event-id=2]',
                options: {
                  ctrlKey: true
                }
              }, function (next) {
                t.isDeeply(scheduler.selectedEvents.map(function (e) {
                  return e.id;
                }), [3, 2], 'Correct selection initially');
                next();
              }, {
                drag: '[data-event-id=1]',
                options: {
                  ctrlKey: true
                },
                by: [0, scheduler.rowHeight]
              }, {
                waitForSelectorNotFound: '.b-dragging'
              });

            case 6:
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
  t.it('Derendering second event vertically, then bringing it back', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var resources, events, event1, event2, renderedCount, dragEl, event2El, event2Top, dragElMutationObserver;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              resources = ArrayHelper.populate(200, function (i) {
                return {
                  id: "r".concat(i + 1),
                  name: "Resource ".concat(i + 1)
                };
              }), events = ArrayHelper.populate(117, function (i) {
                return {
                  id: i + 1,
                  resourceId: "r".concat(i + 1),
                  name: "Event ".concat(i + 1),
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                };
              });
              events[0].name = 'Drag event';
              _context8.next = 4;
              return getScheduler({
                features: {
                  eventDrag: {
                    showTooltip: false
                  },
                  eventTooltip: false,
                  scheduleTooltip: false
                },
                multiEventSelect: true,
                resources: resources,
                events: events
              });

            case 4:
              scheduler = _context8.sent;
              event1 = scheduler.eventStore.first, event2 = scheduler.eventStore.getAt(13), renderedCount = t.query(scheduler.unreleasedEventSelector).length, dragEl = scheduler.getElementFromEventRecord(event1).parentNode, event2El = scheduler.getElementFromEventRecord(event2).parentNode, event2Top = event2El.getBoundingClientRect().top;
              t.chain({
                click: event2El
              }, {
                click: dragEl,
                options: {
                  ctrlKey: true
                }
              }, function (next) {
                t.is(scheduler.selectedEvents.length, 2, 'Two events selected'); // Ensure that during the drag, the dragEl does not get mutated

                dragElMutationObserver = new MutationObserver(function () {
                  dragElMutationObserver.disconnect();
                  t.fail('Dragged element got mutated during drag');
                });
                dragElMutationObserver.observe(dragEl, {
                  characterData: true,
                  childList: true
                });
                next();
              }, {
                drag: dragEl,
                by: [300, 600]
              }, {
                waitForProjectReady: scheduler
              }, function (next) {
                // event2 has been dragged outside of the rendered block
                t.selectorCountIs(scheduler.unreleasedEventSelector, renderedCount - 1, 'Second event no longer rendered');
                next();
              }, {
                waitFor: 250
              }, {
                drag: dragEl,
                by: [-300, -600],
                options: {
                  ctrlKey: true
                }
              }, {
                waitForProjectReady: scheduler
              }, function () {
                // event2 has been rendered again
                t.selectorCountIs(scheduler.unreleasedEventSelector, renderedCount, 'Second event rendered again');
                t.isApproxPx(t.rect('[data-event-id="14"]').top, event2Top, 'At correct y');
              });

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
  t.it('Multi drag, derendering second event horizontally, then bringing it back', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var visibleEventSelector, renderedCount;
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return getScheduler({
                multiEventSelect: true
              });

            case 2:
              scheduler = _context9.sent;
              visibleEventSelector = scheduler.unreleasedEventSelector, renderedCount = scheduler.bodyContainer.querySelectorAll(visibleEventSelector).length;
              t.chain({
                click: '[data-event-id=1]'
              }, {
                drag: '[data-event-id=5]',
                by: [-500, 0],
                options: {
                  ctrlKey: true
                }
              }, {
                waitFor: function waitFor() {
                  return scheduler.bodyContainer.querySelectorAll(visibleEventSelector).length === renderedCount - 1;
                }
              }, {
                drag: '[data-event-id=5]',
                by: [500, 0]
              }, {
                waitFor: function waitFor() {
                  return scheduler.bodyContainer.querySelectorAll(visibleEventSelector).length === renderedCount;
                }
              });

            case 5:
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
  t.it('Should animate events as drag starts when unifiedDrag : true', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var lastTransition;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return getScheduler({
                multiEventSelect: true,
                useInitialAnimation: false,
                features: {
                  eventDrag: {
                    unifiedDrag: true
                  }
                }
              });

            case 2:
              scheduler = _context10.sent;
              lastTransition = Date.now();
              scheduler.timeAxisSubGridElement.addEventListener('transitionend', function () {
                lastTransition = Date.now();
              }); // Let initial view stabilize

              _context10.next = 7;
              return t.waitFor(function () {
                return Date.now() - lastTransition > 500;
              });

            case 7:
              scheduler.selectedEvents = scheduler.eventStore.getRange();
              t.waitForEvent(scheduler.timeAxisSubGridElement, 'transitionend');
              t.dragBy('[data-event-id=1]', [30, 0], null, null, null, true);

            case 10:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x10) {
      return _ref10.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2867
  // https://github.com/bryntum/support/issues/2875

  t.it('Should clean up and remove b-dragging class from all dragged event bars', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return getScheduler({
                multiEventSelect: true
              });

            case 2:
              scheduler = _context11.sent;
              scheduler.selectedEvents = scheduler.eventStore.records;
              _context11.next = 6;
              return t.dragBy('[data-event-id=1]', [100, 100], null, null, null, true);

            case 6:
              _context11.next = 8;
              return t.type(null, '[ESCAPE]');

            case 8:
              _context11.next = 10;
              return t.waitForSelectorNotFound('.b-dragging');

            case 10:
              _context11.next = 12;
              return t.waitForSelectorNotFound('.b-drag-proxy');

            case 12:
              _context11.next = 14;
              return t.moveCursorBy([-50, -20]);

            case 14:
              _context11.next = 16;
              return t.mouseUp(null);

            case 16:
              t.isDeeply(scheduler.selectedEvents.length, 5, 'Dragged events still selected');

            case 17:
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
});