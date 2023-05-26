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

var _bryntum$scheduler = bryntum.scheduler,
    DragHelper = _bryntum$scheduler.DragHelper,
    WidgetHelper = _bryntum$scheduler.WidgetHelper,
    Grid = _bryntum$scheduler.Grid,
    Scheduler = _bryntum$scheduler.Scheduler,
    DateHelper = _bryntum$scheduler.DateHelper,
    StringHelper = _bryntum$scheduler.StringHelper,
    EventModel = _bryntum$scheduler.EventModel,
    AjaxStore = _bryntum$scheduler.AjaxStore;

var Drag = /*#__PURE__*/function (_DragHelper) {
  _inherits(Drag, _DragHelper);

  var _super = _createSuper(Drag);

  function Drag() {
    _classCallCheck(this, Drag);

    return _super.apply(this, arguments);
  }

  _createClass(Drag, [{
    key: "construct",
    value: function construct(config) {
      var me = this;

      _get(_getPrototypeOf(Drag.prototype), "construct", this).call(this, config);

      me.on({
        dragstart: me.onEquipmentDragStart,
        drop: me.onEquipmentDrop,
        thisObj: me
      });
    }
  }, {
    key: "onEquipmentDragStart",
    value: function onEquipmentDragStart(_ref) {
      var event = _ref.event,
          context = _ref.context;
      // save a reference to the equipment so we can access it later
      context.equipment = this.grid.getRecordFromElement(context.grabbed); // Prevent tooltips from showing while dragging

      this.schedule.element.classList.add('b-dragging-event');
    }
  }, {
    key: "onEquipmentDrop",
    value: function onEquipmentDrop(_ref2) {
      var context = _ref2.context;
      var me = this;

      if (context.valid) {
        var equipment = context.equipment,
            eventRecord = me.schedule.resolveEventRecord(context.target);
        eventRecord.equipment = eventRecord.equipment.concat(equipment);
        me.context.finalize(); // Dropped on a scheduled event, display toast

        WidgetHelper.toast("Added ".concat(equipment.name, " to ").concat(eventRecord.name));
      }

      me.schedule.element.classList.remove('b-dragging-event');
    }
  }], [{
    key: "defaultConfig",
    get: function get() {
      return {
        // Don't drag the actual cell element, clone it
        cloneTarget: true,
        mode: 'translateXY',
        // Only allow drops on scheduled tasks
        dropTargetSelector: '.b-sch-event',
        // Only allow dragging cell elements inside on the equipment grid
        targetSelector: '.b-grid-row:not(.b-group-row) .b-grid-cell'
      };
    }
  }]);

  return Drag;
}(DragHelper);

;

var EquipmentGrid = /*#__PURE__*/function (_Grid) {
  _inherits(EquipmentGrid, _Grid);

  var _super2 = _createSuper(EquipmentGrid);

  function EquipmentGrid() {
    _classCallCheck(this, EquipmentGrid);

    return _super2.apply(this, arguments);
  }

  _createClass(EquipmentGrid, null, [{
    key: "$name",
    get:
    /**
     * Original class name getter. See Widget.$name docs for the details.
     * @return {string}
     */
    function get() {
      return 'EquipmentGrid';
    } // Factoryable type name

  }, {
    key: "type",
    get: function get() {
      return 'equipmentgrid';
    }
  }, {
    key: "defaultConfig",
    get: function get() {
      return {
        features: {
          filterBar: true,
          cellEdit: false
        },
        rowHeight: 100,
        columns: [{
          text: '',
          field: 'name',
          htmlEncode: false,
          cellCls: 'b-equipment',
          renderer: function renderer(data) {
            return "<i class=\"".concat(data.record.iconCls, "\"></i>").concat(data.record.name);
          }
        }]
      };
    }
  }]);

  return EquipmentGrid;
}(Grid);

; // Register this widget type with its Factory

EquipmentGrid.initClass();

