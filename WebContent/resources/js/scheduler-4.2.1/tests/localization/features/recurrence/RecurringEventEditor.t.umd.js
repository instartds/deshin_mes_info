function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    var _scheduler, _scheduler$destroy;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : (_scheduler$destroy = _scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(_scheduler);
  }); // https://github.com/bryntum/support/issues/2958

  t.it('Should fit week days on week buttons', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var initialTheme, checkEllipsis;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              initialTheme = DomHelper.themeInfo.name, checkEllipsis = function checkEllipsis() {
                scheduler.features.eventEdit.recurrenceEditor.widgetMap.daysButtonField.items.forEach(function (btn) {
                  var el = btn.label;
                  t.notOk(el.scrollWidth > el.clientWidth, "".concat(btn.text, " is visible on week button"));
                });
              };
              _context.next = 3;
              return t.getSchedulerAsync({
                enableRecurringEvents: true,
                startDate: '2021-05-13',
                features: {
                  eventTooltip: false,
                  eventEdit: true
                },
                events: [{
                  id: 1,
                  name: 'Foo',
                  startDate: '2021-05-14',
                  endDate: '2021-05-15'
                }, {
                  id: 2,
                  name: 'Bar',
                  startDate: '2021-05-14',
                  endDate: '2021-05-15',
                  recurrenceRule: 'FREQ=WEEKLY;INTERVAL=2',
                  cls: 'sch-event2'
                }],
                resources: [{
                  id: 'r1',
                  name: 'Resource 1'
                }, {
                  id: 'r2',
                  name: 'Resource 2'
                }],
                assignments: [{
                  id: 1,
                  eventId: 1,
                  resourceId: 'r1'
                }, {
                  id: 2,
                  eventId: 2,
                  resourceId: 'r1'
                }]
              });

            case 3:
              scheduler = _context.sent;
              _context.next = 6;
              return t.doubleClick('[data-event-id=2]');

            case 6:
              _context.next = 8;
              return t.click('.b-recurrencelegendbutton');

            case 8:
              ['Classic', 'Classic-Light', 'Classic-Dark', 'Material', 'Stockholm'].forEach(function (theme) {
                t.diag("Theme ".concat(theme));
                DomHelper.setTheme(theme);
                LocaleManager.applyLocale('Nl');
                checkEllipsis();
                LocaleManager.applyLocale('Ru');
                checkEllipsis();
                LocaleManager.applyLocale('SvSE');
                checkEllipsis();
                LocaleManager.applyLocale('En');
                checkEllipsis();
              });
              DomHelper.setTheme(initialTheme);

            case 10:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
});