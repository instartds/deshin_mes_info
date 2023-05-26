function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, startVerticalMargin,
  /*startArrowMargin, */
  horizontalMargin;
  t.beforeEach(function (t) {
    if (scheduler) {
      scheduler.destroy();
      scheduler = null;
    }
  });

  function getScheduler() {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15() {
      var config,
          _args15 = arguments;
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              config = _args15.length > 0 && _args15[0] !== undefined ? _args15[0] : {};
              _context15.next = 3;
              return t.getSchedulerAsync(Object.assign({
                startDate: '2011-01-03',
                endDate: '2011-01-09',
                features: {
                  dependencies: true
                },
                // should be divisible by 3
                tickSize: 180,
                rowHeight: 60,
                barMargin: 14,
                columns: []
              }, config));

            case 3:
              scheduler = _context15.sent;
              startVerticalMargin = scheduler.barMargin / 2;
              horizontalMargin = scheduler.features.dependencies.pathFinder.horizontalMargin;

            case 6:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));
    return _getScheduler.apply(this, arguments);
  }

  function getPointFromSide(side, box) {
    switch (side) {
      case 'top':
        return [box.x + box.width / 2, box.top];

      case 'right':
        return [box.right, box.top + box.height / 2];

      case 'bottom':
        return [box.x + box.width / 2, box.bottom];

      case 'left':
        return [box.left, box.top + box.height / 2];
    }
  }

  function convertPathToPoints(dependency, path) {
    var startSide = scheduler.features.dependencies.getDependencyStartSide(dependency),
        endSide = scheduler.features.dependencies.getDependencyEndSide(dependency),
        sourceBox = Rectangle.from(scheduler.getElementFromEventRecord(dependency.fromEvent, undefined, true), scheduler.foregroundCanvas),
        targetBox = Rectangle.from(scheduler.getElementFromEventRecord(dependency.toEvent, undefined, true), scheduler.foregroundCanvas),
        startPoint = getPointFromSide(startSide, sourceBox),
        endPoint = getPointFromSide(endSide, targetBox),
        points = [startPoint];
    path = path.slice();
    path.forEach(function (step, i) {
      var _points = _slicedToArray(points[points.length - 1], 2),
          x = _points[0],
          y = _points[1],
          direction,
          length; // If array passed, take some steps


      if (Array.isArray(step)) {
        var _step = _slicedToArray(step, 2);

        direction = _step[0];
        length = _step[1];

        switch (direction) {
          case 'l':
            x -= length;
            break;

          case 'r':
            x += length;
            break;

          case 'u':
            y -= length;
            break;

          case 'd':
            y += length;
            break;
        }
      } // otherwise just take coordinate from end point
      else {
          switch (step) {
            case 'l':
              x = endPoint[0];
              break;

            case 'r':
              x = endPoint[0];
              break;

            case 'u':
              y = endPoint[1];
              break;

            case 'd':
              y = endPoint[1];
              break;
          }
        }

      points.push([x, y]);
    });
    return points.map(function (point) {
      return point.join(',');
    }).join(' ');
  }
  /**
   * Idea is to generate array of points which should match dependency line points. Points are provided by the user.
   * e.g.: walkDependency(1, [
   *  ['r', 12],  // First segment should move right 12 px
   *  ['d', 100], // next one should move down 100px
   *  ['l', 300], // then left 300px, moving to the left of start point, no negative coordinates needed
   *  'u',        // short for *move up to the end point vertical coordinate*
   *  'r'         // short for *move right to the end point horizontal coordinate*
   * ])
   *
   * @param {*} t Test instance
   * @param {Scheduler.model.DependencyModel|String|Number} dependencyOrId Model or its id
   * @param {[direction, length][]} path Dependency path. Two dimensional array, first value is direction: u,d,l,r
   * second value is length of the segment in pixels
   */


  function walkDependency(t, dependencyOrId, path) {
    var dependency = dependencyOrId.isModel ? dependencyOrId : scheduler.dependencyStore.getById(dependencyOrId),
        dependencyEl = scheduler.getElementForDependency(dependency),
        points = dependencyEl.getAttribute('points'),
        expected = convertPathToPoints(dependency, path);
    t.is(points, expected, "Dependency ".concat(dependency.id, " path is ok"));
  }

  t.it('in-row dependency lines are drawn correctly (from bottom)', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var endArrowMargin, assertDependencies;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              assertDependencies = function _assertDependencies() {
                var pxPerHour = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60);
                walkDependency(t, '1:1-1', [['d', startVerticalMargin], // first line down should be to half bar margin, to be between two vertical events
                ['l', 32 * pxPerHour + endArrowMargin], // next point is 32 hours prior to source start, add arrow margin too
                'u', 'r']);
                walkDependency(t, '1:1-2', [['d', startVerticalMargin], ['l', 20 * pxPerHour + endArrowMargin], 'u', 'r']);
                walkDependency(t, '1:1-3', [['d', startVerticalMargin], ['l', 12 * pxPerHour + endArrowMargin], 'd', 'r']);
                walkDependency(t, '1:1-4', [['d', startVerticalMargin], ['l', endArrowMargin], 'd', 'r']);
                walkDependency(t, '1:1-5', ['d', 'r']);
                walkDependency(t, '1:1-6', [['d', startVerticalMargin], ['r', 12 * pxPerHour + horizontalMargin], 'u', 'r']);
              };

              _context2.next = 3;
              return getScheduler({
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Event 1',
                  startDate: '2011-01-04',
                  duration: 1
                }, {
                  id: '1-1',
                  resourceId: 'r1',
                  name: 'Event 1-1',
                  startDate: '2011-01-03 04:00',
                  duration: 2
                }, {
                  id: '1-2',
                  resourceId: 'r1',
                  name: 'Event 1-2',
                  startDate: '2011-01-03 16:00',
                  duration: 2
                }, {
                  id: '1-3',
                  resourceId: 'r1',
                  name: 'Event 1-3',
                  startDate: '2011-01-04',
                  duration: 1
                }, {
                  id: '1-4',
                  resourceId: 'r1',
                  name: 'Event 1-4',
                  startDate: '2011-01-04 12:00',
                  duration: 2
                }, {
                  id: '1-5',
                  resourceId: 'r1',
                  name: 'Event 1-5',
                  startDate: '2011-01-04 20:00',
                  duration: 2
                }, {
                  id: '1-6',
                  resourceId: 'r1',
                  name: 'Event 1-6',
                  startDate: '2011-01-06',
                  duration: 2
                }],
                dependencies: [{
                  id: '1:1-1',
                  from: '1',
                  to: '1-1',
                  fromSide: 'bottom'
                }, {
                  id: '1:1-2',
                  from: '1',
                  to: '1-2',
                  fromSide: 'bottom'
                }, {
                  id: '1:1-3',
                  from: '1',
                  to: '1-3',
                  fromSide: 'bottom'
                }, {
                  id: '1:1-4',
                  from: '1',
                  to: '1-4',
                  fromSide: 'bottom'
                }, {
                  id: '1:1-5',
                  from: '1',
                  to: '1-5',
                  fromSide: 'bottom'
                }, {
                  id: '1:1-6',
                  from: '1',
                  to: '1-6',
                  fromSide: 'bottom'
                }]
              });

            case 3:
              endArrowMargin = scheduler.features.dependencies.pathFinder.endArrowMargin;
              t.chain({
                waitForSelector: '.b-sch-dependency'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        assertDependencies();
                        t.diag('Change row height');
                        scheduler.rowHeight -= 10;
                        _context.next = 5;
                        return scheduler.await('dependenciesdrawn');

                      case 5:
                        assertDependencies();
                        t.diag('Change bar margin');
                        startVerticalMargin = 4;
                        scheduler.barMargin = 8;
                        _context.next = 11;
                        return scheduler.await('dependenciesdrawn');

                      case 11:
                        assertDependencies();
                        t.diag('Make all deps bidirectional, start arrow margin should return back');
                        scheduler.dependencies.forEach(function (d) {
                          return d.bidirectional = true;
                        });
                        _context.next = 16;
                        return scheduler.await('dependenciesdrawn');

                      case 16:
                        startVerticalMargin = endArrowMargin;
                        scheduler.barMargin = 20;
                        _context.next = 20;
                        return scheduler.await('dependenciesdrawn');

                      case 20:
                        assertDependencies();

                      case 21:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })));

            case 5:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('in-row dependency lines are drawn correctly (from top)', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var endArrowMargin, assertDependencies;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              assertDependencies = function _assertDependencies2() {
                var pxPerHour = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60);
                walkDependency(t, '1:1-1', [['u', startVerticalMargin], ['l', 32 * pxPerHour + endArrowMargin], 'u', 'r']);
                walkDependency(t, '1:1-2', [['u', startVerticalMargin], ['l', 20 * pxPerHour + endArrowMargin], 'u', 'r']);
                walkDependency(t, '1:1-3', [['u', startVerticalMargin], ['l', 12 * pxPerHour + endArrowMargin], 'd', 'r']);
                walkDependency(t, '1:1-4', [['u', startVerticalMargin], ['l', 12 * pxPerHour + horizontalMargin], 'd', 'r']);
                walkDependency(t, '1:1-5', [['u', startVerticalMargin], ['l', 12 * pxPerHour + horizontalMargin], 'd', 'r']);
                walkDependency(t, '1:1-6', ['u', 'r']);
              };

              _context4.next = 3;
              return getScheduler({
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Event 1',
                  startDate: '2011-01-04',
                  duration: 1
                }, {
                  id: '1-1',
                  resourceId: 'r1',
                  name: 'Event 1-1',
                  startDate: '2011-01-03 04:00',
                  duration: 2
                }, {
                  id: '1-2',
                  resourceId: 'r1',
                  name: 'Event 1-2',
                  startDate: '2011-01-03 16:00',
                  duration: 2
                }, {
                  id: '1-3',
                  resourceId: 'r1',
                  name: 'Event 1-3',
                  startDate: '2011-01-04',
                  duration: 1
                }, {
                  id: '1-4',
                  resourceId: 'r1',
                  name: 'Event 1-4',
                  startDate: '2011-01-04 12:00',
                  duration: 2
                }, {
                  id: '1-5',
                  resourceId: 'r1',
                  name: 'Event 1-5',
                  startDate: '2011-01-04 20:00',
                  duration: 2
                }, {
                  id: '1-6',
                  resourceId: 'r1',
                  name: 'Event 1-6',
                  startDate: '2011-01-06',
                  duration: 2
                }],
                dependencies: [{
                  id: '1:1-1',
                  from: '1',
                  to: '1-1',
                  fromSide: 'top'
                }, {
                  id: '1:1-2',
                  from: '1',
                  to: '1-2',
                  fromSide: 'top'
                }, {
                  id: '1:1-3',
                  from: '1',
                  to: '1-3',
                  fromSide: 'top'
                }, {
                  id: '1:1-4',
                  from: '1',
                  to: '1-4',
                  fromSide: 'top'
                }, {
                  id: '1:1-5',
                  from: '1',
                  to: '1-5',
                  fromSide: 'top'
                }, {
                  id: '1:1-6',
                  from: '1',
                  to: '1-6',
                  fromSide: 'top'
                }]
              });

            case 3:
              endArrowMargin = scheduler.features.dependencies.pathFinder.endArrowMargin;
              t.chain({
                waitForSelector: '.b-sch-dependency'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        assertDependencies();
                        t.diag('Change row height');
                        scheduler.rowHeight -= 10;
                        _context3.next = 5;
                        return scheduler.await('dependenciesdrawn');

                      case 5:
                        assertDependencies();
                        t.diag('Change bar margin');
                        startVerticalMargin = 4;
                        scheduler.barMargin = 8;
                        _context3.next = 11;
                        return scheduler.await('dependenciesdrawn');

                      case 11:
                        assertDependencies();

                      case 12:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3);
              })));

            case 5:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x2) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('in-row dependency lines are drawn correctly (from left)', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var endArrowMargin, assertDependencies;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              assertDependencies = function _assertDependencies3() {
                var pxPerHour = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60);
                walkDependency(t, '1:1-1', [['l', 20 * pxPerHour + endArrowMargin], 'u', 'r']);
                walkDependency(t, '1:1-2', [['l', 8 * pxPerHour + endArrowMargin], 'u', 'r']);
                walkDependency(t, '1:1-3', [['l', endArrowMargin], 'd', 'r']);
                walkDependency(t, '1:1-4', [['l', endArrowMargin], 'd', 'r']);
                walkDependency(t, '1:1-5', [['l', endArrowMargin], 'd', 'r']);
                walkDependency(t, '1:1-6', [['l', endArrowMargin], 'u', 'r']);
              };

              _context6.next = 3;
              return getScheduler({
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Event 1',
                  startDate: '2011-01-04',
                  duration: 1
                }, {
                  id: '1-1',
                  resourceId: 'r1',
                  name: 'Event 1-1',
                  startDate: '2011-01-03 04:00',
                  duration: 2
                }, {
                  id: '1-2',
                  resourceId: 'r1',
                  name: 'Event 1-2',
                  startDate: '2011-01-03 16:00',
                  duration: 2
                }, {
                  id: '1-3',
                  resourceId: 'r1',
                  name: 'Event 1-3',
                  startDate: '2011-01-04',
                  duration: 1
                }, {
                  id: '1-4',
                  resourceId: 'r1',
                  name: 'Event 1-4',
                  startDate: '2011-01-04 12:00',
                  duration: 2
                }, {
                  id: '1-5',
                  resourceId: 'r1',
                  name: 'Event 1-5',
                  startDate: '2011-01-04 20:00',
                  duration: 2
                }, {
                  id: '1-6',
                  resourceId: 'r1',
                  name: 'Event 1-6',
                  startDate: '2011-01-06',
                  duration: 2
                }],
                dependencies: [{
                  id: '1:1-1',
                  from: '1',
                  to: '1-1',
                  fromSide: 'left'
                }, {
                  id: '1:1-2',
                  from: '1',
                  to: '1-2',
                  fromSide: 'left'
                }, {
                  id: '1:1-3',
                  from: '1',
                  to: '1-3',
                  fromSide: 'left'
                }, {
                  id: '1:1-4',
                  from: '1',
                  to: '1-4',
                  fromSide: 'left'
                }, {
                  id: '1:1-5',
                  from: '1',
                  to: '1-5',
                  fromSide: 'left'
                }, {
                  id: '1:1-6',
                  from: '1',
                  to: '1-6',
                  fromSide: 'left'
                }]
              });

            case 3:
              endArrowMargin = scheduler.features.dependencies.pathFinder.endArrowMargin;
              t.chain({
                waitForSelector: '.b-sch-dependency'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5() {
                return regeneratorRuntime.wrap(function _callee5$(_context5) {
                  while (1) {
                    switch (_context5.prev = _context5.next) {
                      case 0:
                        assertDependencies();
                        t.diag('Change row height');
                        scheduler.rowHeight -= 10;
                        _context5.next = 5;
                        return scheduler.await('dependenciesdrawn');

                      case 5:
                        assertDependencies();
                        t.diag('Change bar margin');
                        startVerticalMargin = 4;
                        scheduler.barMargin = 8;
                        _context5.next = 11;
                        return scheduler.await('dependenciesdrawn');

                      case 11:
                        assertDependencies();

                      case 12:
                      case "end":
                        return _context5.stop();
                    }
                  }
                }, _callee5);
              })));

            case 5:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x3) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('in-row dependency lines are drawn correctly (from right)', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var endArrowMargin, assertDependencies;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              assertDependencies = function _assertDependencies4() {
                var pxPerHour = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60),
                    eventHeight = document.querySelector(scheduler.unreleasedEventSelector).offsetHeight;
                walkDependency(t, '1:1-1', [['r', endArrowMargin], ['u', eventHeight / 2 + startVerticalMargin], ['l', 44 * pxPerHour + endArrowMargin * 2], 'u', 'r']);
                walkDependency(t, '1:1-2', [['r', endArrowMargin], ['u', eventHeight / 2 + startVerticalMargin], ['l', 32 * pxPerHour + endArrowMargin * 2], 'u', 'r']);
                walkDependency(t, '1:1-3', [['r', endArrowMargin], ['d', eventHeight / 2 + startVerticalMargin], ['l', 24 * pxPerHour + endArrowMargin * 2], 'd', 'r']);
                walkDependency(t, '1:1-4', [['r', endArrowMargin], ['d', eventHeight / 2 + startVerticalMargin], ['l', 12 * pxPerHour + endArrowMargin * 2], 'd', 'r']);
                walkDependency(t, '1:1-5', [['r', endArrowMargin], ['d', eventHeight / 2 + startVerticalMargin], ['l', 4 * pxPerHour + endArrowMargin * 2], 'd', 'r']);
                walkDependency(t, '1:1-6', [['r', endArrowMargin], 'u', 'r']);
              };

              _context8.next = 3;
              return getScheduler({
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Event 1',
                  startDate: '2011-01-04',
                  duration: 1
                }, {
                  id: '1-1',
                  resourceId: 'r1',
                  name: 'Event 1-1',
                  startDate: '2011-01-03 04:00',
                  duration: 2
                }, {
                  id: '1-2',
                  resourceId: 'r1',
                  name: 'Event 1-2',
                  startDate: '2011-01-03 16:00',
                  duration: 2
                }, {
                  id: '1-3',
                  resourceId: 'r1',
                  name: 'Event 1-3',
                  startDate: '2011-01-04',
                  duration: 1
                }, {
                  id: '1-4',
                  resourceId: 'r1',
                  name: 'Event 1-4',
                  startDate: '2011-01-04 12:00',
                  duration: 2
                }, {
                  id: '1-5',
                  resourceId: 'r1',
                  name: 'Event 1-5',
                  startDate: '2011-01-04 20:00',
                  duration: 2
                }, {
                  id: '1-6',
                  resourceId: 'r1',
                  name: 'Event 1-6',
                  startDate: '2011-01-06',
                  duration: 2
                }],
                dependencies: [{
                  id: '1:1-1',
                  from: '1',
                  to: '1-1',
                  fromSide: 'right'
                }, {
                  id: '1:1-2',
                  from: '1',
                  to: '1-2',
                  fromSide: 'right'
                }, {
                  id: '1:1-3',
                  from: '1',
                  to: '1-3',
                  fromSide: 'right'
                }, {
                  id: '1:1-4',
                  from: '1',
                  to: '1-4',
                  fromSide: 'right'
                }, {
                  id: '1:1-5',
                  from: '1',
                  to: '1-5',
                  fromSide: 'right'
                }, {
                  id: '1:1-6',
                  from: '1',
                  to: '1-6',
                  fromSide: 'right'
                }]
              });

            case 3:
              endArrowMargin = scheduler.features.dependencies.pathFinder.endArrowMargin;
              t.chain({
                waitForSelector: '.b-sch-dependency'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                return regeneratorRuntime.wrap(function _callee7$(_context7) {
                  while (1) {
                    switch (_context7.prev = _context7.next) {
                      case 0:
                        assertDependencies();
                        t.diag('Change row height');
                        scheduler.rowHeight -= 10;
                        _context7.next = 5;
                        return scheduler.await('dependenciesdrawn');

                      case 5:
                        assertDependencies();
                        t.diag('Change bar margin');
                        startVerticalMargin = 4;
                        scheduler.barMargin = 8;
                        _context7.next = 11;
                        return scheduler.await('dependenciesdrawn');

                      case 11:
                        assertDependencies();

                      case 12:
                      case "end":
                        return _context7.stop();
                    }
                  }
                }, _callee7);
              })));

            case 5:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x4) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('out-row dependency lines are drawn correctly (from right)', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return getScheduler({
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Event 1',
                  startDate: '2011-01-04',
                  duration: 2
                }, {
                  id: '1-1',
                  resourceId: 'r1',
                  name: 'Event 1-1',
                  startDate: '2011-01-04 04:00',
                  duration: 0.5
                }, {
                  id: '1-2',
                  resourceId: 'r1',
                  name: 'Event 1-2',
                  startDate: '2011-01-05',
                  duration: 2
                }, {
                  id: '2-1',
                  resourceId: 'r2',
                  name: 'Event 2-1',
                  startDate: '2011-01-04 04:00',
                  duration: 0.5
                }, {
                  id: '2-2',
                  resourceId: 'r2',
                  name: 'Event 2-2',
                  startDate: '2011-01-05',
                  duration: 2
                }],
                dependencies: [{
                  id: '1:1-1',
                  from: 1,
                  to: '1-1',
                  type: 0
                }, {
                  id: '1:1-2',
                  from: 1,
                  to: '1-2'
                }, {
                  id: '1:2-1',
                  from: 1,
                  to: '2-1',
                  type: 0
                }, {
                  id: '1:2-2',
                  from: 1,
                  to: '2-2'
                }]
              });

            case 2:
              t.chain({
                waitForSelector: '.b-sch-dependency'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9() {
                var endArrowMargin, pxPerHour, eventHeight;
                return regeneratorRuntime.wrap(function _callee9$(_context9) {
                  while (1) {
                    switch (_context9.prev = _context9.next) {
                      case 0:
                        endArrowMargin = scheduler.features.dependencies.pathFinder.endArrowMargin, pxPerHour = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60), eventHeight = document.querySelector(scheduler.unreleasedEventSelector).offsetHeight;
                        walkDependency(t, '1:1-1', [['l', endArrowMargin], 'd', 'r']);
                        walkDependency(t, '1:1-2', [['r', endArrowMargin], ['d', startVerticalMargin + eventHeight / 2], ['l', 24 * pxPerHour + endArrowMargin * 2], 'd', 'r']);
                        walkDependency(t, '1:2-1', [['l', endArrowMargin], 'd', 'r']);
                        walkDependency(t, '1:2-2', [['r', endArrowMargin], // half event, full event, two bar margins, row border
                        ['d', startVerticalMargin * 4 + eventHeight * 1.5 + 1], ['l', 24 * pxPerHour + endArrowMargin * 2], 'd', 'r']);

                      case 5:
                      case "end":
                        return _context9.stop();
                    }
                  }
                }, _callee9);
              })));

            case 3:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x5) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('out-row dependency lines are drawn correctly (from top)', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return getScheduler({
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Event 1',
                  startDate: '2011-01-04',
                  duration: 2
                }, {
                  id: '1-1',
                  resourceId: 'r1',
                  name: 'Event 1-1',
                  startDate: '2011-01-04 04:00',
                  duration: 0.5
                }, {
                  id: '1-2',
                  resourceId: 'r1',
                  name: 'Event 1-2',
                  startDate: '2011-01-05',
                  duration: 2
                }, {
                  id: '2-1',
                  resourceId: 'r2',
                  name: 'Event 2-1',
                  startDate: '2011-01-04 04:00',
                  duration: 0.5
                }, {
                  id: '2-2',
                  resourceId: 'r2',
                  name: 'Event 2-2',
                  startDate: '2011-01-05',
                  duration: 2
                }],
                dependencies: [{
                  id: '1:1-1',
                  from: 1,
                  to: '1-1',
                  fromSide: 'top'
                }, {
                  id: '1:1-2',
                  from: 1,
                  to: '1-2',
                  fromSide: 'top',
                  toSide: 'right'
                }, {
                  id: '1:2-1',
                  from: 1,
                  to: '2-1',
                  fromSide: 'top'
                }, {
                  id: '1:2-2',
                  from: 1,
                  to: '2-2',
                  fromSide: 'top',
                  toSide: 'right'
                }]
              });

            case 2:
              t.chain({
                waitForSelector: '.b-sch-dependency'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11() {
                var endArrowMargin, pxPerHour;
                return regeneratorRuntime.wrap(function _callee11$(_context11) {
                  while (1) {
                    switch (_context11.prev = _context11.next) {
                      case 0:
                        endArrowMargin = scheduler.features.dependencies.pathFinder.endArrowMargin, pxPerHour = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60);
                        walkDependency(t, '1:1-1', [['u', startVerticalMargin], ['l', 24 * pxPerHour + horizontalMargin], 'd', 'r']);
                        walkDependency(t, '1:1-2', [['u', startVerticalMargin], ['r', 48 * pxPerHour + endArrowMargin], 'd', 'r']);
                        walkDependency(t, '1:2-1', [['u', startVerticalMargin * 2], ['l', 24 * pxPerHour + endArrowMargin], 'd', 'r']);
                        walkDependency(t, '1:2-2', [['u', startVerticalMargin * 2], ['r', 48 * pxPerHour + endArrowMargin], 'd', 'r']);

                      case 5:
                      case "end":
                        return _context11.stop();
                    }
                  }
                }, _callee11);
              })));

            case 3:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x6) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('out-row dependency lines are drawn correctly (from bottom)', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _context14.next = 2;
              return getScheduler({
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Event 1',
                  startDate: '2011-01-04',
                  duration: 2
                }, {
                  id: '1-1',
                  resourceId: 'r1',
                  name: 'Event 1-1',
                  startDate: '2011-01-04 04:00',
                  duration: 0.5
                }, {
                  id: '1-2',
                  resourceId: 'r1',
                  name: 'Event 1-2',
                  startDate: '2011-01-05',
                  duration: 2
                }, {
                  id: '2-1',
                  resourceId: 'r2',
                  name: 'Event 2-1',
                  startDate: '2011-01-04 04:00',
                  duration: 0.5
                }, {
                  id: '2-2',
                  resourceId: 'r2',
                  name: 'Event 2-2',
                  startDate: '2011-01-05',
                  duration: 2
                }],
                dependencies: [{
                  id: '1:1-1',
                  from: 1,
                  to: '1-1',
                  fromSide: 'bottom'
                }, {
                  id: '1:1-2',
                  from: 1,
                  to: '1-2',
                  fromSide: 'bottom',
                  toSide: 'right'
                }, {
                  id: '1:2-1',
                  from: 1,
                  to: '2-1',
                  fromSide: 'bottom'
                }, {
                  id: '1:2-2',
                  from: 1,
                  to: '2-2',
                  fromSide: 'bottom',
                  toSide: 'right'
                }]
              });

            case 2:
              t.chain({
                waitForSelector: '.b-sch-dependency'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13() {
                var endArrowMargin, pxPerHour, eventHeight;
                return regeneratorRuntime.wrap(function _callee13$(_context13) {
                  while (1) {
                    switch (_context13.prev = _context13.next) {
                      case 0:
                        endArrowMargin = scheduler.features.dependencies.pathFinder.endArrowMargin, pxPerHour = scheduler.timeAxisViewModel.getDistanceForDuration(1000 * 60 * 60), eventHeight = document.querySelector(scheduler.unreleasedEventSelector).offsetHeight;
                        walkDependency(t, '1:1-1', [['d', startVerticalMargin], ['l', 20 * pxPerHour + endArrowMargin], 'd', 'r']);
                        walkDependency(t, '1:1-2', [['d', startVerticalMargin], ['r', 48 * pxPerHour + endArrowMargin], 'd', 'r']);
                        walkDependency(t, '1:2-1', [// two bar margins, full event, row border
                        ['d', startVerticalMargin * 4 + eventHeight + 1], ['l', 20 * pxPerHour + endArrowMargin], 'd', 'r']);
                        walkDependency(t, '1:2-2', [// two bar margins, full event, row border
                        ['d', startVerticalMargin * 4 + eventHeight + 1], ['r', 48 * pxPerHour + endArrowMargin], 'd', 'r']);

                      case 5:
                      case "end":
                        return _context13.stop();
                    }
                  }
                }, _callee13);
              })));

            case 3:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x7) {
      return _ref13.apply(this, arguments);
    };
  }());
});