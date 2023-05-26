function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, rangeStore;
  t.beforeEach( /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t, next) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler && scheduler.destroy();
              _context.next = 3;
              return t.getSchedulerAsync({
                startDate: new Date(2018, 1, 7, 7),
                endDate: new Date(2018, 1, 8),
                viewPreset: 'hourAndDay',
                height: 300,
                features: {
                  timeRanges: {
                    enableResizing: true,
                    showCurrentTimeLine: true,
                    showHeaderElements: true,
                    store: {
                      modelClass: TimeSpan,
                      data: [{
                        id: 'lunch',
                        name: 'Lunch o´ clock',
                        startDate: '2018-02-07 11:00',
                        endDate: '2018-02-07 12:00',
                        cls: 'custom'
                      }, {
                        id: 'line',
                        name: 'Important time',
                        startDate: '2018-02-07 13:30',
                        style: 'color: red'
                      }]
                    }
                  }
                }
              });

            case 3:
              scheduler = _context.sent;
              rangeStore = scheduler.features.timeRanges.store;
              next();

            case 6:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x, _x2) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Rendering sanity checks', function (t) {
    t.selectorExists('.b-sch-timeaxiscolumn-levels-2', 'Always outputting the correct number of header levels on header container element');
    t.chain({
      waitForSelector: '.b-grid-headers .b-sch-timerange.b-sch-range',
      desc: 'Should find range element in header'
    }, {
      waitForSelector: '.b-sch-timerange.b-sch-range:contains(Lunch)',
      desc: 'Should find range element in body'
    }, {
      waitForSelector: '.b-grid-headers .b-sch-timerange.b-sch-range',
      desc: 'Should find line element in header'
    }, {
      waitForSelector: '.b-grid-subgrid-normal .b-sch-timerange.b-sch-line',
      desc: 'Should find line element in body'
    }, function () {
      t.selectorExists('.b-sch-range.custom', 'Custom CSS applied');
      t.is(document.querySelector('.b-sch-foreground-canvas .b-sch-line').style.color, 'red', 'Custom style applied');
    });
  });
  t.it('Should render current timeline', function (t) {
    t.selectorExists('.b-sch-timeaxiscolumn-levels-2', 'Always outputting the correct number of header levels on header container element');
    scheduler.setTimeSpan(new Date());
    t.selectorExists('.b-grid-headers .b-sch-timerange.b-sch-current-time', 'Should find current timeline in header');
    t.selectorExists('.b-grid-subgrid-normal .b-sch-timerange.b-sch-current-time', 'Should find current timeline in body');
    scheduler.timeAxis.setTimeSpan(new Date(2016, 1, 1), new Date(2016, 1, 2));
    t.selectorNotExists('.b-grid-headers .b-sch-timerange.b-sch-current-time', 'Should NOT find current timeline in header');
    t.selectorNotExists('.b-grid-subgrid-normal .b-sch-timerange.b-sch-current-time', 'Should NOT find current timeline in body');
    scheduler.setTimeSpan(new Date());
    t.selectorExists('.b-grid-headers .b-sch-timerange.b-sch-current-time', 'Should find current timeline in header');
    t.selectorExists('.b-grid-subgrid-normal .b-sch-timerange.b-sch-current-time', 'Should find current timeline in body');
    scheduler.features.timeRanges.showCurrentTimeLine = false;
    t.selectorNotExists('.b-grid-headers .b-sch-timerange.b-sch-current-time', 'Should not find current timeline in header');
    t.selectorNotExists('.b-grid-subgrid-normal .b-sch-timerange.b-sch-current-time', 'Should not find current timeline in body');
    scheduler.features.timeRanges.showCurrentTimeLine = true;
    t.selectorExists('.b-grid-headers .b-sch-timerange.b-sch-current-time', 'Should find current timeline in header');
    t.selectorExists('.b-grid-subgrid-normal .b-sch-timerange.b-sch-current-time', 'Should find current timeline in body');
  });
  t.it('Should be able to resize range elements in the header', function (t) {
    t.isApprox(document.querySelector('.b-grid-subgrid .b-sch-range').offsetHeight, document.querySelector('.b-grid-subgrid').offsetHeight, 'range has height');
    t.is(document.querySelector('.b-grid-subgrid .b-sch-range').offsetWidth, scheduler.timeAxisViewModel.tickSize, 'range sized ok');
    t.is(document.querySelector('.b-grid-headers .b-sch-range').offsetWidth, scheduler.timeAxisViewModel.tickSize, 'range sized ok');
    t.chain({
      drag: '.b-sch-range',
      fromOffset: [2, '50%'],
      by: [20, 0],
      dragOnly: true
    }, {
      waitForSelector: '.b-tooltip:contains(Lunch)'
    }, {
      waitForSelector: '.b-tooltip .b-sch-clock'
    }, {
      type: '[ESCAPE]'
    }, {
      drag: '.b-sch-range',
      fromOffset: [2, '50%'],
      by: [-scheduler.timeAxisViewModel.tickSize, 0]
    }, function (next) {
      t.expect(rangeStore.getById('lunch').startDate).toEqual(new Date(2018, 1, 7, 10));
      t.expect(rangeStore.getById('lunch').endDate).toEqual(new Date(2018, 1, 7, 12));
      next();
    }, {
      drag: '.b-sch-range',
      fromOffset: ['100%-2', '50%'],
      by: [scheduler.timeAxisViewModel.tickSize, 0]
    }, function (next) {
      t.expect(rangeStore.getById('lunch').startDate).toEqual(new Date(2018, 1, 7, 10));
      t.expect(rangeStore.getById('lunch').endDate).toEqual(new Date(2018, 1, 7, 13));
    });
  });
  t.it('Should be able to resize range elements in the header', function (t) {
    t.isApprox(document.querySelector('.b-grid-subgrid .b-sch-range').offsetHeight, document.querySelector('.b-grid-subgrid').offsetHeight, 'range has height');
    t.chain({
      drag: '.b-sch-range',
      fromOffset: [2, '50%'],
      by: [20, 0],
      dragOnly: true
    }, {
      type: '[ESCAPE]'
    }, function () {
      t.is(document.querySelector('.b-grid-subgrid .b-sch-range').offsetWidth, scheduler.timeAxisViewModel.tickSize, 'range sized ok after aborted resize');
      t.is(document.querySelector('.b-grid-headers .b-sch-range').offsetWidth, scheduler.timeAxisViewModel.tickSize, 'range sized ok after aborted resize');
    });
  });
  t.it('Should be able to drag range elements in the header', function (t) {
    t.selectorExists('.b-sch-timeaxiscolumn-levels-2', 'Always outputting the correct number of header levels on header container element');
    t.chain({
      drag: '.b-sch-range',
      by: [50, 0],
      dragOnly: true
    }, {
      waitForSelector: '.b-tooltip:contains(Lunch)'
    }, {
      waitForSelector: '.b-tooltip .b-sch-clock'
    }, {
      type: '[ESCAPE]'
    }, function (next) {
      t.is(document.querySelector('.b-grid-subgrid .b-sch-range').offsetWidth, scheduler.timeAxisViewModel.tickSize, 'range sized ok after aborted resize');
      t.is(document.querySelector('.b-grid-headers .b-sch-range').offsetWidth, scheduler.timeAxisViewModel.tickSize, 'range sized ok after aborted resize');
      next();
    }, // Should be valid if dragging below header
    {
      drag: '.b-sch-range',
      by: [-scheduler.timeAxisViewModel.tickSize, 100],
      dragOnly: true
    }, function (next) {
      t.selectorExists('.b-scheduler.b-dragging-timerange', 'Scheduler styled for drag');
      next();
    }, {
      mouseUp: null
    }, function () {
      t.selectorNotExists('.b-scheduler.b-dragging-timerange', 'Scheduler no longer styled for drag');
      t.expect(rangeStore.getById('lunch').startDate).toEqual(new Date(2018, 1, 7, 10));
      t.expect(rangeStore.getById('lunch').endDate).toEqual(new Date(2018, 1, 7, 11));
    });
  });
  t.it('Dragging should be constrained to within the time axis', function (t) {
    var lunch = rangeStore.getById('lunch'),
        lunchDuration = lunch.durationMS;
    t.selectorExists('.b-sch-timeaxiscolumn-levels-2', 'Always outputting the correct number of header levels on header container element');
    t.chain({
      drag: '.b-sch-range',
      by: [-4.5 * scheduler.timeAxisViewModel.tickSize, 0]
    }, function (next) {
      // It's been successfully constrained to within the time axis and is the same duration
      t.expect(lunch.startDate).toEqual(scheduler.timeAxis.startDate);
      t.expect(lunch.durationMS).toEqual(lunchDuration);
    });
  });
  t.it('Should be able to drag drop line element in the header', function (t) {
    t.selectorExists('.b-sch-timeaxiscolumn-levels-2', 'Always outputting the correct number of header levels on header container element');
    t.chain({
      drag: '.b-sch-line',
      by: [-scheduler.timeAxisViewModel.tickSize, 0]
    }, function (next) {
      t.expect(rangeStore.getById('line').startDate).toEqual(new Date(2018, 1, 7, 12, 30));
      t.notOk(rangeStore.getById('line').endDate);
      next();
    }, {
      drag: '.b-sch-line',
      by: [scheduler.timeAxisViewModel.tickSize, 0]
    }, function () {
      t.expect(rangeStore.getById('line').startDate).toEqual(new Date(2018, 1, 7, 13, 30));
      t.notOk(rangeStore.getById('line').endDate);
    });
  });
  t.it('Should treat resizing to 0 width as invalid', function (t) {
    t.wontFire(rangeStore, 'change');
    t.selectorExists('.b-sch-timeaxiscolumn-levels-2', 'Always outputting the correct number of header levels on header container element');
    t.chain({
      drag: '.b-sch-range',
      fromOffset: [2, '50%'],
      by: [200, 0]
    }, {
      drag: '.b-sch-range',
      fromOffset: ['100%-2', '50%'],
      by: [-200, 0]
    });
  });
  t.it('Should treat dragging straight down as invalid', function (t) {
    t.wontFire(rangeStore, 'change');
    t.selectorExists('.b-sch-timeaxiscolumn-levels-2', 'Always outputting the correct number of header levels on header container element');
    t.chain({
      drag: '.b-sch-range',
      fromOffset: ['100%-2', '50%'],
      by: [0, 50]
    }, function (next) {
      var box = document.querySelector('.b-grid-headers .b-sch-range').getBoundingClientRect();
      t.is(document.querySelector('.b-grid-headers .b-sch-range').offsetWidth, scheduler.timeAxisViewModel.tickSize, 'range still sized ok');
      t.is(box.right - box.left, scheduler.timeAxisViewModel.tickSize, 'range still sized ok');
    });
  });
  t.it('readOnly should prevent resizing', function (t) {
    scheduler.readOnly = true;
    t.selectorExists('.b-sch-timeaxiscolumn-levels-2', 'Always outputting the correct number of header levels on header container element');
    t.wontFire(rangeStore, 'change');
    t.chain({
      waitForSelector: '.b-sch-range',
      fromOffset: [2, '50%']
    });
  });
  t.it('configuring timeRanges with a timeRanges block', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler && scheduler.destroy(); // This should render and throw no error.
              // https://app.assembla.com/spaces/bryntum/tickets/6756

              scheduler = new Scheduler({
                appendTo: document.body,
                columns: [{
                  text: 'Staff',
                  field: 'name',
                  width: 150
                }],
                crudManager: {
                  transport: {
                    load: {
                      url: 'about:blank'
                    }
                  }
                },
                startDate: new Date(2017, 1, 7, 8),
                endDate: new Date(2017, 1, 7, 18),
                viewPreset: 'hourAndDay',
                height: 300,
                features: {
                  timeRanges: {
                    enableResizing: true,
                    showHeaderElements: true,
                    timeRanges: [{
                      name: 'Lunch o´ clock',
                      startDate: '2017-02-07 11:00',
                      endDate: '2017-02-07 12:00'
                    }]
                  }
                }
              });
              _context2.next = 4;
              return t.waitForProjectReady();

            case 4:
              t.selectorExists('.b-sch-timeaxiscolumn-levels-2', 'Always outputting the correct number of header levels on header container element');

            case 5:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref2.apply(this, arguments);
    };
  }()); //https://app.assembla.com/spaces/bryntum/tickets/6932/details

  t.it('Should be able to coexist with NonWorkingTime', function (t) {
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler({
      appendTo: document.body,
      startDate: new Date(2018, 1, 4),
      endDate: new Date(2018, 1, 17),
      viewPreset: 'weekAndDayLetter',
      height: 300,
      features: {
        timeRanges: true,
        nonWorkingTime: true
      },
      timeRanges: [{
        id: 'lunch',
        name: 'Long lunch',
        startDate: '2018-02-07 3:00',
        endDate: '2018-02-07 22:00'
      }, {
        id: 'line',
        name: 'Important time',
        startDate: '2018-02-09 13:30'
      }]
    }); // TODO uncomment when this is fixed https://app.assembla.com/spaces/bryntum/tickets/8413-horizontaltimeaxis-should-not-completely-overwrite-contents-of-column-el/details#
    // t.selectorExists('.b-grid-headers .b-sch-timeaxiscolumn .b-sch-timerange', 'Timeranges rendered into time axis column element');

    t.selectorExists('.b-grid-headers .b-sch-timerange', 'Timeranges rendered into subGrid header element');
    t.selectorCountIs('.b-grid-headers .b-sch-timerange', 5, '2 timeranges rendered in header');
    t.selectorCountIs('.b-grid-subgrid-normal .b-sch-timerange', 5, '3+2 timeranges found');
    t.selectorCountIs('.b-grid-headers .b-sch-nonworkingtime', 3, 'Three nonworkingtimes found in header');
    t.selectorCountIs('.b-grid-subgrid-normal .b-sch-nonworkingtime', 3, 'Three nonworkingtimes found in body');
  });
  t.it('Should use correct time format for current timeline', function (t) {
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler({
      startDate: new Date(),
      endDate: DateHelper.add(new Date(), 1, 'week'),
      viewPreset: 'weekAndDayLetter',
      height: 300,
      features: {
        timeRanges: {
          showCurrentTimeLine: true,
          showHeaderElements: true,
          currentDateFormat: 'YYYY A'
        }
      },
      events: [],
      timeRanges: []
    });
    var amPM = new Date().getHours() < 12 ? 'AM' : 'PM';
    t.chain({
      waitForSelector: ".b-grid-headers .b-sch-timerange.b-sch-current-time:textEquals(".concat(new Date().getFullYear(), " ").concat(amPM, ")"),
      desc: 'Should find current timeline in header'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              t.livesOk(function () {
                scheduler.features.timeRanges.updateCurrentTimeLine();
              });

            case 1:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    })));
  });
  t.it('Should not crash when updating nonrendered timerange', function (t) {
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler({
      appendTo: document.body,
      startDate: new Date(2018, 1, 4),
      endDate: new Date(2018, 1, 17),
      viewPreset: 'weekAndDayLetter',
      height: 300,
      features: {
        timeRanges: true
      },
      timeRanges: [{
        id: 'lunch',
        startDate: '2028-02-07',
        endDate: '2028-02-08'
      }, {
        startDate: '2008-02-07',
        endDate: '2008-02-08'
      }]
    });
    scheduler.features.timeRanges.store.first.shift(1);
    scheduler.features.timeRanges.store.last.shift(1);
  });
  t.it('Should not crash when updating timerange to no longer be rendered', function (t) {
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler({
      appendTo: document.body,
      startDate: new Date(2018, 1, 4),
      endDate: new Date(2018, 1, 17),
      viewPreset: 'weekAndDayLetter',
      height: 300,
      features: {
        timeRanges: true
      },
      timeRanges: [{
        id: 'lunch',
        startDate: '2018-02-07',
        endDate: '2018-02-08'
      }]
    });
    t.selectorExists('.b-grid-subgrid-normal .b-sch-timerange', 'Should find range');
    scheduler.features.timeRanges.store.first.shift(100, 'y');
    t.chain({
      waitForSelectorNotFound: '.b-grid-subgrid-normal .b-sch-timerange',
      desc: 'Should NOT find updated range'
    });
  });
  t.it('Should not crash if timeRange lacks start or end date', function (t) {
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler({
      appendTo: document.body,
      startDate: new Date(2018, 1, 4),
      endDate: new Date(2018, 1, 17),
      features: {
        timeRanges: true
      },
      timeRanges: [{
        id: 'lunch'
      }]
    });
    t.selectorNotExists('.b-grid-headers .b-sch-timerange', 'Should NOT find time range in header');
    t.selectorNotExists('.b-grid-subgrid-normal .b-sch-timerange', 'Should NOT find time range in body');
  });
  t.it('Should render a line if timeRange start === end date', function (t) {
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler({
      appendTo: document.body,
      startDate: new Date(2018, 1, 4),
      endDate: new Date(2018, 1, 17),
      features: {
        timeRanges: {
          showHeaderElements: true
        }
      },
      timeRanges: [{
        name: 'foo',
        startDate: new Date(2018, 1, 5),
        endDate: new Date(2018, 1, 5)
      }]
    });
    t.selectorExists('.b-grid-headers .b-sch-timerange.b-sch-line', 'Should find time range in header');
    t.selectorExists('.b-grid-subgrid-normal .b-sch-timerange.b-sch-line', 'Should find time range in body');
  });
  t.it('Should show current timeline header element at render time', function (t) {
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler({
      appendTo: document.body,
      startDate: DateHelper.add(new Date(), -1, 'week'),
      endDate: DateHelper.add(new Date(), 1, 'week'),
      features: {
        timeRanges: {
          showCurrentTimeLine: true,
          showHeaderElements: true
        }
      },
      timeRanges: [{
        name: 'foo',
        startDate: new Date(2018, 1, 5),
        endDate: new Date(2018, 1, 5)
      }]
    });
    t.selectorExists('.b-grid-headers .b-sch-current-time label:not(:empty)', 'Should find current time line in header');
  });
  t.it('Should expose timeRanges property on CRUD manager', function (t) {
    scheduler && scheduler.destroy();
    scheduler = new Scheduler({
      appendTo: document.body,
      startDate: '2019-02-07',
      endDate: '2019-02-08',
      viewPreset: 'hourAndDay',
      features: {
        timeRanges: {
          showCurrentTimeLine: true,
          showHeaderElements: true
        }
      },
      columns: [{
        field: 'name',
        text: 'Name',
        width: 200
      }],
      crudManager: {
        autoLoad: true,
        transport: {
          load: {
            url: '../examples/timeranges/data/data.json'
          }
        }
      }
    });
    t.chain({
      waitForSelector: '.b-sch-event'
    }, function (next) {
      t.is(scheduler.crudManager.timeRangeStore, scheduler.features.timeRanges.store, 'Time ranges store is exposed');
    });
  });
  t.it('Should expose timeRanges property on Scheduler', function (t) {
    scheduler && scheduler.destroy();
    scheduler = new Scheduler({
      appendTo: document.body,
      startDate: '2019-02-07',
      endDate: '2019-02-08',
      features: {
        timeRanges: {
          showCurrentTimeLine: true,
          showHeaderElements: true
        }
      },
      columns: [{
        field: 'name',
        text: 'Name',
        width: 200
      }]
    });
    t.ok(scheduler.timeRanges, 'Time ranges array exposed');
    scheduler.timeRanges = [{
      name: 'foo',
      startDate: new Date(2019, 1, 7),
      duration: 1
    }];
    t.selectorExists('.b-grid-headers .b-sch-range label:textEquals(foo)', 'timeRanges setter works');
  }); // https://app.assembla.com/spaces/bryntum/tickets/8762-time-range-elements-are-sized-incorrectly-when-zooming-out/details#

  t.it('Should size elements correctly', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              scheduler && scheduler.destroy();
              scheduler = t.getScheduler({
                startDate: new Date(2018, 0, 4),
                endDate: new Date(2018, 2, 17),
                viewPreset: 'weekAndDayLetter',
                height: 300,
                width: 500,
                features: {
                  timeRanges: true
                },
                timeRanges: [{
                  cls: 'range',
                  startDate: '2018-02-07',
                  endDate: '2018-02-08'
                }],
                events: [{
                  cls: 'event',
                  resourceId: 'r1',
                  startDate: '2018-02-07',
                  endDate: '2018-02-08'
                }]
              });
              _context4.next = 4;
              return t.waitForProjectReady();

            case 4:
              scheduler.timeAxisViewModel.tickSize = 5;
              t.is(document.querySelector('.b-grid-headers .range').offsetWidth, document.querySelector(scheduler.unreleasedEventSelector).offsetWidth, 'Header range element sized same as event');
              t.is(document.querySelector('.b-grid-subgrid .range').offsetWidth, document.querySelector(scheduler.unreleasedEventSelector).offsetWidth, 'Body range element sized same as event');

            case 7:
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
  t.it('Should refresh elements when `include` property changes on Scheduler timeaxis', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              scheduler && scheduler.destroy();
              scheduler = t.getScheduler({
                startDate: new Date(2018, 6, 8),
                endDate: new Date(2018, 6, 15),
                viewPreset: 'weekAndDayLetter',
                height: 300,
                width: 500,
                features: {
                  timeRanges: true
                },
                timeRanges: [{
                  cls: 'range',
                  startDate: '2018-07-14',
                  endDate: '2018-07-15'
                }],
                workingTime: {
                  fromDay: 1,
                  toDay: 6,
                  fromHour: 8,
                  toHour: 17
                },
                events: []
              });
              _context5.next = 4;
              return t.waitForProjectReady();

            case 4:
              t.selectorNotExists('.range', 'Time range not rendered');
              scheduler.workingTime = null;
              t.selectorExists('.range', 'Time range rendered');

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
  }()); // VERTICAL MODE

  t.it('VERTICAL: Should be able to drag range elements in the header', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              scheduler && scheduler.destroy();
              scheduler = t.getScheduler({
                startDate: new Date(2018, 1, 7, 7),
                endDate: new Date(2018, 1, 8),
                viewPreset: 'hourAndDay',
                mode: 'vertical',
                features: {
                  timeRanges: {
                    enableResizing: true,
                    showCurrentTimeLine: true,
                    showHeaderElements: true,
                    store: {
                      modelClass: TimeSpan,
                      data: [{
                        id: 'lunch',
                        name: 'Lunch o´ clock',
                        startDate: '2018-02-07 11:00',
                        endDate: '2018-02-07 12:00',
                        cls: 'custom'
                      }]
                    }
                  }
                }
              });
              _context6.next = 4;
              return t.waitForProjectReady();

            case 4:
              rangeStore = scheduler.features.timeRanges.store;
              t.chain({
                drag: '.b-sch-range',
                by: [0, scheduler.timeAxisViewModel.tickSize]
              }, function () {
                t.expect(rangeStore.getById('lunch').startDate).toEqual(new Date(2018, 1, 7, 12));
                t.expect(rangeStore.getById('lunch').endDate).toEqual(new Date(2018, 1, 7, 13));
              });

            case 6:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref6.apply(this, arguments);
    };
  }()); // EOF VERTICAL MODE

  t.it('Labels and lines should be synchronized after scroll', function (t) {
    t.chain({
      waitForSelector: '.b-sch-timerange'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
      var rangeHeaderEl, rangeEl, lineHeaderEl, lineEl;
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return scheduler.scrollTo(100);

            case 2:
              rangeHeaderEl = document.querySelector('.b-grid-header-container .b-sch-range'), rangeEl = document.querySelector('.b-sch-foreground-canvas .b-sch-range'), lineHeaderEl = document.querySelector('.b-grid-header-container .b-sch-line'), lineEl = document.querySelector('.b-sch-foreground-canvas .b-sch-line');
              t.is(rangeHeaderEl.getBoundingClientRect().left, rangeEl.getBoundingClientRect().left, 'Range header and element are synced');
              t.is(lineHeaderEl.getBoundingClientRect().left, lineEl.getBoundingClientRect().left, 'Line header and element are synced');

            case 5:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    })));
  });
  t.it('Should reuse time range element', function (t) {
    var range = scheduler.features.timeRanges.store.getById('lunch'),
        element = document.querySelector('[data-id="lunch"]'),
        width = element.offsetWidth;
    range.id = 'foo';
    t.is(scheduler.features.timeRanges.getElementsByRecord(range).headerElement, element, 'Element is reused');
    t.selectorCountIs('.b-grid-headers .b-timerange-TimeRanges', 2, 'Two time ranges element in DOM');
    range.endDate = new Date(2018, 1, 7, 13);
    t.waitFor(function () {
      return element.offsetWidth === width * 2;
    }, function () {
      t.is(scheduler.features.timeRanges.getElementsByRecord(range).headerElement, element, 'Element is reused');
      t.selectorCountIs('.b-grid-headers .b-timerange-TimeRanges', 2, 'Two time ranges element in DOM');
    });
  });
  t.it('Should support disabling', function (t) {
    scheduler.features.timeRanges.disabled = true;
    t.selectorNotExists('.b-sch-timerange');
    scheduler.features.timeRanges.disabled = false;
    t.selectorExists('.b-sch-timerange');
  });
  t.it('Should work with hideHeaders set to `true`', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              scheduler && scheduler.destroy();
              scheduler = t.getScheduler({
                startDate: new Date(2018, 1, 7, 7),
                endDate: new Date(2018, 1, 8),
                viewPreset: 'hourAndDay',
                height: 300,
                hideHeaders: true,
                features: {
                  timeRanges: {
                    enableResizing: true,
                    showCurrentTimeLine: true,
                    showHeaderElements: true,
                    store: {
                      modelClass: TimeSpan,
                      data: [{
                        id: 'lunch',
                        name: 'Lunch o´ clock',
                        startDate: '2018-02-07 11:00',
                        endDate: '2018-02-07 12:00',
                        cls: 'custom'
                      }]
                    }
                  }
                }
              });
              _context8.next = 4;
              return t.waitForProjectReady();

            case 4:
              t.selectorNotExists('.b-grid-headers .b-sch-timerange');

            case 5:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x7) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('Should refresh elements when store is batched', function (t) {
    scheduler.timeRanges = [];
    var store = scheduler.features.timeRanges.store;
    store.beginBatch();
    store.add({
      cls: 'range',
      startDate: scheduler.startDate,
      endDate: scheduler.endDate
    });
    store.endBatch();
    t.selectorExists('.range', 'Time range rendered');
  }); // https://github.com/bryntum/support/issues/1398

  t.it('Should not throw exception when update current timeline if scheduler is hidden', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              scheduler && scheduler.destroy();
              _context9.next = 3;
              return t.getSchedulerAsync({
                eventStore: {
                  data: [{
                    id: 'e1',
                    resourceId: 'r1',
                    startDate: new Date(),
                    endDate: new Date()
                  }]
                },
                resourceStore: {
                  data: [{
                    id: 'r1',
                    name: 'Mike'
                  }]
                },
                features: {
                  timeRanges: {
                    enableResizing: true,
                    showCurrentTimeLine: true,
                    showHeaderElements: true
                  }
                },
                startDate: new Date(),
                // replace with current date to timeline be current
                endDate: new Date(),
                // replace with current date to timeline be current
                hidden: true // simulate it hidden in a tab or a hidden card

              });

            case 3:
              scheduler = _context9.sent;
              // call to check if will be exception
              scheduler.features.timeRanges.updateCurrentTimeLine(); // if not exception on call above, show scheduler again to then check if timeline will be visible

              scheduler.hidden = false;
              t.chain({
                waitForElementVisible: '[data-event-id="e1"]'
              }, {
                waitForSelector: '.b-sch-timerange.b-sch-current-time',
                desc: 'Scheduler with current timeline is visible'
              });

            case 7:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x8) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Should not render label elements unless a name or icon is set', function (t) {
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler({
      startDate: new Date(2018, 1, 7, 7),
      endDate: new Date(2018, 1, 8),
      viewPreset: 'hourAndDay',
      features: {
        timeRanges: {
          showCurrentTimeLine: true,
          showHeaderElements: false,
          store: {
            modelClass: TimeSpan,
            data: [{
              id: 1,
              startDate: '2018-02-07 11:00',
              endDate: '2018-02-07 12:00'
            }]
          }
        }
      }
    });
    t.selectorNotExists('.b-sch-range label', 'No range label rendered');
  });
  t.it('Should handle scheduler headers hidden', function (t) {
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler({
      hideHeaders: true,
      startDate: new Date(),
      endDate: new Date(),
      features: {
        timeRanges: {
          currentTimeLineUpdateInterval: 10,
          showCurrentTimeLine: true
        }
      }
    });
    var date = scheduler.features.timeRanges.currentTimeLine.startDate;
    t.selectorExists('.b-grid-subgrid-normal .b-sch-timerange.b-sch-current-time', 'Should find current timeline in body');
    t.waitFor(function () {
      return scheduler.features.timeRanges.currentTimeLine.startDate - date > 50;
    });
  });
  t.it('Should work when scheduler is partnered with another scheduler, using its timeAxisViewModel', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var scheduler2;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              scheduler2 = t.getScheduler({
                id: 'scheduler2',
                height: 300,
                features: {
                  timeRanges: {
                    showCurrentTimeLine: true
                  }
                }
              });
              scheduler.startDate = new Date();
              scheduler2.partner = scheduler;
              _context10.next = 5;
              return t.waitForSelector('.b-grid-header .b-sch-timerange[data-id=currentTime]');

            case 5:
              t.selectorCountIs('.b-grid-header .b-sch-timerange[data-id=currentTime]', 2);

            case 6:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x9) {
      return _ref10.apply(this, arguments);
    };
  }());
});