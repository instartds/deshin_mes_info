function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  t.it('DailyIterator', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var eventStore, project, recurrence1, recurrence2;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: '2018-05-16 12:30:55',
                  endDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=DAILY;COUNT=4;'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  startDate: '2018-05-16 12:30:55',
                  endDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=DAILY;INTERVAL=10;UNTIL=20180527T111213'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1'
                  }]
                })
              });
              _context.next = 4;
              return project.commitAsync();

            case 4:
              recurrence1 = eventStore.getById(1).recurrence, recurrence2 = eventStore.getById(2).recurrence;
              t.it('Count', function (t) {
                var dates = [];
                DailyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence1,
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 16, 12, 30, 55), new Date(2018, 4, 17, 12, 30, 55), new Date(2018, 4, 18, 12, 30, 55), new Date(2018, 4, 19, 12, 30, 55)], 'proper dates iterated');
              });
              t.it('Start/End dates (startDate is greater than event start)', function (t) {
                var dates = [];
                DailyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence1,
                  startDate: new Date(2018, 4, 16, 12, 30, 56),
                  endDate: new Date(2018, 4, 17, 12, 30, 55),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 17, 12, 30, 55)], 'proper dates iterated');
              });
              t.it('Start/End dates (startDate is less than event start)', function (t) {
                var dates = [];
                DailyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence1,
                  startDate: new Date(2018, 4, 16, 12, 30, 54),
                  endDate: new Date(2018, 4, 17, 12, 30, 55),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 16, 12, 30, 55), new Date(2018, 4, 17, 12, 30, 55)], 'proper dates iterated');
              });
              t.it('Until date', function (t) {
                var dates = [];
                t.is(recurrence2.endDate, new Date(2018, 4, 27, 11, 12, 13), 'proper recurrence EndDate');
                DailyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence2,
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 16, 12, 30, 55), new Date(2018, 4, 26, 12, 30, 55)], 'proper dates iterated');
              });
              t.it('Until date + endDate', function (t) {
                var dates = [];
                DailyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence2,
                  endDate: new Date(2018, 4, 26, 12, 30, 54),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 16, 12, 30, 55)], 'proper dates iterated');
              });

            case 10:
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
  t.it('WeeklyIterator', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var eventStore, project, recurrence1, recurrence2, recurrence3, recurrence4, recurrence5;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: '2018-05-16 12:30:55',
                  endDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;COUNT=4;'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  startDate: '2018-05-16 12:30:55',
                  endDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;'
                }, {
                  id: 3,
                  resourceId: 'r1',
                  startDate: '2018-05-16 13:30:55',
                  endDate: '2018-05-18 12:12:13',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=FR,SA;COUNT=4'
                }, {
                  id: 4,
                  resourceId: 'r1',
                  startDate: '2018-05-16 13:30:55',
                  endDate: '2018-05-18 12:12:13',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=FR,SA'
                }, // Weekly in 2 weeks on Mon, Tue, Wed, Thu, Fri starting on 11/02/2020
                {
                  id: 5,
                  resourceId: 'r1',
                  startDate: '2020-11-02 13:30:55',
                  endDate: '2020-11-03 12:12:13',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,TU,WE,TH,FR'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1'
                  }]
                })
              });
              _context2.next = 4;
              return project.commitAsync();

            case 4:
              recurrence1 = eventStore.getById(1).recurrence, recurrence2 = eventStore.getById(2).recurrence, recurrence3 = eventStore.getById(3).recurrence, recurrence4 = eventStore.getById(4).recurrence, recurrence5 = eventStore.getById(5).recurrence;
              t.it('Count', function (t) {
                var dates = [];
                WeeklyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence1,
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 16, 12, 30, 55), new Date(2018, 4, 23, 12, 30, 55), new Date(2018, 4, 30, 12, 30, 55), new Date(2018, 5, 6, 12, 30, 55)], 'proper dates iterated');
              });
              t.it('Start/End dates', function (t) {
                var dates = [];
                WeeklyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence2,
                  startDate: new Date(2018, 4, 23, 12, 30, 55),
                  endDate: new Date(2018, 5, 6, 12, 30, 55),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 23, 12, 30, 55), new Date(2018, 4, 30, 12, 30, 55), new Date(2018, 5, 6, 12, 30, 55)], 'proper dates iterated');
              });
              t.it('Days + Count', function (t) {
                var dates = [];
                WeeklyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence3,
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 18, 13, 30, 55), new Date(2018, 4, 19, 13, 30, 55), new Date(2018, 4, 25, 13, 30, 55), new Date(2018, 4, 26, 13, 30, 55)], 'proper dates iterated');
              });
              t.it('Days + Start/End dates', function (t) {
                var dates = [];
                WeeklyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence4,
                  startDate: new Date(2018, 4, 19, 13, 30, 55),
                  endDate: new Date(2018, 4, 26, 13, 30, 55),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 19, 13, 30, 55), new Date(2018, 4, 25, 13, 30, 55), new Date(2018, 4, 26, 13, 30, 55)], 'proper dates iterated');
              });
              t.it('Iteration startDate is before event start date', function (t) {
                var dates = [];
                WeeklyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence1,
                  startDate: new Date(2018, 4, 1),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 16, 12, 30, 55), new Date(2018, 4, 23, 12, 30, 55), new Date(2018, 4, 30, 12, 30, 55), new Date(2018, 5, 6, 12, 30, 55)], 'proper dates iterated');
              });
              t.it('Continue iteration of Count limited recurrence', function (t) {
                var dates = [],
                    indexes = [];
                WeeklyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence1,
                  startDate: new Date(2018, 4, 23, 12, 30, 56),
                  fn: function fn(date, index) {
                    dates.push(date);
                    indexes.push(index);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 30, 12, 30, 55), new Date(2018, 5, 6, 12, 30, 55)], 'proper dates iterated');
                t.isDeeply(indexes, [3, 4], 'proper indexes iterated');
              }); // Weekly in 2 weeks on Mon, Tue, Wed, Thu, Fri starting on 11/02/2020.

              t.it('Weekly in 2 weeks on Mon, Tue, Wed, Thu, Fri starting on 11/02/2020', function (t) {
                var dates = [],
                    indexes = [];
                WeeklyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence5,
                  startDate: new Date(2020, 10, 2, 13, 30, 55),
                  endDate: new Date(2020, 10, 9, 13, 30, 54),
                  fn: function fn(date, index) {
                    dates.push(date);
                    indexes.push(index);
                  }
                });
                t.isDeeply(dates, [new Date(2020, 10, 2, 13, 30, 55), new Date(2020, 10, 3, 13, 30, 55), new Date(2020, 10, 4, 13, 30, 55), new Date(2020, 10, 5, 13, 30, 55), new Date(2020, 10, 6, 13, 30, 55)], 'proper dates iterated');
                t.isDeeply(indexes, [1, 2, 3, 4, 5], 'proper indexes iterated');
                dates = [];
                indexes = [];
                WeeklyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence5,
                  startDate: new Date(2020, 10, 9, 13, 30, 55),
                  endDate: new Date(2020, 10, 16, 13, 30, 54),
                  fn: function fn(date, index) {
                    dates.push(date);
                    indexes.push(index);
                  }
                });
                t.isDeeply(dates, [], 'proper dates iterated');
                t.isDeeply(indexes, [], 'proper indexes iterated');
                dates = [];
                indexes = [];
                WeeklyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence5,
                  startDate: new Date(2020, 10, 16, 13, 30, 55),
                  endDate: new Date(2020, 10, 23, 13, 30, 54),
                  fn: function fn(date, index) {
                    dates.push(date);
                    indexes.push(index);
                  }
                });
                t.isDeeply(dates, [new Date(2020, 10, 16, 13, 30, 55), new Date(2020, 10, 17, 13, 30, 55), new Date(2020, 10, 18, 13, 30, 55), new Date(2020, 10, 19, 13, 30, 55), new Date(2020, 10, 20, 13, 30, 55)], 'proper dates iterated');
                t.isDeeply(indexes, [6, 7, 8, 9, 10], 'proper indexes iterated');
              });

            case 12:
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
  t.it('MonthlyIterator', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var eventStore, project, recurrence1, recurrence2, recurrence3, recurrence4, recurrence5, recurrence6, recurrence7;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: '2018-05-16 12:30:55',
                  endDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=MONTHLY;INTERVAL=2;COUNT=4;'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  startDate: '2018-05-16 12:30:55',
                  endDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=MONTHLY;INTERVAL=2;'
                }, {
                  id: 3,
                  resourceId: 'r1',
                  startDate: '2018-05-16 13:30:55',
                  endDate: '2018-05-18 12:12:13',
                  recurrenceRule: 'FREQ=MONTHLY;INTERVAL=2;BYMONTHDAY=30,-1;COUNT=4;'
                }, {
                  id: 4,
                  resourceId: 'r1',
                  startDate: '2018-05-16 13:30:55',
                  endDate: '2018-05-18 12:12:13',
                  recurrenceRule: 'FREQ=MONTHLY;INTERVAL=2;BYMONTHDAY=30,-1;'
                }, {
                  id: 5,
                  resourceId: 'r1',
                  startDate: '2018-05-16 14:30:55',
                  endDate: '2018-05-18 13:12:13',
                  recurrenceRule: 'FREQ=MONTHLY;INTERVAL=2;BYDAY=MO,TU,WE,TH,FR;BYSETPOS=1,-1;COUNT=4'
                }, {
                  id: 6,
                  resourceId: 'r1',
                  startDate: '2018-05-16 14:30:55',
                  endDate: '2018-05-18 13:12:13',
                  recurrenceRule: 'FREQ=MONTHLY;INTERVAL=2;BYDAY=SU,SA;BYSETPOS=1,-1'
                }, {
                  id: 7,
                  resourceId: 'r1',
                  startDate: '2018-05-16 15:30:55',
                  endDate: '2018-05-18 14:12:13',
                  recurrenceRule: 'FREQ=MONTHLY;INTERVAL=2;BYDAY=-1SU,1SA,5MO;COUNT=4'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1'
                  }]
                })
              });
              _context3.next = 4;
              return project.commitAsync();

            case 4:
              recurrence1 = eventStore.getById(1).recurrence, recurrence2 = eventStore.getById(2).recurrence, recurrence3 = eventStore.getById(3).recurrence, recurrence4 = eventStore.getById(4).recurrence, recurrence5 = eventStore.getById(5).recurrence, recurrence6 = eventStore.getById(6).recurrence, recurrence7 = eventStore.getById(7).recurrence;
              t.it('Count', function (t) {
                var dates = [];
                MonthlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence1,
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 16, 12, 30, 55), new Date(2018, 6, 16, 12, 30, 55), new Date(2018, 8, 16, 12, 30, 55), new Date(2018, 10, 16, 12, 30, 55)], 'proper dates iterated');
              });
              t.it('Start/End dates', function (t) {
                var dates = [];
                MonthlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence2,
                  startDate: new Date(2018, 6, 16, 13, 30, 55),
                  endDate: new Date(2018, 10, 16, 12, 30, 54),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 8, 16, 12, 30, 55)], 'proper dates iterated');
              });
              t.it('Start/End dates 2', function (t) {
                var dates = [];
                MonthlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence2,
                  startDate: new Date(2018, 7, 16, 12, 30, 55),
                  endDate: new Date(2018, 10, 16, 12, 30, 54),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 8, 16, 12, 30, 55)], 'proper dates iterated');
              });
              t.it('MonthDays + Count', function (t) {
                var dates = [];
                MonthlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence3,
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 30, 13, 30, 55), new Date(2018, 4, 31, 13, 30, 55), new Date(2018, 6, 30, 13, 30, 55), new Date(2018, 6, 31, 13, 30, 55)], 'proper dates iterated');
              });
              t.it('MonthDays + Start/End dates', function (t) {
                var dates = [];
                MonthlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence4,
                  startDate: new Date(2018, 6, 30, 10, 30, 55),
                  endDate: new Date(2018, 9, 30, 13, 30, 55),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 6, 30, 13, 30, 55), new Date(2018, 6, 31, 13, 30, 55), new Date(2018, 8, 30, 13, 30, 55)], 'proper dates iterated');
              });
              t.it('Days + Count + Position (first and last working days of month)', function (t) {
                var dates = [];
                MonthlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence5,
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 31, 14, 30, 55), new Date(2018, 6, 2, 14, 30, 55), new Date(2018, 6, 31, 14, 30, 55), new Date(2018, 8, 3, 14, 30, 55)], 'proper dates iterated');
              });
              t.it('Days + Start/End + Position (first and last weekends of month)', function (t) {
                var dates = [];
                MonthlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence6,
                  startDate: new Date(2018, 4, 23, 14, 30, 55),
                  endDate: new Date(2018, 6, 29, 14, 30, 55),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 27, 14, 30, 55), new Date(2018, 6, 1, 14, 30, 55), new Date(2018, 6, 29, 14, 30, 55)], 'proper dates iterated');
              });
              t.it('Numbered Days + Count', function (t) {
                var dates = [];
                MonthlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence7,
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 27, 15, 30, 55), new Date(2018, 6, 7, 15, 30, 55), new Date(2018, 6, 29, 15, 30, 55), new Date(2018, 6, 30, 15, 30, 55)], 'proper dates iterated');
              });
              t.it('Continue iteration of Count limited recurrence', function (t) {
                var dates = [],
                    indexes = [];
                MonthlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence1,
                  startDate: new Date(2018, 6, 16, 12, 30, 56),
                  fn: function fn(date, index) {
                    dates.push(date);
                    indexes.push(index);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 8, 16, 12, 30, 55), new Date(2018, 10, 16, 12, 30, 55)], 'proper dates iterated');
                t.isDeeply(indexes, [3, 4], 'proper indexes iterated');
              });

            case 14:
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
  t.it('YearlyIterator', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var eventStore, project, recurrence1, recurrence2, recurrence3, recurrence4, recurrence5, recurrence6, recurrence7;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: '2018-05-16 12:30:55',
                  endDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=YEARLY;INTERVAL=2;COUNT=4;'
                }, {
                  id: 2,
                  resourceId: 'r1',
                  startDate: '2018-05-16 12:30:55',
                  endDate: '2018-05-18 11:12:13',
                  recurrenceRule: 'FREQ=YEARLY;INTERVAL=2;'
                }, {
                  id: 3,
                  resourceId: 'r1',
                  startDate: '2018-05-16 13:30:55',
                  endDate: '2018-05-18 12:12:13',
                  recurrenceRule: 'FREQ=YEARLY;INTERVAL=2;COUNT=4;BYMONTH=2,8;'
                }, {
                  id: 4,
                  resourceId: 'r1',
                  startDate: '2018-05-16 13:30:55',
                  endDate: '2018-05-18 12:12:13',
                  recurrenceRule: 'FREQ=YEARLY;INTERVAL=2;BYMONTH=1,12;'
                }, {
                  id: 5,
                  resourceId: 'r1',
                  startDate: '2018-05-16 14:30:55',
                  endDate: '2018-05-18 13:12:13',
                  recurrenceRule: 'FREQ=YEARLY;INTERVAL=2;COUNT=4;BYDAY=MO,TU,WE,TH,FR;BYSETPOS=1,-1'
                }, {
                  id: 6,
                  resourceId: 'r1',
                  startDate: '2018-05-16 14:30:55',
                  endDate: '2018-05-18 13:12:13',
                  recurrenceRule: 'FREQ=YEARLY;INTERVAL=2;BYDAY=SU,SA;BYSETPOS=1,-1'
                }, {
                  id: 7,
                  resourceId: 'r1',
                  startDate: '2018-05-16 15:30:55',
                  endDate: '2018-05-18 14:12:13',
                  recurrenceRule: 'FREQ=YEARLY;INTERVAL=2;BYDAY=-1SU,1SA,5MO;COUNT=4'
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: new ResourceStore({
                  data: [{
                    id: 'r1'
                  }]
                })
              });
              _context4.next = 4;
              return project.commitAsync();

            case 4:
              recurrence1 = eventStore.getById(1).recurrence, recurrence2 = eventStore.getById(2).recurrence, recurrence3 = eventStore.getById(3).recurrence, recurrence4 = eventStore.getById(4).recurrence, recurrence5 = eventStore.getById(5).recurrence, recurrence6 = eventStore.getById(6).recurrence, recurrence7 = eventStore.getById(7).recurrence;
              t.it('Count', function (t) {
                var dates = [];
                YearlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence1,
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 4, 16, 12, 30, 55), new Date(2020, 4, 16, 12, 30, 55), new Date(2022, 4, 16, 12, 30, 55), new Date(2024, 4, 16, 12, 30, 55)], 'proper dates iterated');
              });
              t.it('Start/End dates', function (t) {
                var dates = [];
                YearlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence2,
                  startDate: new Date(2018, 6, 16, 13, 30, 55),
                  endDate: new Date(2020, 4, 16, 12, 30, 55),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2020, 4, 16, 12, 30, 55)], 'proper dates iterated');
              });
              t.it('Start/End dates 2', function (t) {
                var dates = [];
                YearlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence2,
                  startDate: new Date(2019, 6, 16, 12, 30, 55),
                  endDate: new Date(2020, 4, 16, 12, 30, 55),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2020, 4, 16, 12, 30, 55)], 'proper dates iterated');
              });
              t.it('Months + Count', function (t) {
                var dates = [];
                YearlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence3,
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 7, 16, 13, 30, 55), new Date(2020, 1, 16, 13, 30, 55), new Date(2020, 7, 16, 13, 30, 55), new Date(2022, 1, 16, 13, 30, 55)], 'proper dates iterated');
              });
              t.it('Months + Start/End dates', function (t) {
                var dates = [];
                YearlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence4,
                  startDate: new Date(2018, 7, 16, 13, 30, 56),
                  endDate: new Date(2022, 1, 16, 13, 30, 54),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 11, 16, 13, 30, 55), new Date(2020, 0, 16, 13, 30, 55), new Date(2020, 11, 16, 13, 30, 55), new Date(2022, 0, 16, 13, 30, 55)], 'proper dates iterated');
              });
              t.it('Days + Count + Position (first and last working days of year)', function (t) {
                var dates = [];
                YearlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence5,
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 11, 31, 14, 30, 55), new Date(2020, 0, 1, 14, 30, 55), new Date(2020, 11, 31, 14, 30, 55), new Date(2022, 0, 3, 14, 30, 55)], 'proper dates iterated');
              });
              t.it('Days + Start/End + Position (first and last weekends of month)', function (t) {
                var dates = [];
                YearlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence6,
                  startDate: new Date(2018, 0, 8, 14, 30, 55),
                  endDate: new Date(2020, 11, 27, 14, 30, 55),
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 11, 30, 14, 30, 55), new Date(2020, 0, 4, 14, 30, 55), new Date(2020, 11, 27, 14, 30, 55)], 'proper dates iterated');
              });
              t.it('Numbered Days + Count (last Sun, first Sat, 5th Mon)', function (t) {
                var dates = [];
                YearlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence7,
                  fn: function fn(date) {
                    return dates.push(date);
                  }
                });
                t.isDeeply(dates, [new Date(2018, 11, 30, 15, 30, 55), new Date(2020, 0, 4, 15, 30, 55), new Date(2020, 1, 3, 15, 30, 55), new Date(2020, 11, 27, 15, 30, 55)], 'proper dates iterated');
              });
              t.it('Continue of "Numbered Days + Count (last Sun, first Sat, 5th Mon)"', function (t) {
                var dates = [],
                    indexes = [];
                YearlyRecurrenceIterator.forEachDate({
                  startOnly: true,
                  recurrence: recurrence7,
                  startDate: new Date(2020, 1, 3, 15, 30, 56),
                  fn: function fn(date, index) {
                    dates.push(date);
                    indexes.push(index);
                  }
                });
                t.isDeeply(dates, [new Date(2020, 11, 27, 15, 30, 55)], 'proper dates iterated');
                t.isDeeply(indexes, [4], 'proper indexes iterated');
              });

            case 14:
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
});