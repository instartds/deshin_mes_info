function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr == null ? null : typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]; if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

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
    Toast = _bryntum$scheduler.Toast,
    ArrayHelper = _bryntum$scheduler.ArrayHelper,
    DateHelper = _bryntum$scheduler.DateHelper,
    Scheduler = _bryntum$scheduler.Scheduler,
    EventModel = _bryntum$scheduler.EventModel;
/* eslint-disable no-unused-vars,no-undef */
// Will hold record currently being edited

var editingRecord = null;

var Match = /*#__PURE__*/function (_EventModel) {
  _inherits(Match, _EventModel);

  var _super = _createSuper(Match);

  function Match() {
    _classCallCheck(this, Match);

    return _super.apply(this, arguments);
  }

  _createClass(Match, null, [{
    key: "fields",
    get: function get() {
      return [{
        name: 'duration',
        defaultValue: 3
      }, {
        name: 'durationUnit',
        defaultValue: 'h'
      }];
    }
  }]);

  return Match;
}(EventModel);

var scheduler = new Scheduler({
  appendTo: 'container',
  startDate: new Date(2020, 8, 18),
  endDate: new Date(2020, 8, 29),
  viewPreset: 'dayAndWeek',
  rowHeight: 85,
  barMargin: 0,
  fillTicks: true,
  tickSize: 215,
  createEventOnDblClick: false,
  // These are set to null to have less default styling from Scheduler interfering with custom CSS.
  // Makes life easier when you are creating a custom look
  eventColor: null,
  eventStyle: null,
  // CrudManager is used to load data to all stores in one go (Events, Resources and Assignments)
  crudManager: {
    autoLoad: true,
    eventStore: {
      // Provide our custom event model representing a single match
      modelClass: Match
    },
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  features: {
    // Features disabled to give a better demo experience
    eventDragCreate: false,
    eventResize: false,
    columnLines: false,
    // Initial sort
    sort: 'name'
  },
  columns: [{
    text: 'Name',
    field: 'name',
    width: 130
  }],
  // A custom eventRenderer, used to generate the contents of the events
  eventRenderer: function eventRenderer(_ref) {
    var eventRecord = _ref.eventRecord,
        assignmentRecord = _ref.assignmentRecord,
        renderData = _ref.renderData;

    var resources = eventRecord.resources,
        startTime = DateHelper.format(eventRecord.startDate, 'HH:mm'),
        _resources = _slicedToArray(resources, 2),
        home = _resources[0],
        away = _resources[1],
        homeGame = assignmentRecord.resource === home; // Different icons depending on if the game is at home or away


    renderData.iconCls = homeGame ? 'b-fa b-fa-hockey-puck' : 'b-fa b-fa-shuttle-van'; // HTML config:
    // <div class="time">19:00</div>
    // Home - Away
    // <div class="arena">Arena name</div>

    return {
      children: [{
        className: 'time',
        text: startTime
      }, {
        text: "".concat(home.name, " - ").concat((away === null || away === void 0 ? void 0 : away.name) || 'TBD')
      }, {
        className: 'arena',
        text: home.arena
      }]
    };
  },
  listeners: {
    // Listener called before the built in editor is shown
    beforeEventEdit: function beforeEventEdit(_ref2) {
      var eventRecord = _ref2.eventRecord,
          resourceRecord = _ref2.resourceRecord;
      var teams = eventRecord.resources; // Show custom editor

      $('#customEditor').modal('show'); // Fill its fields

      if (teams.length === 0) {
        // New match being created
        $('#home').val(resourceRecord.id);
      } else {
        var _teams$;

        $('#home').val(teams[0].id);
        $('#away').val(((_teams$ = teams[1]) === null || _teams$ === void 0 ? void 0 : _teams$.id) || '');
      }

      $('#startDate').val(DateHelper.format(eventRecord.startDate, 'YYYY-MM-DD'));
      $('#startTime').val(DateHelper.format(eventRecord.startDate, 'HH:mm')); // Store record being edited, to be able to write changes back to it later

      editingRecord = eventRecord; // Prevent built in editor

      return false;
    }
  }
}); // If they exit *not* via the save click, remove any provisional record added via context menu

$('#customEditor').on('focusout', function (e) {
  // Focus has exited the modal popup
  if (!e.currentTarget.contains(e.relatedTarget)) {
    if (editingRecord.isCreating) {
      editingRecord.remove();
    }
  }
}); // When clicking save in the custom editor

$('#save').on('click', function () {
  var assignmentStore = scheduler.assignmentStore,
      eventStore = scheduler.eventStore,
      resourceStore = scheduler.resourceStore,
      home = $('#home').val(),
      away = $('#away').val(),
      date = $('#startDate').val(),
      time = $('#startTime').val(),
      oldTeams = editingRecord.resources,
      newTeams = [resourceStore.getById(away), resourceStore.getById(home)],
      teamChanges = ArrayHelper.delta(newTeams, oldTeams, true);

  if (home === away) {
    Toast.show('A team cannot play itself');
    return false;
  }

  if (!home || !away) {
    Toast.show('Both teams must be selected');
    return false;
  } // Prevent multiple commits from this flow


  assignmentStore.suspendAutoCommit(); // Avoid multiple redraws, from event changes + assignment changes

  scheduler.suspendRefresh();
  editingRecord.beginBatch(); // Update record

  editingRecord.set({
    startDate: DateHelper.parse(date + ' ' + time, 'YYYY-MM-DD HH:mm')
  }); // Update the two teams involved

  eventStore.unassignEventFromResource(editingRecord, teamChanges.toRemove);
  eventStore.assignEventToResource(editingRecord, teamChanges.toAdd);
  editingRecord.endBatch(); // If it was a provisional event, passed in here from drag-create or dblclick or contextmenu,
  // it's now it's no longer a provisional event and will not be removed in thwe focusout handler
  // Also, when promoted to be permanent, auto syncing will kick in if configured.

  editingRecord.isCreating = false;
  assignmentStore.resumeAutoCommit(); // Redraw once

  scheduler.resumeRefresh(true);
});

if (navigator.userAgent.match(/Firefox/) || navigator.userAgent.match(/Safari/)) {
  $('#cancel').on('click', function (e) {
    $('#customEditor').blur();
  });
}