function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
    scheduler = null;
  });

  function setup(_x) {
    return _setup.apply(this, arguments);
  }

  function _setup() {
    _setup = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var config,
          _args3 = arguments;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              config = _args3.length > 1 && _args3[1] !== undefined ? _args3[1] : {};
              scheduler && scheduler.destroy();
              scheduler = t.getScheduler(Object.assign({
                startDate: new Date(2018, 8, 20),
                endDate: new Date(2018, 9, 30),
                viewPreset: 'weekAndMonth',
                resources: [{
                  id: 1
                }, {
                  id: 2
                }],
                events: [{
                  id: 1,
                  resourceId: 1,
                  startDate: new Date(2018, 8, 17),
                  duration: 2,
                  name: 'task 1'
                }, {
                  id: 2,
                  resourceId: 1,
                  startDate: new Date(2018, 8, 24),
                  duration: 2,
                  name: 'task 2'
                }],
                dependencies: [{
                  id: 1,
                  from: 1,
                  to: 2,
                  type: 2
                }],
                features: {
                  dependencies: {
                    showTooltip: false
                  },
                  eventTooltip: false,
                  dependencyEdit: true
                }
              }, config));
              _context3.next = 5;
              return t.waitForProjectReady(scheduler);

            case 5:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));
    return _setup.apply(this, arguments);
  }

  function getSVGRect() {
    return t.query('.b-sch-foreground-canvas svg')[0].getBoundingClientRect();
  }

  function getLastPoint(t, selector) {
    var points = t.query(selector)[0].points;
    return points.getItem(points.numberOfItems - 1);
  }

  function getTaskRect(t, selector) {
    return t.query(selector)[0].getBoundingClientRect();
  } // #8730 https://app.assembla.com/spaces/bryntum/tickets/8730


  t.it('Should redraw dependency on dependency type change via data API', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return setup(t);

            case 2:
              t.chain( // Waiting for dependencies to be drawn
              function (next) {
                if (t.query('.b-sch-dependency').length) {
                  next();
                } else {
                  scheduler.on({
                    once: true,
                    dependenciesDrawn: next
                  });
                }
              }, // Checking that dependency arrow is to the left of task 2
              function (next) {
                var svgRect = getSVGRect(),
                    lastPoint = getLastPoint(t, '.b-sch-foreground-canvas polyline[depId=1]'),
                    taskRect = getTaskRect(t, 'div[data-event-id=2]');
                t.isApprox(taskRect.left, svgRect.left + lastPoint.x, 0.5, 'Marker points to task 2 start');
                next();
              }, // Changing dependency type
              function (next) {
                var dependency = scheduler.dependencyStore.getById(1);
                dependency.type = DependencyBaseModel.Type.StartToEnd;
                scheduler.on({
                  once: true,
                  dependenciesDrawn: next
                });
              }, // Checking that dependency arrow is to the right of task 2
              function () {
                var svgRect = getSVGRect(),
                    lastPoint = getLastPoint(t, '.b-sch-foreground-canvas polyline[depId=1]'),
                    taskRect = getTaskRect(t, 'div[data-event-id=2]');
                t.isApprox(svgRect.left + lastPoint.x, taskRect.right, 0.5, 'Marker points to task 2 end');
              });

            case 3:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x2) {
      return _ref.apply(this, arguments);
    };
  }()); // #8730 https://app.assembla.com/spaces/bryntum/tickets/8730

  t.it('Should redraw dependency on dependency type change via editor with just created task', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var dep;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              dep = null;
              _context2.next = 3;
              return setup(t);

            case 3:
              t.chain( // Waiting for dependencies to be drawn
              {
                waitForDependencies: null
              }, {
                diag: 'Creating new event'
              }, // Creating new event
              {
                drag: '.b-grid-row[data-index=0] .b-sch-timeaxis-cell',
                offset: [250, '50%'],
                by: [100, 0]
              }, {
                waitForSelector: '.b-eventeditor'
              }, {
                type: '123[ENTER]'
              }, {
                waitForSelectorNotFound: '.b-eventeditor'
              }, {
                diag: 'Creating new dependency'
              }, // Creating new dependency
              {
                moveCursorTo: '.b-sch-event-wrap[data-event-id=2]'
              }, {
                mouseDown: '.b-sch-terminal-right'
              }, {
                moveCursorTo: '.b-sch-event-wrap .b-sch-dirty-new'
              }, {
                mouseUp: '.b-sch-event-wrap .b-sch-dirty-new .b-sch-terminal-left'
              }, // Waiting for dependencies to be drawn
              {
                waitFor: function waitFor() {
                  return document.querySelector("[depId=\"".concat(scheduler.dependencyStore.last.id, "\"]"));
                }
              }, // Checking that dependency arrow is to the left of task 2
              function (next) {
                dep = scheduler.dependencyStore.last;
                var svgRect = getSVGRect(),
                    lastPoint = getLastPoint(t, ".b-sch-foreground-canvas polyline[depId=".concat(dep.id, "]")),
                    taskRect = getTaskRect(t, '.b-sch-event-wrap:contains(123)');
                t.isApprox(taskRect.left, svgRect.left + lastPoint.x, 0.5, 'Marker points to task 2 start');
                scheduler.clearLog('dependenciesDrawn');
                next();
              }, {
                diag: 'Changing dependency type'
              }, // Changing dependency type
              {
                dblclick: dep
              }, {
                waitForSelector: '.b-popup .b-header-title:contains(Edit dependency)',
                desc: 'Popup shown'
              }, {
                click: '.b-icon-picker'
              }, {
                click: '.b-list-item:contains(Start to End)'
              }, {
                click: '.b-popup .b-button:contains(Save)'
              }, function () {
                return scheduler.await('dependenciesDrawn');
              }, // Checking that dependency arrow is to the right of task 2
              function () {
                var svgRect = getSVGRect(),
                    lastPoint = getLastPoint(t, ".b-sch-foreground-canvas polyline[depId=".concat(dep.id, "]")),
                    taskRect = getTaskRect(t, '.b-sch-event-wrap:contains(123)');
                t.isApprox(svgRect.left + lastPoint.x, taskRect.right, 0.5, 'Marker points to task 2 end');
              });

            case 4:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref2.apply(this, arguments);
    };
  }());
});