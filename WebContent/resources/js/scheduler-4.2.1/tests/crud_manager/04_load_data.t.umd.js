function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _get(target, property, receiver) { if (typeof Reflect !== "undefined" && Reflect.get) { _get = Reflect.get; } else { _get = function _get(target, property, receiver) { var base = _superPropBase(target, property); if (!base) return; var desc = Object.getOwnPropertyDescriptor(base, property); if (desc.get) { return desc.get.call(receiver); } return desc.value; }; } return _get(target, property, receiver || target); }

function _superPropBase(object, property) { while (!Object.prototype.hasOwnProperty.call(object, property)) { object = _getPrototypeOf(object); if (object === null) break; } return object; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

StartTest(function (t) {
  // Here we test loadData method of AbstractManager class
  t.it('Loads stores by batch in a proper order', function (t) {
    var TestModel = /*#__PURE__*/function (_Model) {
      _inherits(TestModel, _Model);

      var _super = _createSuper(TestModel);

      function TestModel() {
        var _this;

        _classCallCheck(this, TestModel);

        _this = _super.apply(this, arguments);

        if (_this.data.f3) {
          _this.f3Store = _this.data.f3;
        }

        return _this;
      }

      _createClass(TestModel, [{
        key: "flatGet",
        value: function flatGet(field, dataSource) {
          if (field === 'f3') {
            if (!this.f3Store) {
              this.f3Store = new Store({
                fields: ['id', 'a', 'b']
              });
            }

            return this.f3Store;
          }

          return _get(_getPrototypeOf(TestModel.prototype), "flatGet", this).call(this, field, dataSource);
        }
      }, {
        key: "set",
        value: function set(field, value) {
          if (field === 'f3') {
            this.f3Store = value;
            return;
          }

          return _get(_getPrototypeOf(TestModel.prototype), "set", this).call(this, field, value);
        }
      }], [{
        key: "fields",
        get: //f3Store : null,
        function get() {
          return ['id', 'f1', 'f2', 'f3'];
        }
      }]);

      return TestModel;
    }(Model);

    var loaded = 0;
    var someStore1 = new Store({
      fields: ['id', 'ff1', 'ff2']
    }),
        someStore2 = new Store({
      modelClass: TestModel
    });
    var crud = new AbstractCrudManager({
      stores: [{
        store: someStore1,
        storeId: 'someStore1'
      }, {
        store: someStore2,
        storeId: 'someStore2',
        stores: 'f3'
      }]
    });
    someStore1.on('dataset', {
      fn: function fn() {
        t.is(loaded++, 0, 'someStore1 loaded first');
      },
      once: true
    });
    someStore2.on('dataset', {
      fn: function fn() {
        t.is(loaded, 1, 'someStore2 loaded second');
      },
      once: true
    });
    crud.loadData({
      someStore1: {
        rows: [{
          id: 11,
          ff1: '11',
          ff2: '111'
        }, {
          id: 12,
          ff1: '22',
          ff2: '222'
        }]
      },
      someStore2: {
        rows: [{
          id: 1,
          f1: '11',
          f2: '111'
        }, {
          id: 2,
          f1: '22',
          f2: '222',
          f3: {
            rows: [{
              id: 21,
              a: 'a',
              b: 'b'
            }, {
              id: 22,
              a: 'aa',
              b: 'bb'
            }]
          }
        }, {
          id: 3,
          f1: '33',
          f2: '333'
        }, {
          id: 4,
          f1: '44',
          f2: '444'
        }]
      }
    });
    t.is(someStore1.count, 2, 'someStore1 loaded');
    t.is(someStore2.count, 4, 'someStore2 loaded');
    t.is(someStore2.getById(2).f3.count, 2, 'someStore2 sub-store loaded');
    t.isDeeply(someStore2.getById(2).f3.getById(21).data, {
      id: 21,
      a: 'a',
      b: 'b',
      parentIndex: 0
    }, 'someStore2 sub-store has correct record #21');
    t.isDeeply(someStore2.getById(2).get('f3').getById(22).data, {
      id: 22,
      a: 'aa',
      b: 'bb',
      parentIndex: 1
    }, 'someStore2 sub-store has correct record #22');
  });
  t.it('Supports empty dataset loading', function (t) {
    var store1 = new Store({
      storeId: 'store1',
      tree: true,
      data: [{
        id: 1,
        leaf: true
      }, {
        id: 2,
        leaf: true
      }, {
        id: 3,
        leaf: true
      }]
    });
    var store2 = new Store({
      storeId: 'store2',
      data: [{
        id: 1
      }, {
        id: 2
      }]
    });
    var crud = new AbstractCrudManager({
      stores: [{
        store: store1
      }, {
        store: store2
      }]
    });
    crud.loadData({
      store1: {
        rows: []
      },
      store2: {
        rows: []
      }
    });
    t.is(store1.count, 0, 'store1 loaded');
    t.is(store2.count, 0, 'store2 loaded');
  });
  /* eslint-disable */
  // TODO: PORT clearOnLoad?

  t.xit('Supports records append for a tree store when its clearOnLoad is false', function (t) {
    var store1 = new Ext.data.TreeStore({
      fields: ['id'],
      clearOnLoad: false,
      storeId: 'store1',
      proxy: 'memory',
      root: {
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
      }
    });
    var crud = new TestCrudManager1({
      stores: 'store1'
    });
    crud.loadData({
      store1: {
        rows: [{
          id: 4
        }]
      }
    });
    t.isDeeplyUnordered(store1.getRange(), [store1.getNodeById(1), store1.getNodeById(2), store1.getNodeById(3), store1.getNodeById(4)], 'store1 has proper set of records');
  }); // TODO: PORT tree stuff

  t.xit('Supports records append when append is provided from the server side', function (t) {
    var store1 = new Store({
      tree: true,
      fields: ['id'],
      clearOnLoad: false,
      storeId: 'store1',
      data: [{
        id: 1,
        leaf: true
      }, {
        id: 2,
        leaf: true
      }, {
        id: 3,
        leaf: true
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
    var crud = new AbstractCrudManager({
      stores: ['store1', 'store2']
    });
    crud.loadData({
      store1: {
        rows: [{
          id: 4
        }]
      },
      store2: {
        append: true,
        rows: [{
          id: 3
        }]
      }
    });
    t.isDeeplyUnordered(store1.allRecords, [store1.getById(1), store1.getById(2), store1.getById(3), store1.getById(4)], 'store1 has proper set of records');
    t.isDeeplyUnordered(store2.allRecords, [store2.getById(1), store2.getById(2), store2.getById(3)], 'store2 has proper set of records');
  });
  /* eslint-enable */
});