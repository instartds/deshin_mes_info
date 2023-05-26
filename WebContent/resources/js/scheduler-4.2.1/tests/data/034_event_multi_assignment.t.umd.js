function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

StartTest(function (t) {
  var monday = new Date(2015, 2, 16),
      sunday = new Date(2015, 2, 22);

  function getProject() {
    return new ProjectModel({
      eventStore: new EventStore({
        removeUnassignedEvent: false,
        data: [{
          id: 1,
          name: 'Event 1',
          startDate: monday,
          endDate: sunday
        }, {
          id: 2,
          name: 'Event 2',
          startDate: monday,
          endDate: sunday
        }]
      }),
      resourceStore: new ResourceStore({
        data: [{
          id: 1,
          name: 'Resource 1'
        }, {
          id: 2,
          name: 'Resource 2'
        }]
      }),
      assignmentStore: new AssignmentStore({
        data: [{
          id: 1,
          eventId: 1,
          resourceId: 1
        }, {
          id: 2,
          eventId: 1,
          resourceId: 2
        }, {
          id: 3,
          eventId: 2,
          resourceId: 2
        }]
      })
    });
  }

  function idify(recordset) {
    return recordset.map(function (r) {
      return r.id;
    });
  }

  t.describe('Scheduler data model must support events assignment to multiple resources', function (t) {
    t.it('Should properly report resources an event assigned to', function (t) {
      var _getProject = getProject(),
          eventStore = _getProject.eventStore,
          resourceStore = _getProject.resourceStore,
          _eventStore = _slicedToArray(eventStore, 2),
          e1 = _eventStore[0],
          e2 = _eventStore[1],
          _resourceStore = _slicedToArray(resourceStore, 2),
          r1 = _resourceStore[0],
          r2 = _resourceStore[1];

      t.isDeeplyUnordered(e1.resources, [r1, r2], 'Event 1 is correctly assigned to multiple resources');
      t.isDeeplyUnordered(e2.resources, [r2], 'Event 2 is correctly assigned to single resource');
      t.ok(e1.isAssignedTo(r1), 'Event 1 correctly reports it\'s assignment to Resource 1');
      t.ok(e1.isAssignedTo(2), 'Event 1 correctly reports it\'s assignment to Resource 1');
      t.ok(eventStore.isEventAssignedToResource(2, 2), 'EventStore correctly reports Event 2 to be assiged to Resource 2');
    });
    t.it('Should properly report events a resource assigned to', function (t) {
      var _getProject2 = getProject(),
          eventStore = _getProject2.eventStore,
          resourceStore = _getProject2.resourceStore;

      var resource1events, resource2events;
      t.diag('Via resource store');
      resource1events = idify(resourceStore.getById(1).getEvents());
      resource2events = idify(resourceStore.getById(2).getEvents());
      t.isDeeplyUnordered(resource1events, [1], 'Resource 1 is correctly assigned to single event');
      t.isDeeplyUnordered(resource2events, [1, 2], 'Resource 2 is correctly assigned to multiple events');
      t.diag('Via event store');
      resource1events = idify(eventStore.getEventsForResource(1));
      resource2events = idify(eventStore.getEventsForResource(2));
      t.isDeeplyUnordered(resource1events, [1], 'Resource 1 is correctly assigned to single event');
      t.isDeeplyUnordered(resource2events, [1, 2], 'Resource 2 is correctly assigned to multiple events');
    });
    t.it('Should support \'runtime\' event assignment/unassignment', function (t) {
      var _getProject3 = getProject(),
          eventStore = _getProject3.eventStore,
          resourceStore = _getProject3.resourceStore,
          e2 = eventStore.getById(2),
          _resourceStore2 = _slicedToArray(resourceStore, 2),
          r1 = _resourceStore2[0],
          r2 = _resourceStore2[1];

      e2.unassign(r2);
      t.isDeeplyUnordered(idify(r2.getEvents()), [1], 'Event 2 was correctly unassigned from Resource 2');
      e2.assign(r1);
      t.isDeeplyUnordered(idify(r1.getEvents()), [1, 2], 'Event 2 was correctly assigned to Resource 1');
    });
    t.it('Should properly split a multi-resource event', /*#__PURE__*/function () {
      var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
        var project, eventStore, assignmentStore, _eventStore2, event1, eventStoreCountBeforeSplit, assignmentStoreCountBeforeSplit, clone, event1Resources, cloneResources;

        return regeneratorRuntime.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                project = getProject(), eventStore = project.eventStore, assignmentStore = project.assignmentStore, _eventStore2 = _slicedToArray(eventStore, 1), event1 = _eventStore2[0]; // Need to await to have calculated values on split

                _context.next = 3;
                return project.commitAsync();

              case 3:
                eventStoreCountBeforeSplit = eventStore.count;
                assignmentStoreCountBeforeSplit = assignmentStore.count;
                _context.next = 7;
                return event1.split();

              case 7:
                clone = _context.sent;
                event1Resources = idify(eventStore.getById(1).resources);
                cloneResources = idify(clone.resources);
                t.isDeeplyUnordered(event1Resources, cloneResources, 'Split section was correctly assigned to multiple resources');
                t.is(assignmentStore.count, assignmentStoreCountBeforeSplit + 2, 'Split operation generated 2 new assignments');
                t.is(eventStore.count, eventStoreCountBeforeSplit + 1, 'Split operation generated 1 new event');

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