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
  // Checks that CRUD manager can retrieve storeId value from other properties
  t.it('CrudManager can use any store property as storeId', function (t) {
    t.it('defined on prototype', function (t) {
      //t.expectGlobal('TestCrudManager1');
      var TestCrudManager1 = /*#__PURE__*/function (_CrudManager) {
        _inherits(TestCrudManager1, _CrudManager);

        var _super = _createSuper(TestCrudManager1);

        function TestCrudManager1() {
          _classCallCheck(this, TestCrudManager1);

          return _super.apply(this, arguments);
        }

        _createClass(TestCrudManager1, null, [{
          key: "defaultConfig",
          get: function get() {
            return {
              storeIdProperty: 'oops'
            };
          }
        }]);

        return TestCrudManager1;
      }(CrudManager);

      var project = new ProjectModel({
        resourceStore: t.getResourceStore({
          oops: 'res'
        }),
        eventStore: t.getEventStore({
          oops: 'eve'
        })
      }),
          resourceStore = project.resourceStore,
          eventStore = project.eventStore;
      var crud = new TestCrudManager1({
        resourceStore: 'resources',
        eventStore: 'events'
      });
      t.is(crud.stores.length, 4, 'proper number of stores'); // +2 assignmentstore & dep

      t.is(crud.getStore('res'), resourceStore, 'resourceStore found');
      t.is(crud.getStore('eve'), eventStore, 'eventStore found');
      resourceStore.destroy();
      eventStore.destroy();
    });
    t.it('defined on instance', function (t) {
      var project = new ProjectModel({
        resourceStore: t.getResourceStore({
          oops: 'res'
        }),
        eventStore: t.getEventStore({
          oops: 'eve'
        })
      }),
          resourceStore = project.resourceStore,
          eventStore = project.eventStore;
      var crud = new CrudManager({
        resourceStore: 'resources',
        eventStore: 'events',
        storeIdProperty: 'oops'
      });
      t.is(crud.stores.length, 4, 'proper number of stores'); // +2 assignmentstore & dep

      t.is(crud.getStore('res'), resourceStore, 'resourceStore found');
      t.is(crud.getStore('eve'), eventStore, 'eventStore found');
      resourceStore.destroy();
      eventStore.destroy();
    });
  });
  t.it('CrudManager takes into account storeIdProperty on a store', function (t) {
    //t.expectGlobal('TestCrudManager2');
    var TestCrudManager2 = /*#__PURE__*/function (_CrudManager2) {
      _inherits(TestCrudManager2, _CrudManager2);

      var _super2 = _createSuper(TestCrudManager2);

      function TestCrudManager2() {
        _classCallCheck(this, TestCrudManager2);

        return _super2.apply(this, arguments);
      }

      _createClass(TestCrudManager2, null, [{
        key: "defaultConfig",
        get: function get() {
          return {
            storeIdProperty: 'oops'
          };
        }
      }]);

      return TestCrudManager2;
    }(CrudManager);

    var project = new ProjectModel({
      resourceStore: t.getResourceStore({
        oops: 'res'
      }),
      eventStore: t.getEventStore({
        foo: 'eve',
        storeIdProperty: 'foo'
      })
    }),
        resourceStore = project.resourceStore,
        eventStore = project.eventStore;
    var crud = new TestCrudManager2({
      resourceStore: 'resources',
      eventStore: 'events'
    });
    t.is(crud.stores.length, 4, 'proper number of stores'); // +2 assignmentstore & dep

    t.is(crud.getStore('res'), resourceStore, 'resourceStore found');
    t.is(crud.getStore('eve'), eventStore, 'eventStore found');
    resourceStore.destroy();
    eventStore.destroy();
  });
});