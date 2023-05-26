function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

var _templateObject, _templateObject2, _templateObject3;

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr == null ? null : typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]; if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

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
    ResourceModel = _bryntum$scheduler.ResourceModel,
    EventModel = _bryntum$scheduler.EventModel,
    DateHelper = _bryntum$scheduler.DateHelper,
    Scheduler = _bryntum$scheduler.Scheduler,
    Toast = _bryntum$scheduler.Toast,
    MessageDialog = _bryntum$scheduler.MessageDialog,
    StringHelper = _bryntum$scheduler.StringHelper;

var Employee = /*#__PURE__*/function (_ResourceModel) {
  _inherits(Employee, _ResourceModel);

  var _super = _createSuper(Employee);

  function Employee() {
    _classCallCheck(this, Employee);

    return _super.apply(this, arguments);
  }

  _createClass(Employee, [{
    key: "cls",
    get: function get() {
      return this.available ? '' : 'unavailable';
    }
  }], [{
    key: "fields",
    get: function get() {
      return [{
        name: 'available',
        type: 'boolean',
        defaultValue: true
      }, {
        name: 'statusMessage',
        defaultValue: 'Gone fishing'
      }];
    }
  }]);

  return Employee;
}(ResourceModel);

var Task = /*#__PURE__*/function (_EventModel) {
  _inherits(Task, _EventModel);

  var _super2 = _createSuper(Task);

  function Task() {
    _classCallCheck(this, Task);

    return _super2.apply(this, arguments);
  }

  _createClass(Task, [{
    key: "dragValidationText",
    get: function get() {
      var resource = this.resource,
          type = this.type;
      var result = '';

      switch (type) {
        case 'Golf':
          result = 'Only C-suite people can play Golf';
          break;

        case 'Meeting':
          result = "Only ".concat(resource.role, " can participate in meetings");
          break;

        case 'Coding':
          result = "Only ".concat(resource.role, " can do coding");
          break;

        case 'Sales':
          result = "Only ".concat(resource.role, " can prepare marketing strategies");
          break;

        case 'Fixed':
          result = 'Fixed time event - may be reassigned, but not rescheduled';
          break;
      }

      return result;
    }
  }, {
    key: "resizeValidationText",
    get: function get() {
      var result = '';

      switch (this.type) {
        case 'Golf':
          result = 'Golf game has always fixed duration';
          break;

        case 'Coding':
          result = 'Programming task duration cannot be shortened';
          break;
      }

      return result;
    }
  }], [{
    key: "fields",
    get: function get() {
      return ['type'];
    }
  }]);

  return Task;
}(EventModel);

