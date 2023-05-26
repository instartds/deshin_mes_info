function _createForOfIteratorHelper(o, allowArrayLike) { var it = typeof Symbol !== "undefined" && o[Symbol.iterator] || o["@@iterator"]; if (!it) { if (Array.isArray(o) || (it = _unsupportedIterableToArray(o)) || allowArrayLike && o && typeof o.length === "number") { if (it) o = it; var i = 0; var F = function F() {}; return { s: F, n: function n() { if (i >= o.length) return { done: true }; return { done: false, value: o[i++] }; }, e: function e(_e) { throw _e; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var normalCompletion = true, didErr = false, err; return { s: function s() { it = it.call(o); }, n: function n() { var step = it.next(); normalCompletion = step.done; return step; }, e: function e(_e2) { didErr = true; err = _e2; }, f: function f() { try { if (!normalCompletion && it.return != null) it.return(); } finally { if (didErr) throw err; } } }; }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

var _bryntum$scheduler = bryntum.scheduler,
    AsyncHelper = _bryntum$scheduler.AsyncHelper,
    DateHelper = _bryntum$scheduler.DateHelper,
    WidgetHelper = _bryntum$scheduler.WidgetHelper,
    DataGenerator = _bryntum$scheduler.DataGenerator,
    Scheduler = _bryntum$scheduler.Scheduler;
var RESOURCES = 100,
    EVENTS = 5;

function generateResources() {
  return _generateResources.apply(this, arguments);
}

function _generateResources() {
  _generateResources = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
    var resourceCount, eventCount, today, mask, colors, resources, events, dependencies, schedulerEndDate, _iterator, _step, res, j, startDate, duration, endDate, eventId;

    return regeneratorRuntime.wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            resourceCount = RESOURCES, eventCount = EVENTS, today = DateHelper.clearTime(new Date()), mask = WidgetHelper.mask(scheduler.element, 'Generating records'), colors = ['cyan', 'green', 'indigo'], resources = [], events = [], dependencies = [];
            schedulerEndDate = today;
            _iterator = _createForOfIteratorHelper(DataGenerator.generate(resourceCount));
            _context.prev = 3;

            _iterator.s();

          case 5:
            if ((_step = _iterator.n()).done) {
              _context.next = 15;
              break;
            }

            res = _step.value;
            resources.push(res);

            for (j = 0; j < eventCount; j++) {
              startDate = DateHelper.add(today, Math.round(Math.random() * (j + 1) * 20), 'days'), duration = Math.round(Math.random() * 9) + 2, endDate = DateHelper.add(startDate, duration, 'days'), eventId = events.length + 1;
              events.push({
                id: eventId,
                name: 'Task #' + (events.length + 1),
                startDate: startDate,
                duration: duration,
                endDate: endDate,
                resourceId: res.id,
                eventColor: colors[resources.length % 3]
              });

              if (j > 0) {
                dependencies.push({
                  id: dependencies.length + 1,
                  from: eventId - 1,
                  to: eventId
                });
              }

              if (endDate > schedulerEndDate) schedulerEndDate = endDate;
            }

            if (!(resources.length % 20 === 0)) {
              _context.next = 13;
              break;
            }

            mask.text = "Generated ".concat(resources.length * eventCount, " of ").concat(resourceCount * eventCount, " records");
            _context.next = 13;
            return AsyncHelper.animationFrame();

          case 13:
            _context.next = 5;
            break;

          case 15:
            _context.next = 20;
            break;

          case 17:
            _context.prev = 17;
            _context.t0 = _context["catch"](3);

            _iterator.e(_context.t0);

          case 20:
            _context.prev = 20;

            _iterator.f();

            return _context.finish(20);

          case 23:
            scheduler.endDate = schedulerEndDate;
            scheduler.eventStore.data = events;
            scheduler.resourceStore.data = resources;
            scheduler.dependencyStore.data = dependencies;
            mask.close();

          case 28:
          case "end":
            return _context.stop();
        }
      }
    }, _callee, null, [[3, 17, 20, 23]]);
  }));
  return _generateResources.apply(this, arguments);
}

var headerTpl = function headerTpl(_ref) {
  var currentPage = _ref.currentPage,
      totalPages = _ref.totalPages;
  return "\n    <div class=\"demo-export-header\">\n        <img src=\"resources/logo.png\"/>\n        <dl>\n            <dt>Date: ".concat(DateHelper.format(new Date(), 'll LT'), "</dt>\n            <dd>").concat(totalPages ? "Page: ".concat(currentPage + 1, "/").concat(totalPages) : '', "</dd>\n        </dl>\n    </div>");
};

var footerTpl = function footerTpl() {
  return '<div class="demo-export-footer"><h3>© 2020 Bryntum AB</h3></div>';
};

var scheduler = new Scheduler({
  appendTo: 'container',
  eventStyle: 'border',
  rowHeight: 50,
  columns: [{
    type: 'rownumber'
  }, {
    text: 'First name',
    field: 'firstName',
    flex: 1
  }, {
    text: 'Surname',
    field: 'surName',
    flex: 1
  }, {
    type: 'number',
    text: 'Score',
    field: 'score',
    flex: 1
  }],
  features: {
    dependencies: {
      disabled: true
    },
    pdfExport: {
      exportServer: 'http://localhost:8080/',
      headerTpl: headerTpl,
      footerTpl: footerTpl
    }
  },
  tbar: [{
    type: 'button',
    toggleable: true,
    icon: 'b-fa-square',
    pressedIcon: 'b-fa-check-square',
    text: 'Show dependencies',
    onToggle: function onToggle(_ref2) {
      var pressed = _ref2.pressed;
      scheduler.features.dependencies.disabled = !pressed;
    }
  }, {
    ref: 'exportButton',
    type: 'button',
    icon: 'b-fa-file-export',
    text: 'Export',
    onClick: function onClick() {
      scheduler.features.pdfExport.showExportDialog();
    }
  }]
});
generateResources();