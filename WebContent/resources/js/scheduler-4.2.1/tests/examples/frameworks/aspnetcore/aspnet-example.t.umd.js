function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest( /*#__PURE__*/function () {
  var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
    var scheduler;
    return regeneratorRuntime.wrap(function _callee4$(_context4) {
      while (1) {
        switch (_context4.prev = _context4.next) {
          case 0:
            _context4.next = 2;
            return t.waitForSelector('.b-sch-event');

          case 2:
            scheduler = window.scheduler;
            scheduler.enableEventAnimations = false;
            t.it('Testing add/update/remove resource/event', /*#__PURE__*/function () {
              var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
                var _scheduler$resourceSt, _scheduler$resourceSt2, resource, _scheduler$eventStore, _scheduler$eventStore2, event;

                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        _context.prev = 0;
                        _scheduler$resourceSt = scheduler.resourceStore.add({
                          Name: 'New resource'
                        }), _scheduler$resourceSt2 = _slicedToArray(_scheduler$resourceSt, 1), resource = _scheduler$resourceSt2[0], _scheduler$eventStore = scheduler.eventStore.add({
                          ResourceId: resource.id,
                          Name: 'New event',
                          StartDate: '2017-09-12',
                          EndDate: '2017-09-13'
                        }), _scheduler$eventStore2 = _slicedToArray(_scheduler$eventStore, 1), event = _scheduler$eventStore2[0];
                        t.diag('Adding new resource/event');
                        scheduler.crudManager.on({
                          beforeSync: function beforeSync(_ref3) {
                            var pack = _ref3.pack;
                            t.isDeeply(pack.resources, {
                              added: [{
                                $PhantomId: resource.id,
                                Name: 'New resource'
                              }]
                            }, 'Resource sync pack is ok');
                            t.isDeeply(pack.events, {
                              added: [{
                                $PhantomId: event.id,
                                Name: 'New event',
                                StartDate: new Date('2017-09-12 00:00').toString(),
                                EndDate: new Date('2017-09-13 00:00').toString(),
                                ResourceId: resource.id,
                                Cls: '',
                                Draggable: true,
                                Resizable: true,
                                duration: 1,
                                durationUnit: 'd'
                              }]
                            }, 'Event sync pack is ok');
                          },
                          beforeSyncApply: function beforeSyncApply(_ref4) {
                            var response = _ref4.response;
                            var newResourceId = response.resources.rows[0].Id,
                                newEventId = response.events.rows[0].Id;
                            t.isDeeply(response.resources.rows, [{
                              $PhantomId: resource.id,
                              Id: newResourceId
                            }], 'Resource is added');
                            t.isDeeply(response.events.rows, [{
                              $PhantomId: event.id,
                              Id: newEventId,
                              ResourceId: newResourceId
                            }], 'Event is added');
                          },
                          once: true
                        });
                        _context.next = 6;
                        return scheduler.crudManager.sync();

                      case 6:
                        t.diag('Changing resource/event');
                        resource.name = 'resource';
                        event.name = 'event';
                        scheduler.crudManager.on({
                          beforeSync: function beforeSync(_ref5) {
                            var pack = _ref5.pack;
                            t.isDeeply(pack.resources, {
                              updated: [{
                                Id: resource.id,
                                Name: 'resource'
                              }]
                            }, 'Resource sync pack is ok');
                            t.isDeeply(pack.events, {
                              updated: [{
                                Id: event.id,
                                Name: 'event'
                              }]
                            }, 'Event sync pack is ok');
                          },
                          beforeSyncApply: function beforeSyncApply(_ref6) {
                            var response = _ref6.response;
                            var newResourceId = response.resources.rows[0].Id,
                                newEventId = response.events.rows[0].Id;
                            t.isDeeply(response.resources.rows, [{
                              Id: newResourceId
                            }], 'Resource is updated');
                            t.isDeeply(response.events.rows, [{
                              Id: newEventId
                            }], 'Event is updated');
                          },
                          once: true
                        });
                        _context.next = 12;
                        return scheduler.crudManager.sync();

                      case 12:
                        t.diag('Removing resource/event');
                        event.remove();
                        resource.remove();
                        scheduler.crudManager.on({
                          beforeSync: function beforeSync(_ref7) {
                            var pack = _ref7.pack;
                            t.isDeeply(pack.resources, {
                              removed: [{
                                Id: resource.id
                              }]
                            }, 'Resource sync pack is ok');
                            t.isDeeply(pack.events, {
                              removed: [{
                                Id: event.id
                              }]
                            }, 'Event sync pack is ok');
                          },
                          beforeSyncApply: function beforeSyncApply(_ref8) {
                            var response = _ref8.response;
                            t.isDeeply(response.resources.removed, [{
                              Id: resource.id
                            }], 'Resource is removed');
                            t.isDeeply(response.events.removed, [{
                              Id: event.id
                            }], 'Event is removed');
                          },
                          once: true
                        });
                        _context.next = 18;
                        return scheduler.crudManager.sync();

                      case 18:
                        _context.next = 23;
                        break;

                      case 20:
                        _context.prev = 20;
                        _context.t0 = _context["catch"](0);
                        t.fail(_context.t0.stack);

                      case 23:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee, null, [[0, 20]]);
              }));

              return function (_x2) {
                return _ref2.apply(this, arguments);
              };
            }());
            t.it('Adding multiple new events to new/existing resource', /*#__PURE__*/function () {
              var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
                var existingResource, newEvents, i, _scheduler$resourceSt3, _scheduler$resourceSt4, newResource;

                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        _context2.prev = 0;
                        t.diag('Adding new events to existing resource');
                        existingResource = scheduler.resourceStore.last;
                        newEvents = [];

                        for (i = 0; i < 4; i++) {
                          newEvents.push({
                            ResourceId: existingResource.id,
                            Name: "Event ".concat(i + 1),
                            StartDate: '2017-09-12',
                            EndDate: '2017-09-13'
                          });
                        }

                        newEvents = scheduler.eventStore.add(newEvents);
                        scheduler.crudManager.on({
                          beforeSyncApply: function beforeSyncApply(_ref10) {
                            var response = _ref10.response;
                            t.isDeeply(response.events.rows, newEvents.map(function (record, index) {
                              return {
                                $PhantomId: record.id,
                                Id: response.events.rows[index].Id
                              };
                            }), 'Events are added');
                          },
                          once: true
                        });
                        _context2.next = 9;
                        return scheduler.crudManager.sync();

                      case 9:
                        t.diag('Adding existing events to new resource');
                        _scheduler$resourceSt3 = scheduler.resourceStore.add({
                          Name: 'foo'
                        }), _scheduler$resourceSt4 = _slicedToArray(_scheduler$resourceSt3, 1), newResource = _scheduler$resourceSt4[0];
                        newEvents.forEach(function (event) {
                          return event.assign(newResource);
                        });
                        scheduler.crudManager.on({
                          beforeSyncApply: function beforeSyncApply(_ref11) {
                            var response = _ref11.response;
                            var newResourceId = response.resources.rows[0].Id;
                            t.isDeeply(response.resources.rows, [{
                              $PhantomId: newResource.id,
                              Id: newResourceId
                            }], 'Resource is added');
                            t.isDeeply(response.events.rows, newEvents.map(function (record) {
                              return {
                                Id: record.id,
                                ResourceId: newResourceId
                              };
                            }), 'Events are added');
                          },
                          once: true
                        });
                        _context2.next = 15;
                        return scheduler.crudManager.sync();

                      case 15:
                        t.isDeeply(newResource.events.map(function (e) {
                          return e.id;
                        }), newEvents.map(function (e) {
                          return e.id;
                        }), 'Resource events are ok');
                        t.selectorCountIs('.b-sch-event', scheduler.eventStore.count, 'Event selector count is ok');
                        t.diag('Cleanup');
                        newResource.remove();
                        newEvents.forEach(function (event) {
                          return event.remove();
                        });
                        _context2.next = 22;
                        return scheduler.crudManager.sync();

                      case 22:
                        _context2.next = 27;
                        break;

                      case 24:
                        _context2.prev = 24;
                        _context2.t0 = _context2["catch"](0);
                        t.fail(_context2.t0.stack);

                      case 27:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2, null, [[0, 24]]);
              }));

              return function (_x3) {
                return _ref9.apply(this, arguments);
              };
            }());
            t.it('Event dates are sent to and handled by backend including time zone', /*#__PURE__*/function () {
              var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
                var resource, _scheduler$eventStore3, _scheduler$eventStore4, event, _event, startDate, endDate, eventId;

                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        _context3.prev = 0;
                        resource = scheduler.resourceStore.last;
                        _scheduler$eventStore3 = scheduler.eventStore.add({
                          ResourceId: resource.id,
                          Name: 'New event',
                          StartDate: '2017-09-12',
                          EndDate: '2017-09-13'
                        }), _scheduler$eventStore4 = _slicedToArray(_scheduler$eventStore3, 1), event = _scheduler$eventStore4[0];
                        _event = event, startDate = _event.startDate, endDate = _event.endDate;
                        _context3.next = 6;
                        return scheduler.crudManager.sync();

                      case 6:
                        eventId = event.id;
                        t.is(event.startDate, startDate, 'Start date is ok after sync');
                        t.is(event.endDate, endDate, 'End date is ok after sync');
                        _context3.next = 11;
                        return scheduler.crudManager.load();

                      case 11:
                        event = scheduler.eventStore.getById(eventId);
                        t.is(event.startDate, startDate, 'Start date is ok after load');
                        t.is(event.endDate, endDate, 'End date is ok after load');
                        t.diag('Cleanup');
                        event.remove();
                        _context3.next = 18;
                        return scheduler.crudManager.sync();

                      case 18:
                        _context3.next = 23;
                        break;

                      case 20:
                        _context3.prev = 20;
                        _context3.t0 = _context3["catch"](0);
                        t.fail(_context3.t0.stack);

                      case 23:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3, null, [[0, 20]]);
              }));

              return function (_x4) {
                return _ref12.apply(this, arguments);
              };
            }());

          case 7:
          case "end":
            return _context4.stop();
        }
      }
    }, _callee4);
  }));

  return function (_x) {
    return _ref.apply(this, arguments);
  };
}());