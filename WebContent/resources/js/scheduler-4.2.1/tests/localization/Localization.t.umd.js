function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  function applyLocale(t, name) {
    t.diag("Applying locale ".concat(name));
    return LocaleManager.locale = window.bryntum.locales[name];
  }

  Object.assign(window, {
    Scheduler: Scheduler,
    EventStore: EventStore,
    ResourceStore: ResourceStore,
    DependencyStore: DependencyStore
  });
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
    scheduler = null;
  });
  t.it('Should update event editor date pickers weekStartDay on switching locales', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventTooltip: false,
        eventEdit: true // is enabled by default already, but in case we change our minds...

      }
    });
    t.chain({
      waitForRowsVisible: scheduler
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
      var locale;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              locale = applyLocale(t, 'En');
              t.is(locale.DateHelper.weekStartDay, 0, 'English week starts from Sunday');

            case 2:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    })), {
      doubleClick: '.b-sch-event'
    }, {
      click: '.b-pickerfield[data-ref="startDateField"] .b-icon-calendar'
    }, {
      waitForSelector: '.b-calendar-day-header[data-column-index="0"][data-cell-day="0"]',
      desc: 'Start date: Week starts with correct day'
    }, {
      type: '[ESC]'
    }, {
      click: '.b-pickerfield[data-ref="endDateField"] .b-icon-calendar'
    }, {
      waitForSelector: '.b-calendar-day-header[data-column-index="0"][data-cell-day="0"]',
      desc: 'End date: Week starts with correct day'
    }, {
      type: '[ESC]'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      var locale;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              locale = applyLocale(t, 'Ru');
              t.is(locale.DateHelper.weekStartDay, 1, 'Russian week starts from Monday');

            case 2:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    })), {
      click: '.b-pickerfield[data-ref="startDateField"] .b-icon-calendar'
    }, {
      waitForSelector: '.b-calendar-day-header[data-column-index="0"][data-cell-day="1"]',
      desc: 'Start date: Week starts with correct day'
    }, {
      type: '[ESC]'
    }, {
      click: '.b-pickerfield[data-ref="endDateField"] .b-icon-calendar'
    }, {
      waitForSelector: '.b-calendar-day-header[data-column-index="0"][data-cell-day="1"]',
      desc: 'End date: Week starts with correct day'
    });
  });
  t.it('Should update topDateFormat for dayAndWeek preset on switching locales', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'dayAndWeek'
    }); // new Intl.DateTimeFormat('ru', { month : 'short' }).format(new Date(2011, 0, 1))
    // Chrome => "янв."
    // IE11   => "янв"

    var ruDateText = BrowserHelper.isIE11 ? 'нед.01 янв 2011' : 'нед.01 янв. 2011';
    t.chain({
      waitForRowsVisible: scheduler
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              applyLocale(t, 'En');

            case 1:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    })), {
      waitForSelector: '.b-sch-header-timeaxis-cell[data-tick-index="0"]:contains(w.01 Jan 2011)',
      desc: 'English topDateFormat is correct for dayAndWeek preset'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              applyLocale(t, 'Ru');

            case 1:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    })), {
      waitForSelector: ".b-sch-header-timeaxis-cell[data-tick-index=\"0\"]:contains(".concat(ruDateText, ")"),
      desc: 'Russian topDateFormat is correct for dayAndWeek preset'
    });
  });
  t.it('Should update topDateFormat for dayAndWeek and weekAndDay presets on switching locales', function (t) {
    var customEnLocale = LocaleHelper.mergeLocales(window.bryntum.locales.En, {
      PresetManager: {
        dayAndWeek: {
          topDateFormat: 'MMMM YYYY'
        },
        weekAndDay: {
          topDateFormat: 'YYYY MMM DD'
        }
      }
    });
    LocaleHelper.publishLocale('En-Custom', customEnLocale);
    scheduler = t.getScheduler({
      viewPreset: 'dayAndWeek'
    });
    t.chain({
      waitForRowsVisible: scheduler
    }, function () {
      applyLocale(t, 'En');
      t.selectorExists('.b-sch-header-timeaxis-cell[data-tick-index="0"]:contains(w.01 Jan 2011)', 'English topDateFormat is correct for dayAndWeek preset');
      applyLocale(t, 'En-Custom');
      t.selectorExists('.b-sch-header-timeaxis-cell[data-tick-index="0"]:contains(January 2011)', 'English Custom topDateFormat is correct for dayAndWeek preset');
      scheduler.viewPreset = 'weekAndDay';
      applyLocale(t, 'En');
      t.selectorExists('.b-sch-header-timeaxis-cell[data-tick-index="0"]:contains(2011 January 02)', 'English topDateFormat is correct for weekAndDay preset');
      applyLocale(t, 'En-Custom');
      t.selectorExists('.b-sch-header-timeaxis-cell[data-tick-index="0"]:contains(2011 Jan 02)', 'English Custom topDateFormat is correct for weekAndDay preset');
    });
  }); // https://github.com/bryntum/support/issues/2770

  t.it('Should update column lines when changing locale', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'weekAndDayLetter',
                startDate: '2011-01-03',
                endDate: '2011-01-29',
                tickSize: 50
              });

            case 2:
              scheduler = _context5.sent;
              applyLocale(t, 'En');
              _context5.next = 6;
              return t.waitForAnimationFrame();

            case 6:
              t.is(scheduler.timeAxis.first.startDate.getDay(), 0, 'Week starts on Sunday');
              t.isApprox(DomHelper.getTranslateX(t.query('[data-line="major-1"]')[0]), 7 * scheduler.tickSize, 'First major after 7 ticks');
              applyLocale(t, 'SvSE');
              _context5.next = 11;
              return t.waitForAnimationFrame();

            case 11:
              t.is(scheduler.timeAxis.first.startDate, new Date(2011, 0, 2), 'Same tick setup after locale changed');
              t.is(scheduler.timeAxis.weekStartDay, 1, 'Time axis reports week starts on Monday');
              t.isApprox(DomHelper.getTranslateX(t.query('[data-line="major-1"]')[0]), scheduler.tickSize, 'First major now after 1 tick');

            case 14:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x) {
      return _ref5.apply(this, arguments);
    };
  }());
});