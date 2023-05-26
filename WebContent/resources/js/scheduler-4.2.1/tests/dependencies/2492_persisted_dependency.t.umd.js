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
  t.beforeEach(function () {
    var _scheduler;

    (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });
  t.it('Persisted dependency is removed from cache', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var _scheduler$dependency, _scheduler$dependency2, dependency, phantomId;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'Albert'
                    }]
                  },
                  events: {
                    rows: [{
                      id: 1,
                      resourceId: 1,
                      name: 'Event 1',
                      startDate: '2021-03-09',
                      endDate: '2021-03-10'
                    }, {
                      id: 2,
                      resourceId: 1,
                      name: 'Event 2',
                      startDate: '2021-03-09',
                      endDate: '2021-03-10'
                    }, {
                      id: 3,
                      resourceId: 1,
                      name: 'Event 2',
                      startDate: '2021-03-09',
                      endDate: '2021-03-10'
                    }]
                  },
                  dependencies: {
                    rows: [{
                      id: 1,
                      from: 1,
                      to: 2
                    }]
                  }
                })
              });
              scheduler = new Scheduler({
                appendTo: document.body,
                width: 600,
                height: 400,
                startDate: new Date(2021, 2, 8),
                endDate: new Date(2021, 2, 12),
                crudManager: {
                  autoLoad: true,
                  transport: {
                    load: {
                      url: 'load'
                    },
                    sync: {
                      url: 'sync'
                    }
                  }
                },
                features: {
                  dependencies: true
                }
              });
              _context.next = 4;
              return t.waitForSelector('.b-sch-dependency');

            case 4:
              _scheduler$dependency = scheduler.dependencyStore.add({
                from: 2,
                to: 3
              }), _scheduler$dependency2 = _slicedToArray(_scheduler$dependency, 1), dependency = _scheduler$dependency2[0];
              phantomId = dependency.id;
              _context.next = 8;
              return t.waitForSelector(".b-sch-dependency[depId=\"".concat(phantomId, "\"]"));

            case 8:
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true,
                  dependencies: {
                    rows: [{
                      $PhantomId: phantomId,
                      id: 100
                    }]
                  }
                })
              });
              _context.next = 11;
              return scheduler.crudManager.sync();

            case 11:
              _context.next = 13;
              return t.waitForSelector('.b-sch-dependency[depId="100"]');

            case 13:
              scheduler.dependencyStore.remove(dependency);
              _context.next = 16;
              return scheduler.await('dependenciesDrawn', false);

            case 16:
              t.selectorCountIs('.b-sch-dependency[depId="100"]', 0, 'No dependency line matching new dep real id');
              t.selectorCountIs(".b-sch-dependency[depId=\"".concat(phantomId, "\"]"), 0, 'No dependency line matching new dep phantom id');

            case 18:
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