function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var dependencyStore;
  t.beforeEach(function () {
    dependencyStore && dependencyStore.destroy();
    dependencyStore = null;
  });
  t.it('Should have no changes after initial load', function (t) {
    dependencyStore = new DependencyStore({
      data: [{
        id: 'd1',
        from: 'e1',
        to: 'e2'
      }, {
        id: 'd2',
        from: 'e2',
        to: 'e3'
      }]
    });
    t.notOk(dependencyStore.changes, 'No changes');
  });
  t.it('Should be possible to find dependency record based on `from` and `to` ids', function (t) {
    dependencyStore = new DependencyStore({
      data: [{
        id: 'd1',
        from: 'e1',
        to: 'e2'
      }, {
        id: 'd2',
        from: 'e2',
        to: 'e3'
      }]
    });
    var dependency = dependencyStore.getDependencyForSourceAndTargetEvents('e2', 'e3');
    t.is(dependency.id, 'd2', 'Correct dependency found');
  });
  t.it('Should have no changes with data supplied by the scheduler', function (t) {
    var scheduler = new Scheduler({
      dependencies: [{
        id: 'd1',
        from: 'e1',
        to: 'e2'
      }, {
        id: 'd2',
        from: 'e2',
        to: 'e3'
      }],
      resources: ArrayHelper.populate(10, function (i) {
        return {
          id: 'r' + (i + 1),
          name: 'Resource ' + (i + 1)
        };
      }),
      events: [{
        id: 'e1',
        startDate: new Date(2019, 2, 10),
        duration: 2,
        name: 'Single'
      }, {
        id: 'e2',
        startDate: new Date(2019, 2, 14),
        duration: 2,
        name: 'Multi A'
      }]
    });
    t.is(scheduler.dependencyStore.count, 2, 'Dependencies loaded');
    t.notOk(scheduler.dependencyStore.changes, 'No changes');
    scheduler.destroy();
  });
  t.it('Should have no changes with data supplied by Scheduler', function (t) {
    var scheduler = new Scheduler({
      features: {
        dependencies: true
      },
      resources: ArrayHelper.populate(10, function (i) {
        return {
          id: 'r' + (i + 1),
          name: 'Resource ' + (i + 1)
        };
      }),
      events: [{
        id: 'e1',
        startDate: new Date(2019, 2, 10),
        duration: 2,
        name: 'Single'
      }, {
        id: 'e2',
        startDate: new Date(2019, 2, 14),
        duration: 2,
        name: 'Multi A'
      }],
      dependencies: [{
        id: 'd1',
        from: 'e1',
        to: 'e2'
      }, {
        id: 'd2',
        from: 'e2',
        to: 'e3'
      }]
    });
    t.is(scheduler.dependencyStore.count, 2, 'Dependencies loaded');
    t.notOk(scheduler.dependencyStore.changes, 'No changes');
    scheduler.destroy();
  });
  t.it('Should be possible to pass event instance to from/to fields when create a new dependency', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var project, _project$eventStore, from, to, dependency;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              project = new ProjectModel({
                dependenciesData: [],
                eventsData: [{
                  id: 1,
                  startDate: '2020-05-08',
                  endDate: '2020-05-09'
                }, {
                  id: 2,
                  startDate: '2020-05-08',
                  endDate: '2020-05-09'
                }]
              });
              _context.next = 3;
              return t.waitForProjectReady();

            case 3:
              _project$eventStore = _slicedToArray(project.eventStore, 2), from = _project$eventStore[0], to = _project$eventStore[1];
              dependency = project.dependencyStore.add({
                from: from,
                to: to
              })[0];
              _context.next = 7;
              return t.waitForProjectReady();

            case 7:
              t.is(dependency.from, from, 'Dependency "from" is correct');
              t.is(dependency.to, to, 'Dependency "to" is correct');

            case 9:
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