function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

var _bryntum$scheduler = bryntum.scheduler,
    DateHelper = _bryntum$scheduler.DateHelper,
    Scheduler = _bryntum$scheduler.Scheduler,
    StringHelper = _bryntum$scheduler.StringHelper;

var styleNode = document.createElement('style'),
    setAnimationDuration = function setAnimationDuration(value) {
  scheduler.transitionDuration = value;
  styleNode.innerHTML = ".b-grid-row,.b-sch-event-wrap { transition-duration: ".concat(value / 1000, "s !important; }");
};

document.head.appendChild(styleNode);
var scheduler = new Scheduler({
  appendTo: 'container',
  eventColor: null,
  resourceImagePath: '../_shared/images/users/',
  columns: [{
    type: 'resourceInfo',
    text: 'Staff',
    field: 'name',
    width: 150
  }, {
    text: 'Task color',
    field: 'eventColor',
    width: 90,
    htmlEncode: false,
    renderer: function renderer(_ref) {
      var record = _ref.record;
      return "<div class=\"color-box b-sch-".concat(record.eventColor, "\"></div>").concat(StringHelper.capitalize(record.eventColor));
    },
    editor: {
      type: 'combo',
      items: Scheduler.eventColors,
      editable: false,
      listItemTpl: function listItemTpl(_ref2) {
        var value = _ref2.value;
        return "<div class=\"color-box b-sch-".concat(value, "\"></div><div>").concat(value, "</div>");
      }
    }
  }],
  features: {
    timeRanges: true
  },
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  },
  barMargin: 1,
  rowHeight: 50,
  startDate: new Date(2017, 1, 7, 8),
  endDate: new Date(2017, 1, 7, 18),
  viewPreset: 'hourAndDay',
  useInitialAnimation: 'slide-from-left',
  tbar: [{
    type: 'slider',
    ref: 'duration',
    text: 'Animation duration ',
    min: 0,
    max: 3000,
    value: 500,
    step: 200,
    showValue: false,
    showTooltip: true,
    onChange: function onChange(_ref3) {
      var value = _ref3.value;
      return setAnimationDuration(value);
    }
  }, {
    type: 'buttongroup',
    items: [{
      type: 'button',
      text: 'Max 1hr meetings',
      onAction: function onAction() {
        scheduler.eventStore.query(function (task) {
          return task.eventType === 'Meeting';
        }).forEach(function (task) {
          return task.duration = Math.min(task.duration, 1);
        });
      }
    }, {
      type: 'button',
      text: 'After lunch',
      onAction: function onAction() {
        var eventStore = scheduler.eventStore,
            lunchFinishTime = scheduler.features.timeRanges.store.getById('lunch').endDate;
        eventStore.query(function (task) {
          return task.eventType === 'Meeting';
        }).forEach(function (task) {
          return task.startDate = DateHelper.max(task.startDate, lunchFinishTime);
        });
      }
    }]
  }, {
    type: 'button',
    text: 'Random update',
    onAction: function () {
      var _onAction = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
        var eventStore, nbrToAnimate, i, index, event;
        return regeneratorRuntime.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                if (scheduler.isEngineReady) {
                  eventStore = scheduler.eventStore, nbrToAnimate = Math.min(eventStore.count, 4); // Grab a bunch of random events to change

                  for (i = 0; i < nbrToAnimate; i++) {
                    index = Math.floor(Math.random() * eventStore.count), event = eventStore.getAt(index);
                    event.set({
                      resourceId: (scheduler.resourceStore.indexOf(event.resource) + 2) % 8 + 1,
                      startDate: DateHelper.add(event.startDate, event.startDate.getHours() % 2 ? 1 : -1, 'hour')
                    });
                  }
                }

              case 1:
              case "end":
                return _context.stop();
            }
          }
        }, _callee);
      }));

      function onAction() {
        return _onAction.apply(this, arguments);
      }

      return onAction;
    }()
  }, {
    type: 'button',
    text: 'Initial animation',
    icon: 'b-fa-sliders-h',
    toggleable: true,
    menu: {
      onItem: function onItem(_ref4) {
        var item = _ref4.item;
        return scheduler.restartInitialAnimation(item.animation);
      },
      onBeforeShow: function onBeforeShow(_ref5) {
        var menu = _ref5.source;
        menu.items.map(function (item) {
          return item.disabled = scheduler.useInitialAnimation === item.animation;
        });
      },
      items: [{
        text: 'Fade in',
        icon: 'b-fa b-fa-play',
        animation: 'fade-in'
      }, {
        text: 'Slide from left',
        icon: 'b-fa b-fa-play',
        animation: 'slide-from-left'
      }, {
        text: 'Slide from top',
        icon: 'b-fa b-fa-play',
        animation: 'slide-from-top'
      }, {
        text: 'Zoom in',
        icon: 'b-fa b-fa-play',
        animation: 'zoom-in'
      }, {
        text: 'Custom',
        icon: 'b-fa b-fa-play',
        cls: 'b-separator',
        animation: 'custom'
      }]
    }
  }]
});
setAnimationDuration(500);