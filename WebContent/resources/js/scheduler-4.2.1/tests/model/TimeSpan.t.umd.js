function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

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

StartTest(function (t) {
  t.it('Sanity', function (t) {
    t.ok(TimeSpan, 'TimeSpan is here');
    t.diag('get dates');
    t.is(new TimeSpan().name, '', 'New timespan should have empty name');
    var timespan1 = new TimeSpan({
      startDate: new Date(2011, 6, 10),
      endDate: new Date(2011, 6, 12)
    });
    t.isDeeply(timespan1.dates, [new Date(2011, 6, 10), new Date(2011, 6, 11)], 'Correct dates in timespan');
    var timespan2 = new TimeSpan({
      startDate: new Date(2011, 6, 10, 1),
      endDate: new Date(2011, 6, 12, 1)
    });
    t.isDeeply(timespan2.dates, [new Date(2011, 6, 10), new Date(2011, 6, 11), new Date(2011, 6, 12)], 'Correct dates in timespan starting not at the days edge');
  });
  t.it('Duration should be calculated if not specified', function (t) {
    var timeSpan1 = new TimeSpan({
      startDate: new Date(2018, 2, 5),
      endDate: new Date(2018, 2, 7)
    });
    t.is(timeSpan1.duration, 2, 'duration correct');
    var timeSpan2 = new TimeSpan({
      startDate: new Date(2018, 2, 5, 10),
      endDate: new Date(2018, 2, 5, 11),
      durationUnit: 'hour'
    });
    t.is(timeSpan2.duration, 1, 'duration correct with durationUnit');
  });
  t.it('Start date should be calculated if not specified', function (t) {
    var timeSpan1 = new TimeSpan({
      endDate: new Date(2018, 2, 15),
      duration: 5
    });
    t.is(timeSpan1.startDate, new Date(2018, 2, 10), 'startDate correct');
    var timeSpan2 = new TimeSpan({
      endDate: new Date(2018, 2, 5, 10),
      duration: 0.5,
      durationUnit: 'hour'
    });
    t.is(timeSpan2.startDate, new Date(2018, 2, 5, 9, 30), 'startDate correct with durationUnit');
  });
  t.it('End date should be calculated if not specified', function (t) {
    var timeSpan1 = new TimeSpan({
      startDate: new Date(2018, 2, 5),
      duration: 5
    });
    t.is(timeSpan1.endDate, new Date(2018, 2, 10), 'endDate correct');
    var timeSpan2 = new TimeSpan({
      startDate: new Date(2018, 2, 5, 10),
      duration: 0.5,
      durationUnit: 'hour'
    });
    t.is(timeSpan2.endDate, new Date(2018, 2, 5, 10, 30), 'endDate correct with durationUnit');
  });
  t.it('Changing dates should optionally update duration', function (t) {
    var timeSpan = new TimeSpan({
      startDate: new Date(2018, 2, 5),
      endDate: new Date(2018, 2, 7)
    });
    timeSpan.endDate = new Date(2018, 2, 6);
    t.is(timeSpan.startDate, new Date(2018, 2, 5), 'startDate intact');
    t.is(timeSpan.endDate, new Date(2018, 2, 6), 'endDate set');
    t.is(timeSpan.duration, 1, 'Changing endDate updated duration');
    timeSpan.startDate = new Date(2018, 2, 4);
    t.is(timeSpan.startDate, new Date(2018, 2, 4), 'startDate moved');
    t.is(timeSpan.endDate, new Date(2018, 2, 5), 'endDate updated');
    t.is(timeSpan.duration, 1, 'Calling startDate setter kept duration by default');
    timeSpan.setStartDate(new Date(2018, 2, 3), false);
    t.is(timeSpan.startDate, new Date(2018, 2, 3), 'startDate set');
    t.is(timeSpan.endDate, new Date(2018, 2, 5), 'endDate intact');
    t.is(timeSpan.duration, 2, 'Calling setStartDate with false, should update duration');
    timeSpan.setStartDate(new Date(2018, 2, 4), true);
    t.is(timeSpan.startDate, new Date(2018, 2, 4), 'startDate set');
    t.is(timeSpan.endDate, new Date(2018, 2, 6), 'startDate intact');
    t.is(timeSpan.duration, 2, 'Calling setStartDate with true should keep duration');
  });
  t.it('Changing duration should update endDate', function (t) {
    var timeSpan1 = new TimeSpan({
      startDate: new Date(2018, 2, 5),
      endDate: new Date(2018, 2, 7)
    });
    timeSpan1.duration = 5;
    t.is(timeSpan1.endDate, new Date(2018, 2, 10), 'endDate correct');
  });
  t.it('Changing duration with a string representation of the new duration should update endDate', function (t) {
    var timeSpan1 = new TimeSpan({
      startDate: new Date(2018, 2, 5),
      endDate: new Date(2018, 2, 7)
    });
    timeSpan1.duration = '5';
    t.is(timeSpan1.endDate, new Date(2018, 2, 10), 'endDate correct');
  });
  t.it('Changing duration and unit should update endDate', function (t) {
    var timeSpan1 = new TimeSpan({
      startDate: new Date(2018, 2, 5, 10),
      duration: 0.5,
      durationUnit: 'hour'
    });
    timeSpan1.setDuration(1, 'day');
    t.is(timeSpan1.endDate, new Date(2018, 2, 6, 10), 'endDate correct');
  });
  t.it('Changing duration and unit should update endDate when new duration is in string representation', function (t) {
    var timeSpan1 = new TimeSpan({
      startDate: new Date(2018, 2, 5, 10),
      duration: 0.5,
      durationUnit: 'hour'
    });
    timeSpan1.setDuration('1', 'day');
    t.is(timeSpan1.endDate, new Date(2018, 2, 6, 10), 'endDate correct');
  });
  t.it('Changing one date should not set the other if it is undefined and has no duration', function (t) {
    var timeSpan1 = new TimeSpan({
      startDate: new Date(2018, 2, 5)
    });
    timeSpan1.startDate = new Date(2017, 2, 6);
    t.notOk(timeSpan1.duration, 'No duration set');
    t.notOk(timeSpan1.endDate, 'No endDate set');
    var timeSpan2 = new TimeSpan({
      endDate: new Date(2018, 2, 5)
    });
    timeSpan2.endDate = new Date(2017, 2, 6);
    t.notOk(timeSpan2.duration, 'No duration set');
    t.notOk(timeSpan2.startDate, 'No startDate set');
  });
  t.it('Setting start date when having only duration should calculate the end date', function (t) {
    var timeSpan1 = new TimeSpan({
      duration: 3
    });
    timeSpan1.startDate = new Date(2018, 2, 6);
    t.is(timeSpan1.endDate, new Date(2018, 2, 9), 'endDate calculated');
  });
  t.it('Setting end date when having only duration should calculate the start date', function (t) {
    var timeSpan1 = new TimeSpan({
      duration: 3
    });
    timeSpan1.endDate = new Date(2018, 2, 9);
    t.is(timeSpan1.startDate, new Date(2018, 2, 6), 'startDate calculated');
  });
  t.it('Setting new start date > end date should not result in negative duration', function (t) {
    var timeSpan1 = new TimeSpan({
      startDate: new Date(2018, 0, 1),
      duration: 1
    });
    timeSpan1.startDate = new Date(2018, 1, 1);
    t.is(timeSpan1.startDate, new Date(2018, 1, 1), 'startDate moved');
    t.is(timeSpan1.endDate, new Date(2018, 1, 2), 'endDate calculated');
    t.is(timeSpan1.duration, 1, 'duration intact');
  });
  t.it('Setting new end date < start date should throw', function (t) {
    var timeSpan1 = new TimeSpan({
      startDate: new Date(2018, 0, 1),
      duration: 1
    });
    t.throwsOk(function () {
      timeSpan1.endDate = new Date(2017, 0, 1);
    }, 'Negative duration');
  });
  t.it('Setting new start date + end date together should work', function (t) {
    var timeSpan1 = new TimeSpan({
      startDate: new Date(2018, 0, 1),
      duration: 1
    });
    timeSpan1.set({
      startDate: new Date(2018, 0, 1),
      endDate: new Date(2018, 0, 11)
    });
    t.is(timeSpan1.startDate, new Date(2018, 0, 1), 'startDate set');
    t.is(timeSpan1.endDate, new Date(2018, 0, 11), 'endDate set');
    t.is(timeSpan1.duration, 10, 'duration calculated');
    timeSpan1.setStartEndDate(new Date(2018, 0, 3), new Date(2018, 0, 5));
    t.is(timeSpan1.startDate, new Date(2018, 0, 3), 'setStartEndDate: startDate set');
    t.is(timeSpan1.endDate, new Date(2018, 0, 5), 'setStartEndDate: endDate set');
    t.is(timeSpan1.duration, 2, 'setStartEndDate: duration calculated');
  });
  t.it('Setting new start date + duration in an Object set should work', function (t) {
    var timeSpan = new TimeSpan({
      startDate: new Date(2018, 0, 1),
      duration: 1
    });
    timeSpan.set({
      startDate: new Date(2018, 0, 12),
      duration: 2,
      durationUnit: 'minutes'
    });
    t.is(timeSpan.startDate, new Date(2018, 0, 12), 'startDate set');
    t.is(timeSpan.endDate, new Date(2018, 0, 12, 0, 2), 'endDate calculated');
    t.is(timeSpan.duration, 2, 'duration set');
    t.is(timeSpan.durationUnit, 'minutes', 'durationUnit set');
  }); // https://app.assembla.com/spaces/bryntum/tickets/7735

  t.it('TimeSpan.normalize should respect custom model fields', function (t) {
    var MyTimeSpan = /*#__PURE__*/function (_TimeSpan) {
      _inherits(MyTimeSpan, _TimeSpan);

      var _super = _createSuper(MyTimeSpan);

      function MyTimeSpan() {
        _classCallCheck(this, MyTimeSpan);

        return _super.apply(this, arguments);
      }

      _createClass(MyTimeSpan, null, [{
        key: "fields",
        get: function get() {
          return [{
            name: 'startDate',
            dataSource: 'taskstart',
            type: 'date',
            format: 'YYYY-MM-DDTHH:mm:ssZ'
          }, {
            name: 'endDate',
            dataSource: 'taskfinish',
            type: 'date',
            format: 'YYYY-MM-DDTHH:mm:ssZ'
          }, {
            name: 'duration',
            dataSource: 'lasting',
            type: 'number',
            allowNull: true
          }, {
            name: 'durationUnit',
            dataSource: 'lastingUnit',
            type: 'string',
            defaultValue: 'd'
          }];
        }
      }]);

      return MyTimeSpan;
    }(TimeSpan); // normalize is called automatically after model creation


    var spanWithNoDuration = new MyTimeSpan({
      taskstart: new Date(2019, 2, 8),
      taskfinish: new Date(2019, 2, 9)
    });
    t.is(spanWithNoDuration.data.lasting, 1);
    t.is(spanWithNoDuration.data.lastingUnit, 'd');
    var spanWithNoEndDate = new MyTimeSpan({
      taskstart: new Date(2019, 2, 8),
      lasting: 4,
      lastingUnit: 'h'
    });
    spanWithNoEndDate.normalize();
    t.isDateEqual(spanWithNoEndDate.data.taskfinish, new Date(2019, 2, 8, 4));
    var spanWithNoStartDate = new MyTimeSpan({
      taskfinish: new Date(2019, 2, 9),
      lasting: 4,
      lastingUnit: 'h'
    });
    spanWithNoStartDate.normalize();
    t.isDateEqual(spanWithNoStartDate.data.taskstart, new Date(2019, 2, 8, 20));
  });
});