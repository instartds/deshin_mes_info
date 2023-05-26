var _templateObject, _templateObject2, _templateObject3;

function _taggedTemplateLiteral(strings, raw) { if (!raw) { raw = strings.slice(0); } return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

var _bryntum$scheduler = bryntum.scheduler,
    DateHelper = _bryntum$scheduler.DateHelper,
    StringHelper = _bryntum$scheduler.StringHelper,
    Scheduler = _bryntum$scheduler.Scheduler,
    Toast = _bryntum$scheduler.Toast;
var scheduler = new Scheduler({
  appendTo: 'container',
  eventStyle: 'border',
  resourceImagePath: '../_shared/images/users/',
  features: {
    stripe: true,
    timeRanges: true,
    headerZoom: true,
    eventEdit: {
      // Uncomment to make event editor readonly from the start
      // readOnly : true,
      // Add items to the event editor
      items: {
        // Using this ref hooks dynamic toggling of fields per eventType up
        eventTypeField: {
          type: 'combo',
          name: 'eventType',
          label: 'Type',
          // Provided items start at 100, and go up in 100s, so insert after first one
          weight: 110,
          items: ['Appointment', 'Internal', 'Meeting']
        },
        locationField: {
          type: 'text',
          name: 'location',
          label: 'Location',
          weight: 120,
          // This field is only displayed for meetings
          dataset: {
            eventType: 'Meeting'
          }
        },
        eventColorField: {
          type: 'combo',
          label: 'Color',
          name: 'eventColor',
          editable: false,
          weight: 130,
          listItemTpl: function listItemTpl(item) {
            return StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["<div class=\"color-box b-sch-", "\"></div><div>", "</div>"])), item.value, item.text);
          },
          items: Scheduler.eventColors.map(function (color) {
            return [color, StringHelper.capitalize(color)];
          })
        },
        linkField: {
          type: 'displayfield',
          label: 'Link',
          name: 'id',
          weight: 600,
          template: function template(link) {
            return StringHelper.xss(_templateObject2 || (_templateObject2 = _taggedTemplateLiteral(["<a href='//your.app/task/", "' target='blank'>Open in new tab</a></div>"])), link);
          }
        }
      }
    }
  },
  subGridConfigs: {
    locked: {
      width: 300
    }
  },
  columns: [{
    type: 'resourceInfo',
    flex: 1,
    text: 'Staff'
  }, {
    text: 'Type',
    field: 'role',
    flex: 1,
    editor: {
      type: 'combo',
      items: ['Sales', 'Developer', 'Marketing', 'Product manager', 'CEO', 'CTO'],
      editable: false,
      pickerWidth: 140
    }
  }],
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    },
    eventStore: {
      // Extra fields used on EventModels. Store tries to be smart about it and extracts these from the first
      // record it reads, but it is good practice to define them anyway to be certain they are included.
      fields: ['location', {
        name: 'eventType',
        defaultValue: 'Appointment'
      }]
    }
  },
  barMargin: 2,
  rowHeight: 50,
  startDate: new Date(2017, 1, 7, 8),
  endDate: new Date(2017, 1, 7, 22),
  viewPreset: {
    base: 'hourAndDay',
    tickWidth: 100
  },
  // Specialized body template with header and footer
  eventBodyTemplate: function eventBodyTemplate(data) {
    return StringHelper.xss(_templateObject3 || (_templateObject3 = _taggedTemplateLiteral(["<i class=\"", "\"></i><section><div class=\"b-sch-event-header\">", "</div><div class=\"b-sch-event-footer\">", "</div></section>"])), data.iconCls || '', data.headerText, data.footerText);
  },
  eventRenderer: function eventRenderer(_ref) {
    var eventRecord = _ref.eventRecord,
        resourceRecord = _ref.resourceRecord,
        renderData = _ref.renderData;
    renderData.style = 'background-color:' + resourceRecord.color;
    return {
      headerText: DateHelper.format(eventRecord.startDate, 'LT'),
      footerText: eventRecord.name || '',
      iconCls: eventRecord.iconCls
    };
  },
  listeners: {
    eventEditBeforeSetRecord: function eventEditBeforeSetRecord(_ref2) {
      var editor = _ref2.source,
          eventRecord = _ref2.record;
      editor.title = "Edit ".concat(eventRecord.eventType || ''); // Only CEO and CTO roles are allowed to play golf...

      if (eventRecord.name === 'Golf') {
        editor.widgetMap.resourceField.store.filter({
          filterBy: function filterBy(resource) {
            return resource.role.startsWith('C');
          },
          id: 'golfFilter'
        });
      } else {
        // Clear our golf filter before editing starts
        editor.widgetMap.resourceField.store.removeFilter('golfFilter');
      }
    }
  },
  tbar: [{
    type: 'checkbox',
    label: 'Read only editor',
    tooltip: 'Toggle read only mode for the event editor',
    onChange: function onChange(_ref3) {
      var checked = _ref3.checked;
      scheduler.features.eventEdit.readOnly = checked;
    }
  }, {
    type: 'button',
    icon: 'b-icon b-icon-add',
    text: 'Add new event',
    onAction: function onAction() {
      var resource = scheduler.resourceStore.first;

      if (!resource) {
        Toast.show('There is no resource available');
        return;
      }

      var event = new scheduler.eventStore.modelClass({
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
    icon: 'b-icon b-icon-trash',
    color: 'b-red',
    text: 'Clear all events',
    onAction: function onAction() {
      return scheduler.eventStore.removeAll();
    }
  }, '->', {
    type: 'datefield',
    label: 'View date',
    inputWidth: '8em',
    value: new Date(2017, 1, 7),
    editable: false,
    listeners: {
      change: function change(_ref4) {
        var value = _ref4.value;
        return scheduler.setTimeSpan(DateHelper.add(value, 8, 'hour'), DateHelper.add(value, 22, 'hour'));
      }
    }
  }]
});