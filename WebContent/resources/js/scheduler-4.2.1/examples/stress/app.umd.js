var _templateObject;

function _taggedTemplateLiteral(strings, raw) { if (!raw) { raw = strings.slice(0); } return Object.freeze(Object.defineProperties(strings, { raw: { value: Object.freeze(raw) } })); }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

var _bryntum$scheduler = bryntum.scheduler,
    StringHelper = _bryntum$scheduler.StringHelper,
    DateHelper = _bryntum$scheduler.DateHelper,
    Toast = _bryntum$scheduler.Toast,
    DataGenerator = _bryntum$scheduler.DataGenerator,
    Scheduler = _bryntum$scheduler.Scheduler;
var generator = DataGenerator.generate(1000),
    actionInterval = 10000,
    eventNames = ['Feed the ducks', 'Zoom meeting', 'Customer call', 'Sales campaign', 'Server maintenance', 'Replace IE with Chrome', 'Install anti-virus', 'Water flowers', 'Fly to Vegas', 'Book meeting room', 'Get vaccinated', 'Buy Covid masks 50-pack', 'Cancel Netflix subscription'];

var ColleagueSimulator = /*#__PURE__*/function () {
  function ColleagueSimulator(config) {
    _classCallCheck(this, ColleagueSimulator);

    Object.assign(this, config);
    this.eventStore.on({
      change: 'onEventStoreChange',
      thisObj: this
    });
    this.resourceStore.on({
      change: 'onResourceStoreChange',
      thisObj: this
    });
    this.scheduler.element.addEventListener('animationend', function (_ref) {
      var target = _ref.target,
          animationName = _ref.animationName;

      if (animationName === 'slideout') {
        delete target.dataset.editMessage;
      }
    });
    this.nbrOfColleagues = config.nbrOfColleagues;
  }

  _createClass(ColleagueSimulator, [{
    key: "start",
    value: function start() {
      this.stop();
      this.timer = setInterval(this.randomChange.bind(this), this.interval);
    }
  }, {
    key: "stop",
    value: function stop() {
      clearTimeout(this.timer);
    }
  }, {
    key: "interval",
    get: function get() {
      return this._interval;
    },
    set: function set(value) {
      this._interval = value;
      this.start();
    }
  }, {
    key: "nbrOfColleagues",
    set: function set(value) {
      this.interval = actionInterval / value;
    }
  }, {
    key: "randomChange",
    value: function randomChange() {
      var me = this,
          eventStore = me.eventStore,
          index = Math.round(Math.random() * eventStore.count),
          record = eventStore.getAt(index) || eventStore.last;
      var changeType = Math.round(Math.random() * 7);

      if (!me.resourceStore.count) {
        changeType = 3;
      } else if (!record) {
        changeType = 2;
      }

      switch (changeType) {
        case 0:
          return me.shift(record);

        case 1:
          return me.changeName(record);

        case 2:
          return me.addEvent();

        case 3:
          return me.addResource();

        case 4:
          return Math.round() > 0.5 && me.removeResource();

        case 5:
          return me.changeDuration(record);

        case 6:
          return me.reassignEvent(record);

        case 7:
          return Math.round() > 0.5 && me.removeEvent(record);
      }
    }
  }, {
    key: "shift",
    value: function shift(event) {
      event.shift(Math.round() > 0.5 ? 1 : -1);
    }
  }, {
    key: "changeName",
    value: function changeName(event) {
      event.name = this.getRandomEventName();
    }
  }, {
    key: "removeEvent",
    value: function removeEvent(event) {
      event.remove();
    }
  }, {
    key: "addEvent",
    value: function addEvent() {
      var startDate = DateHelper.add(this.startDate, Math.round(Math.random() * 6), 'h');
      this.eventStore.add({
        name: this.getRandomEventName(),
        resourceId: this.resourceStore.getAt(Math.round(Math.random() * (this.resourceStore.count - 1))).id,
        startDate: startDate,
        endDate: DateHelper.add(startDate, 2, 'h'),
        duration: 2,
        durationUnit: 'h'
      });
    }
  }, {
    key: "addResource",
    value: function addResource() {
      var next = generator.next();
      this.resourceStore.add(next.value);
    }
  }, {
    key: "changeDuration",
    value: function changeDuration(event) {
      var sign = event.duration > 1 && Math.round() > 0.5 ? -1 : 1;
      event.endDate = DateHelper.add(event.endDate, 1 * sign, event.durationUnit);
    }
  }, {
    key: "removeResource",
    value: function removeResource() {
      var _this$resourceStore$l;

      (_this$resourceStore$l = this.resourceStore.last) === null || _this$resourceStore$l === void 0 ? void 0 : _this$resourceStore$l.remove();
    }
  }, {
    key: "reassignEvent",
    value: function reassignEvent(event) {
      var otherResources = this.resourceStore.getRange().filter(function (r) {
        return r !== event.resource;
      }),
          newResource = otherResources[Math.round(Math.random() * this.resourceStore.count)];

      if (newResource !== event.resource) {
        this.eventStore.assignEventToResource(event, newResource);
      }
    }
  }, {
    key: "getRandomEventName",
    value: function getRandomEventName() {
      return eventNames[Math.round(Math.random() * eventNames.length - 1)];
    }
  }, {
    key: "getRandomResourceName",
    value: function getRandomResourceName() {
      var _this$resourceStore$g;

      return ((_this$resourceStore$g = this.resourceStore.getAt(Math.round(Math.random() * this.resourceStore.count))) === null || _this$resourceStore$g === void 0 ? void 0 : _this$resourceStore$g.name) || 'Mystery man';
    }
  }, {
    key: "onResourceStoreChange",
    value: function () {
      var _onResourceStoreChange = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(_ref2) {
        var source, action, record, records;
        return regeneratorRuntime.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                source = _ref2.source, action = _ref2.action, record = _ref2.record, records = _ref2.records;
                _context.t0 = action;
                _context.next = _context.t0 === 'remove' ? 4 : _context.t0 === 'add' ? 4 : 6;
                break;

              case 4:
                Toast.show({
                  html: "".concat(this.getRandomResourceName(), " ").concat(action + (action === 'remove' ? 'd' : 'ed'), " <strong>").concat(StringHelper.encodeHtml(records[0].name), "</strong>"),
                  timeout: Math.max(500, this.interval)
                });
                return _context.abrupt("break", 6);

              case 6:
              case "end":
                return _context.stop();
            }
          }
        }, _callee, this);
      }));

      function onResourceStoreChange(_x) {
        return _onResourceStoreChange.apply(this, arguments);
      }

      return onResourceStoreChange;
    }()
  }, {
    key: "onEventStoreChange",
    value: function () {
      var _onEventStoreChange = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(_ref3) {
        var source, action, record, records, eventBar;
        return regeneratorRuntime.wrap(function _callee2$(_context2) {
          while (1) {
            switch (_context2.prev = _context2.next) {
              case 0:
                source = _ref3.source, action = _ref3.action, record = _ref3.record, records = _ref3.records;
                _context2.t0 = action;
                _context2.next = _context2.t0 === 'remove' ? 4 : _context2.t0 === 'update' ? 6 : _context2.t0 === 'add' ? 6 : 10;
                break;

              case 4:
                Toast.show({
                  html: "".concat(this.getRandomResourceName(), " deleted task <strong>").concat(StringHelper.encodeHtml(records[0].name), "</strong>"),
                  timeout: Math.max(500, this.interval)
                });
                return _context2.abrupt("break", 10);

              case 6:
                record = record || records[0];
                eventBar = this.scheduler.getElementFromEventRecord(record);

                if (eventBar) {
                  eventBar.parentElement.dataset.editMessage = "".concat(StringHelper.capitalize(action), " by ").concat(this.getRandomResourceName());
                }

                return _context2.abrupt("break", 10);

              case 10:
              case "end":
                return _context2.stop();
            }
          }
        }, _callee2, this);
      }));

      function onEventStoreChange(_x2) {
        return _onEventStoreChange.apply(this, arguments);
      }

      return onEventStoreChange;
    }()
  }]);

  return ColleagueSimulator;
}();

