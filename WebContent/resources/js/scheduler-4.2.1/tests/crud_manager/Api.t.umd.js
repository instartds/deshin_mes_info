function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    Scheduler.destroy(scheduler);
  });
  t.it('Should revert / accept all changes when revertChanges / acceptChanges is called', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var cm;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  assignments: {
                    rows: [{
                      resourceId: 1,
                      eventId: 1
                    }]
                  },
                  events: {
                    rows: [{
                      id: 1,
                      name: 'Task'
                    }]
                  },
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'Man'
                    }]
                  }
                })
              });
              scheduler = t.getScheduler({
                crudManager: {
                  transport: {
                    load: {
                      url: 'load'
                    },
                    sync: {
                      url: 'sync'
                    }
                  },
                  autoLoad: false,
                  autoSync: false
                }
              });
              cm = scheduler.crudManager;
              _context.next = 5;
              return cm.load();

            case 5:
              cm.resourceStore.add({});
              cm.eventStore.add({});
              cm.assignmentStore.add({});
              t.ok(cm.hasChanges(), 'Changes found');
              cm.revertChanges();
              t.notOk(cm.hasChanges(), 'No changes found');
              cm.resourceStore.first.name = 'foo';
              cm.eventStore.first.name = 'foo';
              cm.assignmentStore.first.eventId = null;
              t.ok(cm.hasChanges(), 'Changes found');
              cm.acceptChanges();
              t.notOk(cm.hasChanges(), 'No changes found');

            case 17:
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