function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
    scheduler = null; // After scheduler destroy, all menuitems must also have been destroyed

    t.is(bryntum.queryAll('menuitem').length, 0, 'Menu items all destroyed');
  });
  t.it('Should work with a disabled dependencyEdit feature', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'dayAndWeek',
      features: {
        eventMenu: true,
        dependencies: {
          disabled: false
        },
        dependencyEdit: {
          disabled: true
        }
      }
    }, 3);
    t.chain({
      contextmenu: '.b-sch-header-timeaxis-cell'
    }, function () {
      return t.ok(scheduler.features.timeAxisHeaderMenu.menu.isVisible, 'Time axis header context menu is visible');
    });
  });
  t.it('Should not throw an error when timeaxis end date set to same as start date', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'dayAndWeek',
      startDate: new Date(2012, 5, 3),
      endDate: new Date(2012, 5, 17),
      features: {
        timeAxisHeaderMenu: true
      }
    }, 1);
    t.chain({
      rightclick: '.b-sch-header-timeaxis-cell',
      offset: [5, 5]
    }, {
      moveMouseTo: '.b-menuitem:contains(Date range)'
    }, {
      waitForElementVisible: '.b-datefield:contains(Start date)'
    }, // This should not throw
    function (next) {
      var sd = bryntum.fromElement(t.query('.b-datefield:contains(Start date)')[0]),
          ed = bryntum.fromElement(t.query('.b-datefield:contains(End date)')[0]);
      t.is(scheduler.timeAxis.count, 14, '14 ticks across TimeAxis');
      ed.value = sd.value;
      t.is(scheduler.timeAxis.count, 1, '1 tics across TimeAxis');
      next();
    });
  });
  t.it('Should not throw an error when timeaxis start date set greater than end date', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'hourAndDay',
      startDate: new Date(2012, 5, 3),
      endDate: new Date(2012, 5, 3, 6),
      appendTo: document.body,
      features: {
        timeAxisHeaderMenu: true
      }
    }, 1);
    var startDateField, endDateField;
    t.chain({
      rightclick: ':textEquals(12 AM)'
    }, {
      moveMouseTo: '.b-menuitem:contains(Date range)'
    }, {
      waitForElementVisible: '.b-datefield:contains(Start date)'
    }, {
      diag: 'Sanity checks'
    }, function (next) {
      startDateField = bryntum.fromElement(t.query('.b-datefield:contains(Start date)')[0]);
      endDateField = bryntum.fromElement(t.query('.b-datefield:contains(End date)')[0]);
      t.is(startDateField.value, new Date(2012, 5, 3), 'start date field value is correct');
      t.is(endDateField.value, new Date(2012, 5, 3), 'end date field value is correct');
      next();
    }, {
      diag: 'Change start date +1 day'
    }, {
      click: function click() {
        return startDateField.triggers.forward.element;
      },
      desc: 'Clicking to shift start date +1 day ..should not throw exception'
    }, function () {
      t.is(scheduler.timeAxis.count, 24, '1 ticks across TimeAxis');
      t.is(scheduler.timeAxis.startDate, new Date(2012, 5, 4), 'timeaxis start date is correct');
      t.is(scheduler.timeAxis.endDate, new Date(2012, 5, 5), 'timeaxis end date is correct');
    });
  });
  t.it('Should support adding extraItems', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'dayAndWeek',
      startDate: new Date(2012, 5, 3),
      endDate: new Date(2012, 5, 17),
      features: {
        timeAxisHeaderMenu: {
          items: [{
            text: 'Foo'
          }, {
            text: 'Bar'
          }]
        }
      }
    }, 1);
    t.chain({
      rightclick: '.b-sch-header-timeaxis-cell',
      offset: [5, 5]
    }, {
      waitForSelector: '.b-menuitem:contains(Foo)'
    }, {
      waitForSelector: '.b-menuitem:contains(Bar)'
    });
  });
  t.it('Should support manipulating default menu items', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'dayAndWeek',
      startDate: new Date(2012, 5, 3),
      endDate: new Date(2012, 5, 17),
      features: {
        timeAxisHeaderMenu: {
          processItems: function processItems(_ref) {
            var items = _ref.items;
            t.is(Object.keys(items).length, 5, '3 builtin items, 2 custom extra items'); // Filter out Bar item

            items.bar = false;
          },
          items: {
            foo: {
              text: 'Foo'
            },
            bar: {
              text: 'Bar'
            }
          }
        }
      }
    }, 1);
    t.chain({
      rightclick: '.b-sch-header-timeaxis-cell',
      offset: [5, 5]
    }, {
      waitForSelector: '.b-menuitem:contains(Foo)'
    }, {
      waitForSelectorNotFound: '.b-menuitem:contains(Bar)'
    });
  });
  t.it('Should handle triggerEvent config to show menu', function (t) {
    scheduler = t.getScheduler({
      features: {
        timeAxisHeaderMenu: {
          triggerEvent: 'click'
        }
      }
    });
    t.chain( // Click event
    {
      click: '.b-sch-header-timeaxis-cell'
    }, {
      waitForSelector: '.b-menu',
      desc: 'Menu visible'
    }, {
      type: '[ESC]]'
    }, {
      waitForSelectorNotFound: '.b-menu',
      desc: 'Menu hidden'
    },
    /*#__PURE__*/
    // DblClick event
    _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler.features.timeAxisHeaderMenu.triggerEvent = 'dblclick';

            case 1:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    })), {
      dblClick: '.b-sch-header-timeaxis-cell'
    }, {
      waitForSelector: '.b-menu',
      desc: 'Menu visible'
    }, {
      type: '[ESC]]'
    }, {
      waitForSelectorNotFound: '.b-menu',
      desc: 'Menu hidden'
    },
    /*#__PURE__*/
    // Contextmenu event
    _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler.features.timeAxisHeaderMenu.triggerEvent = 'contextmenu';

            case 1:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    })), {
      rightClick: '.b-sch-header-timeaxis-cell'
    }, {
      waitForSelector: '.b-menu',
      desc: 'Menu visible'
    }, {
      type: '[ESC]]'
    }, {
      waitForSelectorNotFound: '.b-menu',
      desc: 'Menu hidden'
    });
  });
  t.it('Should support disabling', function (t) {
    scheduler = t.getScheduler({
      features: {
        timeAxisHeaderMenu: true
      }
    });
    scheduler.features.timeAxisHeaderMenu.disabled = true;
    t.chain({
      rightClick: '.b-sch-timeaxiscolumn'
    }, function (next) {
      t.selectorNotExists('.b-menu', 'No menu displayed');
      scheduler.features.timeAxisHeaderMenu.disabled = false;
      next();
    }, {
      rightClick: '.b-sch-timeaxiscolumn'
    }, function () {
      t.selectorExists('.b-menu', 'Menu displayed');
    });
  });
});