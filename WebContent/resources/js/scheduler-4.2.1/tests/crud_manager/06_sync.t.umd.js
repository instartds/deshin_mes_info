function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

StartTest(function (t) {
  t.diag('Here we test sync() method of AbstractCrudManager class');
  var sent, received, someStore1, someStore2, crud, added1, added2, response; // dummy transport implementation
  // just waits for 50ms and then calls the successful callback

  var TestTransport = function TestTransport(Base) {
    return /*#__PURE__*/function (_Base) {
      _inherits(_class, _Base);

      var _super = _createSuper(_class);

      function _class() {
        _classCallCheck(this, _class);

        return _super.apply(this, arguments);
      }

      _createClass(_class, [{
        key: "sendRequest",
        value: function sendRequest(config) {
          var _this = this;

          var r = response[sent],
              me = this;
          sent++;
          window.setTimeout(function () {
            // The callbacks receive the Fetch API's Response object
            // So we fab one up with a fail code and blank response text here.
            if (_this.testRequestMethod === 'failure') {
              config.failure.call(config.thisObj, {
                ok: false,
                redirected: false,
                status: 500,
                statusText: 'Internal Server Error',
                text: function text() {
                  return new Promise(function (resolve) {
                    resolve('');
                  });
                },
                json: function json() {
                  return new Promise(function (resolve) {
                    resolve({});
                  });
                }
              }, null, {
                type: config.type,
                id: config.id
              });
            } else {
              config.success.call(config.thisObj || _this, {
                ok: false,
                redirected: false,
                status: 200,
                statusText: 'OK',
                text: function text() {
                  return new Promise(function (resolve) {
                    resolve(JSON.stringify(r));
                  });
                },
                json: function json() {
                  return new Promise(function (resolve) {
                    resolve(r);
                  });
                }
              }, null, {
                type: config.type,
                id: config.id
              }).then(function () {
                if (r && r.success) {
                  me.test.is(me.revision, r.revision, 'revision applied');
                }

                received++;
              });
            }
          }, 50);
        }
      }]);

      return _class;
    }(Base);
  };

  var TestCrudManager1 = /*#__PURE__*/function (_JsonEncoder) {
    _inherits(TestCrudManager1, _JsonEncoder);

    var _super2 = _createSuper(TestCrudManager1);

    function TestCrudManager1() {
      _classCallCheck(this, TestCrudManager1);

      return _super2.apply(this, arguments);
    }

    _createClass(TestCrudManager1, [{
      key: "warn",
      value: function warn() {}
    }]);

    return TestCrudManager1;
  }(JsonEncoder(TestTransport(AbstractCrudManager)));

  var initTestData = function initTestData(t) {
    // reset requests number
    sent = 0;
    received = 0;
    response = [];
    someStore1 = new Store({
      storeId: 'someStore1',
      fields: ['id', 'ff1', 'ff2'],
      data: [{
        id: 11,
        ff1: '11',
        ff2: '111'
      }, {
        id: 12,
        ff1: '22',
        ff2: '222'
      }, {
        id: 13,
        ff1: '33',
        ff2: '333'
      }]
    });
    someStore2 = new Store({
      tree: true,
      storeId: 'someStore2',
      fields: ['id', 'f1', 'f2'],
      data: [{
        expanded: true,
        children: [{
          id: 1,
          f1: '11',
          f2: '111'
        }, {
          id: 2,
          f1: '22',
          f2: '222'
        }, {
          id: 3,
          f1: '33',
          f2: '333'
        }, {
          id: 4,
          f1: '44',
          f2: '444'
        }]
      }]
    });
    crud = new TestCrudManager1({
      test: t,
      stores: [someStore1, someStore2],
      revision: 1
    }); // init stores changes
    // someStore1

    someStore1.remove(someStore1.getById(11));
    someStore1.getById(12).set('ff1', '-22');
    added1 = someStore1.add({
      ff1: 'new',
      ff2: 'new'
    }); // someStore2

    someStore2.first.removeChild(someStore2.getById(4));
    someStore2.getById(3).set('f1', '-33');
    added2 = someStore2.getById(3).appendChild({
      f1: '55',
      f2: '555'
    }); // server response for this set of changes

    response.push({
      revision: 2,
      success: true,
      someStore1: {
        rows: [{
          $PhantomId: added1[0].id,
          id: 14
        }, {
          id: 12,
          ff2: '-222'
        }],
        removed: [{
          id: 11
        }]
      },
      someStore2: {
        rows: [{
          $PhantomId: added2.id,
          id: 5
        }, {
          id: 3,
          f2: '-333'
        }],
        removed: [{
          id: 4
        }]
      }
    });
  };

  t.it('Delays the sending of sync packet while previous is not responded', function (t) {
    initTestData(t); // we expect one syncdelayed since one of sync() calls are delayed

    t.willFireNTimes(crud, 'syncdelayed', 1); // successful sync() calls have to return following events

    t.willFireNTimes(crud, 'beforesync', 2);
    t.willFireNTimes(crud, 'beforesyncapply', 2);
    t.willFireNTimes(crud, 'sync', 2); // call sync for the 1st time

    var promise1 = crud.sync();
    t.is(crud.activeSyncPromise, promise1, 'First sync promise is active');
    promise1.then(function () {
      t.is(crud.activeSyncPromise, promise2, 'First sync promise is resolved and second promise started');
    }); // add one more record

    var a = someStore1.add({
      ff1: 'another new',
      ff2: 'another new'
    }); // server response for this change

    response.push({
      success: true,
      revision: 3,
      someStore1: {
        rows: [{
          $PhantomId: a[0].id,
          id: 15
        }]
      }
    }); // now we call sync again but the 1st call is not responded yet
    // so crud manager will delay 2nd sync call and re-call it
    // after 1st packet get responded

    var promise2 = crud.sync();
    t.is(crud.activeSyncPromise, promise2, 'Queued second sync promise');
    t.is(sent, 1, 'Sent only 1st sync packet');
    t.waitFor(function () {
      return someStore1.modified.count === 0 && someStore2.modified.count === 0 && sent === 2 && received === 2;
    }, function () {
      t.it('Applies response to someStore1', function (t) {
        t.notOk(someStore1.modified.count, 'has no dirty updated records');
        t.notOk(someStore1.removed.count, 'has no dirty removed records');
        t.is(someStore1.getById(14).get('ff1'), 'new', 'added record has correct ff1 field value');
        t.is(someStore1.getById(14).get('ff2'), 'new', 'added record has correct ff2 field value');
        t.is(someStore1.getById(12).get('ff2'), '-222', 'updated record has correct ff2 field value');
        var newRec = someStore1.getById(15);
        t.ok(newRec, 'Another added record found'); // to get better debugging info from TC on fail

        if (newRec) {
          t.is(newRec.get('ff1'), 'another new', 'another added record has correct ff1 field value');
          t.is(newRec.get('ff2'), 'another new', 'another added record has correct ff2 field value');
        }
      });
      t.it('Applies response to someStore2', function (t) {
        t.notOk(someStore2.modified.count, 'has no dirty updated records');
        t.notOk(someStore2.removed.count, 'has no dirty removed records');
        t.is(someStore2.getById(5).get('f1'), '55', 'added record has correct f1 field value');
        t.is(someStore2.getById(5).get('f2'), '555', 'added record has correct f2 field value');
        t.is(someStore2.getById(3).get('f2'), '-333', 'updated record has correct f2 field value');
      });
      scenario2(t);
    });
  });
  t.it('Fires syncfail on AJAX errors', function (t) {
    var resourceStore = t.getResourceStore({}, 5);
    var crud = new CrudManager({
      resourceStore: resourceStore,
      eventStore: t.getEventStore({}, 5),
      transport: {
        sync: {
          url: 'foo'
        }
      },
      warn: function warn() {},
      listeners: {
        requestFail: function requestFail(event) {
          t.it('requestFail event params', function (t) {
            t.is(event.requestType, 'sync');
            t.is(event.response, null);
            t.ok(event.responseText);
            t.ok(event.responseOptions);
          });
        },
        syncFail: function syncFail(event) {
          t.it('loadFail event params', function (t) {
            t.is(event.response, null);
            t.ok(event.responseText);
            t.ok(event.responseOptions);
            t.ok('options' in event);
          });
        }
      }
    });
    t.willFireNTimes(crud, 'syncfail', 1);
    resourceStore.add({
      name: 'bar'
    });
    var async = t.beginAsync();
    crud.sync().then(function () {
      return t.endAsync(async);
    }, function () {
      return t.endAsync(async);
    });
  });

  function scenario2(t) {
    t.it('Fires syncfail event if response is empty', function (t) {
      initTestData(t);
      t.willFireNTimes(crud, 'syncfail', 1);
      response.length = 0;
      var called = 0;
      t.waitForEvent(crud, 'syncfail', function () {
        t.waitFor(function () {
          return called === 1;
        }, function () {
          scenario3(t);
        });
      });
      crud.sync().then(function () {}, function () {
        called++;
        t.pass('Promise rejected successfully');
      });
    });
  }

  function scenario3(t) {
    t.it('Fires syncfail event if response.success is empty', function (t) {
      initTestData(t);
      t.willFireNTimes(crud, 'syncfail', 1);
      delete response[0].success;
      var called = 0;
      t.waitForEvent(crud, 'syncfail', function () {
        t.waitFor(function () {
          return called === 1;
        }, function () {
          return t.pass('Rejected successfully');
        });
      });
      crud.sync().then(function () {}, function () {
        called++;
        t.pass('Promise rejected successfully');
      });
    });
  }

  t.it('Promises work ok', function (t) {
    initTestData(t);
    t.chain(function (next) {
      crud.on({
        beforeSync: function beforeSync() {
          return false;
        },
        once: true
      });
      crud.sync().then(function (_ref) {
        var cancelled = _ref.cancelled;
        t.pass('Sync request cancelled ok');
        t.ok(cancelled, 'Reason is ok');
        next();
      });
    }, function (next) {
      someStore1.add({
        ff1: 'another new',
        ff2: 'another new'
      });
      crud.testRequestMethod = 'failure';
      crud.sync().then(function () {}, function (_ref2) {
        var cancelled = _ref2.cancelled;
        t.pass('Request was not successful ok');
        t.notOk(cancelled, 'Reason is ok');
        next();
      });
    }, function (next) {
      delete crud.testRequestMethod;
      sent = 0;
      crud.sync().then(function () {
        t.pass('Request was successful');
        next();
      }, function () {
        t.fail('Request should be successful');
      });
    }, // This step is required to make previous step stable without begin/endAsync
    function (next) {});
  });
  t.it('Should not try to sync invalid record', function (t) {
    var Resource = /*#__PURE__*/function (_ResourceModel) {
      _inherits(Resource, _ResourceModel);

      var _super3 = _createSuper(Resource);

      function Resource() {
        _classCallCheck(this, Resource);

        return _super3.apply(this, arguments);
      }

      _createClass(Resource, [{
        key: "isValid",
        get: function get() {
          return Boolean(this.name);
        }
      }]);

      return Resource;
    }(ResourceModel);

    var resourceStore = t.getResourceStore({
      modelClass: Resource
    }, 5);
    var crud = new CrudManager({
      autoSync: true,
      resourceStore: resourceStore,
      eventStore: t.getEventStore({}, 5),
      transport: {
        sync: {
          url: 'foo'
        }
      },
      warn: function warn() {}
    });
    t.wontFire(crud, 'beforesync');
    var newResource = new Resource();
    resourceStore.add(newResource);
    var async = t.beginAsync();
    crud.sync().then(function () {
      return t.endAsync(async);
    }, function () {
      return t.endAsync(async);
    });
  });
  t.it('sync should work with fields with a dataSource', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var MyEventRec, crud;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              MyEventRec = /*#__PURE__*/function (_EventModel) {
                _inherits(MyEventRec, _EventModel);

                var _super4 = _createSuper(MyEventRec);

                function MyEventRec() {
                  _classCallCheck(this, MyEventRec);

                  return _super4.apply(this, arguments);
                }

                _createClass(MyEventRec, null, [{
                  key: "fields",
                  get: function get() {
                    return [{
                      name: 'name',
                      type: 'string',
                      dataSource: 'eventDisplayName'
                    }];
                  }
                }]);

                return MyEventRec;
              }(EventModel);

              t.mockUrl('test-sync-with-dataSource', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  events: {
                    rows: [{
                      id: 1,
                      eventDisplayName: 'First event name after sync'
                    }]
                  }
                })
              });
              crud = new CrudManager({
                project: new ProjectModel({
                  eventStore: t.getEventStore({
                    modelClass: MyEventRec,
                    data: [{
                      id: 1,
                      eventDisplayName: 'First event start name'
                    }]
                  }, 5)
                }),
                transport: {
                  sync: {
                    url: 'test-sync-with-dataSource'
                  }
                },
                warn: function warn() {}
              });
              _context.next = 5;
              return t.waitForProjectReady(crud);

            case 5:
              t.is(crud.eventStore.first.name, 'First event start name'); // This will be attempted to be synced, but the server will override, returning its own new name

              crud.eventStore.first.name = 'Attempt to set the name';
              _context.next = 9;
              return crud.sync();

            case 9:
              t.is(crud.eventStore.first.name, 'First event name after sync');

            case 10:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Should support suspendAutoSync/resumeAutoSync', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var crud, spy;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              crud = new CrudManager({
                autoSyncTimeout: 0,
                project: new ProjectModel({
                  eventStore: t.getEventStore({
                    data: [{
                      id: 1,
                      eventDisplayName: 'First event start name'
                    }]
                  })
                }),
                autoSync: true
              });
              spy = t.spyOn(crud, 'sync');
              crud.suspendAutoSync();
              crud.suspendAutoSync();
              t.expect(crud.autoSyncSuspendCounter).toBe(2);
              t.expect(spy.calls.count()).toBe(0);
              crud.resumeAutoSync();
              t.expect(spy.calls.count()).toBe(0);
              t.expect(crud.autoSyncSuspendCounter).toBe(1); // this should trigger a schedule of sync() which is delayed by 0ms

              crud.resumeAutoSync();
              _context2.next = 12;
              return t.waitFor(function () {
                return spy.calls.count() === 1;
              });

            case 12:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should not call sync if resumeAutoSync is called with false', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var crud, spy;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              crud = new CrudManager({
                autoSyncTimeout: 0,
                project: new ProjectModel({
                  eventStore: t.getEventStore({
                    data: [{
                      id: 1,
                      eventDisplayName: 'First event start name'
                    }]
                  })
                }),
                autoSync: true
              });
              spy = t.spyOn(crud, 'sync');
              crud.suspendAutoSync();
              t.expect(crud.autoSyncSuspendCounter).toBe(1);
              t.expect(spy.calls.count()).toBe(0);
              crud.resumeAutoSync(false); // wait a bit to allow setTimeout 0 to expire

              _context3.next = 8;
              return t.waitFor(50);

            case 8:
              t.expect(spy.calls.count()).toBe(0);

            case 9:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref5.apply(this, arguments);
    };
  }());
});