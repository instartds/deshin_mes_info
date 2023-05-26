function _createForOfIteratorHelper(o, allowArrayLike) { var it = typeof Symbol !== "undefined" && o[Symbol.iterator] || o["@@iterator"]; if (!it) { if (Array.isArray(o) || (it = _unsupportedIterableToArray(o)) || allowArrayLike && o && typeof o.length === "number") { if (it) o = it; var i = 0; var F = function F() {}; return { s: F, n: function n() { if (i >= o.length) return { done: true }; return { done: false, value: o[i++] }; }, e: function e(_e) { throw _e; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var normalCompletion = true, didErr = false, err; return { s: function s() { it = it.call(o); }, n: function n() { var step = it.next(); normalCompletion = step.done; return step; }, e: function e(_e2) { didErr = true; err = _e2; }, f: function f() { try { if (!normalCompletion && it.return != null) it.return(); } finally { if (didErr) throw err; } } }; }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

var _bryntum$scheduler = bryntum.scheduler,
    AsyncHelper = _bryntum$scheduler.AsyncHelper,
    DateHelper = _bryntum$scheduler.DateHelper,
    WidgetHelper = _bryntum$scheduler.WidgetHelper,
    Scheduler = _bryntum$scheduler.Scheduler,
    DataGenerator = _bryntum$scheduler.DataGenerator,
    RandomGenerator = _bryntum$scheduler.RandomGenerator;
var today = DateHelper.clearTime(new Date()),
    colors = ['cyan', 'green', 'indigo'];

function generateResources() {
  return _generateResources.apply(this, arguments);
}

function _generateResources() {
  _generateResources = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
    var resourceCount, eventCount, mask, resources, events, random, schedulerEndDate, _iterator, _step, res, j, num, startDate, duration, endDate;

    return regeneratorRuntime.wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            resourceCount = scheduler.widgetMap.resourceCountField.value, eventCount = scheduler.widgetMap.eventCountField.value, mask = WidgetHelper.mask(scheduler.element, 'Generating records'), resources = [], events = [], random = new RandomGenerator();
            schedulerEndDate = today;
            console.time('generate');
            _iterator = _createForOfIteratorHelper(DataGenerator.generate(resourceCount));
            _context.prev = 4;

            _iterator.s();

          case 6:
            if ((_step = _iterator.n()).done) {
              _context.next = 16;
              break;
            }

            res = _step.value;
            resources.push(res);

            for (j = 0; j < eventCount; j++) {
              num = random.nextRandom(j * 2 + 1) + j, startDate = DateHelper.add(today, num, 'days'), duration = Math.round(random.nextRandom(9)) + 2, endDate = DateHelper.add(startDate, duration, 'days');
              events.push({
                id: events.length + 1,
                name: "Task #".concat(events.length + 1),
                eventColor: colors[resources.length % 3],
                resourceId: res.id,
                startDate: startDate,
                duration: duration //endDate

              });

              if (endDate > schedulerEndDate) {
                schedulerEndDate = endDate;
              }
            }

            if (!(resources.length % 2000 === 0)) {
              _context.next = 14;
              break;
            }

            mask.text = "Generated ".concat(resources.length * eventCount, " of ").concat(resourceCount * eventCount, " records");
            _context.next = 14;
            return AsyncHelper.animationFrame();

          case 14:
            _context.next = 6;
            break;

          case 16:
            _context.next = 21;
            break;

          case 18:
            _context.prev = 18;
            _context.t0 = _context["catch"](4);

            _iterator.e(_context.t0);

          case 21:
            _context.prev = 21;

            _iterator.f();

            return _context.finish(21);

          case 24:
            console.timeEnd('generate');
            console.time('data');
            scheduler.suspendRefresh();
            scheduler.setTimeSpan(today, schedulerEndDate);
            scheduler.project = {
              resourceStore: {
                useRawData: true,
                data: resources
              },
              eventStore: {
                useRawData: true,
                data: events
              }
            };
            scheduler.resumeRefresh(true);
            console.timeEnd('data');
            mask.close();

          case 32:
          case "end":
            return _context.stop();
        }
      }
    }, _callee, null, [[4, 18, 21, 24]]);
  }));
  return _generateResources.apply(this, arguments);
}

var scheduler = new Scheduler({
  appendTo: 'container',
  eventStyle: 'border',
  rowHeight: 50,
  barMargin: 0,
  mode: 'vertical',
  tbar: [{
    ref: 'resourceCountField',
    type: 'number',
    placeholder: 'Number of resources',
    label: 'Resources',
    tooltip: 'Enter number of resource columns to generate and press [ENTER]',
    value: 100,
    width: 200,
    onChange: function onChange() {
      return generateResources();
    }
  }, {
    type: 'widget',
    html: 'X',
    width: 30,
    style: 'text-align: center'
  }, {
    ref: 'eventCountField',
    type: 'number',
    placeholder: 'Number of events',
    label: 'Events',
    tooltip: 'Enter number of events per resource to generate and press [ENTER]',
    min: 1,
    max: 100,
    value: 10,
    width: 180,
    onChange: function onChange() {
      return generateResources();
    }
  }]
});
generateResources();