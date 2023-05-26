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
  // Test check that we call setCrudManager (if provided) on a store when registering it in a CrudManager
  // and that we set "crudManager" on the store otherwise
  //t.expectGlobal('TestCrudManager1', 'Store2');
  var Store2 = /*#__PURE__*/function (_Store) {
    _inherits(Store2, _Store);

    var _super = _createSuper(Store2);

    function Store2() {
      _classCallCheck(this, Store2);

      return _super.apply(this, arguments);
    }

    _createClass(Store2, [{
      key: "setCrudManager",
      value: function setCrudManager(cm) {
        this.foo = cm;
      }
    }]);

    return Store2;
  }(Store);

  var TestCrudManager1 = /*#__PURE__*/function (_AbstractCrudManager) {
    _inherits(TestCrudManager1, _AbstractCrudManager);

    var _super2 = _createSuper(TestCrudManager1);

    function TestCrudManager1() {
      _classCallCheck(this, TestCrudManager1);

      return _super2.call(this, {
        stores: [{
          storeId: 'store1',
          store: new Store()
        }, {
          storeId: 'store2',
          store: new Store2()
        }]
      });
    }

    return TestCrudManager1;
  }(AbstractCrudManager);

  t.it('CrudManager call a registered store setCrudManager hook (or decorates it w/ crudManager property)', function (t) {
    var crud = new TestCrudManager1();
    t.is(crud.getStore('store1').crudManager, crud, 'store1 is decorated');
    t.is(crud.getStore('store2').foo, crud, 'setCrudManager is called on store2');
  });
});