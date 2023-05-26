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
  t.beforeEach(function () {
    scheduler && !scheduler.isDestroyed && scheduler.destroy();
  });
  t.it('Should repaint each affected resource just once after eventStore#commit', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                resources: [{
                  id: 1,
                  name: 'First'
                }],
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2018, 1, 31),
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: '2018-01-01',
                  duration: 1
                }, {
                  id: 2,
                  resourceId: 1,
                  startDate: '2018-02-01',
                  duration: 1
                }]
              });
              _context.next = 3;
              return t.waitForProjectReady(scheduler);

            case 3:
              _context.next = 5;
              return scheduler.eventStore.first.shift(1);

            case 5:
              _context.next = 7;
              return scheduler.eventStore.last.shift(1);

            case 7:
              t.isCalledOnce('repaintEventsForResource', scheduler, 'Called just once even several resource events were changed');
              scheduler.eventStore.commit();

            case 9:
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
  t.it('Should always have an AssignmentStore', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var create, _create, assert;

      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              assert = function _assert(t) {
                t.ok(scheduler.assignmentStore, 'Has AssignmentStore');
                t.is(scheduler.assignmentStore.count, 2, 'With correct amount of assignments in it');

                var _scheduler$assignment = _slicedToArray(scheduler.assignmentStore, 2),
                    firstAssignment = _scheduler$assignment[0],
                    lastAssignment = _scheduler$assignment[1],
                    _scheduler$eventStore = _slicedToArray(scheduler.eventStore, 2),
                    firstEvent = _scheduler$eventStore[0],
                    lastEvent = _scheduler$eventStore[1],
                    _scheduler$resourceSt = _slicedToArray(scheduler.resourceStore, 2),
                    firstResource = _scheduler$resourceSt[0],
                    lastResource = _scheduler$resourceSt[1];

                t.is(firstAssignment.event, firstEvent, 'First assignment has correct event');
                t.is(lastAssignment.event, lastEvent, 'Last assignment has correct event');
                t.is(firstAssignment.resource, firstResource, 'First assignment has correct resource');
                t.is(lastAssignment.resource, firstResource, 'Last assignment has correct resource');
                t.is(firstEvent.resource, firstResource, 'First event has correct resource');
                t.isDeeply(firstEvent.resources, [firstResource], 'First event has correct resources');
                t.is(lastEvent.resource, firstResource, 'Last event has correct resource');
                t.isDeeply(lastEvent.resources, [firstResource], 'Last event has correct resources');
                t.isDeeplyUnordered(firstResource.events, [firstEvent, lastEvent], 'First resource has correct events');
                t.isDeeply(lastResource.events, [], 'Last resource has no events');
                t.is(firstEvent.resourceId, 1, 'Correct resourceId for first event');
                t.is(lastEvent.resourceId, 1, 'Correct resourceId for last event');
                t.selectorCountIs('.b-sch-event', 2, 'And events are rendered');
              };

              _create = function _create3() {
                _create = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(config) {
                  return regeneratorRuntime.wrap(function _callee8$(_context8) {
                    while (1) {
                      switch (_context8.prev = _context8.next) {
                        case 0:
                          scheduler = new Scheduler(Object.assign({
                            appendTo: document.body,
                            useInitialAnimation: false,
                            startDate: new Date(2019, 11, 13),
                            endDate: new Date(2019, 11, 20)
                          }, config));
                          _context8.next = 3;
                          return t.waitForProjectReady();

                        case 3:
                        case "end":
                          return _context8.stop();
                      }
                    }
                  }, _callee8);
                }));
                return _create.apply(this, arguments);
              };

              create = function _create2(_x3) {
                return _create.apply(this, arguments);
              };

              t.it('When using inline data with resourceId', /*#__PURE__*/function () {
                var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
                  return regeneratorRuntime.wrap(function _callee2$(_context2) {
                    while (1) {
                      switch (_context2.prev = _context2.next) {
                        case 0:
                          _context2.next = 2;
                          return create({
                            resources: [{
                              id: 1,
                              name: 'Batman'
                            }, {
                              id: 2,
                              name: 'Flash'
                            }],
                            events: [{
                              id: 1,
                              resourceId: 1,
                              startDate: '2019-12-13',
                              duration: 4
                            }, {
                              id: 2,
                              resourceId: 1,
                              startDate: '2019-12-13',
                              duration: 1
                            }]
                          });

                        case 2:
                          assert(t);

                        case 3:
                        case "end":
                          return _context2.stop();
                      }
                    }
                  }, _callee2);
                }));

                return function (_x4) {
                  return _ref3.apply(this, arguments);
                };
              }());
              t.it('When using inline data with assignments', /*#__PURE__*/function () {
                var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
                  return regeneratorRuntime.wrap(function _callee3$(_context3) {
                    while (1) {
                      switch (_context3.prev = _context3.next) {
                        case 0:
                          _context3.next = 2;
                          return create({
                            resources: [{
                              id: 1,
                              name: 'Batman'
                            }, {
                              id: 2,
                              name: 'Flash'
                            }],
                            events: [{
                              id: 1,
                              startDate: '2019-12-13',
                              duration: 4
                            }, {
                              id: 2,
                              startDate: '2019-12-13',
                              duration: 1
                            }],
                            assignments: [{
                              eventId: 1,
                              resourceId: 1
                            }, {
                              eventId: 2,
                              resourceId: 1
                            }]
                          });

                        case 2:
                          assert(t);

                        case 3:
                        case "end":
                          return _context3.stop();
                      }
                    }
                  }, _callee3);
                }));

                return function (_x5) {
                  return _ref4.apply(this, arguments);
                };
              }());
              t.it('When using store configs with resourceId', /*#__PURE__*/function () {
                var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
                  return regeneratorRuntime.wrap(function _callee4$(_context4) {
                    while (1) {
                      switch (_context4.prev = _context4.next) {
                        case 0:
                          _context4.next = 2;
                          return create({
                            resourceStore: {
                              data: [{
                                id: 1,
                                name: 'Batman'
                              }, {
                                id: 2,
                                name: 'Flash'
                              }]
                            },
                            eventStore: {
                              data: [{
                                id: 1,
                                resourceId: 1,
                                startDate: '2019-12-13',
                                duration: 4
                              }, {
                                id: 2,
                                resourceId: 1,
                                startDate: '2019-12-13',
                                duration: 1
                              }]
                            }
                          });

                        case 2:
                          assert(t);

                        case 3:
                        case "end":
                          return _context4.stop();
                      }
                    }
                  }, _callee4);
                }));

                return function (_x6) {
                  return _ref5.apply(this, arguments);
                };
              }());
              t.it('When using store configs with assignments', /*#__PURE__*/function () {
                var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
                  return regeneratorRuntime.wrap(function _callee5$(_context5) {
                    while (1) {
                      switch (_context5.prev = _context5.next) {
                        case 0:
                          _context5.next = 2;
                          return create({
                            resourceStore: {
                              data: [{
                                id: 1,
                                name: 'Batman'
                              }, {
                                id: 2,
                                name: 'Flash'
                              }]
                            },
                            eventStore: {
                              data: [{
                                id: 1,
                                startDate: '2019-12-13',
                                duration: 4
                              }, {
                                id: 2,
                                startDate: '2019-12-13',
                                duration: 1
                              }]
                            },
                            assignmentStore: {
                              data: [{
                                eventId: 1,
                                resourceId: 1
                              }, {
                                eventId: 2,
                                resourceId: 1
                              }]
                            }
                          });

                        case 2:
                          assert(t);

                        case 3:
                        case "end":
                          return _context5.stop();
                      }
                    }
                  }, _callee5);
                }));

                return function (_x7) {
                  return _ref6.apply(this, arguments);
                };
              }());
              t.it('When using stores with resourceId', /*#__PURE__*/function () {
                var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
                  return regeneratorRuntime.wrap(function _callee6$(_context6) {
                    while (1) {
                      switch (_context6.prev = _context6.next) {
                        case 0:
                          _context6.next = 2;
                          return create({
                            resourceStore: new ResourceStore({
                              data: [{
                                id: 1,
                                name: 'Batman'
                              }, {
                                id: 2,
                                name: 'Flash'
                              }]
                            }),
                            eventStore: new EventStore({
                              data: [{
                                id: 1,
                                resourceId: 1,
                                startDate: '2019-12-13',
                                duration: 4
                              }, {
                                id: 2,
                                resourceId: 1,
                                startDate: '2019-12-13',
                                duration: 1
                              }]
                            })
                          });

                        case 2:
                          assert(t);

                        case 3:
                        case "end":
                          return _context6.stop();
                      }
                    }
                  }, _callee6);
                }));

                return function (_x8) {
                  return _ref7.apply(this, arguments);
                };
              }());
              t.it('When using stores with assignments', /*#__PURE__*/function () {
                var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
                  return regeneratorRuntime.wrap(function _callee7$(_context7) {
                    while (1) {
                      switch (_context7.prev = _context7.next) {
                        case 0:
                          _context7.next = 2;
                          return create({
                            resourceStore: new ResourceStore({
                              data: [{
                                id: 1,
                                name: 'Batman'
                              }, {
                                id: 2,
                                name: 'Flash'
                              }]
                            }),
                            eventStore: new EventStore({
                              data: [{
                                id: 1,
                                startDate: '2019-12-13',
                                duration: 4
                              }, {
                                id: 2,
                                startDate: '2019-12-13',
                                duration: 1
                              }]
                            }),
                            assignmentStore: new AssignmentStore({
                              data: [{
                                eventId: 1,
                                resourceId: 1
                              }, {
                                eventId: 2,
                                resourceId: 1
                              }]
                            })
                          });

                        case 2:
                          assert(t);

                        case 3:
                        case "end":
                          return _context7.stop();
                      }
                    }
                  }, _callee7);
                }));

                return function (_x9) {
                  return _ref8.apply(this, arguments);
                };
              }());

            case 9:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
});