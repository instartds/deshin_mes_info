function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var resourceCombo;
  t.beforeEach(function (t) {
    var _resourceCombo;

    (_resourceCombo = resourceCombo) === null || _resourceCombo === void 0 ? void 0 : _resourceCombo.destroy();
  });
  t.it('Should render list items\'s colours correctly', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var _resourceCombo2, resourceIcon, picker;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              resourceCombo = new ResourceCombo({
                showEventColor: true,
                displayField: 'name',
                store: new ResourceStore({
                  data: [{
                    name: 'No-colour resource'
                  }, {
                    name: 'Red resource',
                    eventColor: '#f00'
                  }, {
                    name: 'Blue resource',
                    eventColor: 'blue'
                  }]
                }),
                clearable: true,
                appendTo: document.body
              });
              resourceCombo.showPicker();
              _resourceCombo2 = resourceCombo, resourceIcon = _resourceCombo2.resourceIcon, picker = _resourceCombo2.picker;
              t.is(DomHelper.getStyleValue(resourceIcon, 'display'), 'none', 'resourceIcon initially hidden');
              t.is(DomHelper.getStyleValue(picker.getItem(0).firstChild, 'display'), 'none', 'First item has no icon');
              t.is(DomHelper.getStyleValue(picker.getItem(1).firstChild, 'color'), 'rgb(255, 0, 0)', 'Second item is red');
              t.notOk(picker.getItem(2).firstChild.style.color, 'Inline colour cleared when colour set by class name');
              t.hasCls(picker.getItem(2).firstChild, 'b-sch-foreground-blue', 'Third item is blue');
              t.chain({
                click: '.b-list-item[data-index="1"]'
              }, function (next) {
                t.is(DomHelper.getStyleValue(resourceIcon, 'color'), 'rgb(255, 0, 0)', 'resourceIcon is red for red item');
                resourceCombo.showPicker();
                next();
              }, {
                click: '.b-list-item[data-index="2"]'
              }, function (next) {
                t.notOk(resourceIcon.style.color, 'Inline colour cleared when colour set by class name');
                t.hasCls(resourceIcon, 'b-sch-foreground-blue', 'resourceIcon is blue for blue item');
                resourceCombo.showPicker();
                next();
              }, {
                click: '.b-list-item[data-index="0"]'
              }, function (next) {
                t.is(DomHelper.getStyleValue(resourceIcon, 'display'), 'none', 'resourceIcon hidden for no-color item');
                resourceCombo.showPicker();
                next();
              }, {
                click: '.b-list-item[data-index="2"]'
              }, function (next) {
                t.hasCls(resourceIcon, 'b-sch-foreground-blue', 'resourceIcon is blue for blue item');
                resourceCombo.showPicker();
                next();
              }, {
                click: function click() {
                  return resourceCombo.triggers.clear.element;
                }
              }, function () {
                t.is(DomHelper.getStyleValue(resourceIcon, 'display'), 'none', 'resourceIcon hidden when field cleared');
              });

            case 9:
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
  t.it('Should not be affected by XSS injection with single selection', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              resourceCombo = new ResourceCombo({
                showEventColor: true,
                items: ['First', 'Second'],
                appendTo: document.body
              });
              t.injectXSS(resourceCombo);
              resourceCombo.showPicker();
              _context2.next = 5;
              return t.click('.b-list-item[data-index="0"]');

            case 5:
              t.pass('Ok');

            case 6:
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
  t.it('Should not be affected by XSS injection with multiple selection', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              resourceCombo = new ResourceCombo({
                showEventColor: true,
                multiSelect: true,
                items: ['First', 'Second'],
                appendTo: document.body
              });
              t.injectXSS(resourceCombo);
              resourceCombo.showPicker();
              _context3.next = 5;
              return t.click('.b-list-item[data-index="1"]');

            case 5:
              _context3.next = 7;
              return t.click('.b-list-item[data-index="0"]');

            case 7:
              t.pass('Ok');

            case 8:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref3.apply(this, arguments);
    };
  }());
});