function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var cmp;

  var createScheduler = function createScheduler() {
    document.body.innerHTML += "\n            <bryntum-scheduler \n                stylesheet=\"../build/scheduler.stockholm.css\"\n                data-view-preset=\"weekAndDay\"\n                data-start-date=\"2018-04-02\"\n                data-end-date=\"2018-04-09\"\n            >\n                    <column data-field=\"name\">Name</column>\n                    <data>\n                        <events>\n                            <data data-id=\"1\" data-name=\"Click me\" data-icon-cls=\"b-fa b-fa-mouse-pointer\" data-resource-id=\"1\" data-start-date=\"2018-04-03\" data-end-date=\"2018-04-05\"></data>\n                            <data data-id=\"2\" data-name=\"Drag me\" data-icon-cls=\"b-fa b-fa-arrows-alt\" data-resource-id=\"2\" data-start-date=\"2018-04-04\" data-end-date=\"2018-04-06\"></data>\n                            <data data-id=\"3\" data-name=\"Resize me\" data-icon-cls=\"b-fa b-fa-arrows-alt-h\" data-resource-id=\"3\" data-start-date=\"2018-04-05\" data-end-date=\"2018-04-07\"></data>\n                        </events>\n                        <resources>\n                            <data data-id=\"1\" data-name=\"Daniel\"></data>\n                            <data data-id=\"2\" data-name=\"Steven\"></data>\n                            <data data-id=\"3\" data-name=\"Sergei\"></data>\n                        </resources>\n                    </data>\n            </bryntum-scheduler>";
  };

  t.beforeEach(function (t) {
    cmp && cmp.remove();
    document.body.style = 'height:100%;width:100%;overflow:hidden;';
    document.body.innerHTML = '';
  });
  t.it('Should finalize drag drop if mouse up happens outside shadow root', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              createScheduler();
              cmp = document.querySelector('bryntum-scheduler');
              document.body.style.padding = '10em';
              _context.next = 5;
              return t.dragBy('bryntum-scheduler -> .b-sch-event', [-20, 0], null, null, null, true);

            case 5:
              _context.next = 7;
              return t.moveCursorTo([1, 1]);

            case 7:
              _context.next = 9;
              return t.mouseUp();

            case 9:
              t.selectorNotExists('.b-draghelper-active');
              t.selectorNotExists('bryntum-scheduler -> .b-draghelper-active');

            case 11:
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
  t.it('Should show event editor in ShadowRoot´s float root', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              createScheduler();
              cmp = document.querySelector('bryntum-scheduler');
              _context2.next = 4;
              return t.doubleClick('bryntum-scheduler -> .b-sch-event');

            case 4:
              _context2.next = 6;
              return t.waitForSelector('bryntum-scheduler -> .b-float-root .b-eventeditor');

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
  t.it('Should show event tooltip in ShadowRoot´s float root', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              createScheduler();
              cmp = document.querySelector('bryntum-scheduler');
              _context3.next = 4;
              return t.moveCursorTo([0, 0]);

            case 4:
              _context3.next = 6;
              return t.moveCursorTo('bryntum-scheduler -> .b-sch-event');

            case 6:
              _context3.next = 8;
              return t.waitForSelector('bryntum-scheduler -> .b-float-root .b-tooltip');

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
  t.it('Should handle multiple scheduler web components', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              createScheduler();
              document.querySelector('bryntum-scheduler').style.cssText = 'display:block;height:200px;width:400px';
              createScheduler();
              document.querySelector('bryntum-scheduler:last-child').style.cssText = 'display:block;height:200px;width:400px';
              _context4.next = 6;
              return t.doubleClick('bryntum-scheduler -> .b-sch-event');

            case 6:
              _context4.next = 8;
              return t.click('bryntum-scheduler -> .b-button:textEquals(Save)');

            case 8:
              _context4.next = 10;
              return t.doubleClick('bryntum-scheduler:last-child -> .b-sch-event');

            case 10:
              _context4.next = 12;
              return t.click('bryntum-scheduler:last-child -> .b-button:textEquals(Save)');

            case 12:
              t.pass('No crash due to hard coded id´s used');

            case 13:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should show event editor fully, overflowing shadow root, when web component is small', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              createScheduler();
              cmp = document.querySelector('bryntum-scheduler');
              cmp.style.cssText = 'display:block;height:200px;width:400px';
              _context5.next = 5;
              return t.doubleClick('bryntum-scheduler -> .b-sch-event');

            case 5:
              _context5.next = 7;
              return t.waitForSelector('bryntum-scheduler -> .b-float-root .b-eventeditor');

            case 7:
              _context5.next = 9;
              return t.click('bryntum-scheduler -> .b-button:textEquals(Save)');

            case 9:
              _context5.next = 11;
              return t.waitForSelectorNotFound('bryntum-scheduler -> .b-float-root .b-eventeditor');

            case 11:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x5) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should stop dependency creation when dropping outside of web component', function (t) {
    document.body.style = '';
    document.body.innerHTML = "\n        <div id=\"container\" style=\"width: 600px; height:400px;\">\n            <bryntum-scheduler\n                    stylesheet=\"../build/scheduler.stockholm.css\"\n                    fa-path=\"../build/fonts\"\n                    data-min-height=\"20em\"\n                    data-view-preset=\"weekAndDay\"\n                    data-start-date=\"2018-04-02\"\n                    data-end-date=\"2018-04-09\">\n                <column data-field=\"name\">Name</column>\n                <feature data-name=\"dependencies\"></feature>\n                <data>\n                    <events>\n                        <data data-id=\"1\" data-name=\"Click me\" data-icon-cls=\"b-fa b-fa-mouse-pointer\" data-resource-id=\"1\" data-start-date=\"2018-04-03\" data-end-date=\"2018-04-05\"></data>\n                        <data data-id=\"2\" data-name=\"Drag me\" data-icon-cls=\"b-fa b-fa-arrows-alt\" data-resource-id=\"2\" data-start-date=\"2018-04-04\" data-end-date=\"2018-04-06\"></data>\n                        <data data-id=\"3\" data-name=\"Resize me\" data-icon-cls=\"b-fa b-fa-arrows-alt-h\" data-resource-id=\"3\" data-start-date=\"2018-04-05\" data-end-date=\"2018-04-07\"></data>\n                    </events>\n                    <resources>\n                        <data data-id=\"1\" data-name=\"Daniel\"></data>\n                        <data data-id=\"2\" data-name=\"Steven\"></data>\n                        <data data-id=\"3\" data-name=\"Sergei\"></data>\n                    </resources>\n                </data>\n            </bryntum-scheduler>\n        </div>";
    t.chain( // Regular dependency dragdrop works fine
    {
      moveMouseTo: 'bryntum-scheduler -> .b-sch-event'
    }, {
      drag: 'bryntum-scheduler -> .b-sch-event .b-sch-terminal-left',
      to: 'bryntum-scheduler -> [data-event-id="2"]',
      dragOnly: true
    }, {
      mouseUp: 'bryntum-scheduler -> [data-event-id="2"] .b-sch-terminal-left'
    }, {
      waitForSelectorNotFound: 'bryntum-scheduler -> .b-sch-dependency-connector'
    }, // Dropping dependency line outside of webcomponent works too
    {
      moveMouseTo: 'bryntum-scheduler -> .b-sch-event'
    }, {
      drag: 'bryntum-scheduler -> .b-sch-event .b-sch-terminal-bottom',
      to: 'bryntum-scheduler -> [data-event-id="2"]',
      dragOnly: true
    }, {
      mouseUp: '#container',
      offset: ['100%', '100%+50']
    }, {
      waitForSelectorNotFound: 'bryntum-scheduler -> .b-sch-dependency-connector'
    });
  });
});