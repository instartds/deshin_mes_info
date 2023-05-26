function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler = bryntum.query('scheduler');
  t.it('sanity', function (t) {
    t.chain({
      waitForSelector: '.b-sch-range'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
      var _scheduler$features$t, _scheduler$features$t2, first, second, timeRanges;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.is(document.querySelectorAll('.b-sch-range').length, 4, 'Recurring time ranges are rendered (span)');
              t.is(document.querySelectorAll('.b-sch-line').length, 3, 'Recurring time ranges are rendered (line)');
              _scheduler$features$t = scheduler.features.timeRanges.store.getRange(), _scheduler$features$t2 = _slicedToArray(_scheduler$features$t, 2), first = _scheduler$features$t2[0], second = _scheduler$features$t2[1], timeRanges = scheduler.timeRanges;
              t.ok(timeRanges.includes(first), 'Line occurrence is among time ranges');
              t.ok(timeRanges.includes(second), 'Range occurrence is among time ranges');
              t.is(first.occurrences.length, 2, '2 occurrences of line');
              t.is(second.occurrences.length, 3, '3 occurrences of range');
              t.ok(first.occurrences.every(function (o) {
                return timeRanges.includes(o);
              }), 'All lines are in time ranges');
              t.ok(second.occurrences.every(function (o) {
                return timeRanges.includes(o);
              }), 'All ranges are in time ranges');

            case 9:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    })));
  });
});