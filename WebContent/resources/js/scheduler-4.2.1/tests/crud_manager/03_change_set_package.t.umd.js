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
  // Here we test getChangeSetPackage method of AbstractManager class
  var TestModel = /*#__PURE__*/function (_Model) {
    _inherits(TestModel, _Model);

    var _super = _createSuper(TestModel);

    function TestModel(config) {
      var _this;

      _classCallCheck(this, TestModel);

      _this = _super.apply(this, arguments);

      if (config.f3) {
        _this.f3Store = config.f3;
        config.f3 = null;
      }

      return _this;
    }

    _createClass(TestModel, [{
      key: "get",
      value: function get(field) {
        if (field === 'f3') return this.f3Store;
        return _get(_getPrototypeOf(TestModel.prototype), "get", this).call(this, field);
      }
    }], [{
      key: "fields",
      get: function get() {
        return ['id', 'f1', {
          name: 'f2',
          type: 'date',
          format: 'YYYYMMDD'
        }, 'f3', {
          name: 'f4',
          critical: true
        }];
      }
    }]);

    return TestModel;
  }(Model);

  var resourceStore = t.getResourceStore(),
      someStore = new Store({
    modelClass: TestModel,
    data: [{
      id: 1,
      f1: '11',
      f2: new Date(2020, 7, 11),
      f4: 'foo'
    }, {
      id: 2,
      f1: '22',
      f2: new Date(2020, 7, 12)
    }, {
      id: 3,
      f1: '33',
      f2: new Date(2020, 7, 13)
    }, {
      id: 4,
      f1: '44',
      f2: new Date(2020, 7, 14)
    }]
  }),
      someSubStore = new Store({
    fields: ['id', 'ff1', 'ff2'],
    data: [{
      id: 1,
      ff1: '11',
      ff2: '111'
    }, {
      id: 2,
      ff1: '22',
      ff2: '222'
    }, {
      id: 3,
      ff1: '33',
      ff2: '333'
    }, {
      id: 4,
      ff1: '44',
      ff2: '444'
    }]
  });
  var crud = new AbstractCrudManager({
    stores: [{
      store: resourceStore,
      storeId: 'resources'
    }, {
      store: someStore,
      storeId: 'something',
      stores: [{
        storeId: 'f3'
      }]
    }],
    revision: 1
  });
  t.it('Change set package for not modified data is null', function (t) {
    var pack = crud.getChangeSetPackage();
    t.notOk(pack, 'No changes yet');
  });
  t.it('Supports setting of a record back to its original values', function (t) {
    t.willFireNTimes(crud, 'haschanges', 1);
    t.willFireNTimes(crud, 'nochanges', 1);
    var r1 = resourceStore.first,
        oldName = r1.name;
    r1.name = 'Some Name';
    t.ok(crud.hasChanges(), 'hasChanges() is true');
    r1.name = oldName;
    t.notOk(crud.hasChanges(), 'hasChanges() is false');
  });
  t.it('Change set package for modified data', function (t) {
    // TODO: should be 13 if we take sub-stores into account, need to implement this in the future
    t.willFireNTimes(crud, 'haschanges', 10);
    resourceStore.getById('r1').name = 'Some Name';
    resourceStore.getById('r3').name = 'Some Other Name';
    resourceStore.remove(resourceStore.getById('r2'));
    resourceStore.remove(resourceStore.getById('r4'));
    var newResource = resourceStore.add({
      name: 'New Resource'
    })[0];
    someStore.getById(1).f1 = '-11';
    someStore.getById(2).f2 = '-222';
    someStore.remove(someStore.getById(3));
    someStore.remove(someStore.getById(4)); // add record having embedded store

    var newRec = someStore.add({
      f1: '55',
      f2: new Date(2020, 7, 15),
      f3: someSubStore
    })[0]; // add record to the embedded store

    var newSubRec = someSubStore.add({
      ff1: 'xx',
      ff2: 'xxx'
    })[0]; // edit record in the embedded store

    someSubStore.getById(1).ff1 = '!11'; // remove record from the embedded store

    someSubStore.remove(someSubStore.getById(4));
    var pack = crud.getChangeSetPackage();
    t.is(pack.type, 'sync', 'Correct package type');
    t.ok(pack.requestId, 'Has some request Id');
    t.ok(pack.revision, 'Has some revision');
    t.isDeeply(pack.resources.added, [{
      name: 'New Resource',
      $PhantomId: newResource.id
    }], 'Correct list of added records');
    t.isDeeply(pack.resources.updated, [{
      id: 'r1',
      name: 'Some Name'
    }, {
      id: 'r3',
      name: 'Some Other Name'
    }], 'Correct list of updated records');
    t.isDeeply(pack.resources.removed, [{
      id: 'r2'
    }, {
      id: 'r4'
    }], 'Correct list of removed records');
    t.isDeeply(pack.something.added, [{
      f1: '55',
      f2: '20200815',
      // TODO: uncomment when "critical" fields are supported
      // f4           : undefined,
      $PhantomId: newRec.id,
      // embedded store changes
      f3: {
        $store: true,
        added: [{
          ff1: 'xx',
          ff2: 'xxx',
          $PhantomId: newSubRec.id
        }],
        updated: [{
          id: 1,
          ff1: '!11'
        }],
        removed: [{
          id: 4
        }]
      }
    }], 'Correct list of added records (including embedded store changes)'); // t.isDeeply(pack.something.updated, [{ id : 1, f1 : '-11', f4 : 'foo' }, {
    //     id : 2,
    //     f2 : '-222',
    //     f4 : undefined
    // }], 'Correct list of updated records');
    // t.isDeeply(pack.something.removed, [{ id : 3 }, { id : 4 }], 'Correct list of removed records');
  });
});