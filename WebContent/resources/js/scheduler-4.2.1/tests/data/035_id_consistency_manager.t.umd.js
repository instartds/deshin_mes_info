function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

// IdConsistencyManager not used but test is still valid for stores
StartTest(function (t) {
  function createDataLayerWithoutAssignments() {
    return new ProjectModel({
      resourceStore: new ResourceStore({
        data: [{
          id: 1,
          name: 'Resource 1'
        }, {
          id: 2,
          name: 'Resource 2'
        }]
      }),
      eventStore: new EventStore({
        data: [{
          name: 'Event 1',
          resourceId: 1
        }, {
          name: 'Event 2',
          resourceId: 2
        }]
      })
    });
  }

  function createDataLayerWithAssignments() {
    var project = new ProjectModel({
      assignmentStore: new AssignmentStore(),
      resourceStore: new ResourceStore({
        data: [{
          name: 'Resource 1'
        }, {
          name: 'Resource 2'
        }]
      }),
      eventStore: new EventStore({
        data: [{
          name: 'Event 1'
        }, {
          name: 'Event 2'
        }]
      })
    });
    project.eventStore.getAt(0).assign(project.resourceStore.getAt(0));
    project.eventStore.getAt(1).assign(project.resourceStore.getAt(1));
    return project;
  }

  t.describe('Id consistency manager should update model records referential fields with updated record ids', function (t) {
    t.it('Should update event resource ids on an event store if it works without assignment store and resource ids are changed', function (t) {
      var _createDataLayerWitho = createDataLayerWithoutAssignments(),
          eventStore = _createDataLayerWitho.eventStore,
          resourceStore = _createDataLayerWitho.resourceStore,
          _eventStore = _slicedToArray(eventStore, 2),
          event1 = _eventStore[0],
          event2 = _eventStore[1],
          _resourceStore = _slicedToArray(resourceStore, 2),
          resource1 = _resourceStore[0],
          resource2 = _resourceStore[1];

      t.is(event1.resourceId, resource1.id, 'Event1 is assigned to Resource1');
      t.is(event2.resourceId, resource2.id, 'Event2 is assigned to Resource2');
      resource1.id = 1;
      resource2.id = 2;
      t.is(event1.resourceId, resource1.id, 'Event1 is still assigned to Resource1');
      t.is(event2.resourceId, resource2.id, 'Event2 is still assigned to Resource2');
    });
    t.it('Should update assignment event ids on an assignment store if event ids are changed and should update resource ids on assignment store if resource ids are changed', /*#__PURE__*/function () {
      var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
        var _createDataLayerWithA, eventStore, resourceStore, assignmentStore, _eventStore2, event1, event2, _resourceStore2, resource1, resource2, _assignmentStore, assignment1, assignment2;

        return regeneratorRuntime.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                _createDataLayerWithA = createDataLayerWithAssignments(), eventStore = _createDataLayerWithA.eventStore, resourceStore = _createDataLayerWithA.resourceStore, assignmentStore = _createDataLayerWithA.assignmentStore, _eventStore2 = _slicedToArray(eventStore, 2), event1 = _eventStore2[0], event2 = _eventStore2[1], _resourceStore2 = _slicedToArray(resourceStore, 2), resource1 = _resourceStore2[0], resource2 = _resourceStore2[1], _assignmentStore = _slicedToArray(assignmentStore, 2), assignment1 = _assignmentStore[0], assignment2 = _assignmentStore[1];
                t.ok(assignment1.eventId === event1.id && assignment1.resourceId === resource1.id, 'Event1 is assigned to Resource1');
                t.ok(assignment2.eventId === event2.id && assignment2.resourceId === resource2.id, 'Event2 is assigned to Resource2');
                event1.id = 1;
                event2.id = 2;
                _context.next = 7;
                return t.waitForProjectReady(eventStore);

              case 7:
                t.ok(assignment1.eventId === event1.id && assignment1.resourceId === resource1.id, 'Event1 is still assigned to Resource1 after Event1 id has been changed');
                t.ok(assignment2.eventId === event2.id && assignment2.resourceId === resource2.id, 'Event2 is still assigned to Resource2 after Event2 id has been changed');
                resource1.id = 1;
                resource2.id = 2;
                t.ok(assignment1.eventId === event1.id && assignment1.resourceId === resource1.id, 'Event1 is still assigned to Resource1 after Resource1 id has been changed');
                t.ok(assignment2.eventId === event2.id && assignment2.resourceId === resource2.id, 'Event2 is still assigned to Resource2 after Resource2 id has been changed');

              case 13:
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
});