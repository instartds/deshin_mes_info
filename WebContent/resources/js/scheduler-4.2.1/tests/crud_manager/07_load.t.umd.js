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
  // Here we test load() method of AbstractCrudManager class
  var sent = 0; // dummy transport implementation
  // just waits for 50ms and then calls the successful callback

  var response = [],
      TestTransport = function TestTransport(Base) {
    return /*#__PURE__*/function (_ref) {
      _inherits(_class, _ref);

      var _super = _createSuper(_class);

      function _class() {
        _classCallCheck(this, _class);

        return _super.apply(this, arguments);
      }

      _createClass(_class, [{
        key: "sendRequest",
        value: function sendRequest(config) {
          var _this = this;

          var r = response[sent];
          sent++;
          window.setTimeout(function () {
            return config[_this.testRequestMethod || 'success'].call(config.thisObj || _this, {
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
            }, null, config);
          }, 50);
        }
      }]);

      return _class;
    }(Base || /*#__PURE__*/function () {
      function _class2() {
        _classCallCheck(this, _class2);
      }

      return _class2;
    }());
  };

  var TestCrudManager1 = /*#__PURE__*/function (_TestTransport) {
    _inherits(TestCrudManager1, _TestTransport);

    var _super2 = _createSuper(TestCrudManager1);

    function TestCrudManager1() {
      _classCallCheck(this, TestCrudManager1);

      return _super2.apply(this, arguments);
    }

    return TestCrudManager1;
  }(TestTransport(JsonEncoder(AbstractCrudManager)));

  var someStore1, someStore2, crud;

  function initTestData() {
    someStore1 = new Store({
      storeId: 'someStore1',
      fields: ['id', 'ff1', 'ff2']
    });
    someStore2 = new Store({
      tree: true,
      storeId: 'someStore2',
      fields: ['id', 'f1', 'f2']
    });
    crud = new TestCrudManager1({
      stores: [someStore1, someStore2]
    }); // server response for this set of changes

    response.push({
      success: true,
      revision: 99,
      someStore1: {
        rows: [{
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
      },
      someStore2: {
        rows: [{
          id: 0,
          f1: 'root',
          f2: 'root',
          children: [{
            id: 1,
            f1: '11',
            f2: '111',
            leaf: true
          }, {
            id: 2,
            f1: '22',
            f2: '222',
            leaf: true
          }, {
            id: 3,
            f1: '33',
            f2: '333',
            leaf: true
          }, {
            id: 4,
            f1: '44',
            f2: '444',
            leaf: true
          }, {
            id: 5,
            f1: '55',
            f2: '555',
            children: [{
              id: 6,
              f1: '66',
              f2: '666',
              leaf: true
            }, {
              id: 7,
              f1: '77',
              f2: '777',
              leaf: true
            }]
          }]
        }]
      }
    });
  }

  t.it('Loads data', function (t) {
    initTestData();
    t.is(crud.isLoading, false, 'not loading now');
    t.willFireNTimes(crud, 'beforeload', 1);
    t.willFireNTimes(crud, 'beforeloadapply', 1);
    t.willFireNTimes(crud, 'load', 1);
    t.willFireNTimes(crud, 'nochanges', 1);
    t.willFireNTimes(someStore1, 'loadstart', 1);
    t.willFireNTimes(someStore1, 'afterrequest', 1);
    t.beginAsync();
    var promise = crud.load();
    t.is(crud.isLoading, true, 'loading when operation is started');
    promise.then(function () {
      t.is(crud.isLoading, false, 'not loading when operation is finished');
      t.endAsync();
      t.is(crud.revision, 99, 'revision applied');
      t.it('Applies response to someStore1', function (t) {
        t.notOk(someStore1.modified.count, 'has no dirty updated records');
        t.notOk(someStore1.removed.count, 'has no dirty removed records');
        t.is(someStore1.getById(11).get('ff1'), '11', '#11: correct ff1 field value');
        t.is(someStore1.getById(11).get('ff2'), '111', '#11: correct ff2 field value');
        t.is(someStore1.getById(12).get('ff1'), '22', '#12: correct ff1 field value');
        t.is(someStore1.getById(12).get('ff2'), '222', '#12: correct ff2 field value');
        t.is(someStore1.getById(13).get('ff1'), '33', '#13: correct ff1 field value');
        t.is(someStore1.getById(13).get('ff2'), '333', '#13: correct ff2 field value');
      });
      t.it('Applies response to someStore2', function (t) {
        t.notOk(someStore2.modified.count, 'has no dirty updated records');
        t.notOk(someStore2.removed.count, 'has no dirty removed records');
        t.is(someStore2.getById(1).get('f1'), '11', 'correct f1 field value');
        t.is(someStore2.getById(1).get('f2'), '111', 'correct f2 field value');
        t.is(someStore2.getById(2).get('f1'), '22', 'correct f1 field value');
        t.is(someStore2.getById(2).get('f2'), '222', 'correct f2 field value');
        t.is(someStore2.getById(3).get('f1'), '33', 'correct f1 field value');
        t.is(someStore2.getById(3).get('f2'), '333', 'correct f2 field value');
        t.is(someStore2.getById(4).get('f1'), '44', 'correct f1 field value');
        t.is(someStore2.getById(4).get('f2'), '444', 'correct f2 field value');
        t.is(someStore2.getById(5).get('f1'), '55', 'correct f1 field value');
        t.is(someStore2.getById(5).get('f2'), '555', 'correct f2 field value');
        t.is(someStore2.getById(6).get('f1'), '66', 'correct f1 field value');
        t.is(someStore2.getById(6).get('f2'), '666', 'correct f2 field value');
        t.is(someStore2.getById(7).get('f1'), '77', 'correct f1 field value');
        t.is(someStore2.getById(7).get('f2'), '777', 'correct f2 field value');
      });
    });
    t.is(sent, 1, 'Load packet sent');
  });
  t.it('Fires loadfail on AJAX errors', function (t) {
    var crud = new CrudManager({
      resourceStore: t.getResourceStore({}, 5),
      eventStore: t.getEventStore({}, 5),
      transport: {
        load: {
          url: 'foo'
        }
      },
      warn: function warn() {},
      listeners: {
        requestFail: function requestFail(event) {
          t.it('requestFail event params', function (t) {
            t.is(event.requestType, 'load');
            t.is(event.response, null);
            t.ok(event.responseText);
            t.ok(event.responseOptions);
          });
        },
        loadFail: function loadFail(event) {
          t.it('loadFail event params', function (t) {
            t.is(event.response, null);
            t.ok(event.responseText);
            t.ok(event.responseOptions);
            t.ok('options' in event);
          });
        }
      }
    });
    t.willFireNTimes(crud, 'loadfail', 1);
    var async = t.beginAsync();
    t.is(crud.isLoading, false, 'not loading now');
    crud.on('loadstart', function () {
      t.is(crud.isLoading, true, 'isLoading inside loadstart listener');
    });
    var promise = crud.load();
    t.is(crud.isLoading, true, 'loading now');
    promise.then(function () {
      return t.endAsync(async);
    }, function () {
      t.endAsync(async);
      t.is(crud.isLoading, false, 'not loading now');
    });
  });
  t.it('Promises do work', function (t) {
    initTestData();
    crud.on({
      beforeload: function beforeload() {
        return false;
      },
      once: true
    });
    t.chain(function (next) {
      crud.load().then(function () {}, function (_ref2) {
        var cancelled = _ref2.cancelled;
        t.ok(cancelled, 'Request was cancelled');
        next();
      });
    }, function (next) {
      crud.testRequestMethod = 'failure';
      crud.load().then(function () {}, function (response) {
        t.notOk(response.cancelled, 'Request was not sent');
        next();
      });
    }, function (next) {
      delete crud.testRequestMethod;
      sent = 0;
      crud.load().then(function (_ref3) {
        var response = _ref3.response;
        t.is(response.success, true, 'Response successful');
        next();
      }, function () {
        t.fail('Response should be successful');
      });
    }, // This step is required to make previous step stable without begin/endAsync
    function (next) {});
  });
  t.it('Should cancel load request', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var cm, handler, cancelled;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              cm = new CrudManager({
                transport: {
                  load: {
                    url: 'foo'
                  }
                }
              });
              t.firesOk({
                observable: cm,
                events: {
                  beforeLoad: 2,
                  load: 1
                }
              }); // unhandled rejection handle is disabled in this test, but we need it in this particular test

              handler = function handler(event) {
                t.fail("Unhandled promise rejection: ".concat(event.reason));
              };

              window.addEventListener('unhandledrejection', handler);
              cancelled = false; // Call first load to scheduler request, do not wait for it to end

              cm.load().catch(function (reason) {
                if (reason.cancelled) {
                  cancelled = true;
                }
              });
              t.mockUrl('foo', {
                responseText: JSON.stringify({
                  success: true
                })
              }); // Call load once again, first request should get cancelled

              _context.next = 9;
              return cm.load();

            case 9:
              t.ok(cancelled, 'First load was cancelled');
              window.removeEventListener('unhandledrejection', handler);

            case 11:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should handle server responding garbage / 500 error', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var async, AutoLoadCrudManager, consoleWarn, cm;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              async = t.beginAsync();

              AutoLoadCrudManager = /*#__PURE__*/function (_CrudManager) {
                _inherits(AutoLoadCrudManager, _CrudManager);

                var _super3 = _createSuper(AutoLoadCrudManager);

                function AutoLoadCrudManager() {
                  _classCallCheck(this, AutoLoadCrudManager);

                  return _super3.apply(this, arguments);
                }

                _createClass(AutoLoadCrudManager, [{
                  key: "onLoadFail",
                  value: // We don't use Siesta means to track the event to let CrudManager output to console
                  function onLoadFail() {
                    t.endAsync(async);
                    t.pass('loadFail is triggered');
                  }
                }]);

                return AutoLoadCrudManager;
              }(CrudManager);

              t.failOnPromiseRejection = false;
              consoleWarn = t.spyOn(t.global.console, 'warn').and.callThrough();
              cm = new AutoLoadCrudManager({
                autoLoad: true,
                transport: {
                  load: {
                    url: 'missingUrl'
                  },
                  sync: {
                    url: 'missingUrl'
                  }
                }
              });
              _context2.next = 7;
              return t.waitFor(function () {
                return !cm.isCrudManagerLoading;
              });

            case 7:
              // Only run in debug env
              if (VersionHelper.isDebug) {
                t.expect(consoleWarn).toHaveBeenCalledWith(t.anyStringLike('CrudManager error while auto-loading the data (please setup "loadFail" or "requestFail" event listeners to handle such cases)'), t.any());
              }

            case 8:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should handle server responding 200 but malformed JSON', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var async, consoleWarn, AutoLoadCrudManager, cm;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              async = t.beginAsync();
              consoleWarn = t.spyOn(t.global.console, 'warn').and.callThrough();
              t.spyOn(t.global.console, 'error').and.stub();

              AutoLoadCrudManager = /*#__PURE__*/function (_CrudManager2) {
                _inherits(AutoLoadCrudManager, _CrudManager2);

                var _super4 = _createSuper(AutoLoadCrudManager);

                function AutoLoadCrudManager() {
                  _classCallCheck(this, AutoLoadCrudManager);

                  return _super4.apply(this, arguments);
                }

                _createClass(AutoLoadCrudManager, [{
                  key: "onLoadFail",
                  value: // We don't use Siesta means to track the event to let CrudManager output to console
                  function onLoadFail() {
                    t.endAsync(async);
                    t.pass('loadFail is triggered');
                  }
                }]);

                return AutoLoadCrudManager;
              }(CrudManager);

              cm = new AutoLoadCrudManager({
                autoLoad: true,
                transport: {
                  load: {
                    url: 'crud_manager/mockresponses/badjson.json'
                  },
                  sync: {
                    url: 'crud_manager/mockresponses/badjson.json'
                  }
                }
              });
              _context3.next = 7;
              return t.waitFor(function () {
                return !cm.isCrudManagerLoading;
              });

            case 7:
              // Only run in debug env
              if (VersionHelper.isDebug) {
                t.expect(consoleWarn).toHaveBeenCalledWith(t.anyStringLike('CrudManager error while auto-loading the data (please setup "loadFail" or "requestFail" event listeners to handle such cases)'), t.any());
              }

            case 8:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref6.apply(this, arguments);
    };
  }()); // NOTE: This will not work now without a project connecting the stores. TODO: Remove?

  t.xit('Should update dependent stores', function (t) {
    var crud = new CrudManager({
      autoLoad: true,
      transport: {
        load: {
          url: 'crud_manager/mockresponses/resourcetree.json'
        }
      }
    });
    var async = t.beginAsync();
    crud.on({
      load: function load() {
        crud.eventStore.forEach(function (record) {
          t.isInstanceof(record.resource, ResourceModel, 'Resource reference is ok');
        });
        t.endAsync(async);
      }
    });
  });
  t.it('Triggering new load while loading is ongoing should not lead to exception in console', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var crud;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              crud = new CrudManager({
                transport: {
                  load: {
                    url: 'crud_manager/mockresponses/resourcetree.json'
                  }
                }
              });
              crud.load().catch(function (_ref8) {
                var cancelled = _ref8.cancelled;
                // TODO the code never steps in here
                t.ok(cancelled);
              });
              _context4.next = 4;
              return crud.load();

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Should support having query params in the URL', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var crud, spy, url;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              crud = new CrudManager({
                transport: {
                  load: {
                    url: 'params?foo=bar'
                  }
                }
              });
              spy = t.spyOn(window, 'fetch').callFake(function () {
                return new Promise(function () {});
              });
              crud.load();
              url = spy.callsLog[0].args[0];
              t.ok(url.startsWith('params?foo=bar&data='), 'Params appended to URL with &');

            case 5:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x5) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Should handle stores being destroyed during load', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var promise;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              initTestData();
              promise = crud.load();
              someStore2.destroy();
              _context6.next = 5;
              return promise;

            case 5:
              t.is(someStore1.getById(11).get('ff1'), '11', 'Other store loaded correctly');

            case 6:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref10.apply(this, arguments);
    };
  }());
});