var scheduler = new Scheduler({
  appendTo: 'container',
  // don't allow tasks to overlap
  allowOverlap: false,
  resourceImagePath: '../_shared/images/users/',
  features: {
    stripe: true,
    timeRanges: true,
    eventTooltip: {
      template: function template(data) {
        var task = data.eventRecord;
        return "\n                    ".concat(task.name ? StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["<div class=\"b-sch-event-title\">", "</div>"])), task.name) : '', "\n                    ").concat(data.startClockHtml, "\n                    ").concat(data.endClockHtml, "\n                    ").concat(task.dragValidationText || task.resizeValidationText ? "<div class=\"restriction-title\"><b>Restrictions:</b></div>\n                    <ul class=\"restriction-list\">\n                        ".concat(task.dragValidationText ? "<li>".concat(task.dragValidationText, "</li>") : '', "\n                        ").concat(task.resizeValidationText ? "<li>".concat(task.resizeValidationText, "</li>") : '', "\n                    </ul>") : '', "\n                ");
      }
    },
    eventDrag: {
      validatorFn: function validatorFn(_ref) {
        var draggedRecords = _ref.draggedRecords,
            newResource = _ref.newResource;
        var task = draggedRecords[0],
            isValid = task.type === 'Fixed' || // Only C-suite people can play Golf
        task.type === 'Golf' && ['CEO', 'CTO'].includes(newResource.role) || // Tasks that have type defined cannot be assigned to another resource type
        !(task.type && newResource.role !== task.resource.role);
        return {
          valid: newResource.available && isValid,
          message: !newResource.available ? newResource.statusMessage : !isValid ? task.dragValidationText : ''
        };
      }
    },
    eventResize: {
      validatorFn: function validatorFn(_ref2) {
        var task = _ref2.eventRecord,
            endDate = _ref2.endDate,
            startDate = _ref2.startDate;
        var originalDuration = task.endDate - task.startDate,
            isValid = !(task.type === 'Golf' || task.type === 'Coding' && originalDuration > endDate - startDate);
        return {
          valid: isValid,
          message: isValid ? '' : task.resizeValidationText
        };
      }
    },
    eventDragCreate: {
      validatorFn: function validatorFn(_ref3) {
        var resource = _ref3.resourceRecord;
        return {
          valid: resource.available,
          message: resource.available ? '' : resource.statusMessage
        };
      }
    }
  },
  subGridConfigs: {
    locked: {
      width: 350
    }
  },
  columns: [{
    type: 'resourceInfo',
    text: 'Staff'
  }, {
    text: 'Role',
    field: 'role',
    flex: 1,
    editor: {
      type: 'combo',
      items: ['Sales', 'Developer', 'Marketing', 'Product manager'],
      editable: false,
      pickerWidth: 140
    }
  }, {
    text: 'Available',
    type: 'check',
    field: 'available'
  }],
  crudManager: {
    autoLoad: true,
    eventStore: {
      modelClass: Task
    },
    resourceStore: {
      modelClass: Employee
    },
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  barMargin: 2,
  rowHeight: 50,
  startDate: new Date(2019, 1, 7, 8),
  endDate: new Date(2019, 1, 7, 22),
  viewPreset: {
    base: 'hourAndDay',
    tickWidth: 100
  },
  multiEventSelect: true,
  // Specialized body template with header and footer
  eventBodyTemplate: function eventBodyTemplate(data) {
    return "".concat(data.iconCls ? "<i class=\"".concat(data.iconCls, "\"></i>") : '') + StringHelper.xss(_templateObject2 || (_templateObject2 = _taggedTemplateLiteral(["<section>\n            <div class=\"b-sch-event-header\">", "</div>\n            <div class=\"b-sch-event-footer\">", "</div>\n        </section>\n    "])), data.headerText, data.footerText);
  },
  eventRenderer: function eventRenderer(_ref4) {
    var eventRecord = _ref4.eventRecord,
        resourceRecord = _ref4.resourceRecord,
        renderData = _ref4.renderData;
    return {
      headerText: DateHelper.format(eventRecord.startDate, 'LT'),
      footerText: eventRecord.name || '',
      iconCls: eventRecord.iconCls
    };
  },
  listeners: {
    beforeEventAdd: function beforeEventAdd(_ref5) {
      var resourceRecords = _ref5.resourceRecords;

      var _resourceRecords = _slicedToArray(resourceRecords, 1),
          resource = _resourceRecords[0],
          available = resource.available;

      if (!available) {
        Toast.show("Resource not available: ".concat(resource.statusMessage));
      }

      return available;
    },
    beforeEventDrag: function beforeEventDrag(_ref6) {
      var eventRecord = _ref6.eventRecord;
      // Only Henrik can be assigned Marketing tasks.
      // constrainDragToResource prevents dragging up or down.
      scheduler.features.eventDrag.constrainDragToResource = eventRecord.type === 'Marketing' && eventRecord.resource.name === 'Henrik'; // Events with type Fixed must not change time slot.

      scheduler.features.eventDrag.constrainDragToTimeSlot = eventRecord.type === 'Fixed';
    },
    beforeEventDropFinalize: function beforeEventDropFinalize(_ref7) {
      return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
        var scheduler, context, namesInQuotes, result;
        return regeneratorRuntime.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                scheduler = _ref7.source, context = _ref7.context;

                if (!scheduler.confirmationsEnabled) {
                  _context.next = 8;
                  break;
                }

                context.async = true;
                namesInQuotes = context.draggedRecords.map(function (eventRecord) {
                  return "\"".concat(StringHelper.encodeHtml(eventRecord.name), "\"");
                });
                _context.next = 6;
                return MessageDialog.confirm({
                  title: 'Please confirm',
                  message: "".concat(namesInQuotes.join(', '), " ").concat(namesInQuotes.length > 1 ? 'were' : 'was', " moved. Allow this operation?")
                });

              case 6:
                result = _context.sent;
                // `true` to accept the changes or `false` to reject them
                context.finalize(result === MessageDialog.yesButton);

              case 8:
              case "end":
                return _context.stop();
            }
          }
        }, _callee);
      }))();
    },
    beforeeventresizefinalize: function beforeeventresizefinalize(_ref8) {
      return _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
        var scheduler, context, eventRecord, result;
        return regeneratorRuntime.wrap(function _callee2$(_context2) {
          while (1) {
            switch (_context2.prev = _context2.next) {
              case 0:
                scheduler = _ref8.source, context = _ref8.context;

                if (!scheduler.confirmationsEnabled) {
                  _context2.next = 8;
                  break;
                }

                context.async = true;
                eventRecord = context.eventRecord;
                _context2.next = 6;
                return MessageDialog.confirm({
                  title: 'Please confirm',
                  message: StringHelper.xss(_templateObject3 || (_templateObject3 = _taggedTemplateLiteral(["\"", "\" duration changed. Allow this operation?"])), eventRecord.name)
                });

              case 6:
                result = _context2.sent;
                // `true` to accept the changes or `false` to reject them
                context.finalize(result === MessageDialog.yesButton);

              case 8:
              case "end":
                return _context2.stop();
            }
          }
        }, _callee2);
      }))();
    }
  },
  tbar: [{
    type: 'button',
    ref: 'confirmationBtn',
    text: 'Enable confirmations',
    toggleable: true,
    icon: 'b-fa-square',
    pressedIcon: 'b-fa-check-square',
    onAction: function onAction(_ref9) {
      var button = _ref9.source;
      return scheduler.confirmationsEnabled = button.pressed;
    }
  }, {
    type: 'button',
    ref: 'lockBtn',
    text: 'Read only',
    toggleable: true,
    icon: 'b-fa-square',
    pressedIcon: 'b-fa-check-square',
    onAction: function onAction(_ref10) {
      var button = _ref10.source;
      return scheduler.readOnly = button.pressed;
    }
  }]
});