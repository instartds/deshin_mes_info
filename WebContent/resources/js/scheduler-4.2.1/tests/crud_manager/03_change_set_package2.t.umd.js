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
  var TestModel = /*#__PURE__*/function (_Model) {
    _inherits(TestModel, _Model);

    var _super = _createSuper(TestModel);

    function TestModel() {
      _classCallCheck(this, TestModel);

      return _super.apply(this, arguments);
    }

    _createClass(TestModel, null, [{
      key: "fields",
      get: function get() {
        return ['id', 'f1', 'f2', 'f3', {
          name: 'f4',
          critical: true
        }, {
          name: 'f5',
          persist: false
        }];
      }
    }]);

    return TestModel;
  }(Model);

  var MyResource = /*#__PURE__*/function (_ResourceModel) {
    _inherits(MyResource, _ResourceModel);

    var _super2 = _createSuper(MyResource);

    function MyResource() {
      _classCallCheck(this, MyResource);

      return _super2.apply(this, arguments);
    }

    _createClass(MyResource, null, [{
      key: "fields",
      get: function get() {
        return ResourceModel.fields.concat(['surname']);
      }
    }]);

    return MyResource;
  }(ResourceModel);

  t.it('Should write all fields', function (t) {
    var resourceStore = t.getResourceStore({
      modelClass: MyResource,
      writeAllFields: false,
      data: [{
        id: 1,
        name: 'Albert',
        surname: 'Einstein'
      }]
    }),
        someStore = new Store({
      modelClass: TestModel,
      data: [{
        id: 1,
        f1: '11',
        f2: '111',
        f4: 'foo',
        f5: 'garbage'
      }]
    }),
        someStore1 = new Store({
      fields: ['id', 'ff1', 'ff2'],
      data: [{
        id: 1,
        ff1: '11',
        ff2: '111'
      }]
    });
    var crud = new AbstractCrudManager({
      writeAllFields: true,
      stores: [{
        store: resourceStore,
        storeId: 'resources'
      }, {
        store: someStore,
        storeId: 'something'
      }, {
        store: someStore1,
        storeId: 'something1',
        writeAllFields: false
      }],
      revision: 1
    });
    someStore.first.f1 = '22';
    someStore1.first.ff1 = '22';
    resourceStore.first.name = 'John';
    var pack = crud.getChangeSetPackage();
    t.isDeeply(pack.resources, {
      updated: [{
        id: 1,
        name: 'John'
      }]
    });
    t.isDeeply(pack.something, {
      updated: [{
        id: 1,
        f1: '22',
        f2: '111',
        f4: 'foo'
      }]
    });
    t.isDeeply(pack.something1, {
      updated: [{
        id: 1,
        ff1: '22'
      }]
    });
  });
  t.it('Should write all fields', function (t) {
    var resourceStore = t.getResourceStore({
      modelClass: MyResource,
      data: [{
        id: 1,
        name: 'Albert',
        surname: 'Einstein'
      }]
    }),
        someStore = new Store({
      modelClass: TestModel,
      writeAllFields: true,
      data: [{
        id: 1,
        f1: '11',
        f2: '111',
        f4: 'foo',
        f5: 'garbage'
      }]
    }),
        someStore1 = new Store({
      fields: ['id', 'ff1', 'ff2'],
      data: [{
        id: 1,
        ff1: '11',
        ff2: '111'
      }]
    });
    var crud = new AbstractCrudManager({
      stores: [{
        store: resourceStore,
        storeId: 'resources',
        writeAllFields: true
      }, {
        store: someStore,
        storeId: 'something'
      }, {
        store: someStore1,
        storeId: 'something1'
      }],
      revision: 1
    });
    someStore.first.f1 = '22';
    someStore1.first.ff1 = '22';
    resourceStore.first.name = 'John';
    var pack = crud.getChangeSetPackage();
    t.isDeeply(pack.resources, {
      updated: [{
        id: 1,
        name: 'John',
        surname: 'Einstein'
      }]
    });
    t.isDeeply(pack.something, {
      updated: [{
        id: 1,
        f1: '22',
        f2: '111',
        f4: 'foo'
      }]
    });
    t.isDeeply(pack.something1, {
      updated: [{
        id: 1,
        ff1: '22'
      }]
    });
  });
  t.it('Modified non-persistable field should not get record added to changeset package', function (t) {
    var TestModel = /*#__PURE__*/function (_Model2) {
      _inherits(TestModel, _Model2);

      var _super3 = _createSuper(TestModel);

      function TestModel() {
        _classCallCheck(this, TestModel);

        return _super3.apply(this, arguments);
      }

      _createClass(TestModel, null, [{
        key: "fields",
        get: function get() {
          return ['f1', {
            name: 'f2',
            persist: false
          }];
        }
      }]);

      return TestModel;
    }(Model);

    var store1 = new Store({
      modelClass: TestModel,
      writeAllFields: true,
      data: [{
        id: 1,
        f1: 1,
        f2: 1
      }, {
        id: 2
      }]
    }),
        store2 = new Store({
      modelClass: TestModel,
      data: [{
        id: 1,
        f1: 1,
        f2: 1
      }, {
        id: 2
      }]
    }),
        crud = new AbstractCrudManager({
      stores: [{
        store: store1,
        storeId: 'store1'
      }, {
        store: store2,
        storeId: 'store2',
        writeAllFields: true
      }],
      revision: 1
    }); // remove last record to make sure change set is never empty

    store1.last.remove();
    store2.last.remove(); // change non-persistable field

    store1.first.f2 = store2.first.f2 = 10;
    var pack = crud.getChangeSetPackage();
    t.is(pack.store1.updated, null, 'store 1 ignored non-persistable change');
    t.is(pack.store2.updated, null, 'store 2 ignored non-persistable change');
    store1.first.f1 = store2.first.f1 = 20;
    pack = crud.getChangeSetPackage();
    t.isDeeply(pack.store1.updated, [{
      id: 1,
      f1: 20
    }], 'Non-persistable field is ignored in changeset package');
    t.isDeeply(pack.store2.updated, [{
      id: 1,
      f1: 20
    }], 'Non-persistable field is ignored in changeset package');
  });
});