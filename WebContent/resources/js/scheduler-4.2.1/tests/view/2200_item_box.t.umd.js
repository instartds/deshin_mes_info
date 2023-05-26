function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    return scheduler && scheduler.destroy();
  }); // --------------------------------------------------

  function checkBoxes(scheduler, t) {
    var _scheduler$eventStore = _slicedToArray(scheduler.eventStore, 2),
        event1 = _scheduler$eventStore[0],
        event2 = _scheduler$eventStore[1],
        _scheduler$getItemBox = scheduler.getItemBox(event1),
        _scheduler$getItemBox2 = _slicedToArray(_scheduler$getItemBox, 1),
        eventBox1 = _scheduler$getItemBox2[0],
        _scheduler$getItemBox3 = scheduler.getItemBox(event2),
        _scheduler$getItemBox4 = _slicedToArray(_scheduler$getItemBox3, 1),
        eventBox2 = _scheduler$getItemBox4[0];

    t.isGreater(eventBox1.height, 0, 'EventBox1 height should be greater then 0');
    t.isGreater(eventBox1.width, 0, 'EventBox1 width should be greater then 0');
    t.isGreater(eventBox2.height, 0, 'EventBox2 height should be greater then 0');
    t.isGreater(eventBox2.width, 0, 'EventBox2 width should be greater then 0');
    t.isLess(eventBox1.top, eventBox2.top, 'EventBox 1 should be reported being above EventBox 2');
  }

  function withSchedulerHidden(scheduler, exec) {
    scheduler.element.style.display = 'none';
    exec();
    scheduler.element.style.display = 'block';
  } // --------------------------------------------------


  t.it("Scheduler view should report meaningfull item box even if it's not displayed, i.e. it should calculate item" + 'position based on dates, row number an item is, row height etc', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({}, 2);

            case 2:
              scheduler = _context.sent;
              t.diag('Unhidden case');
              checkBoxes(scheduler, t);
              withSchedulerHidden(scheduler, function () {
                t.diag('Hidden case');
                checkBoxes(scheduler, t);
              });

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
});