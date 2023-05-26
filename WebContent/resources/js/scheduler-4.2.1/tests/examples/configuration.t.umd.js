function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler = bryntum.query('scheduler'),
      combo = scheduler.widgetMap.presetCombo;
  t.it('sanity', function (t) {
    t.chain({
      waitForSelector: '.b-sch-foreground-canvas'
    }, function () {
      return t.checkGridSanity(scheduler);
    });
  });
  t.it('Event editor should work', function (t) {
    var eventEdit = scheduler.features.eventEdit,
        chain = [],
        addStep = function addStep(event) {
      chain.push(function (next) {
        eventEdit.editEvent(event);
        next();
      }, {
        waitForElementVisible: '.b-eventeditor'
      }, // The min/max checking must not invalidate
      // valid field values.
      function (next) {
        t.selectorNotExists('.b-invalid');
        next();
      }, BrowserHelper.isIE11 ? {
        click: '.b-button:contains(Cancel)'
      } : {
        type: '[ESC]'
      });
    };

    scheduler.eventStore.forEach(addStep);
    t.chain(chain);
  });
  t.it('Preset combo works', function (t) {
    if (!combo) {
      t.exit('Preset combo not found  ');
    }

    t.ok(combo.isVisible, 'Combo is visible');
    t.is(combo.store.count, 11, 'Combo has correct number of items');
    t.chain( // Collect steps for each item
    combo.store.map(function (rec, index) {
      return [{
        click: '[data-ref=presetCombo]',
        desc: "Combo ".concat(index + 1, " clicked")
      }, {
        waitForEvent: [scheduler, 'presetchange'],
        trigger: {
          click: ".b-list-item[data-index=\"".concat(index, "\"][data-id=\"").concat(rec.id, "\"]")
        }
      }, function (next) {
        // https://github.com/bryntum/support/issues/2121
        // Going from text being wrapped->unwrapped or vice versa fooled DomSync.
        // Text was left behind in cells from previous rendering.
        // All cell text is wrapped now.
        Array.from(document.querySelectorAll('.b-sch-header-row.b-lowest .b-sch-header-timeaxis-cell')).forEach(function (cell) {
          t.isLessOrEqual(cell.scrollWidth, scheduler.tickSize);
        });
        t.is(combo.value, rec.id);
        next();
      }];
    }));
  });
  t.it('Should not be affected by XSS injection', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.injectXSS(scheduler);
              t.pass('Ok');

            case 2:
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