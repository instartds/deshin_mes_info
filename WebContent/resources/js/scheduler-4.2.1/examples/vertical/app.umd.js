var _templateObject;

function _taggedTemplateLiteral(strings, raw) { if (!raw) { raw = strings.slice(0); } return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    DateHelper = _bryntum$scheduler.DateHelper,
    StringHelper = _bryntum$scheduler.StringHelper;
/* eslint-disable no-unused-vars */

var scheduler = new Scheduler({
  appendTo: 'container',
  mode: 'vertical',
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  startDate: new Date(2019, 0, 1, 6),
  endDate: new Date(2019, 0, 1, 18),
  viewPreset: 'hourAndDay',
  barMargin: 5,
  resourceMargin: 5,
  eventStyle: 'colored',
  tickSize: 80,
  resourceImagePath: '../_shared/images/users/',
  features: {
    filterBar: true,
    // required to filterable on columns work
    resourceTimeRanges: true,
    timeRanges: {
      enableResizing: true,
      showCurrentTimeLine: true
    },
    summary: {
      disabled: true,
      renderer: function renderer(_ref) {
        var events = _ref.events;
        return events.length;
      },
      verticalSummaryColumnConfig: {
        text: 'Summary'
      }
    }
  },
  resourceColumns: {
    columnWidth: 140 //,
    //headerRenderer : ({ resourceRecord }) => StringHelper.xss`${resourceRecord.id} - ${resourceRecord.name}`

  },
  verticalTimeAxisColumn: {
    filterable: {
      // filter configuration
      filterField: {
        // define the configuration for the filter field
        type: 'text',
        // type of the field rendered for the filter
        placeholder: 'Filter events',
        onChange: function onChange(_ref2) {
          var value = _ref2.value;
          // on change of the field, filter the event store
          scheduler.eventStore.filter({
            // filter event by name converting to lowerCase to be equal comparison
            filters: function filters(event) {
              return event.name.toLowerCase().includes(value.toLowerCase());
            },
            replace: true // to replace all existing filters with a new filter

          });
        }
      }
    }
  },
  subGridConfigs: {
    locked: {
      // Wide enough to not clip tick labels for all the zoom levels.
      width: 115
    }
  },
  eventRenderer: function eventRenderer(_ref3) {
    var eventRecord = _ref3.eventRecord;
    return StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["\n        <div class=\"time\">", "</div>\n        <div class=\"name\">", "</div>\n    "])), DateHelper.format(eventRecord.startDate, 'LT'), eventRecord.name);
  },
  tbar: [{
    type: 'date',
    value: 'up.startDate',
    step: '1d',
    onChange: function onChange(_ref4) {
      var value = _ref4.value;
      // Preserve time, only changing "day"
      var diff = DateHelper.diff(DateHelper.clearTime(scheduler.startDate), value, 'days');
      scheduler.startDate = DateHelper.add(scheduler.startDate, diff, 'days');
    }
  }, {
    type: 'button',
    id: 'fitButton',
    text: 'Fit',
    icon: 'b-fa-arrows-alt-h',
    menu: {
      items: {
        none: {
          text: 'No fit',
          checked: false,
          //!scheduler.resourceColumns.fitWidth && !scheduler.resourceColumns.fillWidth,
          closeParent: true
        },
        fill: {
          text: 'Fill width',
          checked: 'up.resourceColumns.fillWidth',
          closeParent: true
        },
        fit: {
          text: 'Fit width',
          checked: 'up.resourceColumns.fitWidth',
          closeParent: true
        }
      },
      onItem: function onItem(_ref5) {
        var item = _ref5.source;
        item.owner.widgetMap.none.checked = item.ref === 'none';
        scheduler.resourceColumns.fillWidth = item.owner.widgetMap.fill.checked = item.ref === 'fill';
        scheduler.resourceColumns.fitWidth = item.owner.widgetMap.fit.checked = item.ref === 'fit';
        scheduler.resourceColumns.fitWidth = item.ref === 'fit';
      }
    }
  }, {
    type: 'button',
    text: 'Layout',
    icon: 'b-fa-layer-group',
    menu: {
      items: {
        none: {
          text: 'Overlap',
          checked: false,
          closeParent: true
        },
        pack: {
          text: 'Pack',
          checked: true,
          closeParent: true
        },
        mixed: {
          text: 'Mixed',
          checked: false,
          closeParent: true
        }
      },
      onItem: function onItem(_ref6) {
        var item = _ref6.source;
        var _item$owner$widgetMap = item.owner.widgetMap,
            none = _item$owner$widgetMap.none,
            pack = _item$owner$widgetMap.pack,
            mixed = _item$owner$widgetMap.mixed;
        none.checked = item.ref === 'none';
        pack.checked = item.ref === 'pack';
        mixed.checked = item.ref === 'mixed';
        scheduler.eventLayout = item.ref;
      }
    }
  }, {
    type: 'button',
    text: 'Sizing',
    icon: 'b-fa-expand-arrows-alt',
    menu: {
      columnWidth: {
        type: 'slider',
        text: 'Column width',
        showValue: true,
        min: 50,
        max: 200,
        value: 'up.resourceColumnWidth',
        onInput: function onInput(_ref7) {
          var value = _ref7.value;
          var fitWidgetMap = scheduler.widgetMap.fitButton.menu.widgetMap || {},
              fitNoneButton = fitWidgetMap.none,
              fitFillButton = fitWidgetMap.fill,
              fitFitButton = fitWidgetMap.fit;

          if (fitNoneButton) {
            fitNoneButton.checked = true;
            fitFillButton.checked = false;
            fitFitButton.checked = false;
          }

          scheduler.resourceColumns.fitWidth = scheduler.resourceColumns.fillWidth = null;
          scheduler.resourceColumns.columnWidth = value;
        }
      },
      tickHeight: {
        type: 'slider',
        text: 'Tick height',
        showValue: true,
        min: 20,
        style: 'margin-top: .5em',
        value: 'up.tickSize',
        onInput: function onInput(_ref8) {
          var value = _ref8.value;
          // To allow ticks to not fill height
          scheduler.suppressFit = true; // Set desired size

          scheduler.tickSize = value;
        }
      },
      barMargin: {
        type: 'slider',
        text: 'Bar margin',
        showValue: true,
        min: 0,
        max: 10,
        style: 'margin-top: .5em',
        value: 'up.barMargin',
        onInput: function onInput(_ref9) {
          var value = _ref9.value;
          scheduler.barMargin = value;
        }
      },
      resourceMargin: {
        type: 'slider',
        text: 'Resource margin',
        showValue: true,
        min: 0,
        max: 10,
        style: 'margin-top: .5em',
        value: 'up.resourceMargin',
        onInput: function onInput(_ref10) {
          var value = _ref10.value;
          scheduler.resourceMargin = value;
        }
      }
    }
  }, {
    type: 'button',
    text: 'Show summary',
    toggleable: true,
    icon: 'b-fa-table',
    onToggle: function onToggle(_ref11) {
      var pressed = _ref11.pressed;
      scheduler.features.summary.disabled = !pressed;
    }
  }]
});