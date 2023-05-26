function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  var startDate = new Date(2019, 0, 6);

  function createScheduler() {
    return _createScheduler.apply(this, arguments);
  }

  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23() {
      var count,
          params,
          _args23 = arguments;
      return regeneratorRuntime.wrap(function _callee23$(_context23) {
        while (1) {
          switch (_context23.prev = _context23.next) {
            case 0:
              count = _args23.length > 0 && _args23[0] !== undefined ? _args23[0] : 50;
              params = _args23.length > 1 && _args23[1] !== undefined ? _args23[1] : {};
              scheduler = new Scheduler(Object.assign({
                appendTo: document.body,
                features: {
                  resourceTimeRanges: true
                },
                viewPreset: 'dayAndWeek',
                startDate: startDate,
                rowHeight: 60,
                barMargin: 10,
                endDate: new Date(2019, 0, 27),
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                resources: ArrayHelper.fill(count, {}, function (r, i) {
                  return (r.name = 'Resource ' + (i + 1)) && (r.id = i + 1);
                }),
                // Throw some events in there also to make sure the combination works
                events: ArrayHelper.fill(count, {}, function (r, i) {
                  return Object.assign(r, {
                    id: i + 1,
                    name: 'Event ' + (i + 1),
                    resourceId: i + 1,
                    startDate: DateHelper.add(startDate, i % 12 + 1, 'days'),
                    duration: 2,
                    durationUnit: 'days'
                  });
                }),
                resourceTimeRanges: [{
                  id: 1,
                  resourceId: 1,
                  startDate: startDate,
                  duration: 4,
                  durationUnit: 'days',
                  name: 'Range 1',
                  cls: 'custom'
                }, {
                  id: 2,
                  resourceId: 1,
                  startDate: DateHelper.add(startDate, 5, 'days'),
                  duration: 2,
                  durationUnit: 'days',
                  name: 'Range 2',
                  style: 'color: red'
                }, {
                  id: 3,
                  resourceId: 1,
                  startDate: DateHelper.add(startDate, 17, 'days'),
                  duration: 4,
                  durationUnit: 'days',
                  name: 'Range 3'
                }, {
                  id: 4,
                  resourceId: 50,
                  startDate: startDate,
                  duration: 3,
                  durationUnit: 'days',
                  name: 'Range 4'
                }],
                enableEventAnimations: false,
                useInitialAnimation: false
              }, params));
              _context23.next = 5;
              return t.waitForProjectReady();

            case 5:
            case "end":
              return _context23.stop();
          }
        }
      }, _callee23);
    }));
    return _createScheduler.apply(this, arguments);
  }

  var rangeSelector = '.b-sch-resourcetimerange:not(.b-sch-released)';

  function checkBounds(t, element, expected) {
    var tolerance = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : 1;
    //const bounds = element.getBoundingClientRect();
    var bounds = Rectangle.from(element, scheduler.timeAxisSubGridElement);
    var pass = true;

    if (Math.abs(bounds.left - expected.left) > tolerance) {
      t.fail("Expected left ".concat(expected.left, " +-").concat(tolerance, ", got ").concat(bounds.left, " for ").concat(element.id));
      pass = false;
    }

    if (Math.abs(bounds.top - expected.top) > tolerance) {
      t.fail("Expected top ".concat(expected.top, " +-").concat(tolerance, ", got ").concat(bounds.top, " for ").concat(element.id));
      pass = false;
    }

    if (Math.abs(bounds.width - expected.width) > tolerance) {
      t.fail("Expected width ".concat(expected.width, " +-").concat(tolerance, ", got ").concat(bounds.width, " for ").concat(element.id));
      pass = false;
    }

    if (Math.abs(bounds.height - expected.height) > tolerance) {
      t.fail("Expected height ".concat(expected.height, " +-").concat(tolerance, ", got ").concat(bounds.height, " for ").concat(element.id));
      pass = false;
    }

    if (pass) {
      t.pass('Bounds match for ' + element.id);
    }
  }

  t.beforeEach(function (t) {
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });
  t.it('Should render ranges correctly initially', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var rangeElements, eventElements;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return createScheduler();

            case 2:
              rangeElements = t.query(rangeSelector);
              t.is(rangeElements.length, 2, '2 ranges rendered initially');
              checkBounds(t, rangeElements[0], {
                left: 0,
                top: 0,
                width: 400,
                height: 60
              });
              checkBounds(t, rangeElements[1], {
                left: 500,
                top: 0,
                width: 200,
                height: 60
              }); // Also make sure events are still rendered correctly

              eventElements = t.query('.b-sch-event:not(.b-sch-released)');
              t.is(eventElements.length, 12, '12 events rendered initially');
              checkBounds(t, eventElements[0], {
                left: 100,
                top: 10,
                width: 200,
                height: 40
              });
              checkBounds(t, eventElements[11], {
                left: 300,
                top: 864,
                width: 200,
                height: 40
              });
              t.elementIsTopElement(eventElements[0], true, 'Event displayed in front of range');
              t.ok(rangeElements[0].classList.contains('custom'), 'Custom CSS applied');
              t.is(rangeElements[1].style.color, 'red', 'Custom style applied');
              t.hasStyle(rangeElements[0].firstElementChild, 'font-size', '12px', 'Correct font-size');

            case 14:
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
  t.it('Should render ranges correctly when scrolled into view', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var yScroller, xScroller;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return createScheduler();

            case 2:
              yScroller = scheduler.scrollable, xScroller = scheduler.timeAxisSubGrid.scrollable;
              t.chain( // Scroll all the way to the right
              {
                waitForEvent: [xScroller, 'scrollend'],
                trigger: function trigger() {
                  return xScroller.scrollTo(2000, null, true);
                }
              }, function (next) {
                var rangeElements = t.query('.b-sch-resourcetimerange:not(.b-sch-released)');
                t.is(rangeElements.length, 1, '1 ranges rendered after scroll to top right');
                checkBounds(t, rangeElements[0], {
                  left: 1700,
                  top: 0,
                  width: 400,
                  height: 60
                });
                next();
              }, // Scroll all the way to the bottom
              {
                waitForEvent: [yScroller, 'scrollend'],
                trigger: function trigger() {
                  return yScroller.scrollTo(null, yScroller.maxY, {
                    animate: true,
                    force: true
                  });
                }
              }, function (next) {
                var rangeElements = t.query('.b-sch-resourcetimerange:not(.b-sch-released)');
                t.is(rangeElements.length, 0, 'No ranges rendered after scroll to bottom right');
                next();
              }, // Scroll all the way to the left
              {
                waitForEvent: [xScroller, 'scrollend'],
                trigger: function trigger() {
                  return xScroller.scrollTo(0, null, true);
                }
              }, function () {
                var rangeElements = t.query('.b-sch-resourcetimerange:not(.b-sch-released)');
                t.is(rangeElements.length, 1, '1 ranges rendered after scroll to bottom left');
                checkBounds(t, rangeElements[0], {
                  left: 0,
                  top: 2989,
                  width: 300,
                  height: 60
                });
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
  t.it('Remove should update UI', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return createScheduler();

            case 2:
              scheduler.resourceTimeRangeStore.first.remove();
              t.chain({
                waitFor: function waitFor() {
                  return t.query(rangeSelector).length === 1;
                },
                desc: 'Waiting for range element to fade away'
              }, function (next) {
                var rangeElements = t.query(rangeSelector);
                t.is(rangeElements.length, 1, 'Single range rendered after remove');
                checkBounds(t, rangeElements[0], {
                  left: 500,
                  top: 0,
                  width: 200,
                  height: 60
                });
                next();
              }, // Make sure it does not reappear on scroll
              {
                waitForEvent: [scheduler, 'scroll'],
                trigger: function trigger() {
                  return scheduler.scrollTop = 20;
                }
              }, function () {
                return t.selectorCountIs(rangeSelector, 1, 'Single range rendered after scroll');
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
  t.it('Remove all should update UI', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return createScheduler();

            case 2:
              scheduler.resourceTimeRangeStore.removeAll();
              t.chain({
                waitFor: function waitFor() {
                  return t.query(rangeSelector).length === 0;
                },
                desc: 'Waiting for range elements to fade away'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
                return regeneratorRuntime.wrap(function _callee4$(_context4) {
                  while (1) {
                    switch (_context4.prev = _context4.next) {
                      case 0:
                        return _context4.abrupt("return", t.selectorNotExists(rangeSelector, 'No range elements after removeAll'));

                      case 1:
                      case "end":
                        return _context4.stop();
                    }
                  }
                }, _callee4);
              })), // Make sure it does not reappear on scroll
              {
                waitForEvent: [scheduler, 'scroll'],
                trigger: function trigger() {
                  return scheduler.scrollTop = 20;
                }
              }, function () {
                return t.selectorNotExists(rangeSelector, 'No range elements after scroll');
              });

            case 4:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Add should update UI', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var rangeElements;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return createScheduler();

            case 2:
              scheduler.resourceTimeRangeStore.add({
                id: 5,
                resourceId: 2,
                startDate: startDate,
                duration: 1,
                durationUnit: 'd'
              });
              rangeElements = t.query(rangeSelector);
              t.is(rangeElements.length, 3, '3 range elements found');
              checkBounds(t, rangeElements[2], {
                left: 0,
                top: 61,
                width: 100,
                height: 60
              });

            case 6:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x5) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Add multiple should update UI', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var rangeElements;
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return createScheduler();

            case 2:
              scheduler.resourceTimeRangeStore.add([{
                id: 5,
                resourceId: 2,
                startDate: startDate,
                duration: 1,
                durationUnit: 'd',
                name: 'New 1'
              }, {
                id: 6,
                resourceId: 4,
                startDate: startDate,
                duration: 1,
                durationUnit: 'd',
                name: 'New 2'
              }]);
              rangeElements = t.query(rangeSelector);
              t.is(rangeElements.length, 4, '4 range elements found');
              checkBounds(t, rangeElements[2], {
                left: 0,
                top: 61,
                width: 100,
                height: 60
              });
              checkBounds(t, rangeElements[3], {
                left: 0,
                top: 183,
                width: 100,
                height: 60
              });

            case 7:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x6) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Data manipulation should update UI', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var el;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return createScheduler();

            case 2:
              el = document.querySelector(rangeSelector);
              scheduler.resourceTimeRangeStore.first.startDate = DateHelper.add(startDate, 1, 'day');
              checkBounds(t, el, {
                left: 100,
                top: 0,
                width: 400,
                height: 60
              });
              scheduler.resourceTimeRangeStore.first.duration = 10;
              checkBounds(t, el, {
                left: 100,
                top: 0,
                width: 1000,
                height: 60
              });
              scheduler.resourceTimeRangeStore.first.resourceId = 10;
              checkBounds(t, el, {
                left: 100,
                top: 549,
                width: 1000,
                height: 60
              });

            case 9:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x7) {
      return _ref8.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7319

  t.it('Released ranges should be hidden', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var firstRange;
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return createScheduler();

            case 2:
              firstRange = document.querySelector('.b-sch-resourcetimerange');
              t.elementIsVisible(firstRange, 'Initially visible'); // Simulate releasing the first range.

              firstRange.classList.add('b-released');
              t.elementIsNotVisible(firstRange, 'Hidden when released');

            case 6:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x8) {
      return _ref9.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7441-crash-when-updating-resourcetimerange-of-non-existing-resource/details#

  t.it('Should not crash if updating resource time range of nonexisting resource', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return createScheduler();

            case 2:
              scheduler.resourceStore.removeAll();
              _context10.next = 5;
              return t.waitForProjectReady();

            case 5:
              scheduler.resourceTimeRangeStore.first.startDate = new Date(2018, 11, 1);
              t.selectorNotExists('.b-sch-resourcetimerange', 'No ranges rendered');

            case 7:
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
  t.xit('Should remove timeranges of removed resource', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return createScheduler();

            case 2:
              t.is(scheduler.resourceTimeRangeStore.count, 4);
              scheduler.resourceStore.remove(1);
              t.is(scheduler.resourceTimeRangeStore.query(function (tr) {
                return tr.resourceId === 1;
              }).length, 0, 'Time ranges of deleted resource were removed');
              t.is(scheduler.resourceTimeRangeStore.count, 1);

            case 6:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x10) {
      return _ref11.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8005/details

  t.it('Should produce correct height when using eventLayout "none"', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      var rangeElements;
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                features: {
                  resourceTimeRanges: true
                },
                eventLayout: 'none',
                startDate: startDate,
                rowHeight: 60,
                endDate: new Date(2019, 0, 27),
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                resources: [{
                  id: 1,
                  name: 'Resource 1'
                }],
                resourceTimeRanges: [{
                  id: 1,
                  resourceId: 1,
                  startDate: startDate,
                  duration: 4,
                  durationUnit: 'd',
                  name: 'Range 1'
                }],
                enableEventAnimations: false
              });
              _context12.next = 3;
              return t.waitForProjectReady();

            case 3:
              scheduler.resourceTimeRangeStore.add([{
                id: 5,
                resourceId: 2,
                startDate: startDate,
                duration: 1,
                durationUnit: 'd'
              }]);
              rangeElements = t.query(rangeSelector);
              t.is(rangeElements.length, 1, '1 range element found');
              t.is(rangeElements[0].offsetHeight, 60);

            case 7:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x11) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('Should draw resource time ranges after events are filtered', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      var timeRangesCount;
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                features: {
                  resourceTimeRanges: true
                },
                viewPreset: 'dayAndWeek',
                startDate: startDate,
                endDate: new Date(2019, 0, 27),
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 100
                }],
                resources: ArrayHelper.populate(20, function (i) {
                  return {
                    name: 'Resource ' + (i + 1),
                    id: i + 1
                  };
                }),
                events: ArrayHelper.populate(20, function (i) {
                  return {
                    id: i + 1,
                    name: 'Event ' + (i + 1),
                    resourceId: i + 1,
                    startDate: DateHelper.add(startDate, i % 12 + 1, 'days'),
                    duration: 2,
                    durationUnit: 'days'
                  };
                }),
                resourceTimeRanges: ArrayHelper.populate(20, function (i) {
                  return {
                    id: i + 1,
                    resourceId: i + 1,
                    name: "Range ".concat(i + 1),
                    startDate: startDate,
                    duration: 1 + Math.round(Math.random() * 10),
                    durationUnit: 'days'
                  };
                }),
                enableEventAnimations: false,
                useInitialAnimation: false
              });
              _context15.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.chain({
                waitForSelector: '.b-sch-resourcetimerange'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13() {
                return regeneratorRuntime.wrap(function _callee13$(_context13) {
                  while (1) {
                    switch (_context13.prev = _context13.next) {
                      case 0:
                        timeRangesCount = t.query('.b-sch-resourcetimerange').length;
                        t.is(timeRangesCount, 15, 'Resource time range for every resource within buffer');

                      case 2:
                      case "end":
                        return _context13.stop();
                    }
                  }
                }, _callee13);
              })), // without this timeout view is visually correct when it shouldn't be. test catches problem, but visually
              // view is correct, so this waitFor is mostly for human
              {
                waitFor: 100
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14() {
                return regeneratorRuntime.wrap(function _callee14$(_context14) {
                  while (1) {
                    switch (_context14.prev = _context14.next) {
                      case 0:
                        t.diag('Filter all events');
                        scheduler.eventStore.filter(function (r) {
                          return /Event 2$/.test(r.name);
                        });
                        t.is(t.query('.b-sch-resourcetimerange:not(.b-sch-released)').length, timeRangesCount, 'All time ranges are rendered');

                      case 3:
                      case "end":
                        return _context14.stop();
                    }
                  }
                }, _callee14);
              })));

            case 4:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x12) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('Should not disappear when zooming with all events filtered out', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return createScheduler(1);

            case 2:
              scheduler.eventStore.filter(function () {
                return false;
              });
              t.ok(scheduler.hasVisibleEvents, 'ResourceTimeRanges considered visible events');
              t.chain({
                waitForEvent: [scheduler, 'presetChange'],
                trigger: function trigger() {
                  return scheduler.zoomIn();
                }
              }, {
                waitForEvent: [scheduler, 'presetChange'],
                trigger: function trigger() {
                  return scheduler.zoomIn();
                }
              }, function () {
                t.selectorCountIs('.b-sch-resourcetimerange:not(.b-sch-released)', 2, 'Resource time ranges drawn after filter + zoom');
                scheduler.resourceTimeRangeStore.filter(function () {
                  return false;
                });
                t.notOk(scheduler.hasVisibleEvents, 'Nothing considered visible after filtering ranges out');
              });

            case 5:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x13) {
      return _ref16.apply(this, arguments);
    };
  }());
  t.it('Should support disabling', /*#__PURE__*/function () {
    var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return createScheduler(1);

            case 2:
              scheduler.features.resourceTimeRanges.disabled = true;
              t.selectorNotExists('.b-sch-resourcetimerange:not(.b-sch-released)', 'None');
              scheduler.features.resourceTimeRanges.disabled = false;
              t.selectorExists('.b-sch-resourcetimerange:not(.b-sch-released)', 'Found');

            case 6:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x14) {
      return _ref17.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/369

  t.it('Should preserve names on scrolling', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      width: '600px',
      mode: 'vertical',
      startDate: new Date(2019, 0, 1, 0),
      endDate: new Date(2019, 0, 1, 6),
      viewPreset: 'hourAndDay',
      features: {
        resourceTimeRanges: true
      },
      resources: [{
        id: 'r1',
        name: 'Mike'
      }, {
        id: 'r2',
        name: 'Linda'
      }, {
        id: 'r3',
        name: 'Lisa'
      }, {
        id: 'r4',
        name: 'Madison'
      }, {
        id: 'r5',
        name: 'Mark'
      }, {
        id: 'r6',
        name: 'Kate'
      }, {
        id: 'r7',
        name: 'Dan'
      }, {
        id: 'r8',
        name: 'Henrik'
      }, {
        id: 'r9',
        name: 'Rob'
      }, {
        id: 'r10',
        name: 'Gloria'
      }],
      resourceTimeRanges: [{
        id: 1,
        resourceId: 'r1',
        startDate: '2019-01-01T00:00',
        endDate: '2019-01-01T01:00',
        name: 'One',
        timeRangeColor: 'green'
      }, {
        id: 2,
        resourceId: 'r2',
        startDate: '2019-01-01T00:00',
        endDate: '2019-01-01T01:00',
        name: 'Two',
        timeRangeColor: 'red'
      }, {
        id: 3,
        resourceId: 'r3',
        startDate: '2019-01-01T00:00',
        endDate: '2019-01-01T01:00',
        name: 'Three',
        timeRangeColor: 'blue'
      }]
    });
    var scrollTimer;
    var scrollable = scheduler.subGrids.normal.scrollable,
        checkTimeRanges = scheduler.resourceTimeRangeStore.records.map(function (timeRange) {
      return {
        waitForSelector: ".b-sch-resourcetimerange[data-resource-id=\"".concat(timeRange.resourceId, "\"]:contains(").concat(timeRange.name, ")"),
        desc: "Correct timerange name ".concat(timeRange.name)
      };
    });
    t.chain(checkTimeRanges, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18() {
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              scrollTimer = setInterval(function () {
                return scrollable.x += 100;
              }, 50);

            case 1:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    })), {
      waitFor: function waitFor() {
        return scrollable.x >= 500;
      }
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19() {
      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              clearInterval(scrollTimer);
              scrollTimer = setInterval(function () {
                return scrollable.x -= 100;
              }, 50);

            case 2:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    })), {
      waitFor: function waitFor() {
        return scrollable.x === 0;
      }
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20() {
      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              clearInterval(scrollTimer);

            case 1:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    })), checkTimeRanges);
  });
  t.it('Should support resourceTimeRangeStore provided on the Scheduler', /*#__PURE__*/function () {
    var _ref21 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21(t) {
      return regeneratorRuntime.wrap(function _callee21$(_context21) {
        while (1) {
          switch (_context21.prev = _context21.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                features: {
                  resourceTimeRanges: true
                },
                startDate: new Date(2019, 0, 6),
                endDate: new Date(2019, 0, 27),
                resources: [{
                  id: 1,
                  name: 'Resource 1'
                }],
                resourceTimeRangeStore: new ResourceTimeRangeStore({
                  data: [{
                    id: 1,
                    resourceId: 1,
                    startDate: new Date(2019, 0, 6),
                    duration: 4,
                    durationUnit: 'd',
                    name: 'Range 1'
                  }]
                }),
                enableEventAnimations: false
              });
              _context21.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.selectorCountIs(rangeSelector, 1, '1 range element found');

            case 4:
            case "end":
              return _context21.stop();
          }
        }
      }, _callee21);
    }));

    return function (_x15) {
      return _ref21.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2163

  t.it('Should support iconCls on resource time range', /*#__PURE__*/function () {
    var _ref22 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
      return regeneratorRuntime.wrap(function _callee22$(_context22) {
        while (1) {
          switch (_context22.prev = _context22.next) {
            case 0:
              _context22.next = 2;
              return createScheduler(1, {
                resourceTimeRanges: [{
                  id: 1,
                  resourceId: 1,
                  startDate: startDate,
                  duration: 4,
                  iconCls: 'b-fa b-fa-plus',
                  name: 'Range 1'
                }]
              });

            case 2:
              t.selectorExists('.b-fa-plus', 'Plus icon applied');

            case 3:
            case "end":
              return _context22.stop();
          }
        }
      }, _callee22);
    }));

    return function (_x16) {
      return _ref22.apply(this, arguments);
    };
  }());
});