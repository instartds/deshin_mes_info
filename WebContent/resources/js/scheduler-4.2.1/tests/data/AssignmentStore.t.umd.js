function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var project, resourceStore, eventStore, assignmentStore;

  function createData() {
    return _createData.apply(this, arguments);
  }

  function _createData() {
    _createData = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee23() {
      var removeUnassignedEvent,
          _args23 = arguments;
      return regeneratorRuntime.wrap(function _callee23$(_context23) {
        while (1) {
          switch (_context23.prev = _context23.next) {
            case 0:
              removeUnassignedEvent = _args23.length > 0 && _args23[0] !== undefined ? _args23[0] : false;
              resourceStore = new ResourceStore({
                data: [{
                  id: 1,
                  name: 'Superman'
                }, {
                  id: 2,
                  name: 'Batman'
                }]
              });
              assignmentStore = new AssignmentStore({
                data: [{
                  id: 1,
                  eventId: 1,
                  resourceId: 1
                }, {
                  id: 2,
                  eventId: 2,
                  resourceId: 1
                }, {
                  id: 3,
                  eventId: 2,
                  resourceId: 2
                }, {
                  id: 4,
                  eventId: 3,
                  resourceId: 2
                }]
              });
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  name: 'Fly'
                }, {
                  id: 2,
                  name: 'Fight'
                }, {
                  id: 3,
                  name: 'Sneak'
                }],
                removeUnassignedEvent: removeUnassignedEvent
              });
              project = new ProjectModel({
                assignmentStore: assignmentStore,
                eventStore: eventStore,
                resourceStore: resourceStore
              });
              _context23.next = 7;
              return t.waitForProjectReady(project);

            case 7:
            case "end":
              return _context23.stop();
          }
        }
      }, _callee23);
    }));
    return _createData.apply(this, arguments);
  }

  t.it('Basic assignment sanity', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var _eventStore, _eventStore2, fly, fight, sneak, _resourceStore, _resourceStore2, superman, batman, _assignmentStore, _assignmentStore2, superFly, superFight, batFight, batSneak;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return createData();

            case 2:
              _eventStore = eventStore, _eventStore2 = _slicedToArray(_eventStore, 3), fly = _eventStore2[0], fight = _eventStore2[1], sneak = _eventStore2[2];
              _resourceStore = resourceStore, _resourceStore2 = _slicedToArray(_resourceStore, 2), superman = _resourceStore2[0], batman = _resourceStore2[1];
              _assignmentStore = assignmentStore, _assignmentStore2 = _slicedToArray(_assignmentStore, 4), superFly = _assignmentStore2[0], superFight = _assignmentStore2[1], batFight = _assignmentStore2[2], batSneak = _assignmentStore2[3];
              t.is(superFly.resource, superman, 'Correct resource for first assignment');
              t.is(superFight.resource, superman, 'Correct resource for second assignment');
              t.is(batFight.resource, batman, 'Correct resource for third assignment');
              t.is(batSneak.resource, batman, 'Correct resource for forth assignment');
              t.is(superFly.event, fly, 'Correct event for first assignment');
              t.is(superFight.event, fight, 'Correct event for second assignment');
              t.is(batFight.event, fight, 'Correct event for third assignment');
              t.is(batSneak.event, sneak, 'Correct event for forth assignment');
              t.isDeeplyUnordered(fly.assignments, [superFly], 'Correct assignments for first event');
              t.isDeeplyUnordered(fight.assignments, [superFight, batFight], 'Correct assignments for second event');
              t.isDeeplyUnordered(sneak.assignments, [batSneak], 'Correct assignments for third event');
              t.isDeeplyUnordered(superman.assignments, [superFly, superFight], 'Correct assignments for first resource');
              t.isDeeplyUnordered(batman.assignments, [batFight, batSneak], 'Correct assignments for second resource'); // Not relations, but worth checking

              t.isDeeplyUnordered(superman.events, [fly, fight], 'Correct events for first resource');
              t.isDeeplyUnordered(batman.events, [fight, sneak], 'Correct events for second resource');
              t.isDeeplyUnordered(fly.resources, [superman], 'Correct resources for first event');
              t.isDeeplyUnordered(fight.resources, [superman, batman], 'Correct resources for second event');
              t.isDeeplyUnordered(sneak.resources, [batman], 'Correct resources for third event');
              t.ok(assignmentStore.storage.indices.event, 'Indexed by event');
              t.ok(assignmentStore.storage.indices.resource, 'Indexed by resource'); // Excluded for now, see note AssignmentStoreMixin
              // t.ok(assignmentStore.storage.indices.eventResourceKey, 'Indexed by eventResourceKey');

            case 25:
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
  t.it('Relation manipulations should work', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var _eventStore$records, sneak, _resourceStore$record, superman, batman, _assignmentStore$reco, superFly, superFight, batFight, batSneak;

      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return createData();

            case 2:
              _eventStore$records = _slicedToArray(eventStore.records, 3), sneak = _eventStore$records[2];
              _resourceStore$record = _slicedToArray(resourceStore.records, 2), superman = _resourceStore$record[0], batman = _resourceStore$record[1];
              _assignmentStore$reco = _slicedToArray(assignmentStore.records, 4), superFly = _assignmentStore$reco[0], superFight = _assignmentStore$reco[1], batFight = _assignmentStore$reco[2], batSneak = _assignmentStore$reco[3];
              batSneak.resource = superman;
              _context2.next = 8;
              return t.waitForProjectReady(eventStore);

            case 8:
              t.is(batSneak.resourceId, superman.id, 'Assignments resourceId updated');
              t.isDeeplyUnordered(sneak.assignments, [batSneak], 'Events assignments still correct');
              t.isDeeplyUnordered(superman.assignments, [superFly, superFight, batSneak], 'New resource assignments updated');
              t.isDeeplyUnordered(batman.assignments, [batFight], 'Old resource assignments updated'); // batman going super!

              batman.assignments = [superFly, superFight, batSneak];
              _context2.next = 15;
              return t.waitForProjectReady(eventStore);

            case 15:
              t.is(superFly.resource, batman, 'First assignment updated');
              t.is(superFight.resource, batman, 'Second assignment updated');
              t.is(batSneak.resource, batman, 'Third assignment updated'); // No more sneaking

              batSneak.resource = null;
              _context2.next = 21;
              return t.waitForProjectReady(eventStore);

            case 21:
              t.is(batSneak.resource, null, 'Assignments resource is null');
              t.is(batSneak.resourceId, null, 'Assignments resourceId is null'); // Invalid flying

              superFly.resource = 'blargh';
              _context2.next = 26;
              return t.waitForProjectReady(eventStore);

            case 26:
              t.is(superFly.resource, null, 'Assignments resource is null'); // TODO: Is this what we want? What if resource enters store after
              // t.is(superFly.resourceId, null, 'Assignments resourceId is null');

            case 27:
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
  t.it('assignEventToResource should work', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var _resourceStore$record2, superman, batman, _eventStore$records2, fly;

      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return createData();

            case 2:
              _resourceStore$record2 = _slicedToArray(resourceStore.records, 2), superman = _resourceStore$record2[0], batman = _resourceStore$record2[1];
              _eventStore$records2 = _slicedToArray(eventStore.records, 1), fly = _eventStore$records2[0];
              assignmentStore.removeAll();
              _context3.next = 7;
              return t.waitForProjectReady(eventStore);

            case 7:
              eventStore.assignEventToResource(fly, superman);
              t.isDeeply(fly.resources, [superman]);
              eventStore.assignEventToResource(fly, batman);
              t.isDeeply(fly.resources, [superman, batman]);
              eventStore.unassignEventFromResource(fly, batman);
              t.isDeeply(fly.resources, [superman]);
              eventStore.assignEventToResource(fly, batman, true);
              t.isDeeply(fly.resources, [batman], 'When passing `true`, old assignments should be removed');
              eventStore.unassignEventFromResource(fly, batman);
              t.isDeeply(fly.resources, []);

            case 17:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8482/details

  t.it('Should update related entities while stores are batched', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var event;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return createData();

            case 2:
              eventStore.beginBatch();
              event = eventStore.add({
                name: 'test',
                startDate: new Date(2017, 0, 1, 14),
                duration: 1,
                durationUnit: 'hour'
              })[0];
              eventStore.endBatch();
              eventStore.assignEventToResource(event.id, 'r1');
              t.is(event.assignments.length, 1, 'Assignment present');

            case 7:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Removing assignment should not impact "event" relation of other assignments', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var eventStore, resourceStore, assignmentStore, project;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              eventStore = new EventStore({
                data: [{
                  id: 1,
                  name: 'Event 1'
                }, {
                  id: 2,
                  name: 'Event 2'
                }]
              }), resourceStore = new ResourceStore({
                data: [{
                  id: 1,
                  name: 'Resource 1'
                }, {
                  id: 2,
                  name: 'Resource 2'
                }]
              }), assignmentStore = new AssignmentStore({
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
              }), project = new ProjectModel({
                eventStore: eventStore,
                resourceStore: resourceStore,
                assignmentStore: assignmentStore
              });
              assignmentStore.first.remove();
              _context5.next = 4;
              return t.waitForProjectReady(project);

            case 4:
              t.ok(assignmentStore.first.event, 'Event of other assignments still intact');

            case 5:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x5) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('should remove assignments when linked records are removed', function (t) {
    t.it('should remove assignments when events are removed', /*#__PURE__*/function () {
      var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
        var _eventStore3, _eventStore4, event1, event2, event3, _resourceStore3, _resourceStore4, resource1, resource2, spy;

        return regeneratorRuntime.wrap(function _callee6$(_context6) {
          while (1) {
            switch (_context6.prev = _context6.next) {
              case 0:
                _context6.next = 2;
                return createData();

              case 2:
                _eventStore3 = eventStore, _eventStore4 = _slicedToArray(_eventStore3, 3), event1 = _eventStore4[0], event2 = _eventStore4[1], event3 = _eventStore4[2], _resourceStore3 = resourceStore, _resourceStore4 = _slicedToArray(_resourceStore3, 2), resource1 = _resourceStore4[0], resource2 = _resourceStore4[1];
                spy = t.spyOn(eventStore, 'remove');
                event1.remove();
                _context6.next = 7;
                return t.waitForProjectReady(project);

              case 7:
                t.notOk(assignmentStore.getById(1), 'Assignment removed');
                t.isDeeply(resource1.events, [event2], 'Correct events for resource 1');
                eventStore.remove([event2, event3]);
                _context6.next = 12;
                return t.waitForProjectReady(project);

              case 12:
                t.is(assignmentStore.count, 0, 'Assignments removed');
                t.isDeeply(resource1.events, [], 'No events for resource 1');
                t.isDeeply(resource2.events, [], 'No events for resource 2'); // No removal loop

                t.expect(spy).toHaveBeenCalled(2);

              case 16:
              case "end":
                return _context6.stop();
            }
          }
        }, _callee6);
      }));

      return function (_x6) {
        return _ref6.apply(this, arguments);
      };
    }());
    t.it('should remove all assignments when all events are removed', /*#__PURE__*/function () {
      var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
        var _resourceStore5, _resourceStore6, resource1, resource2, spy;

        return regeneratorRuntime.wrap(function _callee7$(_context7) {
          while (1) {
            switch (_context7.prev = _context7.next) {
              case 0:
                _context7.next = 2;
                return createData();

              case 2:
                _resourceStore5 = resourceStore, _resourceStore6 = _slicedToArray(_resourceStore5, 2), resource1 = _resourceStore6[0], resource2 = _resourceStore6[1];
                spy = t.spyOn(eventStore, 'removeAll');
                eventStore.removeAll();
                t.is(assignmentStore.count, 0, 'Assignments removed');
                t.isDeeply(resource1.events, [], 'No events for resource 1');
                t.isDeeply(resource2.events, [], 'No events for resource 2');
                t.expect(spy).toHaveBeenCalled(1);

              case 9:
              case "end":
                return _context7.stop();
            }
          }
        }, _callee7);
      }));

      return function (_x7) {
        return _ref7.apply(this, arguments);
      };
    }());
    t.it('should remove assignments when resource is removed', /*#__PURE__*/function () {
      var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
        var _eventStore5, _eventStore6, event1, event2, event3, _assignmentStore3, _assignmentStore4, a3, a4, _resourceStore7, _resourceStore8, resource2, spy;

        return regeneratorRuntime.wrap(function _callee8$(_context8) {
          while (1) {
            switch (_context8.prev = _context8.next) {
              case 0:
                _context8.next = 2;
                return createData();

              case 2:
                _eventStore5 = eventStore, _eventStore6 = _slicedToArray(_eventStore5, 3), event1 = _eventStore6[0], event2 = _eventStore6[1], event3 = _eventStore6[2], _assignmentStore3 = assignmentStore, _assignmentStore4 = _slicedToArray(_assignmentStore3, 4), a3 = _assignmentStore4[2], a4 = _assignmentStore4[3], _resourceStore7 = resourceStore, _resourceStore8 = _slicedToArray(_resourceStore7, 2), resource2 = _resourceStore8[1];
                spy = t.spyOn(resourceStore, 'remove');
                resourceStore.first.remove();
                _context8.next = 7;
                return t.waitForProjectReady(project);

              case 7:
                t.isDeeply(assignmentStore.records, [a3, a4], 'Assignments removed');
                t.isDeeply(event1.resources, [], 'No resources for event 1');
                t.isDeeply(event2.resources, [resource2], 'Correct resources for event 2');
                t.isDeeply(event3.resources, [resource2], 'Correct resources for event 3');
                t.expect(spy).toHaveBeenCalled(1);

              case 12:
              case "end":
                return _context8.stop();
            }
          }
        }, _callee8);
      }));

      return function (_x8) {
        return _ref8.apply(this, arguments);
      };
    }());
    t.it('should remove assignments when resources are removed', /*#__PURE__*/function () {
      var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
        var _eventStore7, _eventStore8, event1, event2, event3, _resourceStore9, _resourceStore10, resource1, resource2, resourceSpy, assignmentSpy;

        return regeneratorRuntime.wrap(function _callee9$(_context9) {
          while (1) {
            switch (_context9.prev = _context9.next) {
              case 0:
                _context9.next = 2;
                return createData();

              case 2:
                _eventStore7 = eventStore, _eventStore8 = _slicedToArray(_eventStore7, 3), event1 = _eventStore8[0], event2 = _eventStore8[1], event3 = _eventStore8[2], _resourceStore9 = resourceStore, _resourceStore10 = _slicedToArray(_resourceStore9, 2), resource1 = _resourceStore10[0], resource2 = _resourceStore10[1];
                resourceSpy = t.spyOn(resourceStore, 'remove'), assignmentSpy = t.spyOn(assignmentStore, 'remove');
                resourceStore.remove([resource1, resource2]);
                t.is(assignmentStore.count, 0, 'Assignments removed');
                t.isDeeply(event1.resources, [], 'No resources for event 1');
                t.isDeeply(event2.resources, [], 'No resources for event 2');
                t.isDeeply(event3.resources, [], 'No resources for event 3');
                t.expect(resourceSpy).toHaveBeenCalled(1);
                t.expect(assignmentSpy).toHaveBeenCalled(1);

              case 11:
              case "end":
                return _context9.stop();
            }
          }
        }, _callee9);
      }));

      return function (_x9) {
        return _ref9.apply(this, arguments);
      };
    }());
    t.it('should remove all assignments when all resources are removed', /*#__PURE__*/function () {
      var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
        var _eventStore9, _eventStore10, event1, event2, event3, resourceSpy, assignmentSpy;

        return regeneratorRuntime.wrap(function _callee10$(_context10) {
          while (1) {
            switch (_context10.prev = _context10.next) {
              case 0:
                _context10.next = 2;
                return createData();

              case 2:
                _eventStore9 = eventStore, _eventStore10 = _slicedToArray(_eventStore9, 3), event1 = _eventStore10[0], event2 = _eventStore10[1], event3 = _eventStore10[2];
                resourceSpy = t.spyOn(resourceStore, 'removeAll'), assignmentSpy = t.spyOn(assignmentStore, 'removeAll');
                resourceStore.removeAll();
                t.is(assignmentStore.count, 0, 'Assignments removed');
                t.isDeeply(event1.resources, [], 'No resources for event 1');
                t.isDeeply(event2.resources, [], 'No resources for event 2');
                t.isDeeply(event3.resources, [], 'No resources for event 3');
                t.expect(resourceSpy).toHaveBeenCalled(1);
                t.expect(assignmentSpy).toHaveBeenCalled(1);

              case 11:
              case "end":
                return _context10.stop();
            }
          }
        }, _callee10);
      }));

      return function (_x10) {
        return _ref10.apply(this, arguments);
      };
    }());
  });
  t.it('should remove events when assignments are removed', function (t) {
    t.it('should remove single assigned event when assignment is removed', /*#__PURE__*/function () {
      var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
        var eventSpy, assignmentSpy;
        return regeneratorRuntime.wrap(function _callee11$(_context11) {
          while (1) {
            switch (_context11.prev = _context11.next) {
              case 0:
                _context11.next = 2;
                return createData(true);

              case 2:
                eventSpy = t.spyOn(eventStore, 'remove'), assignmentSpy = t.spyOn(assignmentStore, 'remove');
                assignmentStore.first.remove();
                t.notOk(eventStore.getById(1), 'Event removed with assignment');
                t.expect(eventSpy).toHaveBeenCalled(1);
                t.expect(assignmentSpy).toHaveBeenCalled(1);

              case 7:
              case "end":
                return _context11.stop();
            }
          }
        }, _callee11);
      }));

      return function (_x11) {
        return _ref11.apply(this, arguments);
      };
    }());
    t.it('should remove assigned event when all its assignments are removed', /*#__PURE__*/function () {
      var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
        var _assignmentStore5, _assignmentStore6, a2, a3, eventSpy, assignmentSpy;

        return regeneratorRuntime.wrap(function _callee12$(_context12) {
          while (1) {
            switch (_context12.prev = _context12.next) {
              case 0:
                _context12.next = 2;
                return createData(true);

              case 2:
                _assignmentStore5 = assignmentStore, _assignmentStore6 = _slicedToArray(_assignmentStore5, 3), a2 = _assignmentStore6[1], a3 = _assignmentStore6[2], eventSpy = t.spyOn(eventStore, 'remove'), assignmentSpy = t.spyOn(assignmentStore, 'remove');
                a2.remove();
                t.ok(eventStore.getById(2), 'Event note removed with first assignment');
                a3.remove();
                t.notOk(eventStore.getById(2), 'Event removed with second assignment');
                t.expect(eventSpy).toHaveBeenCalled(1);
                t.expect(assignmentSpy).toHaveBeenCalled(2);

              case 9:
              case "end":
                return _context12.stop();
            }
          }
        }, _callee12);
      }));

      return function (_x12) {
        return _ref12.apply(this, arguments);
      };
    }());
    t.it('should remove events when all assignments are removed', /*#__PURE__*/function () {
      var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
        var unassigned, eventSpy, assignmentSpy;
        return regeneratorRuntime.wrap(function _callee13$(_context13) {
          while (1) {
            switch (_context13.prev = _context13.next) {
              case 0:
                _context13.next = 2;
                return createData(true);

              case 2:
                unassigned = eventStore.add({
                  id: 4,
                  name: 'Unassigned'
                });
                eventSpy = t.spyOn(eventStore, 'remove'), assignmentSpy = t.spyOn(assignmentStore, 'removeAll');
                assignmentStore.removeAll();
                t.isDeeply(eventStore.records, unassigned, 'Expected events removed with assignments');
                t.expect(eventSpy).toHaveBeenCalled(1);
                t.expect(assignmentSpy).toHaveBeenCalled(1);

              case 8:
              case "end":
                return _context13.stop();
            }
          }
        }, _callee13);
      }));

      return function (_x13) {
        return _ref13.apply(this, arguments);
      };
    }());
    t.it('should remove events when resource is removed', /*#__PURE__*/function () {
      var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
        var eventSpy, assignmentSpy, resourceSpy;
        return regeneratorRuntime.wrap(function _callee14$(_context14) {
          while (1) {
            switch (_context14.prev = _context14.next) {
              case 0:
                _context14.next = 2;
                return createData(true);

              case 2:
                eventSpy = t.spyOn(eventStore, 'remove'), assignmentSpy = t.spyOn(assignmentStore, 'remove'), resourceSpy = t.spyOn(resourceStore, 'remove');
                resourceStore.first.remove();
                t.notOk(assignmentStore.getById(1), 'Assignment removed');
                t.notOk(eventStore.getById(1), 'Event removed');
                resourceStore.first.remove();
                t.is(assignmentStore.count, 0, 'Assignments removed');
                t.is(eventStore.count, 0, 'Events removed'); // No removal loops

                t.expect(eventSpy).toHaveBeenCalled(2);
                t.expect(assignmentSpy).toHaveBeenCalled(2);
                t.expect(resourceSpy).toHaveBeenCalled(2);

              case 12:
              case "end":
                return _context14.stop();
            }
          }
        }, _callee14);
      }));

      return function (_x14) {
        return _ref14.apply(this, arguments);
      };
    }());
    t.it('should remove all events when all resources are removed', /*#__PURE__*/function () {
      var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
        var eventSpy, assignmentSpy, resourceSpy;
        return regeneratorRuntime.wrap(function _callee15$(_context15) {
          while (1) {
            switch (_context15.prev = _context15.next) {
              case 0:
                _context15.next = 2;
                return createData(true);

              case 2:
                eventSpy = t.spyOn(eventStore, 'remove'), assignmentSpy = t.spyOn(assignmentStore, 'removeAll'), resourceSpy = t.spyOn(resourceStore, 'remove');
                resourceStore.removeAll();
                t.is(assignmentStore.count, 0, 'Assignments removed');
                t.is(eventStore.count, 0, 'Events removed'); // No removal loops

                t.expect(eventSpy).toHaveBeenCalled(1);
                t.expect(assignmentSpy).toHaveBeenCalled(1);
                t.expect(resourceSpy).toHaveBeenCalled(0);

              case 9:
              case "end":
                return _context15.stop();
            }
          }
        }, _callee15);
      }));

      return function (_x15) {
        return _ref15.apply(this, arguments);
      };
    }());
  });
  t.it('Add assignment then event', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      var project;
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              project = new ProjectModel({
                assignmentsData: [{
                  id: 1,
                  eventId: 1,
                  resourceId: 1
                }],
                resourcesData: [{
                  id: 1
                }],
                eventsData: [{
                  id: 1
                }]
              });
              _context16.next = 3;
              return project.commitAsync();

            case 3:
              project.assignmentStore.add({
                id: 2,
                eventId: 2,
                resourceId: 1
              });
              project.eventStore.add({
                id: 2
              });
              _context16.next = 7;
              return project.commitAsync();

            case 7:
              t.is(project.assignmentStore.last.event, project.eventStore.last);

            case 8:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x16) {
      return _ref16.apply(this, arguments);
    };
  }());
  t.it('Data should be ready after addAsync()', /*#__PURE__*/function () {
    var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      var _yield$assignmentStor, _yield$assignmentStor2, assignment;

      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return createData();

            case 2:
              _context17.next = 4;
              return assignmentStore.addAsync({
                eventId: 1,
                resourceId: 2
              });

            case 4:
              _yield$assignmentStor = _context17.sent;
              _yield$assignmentStor2 = _slicedToArray(_yield$assignmentStor, 1);
              assignment = _yield$assignmentStor2[0];
              t.is(assignment.event, eventStore.getById(1), 'Event reference correct');
              t.is(assignment.resource, resourceStore.getById(2), 'Resource reference correct');

            case 9:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x17) {
      return _ref17.apply(this, arguments);
    };
  }());
  t.it('Data should be ready after loadDataAsync()', /*#__PURE__*/function () {
    var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              _context18.next = 2;
              return createData();

            case 2:
              _context18.next = 4;
              return assignmentStore.loadDataAsync([{
                eventId: 1,
                resourceId: 2
              }]);

            case 4:
              t.is(assignmentStore.first.event, eventStore.getById(1), 'Event reference correct');
              t.is(assignmentStore.first.resource, resourceStore.getById(2), 'Resource reference correct');

            case 6:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    }));

    return function (_x18) {
      return _ref18.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/1654

  t.it('Changing resource should update resourceId', /*#__PURE__*/function () {
    var _ref19 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee19(t) {
      var _assignmentStore7, _assignmentStore8, assignment;

      return regeneratorRuntime.wrap(function _callee19$(_context19) {
        while (1) {
          switch (_context19.prev = _context19.next) {
            case 0:
              _context19.next = 2;
              return createData();

            case 2:
              _assignmentStore7 = assignmentStore, _assignmentStore8 = _slicedToArray(_assignmentStore7, 1), assignment = _assignmentStore8[0];
              assignment.resource = resourceStore.last;
              _context19.next = 6;
              return project.commitAsync();

            case 6:
              t.is(assignment.resourceId, 2, 'Correct after change');
              t.isDeeply(assignment.modifications, {
                resourceId: 2,
                id: 1
              }, 'Modified');

            case 8:
            case "end":
              return _context19.stop();
          }
        }
      }, _callee19);
    }));

    return function (_x19) {
      return _ref19.apply(this, arguments);
    };
  }());
  t.it('Changing event should update eventId', /*#__PURE__*/function () {
    var _ref20 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee20(t) {
      var _assignmentStore9, _assignmentStore10, assignment;

      return regeneratorRuntime.wrap(function _callee20$(_context20) {
        while (1) {
          switch (_context20.prev = _context20.next) {
            case 0:
              _context20.next = 2;
              return createData();

            case 2:
              _assignmentStore9 = assignmentStore, _assignmentStore10 = _slicedToArray(_assignmentStore9, 1), assignment = _assignmentStore10[0];
              assignment.event = eventStore.last;
              _context20.next = 6;
              return project.commitAsync();

            case 6:
              t.is(assignment.eventId, 3, 'Correct after change');
              t.isDeeply(assignment.modifications, {
                eventId: 3,
                id: 1
              }, 'Modified');

            case 8:
            case "end":
              return _context20.stop();
          }
        }
      }, _callee20);
    }));

    return function (_x20) {
      return _ref20.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2402

  t.it('Should respect silent flag for add() method', /*#__PURE__*/function () {
    var _ref21 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee21(t) {
      return regeneratorRuntime.wrap(function _callee21$(_context21) {
        while (1) {
          switch (_context21.prev = _context21.next) {
            case 0:
              assignmentStore = new AssignmentStore();
              t.wontFire(assignmentStore, 'change');
              t.wontFire(assignmentStore, 'add');
              assignmentStore.add({}, true);

            case 4:
            case "end":
              return _context21.stop();
          }
        }
      }, _callee21);
    }));

    return function (_x21) {
      return _ref21.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2453

  t.it('Should not rebuild AssignmentStore indices multiple times when adding events', /*#__PURE__*/function () {
    var _ref22 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee22(t) {
      var spy, _assignmentStore$add, _assignmentStore$add2, a1, a2, a3;

      return regeneratorRuntime.wrap(function _callee22$(_context22) {
        while (1) {
          switch (_context22.prev = _context22.next) {
            case 0:
              _context22.next = 2;
              return createData();

            case 2:
              _context22.next = 4;
              return resourceStore.addAsync({
                id: 4
              });

            case 4:
              spy = t.spyOn(assignmentStore.storage, 'rebuildIndices').and.callThrough();
              _assignmentStore$add = assignmentStore.add([{
                eventId: 1,
                resourceId: 4
              }, {
                eventId: 2,
                resourceId: 4
              }, {
                eventId: 3,
                resourceId: 4
              }]), _assignmentStore$add2 = _slicedToArray(_assignmentStore$add, 3), a1 = _assignmentStore$add2[0], a2 = _assignmentStore$add2[1], a3 = _assignmentStore$add2[2];
              t.ok(a1.event.isEventModel, 'A1 event linked pre commit');
              t.ok(a2.event.isEventModel, 'A2 event linked pre commit');
              t.ok(a3.event.isEventModel, 'A3 event linked pre commit');
              t.ok(a1.resource.isResourceModel, 'A1 resource linked pre commit');
              t.ok(a2.resource.isResourceModel, 'A2 resource linked pre commit');
              t.ok(a3.resource.isResourceModel, 'A3 resource linked pre commit');
              _context22.next = 14;
              return project.commitAsync();

            case 14:
              t.expect(spy).toHaveBeenCalled(2); // From add and commit

            case 15:
            case "end":
              return _context22.stop();
          }
        }
      }, _callee22);
    }));

    return function (_x22) {
      return _ref22.apply(this, arguments);
    };
  }());
});