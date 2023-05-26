function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;

  function createScheduler(_x) {
    return _createScheduler.apply(this, arguments);
  }

  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = new Scheduler({
                width: 400,
                height: 300,
                features: {
                  pan: true,
                  eventDragCreate: false
                },
                columns: [{
                  field: 'name',
                  width: 150
                }],
                resources: [{
                  id: 1,
                  name: 'Steve',
                  job: 'Carpenter'
                }, {
                  id: 2,
                  name: 'John',
                  job: 'Contractor'
                }, {}, {}, {}, {}],
                events: [{
                  id: 1,
                  name: 'Work',
                  resourceId: 1,
                  startDate: new Date(2017, 0, 1),
                  endDate: new Date(2017, 0, 5)
                }],
                startDate: new Date(2017, 0, 1),
                endDate: new Date(2017, 1, 16),
                appendTo: document.body
              });
              _context.next = 3;
              return t.waitForProjectReady(scheduler);

            case 3:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));
    return _createScheduler.apply(this, arguments);
  }

  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });
  t.it('Dragging event should not pan', function (t) {
    createScheduler(t);
    t.wontFire(scheduler.subGrids.normal.scrollable, 'scroll');
    t.chain({
      drag: '.b-sch-event',
      fromOffset: [50, 20],
      by: [-10, 0]
    });
  });
  t.it('Dragging on an event should pan if drag feature is not enabled', function (t) {
    createScheduler(t);
    t.firesAtLeastNTimes(scheduler.subGrids.normal.scrollable, 'scroll', 1);
    scheduler.features.eventDrag.disabled = true;
    t.chain({
      drag: '.b-sch-event',
      by: [-10, 0]
    });
  });
  t.it('Dragging on a cell should pan', function (t) {
    createScheduler(t);
    scheduler.events = [];
    t.firesAtLeastNTimes(scheduler.subGrids.normal.scrollable, 'scroll', 1);
    t.chain({
      drag: '.b-sch-timeaxis-cell',
      fromOffset: [50, 20],
      by: [-10, -10]
    }, function () {
      t.is(scheduler.subGrids.normal.scrollable.x, 10, 'scrolled horizontally to 10');
      t.is(scheduler.scrollable.y, 10, 'scrolled vertically to 10');
    });
  });
  t.it('Should support disabling', function (t) {
    createScheduler(t);
    scheduler.events = [];
    scheduler.features.pan.disabled = true;
    t.selectorNotExists('.b-pan', 'Feature CSS class removed');
    t.chain({
      drag: '.b-sch-timeaxis-cell',
      fromOffset: [50, 20],
      by: [-10, -10]
    }, function (next) {
      t.is(scheduler.subGrids.normal.scrollable.x, 0, 'Not scrolled horizontally');
      t.is(scheduler.scrollable.y, 0, 'Not scrolled vertically');
      scheduler.features.pan.disabled = false;
      next();
    }, {
      drag: '.b-sch-timeaxis-cell',
      fromOffset: [50, 20],
      by: [-10, -10]
    }, function () {
      t.is(scheduler.subGrids.normal.scrollable.x, 10, 'scrolled horizontally to 10');
      t.is(scheduler.scrollable.y, 10, 'scrolled vertically to 10');
    });
  });
  t.it('Should be able to coexist with other features using same mouse input', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      width: 400,
      height: 300,
      features: {
        pan: true,
        eventDragCreate: true,
        eventDragSelect: true
      }
    });
    t.pass('Scheduler created ok');
  });
  t.it('Should not add feature CSS class if it is disabled', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      features: {
        pan: {
          disabled: true
        },
        eventDragCreate: true,
        eventDragSelect: true
      }
    });
    t.hasNotCls(scheduler.element, 'b-pan', 'Feature CSS class removed');
    scheduler.features.pan.disabled = false;
    t.hasCls(scheduler.element, 'b-pan', 'Feature CSS class added');
  });
});