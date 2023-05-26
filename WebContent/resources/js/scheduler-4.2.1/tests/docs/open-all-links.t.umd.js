function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

/*global DocsBrowserInstance*/

/*eslint no-undef: "error"*/
describe('Open all links in docs tree and assert correct content + no crashes', /*#__PURE__*/function () {
  var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
    var classRecord, _DocsBrowserInstance, navigationTree, _t$getConfig, _t$getConfig$ignoreTo, ignoreTopics, docsTitle, records;

    return regeneratorRuntime.wrap(function _callee3$(_context3) {
      while (1) {
        switch (_context3.prev = _context3.next) {
          case 0:
            _DocsBrowserInstance = DocsBrowserInstance, navigationTree = _DocsBrowserInstance.navigationTree, _t$getConfig = t.getConfig(), _t$getConfig$ignoreTo = _t$getConfig.ignoreTopics, ignoreTopics = _t$getConfig$ignoreTo === void 0 ? [] : _t$getConfig$ignoreTo, docsTitle = _t$getConfig.docsTitle, records = [];
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

                        location.hash = classRecord.href || classRecord.fullName;
                        t.suppressPassedWaitForAssertion = true;
                        _context.next = 6;
                        return t.waitForSelector("#content h1:contains(".concat(classRecord.readableName, ")"));

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
            return t.waitForSelector("#content h1:textEquals(".concat(docsTitle, ")"));

          case 7:
            _context3.next = 9;
            return t.waitForSelectorNotFound('.loading');

          case 9:
            navigationTree.store.traverse(function (classRec) {
              if ((!classRec.children || !classRec.children.length) && !ignoreTopics.includes(classRec.get('id')) && !classRec.isGuide && classRec.id !== 'apidiff') {
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
            t.it('Should not see any global members, only classes', function (t) {
              for (var p in t.global.docsJson) {
                if (p !== 'classes') {
                  t.fail(t.global.docsJson[p].map(function (o) {
                    return o.name;
                  }).join(', '), 'Should not find any top level members');
                }
              }
            });

          case 11:
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