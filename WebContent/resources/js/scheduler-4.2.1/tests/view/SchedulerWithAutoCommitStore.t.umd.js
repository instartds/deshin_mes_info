function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });
  t.it('Scheduler configured with assignment store must show events assigned to a resource', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var delay;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              delay = 1000;
              t.mockUrl('events/read', {
                delay: delay,
                responseText: JSON.stringify({
                  success: true,
                  data: [{
                    id: 1,
                    startDate: '2020-04-20',
                    endDate: '2020-04-22',
                    resourceId: 1
                  }, {
                    id: 2,
                    startDate: '2020-04-21',
                    endDate: '2020-04-23',
                    resourceId: 2
                  }]
                })
              });
              t.mockUrl('events/update', {
                delay: delay,
                responseText: JSON.stringify({
                  success: true,
                  data: [{
                    id: 1
                  }, {
                    id: 2
                  }]
                })
              });
              t.mockUrl('resources/read', {
                delay: delay,
                responseText: JSON.stringify({
                  success: true,
                  data: [{
                    id: 1,
                    name: 'Albert'
                  }, {
                    id: 2,
                    name: 'Bruce'
                  }]
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                width: 600,
                height: 400,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 150
                }],
                startDate: '2020-04-20',
                endDate: '2020-04-25',
                project: {
                  // The test expects "commit" event triggered by eventStore after data loading
                  // it happens only if we disable silenceInitialCommit
                  silenceInitialCommit: false
                },
                eventStore: {
                  autoLoad: true,
                  autoCommit: true,
                  readUrl: 'events/read',
                  updateUrl: 'events/update'
                },
                resourceStore: {
                  autoLoad: true,
                  autoCommit: true,
                  readUrl: 'resources/read'
                }
              });
              _context.next = 7;
              return scheduler.eventStore.await('load');

            case 7:
              _context.next = 9;
              return t.waitForProjectReady(scheduler);

            case 9:
              _context.next = 11;
              return scheduler.eventStore.await('commit');

            case 11:
              t.selectorCountIs('.b-sch-committing', 0, 'Committing cls is cleaned up after initial load');
              t.mockUrl('events/update', {
                delay: delay,
                responseText: JSON.stringify({
                  success: true,
                  data: [{
                    id: 2
                  }]
                })
              });
              scheduler.eventStore.last.name = 'Foo';
              _context.next = 16;
              return Promise.all([scheduler.eventStore.await('commit'), t.waitForProjectReady(scheduler)]);

            case 16:
              t.selectorCountIs('.b-sch-committing', 0, 'Committing cls is cleaned up after updating event name');
              t.mockUrl('events/update', {
                delay: delay,
                responseText: JSON.stringify({
                  success: true,
                  data: [{
                    id: 1
                  }]
                })
              });
              scheduler.eventStore.first.duration = 4;
              _context.next = 21;
              return Promise.all([scheduler.eventStore.await('commit'), t.waitForProjectReady(scheduler)]);

            case 21:
              t.selectorCountIs('.b-sch-committing', 0, 'Committing cls is cleaned up after updating event duration');

            case 22:
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
});