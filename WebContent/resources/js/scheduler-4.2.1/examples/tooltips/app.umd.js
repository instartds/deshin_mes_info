var _bryntum$scheduler = bryntum.scheduler,
    StringHelper = _bryntum$scheduler.StringHelper,
    DateHelper = _bryntum$scheduler.DateHelper,
    AjaxHelper = _bryntum$scheduler.AjaxHelper,
    TabPanel = _bryntum$scheduler.TabPanel;
/* eslint-disable no-unused-vars */

var tabPanel = new TabPanel({
  appendTo: 'container',
  items: [{
    type: 'scheduler',
    title: 'Local tooltips',
    startDate: new Date(2017, 0, 1, 6),
    endDate: new Date(2017, 0, 1, 20),
    viewPreset: 'hourAndDay',
    crudManager: {
      autoLoad: true,
      transport: {
        load: {
          url: 'data/data.json'
        }
      }
    },
    features: {
      eventDrag: {
        // Custom tooltip for when an event is dragged
        tooltipTemplate: function tooltipTemplate(_ref) {
          var eventRecord = _ref.eventRecord,
              startDate = _ref.startDate;
          return "<h4 style=\"margin:0 0 1em 0\">Custom drag drop tooltip</h4>\n                        <div style=\"margin-bottom:0.8em\">".concat(eventRecord.name, "</div>\n                        <i style=\"margin-right:0.5em\" class=\"b-icon b-icon-clock\"></i>").concat(DateHelper.format(startDate, 'HH:mm'), "\n                    ");
        }
      },
      eventResize: {
        // A minimal end date tooltip when resizing
        tooltipTemplate: function tooltipTemplate(_ref2) {
          var record = _ref2.record,
              endDate = _ref2.endDate;
          return DateHelper.format(endDate, 'HH:mm');
        }
      },
      eventTooltip: {
        tools: [{
          cls: 'b-fa b-fa-cut',
          handler: function handler() {
            this.eventRecord.split();
            this.hide();
          }
        }, {
          cls: 'b-fa b-fa-trash',
          handler: function handler() {
            this.eventRecord.remove();
            this.hide();
          }
        }, {
          cls: 'b-fa b-fa-angle-left',
          handler: function handler() {
            this.eventRecord.shift(-1);
          }
        }, {
          cls: 'b-fa b-fa-angle-right',
          handler: function handler() {
            this.eventRecord.shift(1);
          }
        }],
        header: {
          titleAlign: 'start'
        },
        onBeforeShow: function onBeforeShow(_ref3) {
          var tooltip = _ref3.source;
          tooltip.title = StringHelper.encodeHtml(tooltip.eventRecord.name);
        },
        template: function template(data) {
          return "<dl>\n                        <dt>Assigned to:</dt>\n                        <dd>\n                             ".concat(data.eventRecord.resource.get('image') ? "<img class=\"resource-image\" src=\"../_shared/images/users/".concat(data.eventRecord.resource.get('image'), "\"/>") : '', "\n                             ").concat(StringHelper.encodeHtml(data.eventRecord.resource.name), "\n                        </dd>\n                        <dt>Time:</dt>\n                        <dd>\n                            ").concat(DateHelper.format(data.eventRecord.startDate, 'LT'), " - ").concat(DateHelper.format(data.eventRecord.endDate, 'LT'), "\n                        </dd>\n                        ").concat(data.eventRecord.get('note') ? "<dt>Note:</dt><dd>".concat(data.eventRecord.note, "</dd>") : '', "\n    \n                        ").concat(data.eventRecord.get('image') ? "<dt>Image:</dt><dd><img class=\"image\" src=\"".concat(data.eventRecord.get('image'), "\"/></dd>") : '', "\n                    </dl>\n                    ");
        } // You can also use Tooltip configs here, for example:
        // anchorToTarget : false,
        // trackMouse     : true

      }
    },
    columns: [{
      text: 'Name',
      field: 'name',
      width: 130
    }]
  }, {
    type: 'scheduler',
    title: 'Remotely loaded tooltips',
    startDate: new Date(2017, 0, 1, 6),
    endDate: new Date(2017, 0, 1, 20),
    viewPreset: 'hourAndDay',
    crudManager: {
      autoLoad: true,
      transport: {
        load: {
          url: 'data/data.json'
        }
      }
    },
    features: {
      eventTooltip: {
        template: function template(_ref4) {
          var eventRecord = _ref4.eventRecord;
          return AjaxHelper.get("./fakeServer?name=".concat(eventRecord.name)).then(function (response) {
            return response.responseText;
          });
        }
      }
    },
    columns: [{
      text: 'Name',
      field: 'name',
      width: 130
    }]
  }]
}); // DEMO ONLY: Mock a server endpoint fetching data to be shown in the async column

AjaxHelper.mockUrl('./fakeServer', function (url, params) {
  return {
    delay: 1500,
    responseText: "<dl>\n        <dt>".concat(StringHelper.encodeHtml(params.name), ":</dt>\n        <dt>Additional info:</dt>\n        <dd>\n            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n        </dd>\n    </dl>")
  };
});