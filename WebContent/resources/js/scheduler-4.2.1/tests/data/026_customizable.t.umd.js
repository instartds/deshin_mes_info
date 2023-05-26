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

//TODO: move it to Core instead of scheduler
StartTest(function (t) {
  var getByKey = function getByKey(array, name) {
    return array.find(function (f) {
      return f.name === name;
    });
  };

  var containsKey = function containsKey(array, name) {
    return !!array.find(function (f) {
      return f.name === name;
    });
  };

  t.ok(Model, 'Model is here');

  var BaseModel = /*#__PURE__*/function (_Model) {
    _inherits(BaseModel, _Model);

    var _super = _createSuper(BaseModel);

    function BaseModel() {
      _classCallCheck(this, BaseModel);

      return _super.apply(this, arguments);
    }

    _createClass(BaseModel, null, [{
      key: "fields",
      get: function get() {
        return [{
          name: 'id',
          dataSource: 'Usual'
        }, {
          name: 'Field1',
          persist: true
        }, {
          name: 'Field2',
          persist: true
        }, {
          name: 'FieldFoo',
          persist: true
        }];
      }
    }]);

    return BaseModel;
  }(Model);

  t.it('Model.set should return array of modified fields', function (t) {
    var instance = new BaseModel();
    t.isDeeply(instance.set('Field1', instance.get('Field1')), null, 'null returned');
    t.isDeeply(instance.set('Field1', 'foo'), {
      Field1: {
        value: 'foo'
      }
    }, 'Object returned');
  });

  var SubModel = /*#__PURE__*/function (_BaseModel) {
    _inherits(SubModel, _BaseModel);

    var _super2 = _createSuper(SubModel);

    function SubModel() {
      _classCallCheck(this, SubModel);

      return _super2.apply(this, arguments);
    }

    _createClass(SubModel, [{
      key: "Field2",
      get: function get() {
        return 'yo2';
      }
    }], [{
      key: "fields",
      get: function get() {
        return [{
          name: 'subField1',
          dataSource: 'field1',
          persist: false
        }, {
          name: 'subField2',
          dataSource: 'field2'
        }, {
          name: 'Field3',
          type: 'int',
          defaultValue: 53
        }, {
          name: 'FieldFoo',
          persist: false
        }];
      }
    }]);

    return SubModel;
  }(BaseModel); //=========================================================================


  t.it('Testing the base model (the one with customizableFields property)', function (t) {
    var baseModelFields = BaseModel.fields;
    var Field1 = getByKey(baseModelFields, 'Field1');
    t.is(baseModelFields.length, 4, '4 baseModel fields');
    t.ok(Field1 && Field1.persist, '`Field1` was created');
    t.ok(containsKey(baseModelFields, 'Field1'), '`Field1` was created');
    t.ok(containsKey(baseModelFields, 'Field2'), '`Field2` was created');
    t.ok(containsKey(baseModelFields, 'FieldFoo'), '`FieldFoo` was created'); // where would that field come from??
    //        t.ok(containsKey(baseModelFields, 'Usual'), '`Usual` field was also created');

    var baseModel = new BaseModel({
      Field1: 'Field1',
      Field2: 'Field2',
      Usual: 'Usual'
    });
    t.is(baseModel.Field1, 'Field1', 'Getter for customizable field `Field1` uses the correct name');
    t.is(baseModel.Field2, 'Field2', 'Getter for customizable field `Field2` uses the correct name');
    t.notOk(baseModel.Usual, "There's no getter for usual field");
  });
  t.it('Testing the sub model (the one inheriting from base model, and w/o customizableFields)', function (t) {
    // internally fields get reversed...
    var subModelFields = SubModel.fields.reverse(); // TODO: PORT are now adding fields, should replace??

    t.is(subModelFields.length, 4, '4 subModelFields');
    t.is(SubModel.$meta.fields.defs.length, 8, '8 exposed fields');
    t.ok(containsKey(subModelFields, 'subField1'), 'Customizable field `Field1` was inherited as `subField1`');
    t.ok(containsKey(subModelFields, 'subField2'), 'Customizable field `Field2` was inherited as `subField2`');
    t.ok(containsKey(subModelFields, 'Field3'), 'Customizable field `field3` was created');
    t.ok(containsKey(subModelFields, 'FieldFoo'), '`FieldFoo` was created');
    t.notok(getByKey(subModelFields, 'FieldFoo').persist, 'FieldFoo was re-defined');
    var subModel = new SubModel({
      subField1: 'subField1',
      subField2: 'subField2',
      Usual: 'Usual'
    }); //t.is(subModel.Field1, 'subField1', 'Getter for customizable field `Field1` uses the default name');

    t.is(subModel.Field2, 'yo2', 'Custom getter for customizable field `Field2` was not overwritten');
    t.is(subModel.get('subField2'), 'subField2', 'Default getter returns correct data');
    t.notok(subModel.getUsual, "There's no getter for usual field");
    t.notok(subModel.getSubField1, "There's no getter named after overriden field");
  });
});