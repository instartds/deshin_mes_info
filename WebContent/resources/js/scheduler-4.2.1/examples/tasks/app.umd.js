var _templateObject, _templateObject2, _templateObject3, _templateObject4;

function _taggedTemplateLiteral(strings, raw) { if (!raw) { raw = strings.slice(0); } return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

var _bryntum$scheduler = bryntum.scheduler,
    Tooltip = _bryntum$scheduler.Tooltip,
    Popup = _bryntum$scheduler.Popup,
    Scheduler = _bryntum$scheduler.Scheduler,
    ResourceModel = _bryntum$scheduler.ResourceModel,
    StringHelper = _bryntum$scheduler.StringHelper;
/* eslint-disable no-unused-vars */
// The data for this demo (data/data.json) uses the 'clients' property to hold children of resources

ResourceModel.childrenField = 'clients';
var colors = ['Cyan', 'Blue', 'Green', 'Light-green', 'Lime', 'Orange', 'Purple', 'Red', 'Teal'];
var scheduler = new Scheduler({
  appendTo: 'container',
  startDate: new Date(2018, 4, 7),
  endDate: new Date(2018, 4, 26),
  barMargin: 7,
  rowHeight: 45,
  eventColor: null,
  eventStyle: null,
  viewPreset: {
    base: 'weekAndDay',
    displayDateFormat: 'll'
  },
  features: {
    // Disable cell editing, this demo has its own custom row editor
    cellEdit: false,
    // Drag only within clients/employees, snap to days
    eventDrag: {
      constrainDragToResource: true,
      showExactDropPosition: true
    },
    // Event editor with two custom fields, location for clients and color for employees
    eventEdit: {
      typeField: 'type',
      items: {
        location: {
          type: 'text',
          name: 'location',
          label: 'Location',
          weight: 110,
          dataset: {
            eventType: 'client'
          }
        },
        color: {
          type: 'combo',
          name: 'color',
          label: 'Color',
          items: colors.map(function (color) {
            return [color.toLowerCase(), color];
          }),
          listItemTpl: function listItemTpl(data) {
            return StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["<div class=\"color-item ", "\"></div>", ""])), data.value, data.text);
          },
          weight: 120,
          dataset: {
            eventType: 'employee'
          }
        }
      }
    },
    // Resize snapping to days
    eventResize: {
      showExactResizePosition: true
    },
    // Shade weekends
    nonWorkingTime: true,
    // Uses a tree where parent nodes are employees and child nodes are clients
    tree: true
  },
  columns: [{
    type: 'tree',
    text: 'Employees',
    field: 'name',
    width: '15em',
    // Hide default tree icons
    expandedFolderIconCls: null,
    collapsedFolderIconCls: null,
    leafIconCls: null,
    // Set to `false` to render our custom markup
    htmlEncode: false,
    // Custom renderer display employee info or client color + name
    renderer: function renderer(_ref) {
      var record = _ref.record,
          value = _ref.value,
          size = _ref.size;

      // Parent rows are employees
      if (record.isParent) {
        var image = record.image !== false ? StringHelper.xss(_templateObject2 || (_templateObject2 = _taggedTemplateLiteral(["<img class=\"profile-img\" src=\"resources/images/", ".jpg\" />"])), record.name.toLowerCase()) : ''; // Make employee row higher

        size.height = 60; // Employee template

        return StringHelper.xss(_templateObject3 || (_templateObject3 = _taggedTemplateLiteral(["\n                        <div class=\"info\">\n                            <div class=\"name\">", "</div>\n                            <div class=\"title\">", "</div>\n                        </div>\n                        <div class=\"add\"><i class=\"b-fa b-fa-plus\"></i></div>\n                    "])), value, record.title) + image;
      } // Other rows are clients
      else {
          // Client template
          return StringHelper.xss(_templateObject4 || (_templateObject4 = _taggedTemplateLiteral(["<div class=\"client-color ", "\"></div>", ""])), record.color, value);
        }
    }
  }],
  // CrudManager loads all data from a single source
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    },
    resourceStore: {
      fields: ['color', 'title'],
      tree: true
    },
    eventStore: {
      fields: ['color', 'location']
    }
  },
  // Custom event renderer that applies colors and display events location
  eventRenderer: function eventRenderer(_ref2) {
    var renderData = _ref2.renderData,
        resourceRecord = _ref2.resourceRecord,
        eventRecord = _ref2.eventRecord;

    if (resourceRecord.isParent) {
      renderData.wrapperCls.add('employee');
    }

    if (eventRecord.color) {
      renderData.wrapperCls.add(eventRecord.color);
    } else if (resourceRecord.color) {
      renderData.wrapperCls.add(resourceRecord.color);
    }

    return StringHelper.encodeHtml(eventRecord.name) + (eventRecord.location ? "<span>, ".concat(StringHelper.encodeHtml(eventRecord.location), "</span>") : '');
  },
  listeners: {
    cellClick: function cellClick(_ref3) {
      var record = _ref3.record,
          event = _ref3.event;

      // Add a new client when clicking plus icon
      if (event.target.closest('.add')) {
        record.appendChild({
          name: 'New client',
          // New client gets a random color
          color: colors[Math.floor(Math.random() * colors.length)].toLowerCase()
        });
      }
    },
    dragCreateEnd: function dragCreateEnd(_ref4) {
      var newEventRecord = _ref4.newEventRecord,
          resourceRecord = _ref4.resourceRecord;
      // Make new event have correct type, to show correct fields in event editor
      newEventRecord.type = resourceRecord.isLeaf ? 'client' : 'employee';
    },
    cellDblClick: function cellDblClick(_ref5) {
      var record = _ref5.record,
          cellElement = _ref5.cellElement,
          column = _ref5.column;

      // Show a custom editor when dbl clicking a client cell
      if (column.field === 'name' && record.isLeaf) {
        new Popup({
          autoShow: true,
          autoClose: true,
          closeAction: 'destroy',
          scrollAction: 'realign',
          forElement: cellElement,
          anchor: true,
          width: '20em',
          cls: 'client-editor',
          items: [{
            type: 'text',
            name: 'name',
            label: 'Client',
            labelWidth: '4em',
            value: record.name,
            onChange: function onChange(_ref6) {
              var value = _ref6.value;
              record.name = value;
            }
          }, {
            type: 'combo',
            cls: 'b-last-row',
            name: 'color',
            label: 'Color',
            labelWidth: '4em',
            items: colors.map(function (color) {
              return [color.toLowerCase(), color];
            }),
            listItemTpl: function listItemTpl(data) {
              return "<div class=\"color-item ".concat(data.value, "\"></div>").concat(data.text);
            },
            value: record.color,
            onChange: function onChange(_ref7) {
              var value = _ref7.value;
              record.color = value;
            }
          }]
        });
      }
    },
    prio: 1
  }
}); // Tooltip for add client buttons (plain divs)

new Tooltip({
  forSelector: '.add',
  html: 'Add client',
  hideDelay: 100
});