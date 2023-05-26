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
  var scheduler;

  var MyDependencyStore = /*#__PURE__*/function (_DependencyStore) {
    _inherits(MyDependencyStore, _DependencyStore);

    var _super = _createSuper(MyDependencyStore);

    function MyDependencyStore() {
      _classCallCheck(this, MyDependencyStore);

      return _super.apply(this, arguments);
    }

    _createClass(MyDependencyStore, [{
      key: "isValidDependency",
      value: function isValidDependency(fromId, toId, type) {
        return type === DependencyBaseModel.Type.StartToEnd || type === DependencyBaseModel.Type.StartToStart;
      }
    }]);

    return MyDependencyStore;
  }(DependencyStore);

  t.beforeEach(function () {
    scheduler && scheduler.destroy();
    scheduler = null;
  });

  var setupScheduler = function setupScheduler(cfg) {
    scheduler = t.getScheduler(Object.assign({
      appendTo: document.body,
      features: {
        dependencies: {
          showTooltip: false
        },
        eventTooltip: false,
        scheduleTooltip: false
      },
      resourceStore: t.getResourceStore2(null, 10)
    }, cfg), 2);
  };

  function assertDepenencyType(t, from, to, type, valid) {
    t.chain({
      moveMouseTo: '.event1'
    }, {
      drag: ".event1 .b-sch-terminal-".concat(from),
      to: '.event2',
      dragOnly: true
    }, {
      moveMouseTo: ".event2 .b-sch-terminal-".concat(to)
    }, {
      mouseUp: null
    }, function () {
      var dep = scheduler.dependencyStore.first;

      if (valid) {
        t.is(dep.fromEvent.name, 'Assignment 1');
        t.is(dep.toEvent.name, 'Assignment 2');
        t.is(dep.type, type);
        t.is(dep.fromSide, from);
        t.is(dep.toSide, to);
      } else {
        t.notOk(dep, 'No dependency has been created');
      }
    });
  }

  t.it('Should be possible to validate to be created dependency', function (t) {
    var Type = DependencyBaseModel.Type;
    t.it('Start-to-Start', function (t) {
      setupScheduler({
        dependencyStore: new MyDependencyStore()
      });
      assertDepenencyType(t, 'left', 'left', Type.StartToStart, true);
    });
    t.it('Start-to-End', function (t) {
      setupScheduler({
        dependencyStore: new MyDependencyStore()
      });
      assertDepenencyType(t, 'left', 'right', Type.StartToEnd, true);
    });
    t.it('End-to-Start', function (t) {
      setupScheduler({
        dependencyStore: new MyDependencyStore()
      });
      assertDepenencyType(t, 'right', 'left', Type.EndToStart, false);
    });
    t.it('End-to-End', function (t) {
      setupScheduler({
        dependencyStore: new MyDependencyStore()
      });
      assertDepenencyType(t, 'right', 'right', Type.EndToEnd, false);
    });
  }); //https://github.com/bryntum/support/issues/172

  t.it('Creating a dependency between already linked events should consider to be valid', function (t) {
    setupScheduler();
    t.firesOk(scheduler.dependencyStore, 'add', 2, 'DependencyStore should be changed 2 times');
    t.chain( // It should be possible to create a dependency.
    {
      moveMouseTo: '.event1'
    }, {
      drag: '.event1 .b-sch-terminal-right',
      to: '.event2',
      dragOnly: true
    }, {
      moveMouseTo: '.event2 .b-sch-terminal-left'
    }, {
      waitForSelector: '.b-sch-dependency-connector.b-valid'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip .b-icon-valid'
    }, {
      mouseUp: null
    }, // It should be possible to create the same dependency again.
    {
      moveMouseTo: '.event1'
    }, {
      drag: '.event1 .b-sch-terminal-right',
      to: '.event2',
      dragOnly: true
    }, {
      moveMouseTo: '.event2 .b-sch-terminal-left'
    }, {
      waitForSelector: '.b-sch-dependency-connector.b-valid'
    }, {
      waitForSelector: '.b-sch-dependency-creation-tooltip .b-icon-valid'
    }, {
      mouseUp: null
    });
  });
});