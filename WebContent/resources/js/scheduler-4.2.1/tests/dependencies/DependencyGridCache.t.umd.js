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
  t.beforeEach(function (t) {
    var _scheduler, _scheduler$destroy;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : (_scheduler$destroy = _scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(_scheduler);
  });

  function createScheduler() {
    return _createScheduler.apply(this, arguments);
  }

  function _createScheduler() {
    _createScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      var config,
          _args2 = arguments;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              config = _args2.length > 0 && _args2[0] !== undefined ? _args2[0] : {};
              _context2.next = 3;
              return t.getSchedulerAsync(Object.assign({
                features: {
                  dependencies: true
                },
                startDate: new Date(2020, 7, 1),
                endDate: new Date(2020, 9, 1),
                tickSize: 50,
                events: [{
                  id: 1,
                  startDate: '2020-08-02',
                  duration: 2,
                  resourceId: 1,
                  name: '1 - T0L0'
                }, {
                  id: 2,
                  startDate: '2020-08-03',
                  duration: 4,
                  resourceId: 2,
                  name: '2 - T0L0'
                }, {
                  id: 3,
                  startDate: '2020-08-07',
                  duration: 3,
                  resourceId: 1,
                  name: '3 - T0L0'
                }, {
                  id: 4,
                  startDate: '2020-08-02',
                  duration: 2,
                  resourceId: 26,
                  name: '4 - T1L0'
                }, {
                  id: 5,
                  startDate: '2020-08-26',
                  duration: 2,
                  resourceId: 1,
                  name: '5 - T0L1'
                }, {
                  id: 6,
                  startDate: '2020-09-21',
                  duration: 2,
                  resourceId: 1,
                  name: '6 - T0L2'
                }, {
                  id: 7,
                  startDate: '2020-08-02',
                  duration: 2,
                  resourceId: 51,
                  name: '7 - T2L0'
                }, {
                  id: 8,
                  startDate: '2020-08-26',
                  duration: 2,
                  resourceId: 26,
                  name: '8 - T1L1'
                }, {
                  id: 9,
                  startDate: '2020-09-21',
                  duration: 2,
                  resourceId: 51,
                  name: '9 - T2L2'
                }],
                dependencies: [// T0L0 - T0L0
                {
                  id: 1,
                  fromEvent: 1,
                  toEvent: 2
                }, {
                  id: 2,
                  fromEvent: 2,
                  toEvent: 3
                }, // T0L0 - T1L0
                {
                  id: 3,
                  fromEvent: 1,
                  toEvent: 4
                }, // T0L0 - T0L1
                {
                  id: 4,
                  fromEvent: 1,
                  toEvent: 5
                }, // T0L0 - T0L1 - T0L2
                {
                  id: 5,
                  fromEvent: 1,
                  toEvent: 6
                }, // T0L0 - T1L0 - T2L0
                {
                  id: 6,
                  fromEvent: 1,
                  toEvent: 7
                }, // T0L0 - T0L1 - T1L0 - T1L1
                {
                  id: 7,
                  fromEvent: 1,
                  toEvent: 8
                }, // T0L0 - T1L0 - T0L1 - T1L1 - T1L2 - T2L0 - T2L1 - T2L2
                {
                  id: 8,
                  fromEvent: 1,
                  toEvent: 9
                }, // T0L1 - T0L2
                {
                  id: 9,
                  fromEvent: 5,
                  toEvent: 6
                }],
                resources: ArrayHelper.populate(100, function (i) {
                  return {
                    id: i + 1,
                    name: "Resource ".concat(i + 1)
                  };
                })
              }, config));

            case 3:
              scheduler = _context2.sent;
              _context2.next = 6;
              return t.waitForDependencies();

            case 6:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));
    return _createScheduler.apply(this, arguments);
  }

  function assertCache(t, top, left) {
    var cache = scheduler.features.dependencies.dependencyGridCache,
        depsInCache = cache[left][top].map(function (entry) {
      return entry.dependency;
    });

    for (var _len = arguments.length, deps = new Array(_len > 3 ? _len - 3 : 0), _key = 3; _key < _len; _key++) {
      deps[_key - 3] = arguments[_key];
    }

    t.isDeeplyUnordered(depsInCache, deps, "T".concat(top, "L").concat(left));
  }

  t.it('Verify initial scenario', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var _scheduler$dependency, dep1, dep2, dep3, dep4, dep5, dep6, dep7, dep8, dep9;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return createScheduler();

            case 2:
              _scheduler$dependency = _slicedToArray(scheduler.dependencyStore, 9), dep1 = _scheduler$dependency[0], dep2 = _scheduler$dependency[1], dep3 = _scheduler$dependency[2], dep4 = _scheduler$dependency[3], dep5 = _scheduler$dependency[4], dep6 = _scheduler$dependency[5], dep7 = _scheduler$dependency[6], dep8 = _scheduler$dependency[7], dep9 = _scheduler$dependency[8]; // T0L0

              assertCache(t, 0, 0, dep1, dep2, dep3, dep4, dep5, dep6, dep7, dep8); // T1L0

              assertCache(t, 1, 0, dep3, dep6, dep7, dep8); // T2L0

              assertCache(t, 2, 0, dep6, dep8); // T0L1

              assertCache(t, 0, 1, dep4, dep5, dep7, dep8, dep9); // T0L2

              assertCache(t, 0, 2, dep5, dep8, dep9); // T1L1

              assertCache(t, 1, 1, dep7, dep8); // T1L2

              assertCache(t, 1, 2, dep8); // T2L1

              assertCache(t, 2, 1, dep8); // T2L2

              assertCache(t, 2, 2, dep8);

            case 12:
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