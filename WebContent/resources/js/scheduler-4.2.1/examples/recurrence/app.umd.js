var _templateObject;

function _taggedTemplateLiteral(strings, raw) { if (!raw) { raw = strings.slice(0); } return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    StringHelper = _bryntum$scheduler.StringHelper;
new Scheduler({
  appendTo: 'container',
  rowHeight: 70,
  enableRecurringEvents: true,
  resourceImagePath: '../_shared/images/users/',
  features: {
    sort: 'name',
    eventTooltip: true,
    labels: {
      // using field as label (will first look in event and then in resource)
      // top : {
      //     renderer : ({ eventRecord }) => {
      //         return eventRecord.hasGeneratedId ? '&lt;Unsynced event&gt;' : eventRecord.id;
      //     }
      // },
      //
      // // using renderer
      // bottom({ resourceRecord, labelElement }) {
      //     if (resourceRecord.category === 'Testers') labelElement.classList.add('custom');
      //     return resourceRecord.category;
      // },
      top: {
        field: 'name'
      }
    }
  },
  // So that shorter, intraday events show up as a block inside a day tick
  fillTicks: true,
  columns: [{
    type: 'resourceInfo',
    text: 'Name'
  }],
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  startDate: new Date(2018, 0, 1),
  endDate: new Date(2018, 4, 1),
  viewPreset: 'weekAndDayLetter',
  eventRenderer: function eventRenderer(_ref) {
    var renderData = _ref.renderData,
        eventRecord = _ref.eventRecord;
    renderData.iconCls = eventRecord.isRecurring ? 'b-fa b-fa-star' : eventRecord.isOccurrence ? 'b-fa b-fa-sync' : 'b-fa b-fa-calendar';
    return StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["", ""])), eventRecord.name);
  }
});