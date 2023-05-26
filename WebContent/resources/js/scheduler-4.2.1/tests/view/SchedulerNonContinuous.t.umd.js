function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;

  function getScheduler() {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee40() {
      var config,
          _args40 = arguments;
      return regeneratorRuntime.wrap(function _callee40$(_context40) {
        while (1) {
          switch (_context40.prev = _context40.next) {
            case 0:
              config = _args40.length > 0 && _args40[0] !== undefined ? _args40[0] : {};
              _context40.next = 3;
              return t.getSchedulerAsync(Object.assign({
                width: 1000,
                enableEventAnimations: false,
                columns: [],
                timeAxis: {
                  continuous: false,
                  generateTicks: function generateTicks(start, end, unit, increment) {
                    var ticks = [];

                    while (start < end) {
                      if (start.getDay() % 2 === 0) {
                        ticks.push({
                          startDate: start,
                          endDate: DateHelper.add(start, increment, unit)
                        });
                      }

                      start = DateHelper.add(start, increment, unit);
                    }

                    return ticks;
                  }
                }
              }, config));

            case 3:
              scheduler = _context40.sent;

            case 4:
            case "end":
              return _context40.stop();
          }
        }
      }, _callee40);
    }));
    return _getScheduler.apply(this, arguments);
  }

  function getBox(id) {
    var el = document.querySelector("[data-event-id=\"".concat(id, "\"]"));
    return el && el.getBoundingClientRect();
  }

  function assertLayout(t, id, x, width) {
    var box = getBox(id);
    t.isApprox(box.left, x, 1, id + ' has correct x');
    t.isApprox(box.width, width, 1, id + ' has correct width');
  }

  t.beforeEach(function () {
    return scheduler && !scheduler.isDestroyed && scheduler.destroy();
  });
  t.it('Should render correctly with non-continuous timeaxis', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var topHeaders, middleHeaders, eventBoxes;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler();

            case 2:
              topHeaders = Array.from(document.querySelectorAll('.b-sch-header-row-0 .b-sch-header-timeaxis-cell'));
              middleHeaders = Array.from(document.querySelectorAll('.b-sch-header-row-1 .b-sch-header-timeaxis-cell'));
              eventBoxes = Array.from(document.querySelectorAll('.b-sch-event')).map(function (el) {
                return el.getBoundingClientRect();
              });
              t.is(topHeaders.length, 2, 'Correct top header count');
              t.is(middleHeaders.length, 5, 'Correct middle header count');
              t.isApprox(scheduler.tickSize, 200, 1, 'Correct tickSize'); // 1000 / 5

              t.isApprox(topHeaders[0].offsetWidth, 600, 1, 'First top header has correct width');
              t.isApprox(topHeaders[1].offsetWidth, 400, 1, 'Second top header has correct width');
              middleHeaders.forEach(function (element) {
                t.isApprox(element.offsetWidth, 200, 1, 'Middle header has correct width');
              });
              t.isApprox(eventBoxes[0].left, 0, 1, 'Correct event x');
              t.isApprox(eventBoxes[1].left, 200, 1, 'Correct event x');
              t.isApprox(eventBoxes[2].left, 200, 1, 'Correct event x');
              t.isApprox(eventBoxes[3].left, 400, 1, 'Correct event x');
              t.isApprox(eventBoxes[4].left, 400, 1, 'Correct event x');
              t.isApprox(eventBoxes[0].width, 200, 1, 'Correct event width');
              t.isApprox(eventBoxes[1].width, 200, 1, 'Correct event width');
              t.isApprox(eventBoxes[2].width, 200, 1, 'Correct event width');
              t.isApprox(eventBoxes[3].width, 200, 1, 'Correct event width');
              t.isApprox(eventBoxes[4].width, 400, 1, 'Correct event width');

            case 21:
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
  t.it('Should redraw correctly on CRUD', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var eventBoxes;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getScheduler();

            case 2:
              scheduler.eventStore.first.startDate = new Date(2011, 0, 8, 12);
              _context2.next = 5;
              return scheduler.eventStore.getAt(1).setStartDate(new Date(2011, 0, 4), false);

            case 5:
              scheduler.eventStore.getAt(2).endDate = new Date(2011, 0, 11, 12); // Setting endDate now keeps duration

              _context2.next = 8;
              return t.waitForProjectReady();

            case 8:
              eventBoxes = Array.from(document.querySelectorAll('.b-sch-event')).map(function (el) {
                return el.getBoundingClientRect();
              });
              t.isApprox(eventBoxes[0].left, 500, 1, 'Correct event x');
              t.isApprox(eventBoxes[1].left, 0, 1, 'Correct event x');
              t.isApprox(eventBoxes[2].left, 200, 1, 'Correct event x');
              t.isApprox(eventBoxes[0].width, 300, 1, 'Correct event width');
              t.isApprox(eventBoxes[1].width, 400, 1, 'Correct event width');
              t.isApprox(eventBoxes[2].width, 700, 1, 'Correct event width');

            case 15:
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
  t.it('Should handle timeAxis#include#day for "smaller" ticks, minuteAndHour', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var getSch, _getSch;

      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _getSch = function _getSch3() {
                _getSch = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(config) {
                  return regeneratorRuntime.wrap(function _callee5$(_context5) {
                    while (1) {
                      switch (_context5.prev = _context5.next) {
                        case 0:
                          return _context5.abrupt("return", getScheduler(Object.assign({
                            timeAxis: {
                              include: {
                                day: {
                                  from: 1,
                                  to: 6
                                } // Exclude Su, Sa

                              }
                            },
                            startDate: new Date(2019, 0, 27),
                            endDate: new Date(2019, 0, 28, 4),
                            viewPreset: 'minuteAndHour'
                          }, config)));

                        case 1:
                        case "end":
                          return _context5.stop();
                      }
                    }
                  }, _callee5);
                }));
                return _getSch.apply(this, arguments);
              };

              getSch = function _getSch2(_x4) {
                return _getSch.apply(this, arguments);
              };

              t.it('Should not draw fully excluded events', /*#__PURE__*/function () {
                var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
                  return regeneratorRuntime.wrap(function _callee3$(_context3) {
                    while (1) {
                      switch (_context3.prev = _context3.next) {
                        case 0:
                          _context3.next = 2;
                          return getSch({
                            events: [{
                              id: 'sunday',
                              resourceId: 'r1',
                              name: 'Sunday',
                              startDate: new Date(2019, 0, 27),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'saturday',
                              resourceId: 'r1',
                              name: 'Saturday',
                              startDate: new Date(2019, 0, 26),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'weekend',
                              resourceId: 'r1',
                              name: 'Weekend',
                              startDate: new Date(2019, 0, 26),
                              duration: 48,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          t.selectorNotExists('.b-sch-event', 'No event elements found');

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
              t.it('Should draw partially excluded events', /*#__PURE__*/function () {
                var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
                  return regeneratorRuntime.wrap(function _callee4$(_context4) {
                    while (1) {
                      switch (_context4.prev = _context4.next) {
                        case 0:
                          _context4.next = 2;
                          return getSch({
                            events: [{
                              id: 'sunday',
                              resourceId: 'r1',
                              name: 'Sunday',
                              startDate: new Date(2019, 0, 27),
                              duration: 25,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          t.selectorExists('.b-sch-event', 'Event element found');

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

            case 4:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should handle timeAxis#include#hour for "smaller" ticks, minuteAndHour', function (t) {
    function getSch(_x7) {
      return _getSch4.apply(this, arguments);
    }

    function _getSch4() {
      _getSch4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(config) {
        return regeneratorRuntime.wrap(function _callee9$(_context9) {
          while (1) {
            switch (_context9.prev = _context9.next) {
              case 0:
                return _context9.abrupt("return", getScheduler(Object.assign({
                  timeAxis: {
                    include: {
                      hour: {
                        from: 10,
                        to: 14
                      }
                    }
                  },
                  startDate: new Date(2019, 0, 28),
                  endDate: new Date(2019, 0, 29),
                  viewPreset: 'minuteAndHour'
                }, config)));

              case 1:
              case "end":
                return _context9.stop();
            }
          }
        }, _callee9);
      }));
      return _getSch4.apply(this, arguments);
    }

    t.it('Should not draw fully excluded events', /*#__PURE__*/function () {
      var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
        return regeneratorRuntime.wrap(function _callee7$(_context7) {
          while (1) {
            switch (_context7.prev = _context7.next) {
              case 0:
                _context7.next = 2;
                return getSch({
                  events: [{
                    id: 'early',
                    resourceId: 'r1',
                    name: 'Sunday',
                    startDate: new Date(2019, 0, 28, 4),
                    duration: 5,
                    durationUnit: 'h'
                  }, {
                    id: 'late',
                    resourceId: 'r1',
                    name: 'Saturday',
                    startDate: new Date(2019, 0, 28, 14),
                    duration: 4,
                    durationUnit: 'h'
                  }]
                });

              case 2:
                t.selectorNotExists('.b-sch-event', 'No event elements found');

              case 3:
              case "end":
                return _context7.stop();
            }
          }
        }, _callee7);
      }));

      return function (_x8) {
        return _ref6.apply(this, arguments);
      };
    }());
    t.it('Should draw partially excluded events', /*#__PURE__*/function () {
      var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
        return regeneratorRuntime.wrap(function _callee8$(_context8) {
          while (1) {
            switch (_context8.prev = _context8.next) {
              case 0:
                _context8.next = 2;
                return getSch({
                  events: [{
                    id: 'early',
                    resourceId: 'r1',
                    name: 'Sunday',
                    startDate: new Date(2019, 0, 28, 4),
                    duration: 7,
                    durationUnit: 'h'
                  }]
                });

              case 2:
                t.selectorExists('.b-sch-event', 'Event element found');

              case 3:
              case "end":
                return _context8.stop();
            }
          }
        }, _callee8);
      }));

      return function (_x9) {
        return _ref7.apply(this, arguments);
      };
    }());
  });
  t.it('Should handle timeAxis#include#day for "smaller" ticks, hourAndDay', function (t) {
    function getSch(_x10) {
      return _getSch5.apply(this, arguments);
    }

    function _getSch5() {
      _getSch5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(config) {
        return regeneratorRuntime.wrap(function _callee12$(_context12) {
          while (1) {
            switch (_context12.prev = _context12.next) {
              case 0:
                return _context12.abrupt("return", getScheduler(Object.assign({
                  startDate: new Date(2019, 0, 26),
                  endDate: new Date(2019, 0, 29),
                  viewPreset: {
                    base: 'hourAndDay',
                    tickWidth: 20,
                    headers: [{
                      unit: 'day',
                      align: 'center',
                      dateFormat: 'ddd DD/MM' //Mon 01/10

                    }, {
                      unit: 'hour',
                      align: 'center',
                      dateFormat: 'HH'
                    }]
                  }
                }, config)));

              case 1:
              case "end":
                return _context12.stop();
            }
          }
        }, _callee12);
      }));
      return _getSch5.apply(this, arguments);
    }

    t.it('Should not draw fully excluded events', /*#__PURE__*/function () {
      var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
        return regeneratorRuntime.wrap(function _callee10$(_context10) {
          while (1) {
            switch (_context10.prev = _context10.next) {
              case 0:
                _context10.next = 2;
                return getSch({
                  timeAxis: {
                    include: {
                      day: {
                        from: 1,
                        to: 6
                      } // Exclude Su, Sa

                    }
                  },
                  events: [{
                    id: 'sunday',
                    resourceId: 'r1',
                    name: 'Sunday',
                    startDate: new Date(2019, 0, 27),
                    duration: 24,
                    durationUnit: 'h'
                  }, {
                    id: 'saturday',
                    resourceId: 'r1',
                    name: 'Saturday',
                    startDate: new Date(2019, 0, 26),
                    duration: 24,
                    durationUnit: 'h'
                  }, {
                    id: 'weekend',
                    resourceId: 'r1',
                    name: 'Weekend',
                    startDate: new Date(2019, 0, 26),
                    duration: 48,
                    durationUnit: 'h'
                  }]
                });

              case 2:
                t.selectorNotExists('.b-sch-event', 'No event elements found');

              case 3:
              case "end":
                return _context10.stop();
            }
          }
        }, _callee10);
      }));

      return function (_x11) {
        return _ref8.apply(this, arguments);
      };
    }());
    t.it('Should draw partially excluded events', /*#__PURE__*/function () {
      var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
        return regeneratorRuntime.wrap(function _callee11$(_context11) {
          while (1) {
            switch (_context11.prev = _context11.next) {
              case 0:
                _context11.next = 2;
                return getSch({
                  timeAxis: {
                    include: {
                      day: {
                        from: 1,
                        to: 6
                      } // Exclude Su, Sa

                    }
                  },
                  events: [{
                    id: 'sunday',
                    resourceId: 'r1',
                    name: 'Sunday',
                    startDate: new Date(2019, 0, 27),
                    duration: 36,
                    durationUnit: 'h'
                  }]
                });

              case 2:
                t.selectorExists('.b-sch-event', 'Event element found');

              case 3:
              case "end":
                return _context11.stop();
            }
          }
        }, _callee11);
      }));

      return function (_x12) {
        return _ref9.apply(this, arguments);
      };
    }());
  });
  t.it('Should handle timeAxis#include#day for "smaller" ticks, weekAndDay', function (t) {
    function getSch(_x13) {
      return _getSch6.apply(this, arguments);
    }

    function _getSch6() {
      _getSch6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(config) {
        return regeneratorRuntime.wrap(function _callee15$(_context15) {
          while (1) {
            switch (_context15.prev = _context15.next) {
              case 0:
                return _context15.abrupt("return", getScheduler(Object.assign({
                  startDate: new Date(2019, 0, 21),
                  endDate: new Date(2019, 1, 1),
                  viewPreset: 'weekAndDay'
                }, config)));

              case 1:
              case "end":
                return _context15.stop();
            }
          }
        }, _callee15);
      }));
      return _getSch6.apply(this, arguments);
    }

    t.it('Should not draw fully excluded events', /*#__PURE__*/function () {
      var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
        return regeneratorRuntime.wrap(function _callee13$(_context13) {
          while (1) {
            switch (_context13.prev = _context13.next) {
              case 0:
                _context13.next = 2;
                return getSch({
                  timeAxis: {
                    include: {
                      day: {
                        from: 1,
                        to: 6
                      } // Exclude Su, Sa

                    }
                  },
                  events: [{
                    id: 'sunday',
                    resourceId: 'r1',
                    name: 'Sunday',
                    startDate: new Date(2019, 0, 27),
                    duration: 24,
                    durationUnit: 'h'
                  }, {
                    id: 'saturday',
                    resourceId: 'r1',
                    name: 'Saturday',
                    startDate: new Date(2019, 0, 26),
                    duration: 24,
                    durationUnit: 'h'
                  }, {
                    id: 'weekend',
                    resourceId: 'r1',
                    name: 'Weekend',
                    startDate: new Date(2019, 0, 26),
                    duration: 48,
                    durationUnit: 'h'
                  }]
                });

              case 2:
                t.selectorNotExists('.b-sch-event', 'No event elements found');

              case 3:
              case "end":
                return _context13.stop();
            }
          }
        }, _callee13);
      }));

      return function (_x14) {
        return _ref10.apply(this, arguments);
      };
    }());
    t.it('Should draw partially excluded events', /*#__PURE__*/function () {
      var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
        return regeneratorRuntime.wrap(function _callee14$(_context14) {
          while (1) {
            switch (_context14.prev = _context14.next) {
              case 0:
                _context14.next = 2;
                return getSch({
                  timeAxis: {
                    include: {
                      day: {
                        from: 1,
                        to: 6
                      } // Exclude Su, Sa

                    }
                  },
                  events: [{
                    id: 'sundayToMonday',
                    resourceId: 'r1',
                    name: 'Su-Mo',
                    startDate: new Date(2019, 0, 27),
                    duration: 48,
                    durationUnit: 'h'
                  }, {
                    id: 'fridayToTuesday',
                    resourceId: 'r1',
                    name: 'Fr-Tu',
                    startDate: new Date(2019, 0, 25),
                    duration: 5,
                    durationUnit: 'd'
                  }]
                });

              case 2:
                assertLayout(t, 'sundayToMonday', 500, 100);
                assertLayout(t, 'fridayToTuesday', 400, 300);

              case 4:
              case "end":
                return _context14.stop();
            }
          }
        }, _callee14);
      }));

      return function (_x15) {
        return _ref11.apply(this, arguments);
      };
    }()); // No need to test drawing within actual ticks here, that is made sure to work elsewhere :)
  });
  t.it('Should handle timeAxis#include#day for "larger" ticks', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee24(t) {
      return regeneratorRuntime.wrap(function _callee24$(_context24) {
        while (1) {
          switch (_context24.prev = _context24.next) {
            case 0:
              t.it('Should not draw fully excluded events', /*#__PURE__*/function () {
                var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
                  return regeneratorRuntime.wrap(function _callee16$(_context16) {
                    while (1) {
                      switch (_context16.prev = _context16.next) {
                        case 0:
                          _context16.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                day: {
                                  from: 1,
                                  to: 6
                                }
                              }
                            },
                            viewPreset: 'weekAndMonth',
                            events: [{
                              id: 'sunday',
                              resourceId: 'r1',
                              name: 'Sunday',
                              startDate: new Date(2011, 0, 2),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'saturday',
                              resourceId: 'r1',
                              name: 'Saturday',
                              startDate: new Date(2011, 0, 8),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'weekend',
                              resourceId: 'r1',
                              name: 'Weekend',
                              startDate: new Date(2011, 0, 8),
                              duration: 48,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          t.selectorNotExists('.b-sch-event', 'No event elements found');

                        case 3:
                        case "end":
                          return _context16.stop();
                      }
                    }
                  }, _callee16);
                }));

                return function (_x17) {
                  return _ref13.apply(this, arguments);
                };
              }());
              t.it('Should not draw fully excluded events 2', /*#__PURE__*/function () {
                var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
                  return regeneratorRuntime.wrap(function _callee17$(_context17) {
                    while (1) {
                      switch (_context17.prev = _context17.next) {
                        case 0:
                          _context17.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                day: {
                                  from: 1,
                                  to: 7
                                } // Exclude Su

                              }
                            },
                            viewPreset: 'weekAndMonth',
                            events: [{
                              id: 'sunday',
                              resourceId: 'r1',
                              name: 'Sunday',
                              startDate: new Date(2011, 0, 2),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'sunday2',
                              resourceId: 'r1',
                              name: 'Sunday 2',
                              startDate: new Date(2011, 0, 2, 12),
                              duration: 8,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          t.selectorNotExists('.b-sch-event', 'No event elements found');

                        case 3:
                        case "end":
                          return _context17.stop();
                      }
                    }
                  }, _callee17);
                }));

                return function (_x18) {
                  return _ref14.apply(this, arguments);
                };
              }());
              t.it('Should not draw fully excluded events 2', /*#__PURE__*/function () {
                var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
                  return regeneratorRuntime.wrap(function _callee18$(_context18) {
                    while (1) {
                      switch (_context18.prev = _context18.next) {
                        case 0:
                          _context18.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                day: {
                                  from: 0,
                                  to: 6
                                } // Exclude Sa

                              }
                            },
                            viewPreset: 'weekAndMonth',
                            events: [{
                              id: 'saturday',
                              resourceId: 'r1',
                              name: 'Saturday',
                              startDate: new Date(2011, 0, 8),
                              duration: 24,
                              durationUnit: 'h'
                            } //{ id : 'saturday2', resourceId : 'r1', name : 'Saturday 2', startDate : new Date(2011, 0, 8, 12), duration : 8, durationUnit : 'h' }
                            ]
                          });

                        case 2:
                          t.selectorNotExists('.b-sch-event', 'No event elements found');

                        case 3:
                        case "end":
                          return _context18.stop();
                      }
                    }
                  }, _callee18);
                }));

                return function (_x19) {
                  return _ref15.apply(this, arguments);
                };
              }());
              t.it('Should draw partially excluded events', /*#__PURE__*/function () {
                var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t) {
                  return regeneratorRuntime.wrap(function _callee19$(_context19) {
                    while (1) {
                      switch (_context19.prev = _context19.next) {
                        case 0:
                          _context19.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                day: {
                                  from: 1,
                                  to: 6
                                } // Exclude Su, Sa

                              }
                            },
                            viewPreset: 'weekAndMonth',
                            events: [{
                              id: 'sundayToMonday',
                              resourceId: 'r1',
                              name: 'Sunday-Monday',
                              startDate: new Date(2011, 0, 2),
                              duration: 36,
                              durationUnit: 'h'
                            }, {
                              id: 'saturdayToMonday',
                              resourceId: 'r1',
                              name: 'Saturday-Monday',
                              startDate: new Date(2011, 0, 8),
                              duration: 72,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          assertLayout(t, 'sundayToMonday', 0, 50);
                          assertLayout(t, 'saturdayToMonday', 500, 100);

                        case 4:
                        case "end":
                          return _context19.stop();
                      }
                    }
                  }, _callee19);
                }));

                return function (_x20) {
                  return _ref16.apply(this, arguments);
                };
              }());
              t.it('Should draw partially excluded events 2', /*#__PURE__*/function () {
                var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(t) {
                  return regeneratorRuntime.wrap(function _callee20$(_context20) {
                    while (1) {
                      switch (_context20.prev = _context20.next) {
                        case 0:
                          _context20.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                day: {
                                  from: 1,
                                  to: 7
                                } // Exclude Su

                              }
                            },
                            viewPreset: 'weekAndMonth',
                            events: [{
                              id: 'sundayToMonday',
                              resourceId: 'r1',
                              name: 'Sunday-Monday',
                              startDate: new Date(2011, 0, 2),
                              duration: 36,
                              durationUnit: 'h'
                            }, {
                              id: 'saturdayToMonday',
                              resourceId: 'r1',
                              name: 'Saturday-Monday',
                              startDate: new Date(2011, 0, 8),
                              duration: 72,
                              durationUnit: 'h'
                            }, {
                              id: 'saturday',
                              resourceId: 'r1',
                              name: 'Saturday',
                              startDate: new Date(2011, 0, 8),
                              duration: 24,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          assertLayout(t, 'sundayToMonday', 0, 42);
                          assertLayout(t, 'saturdayToMonday', 417, 166);
                          assertLayout(t, 'saturday', 417, 83);

                        case 5:
                        case "end":
                          return _context20.stop();
                      }
                    }
                  }, _callee20);
                }));

                return function (_x21) {
                  return _ref17.apply(this, arguments);
                };
              }());
              t.it('Should draw partially excluded events 3', /*#__PURE__*/function () {
                var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21(t) {
                  return regeneratorRuntime.wrap(function _callee21$(_context21) {
                    while (1) {
                      switch (_context21.prev = _context21.next) {
                        case 0:
                          _context21.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                day: {
                                  from: 0,
                                  to: 6
                                } // Exclude Sa

                              }
                            },
                            viewPreset: 'weekAndMonth',
                            events: [{
                              id: 'saturdayToSunday',
                              resourceId: 'r1',
                              name: 'Saturday-Sunday',
                              startDate: new Date(2011, 0, 8),
                              duration: 36,
                              durationUnit: 'h'
                            }, {
                              id: 'fridayToSunday',
                              resourceId: 'r1',
                              name: 'Friday-Sunday',
                              startDate: new Date(2011, 0, 7),
                              duration: 72,
                              durationUnit: 'h'
                            }, {
                              id: 'sunday',
                              resourceId: 'r1',
                              name: 'Sunday',
                              startDate: new Date(2011, 0, 9),
                              duration: 24,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          assertLayout(t, 'saturdayToSunday', 500, 42);
                          assertLayout(t, 'fridayToSunday', 417, 166);
                          assertLayout(t, 'sunday', 500, 83);

                        case 5:
                        case "end":
                          return _context21.stop();
                      }
                    }
                  }, _callee21);
                }));

                return function (_x22) {
                  return _ref18.apply(this, arguments);
                };
              }());
              t.it('Should stretch to fill excluded space, Su & Sa', /*#__PURE__*/function () {
                var _ref19 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
                  return regeneratorRuntime.wrap(function _callee22$(_context22) {
                    while (1) {
                      switch (_context22.prev = _context22.next) {
                        case 0:
                          _context22.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                day: {
                                  from: 1,
                                  to: 6
                                } // Exclude Su, Sa

                              }
                            },
                            viewPreset: 'weekAndMonth',
                            events: [{
                              id: 'su1',
                              resourceId: 'r1',
                              name: 'SU1',
                              startDate: new Date(2011, 0, 2),
                              duration: 8,
                              durationUnit: 'h'
                            }, {
                              id: 'mo1',
                              resourceId: 'r1',
                              name: 'MO1',
                              startDate: new Date(2011, 0, 3),
                              duration: 16,
                              durationUnit: 'h'
                            }, {
                              id: 'tu1',
                              resourceId: 'r1',
                              name: 'TU1',
                              startDate: new Date(2011, 0, 4),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'we1',
                              resourceId: 'r1',
                              name: 'WE1',
                              startDate: new Date(2011, 0, 5, 12),
                              duration: 6,
                              durationUnit: 'h'
                            }, {
                              id: 'th1',
                              resourceId: 'r1',
                              name: 'TH1',
                              startDate: new Date(2011, 0, 6),
                              duration: 8,
                              durationUnit: 'h'
                            }, {
                              id: 'fr1',
                              resourceId: 'r1',
                              name: 'FR1',
                              startDate: new Date(2011, 0, 7),
                              duration: 16,
                              durationUnit: 'h'
                            }, {
                              id: 'sa1',
                              resourceId: 'r1',
                              name: 'SA1',
                              startDate: new Date(2011, 0, 8),
                              duration: 24,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          t.notOk(getBox('su1'), 'su1 not shown');
                          assertLayout(t, 'mo1', 0, 67);
                          assertLayout(t, 'tu1', 100, 100);
                          assertLayout(t, 'we1', 250, 25);
                          assertLayout(t, 'th1', 300, 33);
                          assertLayout(t, 'fr1', 400, 67);
                          t.notOk(getBox('sa1'), 'sa1 not shown');

                        case 9:
                        case "end":
                          return _context22.stop();
                      }
                    }
                  }, _callee22);
                }));

                return function (_x23) {
                  return _ref19.apply(this, arguments);
                };
              }());
              t.it('Should stretch to fill excluded space, Su, Th, Fr, Sa', /*#__PURE__*/function () {
                var _ref20 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23(t) {
                  return regeneratorRuntime.wrap(function _callee23$(_context23) {
                    while (1) {
                      switch (_context23.prev = _context23.next) {
                        case 0:
                          _context23.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                day: {
                                  from: 1,
                                  to: 4
                                } // Exclude Su, Th, Fr, Sa -> Showing Mo, Tu, We

                              }
                            },
                            viewPreset: 'weekAndMonth',
                            events: [{
                              id: 'm1',
                              resourceId: 'r1',
                              name: 'M1',
                              startDate: new Date(2011, 0, 3),
                              duration: 8,
                              durationUnit: 'h'
                            }, // M
                            {
                              id: 't1',
                              resourceId: 'r1',
                              name: 'T1',
                              startDate: new Date(2011, 0, 4),
                              duration: 24,
                              durationUnit: 'h'
                            }, // T
                            {
                              id: 'w1',
                              resourceId: 'r1',
                              name: 'W1',
                              startDate: new Date(2011, 0, 5),
                              duration: 16,
                              durationUnit: 'h'
                            }, // W
                            {
                              id: 'm2',
                              resourceId: 'r1',
                              name: 'M2',
                              startDate: new Date(2011, 0, 10),
                              duration: 24,
                              durationUnit: 'h'
                            }, // Next M
                            {
                              id: 't2',
                              resourceId: 'r1',
                              name: 'T2',
                              startDate: new Date(2011, 0, 11),
                              duration: 8,
                              durationUnit: 'h'
                            } // Next T
                            ]
                          });

                        case 2:
                          assertLayout(t, 'm1', 0, 56);
                          assertLayout(t, 't1', 167, 167);
                          assertLayout(t, 'w1', 333, 111);
                          assertLayout(t, 'm2', 500, 167);
                          assertLayout(t, 't2', 667, 55);

                        case 7:
                        case "end":
                          return _context23.stop();
                      }
                    }
                  }, _callee23);
                }));

                return function (_x24) {
                  return _ref20.apply(this, arguments);
                };
              }());

            case 8:
            case "end":
              return _context24.stop();
          }
        }
      }, _callee24);
    }));

    return function (_x16) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('Should handle weekStartDay = 1', /*#__PURE__*/function () {
    var _ref21 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee29(t) {
      var getSch, _getSch7;

      return regeneratorRuntime.wrap(function _callee29$(_context29) {
        while (1) {
          switch (_context29.prev = _context29.next) {
            case 0:
              _getSch7 = function _getSch9() {
                _getSch7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee28(config) {
                  return regeneratorRuntime.wrap(function _callee28$(_context28) {
                    while (1) {
                      switch (_context28.prev = _context28.next) {
                        case 0:
                          _context28.next = 2;
                          return getScheduler(Object.assign({
                            timeAxis: {
                              include: {
                                day: {
                                  from: 1,
                                  to: 6
                                }
                              }
                            },
                            weekStartDay: 1,
                            startDate: new Date(2019, 1, 11),
                            endDate: new Date(2019, 1, 25),
                            viewPreset: 'weekAndMonth'
                          }, config));

                        case 2:
                        case "end":
                          return _context28.stop();
                      }
                    }
                  }, _callee28);
                }));
                return _getSch7.apply(this, arguments);
              };

              getSch = function _getSch8(_x26) {
                return _getSch7.apply(this, arguments);
              };

              t.it('Should not draw fully excluded events', /*#__PURE__*/function () {
                var _ref22 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee25(t) {
                  return regeneratorRuntime.wrap(function _callee25$(_context25) {
                    while (1) {
                      switch (_context25.prev = _context25.next) {
                        case 0:
                          _context25.next = 2;
                          return getSch({
                            events: [{
                              id: 'sunday',
                              resourceId: 'r1',
                              name: 'Sunday',
                              startDate: new Date(2019, 1, 17),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'saturday',
                              resourceId: 'r1',
                              name: 'Saturday',
                              startDate: new Date(2019, 1, 16),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'weekend',
                              resourceId: 'r1',
                              name: 'Weekend',
                              startDate: new Date(2019, 1, 16),
                              duration: 48,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          t.selectorNotExists('.b-sch-event', 'No event elements found');

                        case 3:
                        case "end":
                          return _context25.stop();
                      }
                    }
                  }, _callee25);
                }));

                return function (_x27) {
                  return _ref22.apply(this, arguments);
                };
              }());
              t.it('Should stretch to fill excluded space', /*#__PURE__*/function () {
                var _ref23 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee26(t) {
                  return regeneratorRuntime.wrap(function _callee26$(_context26) {
                    while (1) {
                      switch (_context26.prev = _context26.next) {
                        case 0:
                          _context26.next = 2;
                          return getSch({
                            events: [{
                              id: 'mo1',
                              resourceId: 'r1',
                              name: 'MO1',
                              startDate: new Date(2019, 1, 11),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'tu1',
                              resourceId: 'r1',
                              name: 'TU1',
                              startDate: new Date(2019, 1, 12),
                              duration: 12,
                              durationUnit: 'h'
                            }, {
                              id: 'we1',
                              resourceId: 'r1',
                              name: 'WE1',
                              startDate: new Date(2019, 1, 13),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'th1',
                              resourceId: 'r1',
                              name: 'TH1',
                              startDate: new Date(2019, 1, 14),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'fr1',
                              resourceId: 'r1',
                              name: 'FR1',
                              startDate: new Date(2019, 1, 15),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'sa1',
                              resourceId: 'r1',
                              name: 'SA1',
                              startDate: new Date(2019, 1, 16),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'su1',
                              resourceId: 'r1',
                              name: 'SU1',
                              startDate: new Date(2019, 1, 17),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'mo2',
                              resourceId: 'r1',
                              name: 'MO2',
                              startDate: new Date(2019, 1, 18),
                              duration: 6,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          assertLayout(t, 'mo1', 0, 100);
                          assertLayout(t, 'tu1', 100, 50);
                          assertLayout(t, 'we1', 200, 100);
                          assertLayout(t, 'th1', 300, 100);
                          assertLayout(t, 'fr1', 400, 100);
                          t.notOk(getBox('sa1'), 'sa1 not shown');
                          t.notOk(getBox('su1'), 'su1 not shown');
                          assertLayout(t, 'mo2', 500, 25);

                        case 10:
                        case "end":
                          return _context26.stop();
                      }
                    }
                  }, _callee26);
                }));

                return function (_x28) {
                  return _ref23.apply(this, arguments);
                };
              }());
              t.it('Should stretch to fill excluded space 2', /*#__PURE__*/function () {
                var _ref24 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee27(t) {
                  return regeneratorRuntime.wrap(function _callee27$(_context27) {
                    while (1) {
                      switch (_context27.prev = _context27.next) {
                        case 0:
                          _context27.next = 2;
                          return getSch({
                            timeAxis: {
                              include: {
                                day: {
                                  from: 1,
                                  to: 6
                                },
                                hour: {
                                  from: 9,
                                  to: 14
                                }
                              }
                            },
                            events: [{
                              id: 'mo1',
                              resourceId: 'r1',
                              name: 'MO1',
                              startDate: new Date(2019, 1, 11, 9),
                              duration: 5,
                              durationUnit: 'h'
                            }, {
                              id: 'tu1',
                              resourceId: 'r1',
                              name: 'TU1',
                              startDate: new Date(2019, 1, 12, 10),
                              duration: 1,
                              durationUnit: 'h'
                            }, {
                              id: 'we1',
                              resourceId: 'r1',
                              name: 'WE1',
                              startDate: new Date(2019, 1, 13, 9),
                              duration: 5,
                              durationUnit: 'h'
                            }, {
                              id: 'th1',
                              resourceId: 'r1',
                              name: 'TH1',
                              startDate: new Date(2019, 1, 14, 9),
                              duration: 5,
                              durationUnit: 'h'
                            }, {
                              id: 'fr1',
                              resourceId: 'r1',
                              name: 'FR1',
                              startDate: new Date(2019, 1, 15),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'sa1',
                              resourceId: 'r1',
                              name: 'SA1',
                              startDate: new Date(2019, 1, 16),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'su1',
                              resourceId: 'r1',
                              name: 'SU1',
                              startDate: new Date(2019, 1, 17),
                              duration: 24,
                              durationUnit: 'h'
                            }, {
                              id: 'mo2',
                              resourceId: 'r1',
                              name: 'MO2',
                              startDate: new Date(2019, 1, 18),
                              duration: 24,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          assertLayout(t, 'mo1', 0, 100);
                          assertLayout(t, 'tu1', 120, 20);
                          assertLayout(t, 'we1', 200, 100);
                          assertLayout(t, 'th1', 300, 100);
                          assertLayout(t, 'fr1', 400, 100);
                          t.notOk(getBox('sa1'), 'sa1 not shown');
                          t.notOk(getBox('su1'), 'su1 not shown');
                          assertLayout(t, 'mo2', 500, 100);

                        case 10:
                        case "end":
                          return _context27.stop();
                      }
                    }
                  }, _callee27);
                }));

                return function (_x29) {
                  return _ref24.apply(this, arguments);
                };
              }());

            case 5:
            case "end":
              return _context29.stop();
          }
        }
      }, _callee29);
    }));

    return function (_x25) {
      return _ref21.apply(this, arguments);
    };
  }());
  t.it('Should handle timeAxis#include#hour for "larger" ticks', /*#__PURE__*/function () {
    var _ref25 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee34(t) {
      return regeneratorRuntime.wrap(function _callee34$(_context34) {
        while (1) {
          switch (_context34.prev = _context34.next) {
            case 0:
              t.it('Should not draw fully excluded events', /*#__PURE__*/function () {
                var _ref26 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee30(t) {
                  return regeneratorRuntime.wrap(function _callee30$(_context30) {
                    while (1) {
                      switch (_context30.prev = _context30.next) {
                        case 0:
                          _context30.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                hour: {
                                  from: 8,
                                  to: 16
                                }
                              }
                            },
                            viewPreset: 'weekAndMonth',
                            events: [{
                              id: 'early',
                              resourceId: 'r1',
                              name: 'Early',
                              startDate: new Date(2011, 0, 7),
                              duration: 4,
                              durationUnit: 'h'
                            }, {
                              id: 'late',
                              resourceId: 'r1',
                              name: 'Late',
                              startDate: new Date(2011, 0, 7, 18),
                              duration: 4,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          t.selectorNotExists('.b-sch-event', 'No event elements found');

                        case 3:
                        case "end":
                          return _context30.stop();
                      }
                    }
                  }, _callee30);
                }));

                return function (_x31) {
                  return _ref26.apply(this, arguments);
                };
              }());
              t.it('Should draw partially excluded events', /*#__PURE__*/function () {
                var _ref27 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee31(t) {
                  return regeneratorRuntime.wrap(function _callee31$(_context31) {
                    while (1) {
                      switch (_context31.prev = _context31.next) {
                        case 0:
                          _context31.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                hour: {
                                  from: 8,
                                  to: 16
                                }
                              }
                            },
                            viewPreset: 'weekAndMonth',
                            tickSize: 700,
                            events: [{
                              id: 'early',
                              resourceId: 'r1',
                              name: 'Early',
                              startDate: new Date(2011, 0, 7, 7),
                              duration: 2,
                              durationUnit: 'h'
                            }, {
                              id: 'long',
                              resourceId: 'r1',
                              name: 'Long',
                              startDate: new Date(2011, 0, 7),
                              duration: 16,
                              durationUnit: 'h'
                            }, {
                              id: 'late',
                              resourceId: 'r1',
                              name: 'Late',
                              startDate: new Date(2011, 0, 7, 15),
                              duration: 4,
                              durationUnit: 'h'
                            }, {
                              id: 'twodays',
                              resourceId: 'r1',
                              name: 'Two days',
                              startDate: new Date(2011, 0, 7),
                              duration: 48,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          assertLayout(t, 'early', 500, 12);
                          assertLayout(t, 'long', 500, 100);
                          assertLayout(t, 'late', 588, 12);
                          assertLayout(t, 'twodays', 500, 200);

                        case 6:
                        case "end":
                          return _context31.stop();
                      }
                    }
                  }, _callee31);
                }));

                return function (_x32) {
                  return _ref27.apply(this, arguments);
                };
              }());
              t.it('Should stretch to fill excluded space, 8-16', /*#__PURE__*/function () {
                var _ref28 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee32(t) {
                  return regeneratorRuntime.wrap(function _callee32$(_context32) {
                    while (1) {
                      switch (_context32.prev = _context32.next) {
                        case 0:
                          _context32.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                hour: {
                                  from: 8,
                                  to: 16
                                }
                              }
                            },
                            viewPreset: 'weekAndMonth',
                            events: [{
                              id: '8to16',
                              resourceId: 'r1',
                              name: 'Fr, 8to16',
                              startDate: new Date(2011, 0, 7, 8),
                              duration: 8,
                              durationUnit: 'h'
                            }, {
                              id: '8to12',
                              resourceId: 'r1',
                              name: 'Fr, 8to12',
                              startDate: new Date(2011, 0, 7, 8),
                              duration: 4,
                              durationUnit: 'h'
                            }, {
                              id: '12to16',
                              resourceId: 'r1',
                              name: 'Fr, 12to16',
                              startDate: new Date(2011, 0, 7, 12),
                              duration: 4,
                              durationUnit: 'h'
                            }, {
                              id: '7to17',
                              resourceId: 'r1',
                              name: 'Fr, 7to17',
                              startDate: new Date(2011, 0, 7, 7),
                              duration: 10,
                              durationUnit: 'h'
                            }, {
                              id: '2days',
                              resourceId: 'r1',
                              name: 'Mo-Tu',
                              startDate: new Date(2011, 0, 10),
                              duration: 48,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          assertLayout(t, '8to16', 357, 72);
                          assertLayout(t, '8to12', 357, 36);
                          assertLayout(t, '12to16', 393, 36);
                          assertLayout(t, '7to17', 357, 72);
                          assertLayout(t, '2days', 571, 143);

                        case 7:
                        case "end":
                          return _context32.stop();
                      }
                    }
                  }, _callee32);
                }));

                return function (_x33) {
                  return _ref28.apply(this, arguments);
                };
              }());
              t.it('Should stretch to fill excluded space, 5-15', /*#__PURE__*/function () {
                var _ref29 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee33(t) {
                  return regeneratorRuntime.wrap(function _callee33$(_context33) {
                    while (1) {
                      switch (_context33.prev = _context33.next) {
                        case 0:
                          _context33.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                hour: {
                                  from: 5,
                                  to: 15
                                }
                              }
                            },
                            viewPreset: 'weekAndMonth',
                            events: [{
                              id: '8to16',
                              resourceId: 'r1',
                              name: 'Fr, 8to16',
                              startDate: new Date(2011, 0, 7, 8),
                              duration: 8,
                              durationUnit: 'h'
                            }, {
                              id: '8to12',
                              resourceId: 'r1',
                              name: 'Fr, 8to12',
                              startDate: new Date(2011, 0, 7, 8),
                              duration: 4,
                              durationUnit: 'h'
                            }, {
                              id: '12to16',
                              resourceId: 'r1',
                              name: 'Fr, 12to16',
                              startDate: new Date(2011, 0, 7, 12),
                              duration: 4,
                              durationUnit: 'h'
                            }, {
                              id: '7to17',
                              resourceId: 'r1',
                              name: 'Fr, 7to17',
                              startDate: new Date(2011, 0, 7, 7),
                              duration: 10,
                              durationUnit: 'h'
                            }, {
                              id: '2days',
                              resourceId: 'r1',
                              name: 'Mo-Tu',
                              startDate: new Date(2011, 0, 10),
                              duration: 48,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          assertLayout(t, '8to16', 378, 51);
                          assertLayout(t, '8to12', 378, 28);
                          assertLayout(t, '12to16', 408, 21);
                          assertLayout(t, '7to17', 372, 57);
                          assertLayout(t, '2days', 571, 143);

                        case 7:
                        case "end":
                          return _context33.stop();
                      }
                    }
                  }, _callee33);
                }));

                return function (_x34) {
                  return _ref29.apply(this, arguments);
                };
              }());

            case 4:
            case "end":
              return _context34.stop();
          }
        }
      }, _callee34);
    }));

    return function (_x30) {
      return _ref25.apply(this, arguments);
    };
  }());
  t.it('Should handle timeAxis#include combinations for "larger" ticks', /*#__PURE__*/function () {
    var _ref30 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee37(t) {
      return regeneratorRuntime.wrap(function _callee37$(_context37) {
        while (1) {
          switch (_context37.prev = _context37.next) {
            case 0:
              t.it('Work week and hours', /*#__PURE__*/function () {
                var _ref31 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee35(t) {
                  return regeneratorRuntime.wrap(function _callee35$(_context35) {
                    while (1) {
                      switch (_context35.prev = _context35.next) {
                        case 0:
                          _context35.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                day: {
                                  from: 1,
                                  to: 6
                                },
                                hour: {
                                  from: 8,
                                  to: 16
                                }
                              }
                            },
                            viewPreset: 'weekAndMonth',
                            events: [{
                              id: 'sunday',
                              resourceId: 'r1',
                              name: 'S 8-16',
                              startDate: new Date(2011, 0, 2, 8),
                              duration: 8,
                              durationUnit: 'h'
                            }, {
                              id: 'monday',
                              resourceId: 'r1',
                              name: 'M 8-16',
                              startDate: new Date(2011, 0, 3, 8),
                              duration: 8,
                              durationUnit: 'h'
                            }, {
                              id: 'tuesday',
                              resourceId: 'r1',
                              name: 'T 8-16',
                              startDate: new Date(2011, 0, 4, 8),
                              duration: 8,
                              durationUnit: 'h'
                            }, {
                              id: 'wednesday',
                              resourceId: 'r1',
                              name: 'W 8-12',
                              startDate: new Date(2011, 0, 5, 8),
                              duration: 4,
                              durationUnit: 'h'
                            }, {
                              id: 'thursday',
                              resourceId: 'r1',
                              name: 'T 12-16',
                              startDate: new Date(2011, 0, 6, 12),
                              duration: 4,
                              durationUnit: 'h'
                            }, {
                              id: 'friday',
                              resourceId: 'r1',
                              name: 'F 8-16',
                              startDate: new Date(2011, 0, 7, 8),
                              duration: 8,
                              durationUnit: 'h'
                            }, {
                              id: 'saturday',
                              resourceId: 'r1',
                              name: 'S 8-16',
                              startDate: new Date(2011, 0, 8, 8),
                              duration: 8,
                              durationUnit: 'h'
                            }, {
                              id: 'twodays',
                              resourceId: 'r1',
                              name: 'M-T',
                              startDate: new Date(2011, 0, 10),
                              duration: 48,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          t.notOk(getBox('sunday'), 'sunday not found');
                          assertLayout(t, 'monday', 0, 100);
                          assertLayout(t, 'tuesday', 100, 100);
                          assertLayout(t, 'wednesday', 200, 50);
                          assertLayout(t, 'thursday', 350, 50);
                          assertLayout(t, 'friday', 400, 100);
                          t.notOk(getBox('saturday'), 'saturday not found');
                          assertLayout(t, 'twodays', 500, 200);

                        case 10:
                        case "end":
                          return _context35.stop();
                      }
                    }
                  }, _callee35);
                }));

                return function (_x36) {
                  return _ref31.apply(this, arguments);
                };
              }());
              t.it('Long work week and hours', /*#__PURE__*/function () {
                var _ref32 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee36(t) {
                  return regeneratorRuntime.wrap(function _callee36$(_context36) {
                    while (1) {
                      switch (_context36.prev = _context36.next) {
                        case 0:
                          _context36.next = 2;
                          return getScheduler({
                            timeAxis: {
                              include: {
                                day: {
                                  from: 1,
                                  to: 7
                                },
                                hour: {
                                  from: 7,
                                  to: 16
                                }
                              }
                            },
                            viewPreset: 'weekAndMonth',
                            events: [{
                              id: 'sunday',
                              resourceId: 'r1',
                              name: 'S 8-16',
                              startDate: new Date(2011, 0, 2, 8),
                              duration: 8,
                              durationUnit: 'h'
                            }, {
                              id: 'monday',
                              resourceId: 'r1',
                              name: 'M 7-16',
                              startDate: new Date(2011, 0, 3, 7),
                              duration: 9,
                              durationUnit: 'h'
                            }, {
                              id: 'tuesday',
                              resourceId: 'r1',
                              name: 'T 8-16',
                              startDate: new Date(2011, 0, 4, 8),
                              duration: 8,
                              durationUnit: 'h'
                            }, {
                              id: 'wednesday',
                              resourceId: 'r1',
                              name: 'W 4-8',
                              startDate: new Date(2011, 0, 5, 4),
                              duration: 4,
                              durationUnit: 'h'
                            }, {
                              id: 'thursday',
                              resourceId: 'r1',
                              name: 'T 4-20',
                              startDate: new Date(2011, 0, 6, 4),
                              duration: 16,
                              durationUnit: 'h'
                            }, {
                              id: 'friday',
                              resourceId: 'r1',
                              name: 'F 7-8',
                              startDate: new Date(2011, 0, 7, 7),
                              duration: 1,
                              durationUnit: 'h'
                            }, {
                              id: 'saturday',
                              resourceId: 'r1',
                              name: 'S 7-16',
                              startDate: new Date(2011, 0, 8, 7),
                              duration: 9,
                              durationUnit: 'h'
                            }, {
                              id: 'twodays',
                              resourceId: 'r1',
                              name: 'M-T',
                              startDate: new Date(2011, 0, 10),
                              duration: 48,
                              durationUnit: 'h'
                            }]
                          });

                        case 2:
                          t.notOk(getBox('sunday'), 'sunday not found');
                          assertLayout(t, 'monday', 0, 83);
                          assertLayout(t, 'tuesday', 92, 75);
                          assertLayout(t, 'wednesday', 167, 9);
                          assertLayout(t, 'thursday', 250, 83);
                          assertLayout(t, 'friday', 333, 9);
                          assertLayout(t, 'saturday', 417, 83);
                          assertLayout(t, 'twodays', 500, 167);

                        case 10:
                        case "end":
                          return _context36.stop();
                      }
                    }
                  }, _callee36);
                }));

                return function (_x37) {
                  return _ref32.apply(this, arguments);
                };
              }());

            case 2:
            case "end":
              return _context37.stop();
          }
        }
      }, _callee37);
    }));

    return function (_x35) {
      return _ref30.apply(this, arguments);
    };
  }());
  t.it('Should reconfigure time axis when applying working time', /*#__PURE__*/function () {
    var _ref33 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee38(t) {
      return regeneratorRuntime.wrap(function _callee38$(_context38) {
        while (1) {
          switch (_context38.prev = _context38.next) {
            case 0:
              _context38.next = 2;
              return t.getSchedulerAsync({
                width: 1000,
                columns: []
              });

            case 2:
              scheduler = _context38.sent;
              t.diag('workingTime assigned');
              scheduler.workingTime = {
                fromDay: 1,
                toDay: 6
              };
              t.selectorNotExists('.b-sch-dayheadercell-6', 'No saturdays');
              t.selectorNotExists('.b-sch-dayheadercell-0', 'No sundays');
              t.diag('workingTime unassigned');
              scheduler.workingTime = null;
              t.selectorExists('.b-sch-dayheadercell-6', 'Saturdays found');
              t.selectorExists('.b-sch-dayheadercell-0', 'Sundays found');

            case 11:
            case "end":
              return _context38.stop();
          }
        }
      }, _callee38);
    }));

    return function (_x38) {
      return _ref33.apply(this, arguments);
    };
  }());
  t.it('Should update header when changing working time config', /*#__PURE__*/function () {
    var _ref34 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee39(t) {
      return regeneratorRuntime.wrap(function _callee39$(_context39) {
        while (1) {
          switch (_context39.prev = _context39.next) {
            case 0:
              _context39.next = 2;
              return t.getSchedulerAsync({
                width: 800,
                height: 600,
                startDate: new Date(2021, 3, 28),
                endDate: new Date(2021, 3, 29),
                viewPreset: 'hourAndDay',
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: '2021-04-28 12:00',
                  endDate: '2021-04-28 14:00'
                }]
              });

            case 2:
              scheduler = _context39.sent;
              _context39.next = 5;
              return t.waitForSelector('.b-grid-row');

            case 5:
              scheduler.workingTime = {
                fromDay: 0,
                toDay: 7,
                fromHour: 10,
                toHour: 16
              };
              t.is(scheduler.timeAxis.count, 6, 'Correct amount of ticks');
              t.is(scheduler.startDate, new Date(2021, 3, 28, 10), 'Start date is ok');
              t.is(scheduler.endDate, new Date(2021, 3, 28, 16), 'End date is ok');
              t.is(scheduler.timeAxisSubGrid.scrollable.scrollWidth, 6 * scheduler.tickSize, 'Time axis scroll width is ok');
              t.selectorCountIs('.b-sch-header-row-1 .b-sch-header-timeaxis-cell', 6, 'Correct amount of ticks rendered');

            case 11:
            case "end":
              return _context39.stop();
          }
        }
      }, _callee39);
    }));

    return function (_x39) {
      return _ref34.apply(this, arguments);
    };
  }());
});