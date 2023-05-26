function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var assignmentStore, resourceStore, eventStore, project;

  function setup() {
    return _setup.apply(this, arguments);
  }

  function _setup() {
    _setup = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6() {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              resourceStore = new ResourceStore({
                data: [{
                  id: 'r1',
                  name: 'Resource 1'
                }, {
                  id: 'r2',
                  name: 'Resource 2'
                }, {
                  id: 'r3',
                  name: 'Resource 3'
                }, {
                  id: 'r4',
                  name: 'Resource 4'
                }, {
                  id: 'r5',
                  name: 'Resource 5'
                }, {
                  id: 'r6',
                  name: 'Resource 6'
                }, {
                  id: 'r7',
                  name: 'Resource 7'
                }, {
                  id: 'r8',
                  name: 'Resource 8'
                }]
              });
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  resourceId: 'r1',
                  name: 'Event 1',
                  startDate: '2019-12-19',
                  duration: 1
                }, {
                  id: 2,
                  resourceId: 'r1',
                  name: 'Event 2',
                  startDate: '2019-12-24',
                  duration: 1
                }, {
                  id: 3,
                  resourceId: 'r2',
                  name: 'Event 3',
                  startDate: '2019-12-20',
                  duration: 1
                }]
              });
              project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: resourceStore
              });
              assignmentStore = project.assignmentStore;
              _context6.next = 6;
              return t.waitForProjectReady(project);

            case 6:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));
    return _setup.apply(this, arguments);
  }

  t.it('should convert resourceId into assignment', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var _resourceStore, _resourceStore2, r1, r2, _eventStore, _eventStore2, e1, e2, e3, _assignmentStore, _assignmentStore2, a1, a2, a3;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return setup();

            case 2:
              _resourceStore = resourceStore, _resourceStore2 = _slicedToArray(_resourceStore, 2), r1 = _resourceStore2[0], r2 = _resourceStore2[1], _eventStore = eventStore, _eventStore2 = _slicedToArray(_eventStore, 3), e1 = _eventStore2[0], e2 = _eventStore2[1], e3 = _eventStore2[2], _assignmentStore = assignmentStore, _assignmentStore2 = _slicedToArray(_assignmentStore, 3), a1 = _assignmentStore2[0], a2 = _assignmentStore2[1], a3 = _assignmentStore2[2];
              t.ok(eventStore.usesSingleAssignment, 'EventStore uses single assignment mode');
              t.is(assignmentStore.count, 3, 'Correct assignment count');
              t.isDeeply(assignmentStore.map(function (a) {
                return a.event;
              }), eventStore.records, 'Correct events for assignments');
              t.isDeeply(assignmentStore.map(function (a) {
                return a.resource;
              }), [r1, r1, r2], 'Correct resources for assignments');
              t.is(e1.resourceId, 'r1', 'Correct resourceId for Event 1');
              t.is(e2.resourceId, 'r1', 'Correct resourceId for Event 2');
              t.is(e3.resourceId, 'r2', 'Correct resourceId for Event 3');
              t.is(e1.data.resourceId, 'r1', 'Correct resourceId in data for Event 1');
              t.is(e2.data.resourceId, 'r1', 'Correct resourceId in data for Event 2');
              t.is(e3.data.resourceId, 'r2', 'Correct resourceId in data for Event 3');
              t.isDeeply(e1.assignments, [a1], 'Correct assignments for Event 1');
              t.isDeeply(e2.assignments, [a2], 'Correct assignments for Event 2');
              t.isDeeply(e3.assignments, [a3], 'Correct assignments for Event 3');

            case 16:
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
  t.it('should update resourceId + assignment on reassignment', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var assertResourceId, _assertResourceId, _eventStore3, _eventStore4, event, _assignmentStore3, _assignmentStore4, assignment, _resourceStore3, _resourceStore4, r2, r3, r4, r5, r6, r7, r8;

      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _assertResourceId = function _assertResourceId3() {
                _assertResourceId = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(resource) {
                  var assertAssignment,
                      _args2 = arguments;
                  return regeneratorRuntime.wrap(function _callee2$(_context2) {
                    while (1) {
                      switch (_context2.prev = _context2.next) {
                        case 0:
                          assertAssignment = _args2.length > 1 && _args2[1] !== undefined ? _args2[1] : true;
                          _context2.next = 3;
                          return t.waitForProjectReady(project);

                        case 3:
                          if (assertAssignment) {
                            t.is(assignment.resourceId, resource.id, 'Assignments resourceId updated');
                            t.is(assignment.resource, resource, 'Assignments resource updated');
                          }

                          t.is(event.resourceId, resource.id, 'Event returned correct resourceId');
                          t.is(event.resource, resource, 'Event returned correct resource');
                          t.ok(event.isModified, 'Event modified');
                          t.is(event.modifications.resourceId, resource.id, 'Event has correct modification');

                        case 8:
                        case "end":
                          return _context2.stop();
                      }
                    }
                  }, _callee2);
                }));
                return _assertResourceId.apply(this, arguments);
              };

              assertResourceId = function _assertResourceId2(_x3) {
                return _assertResourceId.apply(this, arguments);
              };

              _context3.next = 4;
              return setup();

            case 4:
              _eventStore3 = eventStore, _eventStore4 = _slicedToArray(_eventStore3, 1), event = _eventStore4[0], _assignmentStore3 = assignmentStore, _assignmentStore4 = _slicedToArray(_assignmentStore3, 1), assignment = _assignmentStore4[0], _resourceStore3 = resourceStore, _resourceStore4 = _slicedToArray(_resourceStore3, 8), r2 = _resourceStore4[1], r3 = _resourceStore4[2], r4 = _resourceStore4[3], r5 = _resourceStore4[4], r6 = _resourceStore4[5], r7 = _resourceStore4[6], r8 = _resourceStore4[7];
              t.diag('Changing resourceId');
              event.resourceId = 'r2';
              _context3.next = 9;
              return assertResourceId(r2);

            case 9:
              t.diag('Changing resource');
              event.resource = r3;
              _context3.next = 13;
              return assertResourceId(r3);

            case 13:
              t.diag('Calling assign');
              event.assign(r4);
              _context3.next = 17;
              return assertResourceId(r4);

            case 17:
              t.diag('Calling AssignmentStore#assignEventToResource');
              assignmentStore.assignEventToResource(event, r5);
              _context3.next = 21;
              return assertResourceId(r5);

            case 21:
              t.diag('Calling EventoStore#reassignEventFromResourceToResource');
              eventStore.reassignEventFromResourceToResource(event, r5, r6);
              _context3.next = 25;
              return assertResourceId(r6);

            case 25:
              t.diag('Changing assignment record');
              assignment.resourceId = 'r7';
              _context3.next = 29;
              return assertResourceId(r7);

            case 29:
              t.diag('Adding assignment');
              event.resourceId = null;
              assignmentStore.add({
                eventId: event.id,
                resourceId: 'r8'
              });
              _context3.next = 34;
              return assertResourceId(r8, false);

            case 34:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('should update resourceId + assignment when unassigning', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var _eventStore5, _eventStore6, event, _resourceStore5, _resourceStore6, r1, assertUnassigned, _assertUnassigned;

      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _assertUnassigned = function _assertUnassigned3() {
                _assertUnassigned = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
                  return regeneratorRuntime.wrap(function _callee4$(_context4) {
                    while (1) {
                      switch (_context4.prev = _context4.next) {
                        case 0:
                          _context4.next = 2;
                          return t.waitForProjectReady(project);

                        case 2:
                          t.is(event.resourceId, null, 'resourceId is null');
                          t.is(event.assignments.length, 0, 'event.assignments is empty');
                          t.is(event.resource, null, 'event.resource is null');
                          t.notOk(event.isAssignedTo(r1), 'Not assigned to resource');
                          t.notOk(assignmentStore.isEventAssignedToResource(event, r1, 'Not assigned to resource according to store'));
                          t.ok(event.isModified, 'Event modified');
                          t.is(event.modifications.resourceId, null, 'Event has correct modifications'); // reassign before next assertion

                          event.resourceId = 'r1';

                        case 10:
                        case "end":
                          return _context4.stop();
                      }
                    }
                  }, _callee4);
                }));
                return _assertUnassigned.apply(this, arguments);
              };

              assertUnassigned = function _assertUnassigned2() {
                return _assertUnassigned.apply(this, arguments);
              };

              _context5.next = 4;
              return setup();

            case 4:
              _eventStore5 = eventStore, _eventStore6 = _slicedToArray(_eventStore5, 1), event = _eventStore6[0], _resourceStore5 = resourceStore, _resourceStore6 = _slicedToArray(_resourceStore5, 1), r1 = _resourceStore6[0];
              t.diag('Clearing resourceId');
              event.resourceId = null;
              _context5.next = 9;
              return assertUnassigned();

            case 9:
              t.diag('Clearing resource');
              event.resource = null;
              _context5.next = 13;
              return assertUnassigned();

            case 13:
              t.diag('Calling unassign()');
              event.unassign();
              _context5.next = 17;
              return assertUnassigned();

            case 17:
              t.diag('Calling unassign(r1)');
              event.unassign(r1);
              _context5.next = 21;
              return assertUnassigned();

            case 21:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x4) {
      return _ref3.apply(this, arguments);
    };
  }());
});