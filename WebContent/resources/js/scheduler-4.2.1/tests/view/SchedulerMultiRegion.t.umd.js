function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;

  function getScheduler() {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
      var config,
          _args3 = arguments;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              config = _args3.length > 0 && _args3[0] !== undefined ? _args3[0] : {};
              scheduler && scheduler.destroy();
              scheduler = new Scheduler(Object.assign({
                appendTo: document.body,
                subGridConfigs: {
                  left: {
                    width: 160
                  },
                  right: {
                    width: 240
                  }
                },
                startDate: new Date(2019, 1, 17),
                endDate: new Date(2019, 1, 24),
                resources: [{
                  id: 'r1',
                  name: 'Resource 1',
                  value: 100
                }],
                events: [{
                  id: 'e1',
                  resourceId: 'r1',
                  startDate: new Date(2019, 1, 17),
                  duration: 1
                }],
                columns: [{
                  field: 'name',
                  text: 'Name',
                  width: 160,
                  region: 'left'
                }, {
                  field: 'value',
                  text: 'Value',
                  width: 240,
                  region: 'right'
                }]
              }, config));
              _context3.next = 5;
              return t.waitForProjectReady();

            case 5:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));
    return _getScheduler.apply(this, arguments);
  }

  t.it('Sanity', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return getScheduler();

            case 2:
              t.chain( // Scheduler resizes with delay
              {
                waitFor: function waitFor() {
                  return scheduler.foregroundCanvas.offsetWidth < 800;
                }
              }, function () {
                t.selectorCountIs('.b-sch-event', 1, 'Single event rendered');
                t.is(document.querySelector('.b-sch-event').getBoundingClientRect().left, 165, 'Correct event left pos');
                t.is(document.querySelector('.b-sch-header-row-1').offsetWidth, 614, 'Correct header width');
                t.is(scheduler.foregroundCanvas.offsetWidth, 614, 'Correct foregroundCanvas width');
              });

            case 3:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1880

  t.it('Should support dragging right splitter', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return getScheduler();

            case 2:
              t.chain({
                drag: '.b-grid-splitter[data-region=normal]',
                by: [40, 0]
              }, function () {
                return t.is(scheduler.subGrids.right.element.offsetWidth, 200, 'Width updated');
              });

            case 3:
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