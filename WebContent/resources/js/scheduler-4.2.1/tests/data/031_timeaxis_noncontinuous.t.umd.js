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
  t.it('timeSpanInAxis works ok', function (t) {
    var ta = new TimeAxis({
      continuous: false
    });
    ta.reconfigure({
      unit: 'day',
      startDate: new Date(2012, 2, 25),
      endDate: new Date(2012, 2, 26)
    });
    t.ok(ta.timeSpanInAxis(new Date(2012, 2, 25), new Date(2012, 2, 26)), 'Time span matching time axis start end should be "in axis"');
    t.ok(ta.timeSpanInAxis(new Date(2012, 2, 24), new Date(2012, 2, 26)), 'Time span starting before time axis start should be "in axis"');
    t.ok(ta.timeSpanInAxis(new Date(2012, 2, 25), new Date(2012, 2, 27)), 'Time span ending after time axis end should be "in axis"');
    t.ok(ta.timeSpanInAxis(new Date(2012, 2, 24), new Date(2012, 2, 27)), 'Time span starting before and ending after time axis end should be "in axis"');
  });
  t.it('timeSpanInAxis works ok for generated ticks', function (t) {
    var startHour = 8,
        endHour = 17;

    var TestTimeAxis = /*#__PURE__*/function (_TimeAxis) {
      _inherits(TestTimeAxis, _TimeAxis);

      var _super = _createSuper(TestTimeAxis);

      function TestTimeAxis() {
        _classCallCheck(this, TestTimeAxis);

        return _super.apply(this, arguments);
      }

      _createClass(TestTimeAxis, [{
        key: "generateTicks",
        value: function generateTicks(start, end, unit, increment) {
          var ticks = [];

          while (start < end) {
            if (start.getHours() >= startHour && start.getHours() <= endHour) {
              ticks.push({
                startDate: start,
                endDate: DateHelper.add(start, 1, 'hour')
              });
            }

            start = DateHelper.add(start, 1, 'hour');
          }

          return ticks;
        }
      }]);

      return TestTimeAxis;
    }(TimeAxis);

    var startDate = new Date(2010, 0, 1),
        endDate = new Date(2010, 0, 3);
    var ta = new TestTimeAxis({
      continuous: false,
      startDate: startDate,
      endDate: endDate
    });

    while (startDate < endDate) {
      if (startDate.getHours() >= startHour && startDate.getHours() <= endHour) {
        t.ok(ta.dateInAxis(startDate), 'Date in axis: ' + startDate);
      } else {
        t.notOk(ta.dateInAxis(startDate), 'Date not in axis:' + startDate);
      }

      startDate = DateHelper.add(startDate, 1, 'hour');
    }
  });
});