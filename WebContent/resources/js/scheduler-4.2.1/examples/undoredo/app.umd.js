function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

var _templateObject;

function _taggedTemplateLiteral(strings, raw) { if (!raw) { raw = strings.slice(0); } return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

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

var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    ResourceModel = _bryntum$scheduler.ResourceModel,
    EventModel = _bryntum$scheduler.EventModel,
    DependencyModel = _bryntum$scheduler.DependencyModel,
    StringHelper = _bryntum$scheduler.StringHelper;

var Gate = /*#__PURE__*/function (_ResourceModel) {
  _inherits(Gate, _ResourceModel);

  var _super = _createSuper(Gate);

  function Gate() {
    _classCallCheck(this, Gate);

    return _super.apply(this, arguments);
  }

  _createClass(Gate, null, [{
    key: "fields",
    get: function get() {
      return ['capacity'];
    }
  }]);

  return Gate;
}(ResourceModel);

new Scheduler({
  appendTo: 'container',
  features: {
    tree: true,
    regionResize: true,
    dependencies: true
  },
  rowHeight: 45,
  barMargin: 5,
  columns: [{
    type: 'tree',
    text: 'Name',
    width: 200,
    field: 'name'
  }, {
    type: 'number',
    text: 'Capacity',
    width: 80,
    field: 'capacity'
  }],
  startDate: new Date(2017, 11, 2, 8),
  viewPreset: 'hourAndDay',
  enableUndoRedoKeys: true,
  crudManager: {
    autoLoad: true,
    resourceStore: {
      modelClass: Gate
    },
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  // Scheduler always has a Project instance internally, we need to configure its internal StateTrackingManager
  // so that the UndoRedo widget gets customized titles in its transaction dropdown.
  project: {
    stm: {
      autoRecord: true,
      getTransactionTitle: function getTransactionTitle(transaction) {
        var lastAction = transaction.queue[transaction.queue.length - 1];
        var type = lastAction.type,
            model = lastAction.model;

        if (lastAction.modelList && lastAction.modelList.length) {
          model = lastAction.modelList[0];
        }

        var title = 'Transaction ' + this.position;

        if (type === 'UpdateAction' && model instanceof EventModel) {
          title = 'Edit flight ' + model.name;
        } else if (type === 'UpdateAction' && model instanceof ResourceModel) {
          title = 'Edit gate ' + model.name;
        } else if (type === 'RemoveAction' && model instanceof EventModel) {
          title = 'Remove flight ' + model.name;
        } else if (type === 'RemoveAction' && model instanceof ResourceModel) {
          title = 'Remove gate ' + model.name;
        } else if (type === 'AddAction' && model instanceof EventModel) {
          title = 'Add flight ' + model.name;
        } else if (type === 'AddAction' && model instanceof DependencyModel) {
          title = StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["Link ", " -> ", ""])), model.fromEvent.name, model.toEvent.name);
        }

        return title;
      }
    }
  },
  eventRenderer: function eventRenderer(_ref) {
    var eventRecord = _ref.eventRecord,
        resourceRecord = _ref.resourceRecord,
        renderData = _ref.renderData;
    renderData.iconCls = 'b-fa b-fa-plane';

    if (resourceRecord.isLeaf) {
      renderData.eventColor = 'blue';
      return StringHelper.encodeHtml(eventRecord.name);
    } else {
      renderData.eventColor = 'orange';
      return '';
    }
  },
  tbar: [{
    type: 'undoredo',
    icon: 'b-fa-undo',
    items: {
      transactionsCombo: {
        width: 250,
        displayValueRenderer: function displayValueRenderer(value, combo) {
          var stmPos = combo.up('panel', true).project.stm.position || 0;
          return stmPos + ' undo actions / ' + (this.store.count - stmPos) + ' redo actions';
        }
      }
    }
  }]
});