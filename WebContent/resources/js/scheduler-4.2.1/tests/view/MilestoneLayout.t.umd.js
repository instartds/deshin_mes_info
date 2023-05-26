function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, first, second, third, firstElement, secondElement, thirdElement;
  t.beforeEach(function () {
    scheduler && scheduler.destroy && scheduler.destroy();
  });

  function createScheduler() {
    return _createScheduler.apply(this, arguments);
  }

  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
      var config,
          _args7 = arguments;
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              config = _args7.length > 0 && _args7[0] !== undefined ? _args7[0] : {};
              scheduler = new Scheduler(Object.assign({
                appendTo: document.body,
                startDate: '2018-03-19',
                endDate: '2018-03-25',
                resources: [{
                  id: 1,
                  name: 'Demo'
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: '2018-03-19',
                  duration: 2,
                  name: 'Event 1'
                }, {
                  id: 2,
                  resourceId: 1,
                  startDate: '2018-03-19',
                  duration: 0,
                  name: 'Milestone with long text',
                  milestoneWidth: 200
                }, {
                  id: 3,
                  resourceId: 1,
                  startDate: '2018-03-20',
                  duration: 2,
                  name: 'Event 3'
                }, {
                  id: 4,
                  resourceId: 1,
                  startDate: '2018-03-20',
                  duration: 0,
                  name: 'Milestone',
                  milestoneWidth: 80
                }, {
                  id: 5,
                  resourceId: 1,
                  startDate: '2018-03-20',
                  duration: 0,
                  name: 'MS',
                  milestoneWidth: 0
                }],
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 130
                }],
                // Available modes are :
                // 'default'  - no layout
                // 'data'     - from milestoneWidth
                // 'estimate' - length * char width
                // 'measure'  _ precise but slowest
                milestoneLayoutMode: 'measure',
                // Width per char in px when using 'estimate'
                milestoneCharWidth: 10,
                // Milestone alignment, start, center or end
                milestoneAlign: 'center',
                enableEventAnimations: false
              }, config));
              _context7.next = 4;
              return t.waitForProjectReady();

            case 4:
              first = scheduler.eventStore.getById(2);
              second = scheduler.eventStore.getById(4);
              third = scheduler.eventStore.getById(5);
              firstElement = first && scheduler.getElementsFromEventRecord(first)[0].parentNode;
              secondElement = second && scheduler.getElementsFromEventRecord(second)[0].parentNode;
              thirdElement = third && scheduler.getElementsFromEventRecord(third)[0].parentNode;

            case 10:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));
    return _createScheduler.apply(this, arguments);
  }

  t.it('milestoneLayoutMode "data" should use width from records', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return createScheduler({
                milestoneLayoutMode: 'data'
              });

            case 2:
              t.chain({
                waitForSelector: '.b-sch-event'
              }, function (next) {
                t.isApprox(firstElement.offsetWidth, 200, 'Correct width for "Milestone with long text"');
                t.isApprox(secondElement.offsetWidth, 80, 'Correct width for "Milestone"');
                t.isApprox(thirdElement.offsetWidth, 40, 'Positive width for "MS"');
                t.diag('Changing record width');
                first.milestoneWidth = 300;
                next();
              }, // Need to wait since record updates are animated
              {
                waitFor: function waitFor() {
                  return Math.abs(firstElement.offsetWidth - 300) < 5;
                },
                desc: 'Milestone width changed'
              });

            case 3:
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
  t.it('milestoneLayoutMode "estimate" should use width based on length', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return createScheduler({
                milestoneLayoutMode: 'estimate'
              });

            case 2:
              t.chain({
                waitForSelector: '.b-sch-event'
              }, function () {
                var factor = scheduler.milestoneCharWidth;
                t.isApprox(firstElement.offsetWidth, factor * first.name.length, 'Correct width for "Milestone with long text"');
                t.isApprox(secondElement.offsetWidth, factor * second.name.length, 'Correct width for "Milestone"');
                t.isGreater(thirdElement.offsetWidth, 0, 'Positive width for "MS"');
                t.diag('Changing char width');
                factor = scheduler.milestoneCharWidth = 20;
                t.isApprox(firstElement.offsetWidth, factor * first.name.length, 'Correct width for "Milestone with long text"');
                t.isApprox(secondElement.offsetWidth, factor * second.name.length, 'Correct width for "Milestone"');
                t.isGreater(thirdElement.offsetWidth, 0, 'Positive width for "MS"');
              });

            case 3:
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
  t.it('milestoneLayoutMode "measure" should yield correct widths based on event name', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return createScheduler({
                milestoneLayoutMode: 'measure'
              });

            case 2:
              t.chain({
                waitForSelector: '.b-sch-event'
              }, function (next) {
                t.isApprox(firstElement.offsetWidth, 186, 'Correct width for "Milestone with long text"');
                t.isApprox(secondElement.offsetWidth, 100, 'Correct width for "Milestone"');
                t.isApprox(thirdElement.offsetWidth, 61, 'Correct width for "MS"');
                t.diag('Changing text');
                first.name = 'Changed';
                next();
              }, // Need to wait since record updates are animated
              {
                waitFor: function waitFor() {
                  return Math.abs(firstElement.offsetWidth - 98) < 5;
                },
                desc: 'Milestone width changed'
              });

            case 3:
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
  t.it('milestone position should be affected by align', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return createScheduler({
                milestoneAlign: 'start',
                milestoneLayoutMode: 'data'
              });

            case 2:
              t.chain({
                waitForSelector: '.b-sch-event'
              }, function () {
                t.diag('milestoneAlign: "start"'); // Width should not be affected

                t.isApprox(firstElement.offsetWidth, 200, 'Correct width for "Milestone with long text"');
                t.isApprox(secondElement.offsetWidth, 80, 'Correct width for "Milestone"');
                t.isGreater(thirdElement.offsetWidth, 0, 'Positive width for "MS"');
                t.isApprox(firstElement.getBoundingClientRect().left, 262, 'First at correct position');
                t.isApprox(secondElement.getBoundingClientRect().left, 389, 'Second at correct position');
                t.isApprox(thirdElement.getBoundingClientRect().left, 389, 'Third at correct position');
                t.diag('milestoneAlign: "end"');
                scheduler.milestoneAlign = 'end'; // Width should not be affected

                t.isApprox(firstElement.offsetWidth, 200, 'Correct width for "Milestone with long text"');
                t.isApprox(secondElement.offsetWidth, 80, 'Correct width for "Milestone"');
                t.isGreater(thirdElement.offsetWidth, 0, 'Positive width for "MS"');
                t.isApprox(firstElement.getBoundingClientRect().right, 262, 'First at correct position');
                t.isApprox(secondElement.getBoundingClientRect().right, 389, 'Second at correct position');
                t.isApprox(thirdElement.getBoundingClientRect().right, 389, 'Third at correct position');
                t.diag('milestoneAlign: "center"');
                scheduler.milestoneAlign = 'center'; // Width should not be affected

                t.isApprox(firstElement.offsetWidth, 200, 'Correct width for "Milestone with long text"');
                t.isApprox(secondElement.offsetWidth, 80, 'Correct width for "Milestone"');
                t.isGreater(thirdElement.offsetWidth, 0, 'Positive width for "MS"');
                t.isApprox(firstElement.getBoundingClientRect().left, 162, 'First at correct position');
                t.isApprox(secondElement.getBoundingClientRect().left, 349, 'Second at correct position');
                t.isApprox(thirdElement.getBoundingClientRect().left, 369, 'Third at correct position');
              });

            case 3:
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
  t.it('EventDrag should take milestoneLayout into account', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var eventRecord;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return createScheduler({
                milestoneAlign: 'center',
                milestoneLayoutMode: 'data'
              });

            case 2:
              eventRecord = scheduler.eventStore.getById(2);
              t.chain({
                waitForSelector: '.b-sch-event'
              }, {
                drag: '[data-event-id="2"]',
                by: [scheduler.timeAxisViewModel.tickSize, 0]
              }, function (next) {
                t.is(eventRecord.startDate, new Date(2018, 2, 20), 'Correct startDate after drag');
                scheduler.milestoneAlign = 'end';
                next();
              }, {
                drag: '[data-event-id="2"]',
                by: [scheduler.timeAxisViewModel.tickSize, 0]
              }, function (next) {
                t.is(eventRecord.startDate, new Date(2018, 2, 21), 'Correct startDate after drag');
                scheduler.milestoneAlign = 'start';
                next();
              }, {
                drag: '[data-event-id="2"]',
                by: [scheduler.timeAxisViewModel.tickSize, 0]
              }, function () {
                t.is(eventRecord.startDate, new Date(2018, 2, 22), 'Correct startDate after drag');
                scheduler.milestoneAlign = 'start';
              });

            case 4:
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
  t.it('Should render text inside when milestoneTextPosition is `inside`', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var el;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return createScheduler({
                milestoneTextPosition: 'inside',
                rowHeight: 200,
                tickSize: 200,
                columns: [],
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: '2018-03-19',
                  duration: 0,
                  name: '!'
                }]
              });

            case 2:
              el = t.query('.b-sch-event-wrap:not(.b-measure) .b-sch-event:contains(!)')[0];
              t.isApprox(el.getBoundingClientRect().left, 200, 'Text inside milestone');

            case 4:
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
});