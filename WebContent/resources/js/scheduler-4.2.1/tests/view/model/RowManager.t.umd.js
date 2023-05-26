function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, rowManager, eventStore;

  function createScheduler() {
    return _createScheduler.apply(this, arguments);
  }

  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8() {
      var config,
          _scheduler,
          _args8 = arguments;

      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              config = _args8.length > 0 && _args8[0] !== undefined ? _args8[0] : {};
              scheduler = new Scheduler(Object.assign({
                appendTo: document.body,
                startDate: new Date(2020, 3, 12),
                endDate: new Date(2020, 3, 19),
                resources: ArrayHelper.populate(50, function (i) {
                  return {
                    id: i + 1
                  };
                }),
                events: ArrayHelper.populate(100, function (i) {
                  return {
                    id: i + 1,
                    resourceId: Math.floor(i / 2) + 1,
                    startDate: new Date(2020, 3, 15),
                    duration: 2,
                    eventColor: 'blue'
                  };
                }),
                enableEventAnimations: false,
                useInitialAnimation: false,
                rowHeight: 60
              }, config));
              _scheduler = scheduler;
              rowManager = _scheduler.rowManager;
              eventStore = _scheduler.eventStore;
              _context8.next = 7;
              return t.waitForProjectReady(scheduler);

            case 7:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));
    return _createScheduler.apply(this, arguments);
  }

  t.beforeEach(function (t) {
    return scheduler && scheduler.destroy();
  });
  t.it('Should update height map on EventStore CRUD', function (t) {
    t.beforeEach(function (t, next) {
      return createScheduler().then(next);
    });
    t.it('Add', /*#__PURE__*/function () {
      var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
        return regeneratorRuntime.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                t.is(rowManager.totalHeight, 5550, 'Total height initially correct');
                t.is(scheduler.verticalScroller.offsetHeight, 5550, 'Scroller height initially correct');
                eventStore.add({
                  resourceId: 2,
                  startDate: new Date(2020, 3, 15),
                  duration: 1
                });
                _context.next = 5;
                return t.waitForProjectReady(scheduler);

              case 5:
                t.is(rowManager.averageRowHeight, 111, 'Average row height updated');
                t.is(rowManager.heightMap.get(2), 160, 'Height map updated');
                t.is(rowManager.totalHeight, 5600, 'Total height updated');
                t.is(scheduler.verticalScroller.offsetHeight, 5600, 'Scroller height updated');

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
    t.it('Insert', /*#__PURE__*/function () {
      var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
        return regeneratorRuntime.wrap(function _callee2$(_context2) {
          while (1) {
            switch (_context2.prev = _context2.next) {
              case 0:
                eventStore.insert(0, {
                  resourceId: 2,
                  startDate: new Date(2020, 3, 15),
                  duration: 1
                });
                _context2.next = 3;
                return t.waitForProjectReady(scheduler);

              case 3:
                t.is(rowManager.averageRowHeight, 111, 'Average row height updated');
                t.is(rowManager.heightMap.get(2), 160, 'Height map updated');
                t.is(rowManager.totalHeight, 5600, 'Total height updated');
                t.is(scheduler.verticalScroller.offsetHeight, 5600, 'Scroller height updated');

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
    }());
    t.it('Update', /*#__PURE__*/function () {
      var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
        return regeneratorRuntime.wrap(function _callee3$(_context3) {
          while (1) {
            switch (_context3.prev = _context3.next) {
              case 0:
                eventStore.first.startDate = new Date(2020, 3, 18);
                _context3.next = 3;
                return t.waitForProjectReady(scheduler);

              case 3:
                t.is(rowManager.averageRowHeight, 109, 'Average row height updated');
                t.is(rowManager.heightMap.get(1), 60, 'Height map updated');
                t.is(rowManager.totalHeight, 5500, 'Total height updated');
                t.is(scheduler.verticalScroller.offsetHeight, 5500, 'Scroller height updated');
                eventStore.getById(3).resourceId = 5;
                _context3.next = 10;
                return t.waitForProjectReady(scheduler);

              case 10:
                t.is(rowManager.averageRowHeight, 109, 'Average row height not affected');
                t.is(rowManager.heightMap.get(2), 60, 'Height map for source');
                t.is(rowManager.heightMap.get(5), 160, 'And target');
                t.is(rowManager.totalHeight, 5500, 'Total height not affected');
                t.is(scheduler.verticalScroller.offsetHeight, 5500, 'Scroller height not affected');

              case 15:
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
    t.it('Remove', /*#__PURE__*/function () {
      var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
        return regeneratorRuntime.wrap(function _callee4$(_context4) {
          while (1) {
            switch (_context4.prev = _context4.next) {
              case 0:
                eventStore.first.remove();
                _context4.next = 3;
                return t.waitForProjectReady(scheduler);

              case 3:
                t.is(rowManager.averageRowHeight, 109, 'Average row height updated');
                t.is(rowManager.heightMap.get(1), 60, 'Height map updated');
                t.is(rowManager.totalHeight, 5500, 'Total height updated');
                t.is(scheduler.verticalScroller.offsetHeight, 5500, 'Scroller height updated');

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
    t.it('Remove all', /*#__PURE__*/function () {
      var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
        return regeneratorRuntime.wrap(function _callee5$(_context5) {
          while (1) {
            switch (_context5.prev = _context5.next) {
              case 0:
                eventStore.removeAll();
                _context5.next = 3;
                return t.waitForProjectReady(scheduler);

              case 3:
                t.isApprox(rowManager.averageRowHeight, 60, 1, 'Average row height updated');
                t.is(rowManager.heightMap.get(1), 60, 'Height map updated');
                t.is(rowManager.totalHeight, 3050, 'Total height updated');

              case 6:
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
    t.it('Dataset', /*#__PURE__*/function () {
      var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
        return regeneratorRuntime.wrap(function _callee6$(_context6) {
          while (1) {
            switch (_context6.prev = _context6.next) {
              case 0:
                eventStore.data = [{
                  resourceId: 2,
                  startDate: new Date(2020, 3, 15),
                  duration: 1
                }, {
                  resourceId: 2,
                  startDate: new Date(2020, 3, 15),
                  duration: 1
                }];
                _context6.next = 3;
                return t.waitForProjectReady(scheduler);

              case 3:
                t.isApprox(rowManager.averageRowHeight, 61, 1, 'Average row height updated');
                t.is(rowManager.heightMap.get(1), 60, 'Height map updated #1');
                t.is(rowManager.heightMap.get(2), 110, 'Height map updated #2');
                t.is(rowManager.totalHeight, 3100, 'Total height updated');
                t.is(scheduler.verticalScroller.offsetHeight, 3100, 'Scroller height updated');

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
    t.it('Filter', function (t) {
      eventStore.filter(function (e) {
        return e.resourceId < 3;
      });
      t.is(rowManager.averageRowHeight, 62, 'Average row height updated');
      t.is(rowManager.heightMap.get(1), 110, 'Height map updated #1');
      t.is(rowManager.heightMap.get(2), 110, 'Height map updated #2');
      t.is(rowManager.heightMap.get(3), 60, 'Height map updated #3');
      t.is(rowManager.totalHeight, 3150, 'Total height updated');
      t.is(scheduler.verticalScroller.offsetHeight, 3150, 'Scroller height updated');
      eventStore.clearFilters();
      t.isApprox(rowManager.averageRowHeight, 110, 1, 'Average row height updated');
      t.is(rowManager.heightMap.get(1), 110, 'Height map updated #1');
      t.is(rowManager.heightMap.get(2), 110, 'Height map updated #2');
      t.is(rowManager.heightMap.get(3), 110, 'Height map updated #3');
      t.is(rowManager.totalHeight, 5550, 'Total height updated');
      t.is(scheduler.verticalScroller.offsetHeight, 5550, 'Scroller height updated');
    });
  }); // For a simple case when there are few non-overlapping events per resource row estimation should be exact from
  // the start. If estimation is wrong multipage export will likely fail too

  t.it('Should estimate scroll height properly on load', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      var rnd, startDate, week2, endDate, getStart, getEnd, initialScrollHeight, initialTotalHeight;
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              rnd = new RandomGenerator(), startDate = new Date('2020-04-20'), week2 = new Date('2020-04-27'), endDate = new Date('2020-05-02'), getStart = function getStart(i) {
                return DateHelper.add(i % 2 === 0 ? startDate : week2, rnd.nextRandom(3), 'd');
              }, getEnd = function getEnd(i) {
                return DateHelper.min(DateHelper.add(i % 2 === 0 ? week2 : endDate, -rnd.nextRandom(3), 'd'), i % 2 === 0 ? week2 : endDate);
              };
              _context7.next = 3;
              return createScheduler({
                startDate: startDate,
                endDate: endDate,
                rowHeight: 100,
                viewPreset: 'weekAndDayLetter',
                events: ArrayHelper.populate(100, function (i) {
                  return {
                    id: i + 1,
                    resourceId: Math.floor(i / 2) + 1,
                    startDate: getStart(i),
                    endDate: getEnd(i),
                    eventColor: rnd.fromArray(['blue', 'green'])
                  };
                })
              });

            case 3:
              initialScrollHeight = scheduler.scrollable.scrollHeight, initialTotalHeight = scheduler.rowManager.totalHeight;
              scheduler.scrollable.scrollTo(null, scheduler.scrollable.maxY); // Wait for scroll end to give scheduler time to react to scroll and estimate heights

              _context7.next = 7;
              return scheduler.scrollable.await('scrollEnd');

            case 7:
              t.is(scheduler.scrollable.scrollHeight, initialScrollHeight, 'Scroll height was correctly calculated on start');
              t.is(scheduler.rowManager.totalHeight, initialTotalHeight, 'Total height was correctly calculated on start');

            case 9:
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
});