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
    DateHelper = _bryntum$scheduler.DateHelper,
    AjaxStore = _bryntum$scheduler.AjaxStore,
    Scheduler = _bryntum$scheduler.Scheduler,
    EventModel = _bryntum$scheduler.EventModel,
    Toast = _bryntum$scheduler.Toast,
    StringHelper = _bryntum$scheduler.StringHelper;

var Task = /*#__PURE__*/function (_EventModel) {
  _inherits(Task, _EventModel);

  var _super = _createSuper(Task);

  function Task() {
    _classCallCheck(this, Task);

    return _super.apply(this, arguments);
  }

  _createClass(Task, null, [{
    key: "fields",
    get: function get() {
      return ['floor', 'room', {
        name: 'eventType',
        defaultValue: 'Meeting'
      }];
    }
  }]);

  return Task;
}(EventModel);

var scheduler; // CrudManager is responsible for the data

var floors = new AjaxStore({
  storeId: 'floors'
});
var rooms = new AjaxStore({
  storeId: 'rooms'
});
scheduler = new Scheduler({
  appendTo: 'container',
  eventStyle: 'border',
  resourceImagePath: '../_shared/images/users/',
  features: {
    stripe: true,
    timeRanges: true,
    eventEdit: {
      // Add extra widgets to the event editor
      items: {
        eventType: {
          type: 'combo',
          name: 'eventType',
          label: 'Type',
          weight: 110,
          items: ['Appointment', 'Internal', 'Meeting'],
          listeners: {
            // TODO move this code to the event editor
            // #7809 - eventType field should update visibility of the other EventEditor fields
            change: function change(_ref) {
              var combo = _ref.source,
                  value = _ref.value;
              // toggle visibility of widgets belonging to eventTypes
              combo.owner.items.forEach(function (widget) {
                if (widget.dataset && widget.dataset.eventType) {
                  widget.hidden = widget.dataset.eventType !== value;
                }
              });
            }
          }
        },
        floor: {
          type: 'combo',
          store: floors,
          name: 'floor',
          label: 'Floor',
          placeholder: 'Select floor...',
          weight: 120,
          editable: false,
          clearable: true,
          dataset: {
            eventType: 'Meeting'
          },
          // This field is only displayed for meetings
          listeners: {
            change: function change(_ref2) {
              var combo = _ref2.source,
                  value = _ref2.value;
              var roomCombo = combo.owner.widgetMap.roomCombo;

              if (combo.record) {
                roomCombo.store.filter('floorId', value);
                roomCombo.disabled = false; // if the selected record has been filtered out need to reset value

                var index = roomCombo.store.indexOf(roomCombo.record); // check both undefined and -1 until https://app.assembla.com/spaces/bryntum/tickets/8890 is resolved

                if (index === -1 || index == null) {
                  roomCombo.value = null;
                }
              } else {
                roomCombo.value = null;
                roomCombo.disabled = true;
              }
            }
          }
        },
        roomCombo: {
          type: 'combo',
          ref: 'roomCombo',
          store: rooms,
          name: 'room',
          label: 'Room',
          placeholder: 'Select room...',
          weight: 130,
          editable: false,
          clearable: true,
          disabled: true,
          dataset: {
            eventType: 'Meeting'
          } // This field is only displayed for meetings

        }
      }
    }
  },
  subGridConfigs: {
    locked: {
      width: 400
    }
  },
  columns: [{
    type: 'resourceInfo',
    text: 'Staff',
    flex: 1
  }, {
    text: 'Type',
    field: 'role',
    width: 150,
    editor: {
      type: 'combo',
      items: ['Sales', 'Developer', 'Marketing', 'Product manager', 'CEO', 'CTO'],
      editable: false,
      pickerWidth: 140
    }
  }],
  crudManager: {
    autoLoad: true,
    stores: [floors, rooms],
    transport: {
      load: {
        url: 'data/data.json'
      }
    },
    eventStore: {
      modelClass: Task
    }
  },
  eventColor: null,
  // disable default color for events (colors are set in scss file depending on its type)
  barMargin: 2,
  rowHeight: 50,
  startDate: new Date(2019, 1, 7, 8),
  endDate: new Date(2019, 1, 7, 22),
  viewPreset: {
    base: 'hourAndDay',
    tickWidth: 100
  },
  // Specialized body template with header and footer
  eventBodyTemplate: function eventBodyTemplate(data) {
    return StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["\n        <i class=\"", "\"></i>\n        <section>\n        <div class=\"b-sch-event-header\">", "</div>\n        <div class=\"b-sch-event-footer\">", "</div>\n        </section>"])), data.iconCls || '', data.headerText, data.footerText);
  },
  eventRenderer: function eventRenderer(_ref3) {
    var eventRecord = _ref3.eventRecord,
        resourceRecord = _ref3.resourceRecord,
        renderData = _ref3.renderData;
    renderData.cls.add("b-sch-eventtype-".concat(eventRecord.eventType));
    var headerText = DateHelper.format(eventRecord.startDate, 'LT');

    if (eventRecord.eventType === 'Meeting') {
      if (eventRecord.floor) {
        headerText += " | Floor #".concat(eventRecord.floor);
      }

      if (eventRecord.room) {
        headerText += " | Room #".concat(eventRecord.room);
      }
    }

    return {
      headerText: headerText,
      footerText: eventRecord.name || '',
      iconCls: eventRecord.iconCls
    };
  },
  listeners: {
    beforeEventEditShow: function beforeEventEditShow(_ref4) {
      var eventRecord = _ref4.eventRecord,
          editor = _ref4.editor;
      editor.title = eventRecord.eventStore ? "Edit ".concat(eventRecord.eventType || '') : 'Add new event';
    }
  },
  tbar: [{
    type: 'button',
    icon: 'b-icon-add',
    text: 'Add new event',
    onAction: function onAction() {
      var resource = scheduler.resourceStore.first;

      if (!resource) {
        Toast.show('There is no resource available');
        return;
      }

      var event = new Task({
        resourceId: resource.id,
        startDate: scheduler.startDate,
        duration: 1,
        durationUnit: 'h',
        name: 'New task'
      });
      scheduler.editEvent(event);
    }
  }, {
    type: 'button',
    icon: 'b-icon-trash',
    color: 'b-red',
    text: 'Clear all events',
    onAction: function onAction() {
      return scheduler.eventStore.removeAll();
    }
  }]
});