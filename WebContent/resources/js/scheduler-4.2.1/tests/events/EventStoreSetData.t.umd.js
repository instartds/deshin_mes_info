function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var checkSync = /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t, data) {
      var resources, events, scheduler;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              resources = [{
                id: 'r1',
                name: 'Mike'
              }], events = [{
                id: 1,
                resourceId: 'r1',
                startDate: new Date(2017, 0, 1, 10),
                endDate: new Date(2017, 0, 1, 12),
                name: 'Click me',
                iconCls: 'b-fa b-fa-mouse-pointer'
              }];
              _context.next = 3;
              return t.getSchedulerAsync({
                resources: resources,
                eventStore: {
                  syncDataOnLoad: true
                },
                startDate: new Date(2017, 0, 1, 6),
                endDate: new Date(2017, 0, 1, 20),
                viewPreset: 'hourAndDay',
                columns: [{
                  text: 'Name',
                  field: 'name',
                  width: 130
                }]
              });

            case 3:
              scheduler = _context.sent;
              scheduler.eventStore.data = events;
              _context.next = 7;
              return t.waitForSelector('.b-sch-event');

            case 7:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function checkSync(_x, _x2) {
      return _ref.apply(this, arguments);
    };
  }(); // https://github.com/bryntum/support/issues/3099


  t.it('Should render event with empty array data', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return checkSync(t, []);

            case 2:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref2.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/3099

  t.it('Should render event with undefined data', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return checkSync(t);

            case 2:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x4) {
      return _ref3.apply(this, arguments);
    };
  }());
});