function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

StartTest(function (t) {
  // Here we test addStore method of Sch.crud.AbstractManager class
  //t.expectGlobal('TestCrudManager1');
  var resourceStore = t.getResourceStore(),
      eventStore = t.getEventStore();

  var TestCrudManager1 = /*#__PURE__*/function (_AbstractCrudManager) {
    _inherits(TestCrudManager1, _AbstractCrudManager);

    var _super = _createSuper(TestCrudManager1);

    function TestCrudManager1() {
      _classCallCheck(this, TestCrudManager1);

      return _super.apply(this, arguments);
    }

    return TestCrudManager1;
  }(AbstractCrudManager);

  var setup = function setup() {
    var config = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
    var crud = new TestCrudManager1(Object.assign({
      stores: config.stores || [resourceStore, eventStore]
    }), config.crud);
    return {
      crud: crud
    };
  };

  t.it('Constructor accepts stores list', function (t) {
    t.it('instances list', function (t) {
      var crud = setup().crud;
      t.is(crud.stores.length, 2, 'Stores array has correct number of elements');
      t.is(crud.stores[0].storeId, 'resources', '0th has correct storeId');
      t.ok(crud.stores[0].store === resourceStore, '0th has correct store');
      t.is(crud.stores[1].storeId, 'events', '1st has correct storeId');
      t.ok(crud.stores[1].store === eventStore, '1st has correct store');
      crud.destroy();
    });
    t.it('descriptors list', function (t) {
      var crud = setup({
        stores: [{
          store: resourceStore,
          storeId: 'resources'
        }, {
          store: eventStore,
          storeId: 'events'
        }]
      }).crud;
      t.is(crud.stores.length, 2, 'Stores array has correct number of elements');
      t.is(crud.stores[0].storeId, 'resources', '0th has correct storeId');
      t.ok(crud.stores[0].store === resourceStore, '0th has correct store');
      t.is(crud.stores[1].storeId, 'events', '1st has correct storeId');
      t.ok(crud.stores[1].store === eventStore, '1st has correct store');
      crud.destroy();
    });
    t.it('storeId list', function (t) {
      var resourceStore = t.getResourceStore({
        storeId: 'foo'
      }),
          eventStore = t.getEventStore({
        storeId: 'bar'
      }),
          crud = setup({
        stores: ['foo', 'bar']
      }).crud;
      t.is(crud.stores.length, 2, 'Stores array has correct number of elements');
      t.is(crud.stores[0].storeId, resourceStore.storeId, '0th has correct storeId');
      t.ok(crud.stores[0].store === resourceStore, '0th has correct store');
      t.is(crud.stores[1].storeId, eventStore.storeId, '1st has correct storeId');
      t.ok(crud.stores[1].store === eventStore, '1st has correct store');
      crud.destroy();
      resourceStore.destroy();
      eventStore.destroy();
    });
  });
  t.it('addStores appends singular store', function (t) {
    function assert(t, action) {
      var crud = setup().crud,
          newStore = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth1'
      });
      action(crud, newStore);
      t.is(crud.stores.length, 3, 'Stores array has correct number of elements');
      t.is(crud.stores[2].storeId, 'smth1', '2nd has correct storeId');
      t.ok(crud.stores[2].store === newStore, '2nd has correct store');
      newStore.destroy();
      crud.destroy();
    }

    t.it('instance provided', function (t) {
      assert(t, function (crud, newStore) {
        crud.addStore(newStore);
      });
    });
    t.it('storeId provided', function (t) {
      assert(t, function (crud) {
        crud.addStore('smth1');
      });
    });
  });
  t.it('addStores appends multiple stores', function (t) {
    function assert(t, action) {
      var crud = setup().crud;
      var newStore1 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth2'
      });
      var newStore2 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth3'
      });
      action(crud, newStore1, newStore2);
      t.is(crud.stores.length, 4, 'Stores array has correct number of elements');
      t.is(crud.stores[2].storeId, 'smth2', '2nd has correct storeId');
      t.ok(crud.stores[2].store === newStore1, '2nd has correct store');
      t.is(crud.stores[3].storeId, 'smth3', '2nd has correct storeId');
      t.ok(crud.stores[3].store === newStore2, '2nd has correct store');
      newStore1.destroy();
      newStore2.destroy();
      crud.destroy();
    }

    t.it('instances provided', function (t) {
      assert(t, function (crud, newStore1, newStore2) {
        return crud.addStore([newStore1, newStore2]);
      });
    });
    t.it('instances provided', function (t) {
      assert(t, function (crud) {
        return crud.addStore(['smth2', 'smth3']);
      });
    });
  });
  t.it('addStores inserts singular store', function (t) {
    function assert(t, action) {
      var crud = new TestCrudManager1({
        stores: [resourceStore, eventStore]
      });
      var newStore = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth4'
      });
      action(crud, newStore);
      t.is(crud.stores.length, 3, 'Stores array has correct number of elements');
      t.is(crud.stores[0].storeId, 'smth4', '0th has correct storeId');
      t.ok(crud.stores[0].store === newStore, '0th has correct store');
      newStore.destroy();
      crud.destroy();
    }

    t.it('instance provided', function (t) {
      assert(t, function (crud, newStore) {
        crud.addStore(newStore, 0);
      });
    });
    t.it('storeId provided', function (t) {
      assert(t, function (crud) {
        crud.addStore('smth4', 0);
      });
    });
  });
  t.it('addStores inserts multiple stores', function (t) {
    function assert(t, action) {
      var crud = setup().crud;
      var newStore1 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth5'
      });
      var newStore2 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth6'
      });
      action(crud, newStore1, newStore2);
      t.is(crud.stores.length, 4, 'Stores array has correct number of elements');
      t.is(crud.stores[0].storeId, 'smth5', '0th has correct storeId');
      t.ok(crud.stores[0].store === newStore1, '0th has correct store');
      t.is(crud.stores[1].storeId, 'smth6', '1st has correct storeId');
      t.ok(crud.stores[1].store === newStore2, '1st has correct store');
      newStore1.destroy();
      newStore2.destroy();
      crud.destroy();
    }

    t.it('instances provided', function (t) {
      assert(t, function (crud, newStore1, newStore2) {
        crud.addStore([newStore1, newStore2], 0);
      });
    });
    t.it('storeId-s provided', function (t) {
      assert(t, function (crud) {
        crud.addStore(['smth5', 'smth6'], 0);
      });
    });
  });
  t.it('addStores inserts singular store -2 elements before specified store', function (t) {
    function assert(t, action) {
      var newStore1 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth1'
      });
      var newStore2 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth2'
      });
      var newStore3 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth3'
      });
      var newStore4 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth4'
      });
      var newStore5 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth5'
      });
      var newStore6 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth6'
      });
      var crud = setup({
        stores: [resourceStore, eventStore, newStore1, newStore2, newStore3, newStore4, newStore5, newStore6]
      }).crud;
      var newStore7 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth7'
      });
      action(crud, newStore7);
      t.is(crud.stores.length, 9, 'Stores array has correct number of elements');
      t.is(crud.stores[2].storeId, 'smth7', '2nd has correct storeId');
      t.ok(crud.stores[2].store === newStore7, '2nd has correct store');
      [newStore1, newStore2, newStore3, newStore4, newStore5, newStore6, newStore7, crud].forEach(function (s) {
        return s.destroy();
      });
    }

    t.it('instance provided', function (t) {
      assert(t, function (crud, newStore7) {
        crud.addStore(newStore7, -2, crud.getStore('smth3'));
      });
    });
    t.it('storeId provided', function (t) {
      assert(t, function (crud) {
        crud.addStore('smth7', -2, 'smth3');
      });
    });
  });
  t.it('addStores inserts multiple stores -2 elements before specified store', function (t) {
    function assert(t, action) {
      var newStore1 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth1'
      });
      var newStore2 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth2'
      });
      var newStore3 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth3'
      });
      var newStore4 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth4'
      });
      var newStore5 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth5'
      });
      var newStore6 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth6'
      });
      var newStore7 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth7'
      });
      var crud = setup({
        stores: [resourceStore, eventStore, newStore1, newStore2, newStore3, newStore4, newStore5, newStore6, newStore7]
      }).crud;
      var newStore8 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth8'
      });
      var newStore9 = new Store({
        fields: ['f1', 'f2'],
        storeId: 'smth9'
      });
      action(crud, newStore8, newStore9);
      t.is(crud.stores.length, 11, 'Stores array has correct number of elements');
      t.is(crud.stores[2].storeId, 'smth8', '6th has correct storeId');
      t.ok(crud.stores[2].store === newStore8, '6th has correct store');
      t.is(crud.stores[3].storeId, 'smth9', '7th has correct storeId');
      t.ok(crud.stores[3].store === newStore9, '7th has correct store');
      t.it('removeStore correctly removes stores', function (t) {
        crud.removeStore('smth8');
        crud.removeStore(newStore9);
        crud.removeStore(crud.getStoreDescriptor('smth3'));
        t.is(crud.stores.length, 8, 'Stores array has correct number of elements');
        t.notOk(crud.getStore('smth3'), 'No smth3 store registered');
        t.notOk(crud.getStore('smth8'), 'No smth8 store registered');
        t.notOk(crud.getStore('smth9'), 'No smth9 store registered');
        [newStore1, newStore2, newStore3, newStore4, newStore5, newStore6, newStore7, newStore8, newStore9, crud].forEach(function (s) {
          return s.destroy();
        });
      });
    }

    t.it('instances provided', function (t) {
      assert(t, function (crud, newStore1, newStore2) {
        crud.addStore([newStore1, newStore2], -2, 'smth3');
      });
    });
    t.it('addStores inserts multiple stores -2 elements before specified store', function (t) {
      assert(t, function (crud) {
        crud.addStore(['smth8', 'smth9'], -2, 'smth3');
      });
    });
  });
  t.it('Constructor accepts sub-stores list', function (t) {
    var newStore = new Store({
      fields: ['f1', 'f2'],
      storeId: 'smth'
    });
    var subStore = new Store({
      fields: ['ff1', 'ff2']
    });
    var crud = setup({
      stores: [resourceStore, eventStore, {
        store: newStore,
        stores: [{
          storeId: 'f1',
          store: subStore
        }]
      }]
    }).crud;
    t.is(crud.stores.length, 3, 'Stores array has correct number of elements');
    t.is(crud.stores[0].storeId, 'resources', '0th has correct storeId');
    t.ok(crud.stores[0].store === resourceStore, '0th has correct store');
    t.is(crud.stores[1].storeId, 'events', '1st has correct storeId');
    t.ok(crud.stores[1].store === eventStore, '1st has correct store');
    t.is(crud.stores[2].storeId, 'smth', '2nd has correct storeId');
    t.ok(crud.stores[2].store === newStore, '2nd has correct store');
    t.isDeeply(crud.getStoreDescriptor(newStore).stores, [{
      storeId: 'f1',
      store: subStore,
      masterStoreInfo: crud.getStoreDescriptor(newStore)
    }], '2nd has substores list');
  });
  t.it('syncApplySequence config adds stores to alternative sync sequence', function (t) {
    var crud = new TestCrudManager1({
      stores: [{
        store: resourceStore,
        storeId: 'resources'
      }, {
        store: eventStore,
        storeId: 'events'
      }],
      syncApplySequence: ['events', 'resources']
    });
    t.is(crud.syncApplySequence.length, 2, 'Stores array has correct number of elements');
    t.is(crud.syncApplySequence[0].storeId, 'events', '0th has correct storeId');
    t.is(crud.syncApplySequence[1].storeId, 'resources', '1st has correct storeId');
  });
  t.it('addStoreToApplySequence inserts singular store', function (t) {
    var crud = new TestCrudManager1({
      stores: [{
        store: resourceStore,
        storeId: 'resources'
      }, {
        store: eventStore,
        storeId: 'events'
      }]
    });
    var newStore = new Store({
      fields: ['f1', 'f2'],
      storeId: 'smth4'
    });
    crud.addStoreToApplySequence(crud.stores);
    crud.addStore(newStore, 0);
    crud.addStoreToApplySequence(newStore, 1);
    t.is(crud.syncApplySequence.length, 3, 'Stores array has correct number of elements');
    t.is(crud.syncApplySequence[0].storeId, 'resources', '0th has correct storeId');
    t.is(crud.syncApplySequence[1].storeId, 'smth4', '1st has correct storeId');
    t.is(crud.syncApplySequence[2].storeId, 'events', '2nd has correct storeId');
    t.it('removeStore removes store from both arrays', function (t) {
      crud.removeStore('smth4');
      t.is(crud.stores.length, 2, 'Stores array has correct number of elements');
      t.is(crud.stores[0].storeId, 'resources', '0th has correct storeId');
      t.is(crud.stores[1].storeId, 'events', '1st has correct storeId');
      t.is(crud.syncApplySequence.length, 2, 'Stores array has correct number of elements');
      t.is(crud.syncApplySequence[0].storeId, 'resources', '0th has correct storeId');
      t.is(crud.syncApplySequence[1].storeId, 'events', '1st has correct storeId');
    });
  });
  t.it('addStoreToApplySequence inserts singular store (position relative to existing store)', function (t) {
    var crud = new TestCrudManager1({
      stores: [{
        store: resourceStore,
        storeId: 'resources'
      }, {
        store: eventStore,
        storeId: 'events'
      }]
    });
    var newStore = new Store({
      fields: ['f1', 'f2'],
      storeId: 'smth4'
    });
    crud.addStoreToApplySequence(crud.stores);
    crud.addStore(newStore, 0);
    crud.addStoreToApplySequence(newStore, 1, 'resources');
    t.is(crud.syncApplySequence.length, 3, 'Stores array has correct number of elements');
    t.is(crud.syncApplySequence[0].storeId, 'resources', '0th has correct storeId');
    t.is(crud.syncApplySequence[1].storeId, 'smth4', '1st has correct storeId');
    t.is(crud.syncApplySequence[2].storeId, 'events', '2nd has correct storeId');
    t.it('removeStoreFromApplySequence removes store', function (t) {
      crud.removeStoreFromApplySequence('smth4');
      t.is(crud.syncApplySequence.length, 2, 'Stores array has correct number of elements');
      t.is(crud.syncApplySequence[0].storeId, 'resources', '0th has correct storeId');
      t.is(crud.syncApplySequence[1].storeId, 'events', '1st has correct storeId');
    });
  });
});