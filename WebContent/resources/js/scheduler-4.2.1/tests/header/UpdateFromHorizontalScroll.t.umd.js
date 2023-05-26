function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr == null ? null : typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]; if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

StartTest(function (t) {
  //region Make sure there is no non-released nodes in the released map
  // Should be under StartTest to avoid "ReferenceError: Override is not defined" in UMD tests
  var DomSyncOverride = /*#__PURE__*/function () {
    function DomSyncOverride() {
      _classCallCheck(this, DomSyncOverride);
    }

    _createClass(DomSyncOverride, null, [{
      key: "target",
      get: function get() {
        return {
          class: DomSync,
          product: 'scheduler'
        };
      }
    }, {
      key: "syncChildrenCleanup",
      value: function syncChildrenCleanup(targetElement) {
        for (var _len = arguments.length, args = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
          args[_key - 1] = arguments[_key];
        }

        this._overridden.syncChildrenCleanup.apply(this, [targetElement].concat(args));

        var entries = Object.entries(targetElement.releasedIdMap);

        for (var _i = 0, _entries = entries; _i < _entries.length; _i++) {
          var _entries$_i = _slicedToArray(_entries[_i], 2),
              key = _entries$_i[0],
              targetNode = _entries$_i[1];

          if (!targetNode.isReleased) {
            console.log(targetNode);
            throw new Error("Node ".concat(key, " with tickIndex ").concat(targetNode.dataset.tickIndex));
          }
        }
      }
    }]);

    return DomSyncOverride;
  }();

  Override.apply(DomSyncOverride); //endregion

  var scheduler, scheduler2;
  t.beforeEach(function () {
    Base.destroy(scheduler, scheduler2);
  }); //https://github.com/bryntum/support/issues/2338

  t.it('Time axis should render header elements correct when change width and scroll with animation', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = t.getScheduler({
                appendTo: document.body,
                width: 1000,
                height: 300,
                startDate: new Date(2018, 0, 1, 6),
                endDate: new Date(2018, 0, 1, 20),
                viewPreset: 'minuteAndHour'
              });
              _context.next = 3;
              return t.waitForElementTop('.b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=0]');

            case 3:
              // Change width
              scheduler.width = 400; // Reproducible only when animation is enabled

              _context.next = 6;
              return scheduler.scrollHorizontallyTo(1000, true);

            case 6:
              _context.next = 8;
              return scheduler.scrollHorizontallyTo(0, true);

            case 8:
              _context.next = 10;
              return t.waitForElementTop('.b-sch-header-row-0 .b-sch-header-timeaxis-cell[data-tick-index=0] span:contains(Mon 01/01, 6AM)');

            case 10:
              _context.next = 12;
              return t.waitForElementTop('.b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=0] span:contains(00)');

            case 12:
              _context.next = 14;
              return t.waitForElementTop('.b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=1] span:contains(30)');

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
  }()); // https://github.com/bryntum/support/issues/2523

  t.it('Time axis should render header elements correct when grids are partnered', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler = t.getScheduler({
                cls: 'scheduler1',
                width: 1000,
                height: 300,
                startDate: new Date(2018, 0, 1, 6),
                endDate: new Date(2018, 0, 1, 20),
                viewPreset: 'minuteAndHour'
              });
              scheduler2 = new Scheduler({
                cls: 'scheduler2',
                width: 1000,
                height: 300,
                appendTo: document.body,
                columns: [{
                  text: 'Name',
                  sortable: true,
                  width: 100,
                  field: 'name',
                  locked: true
                }],
                partner: scheduler,
                resourceStore: scheduler.resourceStore,
                eventStore: scheduler.eventStore
              });
              _context2.next = 4;
              return t.waitForElementTop('.scheduler1 .b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=0]');

            case 4:
              _context2.next = 6;
              return t.waitForElementTop('.scheduler2 .b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=0]');

            case 6:
              _context2.next = 8;
              return scheduler.scrollHorizontallyTo(1000, true);

            case 8:
              _context2.next = 10;
              return t.waitForElementTop('.scheduler1 .b-sch-header-row-0 .b-sch-header-timeaxis-cell[data-tick-index=13] span:contains(Mon 01/01, 7PM)');

            case 10:
              _context2.next = 12;
              return t.waitForElementTop('.scheduler1 .b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=26] span:contains(00)');

            case 12:
              _context2.next = 14;
              return t.waitForElementTop('.scheduler1 .b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=27] span:contains(30)');

            case 14:
              _context2.next = 16;
              return t.waitForElementTop('.scheduler2 .b-sch-header-row-0 .b-sch-header-timeaxis-cell[data-tick-index=13] span:contains(Mon 01/01, 7PM)');

            case 16:
              _context2.next = 18;
              return t.waitForElementTop('.scheduler2 .b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=26] span:contains(00)');

            case 18:
              _context2.next = 20;
              return t.waitForElementTop('.scheduler2 .b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=27] span:contains(30)');

            case 20:
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
  t.it('Time axis should render header elements correct when grids are partnered dynamically', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              scheduler = t.getScheduler({
                cls: 'scheduler1',
                width: 1000,
                height: 300,
                startDate: new Date(2018, 0, 1, 6),
                endDate: new Date(2018, 0, 1, 20),
                viewPreset: 'minuteAndHour'
              });
              scheduler2 = new Scheduler({
                appendTo: document.body,
                cls: 'scheduler2',
                width: 1000,
                height: 300,
                startDate: new Date(2018, 0, 1, 6),
                endDate: new Date(2018, 0, 1, 20),
                viewPreset: 'minuteAndHour',
                columns: [{
                  text: 'Name',
                  sortable: true,
                  width: 100,
                  field: 'name',
                  locked: true
                }],
                resourceStore: scheduler.resourceStore,
                eventStore: scheduler.eventStore
              });
              scheduler2.partner = scheduler;
              _context3.next = 5;
              return t.waitForElementTop('.scheduler1 .b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=0]');

            case 5:
              _context3.next = 7;
              return t.waitForElementTop('.scheduler2 .b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=0]');

            case 7:
              _context3.next = 9;
              return scheduler.scrollHorizontallyTo(1000, true);

            case 9:
              _context3.next = 11;
              return t.waitForElementTop('.scheduler1 .b-sch-header-row-0 .b-sch-header-timeaxis-cell[data-tick-index=13] span:contains(Mon 01/01, 7PM)');

            case 11:
              _context3.next = 13;
              return t.waitForElementTop('.scheduler1 .b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=26] span:contains(00)');

            case 13:
              _context3.next = 15;
              return t.waitForElementTop('.scheduler1 .b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=27] span:contains(30)');

            case 15:
              _context3.next = 17;
              return t.waitForElementTop('.scheduler2 .b-sch-header-row-0 .b-sch-header-timeaxis-cell[data-tick-index=13] span:contains(Mon 01/01, 7PM)');

            case 17:
              _context3.next = 19;
              return t.waitForElementTop('.scheduler2 .b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=26] span:contains(00)');

            case 19:
              _context3.next = 21;
              return t.waitForElementTop('.scheduler2 .b-sch-header-row-1 .b-sch-header-timeaxis-cell[data-tick-index=27] span:contains(30)');

            case 21:
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