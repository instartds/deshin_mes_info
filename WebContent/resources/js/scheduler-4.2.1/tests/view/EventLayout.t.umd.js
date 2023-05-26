function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  window.Dependencies = Dependencies;
  t.beforeEach(function () {
    var _scheduler, _scheduler$destroy;

    (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : (_scheduler$destroy = _scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(_scheduler);
  });
  t.it('Should layout items correctly when using Pack', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var getTopPosition;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              getTopPosition = function _getTopPosition(name) {
                var cellTop = document.body.querySelector('.b-grid-cell').getBoundingClientRect().top;
                return document.body.querySelector('.' + name).getBoundingClientRect().top - cellTop;
              };

              scheduler = new Scheduler({
                appendTo: document.body,
                rowHeight: 100,
                eventLayout: 'pack',
                viewPreset: 'dayAndWeek',
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2018, 1, 15),
                barMargin: 1,
                resources: [{
                  id: 1,
                  name: 'First'
                }],
                events: [// Events arranged in different 'overlap clusters'
                {
                  cls: 'a',
                  name: 'a',
                  resourceId: 1,
                  startDate: '2018-01-01',
                  endDate: '2018-01-03'
                }, {
                  cls: 'b',
                  name: 'b',
                  resourceId: 1,
                  startDate: '2018-01-01',
                  endDate: '2018-01-03'
                }, {
                  cls: 'c',
                  name: 'c',
                  resourceId: 1,
                  startDate: '2018-01-01',
                  endDate: '2018-01-03'
                }, {
                  cls: 'd',
                  name: 'd',
                  resourceId: 1,
                  startDate: '2018-01-01',
                  endDate: '2018-01-03'
                }, {
                  cls: 'e',
                  name: 'e',
                  resourceId: 1,
                  startDate: '2018-01-04',
                  endDate: '2018-01-07'
                }, {
                  cls: 'f',
                  name: 'f',
                  resourceId: 1,
                  startDate: '2018-01-04',
                  endDate: '2018-01-05'
                }, {
                  cls: 'g',
                  name: 'g',
                  resourceId: 1,
                  startDate: '2018-01-06',
                  endDate: '2018-01-07'
                }, {
                  cls: 'h',
                  name: 'h',
                  resourceId: 1,
                  startDate: '2018-01-08',
                  endDate: '2018-01-09'
                }, {
                  cls: 'i',
                  name: 'i',
                  resourceId: 1,
                  startDate: '2018-01-10',
                  endDate: '2018-01-11'
                }, {
                  cls: 'j',
                  name: 'j',
                  resourceId: 1,
                  startDate: '2018-01-10',
                  endDate: '2018-01-12'
                }, {
                  cls: 'k',
                  name: 'k',
                  resourceId: 1,
                  startDate: '2018-01-11',
                  endDate: '2018-01-14'
                }, {
                  cls: 'l',
                  name: 'l',
                  resourceId: 1,
                  startDate: '2018-01-13',
                  endDate: '2018-01-15'
                }, {
                  cls: 'm',
                  name: 'm',
                  resourceId: 1,
                  startDate: '2018-01-13',
                  endDate: '2018-01-14'
                }]
              });
              _context.next = 4;
              return t.waitForProjectReady();

            case 4:
              scheduler.timeAxisViewModel.tickSize = 20;
              t.subTest('4 event cluster', function (t) {
                t.is(getTopPosition('a'), 1, 'a');
                t.isApprox(getTopPosition('b'), 1 * scheduler.rowHeight / 4, 1, 'b');
                t.isApprox(getTopPosition('c'), 2 * scheduler.rowHeight / 4, 1, 'c');
                t.isApprox(getTopPosition('d'), 3 * scheduler.rowHeight / 4, 1, 'd');
                t.isApprox(document.body.querySelector('.a').offsetHeight, scheduler.rowHeight / 4, 2, 'a');
                t.isApprox(document.body.querySelector('.b').offsetHeight, scheduler.rowHeight / 4, 2, 'b');
                t.isApprox(document.body.querySelector('.c').offsetHeight, scheduler.rowHeight / 4, 2, 'c');
                t.isApprox(document.body.querySelector('.d').offsetHeight, scheduler.rowHeight / 4, 2, 'd');
              });
              t.subTest('3 event cluster', function (t) {
                t.is(getTopPosition('e'), 1, 'e');
                t.isApprox(getTopPosition('f'), scheduler.rowHeight / 2, 1, 'f');
                t.isApprox(getTopPosition('g'), scheduler.rowHeight / 2, 1, 'g');
                t.isApprox(document.body.querySelector('.e').offsetHeight, scheduler.rowHeight / 2, 2, 'e');
                t.isApprox(document.body.querySelector('.f').offsetHeight, scheduler.rowHeight / 2, 2, 'f');
                t.isApprox(document.body.querySelector('.g').offsetHeight, scheduler.rowHeight / 2, 2, 'g');
              });
              t.subTest('Single event cluster', function (t) {
                t.is(getTopPosition('h'), 1, 'h');
                t.isApprox(document.body.querySelector('.h').offsetHeight, scheduler.rowHeight / 1, 2, 'h');
              });
              t.subTest('5 event cluster', function (t) {
                t.is(getTopPosition('j'), 1, 'j');
                t.isApprox(getTopPosition('i'), scheduler.rowHeight / 2, 1, 'j');
                t.isApprox(getTopPosition('k'), scheduler.rowHeight / 2, 1, 'k');
                t.is(getTopPosition('l'), 1, 'l');
                t.isApprox(getTopPosition('m'), scheduler.rowHeight / 4, 1, 'm');
                t.isApprox(document.body.querySelector('.i').offsetHeight, scheduler.rowHeight / 2, 2, 'i');
                t.isApprox(document.body.querySelector('.j').offsetHeight, scheduler.rowHeight / 2, 2, 'j');
                t.isApprox(document.body.querySelector('.k').offsetHeight, scheduler.rowHeight / 2, 2, 'k');
                t.isApprox(document.body.querySelector('.l').offsetHeight, scheduler.rowHeight / 4, 2, 'l');
                t.isApprox(document.body.querySelector('.m').offsetHeight, scheduler.rowHeight / 4, 2, 'm');
              });

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
  t.it('layout upon scheduler viewport resize', function (t) {
    t.it('Resizing Scheduler height with events', /*#__PURE__*/function () {
      var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
        var startEventCount;
        return regeneratorRuntime.wrap(function _callee2$(_context2) {
          while (1) {
            switch (_context2.prev = _context2.next) {
              case 0:
                _context2.next = 2;
                return t.getSchedulerAsync({
                  resourceStore: t.getResourceStore2({}, 100),
                  height: 200
                }, 100);

              case 2:
                scheduler = _context2.sent;
                scheduler.resourceStore.forEach(function (resource) {
                  var e = resource.getEvents()[0];
                  e.startDate = scheduler.timeAxis.startDate;
                  e.endDate = new Date(scheduler.timeAxis.startDate.valueOf() + 1000 * 60 * 60 * 24);
                });
                _context2.next = 6;
                return t.waitForProjectReady();

              case 6:
                t.chain( // Dependencies drawn on frame, so wait for that to complete
                {
                  waitForAnimationFrame: null
                }, function (next) {
                  startEventCount = document.querySelectorAll('.b-sch-event').length;
                  scheduler.height = 760;
                  next();
                }, {
                  // Test completes when the newly visible events show
                  waitFor: function waitFor() {
                    return document.querySelectorAll('.b-sch-event').length > startEventCount;
                  }
                });

              case 7:
              case "end":
                return _context2.stop();
            }
          }
        }, _callee2);
      }));

      return function (_x2) {
        return _ref2.apply(this, arguments);
      };
    }()); // TODO

    t.it('Resizing Scheduler height with events and dependencies', /*#__PURE__*/function () {
      var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
        var startDepCount, startEventCount;
        return regeneratorRuntime.wrap(function _callee3$(_context3) {
          while (1) {
            switch (_context3.prev = _context3.next) {
              case 0:
                _context3.next = 2;
                return t.getSchedulerAsync({
                  dependencyStore: true,
                  resourceStore: t.getResourceStore2({}, 100),
                  height: 200
                }, 100);

              case 2:
                scheduler = _context3.sent;
                scheduler.resourceStore.forEach(function (resource) {
                  var e = resource.getEvents()[0];
                  e.startDate = scheduler.timeAxis.startDate;
                  e.endDate = new Date(scheduler.timeAxis.startDate.valueOf() + 1000 * 60 * 60 * 24);
                });
                _context3.next = 6;
                return t.waitForProjectReady();

              case 6:
                t.chain({
                  waitForSelector: '.b-sch-dependency'
                }, function (next) {
                  startDepCount = document.querySelectorAll('.b-sch-dependency').length;
                  startEventCount = document.querySelectorAll('.b-sch-event').length;
                  scheduler.height = 760;
                  next();
                }, {
                  waitFor: function waitFor() {
                    return document.querySelectorAll('.b-sch-dependency').length > startDepCount && document.querySelectorAll('.b-sch-event').length > startEventCount;
                  }
                });

              case 7:
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
  });
  t.it('should rerender events once on sort', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                rowHeight: 100,
                eventLayout: 'pack',
                viewPreset: 'dayAndWeek',
                startDate: new Date(2018, 0, 1),
                endDate: new Date(2018, 1, 15),
                barMargin: 1,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 200,
                  locked: true
                }],
                resources: [{
                  id: 1,
                  name: 'First'
                }, {
                  id: 2,
                  name: 'Second'
                }, {
                  id: 3,
                  name: 'Third'
                }, {
                  id: 4,
                  name: 'Fourth'
                }],
                events: [{
                  cls: 'a',
                  name: 'a',
                  resourceId: 4,
                  startDate: '2018-01-01',
                  endDate: '2018-01-03'
                }, {
                  cls: 'b',
                  name: 'b',
                  resourceId: 4,
                  startDate: '2018-01-01',
                  endDate: '2018-01-03'
                }, {
                  cls: 'c',
                  name: 'c',
                  resourceId: 4,
                  startDate: '2018-01-01',
                  endDate: '2018-01-03'
                }, {
                  cls: 'd',
                  name: 'd',
                  resourceId: 4,
                  startDate: '2018-01-01',
                  endDate: '2018-01-03'
                }]
              });
              _context4.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.isCalledNTimes('layoutResourceEvents', scheduler.currentOrientation, 0, 'No need to relayout events on sort');
              t.isCalledNTimes('renderEvent', scheduler.currentOrientation, scheduler.eventStore.count, 'Each event rendered');
              scheduler.store.sort('name');

            case 6:
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
  t.it('Number of rendered events should remain stable during scrolling', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var startDate, startEventCount;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return t.getSchedulerAsync({
                resourceStore: t.getResourceStore2({}, 200),
                rowHeight: 50 // To fit 3 rows into the vertical scroll buffer

              }, 200);

            case 2:
              scheduler = _context5.sent;
              startDate = scheduler.timeAxis.startDate;
              scheduler.eventStore.beginBatch();
              scheduler.resourceStore.forEach(function (resource) {
                var e = resource.getEvents()[0];
                e.startDate = startDate;
                e.endDate = new Date(startDate.valueOf() + 1000 * 60 * 60 * 24); // Add some events on this resource

                scheduler.eventStore.add([{
                  resourceId: resource.id,
                  startDate: new Date(startDate.valueOf() + 1000 * 60 * 60 * 24 * 2),
                  endDate: new Date(startDate.valueOf() + 1000 * 60 * 60 * 24 * 3)
                }, {
                  resourceId: resource.id,
                  startDate: new Date(startDate.valueOf() + 1000 * 60 * 60 * 24 * 4),
                  endDate: new Date(startDate.valueOf() + 1000 * 60 * 60 * 24 * 5)
                }]);
              });
              scheduler.eventStore.endBatch();
              _context5.next = 9;
              return t.waitForProjectReady();

            case 9:
              // Scroll down enough to fill the vertical render buffer, if we do not the event count wont match as we scroll
              // further down
              scheduler.scrollTop = 200;
              t.chain( // Wait for events to have been drawn after scroll
              {
                waitForAnimationFrame: null
              }, function (next) {
                startEventCount = t.query('.b-sch-event').length;
                t.diag('Rendered events: ' + document.querySelectorAll('.b-sch-event').length);
                next();
              }, // Scroll to the end
              {
                waitFor: function waitFor() {
                  scheduler.scrollable.scrollBy(null, 100); // Stop when last row is rendered

                  return t.query('.b-grid-row[data-id=r200]').length > 0;
                },
                interval: 50,
                desc: 'Scroll to bottom'
              }, function () {
                // Event count must be stable
                t.is(t.query('.b-sch-event').length, startEventCount, 'Rendered event count is stable');
              });

            case 11:
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
  t.it('Should render events that end outside of view correctly with week based preset', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var bounds;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2011, 0, 1),
                endDate: new Date(2011, 2, 1),
                viewPreset: {
                  tickWidth: 25,
                  displayDateFormat: 'L',
                  timeResolution: {
                    unit: 'week',
                    increment: 1
                  },
                  headers: [{
                    unit: 'week',
                    dateFormat: 'W'
                  }]
                },
                events: [{
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 10),
                  endDate: new Date(2011, 11, 28)
                }]
              }, 1);

            case 2:
              scheduler = _context6.sent;
              bounds = t.rect('.b-sch-event');
              t.ok(bounds.left > 0, 'Event starts in view');

            case 5:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref6.apply(this, arguments);
    };
  }()); // TODO: Restore loop add and investigate rendering

  t.it('Should recalculate scroll height when stacking changes the height of a resource row', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return t.getSchedulerAsync({
                height: 400
              });

            case 2:
              scheduler = _context8.sent;
              t.chain( // Starts with no overflow
              function (next) {
                t.ok(scheduler.scrollable.scrollHeight === scheduler.scrollable.clientHeight);
                next();
              },
              /*#__PURE__*/
              // Make a whole load of overlapping duplicates
              _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                var events, toAdd;
                return regeneratorRuntime.wrap(function _callee7$(_context7) {
                  while (1) {
                    switch (_context7.prev = _context7.next) {
                      case 0:
                        events = scheduler.eventStore.getRange(), toAdd = [];
                        events.forEach(function (event) {
                          var newEvent = event.copy();
                          newEvent.name = newEvent.name + ' copy';
                          toAdd.push(newEvent);
                        });
                        scheduler.eventStore.add(toAdd);
                        _context7.next = 5;
                        return t.waitForProjectReady();

                      case 5:
                      case "end":
                        return _context7.stop();
                    }
                  }
                }, _callee7);
              })), // Now must have overflow
              function () {
                t.ok(scheduler.scrollable.scrollHeight > scheduler.scrollable.clientHeight);
              });

            case 4:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x7) {
      return _ref7.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8746

  t.it('Should recalculate scroll height and move subsequent rows downwards when stacking changes the height of a single resource row', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var event40;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return t.getSchedulerAsync({
                height: 400,
                resourceStore: t.getResourceStore2(null, 100)
              }, 100);

            case 2:
              scheduler = _context10.sent;
              event40 = scheduler.eventStore.getAt(39);
              t.chain( // Starts with no overflow
              function () {
                return scheduler.scrollEventIntoView(event40, {
                  block: 'start'
                });
              }, {
                waitFor: function waitFor() {
                  return scheduler.rowManager.getRowFor(event40.resource);
                }
              },
              /*#__PURE__*/
              // Make row 40 taller due to event overlap
              _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9() {
                var _scheduler2, rowManager, row40, oldRow40Height, newEvent, followingRowTops, i, index, row, heightIncrement, _i, _index, _row;

                return regeneratorRuntime.wrap(function _callee9$(_context9) {
                  while (1) {
                    switch (_context9.prev = _context9.next) {
                      case 0:
                        _scheduler2 = scheduler, rowManager = _scheduler2.rowManager, row40 = rowManager.getRowFor(event40.resource), oldRow40Height = row40.height, newEvent = event40.copy(), followingRowTops = [];

                        for (i = 0, index = row40.dataIndex + 1, row = rowManager.getRow(index); row; row = rowManager.getRow(++index), i++) {
                          followingRowTops[i] = row.top;
                        }

                        newEvent.name = newEvent.name + ' copy';
                        scheduler.eventStore.add(newEvent);
                        _context9.next = 6;
                        return t.waitForProjectReady();

                      case 6:
                        heightIncrement = row40.height - oldRow40Height; // Check all following rows have been bumped down just right

                        for (_i = 0, _index = row40.dataIndex + 1, _row = rowManager.getRow(_index); _row; _row = rowManager.getRow(++_index), _i++) {
                          t.is(_row.top, followingRowTops[_i] + heightIncrement);
                        } // Now must have overflow


                        t.ok(scheduler.scrollable.scrollHeight > scheduler.scrollable.clientHeight);

                      case 9:
                      case "end":
                        return _context9.stop();
                    }
                  }
                }, _callee9);
              })));

            case 5:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x8) {
      return _ref9.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8093

  t.it('Should not redraw other rows when using `eventLayout: none`', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return t.getSchedulerAsync({
                eventLayout: 'none'
              });

            case 2:
              scheduler = _context12.sent;
              _context12.next = 5;
              return t.firesOk({
                observable: scheduler.rowManager,
                events: {
                  renderRow: 3 // first r1, then r1 && r2

                },
                during: function during() {
                  return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11() {
                    return regeneratorRuntime.wrap(function _callee11$(_context11) {
                      while (1) {
                        switch (_context11.prev = _context11.next) {
                          case 0:
                            scheduler.eventStore.first.startDate = new Date(2011, 0, 3);
                            scheduler.eventStore.getById(2).resourceId = 'r1';
                            _context11.next = 4;
                            return t.waitForProjectReady();

                          case 4:
                          case "end":
                            return _context11.stop();
                        }
                      }
                    }, _callee11);
                  }))();
                }
              });

            case 5:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x9) {
      return _ref11.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8642

  t.it('Should apply custom event sorter', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      var sorter, assertEvent;
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              assertEvent = function _assertEvent(id, top) {
                var box = Rectangle.from(document.querySelector("[data-event-id=\"".concat(id, "\"]")), scheduler.timeAxisSubGridElement);
                t.is(box.top, top, 'Correct top for event ' + id);
              };

              sorter = function _sorter(a, b) {
                return a.name > b.name ? -1 : 1;
              };

              _context13.next = 4;
              return t.getSchedulerAsync({
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  duration: 2,
                  name: 'A'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  duration: 2,
                  name: 'B'
                }],
                horizontalEventSorterFn: sorter,
                barMargin: 0
              });

            case 4:
              scheduler = _context13.sent;
              t.diag('Custom sorter applied initially');
              assertEvent(1, 45);
              assertEvent(2, 0);
              t.diag('Custom sorter removed');
              scheduler.horizontalEventSorterFn = null;
              t.chain({
                waitForSelectorNotFound: '.b-animating'
              }, function (next) {
                assertEvent(1, 0);
                assertEvent(2, 45);
                t.diag('Custom sorter reapplied');
                scheduler.horizontalEventSorterFn = sorter;
                next();
              }, {
                waitForSelectorNotFound: '.b-animating'
              }, function () {
                assertEvent(1, 45);
                assertEvent(2, 0);
              });

            case 11:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x10) {
      return _ref12.apply(this, arguments);
    };
  }());
});