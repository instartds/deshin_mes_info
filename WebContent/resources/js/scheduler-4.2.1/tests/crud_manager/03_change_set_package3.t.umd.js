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
  // Checks that crud manager 'haschanges' event catches removals and doesn't react on tree store collapse/expand #2413
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
        return ['id', 'text'];
      }
    }]);

    return TestModel;
  }(Model);

  var someStore, crud;
  t.beforeEach(function () {
    someStore = new Store({
      modelClass: TestModel,
      tree: true,
      data: [{
        id: 1,
        text: '11',
        expanded: true,
        children: [{
          id: 11,
          text: '11',
          leaf: true
        }, {
          id: 12,
          text: '11',
          leaf: true
        }]
      }]
    });
    crud = new AbstractCrudManager({
      stores: [{
        store: someStore,
        storeId: 'foo'
      }]
    });
  });
  t.it('haschanges event fired when removing child node', function (t) {
    t.notOk(crud.getChangeSetPackage(), 'No changes initially');
    t.willFireNTimes(crud, 'haschanges', 1);
    someStore.getById(12).remove();
    t.ok(crud.hasChanges(), 'hasChanges() is true');
  }); // expand/collapse is done by tree feature, this test does not apply currently...

  t.xit('haschanges event is not fired during nodes collapse/expand', function (t) {
    t.notOk(crud.getChangeSetPackage(), 'No changes initially');
    t.wontFire(crud, 'haschanges');
    var node = someStore.getNodeById(1);
    node.collapse();
    t.notOk(crud.hasChanges(), 'hasChanges() is false');
    node.expand();
    t.notOk(crud.hasChanges(), 'hasChanges() is still false');
  });
  t.it('Should support getting a changes object', function (t) {
    var otherStore = new Store({
      fields: ['name', 'age'],
      storeId: 'bar',
      data: [{
        id: 1,
        name: 'Lars',
        age: 22
      }, {
        id: 2,
        name: 'Ida',
        age: 33
      }]
    });
    crud.addStore(otherStore, 0);
    t.is(crud.changes, null, 'No changes initially');
    someStore.getById(12).remove();
    someStore.getById(11).text = 'foo';
    otherStore.getById(2).name = 'Ida W';
    t.isDeeply(crud.changes, {
      foo: {
        updated: [{
          text: 'foo',
          id: 11
        }],
        removed: [{
          id: 12
        }]
      },
      bar: {
        updated: [{
          name: 'Ida W',
          id: 2
        }]
      }
    }, 'Changes ok');
  });
});