var scheduler = new Scheduler({
  appendTo: 'container',
  eventColor: null,
  rowHeight: 60,
  barMargin: 7,
  startDate: new Date(2021, 2, 7, 8),
  endDate: new Date(2021, 2, 7, 18),
  viewPreset: 'hourAndDay',
  eventBodyTemplate: function eventBodyTemplate(data) {
    return StringHelper.xss(_templateObject || (_templateObject = _taggedTemplateLiteral(["\n        <div class=\"b-sch-event-header\">", "</div>\n        <div class=\"b-sch-event-footer\">", "</div>\n    "])), data.headerText, data.footerText);
  },
  eventRenderer: function eventRenderer(_ref4) {
    var eventRecord = _ref4.eventRecord,
        resourceRecord = _ref4.resourceRecord,
        renderData = _ref4.renderData;
    renderData.style = 'background-color:' + resourceRecord.color;
    return {
      headerText: DateHelper.format(eventRecord.startDate, 'HH:mm'),
      footerText: StringHelper.encodeHtml(eventRecord.name || '')
    };
  },
  columns: [{
    type: 'resourceInfo',
    text: 'Staff',
    field: 'name',
    width: 200,
    useNameAsImageName: false
  }],
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    },
    onLoad: function onLoad() {
      colleagueSimulator.start();
    }
  },
  features: {
    dependencies: true
  },
  tbar: [{
    type: 'slider',
    ref: 'nbrOfColleagues',
    text: 'Number of colleagues',
    width: 200,
    min: 1,
    max: 100,
    value: 3,
    step: 1,
    showValue: true,
    showTooltip: true,
    onChange: 'up.onSliderChange'
  }, {
    type: 'button',
    text: 'Stop the madness',
    tooltip: 'Stops the external changes',
    onAction: function onAction() {
      return colleagueSimulator.stop();
    }
  }],
  onSliderChange: function onSliderChange(_ref5) {
    var source = _ref5.source,
        value = _ref5.value;
    colleagueSimulator.nbrOfColleagues = value;
  }
});
var colleagueSimulator = new ColleagueSimulator({
  scheduler: scheduler,
  eventStore: scheduler.eventStore,
  resourceStore: scheduler.resourceStore,
  startDate: scheduler.startDate,
  nbrOfColleagues: scheduler.widgetMap.nbrOfColleagues.value
});