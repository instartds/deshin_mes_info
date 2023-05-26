var _templateObject, _templateObject2;

function _taggedTemplateLiteral(strings, raw) { if (!raw) { raw = strings.slice(0); } return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    StringHelper = _bryntum$scheduler.StringHelper;

var listItemTpl = function listItemTpl(item) {
  return StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["<div class=\"color-box b-sch-", "\"></div><div>", "</div>"])), item.value, item.value);
};

var // Event style to apply to all events
eventStyle = null,
    // Color to apply to all events
eventColor = null;

function hideMilestones() {
  scheduler.eventStore.filter(function (eventRecord) {
    return !eventRecord.isMilestone;
  });
}

function showMilestones(withWidth) {
  scheduler.eventStore.clearFilters();

  if (withWidth) {
    scheduler.milestoneLayoutMode = 'measure';
  } else {
    scheduler.milestoneLayoutMode = 'default';
  }
}

var scheduler = new Scheduler({
  appendTo: 'container',
  startDate: new Date(2017, 0, 1, 6),
  endDate: new Date(2017, 0, 1, 20),
  viewPreset: 'hourAndDay',
  barMargin: 5,
  rowHeight: 50,
  multiEventSelect: true,
  features: {
    cellEdit: false,
    // Not yet compatible with the event styles which center their content
    stickyEvents: false,
    eventDrag: {
      constrainDragToResource: true
    },
    eventEdit: {
      items: {
        resourceField: false,
        nameField: false,
        eventStyle: {
          type: 'combo',
          label: 'Style',
          name: 'eventStyle',
          editable: false,
          weight: 10,
          items: Scheduler.eventStyles
        },
        eventColor: {
          type: 'combo',
          label: 'Color',
          name: 'eventColor',
          editable: false,
          weight: 20,
          listItemTpl: listItemTpl,
          items: Scheduler.eventColors
        }
      }
    }
  },
  columns: [{
    text: 'Name',
    field: 'name',
    htmlEncode: false,
    width: 130,
    renderer: function renderer(_ref) {
      var record = _ref.record;
      return StringHelper.xss(_templateObject2 || (_templateObject2 = _taggedTemplateLiteral(["<div class=\"color-box b-sch-", "\"></div>", ""])), record.name.toLowerCase(), record.name);
    }
  }],
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    },
    listeners: {
      load: function load() {
        hideMilestones();
      }
    }
  },
  eventRenderer: function eventRenderer(_ref2) {
    var eventRecord = _ref2.eventRecord,
        renderData = _ref2.renderData;

    // If a color is specified, apply it to all events
    if (eventColor) {
      renderData.eventColor = eventColor;
    } // And the same for event styles


    if (eventStyle) {
      renderData.eventStyle = eventStyle;
    }

    return renderData.eventStyle + ' ' + renderData.eventColor;
  },
  tbar: [{
    type: 'widget',
    cls: 'b-has-label',
    html: '<label>Milestones</label>'
  }, {
    type: 'buttongroup',
    toggleGroup: true,
    style: 'margin-left : 0',
    items: [{
      text: 'None',
      pressed: true,
      onClick: function onClick() {
        hideMilestones();
      }
    }, {
      text: 'Normal',
      onClick: function onClick() {
        showMilestones(false);
      }
    }, {
      text: 'Width',
      onClick: function onClick() {
        showMilestones(true);
      }
    }]
  }, {
    type: 'combo',
    items: ['mixed'].concat(Scheduler.eventStyles),
    value: 'mixed',
    label: 'Style',
    editable: false,
    listCls: 'style-list',
    // Match events element structure to have matching look in the list
    listItemTpl: function listItemTpl(item) {
      return "\n            <div class=\"b-sch-event-wrap b-sch-style-".concat(item.value, " b-sch-color-red\">\n                <div class=\"b-sch-event\">\n                    <div class=\"b-sch-event-content\">").concat(item.value, "</div>\n                    </div>\n            </div>");
    },
    onSelect: function onSelect(_ref3) {
      var record = _ref3.record;

      // Picked "Mixed", use styles from data
      if (record.value === 'mixed') {
        eventStyle = null;
      } // Picked a named style, use it
      else {
          eventStyle = record.value;
        }

      scheduler.refreshWithTransition();
    }
  }, {
    ref: 'colorCombo',
    type: 'combo',
    items: ['mixed', 'custom'].concat(Scheduler.eventColors),
    value: 'mixed',
    label: 'Color',
    editable: false,
    width: '13em',
    listItemTpl: listItemTpl,
    onSelect: function onSelect(_ref4) {
      var record = _ref4.record;
      var customColor = scheduler.widgetMap.customColor;
      customColor.hide(); // Picked "Mixed", use colors from data

      if (record.value === 'mixed') {
        eventColor = null;
      } // Picked "Custom", display text field to input custom color
      else if (record.value === 'custom') {
          customColor.show();
          customColor.focus();

          if (customColor.value) {
            eventColor = customColor.value;
          }
        } // Picked a named color, use it
        else {
            eventColor = record.value;
          }

      scheduler.refreshWithTransition();
    }
  }, {
    ref: 'customColor',
    type: 'textfield',
    label: 'Custom hex',
    inputWidth: '6em',
    hidden: true,
    listeners: {
      change: function change(_ref5) {
        var value = _ref5.value;
        eventColor = value;
        scheduler.refreshWithTransition();
      }
    }
  }]
});