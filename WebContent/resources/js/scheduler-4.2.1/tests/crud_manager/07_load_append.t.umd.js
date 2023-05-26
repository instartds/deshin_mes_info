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
  // Here we test that a CRUD manager appends records to a flat store when "append: true" is passed to load() call
  var crudManager, async, callback, response; // dummy transport implementation
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

          window.setTimeout(function () {
            t.ok(response, 'Response exists');
            t.ok(config.success, 'Success called');
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
              t.ok(callback, 'Callback called');
              callback && callback();
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
    crudManager = new TestCrudManager();
  });
  t.it('Appends records to a flat store when "append: true" options is passed to load() call', function (t) {
    async = t.beginAsync();
    var store1 = new Store({
      tree: true,
      fields: ['id'],
      storeId: 'store1',
      data: [{
        expanded: true,
        children: [{
          id: 1,
          leaf: true
        }, {
          id: 2,
          leaf: true
        }, {
          id: 3,
          leaf: true
        }]
      }]
    });
    var store2 = new Store({
      fields: ['id'],
      storeId: 'store2',
      data: [{
        id: 1
      }, {
        id: 2
      }]
    });
    crudManager.addStore(['store1', 'store2']);
    response = {
      success: true,
      store1: {
        rows: [{
          id: 4
        }]
      },
      store2: {
        rows: [{
          id: 3
        }]
      }
    };

    callback = function callback() {
      t.endAsync(async);
      t.is(store1.count, 1, 'Store 1 has the correct amount of records');
      t.is(store2.count, 3, 'Store 2 has the correct amount of records');
      t.is(store1.last.get('id'), 4, 'Store 1 last record is correct');
      t.is(store2.last.get('id'), 3, 'Store 2 last record is correct');
      t.isDeeplyUnordered(store1.records, [store1.getById(4)], 'store1 has proper set of records');
      t.isDeeplyUnordered(store2.records, [store2.getById(1), store2.getById(2), store2.getById(3)], 'store2 has proper set of records');
    }; // It triggers sendRequest function therefore callback will be called


    crudManager.load({
      store2: {
        append: true
      }
    });
  });
});