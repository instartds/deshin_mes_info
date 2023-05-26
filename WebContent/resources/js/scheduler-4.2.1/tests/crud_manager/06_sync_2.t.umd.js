function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  t.it('Should sync all stores, prioritized and regular', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var regularStore, featuredStore, eventStore, crud, _eventStore$add, _eventStore$add2, event;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.mockUrl('sync-prioritized', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  events: {
                    rows: [{
                      id: 1,
                      name: 'event'
                    }],
                    removed: [{
                      id: 10
                    }]
                  },
                  regular: {
                    rows: [{
                      id: 1,
                      name: 'regular'
                    }]
                  },
                  featured: {
                    rows: [{
                      id: 1,
                      name: 'featured'
                    }]
                  }
                })
              });
              regularStore = new Store({
                storeId: 'regular',
                fields: ['name']
              }), featuredStore = new Store({
                storeId: 'featured',
                fields: ['name']
              }), eventStore = t.getEventStore([], 0), crud = new CrudManager({
                // NOTE: Needed for event records to find the store, usually supplied by Scheduler
                project: new ProjectModel({
                  eventStore: eventStore
                }),
                transport: {
                  sync: {
                    url: 'sync-prioritized'
                  }
                },
                warn: function warn() {}
              });
              _context.next = 4;
              return t.waitForProjectReady(crud);

            case 4:
              crud.addPrioritizedStore(featuredStore);
              crud.addCrudStore(regularStore); // make change in the event to fill change set package

              _eventStore$add = eventStore.add({
                id: 10,
                name: 'bar'
              }), _eventStore$add2 = _slicedToArray(_eventStore$add, 1), event = _eventStore$add2[0];
              event.name = 'foo';
              _context.next = 10;
              return crud.sync();

            case 10:
              t.is(eventStore.count, 1, '1 event received');
              t.is(regularStore.count, 1, '1 record received');
              t.is(featuredStore.count, 1, '1 record received');
              t.is(eventStore.getById(1).name, 'event', 'Event record is ok');
              t.is(regularStore.getById(1).name, 'regular', 'Record is ok');
              t.is(featuredStore.getById(1).name, 'featured', 'Record is ok'); // remove featured store, response should not be applied to it

              crud.removeCrudStore(featuredStore); // make change in the event to fill change set package

              event = eventStore.getById(1);
              event.name = '';
              t.mockUrl('sync-prioritized', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  events: {
                    rows: [{
                      id: 1,
                      name: 'event 1'
                    }]
                  },
                  regular: {
                    rows: [{
                      id: 1,
                      name: 'regular 1'
                    }]
                  },
                  featured: {
                    rows: [{
                      id: 1,
                      name: 'featured 1'
                    }, {
                      id: 2,
                      name: 'featured 2'
                    }]
                  }
                })
              });
              _context.next = 22;
              return crud.sync();

            case 22:
              t.is(eventStore.count, 1, '1 event received');
              t.is(regularStore.count, 1, '1 record received');
              t.is(featuredStore.count, 1, '1 record received');
              t.is(eventStore.getById(1).name, 'event 1', 'Event record is ok');
              t.is(regularStore.getById(1).name, 'regular 1', 'Record is ok'); // response shouldn't be applied to featured store

              t.is(featuredStore.getById(1).name, 'featured', 'Record is ok');

            case 28:
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
  t.it('Should sync with id field mapped', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var crudManager;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  resources: {
                    rows: [{
                      Id: 1,
                      name: 'Albert'
                    }, {
                      Id: 2,
                      name: 'Brian'
                    }, {
                      Id: 3,
                      name: 'Charles'
                    }]
                  }
                })
              });
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  resources: {
                    rows: [{
                      Id: 1,
                      name: 'event'
                    }],
                    removed: [{
                      Id: 2
                    }, {
                      Id: 3
                    }]
                  }
                })
              });
              crudManager = new CrudManager({
                resourceStore: {
                  fields: [{
                    name: 'id',
                    dataSource: 'Id'
                  }]
                },
                transport: {
                  load: {
                    url: 'load'
                  },
                  sync: {
                    url: 'sync'
                  }
                },
                autoLoad: false,
                autoSync: false
              });
              _context2.next = 5;
              return crudManager.load();

            case 5:
              crudManager.resourceStore.remove(2);
              _context2.next = 8;
              return crudManager.sync();

            case 8:
              t.is(crudManager.resourceStore.count, 1, 'Single resource record found');
              t.is(crudManager.resourceStore.first.id, 1, 'Resource record is correct');

            case 10:
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
  t.it('Sync request fields are mapped according to the dataSource', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var expectedName, crudManager, resourceStore, resource;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  resources: {
                    rows: [{
                      Id: 1,
                      Foo: {
                        Bar: 'Albert'
                      },
                      Age: 30
                    }, {
                      Id: 2,
                      Foo: {
                        Bar: 'Brian'
                      }
                    }]
                  }
                })
              });
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  resources: {
                    rows: [{
                      Id: 1,
                      Age: 40
                    }]
                  }
                })
              });
              expectedName = 'Test', crudManager = new CrudManager({
                resourceStore: {
                  fields: [{
                    name: 'id',
                    dataSource: 'Id'
                  }, {
                    name: 'name',
                    dataSource: 'Foo.Bar'
                  }, {
                    name: 'age',
                    dataSource: 'Age'
                  }]
                },
                transport: {
                  load: {
                    url: 'load'
                  },
                  sync: {
                    url: 'sync'
                  }
                },
                autoLoad: false,
                autoSync: false
              });
              resourceStore = crudManager.resourceStore;
              crudManager.on({
                beforesync: function beforesync(_ref4) {
                  var pack = _ref4.pack;
                  t.isDeeply(pack.resources, {
                    added: [{
                      $PhantomId: resourceStore.last.id,
                      Foo: {
                        Bar: expectedName
                      }
                    }],
                    updated: [{
                      Id: 1,
                      Foo: {
                        Bar: expectedName
                      }
                    }],
                    removed: [{
                      Id: 2
                    }]
                  }, 'Sync request data is ok');
                }
              });
              _context3.next = 7;
              return crudManager.load();

            case 7:
              resource = resourceStore.first;
              t.is(resource.id, 1, 'Resource id is ok');
              t.is(resource.name, 'Albert', 'Resource name is ok');
              resource.name = expectedName;
              resourceStore.add({
                name: expectedName
              });
              resourceStore.remove(2);
              _context3.next = 15;
              return crudManager.sync();

            case 15:
              t.is(resource.age, 40, 'Resource field is updated during sync');

            case 16:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/322

  t.it('Fields with complex mapping should be updated properly', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var crudManager, resourceStore, resource;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  resources: {
                    rows: [{
                      Id: 1,
                      Foo: {
                        Bar: 'Albert'
                      }
                    }, {
                      Id: 2,
                      Foo: {
                        Bar: 'Brian'
                      }
                    }]
                  }
                })
              });
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  resources: {
                    rows: [{
                      Id: 1,
                      Foo: {
                        Bar: 'Chris'
                      }
                    }]
                  }
                })
              });
              crudManager = new CrudManager({
                resourceStore: {
                  fields: [{
                    name: 'id',
                    dataSource: 'Id'
                  }, {
                    name: 'name',
                    dataSource: 'Foo.Bar'
                  }]
                },
                transport: {
                  load: {
                    url: 'load'
                  },
                  sync: {
                    url: 'sync'
                  }
                },
                autoLoad: false,
                autoSync: false
              });
              resourceStore = crudManager.resourceStore;
              _context4.next = 6;
              return crudManager.load();

            case 6:
              resourceStore.add({
                name: 'New resource'
              });
              _context4.next = 9;
              return crudManager.sync();

            case 9:
              resource = resourceStore.getById(1);
              t.is(resource.name, 'Chris', 'Complex resource field is updated during sync');

            case 11:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should properly unbind listeners on removing crud stores', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var resourceStore, eventStore, crud;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              t.mockUrl('test-sync', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  events: {
                    rows: [{
                      id: 1,
                      eventDisplayName: 'First event name'
                    }]
                  }
                })
              });
              resourceStore = t.getResourceStore({}, 5), eventStore = t.getEventStore({}, 5), crud = new CrudManager({
                transport: {
                  sync: {
                    url: 'test-sync'
                  }
                },
                autoSync: true,
                warn: function warn() {}
              });
              crud.addCrudStore(eventStore);
              crud.addCrudStore(resourceStore);
              eventStore.add({
                id: 22,
                name: 'test 1'
              });
              _context5.next = 7;
              return t.waitForEvent(crud, 'sync');

            case 7:
              t.pass('Sync has been called after eventStore update');
              resourceStore.add({
                id: 21,
                name: 'test 1 resource'
              });
              _context5.next = 11;
              return t.waitForEvent(crud, 'sync');

            case 11:
              t.pass('Sync has been called after resourceStore update');
              crud.removeCrudStore(resourceStore);
              t.pass('resourceStore has been removed');
              t.willFireNTimes(crud, 'sync', 3);
              eventStore.add({
                id: 10,
                name: 'bar'
              });
              _context5.next = 18;
              return t.waitForEvent(crud, 'sync');

            case 18:
              t.pass('Sync has been called on eventStore update after remove resourceStore');
              resourceStore.add({
                id: 10,
                name: 'bar'
              });
              crud.addCrudStore(resourceStore);
              resourceStore.add({
                id: 11,
                name: 'foo'
              });
              _context5.next = 24;
              return t.waitForEvent(crud, 'sync');

            case 24:
              t.pass('Sync has been called on resourceStore update after re-add resourceStore');
              eventStore.add({
                id: 24,
                name: 'bar event'
              });
              _context5.next = 28;
              return t.waitForEvent(crud, 'sync');

            case 28:
              t.pass('Sync has been called on eventStore update after re-add resourceStore');

            case 29:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x5) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Should always include any fields marked as alwaysWrite', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var crudManager, resourceStore, spy, callArgs;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'foo',
                      important: 123
                    }, {
                      id: 2,
                      name: 'bar',
                      important: 234
                    }]
                  }
                })
              });
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'foot massage'
                    }]
                  }
                })
              });
              crudManager = new CrudManager({
                resourceStore: {
                  fields: [{
                    name: 'id'
                  }, {
                    name: 'name'
                  }, {
                    name: 'important',
                    alwaysWrite: true
                  }]
                },
                transport: {
                  load: {
                    url: 'load'
                  },
                  sync: {
                    url: 'sync'
                  }
                },
                autoLoad: false,
                autoSync: false
              });
              resourceStore = crudManager.resourceStore;
              _context6.next = 6;
              return crudManager.load();

            case 6:
              resourceStore.first.name = 'foot massage';
              spy = t.spyOn(crudManager, 'sendRequest');
              _context6.next = 10;
              return crudManager.sync();

            case 10:
              callArgs = spy.callsLog[0].args[0];
              t.is(JSON.parse(callArgs.data).resources.updated[0].important, 123, 'Included the important alwaysWrite field');

            case 12:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref7.apply(this, arguments);
    };
  }());
});