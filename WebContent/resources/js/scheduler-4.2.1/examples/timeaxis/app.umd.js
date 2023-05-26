function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _get(target, property, receiver) { if (typeof Reflect !== "undefined" && Reflect.get) { _get = Reflect.get; } else { _get = function _get(target, property, receiver) { var base = _superPropBase(target, property); if (!base) return; var desc = Object.getOwnPropertyDescriptor(base, property); if (desc.get) { return desc.get.call(receiver); } return desc.value; }; } return _get(target, property, receiver || target); }

function _superPropBase(object, property) { while (!Object.prototype.hasOwnProperty.call(object, property)) { object = _getPrototypeOf(object); if (object === null) break; } return object; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    DateHelper = _bryntum$scheduler.DateHelper,
    TabPanel = _bryntum$scheduler.TabPanel;

var SchedulerCustomTimeAxis = /*#__PURE__*/function (_Scheduler) {
  _inherits(SchedulerCustomTimeAxis, _Scheduler);

  var _super = _createSuper(SchedulerCustomTimeAxis);

  function SchedulerCustomTimeAxis() {
    _classCallCheck(this, SchedulerCustomTimeAxis);

    return _super.apply(this, arguments);
  }

  _createClass(SchedulerCustomTimeAxis, null, [{
    key: "type",
    get: // Factoryable type name
    function get() {
      return 'schedulercustomtimeaxis';
    }
  }, {
    key: "defaultConfig",
    get: function get() {
      return {
        eventStyle: 'colored',
        features: {
          sort: 'name',
          eventResize: {
            showExactResizePosition: true
          }
        },
        rowHeight: 60,
        zoomOnTimeAxisDoubleClick: false,
        // Custom preset to display work hours (each hour) below days
        viewPreset: {
          displayDateFormat: 'H:mm',
          tickWidth: 25,
          shiftIncrement: 1,
          shiftUnit: 'WEEK',
          timeResolution: {
            unit: 'MINUTE',
            increment: 60
          },
          headers: [{
            unit: 'DAY',
            align: 'center',
            dateFormat: 'ddd L'
          }, {
            unit: 'HOUR',
            align: 'center',
            dateFormat: 'H'
          }]
        },
        // Custom time axis
        timeAxis: {
          continuous: false,
          generateTicks: function generateTicks(start, end, unit, increment) {
            var ticks = [];

            while (start < end) {
              if (unit !== 'hour' || start.getHours() >= 8 && start.getHours() <= 21) {
                ticks.push({
                  id: ticks.length + 1,
                  startDate: start,
                  endDate: DateHelper.add(start, increment, unit)
                });
              }

              start = DateHelper.add(start, increment, unit);
            }

            return ticks;
          }
        },
        resources: [{
          id: 'r1',
          name: 'Mike'
        }, {
          id: 'r2',
          name: 'Linda'
        }, {
          id: 'r3',
          name: 'Don'
        }, {
          id: 'r4',
          name: 'Karen'
        }, {
          id: 'r5',
          name: 'Doug'
        }, {
          id: 'r6',
          name: 'Peter'
        }, {
          id: 'r7',
          name: 'Fred'
        }, {
          id: 'r8',
          name: 'Lisa'
        }, {
          id: 'r9',
          name: 'Annie'
        }, {
          id: 'r10',
          name: 'Dan'
        }],
        events: [{
          id: 1,
          resourceId: 'r9',
          startDate: '2019-02-11 12:00',
          endDate: '2019-02-11 16:00',
          name: 'Some task',
          eventColor: 'pink'
        }, {
          id: 2,
          resourceId: 'r2',
          startDate: '2019-02-12 08:00',
          endDate: '2019-02-12 14:00',
          name: 'Other task',
          eventColor: 'gray'
        }, {
          id: 3,
          resourceId: 'r10',
          startDate: '2019-02-15 08:00',
          endDate: '2019-02-15 14:00',
          name: 'Important task',
          eventColor: 'orange'
        }],
        // Setup static columns
        columns: [{
          text: 'Name',
          width: 100,
          field: 'name'
        }]
      };
    }
  }]);

  return SchedulerCustomTimeAxis;
}(Scheduler); // Register this widget type with its Factory


SchedulerCustomTimeAxis.initClass();

var SchedulerCustomTimeAxis2 = /*#__PURE__*/function (_Scheduler2) {
  _inherits(SchedulerCustomTimeAxis2, _Scheduler2);

  var _super2 = _createSuper(SchedulerCustomTimeAxis2);

  function SchedulerCustomTimeAxis2() {
    _classCallCheck(this, SchedulerCustomTimeAxis2);

    return _super2.apply(this, arguments);
  }

  _createClass(SchedulerCustomTimeAxis2, [{
    key: "eventRenderer",
    value: function eventRenderer(_ref) {
      var eventRecord = _ref.eventRecord;
      return DateHelper.format(eventRecord.startDate, 'H:mm') + ' - ' + DateHelper.format(eventRecord.endDate, 'H:mm');
    } // Constrain events horizontally within their current day

  }, {
    key: "getDateConstraints",
    value: function getDateConstraints(resourceRecord, eventRecord) {
      if (eventRecord) {
        var timeAxis = this.timeAxis;
        var minDate, maxDate; // DragCreate supplies a date instead of an event record

        if (eventRecord instanceof Date) {
          var date = eventRecord,
              tick = timeAxis.getAt(Math.floor(timeAxis.getTickFromDate(date)));
          minDate = tick.startDate;
          maxDate = tick.endDate;
        } // EventResize & EventDrag
        else {
            var constrainedStartDate = DateHelper.max(eventRecord.startDate, timeAxis.startDate),
                constrainedEndDate = DateHelper.min(eventRecord.endDate, timeAxis.endDate);
            var endDateTick = timeAxis.getTickFromDate(constrainedEndDate); // If event ends at tick end, use prev tick end as constraining date

            if (endDateTick === Math.floor(endDateTick)) {
              endDateTick--;
            }

            var minTickRecord = timeAxis.getAt(Math.floor(timeAxis.getTickFromDate(constrainedStartDate))),
                maxTickRecord = timeAxis.getAt(Math.floor(endDateTick));
            minDate = minTickRecord.startDate;
            maxDate = constrainedEndDate - timeAxis.endDate === 0 ? constrainedEndDate : maxTickRecord.endDate;
          }

        return {
          start: minDate,
          end: maxDate
        };
      }
    }
  }], [{
    key: "type",
    get: // Factoryable type name
    function get() {
      return 'schedulercustomtimeaxis2';
    }
  }, {
    key: "defaultConfig",
    get: function get() {
      return {
        eventStyle: 'colored',
        features: {
          sort: 'name',
          stripe: true,
          headerMenu: false,
          eventResize: {
            showExactResizePosition: true
          }
        },
        zoomOnMouseWheel: false,
        zoomOnTimeAxisDoubleClick: false,
        // Custom preset to display work hours below day
        viewPreset: {
          displayDateFormat: 'H:mm',
          shiftIncrement: 1,
          shiftUnit: 'WEEK',
          timeResolution: {
            unit: 'MINUTE',
            increment: 10
          },
          headers: [{
            unit: 'DAY',
            dateFormat: 'ddd D MMM'
          }, {
            unit: 'DAY',
            renderer: function renderer(start, end, cfg) {
              cfg.headerCellCls = 'sch-hdr-startend';
              return "<span>".concat(DateHelper.format(start, 'H'), "</span><span>").concat(DateHelper.format(end, 'H'), "</span>");
            }
          }]
        },
        rowHeight: 60,
        // Custom time axis
        timeAxis: {
          continuous: false,
          generateTicks: function generateTicks(start, end, unit, increment) {
            // Use our own custom time intervals for day time-axis
            if (unit === 'day') {
              var ticks = [];
              var intervalEnd;

              while (start < end) {
                if (start.getDay() === 5) {
                  // Fridays are lazy days, working 10am - 4pm
                  start.setHours(10);
                  intervalEnd = DateHelper.add(start, 6, 'h');
                } else {
                  start.setHours(8);
                  intervalEnd = DateHelper.add(start, 8, 'h');
                }

                ticks.push({
                  id: ticks.length + 1,
                  startDate: start,
                  endDate: intervalEnd
                });
                start = DateHelper.add(start, 1, 'd');
              }

              return ticks;
            }
          }
        },
        resources: [{
          id: 'r1',
          name: 'Mike'
        }, {
          id: 'r2',
          name: 'Linda'
        }, {
          id: 'r3',
          name: 'Don'
        }, {
          id: 'r4',
          name: 'Karen'
        }, {
          id: 'r5',
          name: 'Doug'
        }, {
          id: 'r6',
          name: 'Peter'
        }, {
          id: 'r7',
          name: 'Fred'
        }, {
          id: 'r8',
          name: 'Lisa'
        }, {
          id: 'r9',
          name: 'Annie'
        }, {
          id: 'r10',
          name: 'Dan'
        }],
        events: [{
          id: 1,
          resourceId: 'r9',
          startDate: '2019-02-11 12:00',
          endDate: '2019-02-11 16:00',
          name: 'Some task',
          eventColor: 'blue'
        }, {
          id: 2,
          resourceId: 'r2',
          startDate: '2019-02-13 08:00',
          endDate: '2019-02-13 14:00',
          name: 'Other task',
          eventColor: 'lime'
        }, {
          id: 3,
          resourceId: 'r10',
          startDate: '2019-02-14 08:00',
          endDate: '2019-02-14 14:00',
          name: 'Important task',
          eventColor: 'red'
        }],
        // Setup static columns
        columns: [{
          text: 'Name',
          width: 100,
          field: 'name'
        }]
      };
    }
  }]);

  return SchedulerCustomTimeAxis2;
}(Scheduler); // Register this widget type with its Factory


SchedulerCustomTimeAxis2.initClass();

var SchedulerCustomTimeAxis3 = /*#__PURE__*/function (_Scheduler3) {
  _inherits(SchedulerCustomTimeAxis3, _Scheduler3);

  var _super3 = _createSuper(SchedulerCustomTimeAxis3);

  function SchedulerCustomTimeAxis3() {
    _classCallCheck(this, SchedulerCustomTimeAxis3);

    return _super3.apply(this, arguments);
  }

  _createClass(SchedulerCustomTimeAxis3, null, [{
    key: "type",
    get: // Factoryable type name
    function get() {
      return 'schedulercustomtimeaxis3';
    }
  }, {
    key: "defaultConfig",
    get: function get() {
      return {
        eventStyle: 'colored',
        features: {
          sort: 'name',
          stripe: true,
          eventResize: {
            showExactResizePosition: true
          }
        },
        zoomOnTimeAxisDoubleClick: false,
        zoomOnMouseWheel: false,
        // Custom preset to display work hours below day
        viewPreset: {
          displayDateFormat: 'H:mm',
          shiftIncrement: 1,
          shiftUnit: 'WEEK',
          timeResolution: {
            unit: 'MINUTE',
            increment: 10
          },
          headers: [{
            unit: 'year',
            // Simplified scenario, assuming view will always just show one US fiscal year
            cellGenerator: function cellGenerator(viewStart, viewEnd) {
              return [{
                start: viewStart,
                end: viewEnd,
                header: "Fiscal Year ".concat(viewStart.getFullYear() + 1)
              }];
            }
          }, {
            unit: 'quarter',
            renderer: function renderer(start, end) {
              var quarter = Math.floor(start.getMonth() / 3) + 1,
                  fiscalQuarter = quarter === 4 ? 1 : quarter + 1;
              return "FQ".concat(fiscalQuarter, " ").concat(start.getFullYear() + (fiscalQuarter === 1 ? 1 : 0));
            }
          }, {
            unit: 'month',
            dateFormat: 'MMM Y'
          }]
        },
        rowHeight: 60,
        resources: [{
          id: 'r1',
          name: 'Mike'
        }, {
          id: 'r2',
          name: 'Linda'
        }, {
          id: 'r3',
          name: 'Don'
        }, {
          id: 'r4',
          name: 'Karen'
        }, {
          id: 'r5',
          name: 'Doug'
        }, {
          id: 'r6',
          name: 'Peter'
        }, {
          id: 'r7',
          name: 'Fred'
        }, {
          id: 'r8',
          name: 'Lisa'
        }, {
          id: 'r9',
          name: 'Annie'
        }, {
          id: 'r10',
          name: 'Dan'
        }],
        events: [{
          id: 1,
          resourceId: 'r9',
          startDate: '2021-02-11',
          endDate: '2021-02-28',
          name: 'Some task',
          eventColor: 'blue'
        }, {
          id: 2,
          resourceId: 'r2',
          startDate: '2021-08-13',
          endDate: '2021-09-23',
          name: 'Other task',
          eventColor: 'lime'
        }, {
          id: 3,
          resourceId: 'r3',
          startDate: '2021-02-24',
          endDate: '2021-06-24',
          name: 'Important task',
          eventColor: 'red'
        }],
        // Setup static columns
        columns: [{
          text: 'Name',
          width: 100,
          field: 'name'
        }]
      };
    }
  }]);

  return SchedulerCustomTimeAxis3;
}(Scheduler);

; // Register this widget type with its Factory

SchedulerCustomTimeAxis3.initClass();

var SchedulerFilterableTimeAxis = /*#__PURE__*/function (_Scheduler4) {
  _inherits(SchedulerFilterableTimeAxis, _Scheduler4);

  var _super4 = _createSuper(SchedulerFilterableTimeAxis);

  function SchedulerFilterableTimeAxis() {
    _classCallCheck(this, SchedulerFilterableTimeAxis);

    return _super4.apply(this, arguments);
  }

  _createClass(SchedulerFilterableTimeAxis, [{
    key: "construct",
    value: function construct(config) {
      var me = this; // Custom preset to display number of events per day in header

      Object.assign(config, {
        resources: [{
          id: 'r1',
          name: 'Mike'
        }, {
          id: 'r2',
          name: 'Linda'
        }, {
          id: 'r3',
          name: 'Don'
        }, {
          id: 'r4',
          name: 'Karen'
        }, {
          id: 'r5',
          name: 'Doug'
        }, {
          id: 'r6',
          name: 'Peter'
        }, {
          id: 'r7',
          name: 'Fred'
        }, {
          id: 'r8',
          name: 'Lisa'
        }, {
          id: 'r9',
          name: 'Annie'
        }, {
          id: 'r10',
          name: 'Dan'
        }],
        events: [{
          id: 1,
          resourceId: 'r9',
          startDate: '2019-02-16 12:00',
          endDate: '2019-02-16 16:00',
          name: 'Some task',
          eventColor: 'pink'
        }, {
          id: 2,
          resourceId: 'r2',
          startDate: '2019-02-10 08:00',
          endDate: '2019-02-10 14:00',
          name: 'Other task',
          eventColor: 'gray'
        }, {
          id: 3,
          resourceId: 'r10',
          startDate: '2019-02-15 08:00',
          endDate: '2019-02-15 14:00',
          name: 'Important task',
          eventColor: 'orange'
        }],
        viewPreset: {
          tickWidth: 20,
          displayDateFormat: 'L',
          shiftUnit: 'WEEK',
          shiftIncrement: 1,
          defaultSpan: 10,
          timeResolution: {
            unit: 'HOUR',
            increment: 6
          },
          headers: [{
            unit: 'WEEK',
            dateFormat: 'ddd D MMM YYYY'
          }, {
            unit: 'DAY',
            align: 'center',
            dateFormat: 'd1'
          }, {
            unit: 'DAY',
            align: 'center',
            renderer: function renderer(start, end, config, index) {
              return me.eventStore.getEvents({
                startDate: start,
                endDate: end
              }).length;
            }
          }]
        }
      });

      _get(_getPrototypeOf(SchedulerFilterableTimeAxis.prototype), "construct", this).call(this, config); // Refresh headers on changes to the eventStore, to show the amount of tasks per day


      me.eventStore.on('change', function () {
        me.timeAxisColumn.refreshHeader();
      });
    }
  }, {
    key: "eventRenderer",
    value: function eventRenderer(_ref2) {
      var eventRecord = _ref2.eventRecord;
      return DateHelper.format(eventRecord.startDate, 'L');
    } //region eventlisteners

  }, {
    key: "onClearFilterClick",
    value: function onClearFilterClick() {
      this.timeAxis.clearFilters();
    }
  }, {
    key: "onWeekdaysClick",
    value: function onWeekdaysClick() {
      this.timeAxis.filterBy(function (tick) {
        return tick.startDate.getDay() !== 6 && tick.startDate.getDay() !== 0;
      });
    }
  }, {
    key: "onWeekendsClick",
    value: function onWeekendsClick() {
      this.timeAxis.filterBy(function (tick) {
        return tick.startDate.getDay() === 6 || tick.startDate.getDay() === 0;
      });
    }
  }, {
    key: "onBookedClick",
    value: function onBookedClick() {
      var _this = this;

      this.timeAxis.filterBy(function (tick) {
        return _this.eventStore.query(function (eventRecord) {
          return DateHelper.intersectSpans(eventRecord.startDate, eventRecord.endDate, tick.startDate, tick.endDate);
        }).length > 0;
      });
    } //endregion

  }], [{
    key: "type",
    get: // Factoryable type name
    function get() {
      return 'schedulerfilterabletimeaxis';
    }
  }, {
    key: "configurable",
    get: function get() {
      return {
        tbar: [{
          type: 'buttonGroup',
          color: 'b-orange',
          toggleGroup: true,
          items: [{
            type: 'button',
            text: 'No filter',
            onClick: 'up.onClearFilterClick',
            pressed: true
          }, {
            type: 'button',
            text: 'Only weekdays',
            onClick: 'up.onWeekdaysClick'
          }, {
            type: 'button',
            text: 'Only weekends',
            onClick: 'up.onWeekendsClick'
          }, {
            type: 'button',
            text: 'Only days with booked events',
            onClick: 'up.onBookedClick'
          }]
        }],
        zoomOnTimeAxisDoubleClick: false,
        features: {
          sort: 'name'
        },
        forceFit: true,
        columns: [{
          text: 'Name',
          width: 100,
          field: 'name'
        }]
      };
    }
  }]);

  return SchedulerFilterableTimeAxis;
}(Scheduler); // Register this widget type with its Factory


SchedulerFilterableTimeAxis.initClass();

var DH = DateHelper,
    sleepingEmoji = "\uD83D\uDE34",
    eatingEmoji = "\uD83E\uDD6A",
    startTime = 7,
    lunchTime = 11,
    endTime = 16,
    // 11:00 - 12:00 lunch time
isLunch = function isLunch(date) {
  return date.getHours() === lunchTime;
},
    // 7:00 - 11:00 && 12:00 - 16:00 working time
isWorkingTime = function isWorkingTime(date) {
  return !isLunch(date) && date.getHours() >= startTime && date.getHours() < endTime;
};

var SchedulerCompressedTimeAxis = /*#__PURE__*/function (_Scheduler5) {
  _inherits(SchedulerCompressedTimeAxis, _Scheduler5);

  var _super5 = _createSuper(SchedulerCompressedTimeAxis);

  function SchedulerCompressedTimeAxis() {
    _classCallCheck(this, SchedulerCompressedTimeAxis);

    return _super5.apply(this, arguments);
  }

  _createClass(SchedulerCompressedTimeAxis, null, [{
    key: "type",
    get: // Factoryable type name
    function get() {
      return 'schedulercompressedtimeaxis';
    }
  }, {
    key: "defaultConfig",
    get: function get() {
      return {
        eventStyle: 'colored',
        features: {
          sort: 'name',
          stripe: true,
          eventResize: {
            showExactResizePosition: true
          }
        },
        zoomOnTimeAxisDoubleClick: false,
        zoomOnMouseWheel: false,
        viewPreset: {
          displayDateFormat: 'H:mm',
          tickWidth: 40,
          shiftIncrement: 1,
          shiftUnit: 'DAY',
          timeResolution: {
            unit: 'MINUTE',
            increment: 30
          },
          headers: [{
            unit: 'DAY',
            align: 'center',
            dateFormat: 'ddd L'
          }, {
            unit: 'MINUTE',
            align: 'center',
            increment: 30,
            renderer: function renderer(date) {
              return isWorkingTime(date) ? DH.format(date, 'H:mm') : isLunch(date) ? eatingEmoji : sleepingEmoji;
            }
          }]
        },
        timeAxis: {
          continuous: false,
          generateTicks: function generateTicks(start, end, unit, increment) {
            // Use our own custom time intervals for minute time-axis
            if (unit === 'minute') {
              var // add early morning
              ticks = [{
                startDate: start,
                endDate: DH.add(start, startTime, 'hours')
              }]; // generate the 1st half of the day

              for (var date = ticks[0].endDate; date.getHours() < lunchTime;) {
                var tickEnd = DH.add(date, 30, 'minute');
                ticks.push({
                  startDate: date,
                  endDate: tickEnd
                });
                date = tickEnd;
              } // add lunch


              var lunchStart = ticks[ticks.length - 1].endDate;
              ticks.push({
                startDate: lunchStart,
                endDate: DH.add(lunchStart, 1, 'hour')
              }); // generate the 2nd half of the day

              for (var _date = ticks[ticks.length - 1].endDate; _date.getHours() < endTime;) {
                var _tickEnd = DH.add(_date, 30, 'minute');

                ticks.push({
                  startDate: _date,
                  endDate: _tickEnd
                });
                _date = _tickEnd;
              } // add the rest of the day


              ticks.push({
                startDate: ticks[ticks.length - 1].endDate,
                endDate: end
              });
              return ticks;
            }
          }
        },
        rowHeight: 60,
        resources: [{
          id: 'r1',
          name: 'Mike'
        }, {
          id: 'r2',
          name: 'Linda'
        }, {
          id: 'r3',
          name: 'Don'
        }, {
          id: 'r4',
          name: 'Karen'
        }, {
          id: 'r5',
          name: 'Doug'
        }, {
          id: 'r6',
          name: 'Peter'
        }, {
          id: 'r7',
          name: 'Fred'
        }, {
          id: 'r8',
          name: 'Lisa'
        }, {
          id: 'r9',
          name: 'Annie'
        }, {
          id: 'r10',
          name: 'Dan'
        }],
        events: [{
          id: 1,
          resourceId: 'r9',
          startDate: '2020-02-20 06:30',
          endDate: '2020-02-20 08:30',
          name: 'Morning task',
          eventColor: 'blue'
        }, {
          id: 2,
          resourceId: 'r2',
          startDate: '2020-02-20 10:00',
          endDate: '2020-02-20 13:00',
          name: 'No lunch task',
          eventColor: 'lime'
        }, {
          id: 3,
          resourceId: 'r3',
          startDate: '2020-02-20 17:00',
          endDate: '2020-02-20 20:00',
          name: 'Night task',
          eventColor: 'red'
        }, {
          id: 4,
          resourceId: 'r5',
          startDate: '2020-02-20 11:30',
          endDate: '2020-02-20 20:00',
          name: 'After lunch overtime',
          eventColor: 'orange'
        }],
        // Setup static columns
        columns: [{
          text: 'Name',
          width: 100,
          field: 'name'
        }]
      };
    }
  }]);

  return SchedulerCompressedTimeAxis;
}(Scheduler);

; // Register this widget type with its Factory

SchedulerCompressedTimeAxis.initClass();
/* eslint-disable no-unused-vars */

var tabPanel = new TabPanel({
  appendTo: 'container',
  items: [{
    title: 'Custom timeaxis #1',
    ref: 'custom1',
    type: 'schedulercustomtimeaxis',
    startDate: new Date(2019, 1, 11),
    endDate: new Date(2019, 1, 16)
  }, {
    title: 'Custom timeaxis #2',
    ref: 'custom2',
    type: 'schedulercustomtimeaxis2',
    startDate: new Date(2019, 1, 11),
    endDate: new Date(2019, 1, 16)
  }, {
    title: 'Filterable timeaxis',
    ref: 'filterable',
    type: 'schedulerfilterabletimeaxis',
    startDate: new Date(2019, 1, 10),
    endDate: new Date(2019, 1, 17)
  }, {
    title: 'Custom header tick spans',
    ref: 'custom3',
    type: 'schedulercustomtimeaxis3',
    startDate: new Date(2020, 9, 1),
    endDate: new Date(2021, 9, 1)
  }, {
    title: 'Compressed non-working time',
    ref: 'compressed',
    type: 'schedulercompressedtimeaxis',
    startDate: new Date(2020, 1, 20),
    endDate: new Date(2020, 1, 21)
  }]
});