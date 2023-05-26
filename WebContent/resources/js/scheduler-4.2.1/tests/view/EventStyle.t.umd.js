function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    var _scheduler, _scheduler$destroy;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : (_scheduler$destroy = _scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(_scheduler);
  });
  t.it('Should support setting eventColor to known value with eventStyle colored', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var barEl;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = t.getScheduler({
                startDate: new Date(2011, 0, 2),
                events: [{
                  id: 'e4-1',
                  startDate: '2011-01-03',
                  endDate: '2011-01-04',
                  eventColor: 'red',
                  eventStyle: 'colored',
                  resourceId: 'r1'
                }]
              });
              _context.next = 3;
              return t.waitForSelector('.b-sch-event');

            case 3:
              barEl = t.query('.b-sch-event')[0];
              t.is(window.getComputedStyle(barEl).backgroundColor, 'rgb(255, 231, 231)', 'Background');
              t.is(window.getComputedStyle(barEl).borderLeftColor, 'rgb(255, 96, 96)', 'Border left');

            case 6:
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
  !(BrowserHelper.isIE11 || BrowserHelper.isEdge) && t.it('Should support setting eventColor to hex value with eventStyle colored', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var barEl;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler = t.getScheduler({
                startDate: new Date(2011, 0, 2),
                events: [{
                  id: 'e4-1',
                  startDate: '2011-01-03',
                  endDate: '2011-01-04',
                  eventColor: '#333',
                  eventStyle: 'colored',
                  resourceId: 'r1'
                }]
              });
              _context2.next = 3;
              return t.waitForSelector('.b-sch-event');

            case 3:
              barEl = t.query('.b-sch-event')[0];
              t.is(window.getComputedStyle(barEl).backgroundColor, 'rgb(51, 51, 51)', 'Background');
              t.is(window.getComputedStyle(barEl).borderLeftColor, 'rgb(51, 51, 51)', 'Border left');

            case 6:
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
  t.it('Should support setting color using hex, hsl, rgb, rgba', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var events, hexEl, rgbaEl, rgbEl, hslEl;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              scheduler = t.getScheduler({
                startDate: new Date(2011, 0, 2),
                events: [{
                  id: 1,
                  startDate: '2011-01-03',
                  endDate: '2011-01-04',
                  eventColor: '#ff0000',
                  resourceId: 'r1'
                }, {
                  id: 2,
                  startDate: '2011-01-03',
                  endDate: '2011-01-04',
                  eventColor: 'rgba(255,0,0, 1)',
                  resourceId: 'r1'
                }, {
                  id: 3,
                  startDate: '2011-01-03',
                  endDate: '2011-01-04',
                  eventColor: 'rgb(255, 0, 0)',
                  resourceId: 'r1'
                }, {
                  id: 4,
                  startDate: '2011-01-03',
                  endDate: '2011-01-04',
                  eventColor: 'hsl(0, 100%, 50%)',
                  resourceId: 'r1'
                }]
              });
              _context3.next = 3;
              return t.waitForSelector('.b-sch-event');

            case 3:
              events = t.query('.b-sch-event'), hexEl = events[0], rgbaEl = events[1], rgbEl = events[2], hslEl = events[3];
              t.is(window.getComputedStyle(hexEl).backgroundColor, 'rgb(255, 0, 0)', 'Hex Background ok');
              t.is(window.getComputedStyle(rgbaEl).backgroundColor, 'rgb(255, 0, 0)', ' rgba Background ok');
              t.is(window.getComputedStyle(rgbEl).backgroundColor, 'rgb(255, 0, 0)', 'rgb Background ok');
              t.is(window.getComputedStyle(hslEl).backgroundColor, 'rgb(255, 0, 0)', 'hsl Background ok');

            case 8:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }());
});