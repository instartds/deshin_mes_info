function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

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
  // Here we test autoSync config of AbstractCrudManager class
  var sent = 0; // dummy transport implementation
  // just waits for 50ms and then calls the successful callback

  var TestTransport = function TestTransport(Base) {
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
          t.it('Packet contains all changes', function (t) {
            t.ok(config.data.someStore1.added.length, 'someStore1 added records');
            t.ok(config.data.someStore1.updated.length, 'someStore1 updated records');
            t.ok(config.data.someStore1.removed.length, 'someStore1 removed records');
            t.ok(config.data.someStore2.added.length, 'someStore2 added records');
            t.ok(config.data.someStore2.updated.length, 'someStore2 updated records');
            t.ok(config.data.someStore2.removed.length, 'someStore2 removed records');
          });
          window.setTimeout(function () {
            return config.success.call(config.thisObj || _this, {
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

    _createClass(TestCrudManager1, [{
      key: "encode",
      value: function encode(data) {
        return data;
      }
    }]);

    return TestCrudManager1;
  }(TestTransport(JsonEncoder(AbstractCrudManager)));

  var someStore1,
      someStore2,
      crud,
      added1,
      added2,
      response = [];

  var initTestData = function initTestData() {
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
      stores: [someStore1, someStore2],
      autoSync: true
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

  t.it('Automatically invokes sync() when autoSync=True', function (t) {
    initTestData(); // we do not call sync() since crud manager has to catch stores changes made inside initTestData() call

    t.willFireNTimes(crud, 'beforesync', 1);
    t.willFireNTimes(crud, 'beforesyncapply', 1);
    t.willFireNTimes(crud, 'sync', 1);
    t.waitForEvent(crud, 'sync', function () {
      t.is(sent, 1, 'Sent only one sync packet');
      t.it('Applies response to someStore1', function (t) {
        t.notOk(someStore1.modified.count, 'has no dirty updated records');
        t.notOk(someStore1.removed.count, 'has no dirty removed records');
        t.is(someStore1.getById(14).get('ff1'), 'new', 'added record has correct ff1 field value');
        t.is(someStore1.getById(14).get('ff2'), 'new', 'added record has correct ff2 field value');
        t.is(someStore1.getById(12).get('ff2'), '-222', 'updated record has correct ff2 field value');
      });
      t.it('Applies response to someStore2', function (t) {
        t.notOk(someStore2.modified.count, 'has no dirty updated records');
        t.notOk(someStore2.removed.count, 'has no dirty removed records');
        t.is(someStore2.getById(5).get('f1'), '55', 'added record has correct f1 field value');
        t.is(someStore2.getById(5).get('f2'), '555', 'added record has correct f2 field value');
        t.is(someStore2.getById(3).get('f2'), '-333', 'updated record has correct f2 field value');
      });
    });
  });
});