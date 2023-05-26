function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.it('sanity', function (t) {
    t.chain({
      waitForSelector: '.b-sch-foreground-canvas'
    }, function (next, el) {
      scheduler = bryntum.fromElement(el[0], 'scheduler');
      t.is(scheduler.timeAxis.weekStartDay, 1, 'weekStartDay localized');
      next();
    }, function () {
      return t.checkGridSanity(scheduler);
    });
  });
  t.it('Default locale (De)', function (t) {
    t.chain( // assume default language is German
    {
      waitForSelector: '[data-column="company"] .b-grid-header-text:textEquals(Firma)'
    }, {
      dblClick: '.b-sch-event'
    }, {
      waitForSelector: '.b-eventeditor'
    }, function (next) {
      t.selectorExists('button:textEquals(Abbrechen)', 'Cancel button is written in German');
      t.selectorExists('.b-combo label:textEquals(Ressource)', 'Resource selector label is written in German');
      next();
    }, {
      click: '[data-ref=infoButton]'
    }, {
      click: '[data-ref=localeCombo] input'
    }, // Switch to English locale
    {
      click: '.b-list :textEquals(English)'
    }, {
      waitForSelector: '[data-column="company"] .b-grid-header-text:textEquals(Company)'
    }, {
      dblClick: '.b-sch-event'
    }, {
      waitForSelector: '.b-eventeditor'
    }, function () {
      t.is(scheduler.timeAxis.weekStartDay, 0, 'weekStartDay localized');
      t.selectorExists('button:textEquals(Cancel)', 'Cancel button is written in English');
      t.selectorExists('.b-combo label:textEquals(Resource)', 'Resource selector label is written in English');
    });
  });
  t.it('Check all locales', function (t) {
    t.chain(['English', 'Nederlands', 'Svenska', 'Русский', 'Deutsch'].map(function (locale) {
      return [{
        diag: "Checking locale ".concat(locale)
      }, {
        click: '[data-ref=infoButton]'
      }, {
        moveMouseTo: '.info-popup .b-checkbox'
      }, {
        waitForSelector: '.b-tooltip-shared'
      }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
        return regeneratorRuntime.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                t.contentNotLike('.b-tooltip-shared', /L{/, 'Tooltip is localized');

              case 1:
              case "end":
                return _context.stop();
            }
          }
        }, _callee);
      })), {
        click: '[data-ref=localeCombo]'
      }, {
        click: ".b-list-item:contains(".concat(locale, ")")
      }];
    }));
  });
});