function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

/*global DocsBrowserInstance*/
StartTest(function (t) {
  t.it('Open all links in guides and assert correct content + no crashes', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var classRecord, _DocsBrowserInstance, navigationTree, records;

      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _DocsBrowserInstance = DocsBrowserInstance, navigationTree = _DocsBrowserInstance.navigationTree, records = [];
              DocsBrowserInstance.animateScroll = false;
              t.beforeEach( /*#__PURE__*/function () {
                var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t, cb) {
                  return regeneratorRuntime.wrap(function _callee$(_context) {
                    while (1) {
                      switch (_context.prev = _context.next) {
                        case 0:
                          classRecord = records.shift();

                          if (!classRecord) {
                            _context.next = 8;
                            break;
                          }

                          // Wipe out the old title to be able to query for page loaded
                          t.global.location.hash = classRecord.fullName;
                          t.suppressPassedWaitForAssertion = true;
                          _context.next = 6;
                          return t.waitForSelector("#content[data-id=\"".concat(classRecord.id, "\"]"));

                        case 6:
                          _context.next = 8;
                          return t.waitForSelectorNotFound('.b-mask:contains(Loading),.fiddlePanelResult:empty,[data-error]');

                        case 8:
                          cb();

                        case 9:
                        case "end":
                          return _context.stop();
                      }
                    }
                  }, _callee);
                }));

                return function (_x2, _x3) {
                  return _ref2.apply(this, arguments);
                };
              }());
              DocsBrowserInstance.onSettingsChange({
                settings: {
                  showPublic: true,
                  showInternal: true,
                  showPrivate: true,
                  showInherited: true
                }
              });
              navigationTree.expandAll();
              _context3.next = 7;
              return t.waitForSelectorNotFound('.loading');

            case 7:
              navigationTree.store.traverse(function (classRec) {
                if (classRec.isLeaf && classRec.isGuide) {
                  records.push(classRec);
                  t.it("Checking ".concat(classRec.id), /*#__PURE__*/function () {
                    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
                      return regeneratorRuntime.wrap(function _callee2$(_context2) {
                        while (1) {
                          switch (_context2.prev = _context2.next) {
                            case 0:
                              _context2.next = 2;
                              return t.assertDocsLinks(classRecord);

                            case 2:
                              return _context2.abrupt("return", _context2.sent);

                            case 3:
                            case "end":
                              return _context2.stop();
                          }
                        }
                      }, _callee2);
                    }));

                    return function (_x4) {
                      return _ref3.apply(this, arguments);
                    };
                  }());
                }
              });

            case 8:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Verify upgrade guide link', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.click('[href="#upgrade-guide"]');

            case 2:
              t.ok(/guides\/upgrades\/[\d.]+\.md/.test(t.global.location.hash));
              t.pass('Navigation is ok');

            case 4:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x5) {
      return _ref4.apply(this, arguments);
    };
  }());
});