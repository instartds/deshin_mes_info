function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr == null ? null : typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]; if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

// eslint-disable-next-line no-unused-vars,import/extensions
var scheduler = new Scheduler({
  appendTo: 'container',
  startDate: new Date(2018, 4, 21, 6),
  endDate: new Date(2018, 4, 21, 18),
  viewPreset: 'hourAndDay',
  rowHeight: 50,
  barMargin: 5,
  eventColor: 'blue',
  passStartEndParameters: true,
  features: {
    // Configure event editor to display 'brand' as resource name
    eventEdit: {
      resourceFieldConfig: {
        displayField: 'name'
      }
    }
  },
  columns: [{
    text: 'Id',
    field: 'id',
    width: 100,
    editor: false,
    hidden: true
  }, {
    text: 'Name',
    field: 'name',
    width: 150
  }],
  eventRenderer: function eventRenderer(_ref) {
    var eventRecord = _ref.eventRecord;
    return eventRecord.name;
  },
  crudManager: {
    resourceStore: {
      fields: [{
        name: 'id',
        dataSource: 'Id'
      }, {
        name: 'name',
        dataSource: 'Name'
      }]
    },
    eventStore: {
      fields: [{
        name: 'id',
        dataSource: 'Id'
      }, {
        name: 'name',
        dataSource: 'Name'
      }, {
        name: 'startDate',
        dataSource: 'StartDate',
        type: 'date'
      }, {
        name: 'endDate',
        dataSource: 'EndDate',
        type: 'date'
      }, {
        name: 'resourceId',
        dataSource: 'ResourceId',
        convert: function convert(v) {
          return Number(v);
        }
      }, {
        name: 'cls',
        dataSource: 'Cls'
      }, {
        name: 'draggable',
        dataSource: 'Draggable'
      }, {
        name: 'resizable',
        dataSource: 'Resizable'
      }]
    },
    transport: {
      load: {
        url: 'schedulercrud/load',
        paramName: 'q'
      },
      sync: {
        url: 'schedulercrud/sync'
      }
    },
    autoLoad: false,
    autoSync: false
  }
});
scheduler.crudManager.load().then(function () {
  scheduler.zoomToFit();
});
scheduler.crudManager.on({
  hasChanges: function hasChanges() {
    syncButton.disabled = false;
  },
  noChanges: function noChanges() {
    syncButton.disabled = true;
  }
}); //region Widgets

var _WidgetHelper$append = WidgetHelper.append([{
  type: 'button',
  ref: 'loadButton',
  color: 'b-orange b-raised',
  icon: 'b-fa b-fa-sync',
  tooltip: 'Reload data',
  onAction: function onAction() {
    scheduler.crudManager.load().then(function () {
      WidgetHelper.toast('Data reloaded');
    }).catch(function () {
      WidgetHelper.toast('Error reloading data');
    });
  }
}, {
  type: 'button',
  ref: 'syncButton',
  color: 'b-green b-raised',
  icon: 'b-fa b-fa-save',
  disabled: true,
  tooltip: 'Sync changes',
  onAction: function onAction() {
    scheduler.crudManager.sync().then(function () {
      WidgetHelper.toast('Changes are synchronized');
    }).catch(function () {
      WidgetHelper.toast('Error synchronizing changes');
    });
  }
}, {
  type: 'checkbox',
  ref: 'checkAutoSync',
  text: 'Auto-sync changes',
  onChange: function onChange(_ref2) {
    var checked = _ref2.checked;
    syncButton.hidden = scheduler.crudManager.autoSync = checked;
  }
}], {
  appendTo: document.getElementById('tools') || document.body
}),
    _WidgetHelper$append2 = _slicedToArray(_WidgetHelper$append, 2),
    syncButton = _WidgetHelper$append2[1]; //endregion