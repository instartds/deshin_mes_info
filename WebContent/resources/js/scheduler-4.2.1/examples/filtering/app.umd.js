var _templateObject;

function _taggedTemplateLiteral(strings, raw) { if (!raw) { raw = strings.slice(0); } return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

var _bryntum$scheduler = bryntum.scheduler,
    DateHelper = _bryntum$scheduler.DateHelper,
    DomClassList = _bryntum$scheduler.DomClassList,
    Scheduler = _bryntum$scheduler.Scheduler,
    StringHelper = _bryntum$scheduler.StringHelper;
var scheduler = new Scheduler({
  appendTo: 'container',
  eventStyle: 'colored',
  eventColor: null,
  features: {
    filterBar: true,
    stripe: true,
    timeRanges: true,
    eventEdit: {
      items: {
        location: {
          weight: 210,
          // After resource
          type: 'text',
          name: 'location',
          label: 'Location',
          dataset: {
            eventType: 'Meeting'
          }
        }
      }
    }
  },
  columns: [{
    type: 'resourceInfo',
    text: 'Staff',
    width: 170
  }, {
    text: 'Role',
    field: 'role',
    width: 140,
    editor: {
      type: 'combo',
      items: ['Sales', 'Developer', 'Marketing', 'Product manager'],
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
    }
  },
  barMargin: 5,
  rowHeight: 55,
  startDate: new Date(2017, 1, 7, 8),
  endDate: new Date(2017, 1, 7, 18),
  viewPreset: 'hourAndDay',
  resourceImagePath: '../_shared/images/users/',
  // Specialized body template with header and footer
  eventBodyTemplate: function eventBodyTemplate(data) {
    return StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["\n        <div class=\"b-sch-event-header\">", "</div>\n        <div class=\"b-sch-event-footer\">", "</div>\n    "])), data.headerText, data.footerText);
  },
  eventRenderer: function eventRenderer(_ref) {
    var eventRecord = _ref.eventRecord,
        resourceRecord = _ref.resourceRecord,
        renderData = _ref.renderData;
    renderData.style = 'background-color:' + resourceRecord.color;
    return {
      headerText: DateHelper.format(eventRecord.startDate, this.displayDateFormat),
      footerText: eventRecord.name || ''
    };
  },
  tbar: ['->', {
    type: 'textfield',
    ref: 'filterByName',
    icon: 'b-fa b-fa-filter',
    placeholder: 'Find tasks by name',
    clearable: true,
    keyStrokeChangeDelay: 100,
    triggers: {
      filter: {
        align: 'start',
        cls: 'b-fa b-fa-filter'
      }
    },
    onChange: function onChange(_ref2) {
      var value = _ref2.value;
      value = value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // Replace all previous filters and set a new filter

      scheduler.eventStore.filter({
        filters: function filters(event) {
          return event.name.match(new RegExp(value, 'i'));
        },
        replace: true
      });
      /*
              // The code above is a one liner version of:
               // Remove all previous filters
              scheduler.eventStore.clearFilters();
               // Set a new filter
              scheduler.eventStore.filter(event => event.name.match(new RegExp(value, 'i')));
               // Having `replace` provided makes the filter config go to the nested `filters` property,
              // see more in the Store.filter docs
          */
    }
  }, {
    type: 'textfield',
    ref: 'highlight',
    placeholder: 'Highlight tasks',
    clearable: true,
    keyStrokeChangeDelay: 100,
    triggers: {
      filter: {
        align: 'start',
        cls: 'b-fa b-fa-search'
      }
    },
    onChange: function onChange(_ref3) {
      var value = _ref3.value;
      scheduler.eventStore.forEach(function (task) {
        var taskClassList = new DomClassList(task.cls);

        if (value !== '' && task.name.toLowerCase().includes(value.toLowerCase())) {
          taskClassList.add('b-match');
        } else {
          taskClassList.remove('b-match');
        }

        task.cls = taskClassList.value;
      });
      scheduler.element.classList[value.length > 0 ? 'add' : 'remove']('b-highlighting');
    }
  }]
});