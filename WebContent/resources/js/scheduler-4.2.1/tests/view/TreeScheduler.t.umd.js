function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });

  function createScheduler() {
    return _createScheduler.apply(this, arguments);
  }

  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                useInitialAnimation: false,
                enableEventAnimations: false,
                features: {
                  tree: true
                },
                columns: [{
                  type: 'tree',
                  text: 'Name',
                  width: 220,
                  field: 'name'
                }],
                resources: [{
                  id: 1,
                  name: 'A',
                  expanded: true,
                  children: [{
                    id: 11,
                    name: 'AA'
                  }, {
                    id: 12,
                    name: 'AB'
                  }, {
                    id: 13,
                    name: 'AC'
                  }]
                }, {
                  id: 2,
                  name: 'B',
                  expanded: false,
                  children: [{
                    id: 21,
                    name: 'BA'
                  }, {
                    id: 22,
                    name: 'BB'
                  }]
                }],
                startDate: new Date(2018, 5, 1),
                endDate: new Date(2018, 5, 8),
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2018, 5, 1),
                  duration: 1
                }, {
                  id: 2,
                  resourceId: 11,
                  startDate: new Date(2018, 5, 1),
                  duration: 2
                }, {
                  id: 3,
                  resourceId: 12,
                  startDate: new Date(2018, 5, 1),
                  duration: 3
                }, {
                  id: 4,
                  resourceId: 2,
                  startDate: new Date(2018, 5, 1),
                  duration: 4
                }, {
                  id: 5,
                  resourceId: 22,
                  startDate: new Date(2018, 5, 1),
                  duration: 5
                }, {
                  id: 6,
                  resourceId: 22,
                  startDate: new Date(2018, 5, 1),
                  duration: 6
                }, {
                  id: 7,
                  resourceId: 22,
                  startDate: new Date(2018, 5, 1),
                  duration: 7
                }]
              });
              _context5.next = 3;
              return t.waitForProjectReady();

            case 3:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));
    return _createScheduler.apply(this, arguments);
  }

  t.it('Expand/collapse should work', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var spy;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return createScheduler();

            case 2:
              spy = t.spyOn(scheduler, 'runWithTransition');
              t.selectorCountIs(scheduler.unreleasedEventSelector, 4, 'Correct number of events initially');
              _context.next = 6;
              return scheduler.collapse(1);

            case 6:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 2, 'Correct number of events after collapse');
              _context.next = 9;
              return scheduler.expand(1);

            case 9:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 4, 'Correct number of events after expand');
              _context.next = 12;
              return scheduler.collapseAll();

            case 12:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 2, 'Correct number of events after collapse all');
              _context.next = 15;
              return scheduler.expandAll();

            case 15:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 7, 'Correct number of events after expand all');
              _context.next = 18;
              return scheduler.collapseAll();

            case 18:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 2, 'Correct number of events after collapse all');
              t.ok(spy.calls.allArgs().every(function (a) {
                return a[1] === false;
              }), 'No transition triggered');

            case 20:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7770

  t.it('Removing parent should remove events', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return createScheduler();

            case 2:
              scheduler.resourceStore.first.remove();
              _context2.next = 5;
              return t.waitForProjectReady();

            case 5:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Correct number of events rendered after remove');

            case 6:
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
  t.it('Converting a leaf node to a parent should only rerender the affected row', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var aa;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return createScheduler();

            case 2:
              aa = scheduler.resourceStore.getAt(1); // Converting a resource to a parent only renders that row

              t.willFireNTimes(scheduler.rowManager, 'renderRow', 1);
              t.ok(aa.isLeaf);
              aa.appendChild({
                name: 'AAA'
              });
              _context3.next = 8;
              return t.waitForProjectReady();

            case 8:
              t.notOk(aa.isLeaf);

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
  }()); // https://app.assembla.com/spaces/bryntum/tickets/9110

  t.it('Should be possible to change events which are not available (inside collapsed resource when there is no rows below)', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var record;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                features: {
                  tree: true
                },
                columns: [{
                  type: 'tree',
                  text: 'Name',
                  field: 'name',
                  width: 220
                }],
                resources: [{
                  id: 1,
                  name: 'Parent',
                  expanded: true,
                  children: [{
                    id: 2,
                    name: 'Child'
                  }]
                }],
                startDate: new Date(2018, 5, 1),
                endDate: new Date(2018, 5, 8),
                events: [{
                  id: 1,
                  resourceId: 2,
                  startDate: new Date(2018, 5, 1),
                  duration: 2
                }]
              });
              _context4.next = 3;
              return t.waitForProjectReady();

            case 3:
              record = scheduler.eventStore.first;
              _context4.next = 6;
              return scheduler.collapse(1);

            case 6:
              record.name = 'test';
              _context4.next = 9;
              return scheduler.expand(1);

            case 9:
              t.selectorExists('.b-sch-event:textEquals(test)', 'Event name is updated');

            case 10:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/243

  t.it('Should be possible to load rows on demand', function (t) {
    t.mockUrl('load', {
      responseText: JSON.stringify({
        success: true,
        data: [{
          id: 1,
          name: 'foo',
          children: true
        }]
      })
    });
    scheduler = new Scheduler({
      appendTo: document.body,
      features: {
        tree: true
      },
      columns: [{
        type: 'tree',
        text: 'Name',
        field: 'name',
        width: 220
      }],
      resourceStore: {
        tree: true,
        autoLoad: true,
        fields: ['model', 'color', 'year', 'rating'],
        readUrl: 'load'
      },
      startDate: new Date(2018, 5, 1),
      endDate: new Date(2018, 5, 8),
      events: [{
        id: 1,
        resourceId: 1,
        name: 'event 1',
        startDate: new Date(2018, 5, 1),
        duration: 2
      }, {
        id: 2,
        resourceId: 2,
        name: 'event 2',
        startDate: new Date(2018, 5, 1),
        duration: 2
      }]
    });
    t.chain({
      waitForSelector: '.b-sch-event:contains(event 1)'
    }, function (next) {
      t.mockUrl('load', {
        responseText: JSON.stringify({
          success: true,
          data: [{
            id: 2,
            name: 'bar'
          }]
        })
      });
      next();
    }, function () {
      return scheduler.expand(1);
    }, {
      waitForSelector: '.b-grid-cell:contains(bar)'
    }, {
      waitForSelector: '.b-sch-event:contains(event 2)'
    });
  });
});