function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

// Ported from 061_dragdrop_filtered_timeaxis.t.js
StartTest(function (t) {
  var scheduler, tickSize;

  function setup(config) {
    config = config || {};
    scheduler && scheduler.destroy();
    scheduler = t.getScheduler(Object.assign({
      viewPreset: 'dayAndWeek',
      startDate: new Date(2010, 0, 6),
      endDate: new Date(2010, 2, 1),
      features: {
        tree: Boolean(config.__tree)
      },
      columns: [{
        type: config.__tree ? 'tree' : null,
        text: 'Name',
        width: 200,
        field: 'name'
      }],
      events: [{
        id: 1,
        name: 'Test event',
        resourceId: 'r1',
        startDate: new Date(2010, 0, 11),
        endDate: new Date(2010, 0, 14)
      }],
      resourceStore: config.__tree ? t.getResourceTreeStore() : t.getResourceStore(),
      appendTo: document.body
    }, config));
    scheduler.timeAxis.filterBy(function (tick) {
      return tick.startDate.getDay() !== 6 && tick.startDate.getDay() !== 0;
    });
    tickSize = scheduler.timeAxisViewModel.tickSize;
  }

  function getTestSteps(t) {
    return [{
      drag: '.b-sch-event',
      by: [-tickSize, 0]
    }, function () {
      var event = scheduler.eventStore.first;
      t.is(event.startDate, new Date(2010, 0, 8), 'Event\'s start date has been changed according to the proxy element\'s position');
    }];
  }

  t.it('Plain horizontal scheduler', function (t) {
    setup();
    t.chain(getTestSteps(t));
  });
  t.it('Tree scheduler', function (t) {
    setup({
      __tree: true
    });
    t.chain(getTestSteps(t));
  }); // https://github.com/bryntum/support/issues/1635

  t.it('Should not crash when dragging outside scheduler with filtered timeaxis', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = t.getScheduler({
                style: 'margin-left:200px',
                startDate: new Date(2020, 2, 24),
                endDate: new Date(2020, 2, 25),
                width: 500,
                tickSize: 20,
                resources: [{
                  id: 'r1',
                  name: 'Buldozer'
                }],
                events: [{
                  id: 'e1',
                  name: 'Buldoze 1',
                  startDate: new Date(2020, 2, 24, 17),
                  duration: 3,
                  durationUnit: 'h'
                }],
                assignments: [{
                  id: 'a1',
                  resource: 'r1',
                  event: 'e1'
                }],
                viewPreset: 'hourAndDay'
              });
              scheduler.timeAxis.filter(function (t) {
                return t.startDate.getHours() > 8 && t.startDate.getHours() < 18;
              });
              _context.next = 4;
              return t.waitForSelector('.b-sch-event');

            case 4:
              t.setCursorPosition(t.rect('.b-sch-event').left, t.rect('.b-sch-event').top);
              t.simulator.setSpeed('speedRun');
              _context.next = 8;
              return t.dragTo('.b-sch-event', '.b-scheduler', null, null, null, true, null, ['100%+100', 50]);

            case 8:
              _context.next = 10;
              return t.moveCursorTo([0, 0], function () {
                t.mouseUp(null);
              });

            case 10:
              t.simulator.setSpeed('turboMode');

            case 11:
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