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
  // Here we test applySyncResponse method of Sch.crud.AbstractManager class
  // in case when we have embedded stores
  var TestModel = /*#__PURE__*/function (_Model) {
    _inherits(TestModel, _Model);

    var _super = _createSuper(TestModel);

    function TestModel(config) {
      var _this;

      _classCallCheck(this, TestModel);

      _this = _super.apply(this, arguments);

      if (_this.data.f3) {
        _this.f3Store = _this.data.f3;
      }

      return _this;
    }

    _createClass(TestModel, [{
      key: "get",
      value: function get(field) {
        if (field == 'f3') return this.f3Store;
        return _get(_getPrototypeOf(TestModel.prototype), "get", this).apply(this, arguments);
      }
    }, {
      key: "set",
      value: function set(field, value) {
        if (field == 'f3') {
          this.f3Store = value;
          return;
        }

        return _get(_getPrototypeOf(TestModel.prototype), "set", this).apply(this, arguments);
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

  var someStore1, subStore1, subStore2, someStore2, crud, added1, added2, subAdded1, subAdded2, response;

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
    }); // this is a sub-store that will be assigned to one of someStore2 records

    subStore1 = new Store({
      tree: true,
      fields: ['id', 'a', 'b'],
      data: [{
        expanded: true,
        children: [{
          id: 1,
          a: 'z',
          b: 'zzz'
        }, {
          id: 2,
          a: 'x',
          b: 'xxx'
        }]
      }]
    }); // this is a sub-store that will be assigned to one of someStore2 records

    subStore2 = new Store({
      fields: ['id', 'c', 'd', 'e'],
      data: [{
        id: 5,
        c: 'c',
        d: 'd',
        e: 'e'
      }, {
        id: 6,
        c: 'cc',
        d: 'dd',
        e: 'ee'
      }, {
        id: 7,
        c: 'ccc',
        d: 'ddd',
        e: 'eee'
      }]
    });
    someStore2 = new Store({
      tree: true,
      modelClass: TestModel,
      storeId: 'someStore2',
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
          f2: '333',
          f3: subStore1
        }, {
          id: 4,
          f1: '44',
          f2: '444'
        }]
      }]
    });
    crud = new AbstractCrudManager({
      stores: [someStore1, {
        store: someStore2,
        // describe that someStore2 might have a sub-store assigned to the 'f3' field of a record
        stores: [{
          storeId: 'f3'
        }]
      }]
    }); // init stores changes
    // someStore1

    someStore1.getById(11).remove();
    someStore1.getById(12).ff1 = '-22';
    added1 = someStore1.add({
      ff1: 'new',
      ff2: 'new'
    }); // someStore2

    someStore2.getById(4).remove();
    someStore2.getById(3).f1 = '-33';
    added2 = someStore2.getById(3).appendChild({
      f1: '55',
      f2: '555',
      f3: subStore2
    }); // edit sub-store of someStore2 record #3

    subAdded1 = subStore1.getById(2).appendChild({
      a: 'a',
      b: 'aaa'
    });
    subStore1.getById(2).a = '!xx';
    subStore1.getById(1).remove(); // edit sub-store of added2 record

    subStore2.test = 'a';
    subAdded2 = subStore2.add({
      c: 'cccc',
      d: 'dddd',
      e: 'eeee'
    });
    subStore2.getById(6).c = '!cc';
    subStore2.getById(5).remove(); // server response

    response = {
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
          id: 5,
          // sub-store changes response
          f3: {
            rows: [{
              $PhantomId: subAdded2[0].id,
              id: 8
            }, {
              id: 6,
              d: '!dd'
            }],
            removed: [{
              id: 5
            }]
          }
        }, {
          id: 3,
          f2: '-333',
          // sub-store changes response
          f3: {
            rows: [{
              $PhantomId: subAdded1.id,
              id: 22
            }, {
              id: 2,
              b: '!xxx'
            }],
            removed: [{
              id: 1
            }]
          }
        }],
        removed: [{
          id: 4
        }]
      }
    };
  };

  t.it('Applies changes to data', function (t) {
    initTestData();
    crud.applySyncResponse(response);
    t.it('someStore1 has correct state after changes applied', function (t) {
      t.notOk(someStore1.modified.count, 'has no dirty updated records');
      t.notOk(someStore1.removed.count, 'has no dirty removed records');
      t.is(someStore1.getById(14).get('ff1'), 'new', 'added record has correct ff1 field value');
      t.is(someStore1.getById(14).get('ff2'), 'new', 'added record has correct ff2 field value');
      t.is(someStore1.getById(12).get('ff2'), '-222', 'updated record has correct ff2 field value');
    });
    t.it('someStore2 has correct state after changes applied', function (t) {
      t.notOk(someStore2.modified.count, 'has no dirty updated records');
      t.notOk(someStore2.removed.count, 'has no dirty removed records');
      t.is(someStore2.getById(5).get('f1'), '55', 'added record has correct `f1` field value');
      t.is(someStore2.getById(5).get('f2'), '555', 'added record has correct `f2` field value');
      t.it('subStore2 has correct state after changes applied', function (t) {
        t.notOk(subStore2.modified.count, 'has no dirty updated records');
        t.notOk(subStore2.removed.count, 'has no dirty removed records');
        t.is(subStore2.getById(8).get('c'), 'cccc', 'added record has correct `c` value');
        t.is(subStore2.getById(8).get('d'), 'dddd', 'added record has correct `d` value');
        t.is(subStore2.getById(8).get('e'), 'eeee', 'added record has correct `e` value');
        t.is(subStore2.getById(6).get('c'), '!cc', 'updated record has correct `c` field value');
        t.is(subStore2.getById(6).get('d'), '!dd', 'updated record has correct `d` field value');
        t.notOk(subStore2.getById(5), 'removed record no longer exists');
      });
      t.is(someStore2.getById(3).get('f2'), '-333', 'updated record has correct f2 field value');
      t.it('subStore1 has correct state after changes applied', function (t) {
        t.notOk(subStore1.modified.count, 'has no dirty updated records');
        t.notOk(subStore1.removed.count, 'has no dirty removed records');
        t.is(subStore1.getById(22).get('a'), 'a', 'added record has correct `a` value');
        t.is(subStore1.getById(22).get('b'), 'aaa', 'added record has correct `aaa` value');
        t.is(subStore1.getById(2).get('a'), '!xx', 'updated record has correct `a` value');
        t.is(subStore1.getById(2).get('b'), '!xxx', 'updated record has correct `b` value');
        t.notOk(subStore1.getById(1), 'removed record no longer exists');
      });
    });
  });
  t.it('Applies changes to data and keeps other dirty records untouched', function (t) {
    initTestData(); // add some more changed data

    someStore1.add({
      ff1: 'another new',
      ff2: 'another new'
    });
    someStore1.remove(someStore1.getById(13)); // to someStore2 as well

    someStore2.getById(1).remove();
    someStore2.getById(2).set('f1', '-22');
    someStore2.getById(3).appendChild({
      f1: 'new node',
      f2: 'new node'
    }); // but apply only response for the data modified in initTestData call

    crud.applySyncResponse(response);
    t.it('someStore1 has correct state after changes applied', function (t) {
      t.is(someStore1.added.count, 1, 'has one added record');
      t.is(someStore1.removed.count, 1, 'has one removed record');
      t.ok(someStore1.added.values[0].hasGeneratedId, 'has one phantom record');
      t.is(someStore1.added.values[0].get('ff1'), 'another new', 'new record has correct ff1 value');
      t.is(someStore1.removed.values[0].data.id, 13, 'has correct removed record');
    });
    t.it('someStore2 has correct state after changes applied', function (t) {
      t.is(someStore2.added.count, 1, 'has 1 added record');
      t.is(someStore2.modified.count, 1, 'has 1 updated record');
      t.is(someStore2.removed.count, 1, 'has 1 removed record');
      t.is(someStore2.added.values[0].get('f1'), 'new node', 'new record has correct f1 value');
      t.is(someStore2.added.values[0].get('f2'), 'new node', 'new record has correct f2 value');
      t.is(someStore2.modified.values[0].get('f1'), '-22', 'updated record has correct f1 value');
      t.is(someStore2.removed.values[0].data.id, 1, 'has correct removed record');
    });
  });
});