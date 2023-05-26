function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.it('Events outside of timeaxis should not trigger rows repainting', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var eventStore;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              eventStore = new EventStore();
              _context3.next = 3;
              return t.getSchedulerAsync({
                startDate: new Date(2010, 1, 1),
                endDate: new Date(2010, 2, 2),
                eventStore: eventStore,
                resourceStore: t.getResourceStore({
                  data: [{
                    id: 1
                  }]
                })
              });

            case 3:
              scheduler = _context3.sent;
              t.it('Should not render events outside the timeaxis', /*#__PURE__*/function () {
                var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
                  var _eventStore$add, _eventStore$add2, event;

                  return regeneratorRuntime.wrap(function _callee$(_context) {
                    while (1) {
                      switch (_context.prev = _context.next) {
                        case 0:
                          t.wontFire(scheduler, 'renderEvent', 'Rows should not be repainted when modifying event records outside the timeaxis');
                          _eventStore$add = eventStore.add({
                            startDate: new Date(1999, 1, 1, 10),
                            endDate: null,
                            //new Date(1999, 1, 1, 12),
                            resourceId: 1
                          }), _eventStore$add2 = _slicedToArray(_eventStore$add, 1), event = _eventStore$add2[0];
                          _context.next = 4;
                          return t.waitForProjectReady();

                        case 4:
                          // testing complex condition checking case when resource and dates are changed simultaneously
                          event.beginBatch();
                          event.endDate = new Date(1999, 1, 1, 13);
                          event.resourceId = 'r2';
                          event.endBatch();
                          _context.next = 10;
                          return t.waitForProjectReady();

                        case 10:
                          event.startDate = null;
                          _context.next = 13;
                          return t.waitForProjectReady();

                        case 13:
                          eventStore.remove(event);
                          _context.next = 16;
                          return t.waitForProjectReady();

                        case 16:
                        case "end":
                          return _context.stop();
                      }
                    }
                  }, _callee);
                }));

                return function (_x2) {
                  return _ref2.apply(this, arguments);
                };
              }());
              t.it('Moving event to/from time axis should repaint rows', /*#__PURE__*/function () {
                var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
                  var event;
                  return regeneratorRuntime.wrap(function _callee2$(_context2) {
                    while (1) {
                      switch (_context2.prev = _context2.next) {
                        case 0:
                          eventStore.data = [{
                            id: 1,
                            startDate: new Date(2010, 1, 1, 10),
                            endDate: new Date(2010, 1, 1, 12),
                            resourceId: 1
                          }];
                          _context2.next = 3;
                          return t.waitForProjectReady();

                        case 3:
                          t.selectorExists('.b-sch-event', 'Event is inside of timeaxis');
                          event = eventStore.getAt(0);
                          event.beginBatch();
                          event.startDate = new Date(2010, 0, 1);
                          event.endDate = new Date(2010, 0, 2);
                          event.endBatch();
                          _context2.next = 11;
                          return t.waitForProjectReady();

                        case 11:
                          t.selectorNotExists(scheduler.unreleasedEventSelector, 'Event is outside of timeaxis');
                          event.beginBatch();
                          event.startDate = new Date(2010, 1, 1, 10);
                          event.endDate = new Date(2010, 1, 1, 12);
                          event.endBatch();
                          _context2.next = 18;
                          return t.waitForProjectReady();

                        case 18:
                          t.selectorExists(scheduler.unreleasedEventSelector, 'Event is inside of timeaxis');

                        case 19:
                        case "end":
                          return _context2.stop();
                      }
                    }
                  }, _callee2);
                }));

                return function (_x3) {
                  return _ref3.apply(this, arguments);
                };
              }());

            case 6:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
});