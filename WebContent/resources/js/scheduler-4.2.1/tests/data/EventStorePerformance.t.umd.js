function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var project;
  t.beforeEach(function () {
    var _project;

    (_project = project) === null || _project === void 0 ? void 0 : _project.destroy();
  }); // https://github.com/bryntum/support/issues/3131
  // Problem comes from SharedEventStoreMixin which generated assignments on the fly thus it is not reproducible in
  // Scheduling Engine

  t.it('Should add events to the store', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var eventsData, i, assignmentIndicesSpy;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              project = new ProjectModel({
                destroyStores: true,
                resourcesData: [{
                  id: 1,
                  name: 'Resource 1'
                }]
              });
              _context.next = 3;
              return project.commitAsync();

            case 3:
              eventsData = [];

              for (i = 1; i < 1000; i++) {
                eventsData.push({
                  id: i,
                  resourceId: 'r1',
                  startDate: new Date(2021, 6, 5),
                  endDate: new Date(2021, 6, 6)
                });
              }

              assignmentIndicesSpy = t.spyOn(project.assignmentStore.storage, 'rebuildIndices');
              project.eventStore.add(eventsData);
              _context.next = 9;
              return project.commitAsync();

            case 9:
              t.expect(assignmentIndicesSpy).toHaveBeenCalled('<10');

            case 10:
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
  t.it('Should laod events to the store', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var eventsData, i, assignmentIndicesSpy;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              project = new ProjectModel({
                destroyStores: true,
                resourcesData: [{
                  id: 1,
                  name: 'Resource 1'
                }]
              });
              _context2.next = 3;
              return project.commitAsync();

            case 3:
              eventsData = [];

              for (i = 1; i < 1000; i++) {
                eventsData.push({
                  id: i,
                  resourceId: 'r1',
                  startDate: new Date(2021, 6, 5),
                  endDate: new Date(2021, 6, 6)
                });
              }

              assignmentIndicesSpy = t.spyOn(project.assignmentStore.storage, 'rebuildIndices');
              _context2.next = 8;
              return project.eventStore.loadDataAsync(eventsData);

            case 8:
              t.expect(assignmentIndicesSpy).toHaveBeenCalled('<10');

            case 9:
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
  t.it('Load and add take comparable time to finish', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var eventsData, i, now, addTime, loadTime;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              project = new ProjectModel({
                destroyStores: true,
                resourcesData: [{
                  id: 1,
                  name: 'Resource 1'
                }]
              });
              _context3.next = 3;
              return project.commitAsync();

            case 3:
              eventsData = [];

              for (i = 1; i < 1000; i++) {
                eventsData.push({
                  id: i,
                  resourceId: 'r1',
                  startDate: new Date(2021, 6, 5),
                  endDate: new Date(2021, 6, 6)
                });
              }

              now = performance.now();
              project.eventStore.add(eventsData);
              _context3.next = 9;
              return project.commitAsync();

            case 9:
              addTime = performance.now() - now;
              project.destroy();
              project = new ProjectModel({
                destroyStores: true,
                resourcesData: [{
                  id: 1,
                  name: 'Resource 1'
                }]
              });
              _context3.next = 14;
              return project.commitAsync();

            case 14:
              now = performance.now();
              _context3.next = 17;
              return project.eventStore.loadDataAsync(eventsData);

            case 17:
              loadTime = performance.now() - now;
              t.isApprox(addTime, loadTime, loadTime * 10, 'store.add is within 1 order of magnitude of store.loadDataAsync');

            case 19:
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