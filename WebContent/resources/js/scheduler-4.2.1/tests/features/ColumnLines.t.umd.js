function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && !scheduler.isDestroyed && scheduler.destroy();
  });

  function assertColumnLines(t) {
    var skipExists = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;
    var bottomCells = t.query(".b-sch-header-row-1 .b-sch-header-timeaxis-cell"),
        topCells = t.query(".b-sch-header-row-0 .b-sch-header-timeaxis-cell");

    if (bottomCells.length > 1) {
      t.selectorExists('.b-column-line', 'Column lines found');
      var bottomCorrect = true;
      bottomCells.forEach(function (element, i) {
        if (i) {
          var line = document.querySelector(".b-column-line[data-line=\"line-".concat(element.dataset.tickIndex, "\"]")),
              left = element.getBoundingClientRect().left; // Some lines might be replaced by major lines, thus the check that line exists

          if (line && Math.abs(line.getBoundingClientRect().left - left) > 0.5) {
            t.fail("Misalign for bottom line ".concat(element.dataset.tickIndex, ", expected ").concat(left, ", got ").concat(line.offsetLeft));
            bottomCorrect = false;
          }
        }
      });

      if (bottomCorrect) {
        t.pass('Bottom lines align');
      }
    }

    if (topCells.length > 1) {
      if (!skipExists) {
        t.selectorExists('.b-column-line-major', 'Major lines found');
      }

      var topCorrect = true;
      topCells.forEach(function (element, i) {
        if (i) {
          var line = document.querySelector(".b-column-line-major[data-line=\"major-".concat(element.dataset.tickIndex, "\"]")),
              left = element.getBoundingClientRect().left; // Some lines might be replaced by major lines, thus the check that line exists

          if (line && Math.abs(line.getBoundingClientRect().left - left) > 0.5) {
            t.fail("Misalign for major line ".concat(element.dataset.tickIndex, ", expected ").concat(left, ", got ").concat(line.offsetLeft));
            topCorrect = false;
          }
        }
      });

      if (topCorrect) {
        t.pass('Top lines align');
      }
    }
  }

  t.it('Column lines align initially', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                features: {
                  columnLines: true
                }
              });

            case 2:
              scheduler = _context.sent;
              assertColumnLines(t);
              scheduler.zoomOut();
              _context.next = 7;
              return t.waitForAnimationFrame();

            case 7:
              assertColumnLines(t);
              scheduler.zoomOut();
              _context.next = 11;
              return t.waitForAnimationFrame();

            case 11:
              assertColumnLines(t);
              scheduler.zoomIn();

            case 13:
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
  t.it('Column lines appear properly (zooming)', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var steps, i;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              scheduler = new Scheduler({
                features: {
                  columnLines: true
                },
                columns: [{
                  field: 'name',
                  width: 150
                }],
                resources: [{
                  id: 1,
                  name: 'Steve',
                  job: 'Carpenter'
                }, {
                  id: 2,
                  name: 'John',
                  job: 'Contractor'
                }],
                events: [{
                  id: 1,
                  name: 'Work',
                  resourceId: 1,
                  startDate: new Date(2017, 0, 1),
                  endDate: new Date(2017, 0, 5)
                }, {
                  id: 2,
                  name: 'Plan',
                  resourceId: 2,
                  startDate: new Date(2017, 0, 2),
                  endDate: new Date(2017, 0, 6)
                }],
                startDate: new Date(2017, 0, 1),
                endDate: new Date(2017, 0, 1, 0, 5),
                viewPreset: 'secondAndMinute',
                barMargin: 0,
                rowHeight: 55,
                appendTo: document.body
              });
              steps = [];

              for (i = scheduler.presets.count; i > 0; --i) {
                steps.push( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                  return regeneratorRuntime.wrap(function _callee2$(_context2) {
                    while (1) {
                      switch (_context2.prev = _context2.next) {
                        case 0:
                          scheduler.zoomOut();
                          _context2.next = 3;
                          return t.waitForAnimationFrame();

                        case 3:
                          t.diag("Zoom level ".concat(scheduler.zoomLevel));
                          assertColumnLines(t);

                        case 5:
                        case "end":
                          return _context2.stop();
                      }
                    }
                  }, _callee2);
                })));
              }

              t.chain({
                waitForProjectReady: scheduler.project
              }, {
                waitForSelector: '.b-sch-timeaxis-cell'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        scheduler.zoomToLevel(25);
                        _context3.next = 3;
                        return t.waitForAnimationFrame();

                      case 3:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3);
              })), steps);

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('Column lines work properly for complex header', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              PresetManager.registerPreset('dayNightShift', {
                tickWidth: 35,
                rowHeight: 32,
                displayDateFormat: 'HH:mm',
                shiftIncrement: 1,
                shiftUnit: 'day',
                timeResolution: {
                  unit: 'minute',
                  increment: 15
                },
                defaultSpan: 24,
                columnLinesFor: 1,
                headers: [{
                  unit: 'day',
                  increment: 1
                }, {
                  unit: 'hour',
                  increment: 12
                }, {
                  unit: 'hour',
                  increment: 2,
                  dateFormat: 'H'
                }]
              });
              _context5.next = 3;
              return t.getSchedulerAsync({
                features: {
                  columnLines: true
                },
                viewPreset: 'dayNightShift',
                startDate: new Date(2017, 0, 1),
                endDate: new Date(2019, 0, 6)
              });

            case 3:
              scheduler = _context5.sent;
              assertColumnLines(t);

            case 5:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x3) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should align when filtering time axis', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getSchedulerAsync({
                features: {
                  columnLines: true
                }
              });

            case 2:
              scheduler = _context6.sent;
              scheduler.timeAxis.filter(function (tick) {
                return tick.startDate.getDay() !== 0;
              });
              _context6.next = 6;
              return t.waitForAnimationFrame();

            case 6:
              assertColumnLines(t);
              scheduler.timeAxis.clearFilters();
              _context6.next = 10;
              return t.waitForAnimationFrame();

            case 10:
              assertColumnLines(t);
              scheduler.timeAxis.filter(function (tick) {
                return tick.startDate.getDay() < 3;
              });
              _context6.next = 14;
              return t.waitForAnimationFrame();

            case 14:
              assertColumnLines(t);

            case 15:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x4) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Should align when resizing viewport', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return t.getSchedulerAsync({
                features: {
                  columnLines: true
                }
              });

            case 2:
              scheduler = _context10.sent;
              t.chain({
                waitForEvent: [scheduler, 'horizontalscroll'],
                trigger: function trigger() {
                  return t.setWindowSize(900, 768);
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                return regeneratorRuntime.wrap(function _callee7$(_context7) {
                  while (1) {
                    switch (_context7.prev = _context7.next) {
                      case 0:
                        _context7.next = 2;
                        return t.waitForAnimationFrame();

                      case 2:
                        assertColumnLines(t);

                      case 3:
                      case "end":
                        return _context7.stop();
                    }
                  }
                }, _callee7);
              })), {
                waitForEvent: [scheduler, 'horizontalscroll'],
                trigger: function trigger() {
                  return t.setWindowSize(1200, 768);
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8() {
                return regeneratorRuntime.wrap(function _callee8$(_context8) {
                  while (1) {
                    switch (_context8.prev = _context8.next) {
                      case 0:
                        _context8.next = 2;
                        return t.waitForAnimationFrame();

                      case 2:
                        assertColumnLines(t);

                      case 3:
                      case "end":
                        return _context8.stop();
                    }
                  }
                }, _callee8);
              })), {
                waitForEvent: [scheduler, 'horizontalscroll'],
                trigger: function trigger() {
                  return t.setWindowSize(1024, 768);
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9() {
                return regeneratorRuntime.wrap(function _callee9$(_context9) {
                  while (1) {
                    switch (_context9.prev = _context9.next) {
                      case 0:
                        _context9.next = 2;
                        return t.waitForAnimationFrame();

                      case 2:
                        assertColumnLines(t);

                      case 3:
                      case "end":
                        return _context9.stop();
                    }
                  }
                }, _callee9);
              })));

            case 4:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x5) {
      return _ref7.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7492

  t.it('Should align with autoAdjustTimeAxis false', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return t.getSchedulerAsync({
                features: {
                  columnLines: true
                },
                startDate: new Date(2016, 11, 30),
                endDate: new Date(2017, 0, 10),
                viewPreset: 'weekAndDay',
                autoAdjustTimeAxis: false
              });

            case 2:
              scheduler = _context11.sent;
              assertColumnLines(t);

            case 4:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x6) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Should support disabling', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return t.getSchedulerAsync({
                features: {
                  columnLines: true
                }
              });

            case 2:
              scheduler = _context12.sent;
              scheduler.features.columnLines.disabled = true;
              _context12.next = 6;
              return t.waitForAnimationFrame();

            case 6:
              t.selectorNotExists('.b-column-line', 'No column lines');
              scheduler.features.columnLines.disabled = false;
              _context12.next = 10;
              return t.waitForAnimationFrame();

            case 10:
              t.selectorExists('.b-column-line', 'Column lines');

            case 11:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x7) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('Should update column lines when reconfiguring working time', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              _context13.next = 2;
              return t.getSchedulerAsync({
                features: {
                  columnLines: true
                },
                width: 1000,
                columns: [],
                workingTime: {
                  fromDay: 1,
                  toDay: 6
                },
                startDate: '2011-01-03',
                endDate: '2011-01-09'
              });

            case 2:
              scheduler = _context13.sent;
              t.diag('1 - 6');
              scheduler.workingTime = {
                fromDay: 1,
                toDay: 5
              };
              _context13.next = 7;
              return t.waitForAnimationFrame();

            case 7:
              assertColumnLines(t, true);
              t.diag('1 - 5');
              scheduler.workingTime = {
                fromDay: 1,
                toDay: 5
              };
              _context13.next = 12;
              return t.waitForAnimationFrame();

            case 12:
              assertColumnLines(t, true);
              t.diag('1 - 4');
              scheduler.workingTime = {
                fromDay: 1,
                toDay: 4
              };
              _context13.next = 17;
              return t.waitForAnimationFrame();

            case 17:
              assertColumnLines(t, true);
              t.diag('1 - 3');
              scheduler.workingTime = {
                fromDay: 1,
                toDay: 3
              };
              _context13.next = 22;
              return t.waitForAnimationFrame();

            case 22:
              assertColumnLines(t, true);
              t.diag('1 - 2');
              scheduler.workingTime = {
                fromDay: 1,
                toDay: 2
              };
              _context13.next = 27;
              return t.waitForAnimationFrame();

            case 27:
              assertColumnLines(t, true);

            case 28:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x8) {
      return _ref13.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1199

  t.it('Should keep showing the bold ticks when working time is applied for week days', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              scheduler = t.getScheduler({
                workingTime: {
                  fromDay: 1,
                  toDay: 6
                },
                startDate: new Date(2017, 0, 1),
                endDate: new Date(2017, 0, 20),
                viewPreset: 'weekAndDay'
              });
              _context14.next = 3;
              return t.waitForAnimationFrame();

            case 3:
              scheduler.backgroundCanvas.style.pointerEvents = 'all';
              t.ok(t.elementIsTop('.b-column-line-major'));

            case 5:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x9) {
      return _ref14.apply(this, arguments);
    };
  }());
  t.it('Should update column lines when reconfiguring working time', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return t.getSchedulerAsync({
                width: 1000,
                columns: [],
                workingTime: {
                  fromDay: 1,
                  toDay: 6
                },
                startDate: '2011-01-03',
                endDate: '2011-01-09'
              });

            case 2:
              scheduler = _context15.sent;
              scheduler.workingTime = {
                fromDay: 1,
                toDay: 5
              };
              _context15.next = 6;
              return t.waitForAnimationFrame();

            case 6:
              assertColumnLines(t, true);
              scheduler.workingTime = {
                fromDay: 1,
                toDay: 4
              };
              _context15.next = 10;
              return t.waitForAnimationFrame();

            case 10:
              assertColumnLines(t, true);
              scheduler.workingTime = {
                fromDay: 1,
                toDay: 3
              };
              _context15.next = 14;
              return t.waitForAnimationFrame();

            case 14:
              assertColumnLines(t, true);
              scheduler.workingTime = {
                fromDay: 1,
                toDay: 2
              };
              _context15.next = 18;
              return t.waitForAnimationFrame();

            case 18:
              assertColumnLines(t, true);

            case 19:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x10) {
      return _ref15.apply(this, arguments);
    };
  }());
});