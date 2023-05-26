function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    Scheduler.destroy(scheduler);
  }); // https://github.com/bryntum/support/issues/2329

  t.it('CrudManager should reload data fast', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var total, resources, events, i, response, spy;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              total = 100, resources = [], events = [];

              for (i = 1; i <= total; i++) {
                resources.push({
                  id: i,
                  name: "Resource ".concat(i)
                });
                events.push({
                  id: i,
                  resourceId: i,
                  name: "Event ".concat(i),
                  startDate: '2021-02-02',
                  endDate: '2021-02-05'
                });
              }

              response = {
                success: true,
                resources: {
                  rows: resources
                },
                events: {
                  rows: events
                }
              };
              scheduler = new Scheduler({
                appendTo: document.body,
                width: 500,
                height: 300,
                startDate: new Date(2021, 0, 31),
                endDate: new Date(2021, 1, 7),
                enableEventAnimations: false,
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 150
                }],
                crudManager: {
                  autoLoad: false,
                  autoSync: false
                }
              });
              spy = t.spyOn(scheduler.assignmentStore.storage, 'rebuildIndices').and.callThrough();
              console.time('Loading time');
              scheduler.crudManager.loadCrudManagerData(response);
              console.timeEnd('Loading time');
              t.expect(spy).toHaveBeenCalled('<4');
              spy.reset();
              console.time('Reloading time');
              scheduler.crudManager.loadCrudManagerData(response);
              console.timeEnd('Reloading time');
              t.expect(spy).toHaveBeenCalled('<4');

            case 14:
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