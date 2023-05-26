function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.it('Should support rendering + dragging event in a webcomponent', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              t.chain({
                waitForSelector: 'bryntum-scheduler -> .b-sch-foreground-canvas'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        scheduler = bryntum.query('scheduler');
                        t.isInstanceOf(scheduler.element.querySelector('.b-sch-event'), HTMLElement, 'event rendered');
                        t.firesOnce(scheduler, 'eventclick');
                        t.firesOnce(scheduler.eventStore, 'update');

                      case 4:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })), {
                click: 'bryntum-scheduler -> .b-sch-event:contains(Click me)'
              }, {
                drag: 'bryntum-scheduler -> .b-sch-event',
                by: [100, 100]
              }, function () {
                var movedTask = scheduler.eventStore.changes.modified[0];
                t.is(movedTask.resource.name, 'Sergei', 'Resource updated');
                t.is(movedTask.startDate, new Date(2018, 3, 4), 'Start Date updated');
              });

            case 1:
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
  t.it('Should support typing', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              t.firesOnce(scheduler, 'eventdblclick');
              t.firesOnce(scheduler.eventStore, 'update');
              t.chain({
                doubleClick: 'bryntum-scheduler -> .b-sch-event:contains(Click me)'
              }, {
                type: 'foo[ENTER]',
                clearExisting: true
              }, {
                waitForSelector: 'bryntum-scheduler -> .b-sch-event:textEquals(foo)'
              });

            case 3:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x2) {
      return _ref3.apply(this, arguments);
    };
  }());
});