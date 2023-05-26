function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
    scheduler = null;
  }); // https://github.com/bryntum/bryntum-suite/issues/120

  t.it('Should not remove event on undoing - single assignment', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var eventStore, stm;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventTooltip: false,
                  eventEdit: true // is enabled by default already, but in case we change our minds...

                },
                events: [],
                enableEventAnimations: false
              });

            case 2:
              scheduler = _context.sent;
              eventStore = scheduler.eventStore, stm = scheduler.project.getStm();
              scheduler.eventStore.add({
                id: 1,
                name: 'test',
                startDate: new Date(2011, 0, 4),
                endDate: new Date(2011, 0, 5),
                resourceId: 'r1'
              });
              _context.next = 7;
              return t.waitForProjectReady(scheduler);

            case 7:
              stm.enable();
              stm.autoRecord = true;
              t.chain({
                doubleClick: '.b-sch-event'
              }, {
                doubleClick: 'input[name=name]'
              }, {
                type: 'foo',
                target: 'input[name=name]',
                clearExisting: true
              }, {
                click: 'button:contains(Save)'
              }, {
                waitFor: function waitFor() {
                  return stm.canUndo;
                }
              }, function () {
                var rec = eventStore.first;
                t.is(eventStore.count, 1, 'One record in the store');
                t.is(rec.name, 'foo', 'Name is updated');
                t.ok(rec.isAssignedTo('r1'), 'Assignment is correct');
                t.contentLike('[data-event-id="1"]', 'foo', 'Element is displayed, name is updated');
                t.ok(stm.canUndo, 'STM is prepared for undoing');
                stm.undo();
                t.is(eventStore.count, 1, 'One record in the store after reverting');
                t.is(rec.name, 'test', 'Name is reverted');
                t.ok(rec.isAssignedTo('r1'), 'Assignment is correct after reverting');
                t.contentLike('[data-event-id="1"]', 'test', 'Element is displayed, name is reverted');
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
  t.it('Should not remove event on undoing - multi assignment', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var stm;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventTooltip: false,
                  eventEdit: true // is enabled by default already, but in case we change our minds...

                },
                events: [],
                assignments: [{
                  id: 1,
                  resourceId: 'r1',
                  eventId: 1
                }, {
                  id: 2,
                  resourceId: 'r2',
                  eventId: 1
                }],
                enableEventAnimations: false
              });

            case 2:
              scheduler = _context2.sent;
              stm = scheduler.project.getStm();
              scheduler.eventStore.add({
                id: 1,
                name: 'test',
                startDate: new Date(2011, 0, 4),
                endDate: new Date(2011, 0, 5)
              });
              stm.enable();
              stm.autoRecord = true;
              t.chain({
                doubleClick: '.b-sch-event'
              }, {
                doubleClick: 'input[name=name]'
              }, {
                type: 'foo',
                target: 'input[name=name]',
                clearExisting: true
              }, {
                click: 'button:contains(Save)'
              }, {
                waitFor: function waitFor() {
                  return stm.canUndo;
                }
              }, function () {
                var store = scheduler.eventStore,
                    rec = store.first;
                t.is(store.count, 1, 'One record in the store');
                t.is(rec.name, 'foo', 'Name is updated');
                t.is(rec.assignments.length, 2, 'Event is assigned to resources');
                t.ok(rec.isAssignedTo('r1'), 'Assignment 1 is correct');
                t.ok(rec.isAssignedTo('r2'), 'Assignment 2 is correct');
                t.selectorCountIs('.b-sch-event:textEquals(foo)', 2, 'Element is displayed, name is updated');
                t.ok(stm.canUndo, 'STM is prepared for undoing');
                stm.undo();
                t.is(store.count, 1, 'One record in the store after reverting');
                t.is(rec.name, 'test', 'Name is reverted');
                t.is(rec.assignments.length, 2, 'Event is assigned to resources after reverting');
                t.ok(rec.isAssignedTo('r1'), 'Assignment 1 is correct after reverting');
                t.ok(rec.isAssignedTo('r2'), 'Assignment 2 is correct after reverting');
                t.selectorCountIs('.b-sch-event:contains(test)', 2, 'Element is displayed, name is reverted');
              });

            case 8:
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
});