var Schedule = /*#__PURE__*/function (_Scheduler) {
  _inherits(Schedule, _Scheduler);

  var _super3 = _createSuper(Schedule);

  function Schedule() {
    _classCallCheck(this, Schedule);

    return _super3.apply(this, arguments);
  }

  _createClass(Schedule, [{
    key: "construct",
    value: function construct(config) {
      var me = this;

      _get(_getPrototypeOf(Schedule.prototype), "construct", this).call(this, config);

      me.on({
        eventEditBeforeSetRecord: me.onBeforeRecordLoaded,
        thisObj: me,
        once: true
      });
      me.equipmentStore.on('load', me.onEquipmentStoreLoad, me);
    } // Populate the equipment combo first time editor is shown

  }, {
    key: "onBeforeRecordLoaded",
    value: function onBeforeRecordLoaded(_ref3) {
      var editor = _ref3.source;
      var equipmentCombo = editor.widgetMap.equipment;

      if (!equipmentCombo.items.length) {
        equipmentCombo.items = this.equipmentStore.getRange();
      }
    }
  }, {
    key: "onEquipmentStoreLoad",
    value: function onEquipmentStoreLoad() {
      // Setup the data for the equipment combo inside the event editor
      // Since the event bars contain icons for equipment, we need to refresh rows once equipment store is available
      this.refreshRows();
    }
  }], [{
    key: "$name",
    get:
    /**
     * Original class name getter. See Widget.$name docs for the details.
     * @return {string}
     */
    function get() {
      return 'Schedule';
    } // Factoryable type name

  }, {
    key: "type",
    get: function get() {
      return 'schedule';
    }
  }, {
    key: "defaultConfig",
    get: function get() {
      return {
        features: {
          eventMenu: {
            items: [// custom item with inline handler
            {
              text: 'Remove all equipment',
              icon: 'b-fa b-fa-times',
              weight: 200,
              onItem: function onItem(_ref4) {
                var eventRecord = _ref4.eventRecord;
                return eventRecord.equipment = [];
              }
            }]
          },
          eventEdit: {
            // Add an extra combo box to the editor to select equipment
            items: {
              equipment: {
                type: 'combo',
                weight: 900,
                // At end
                editable: false,
                multiSelect: true,
                valueField: 'id',
                displayField: 'name',
                ref: 'equipment',
                name: 'equipment',
                label: 'Equipment',
                // Will be populated with items on first show
                items: []
              }
            }
          }
        },
        rowHeight: 100,
        barMargin: 4,
        eventColor: 'indigo',
        resourceImagePath: '../_shared/images/users/',
        columns: [{
          type: 'resourceInfo',
          text: 'Name',
          width: 200,
          showEventCount: false,
          showRole: true
        }],
        // The crud manager will load all its data (resource + events) in one ajax request
        crudManager: {
          autoLoad: true,
          transport: {
            load: {
              url: 'data/data.json'
            }
          }
        },
        // Custom view preset with header configuration
        viewPreset: {
          base: 'hourAndDay',
          columnLinesFor: 0,
          mainHeaderLevel: 1,
          headers: [{
            unit: 'd',
            align: 'center',
            dateFormat: 'ddd DD MMM'
          }, {
            unit: 'h',
            align: 'center',
            dateFormat: 'HH'
          }]
        },
        // Render some extra elements for the assignment equipment items
        eventBodyTemplate: function eventBodyTemplate(data) {
          return "\n                <div class=\"b-sch-event-header\">".concat(data.date, " - ").concat(StringHelper.encodeHtml(data.name), "</div>\n                <ul class=\"b-sch-event-footer\">\n                    ").concat(data.equipment.map(function (item) {
            return "<li title=\"".concat(StringHelper.encodeHtml(item.name), "\" class=\"").concat(item.iconCls, "\"></li>");
          }).join(''), "\n                </ul>\n            ");
        },
        eventRenderer: function eventRenderer(_ref5) {
          var _this = this;

          var eventRecord = _ref5.eventRecord;
          return {
            date: DateHelper.format(eventRecord.startDate, 'LT'),
            name: eventRecord.name || '',
            equipment: eventRecord.equipment.map(function (itemId) {
              return _this.equipmentStore.getById(itemId) || {};
            })
          };
        }
      };
    }
  }]);

  return Schedule;
}(Scheduler);

; // Register this widget type with its Factory

Schedule.initClass();
/* eslint-disable no-unused-vars */

var Task = /*#__PURE__*/function (_EventModel) {
  _inherits(Task, _EventModel);

  var _super4 = _createSuper(Task);

  function Task() {
    _classCallCheck(this, Task);

    return _super4.apply(this, arguments);
  }

  _createClass(Task, null, [{
    key: "fields",
    get: function get() {
      return ['equipment'];
    }
  }, {
    key: "defaults",
    get: function get() {
      return {
        // in this demo, default duration for tasks will be hours (instead of days)
        durationUnit: 'h',
        equipment: []
      };
    }
  }]);

  return Task;
}(EventModel);
/* eslint-disable no-unused-vars */


var equipmentStore = new AjaxStore({
  modelClass: Task,
  readUrl: 'data/equipment.json',
  sorters: [{
    field: 'name',
    ascending: true
  }]
});
var schedule = new Schedule({
  ref: 'schedule',
  appendTo: 'bodycontainer',
  startDate: new Date(2017, 11, 1, 8),
  endDate: new Date(2017, 11, 1, 18),
  equipmentStore: equipmentStore,
  crudManager: {
    autoLoad: true,
    eventStore: {
      modelClass: Task
    },
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  }
});
equipmentStore.load(); // Create our list of equipment

var equipmentGrid = new EquipmentGrid({
  ref: 'equipment',
  appendTo: 'bodycontainer',
  eventStore: schedule.eventStore,
  // Use a chained Store to avoid its filtering to interfere with Scheduler's rendering
  store: equipmentStore.makeChained(function () {
    return true;
  })
});
var drag = new Drag({
  grid: equipmentGrid,
  schedule: schedule,
  outerElement: equipmentGrid.element
});