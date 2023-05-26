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
  var crudManager, response, assertionsFn, async;

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

          window.setTimeout(function () {
            config.success.call(config.thisObj || _this, {
              ok: false,
              redirected: false,
              status: 200,
              statusText: 'OK',
              text: function text() {
                return new Promise(function (resolve) {
                  resolve(JSON.stringify(response));
                });
              },
              json: function json() {
                return new Promise(function (resolve) {
                  resolve(response);
                });
              }
            }, null, config).then(function () {
              assertionsFn && assertionsFn();
            });
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

  var TestCrudManager = /*#__PURE__*/function (_TestTransport) {
    _inherits(TestCrudManager, _TestTransport);

    var _super2 = _createSuper(TestCrudManager);

    function TestCrudManager() {
      _classCallCheck(this, TestCrudManager);

      return _super2.apply(this, arguments);
    }

    return TestCrudManager;
  }(TestTransport(JsonEncoder(AbstractCrudManager)));

  t.beforeEach(function () {
    crudManager && crudManager.destroy();
    crudManager = new TestCrudManager({
      trackResponseType: true
    });
  });
  t.it('CrudManager handles "sync" response on "load" request for a flat store', function (t) {
    async = t.beginAsync();
    var store1 = new Store({
      fields: ['id', 'text1'],
      storeId: 'store1',
      data: [{
        id: 1,
        text1: 'foo'
      }, {
        id: 2,
        text1: 'bar'
      }]
    });
    crudManager.addStore(store1);
    response = {
      type: 'sync',
      success: true,
      store1: {
        rows: [{
          id: 1,
          text1: 'new text1'
        }, {
          id: 3,
          text1: 'new row'
        }],
        removed: [{
          id: 2
        }]
      }
    };
    t.wontFire(store1, 'load');

    assertionsFn = function assertionsFn() {
      t.endAsync(async);
      t.isDeeplyUnordered(store1.records, [store1.getById(1), store1.getById(3)], 'store1 has proper set of records');
      t.notOk(store1.changes, 'store1 has no changes');
    };

    crudManager.load();
  });
  t.it('CrudManager handles "sync" response on "load" request for a tree store', function (t) {
    async = t.beginAsync();
    var store1 = new Store({
      fields: ['id', 'text1'],
      storeId: 'store1',
      tree: true,
      data: [{
        id: 1,
        text1: 'node-1',
        leaf: true
      }, {
        id: 2,
        text1: 'node-2',
        expanded: true,
        children: [{
          id: 21,
          text1: 'node-21',
          leaf: true
        }, {
          id: 22,
          text1: 'node-22',
          leaf: true
        }]
      }, {
        id: 3,
        text1: 'node-3'
      }]
    });
    crudManager.addStore(store1);
    response = {
      type: 'sync',
      success: true,
      store1: {
        rows: [{
          id: 4,
          text1: 'node-4'
        }, {
          id: 23,
          text1: 'node-23',
          parentId: 2
        }, {
          id: 2,
          parentId: 1
        }, {
          id: 5,
          text1: 'node-5',
          expanded: true,
          children: [{
            id: 51,
            text1: 'node-51',
            leaf: true
          }, {
            id: 52,
            text1: 'node-52',
            leaf: true
          }]
        }],
        removed: [{
          id: 21
        }]
      }
    };
    t.wontFire(store1, 'load');

    assertionsFn = function assertionsFn() {
      t.endAsync(async);
      t.notOk(store1.changes, 'store1 has no changes');
      t.isDeeplyUnordered(store1.allRecords, [store1.getById(1), store1.getById(2), store1.getById(22), store1.getById(23), store1.getById(3), store1.getById(4), store1.getById(5), store1.getById(51), store1.getById(52)], 'store1 has proper set of records');
      t.isDeeplyUnordered(store1.rootNode.children, [store1.getById(1), store1.getById(3), store1.getById(4), store1.getById(5)], 'root has proper set of children');
      t.isDeeplyUnordered(store1.getById(1).children, [store1.getById(2)], 'node-1 has proper set of children');
      t.notOk(store1.getById(3).children, 'node-3 has proper set of children');
      t.notOk(store1.getById(4).children, 'node-4 has proper set of children');
      t.isDeeplyUnordered(store1.getById(5).children, [store1.getById(51), store1.getById(52)], 'node-5 has proper set of children');
      t.isDeeplyUnordered(store1.getById(2).children, [store1.getById(22), store1.getById(23)], 'node-2 has proper set of children');
    };

    crudManager.load();
  });
});