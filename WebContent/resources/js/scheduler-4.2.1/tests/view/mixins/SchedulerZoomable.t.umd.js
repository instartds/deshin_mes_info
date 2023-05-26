function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    return scheduler && scheduler.destroy();
  });

  function getMSPPX() {
    return scheduler.getDateFromCoordinate(1) - scheduler.startDate;
  }

  t.it('Should zoom to preset', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'weekAndDay',
      startDate: new Date(2018, 4, 20),
      endDate: new Date(2018, 4, 27)
    });
    var centerDate = scheduler.viewportCenterDate;

    function assertZoom(preset) {
      // check if center date is saved
      // TODO: Relaxed by  * 1.1, remove as part of #7882
      t.isApprox(scheduler.viewportCenterDate.getTime(), centerDate.getTime(), getMSPPX() * 1.1, 'Center date is ok');
      t.is(scheduler.timeAxisViewModel.viewPreset.id, preset, 'View preset is correct');
    }

    t.willFireNTimes(scheduler, 'timeAxisChange', 3);
    t.chain({
      waitForSelector: '.b-sch-timeaxis-cell'
    }, function () {
      var preset = 'minuteAndHour';
      scheduler.zoomTo(preset);
      assertZoom(preset);
      preset = 'monthAndYear';
      scheduler.zoomTo(preset);
      assertZoom(preset);
      preset = 'dayAndWeek';
      scheduler.zoomTo(preset);
      assertZoom(preset);
    });
  });
  t.it('Should fire presetChange with correct signature when zoom to a viewpreset', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'weekAndDay',
      startDate: new Date(2018, 4, 20),
      endDate: new Date(2018, 4, 27)
    });
    t.firesOnce(scheduler, 'presetChange');
    scheduler.on({
      presetChange: function presetChange(_ref) {
        var from = _ref.from,
            to = _ref.to;
        t.is(to.id, 'minuteAndHour');
        t.ok(to.equals(PresetManager.getPreset('minuteAndHour')));
      }
    });
    t.chain({
      waitForRowsVisible: scheduler
    }, function () {
      scheduler.zoomTo('minuteAndHour');
    });
  });
  t.it('Should fire presetChange with correct signature when zoom to a timespan', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'weekAndDay',
      startDate: new Date(2018, 4, 20),
      endDate: new Date(2018, 4, 27)
    });
    t.firesOnce(scheduler, 'presetChange');
    scheduler.on({
      presetChange: function presetChange(_ref2) {
        var from = _ref2.from,
            to = _ref2.to;
        t.is(to.id, 'year');
        t.ok(to.equals(PresetManager.getPreset('year')));
      }
    });
    t.chain({
      waitForRowsVisible: scheduler
    }, function () {
      scheduler.zoomToSpan({
        startDate: new Date(2017, 4, 20),
        endDate: new Date(2019, 4, 27)
      });
    });
  });
  t.it('Should fire presetChange with correct signature when zoom to a level', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'weekAndDay',
      startDate: new Date(2018, 4, 20),
      endDate: new Date(2018, 4, 27)
    });
    t.firesOnce(scheduler, 'presetChange');
    scheduler.on({
      presetChange: function presetChange(_ref3) {
        var from = _ref3.from,
            to = _ref3.to;
        t.is(to.id, 'manyYears');
        t.ok(to.equals(PresetManager.getPreset('manyYears')));
      }
    });
    t.chain({
      waitForRowsVisible: scheduler
    }, function () {
      scheduler.zoomToLevel('manyYears');
    });
  });
  t.it('Should zoom to level index', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'weekAndDay',
      startDate: new Date(2018, 4, 20),
      endDate: new Date(2018, 4, 27)
    });
    t.chain({
      waitForSelector: '.b-sch-timeaxis-cell'
    }, function () {
      t.willFireNTimes(scheduler, 'timeAxisChange', 3);
      scheduler.zoomTo(scheduler.presets.indexOf(scheduler.normalizePreset('manyYears')));
      t.is(scheduler._viewPreset.id, 'manyYears', 'Zoomed to level 0');
      scheduler.zoomTo(scheduler.presets.count - 1);
      t.is(scheduler._viewPreset.id, scheduler.presets.last.id, 'Zoomed to max level');
      scheduler.zoomTo({
        level: 0,
        startDate: new Date(2000, 0, 1),
        endDate: new Date(2010, 0, 1),
        width: 300,
        centerDate: new Date(2004, 0, 1)
      });
      t.is(scheduler._viewPreset.id, 'manyYears', 'Zoomed to level 0');
      t.is(scheduler.startDate, new Date(2000, 0, 1), 'Start is ok');
      t.is(scheduler.endDate, new Date(2010, 0, 1), 'End is ok');
      t.isApprox(scheduler.viewportCenterDate.getTime(), new Date(2004, 0, 1).getTime(), getMSPPX(), 'Center is ok');
    });
  });
  t.it('Should zoom to preset with config', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'weekAndDay',
      startDate: new Date(2018, 4, 20),
      endDate: new Date(2018, 4, 27)
    });

    function getMSPPX() {
      return scheduler.getDateFromCoordinate(1) - scheduler.startDate;
    }

    function assertZoom(config) {
      var centerDate = config.centerDate || new Date((config.startDate.getTime() + config.endDate.getTime()) / 2);
      t.isApprox(scheduler.viewportCenterDate.getTime(), centerDate.getTime(), getMSPPX(), 'Center date is ok');
      t.is(scheduler.timeAxisViewModel.viewPreset.id, config.preset, 'View preset is correct');

      if (config.width) {
        t.is(scheduler.timeAxisViewModel.tickSize, config.width, 'Tick width is ok');
      }
    }

    t.chain({
      waitForSelector: '.b-sch-timeaxis-cell'
    }, function () {
      t.willFireNTimes(scheduler, 'timeAxisChange', 2);
      var preset = 'minuteAndHour';
      var config = {
        preset: preset,
        startDate: new Date(2018, 4, 21),
        endDate: new Date(2018, 4, 22)
      };
      scheduler.zoomTo(config);
      assertZoom(config);
      config = {
        preset: preset,
        startDate: new Date(2018, 4, 22),
        endDate: new Date(2018, 4, 24),
        centerDate: new Date(2018, 4, 22, 12),
        width: 200
      };
      scheduler.zoomTo(config);
      assertZoom(config);
    });
  });
  t.it('Should zoom to span', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'weekAndDay',
      startDate: new Date(2018, 4, 20),
      endDate: new Date(2018, 4, 27)
    });
    t.chain({
      waitForSelector: '.b-sch-timeaxis-cell'
    }, function () {
      t.willFireNTimes(scheduler, 'timeAxisChange', 1);
      var hour = 1000 * 60 * 60;
      scheduler.zoomTo({
        startDate: new Date(2017, 0, 1, 6),
        endDate: new Date(2017, 0, 1, 20)
      });
      t.waitFor(function () {
        return scheduler.scrollLeft > 0;
      }, function () {
        var visibleStartDate = scheduler.getDateFromCoordinate(scheduler.scrollLeft),
            visibleEndDate = scheduler.getDateFromCoordinate(scheduler.scrollLeft + scheduler.timeAxisViewModel.availableSpace);
        t.ok(scheduler._viewPreset.id.startsWith('hourAndDay'), 'View preset is ok');
        t.isApprox(visibleStartDate.getTime(), new Date(2017, 0, 1, 6), hour, 'Start date is ok');
        t.isApprox(visibleEndDate.getTime(), new Date(2017, 0, 1, 20), hour, 'End date is ok');
      });
    });
  });
  t.it('Should zoom to time span of event store contents when calling zoomToFit', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var dayMs;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'weekAndDay',
                events: [{
                  startDate: new Date(2018, 6, 1),
                  endDate: new Date(2018, 7, 1),
                  resourceId: 'r1'
                }]
              });

            case 2:
              scheduler = _context.sent;
              dayMs = 1000 * 60 * 60 * 24;
              t.chain(function () {
                t.firesOnce(scheduler, 'timeAxisChange');
                scheduler.zoomToFit({});
                t.waitFor(function () {
                  return scheduler.scrollLeft > 0;
                }, function () {
                  var visibleStartDate = scheduler.getDateFromCoordinate(scheduler.scrollLeft),
                      visibleEndDate = scheduler.getDateFromCoordinate(scheduler.scrollLeft + scheduler.timeAxisViewModel.availableSpace);
                  t.isApprox(visibleStartDate.getTime(), new Date(2018, 6, 1).getTime(), dayMs, 'Start date is ok');
                  t.isApprox(visibleEndDate.getTime(), new Date(2018, 7, 1).getTime(), dayMs, 'End date is ok'); // Should not crash or misbehave when zoomToFit is called with empty eventStore

                  scheduler.events = [];
                  scheduler.zoomToFit();
                  t.isApprox(visibleStartDate.getTime(), new Date(2018, 6, 1).getTime(), dayMs, 'Start date is ok');
                  t.isApprox(visibleEndDate.getTime(), new Date(2018, 7, 1).getTime(), dayMs, 'End date is ok');
                });
              });

            case 5:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref4.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7968

  t.it('zoomToSpan should take centerDate config into account', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'weekAndDay',
      startDate: new Date(2018, 4, 20),
      endDate: new Date(2018, 4, 27)
    });
    var centerDate = new Date(2017, 0, 1);
    t.chain({
      waitForSelector: '.b-sch-timeaxis-cell'
    }, function () {
      scheduler.zoomToSpan({
        startDate: new Date(2017, 0, 1, 6),
        endDate: new Date(2017, 0, 1, 20),
        centerDate: centerDate
      });
      t.waitFor(function () {
        return scheduler.scrollLeft > 0;
      }, function () {
        var visibleStartDate = scheduler.getDateFromCoordinate(scheduler.scrollLeft),
            visibleEndDate = scheduler.getDateFromCoordinate(scheduler.scrollLeft + scheduler.timeAxisViewModel.availableSpace),
            visibleCenter = new Date((visibleStartDate.getTime() + visibleEndDate.getTime()) / 2);
        t.isApprox(visibleCenter.getTime(), centerDate.getTime(), 1000 * 60 * 60, 'Center date is correct');
      });
    });
  });
  t.it('Should respect leftMargin / rightMargin configs provided to zoomToFit', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var dayMs;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'weekAndDayLetter',
                events: [{
                  startDate: new Date(2018, 6, 1),
                  endDate: new Date(2018, 7, 1),
                  resourceId: 'r1'
                }]
              });

            case 2:
              scheduler = _context3.sent;
              dayMs = 1000 * 60 * 60 * 24;
              scheduler.zoomToFit();
              t.chain({
                waitFor: function waitFor() {
                  return scheduler.visibleDateRange.startDate - new Date(2018, 6, 1) < dayMs && scheduler.visibleDateRange.endDate - new Date(2018, 7, 1) < dayMs;
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        t.firesOnce(scheduler, 'timeAxisChange');
                        _context2.next = 3;
                        return scheduler.eventStore.first.setStartDate(new Date(2018, 6, 23));

                      case 3:
                        scheduler.zoomToFit({
                          leftMargin: 60,
                          rightMargin: 60
                        });

                      case 4:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              })), function () {
                var startDate = scheduler.getDateFromCoordinate(scheduler.scrollLeft + 60),
                    endDate = scheduler.getDateFromCoordinate(scheduler.scrollLeft + scheduler.timeAxisViewModel.availableSpace - 60);
                t.isApprox(startDate, new Date(2018, 6, 23).getTime(), dayMs, 'Start date is ok');
                t.isApprox(endDate, new Date(2018, 7, 23).getTime(), dayMs, 'End date is ok');
              });

            case 6:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x2) {
      return _ref5.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8868-crash-when-opening-bigdataset-in-iphone/details#

  t.it('should not crash if calling zoomToFit when there is no space for time axis', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                width: 50,
                events: [{
                  startDate: new Date(2018, 6, 1),
                  endDate: new Date(2018, 7, 1),
                  resourceId: 'r1'
                }]
              });

            case 2:
              scheduler = _context4.sent;
              scheduler.zoomToFit();

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x3) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Should zoom on CTRL + mousewheel sanity checks', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var originalZoomLevel;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2018, 1, 7, 7),
                endDate: new Date(2018, 1, 8),
                viewPreset: 'hourAndDay',
                height: 300
              });

            case 2:
              scheduler = _context5.sent;
              originalZoomLevel = scheduler.zoomLevel;
              t.firesOnce(scheduler.timeAxisViewModel, 'update');
              t.wheel('.b-timeline-subgrid', function () {
                t.expect(scheduler.zoomLevel).toBe(originalZoomLevel - 1);
              }, t, {
                deltaY: 1000,
                ctrlKey: true
              });

            case 6:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x4) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Should sync scrollers on zoom', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var assertScrollers;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              assertScrollers = function _assertScrollers() {
                var normal = scheduler.subGrids.normal;
                t.is(normal.header.scrollable.x, normal.scrollable.x, 'Header scrollable is synced');
                t.is(normal.fakeScroller.x, normal.scrollable.x, 'Fake scrollable is synced');
              };

              scheduler = t.getScheduler();
              scheduler.zoomIn();
              _context6.next = 5;
              return scheduler.rowManager.await('renderDone');

            case 5:
              assertScrollers(); // Wait for a timeout to make sure every delayed listener is invoked

              _context6.next = 8;
              return new Promise(function (resolve) {
                return setTimeout(resolve, 500);
              });

            case 8:
              t.diag('Assert scrollers after delay');
              assertScrollers();

            case 10:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x5) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Should return zoom level', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var _scheduler, zoomLevel, newLevel;

      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              scheduler = t.getScheduler();
              _context7.next = 3;
              return t.waitForSelector('.b-sch-event');

            case 3:
              _scheduler = scheduler, zoomLevel = _scheduler.zoomLevel;
              newLevel = scheduler.zoomIn();
              t.is(newLevel, zoomLevel + 1, 'New level is ok');

            case 6:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x6) {
      return _ref10.apply(this, arguments);
    };
  }());
});