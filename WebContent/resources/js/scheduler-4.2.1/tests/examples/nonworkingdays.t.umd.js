function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler = bryntum.query('scheduler'),
      getNonWorkingDaysValues = function getNonWorkingDaysValues() {
    return scheduler.widgetMap.nonWorkingDays.items.filter(function (button) {
      return button.pressed;
    }).map(function (button) {
      return button.index;
    });
  };

  t.it('Sanity', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.checkGridSanity(scheduler);

            case 2:
              _context.next = 4;
              return t.waitForSelector('.b-sch-nonworkingtime');

            case 4:
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
  t.it('Weekend buttons should be localized and selection updated on locale change', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var dayName;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.waitForSelector('.b-buttongroup[data-ref="nonWorkingDays"] .b-button[data-item-index="0"]:contains(Sun)');

            case 2:
              t.isDeeply(getNonWorkingDaysValues(), [0, 6], 'Buttons pressed correctly');
              _context2.next = 5;
              return t.click('.b-buttongroup[data-ref="nonWorkingDays"] .b-button[data-item-index="1"]');

            case 5:
              t.isDeeply(getNonWorkingDaysValues(), [0, 1, 6], 'Buttons pressed correctly');
              t.diag('Select Russian locale');
              _context2.next = 9;
              return t.click('[data-ref=infoButton]');

            case 9:
              _context2.next = 11;
              return t.click('[data-ref=localeCombo]');

            case 11:
              _context2.next = 13;
              return t.click('.b-list-item:contains(Русский)');

            case 13:
              dayName = BrowserHelper.isSafari ? 'Вс' : 'вс';
              _context2.next = 16;
              return t.waitForSelector(".b-buttongroup[data-ref=\"nonWorkingDays\"] .b-button[data-item-index=\"0\"]:contains(".concat(dayName, ")"));

            case 16:
              t.isDeeply(getNonWorkingDaysValues(), [0, 6], 'Buttons pressed correctly');
              _context2.next = 19;
              return t.click('.b-buttongroup[data-ref="nonWorkingDays"] .b-button[data-item-index="2"]');

            case 19:
              t.isDeeply(getNonWorkingDaysValues(), [0, 2, 6], 'Buttons pressed correctly');
              t.diag('Select English locale');
              _context2.next = 23;
              return t.click('[data-ref=infoButton]');

            case 23:
              _context2.next = 25;
              return t.click('[data-ref=localeCombo]');

            case 25:
              _context2.next = 27;
              return t.click('.b-list-item:contains(English)');

            case 27:
              _context2.next = 29;
              return t.waitForSelector('.b-buttongroup[data-ref="nonWorkingDays"] .b-button[data-item-index="0"]:contains(Sun)');

            case 29:
              t.isDeeply(getNonWorkingDaysValues(), [0, 1, 6], 'Buttons pressed correctly');
              t.diag('Select Russian locale');
              _context2.next = 33;
              return t.click('[data-ref=infoButton]');

            case 33:
              _context2.next = 35;
              return t.click('[data-ref=localeCombo]');

            case 35:
              _context2.next = 37;
              return t.click('.b-list-item:contains(Русский)');

            case 37:
              _context2.next = 39;
              return t.waitForSelector(".b-buttongroup[data-ref=\"nonWorkingDays\"] .b-button[data-item-index=\"0\"]:contains(".concat(dayName, ")"));

            case 39:
              t.isDeeply(getNonWorkingDaysValues(), [0, 2, 6], 'Buttons pressed correctly');

            case 40:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref2.apply(this, arguments);
    };
  }());
});