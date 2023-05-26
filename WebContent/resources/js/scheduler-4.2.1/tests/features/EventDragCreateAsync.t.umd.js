function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    return scheduler && scheduler.destroy();
  });
  t.it('Should not be possible to drag create if one is in progress', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var dragCreateContext;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getScheduler({
                events: []
              });

            case 2:
              scheduler = _context2.sent;
              scheduler.on({
                beforedragcreatefinalize: function beforedragcreatefinalize(_ref2) {
                  var context = _ref2.context;
                  context.async = true;
                  dragCreateContext = context;
                },
                once: true
              });
              t.firesOk({
                observable: scheduler,
                events: {
                  beforedragcreate: 3,
                  dragcreatestart: 3,
                  dragcreateend: 3,
                  afterdragcreate: 3,
                  beforedragcreatefinalize: 3
                }
              });
              t.chain( // Kick off a drag create. It will be converted to async, and finalized later
              {
                drag: '.b-sch-timeaxis-cell',
                offset: [200, 50],
                by: [100, 0]
              }, // Attempt another drag create while one is in progress - this should not work
              {
                drag: '.b-sch-timeaxis-cell',
                offset: [200, 100],
                by: [100, 0]
              }, function (next) {
                t.is(scheduler.eventStore.count, 1, 'Second attempt to drag create failed'); // Finish that first dragcreate

                dragCreateContext.finalize(true);
                t.is(scheduler.eventStore.count, 1, 'Only 1 event created');
                next();
              }, function (next) {
                scheduler.on({
                  beforedragcreatefinalize: function beforedragcreatefinalize(_ref3) {
                    var context = _ref3.context;
                    context.async = true;
                    dragCreateContext = context;
                  },
                  once: true
                });
                next();
              }, // This one will also delay completing and creating the second event
              {
                drag: '.b-sch-timeaxis-cell',
                offset: [200, 100],
                by: [100, 0]
              }, // These should not create a third event.
              {
                click: '.b-sch-timeaxis-cell',
                offset: [200, 150]
              }, {
                drag: '.b-sch-timeaxis-cell',
                offset: [200, 150],
                by: [100, 0]
              },
              /*#__PURE__*/
              // Finish the second delayed dragcreate
              _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        dragCreateContext.finalize(true);
                        _context.next = 3;
                        return t.waitForProjectReady();

                      case 3:
                        t.is(scheduler.eventStore.count, 2, '2nd event created');

                      case 4:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })), {
                drag: '.b-sch-timeaxis-cell',
                offset: [200, 250],
                by: [100, 0]
              }, function () {
                t.is(scheduler.eventStore.count, 3, '3rd event created');
              });

            case 6:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
});