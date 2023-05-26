function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest( /*#__PURE__*/function () {
  var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
    var scheduler;
    return regeneratorRuntime.wrap(function _callee5$(_context5) {
      while (1) {
        switch (_context5.prev = _context5.next) {
          case 0:
            scheduler = bryntum.query('scheduler');
            t.beforeEach(function (t, next) {
              t.waitForSelector('.b-sch-event', function () {
                next();
              });
            });
            t.it('sanity', function (t) {
              t.checkGridSanity(scheduler);
            });
            t.it('Should generate data once only', /*#__PURE__*/function () {
              var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
                var spy;
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        scheduler.store.removeAll();
                        _context.next = 3;
                        return t.click('.b-button:contains(5K)');

                      case 3:
                        _context.next = 5;
                        return t.waitForSelector(scheduler.unreleasedEventSelector);

                      case 5:
                        scheduler.store.removeAll();
                        spy = t.spyOn(console, 'time');
                        _context.next = 9;
                        return t.click('.b-button:contains(1K)');

                      case 9:
                        _context.next = 11;
                        return t.waitForSelector(scheduler.unreleasedEventSelector);

                      case 11:
                        t.is(spy.callsLog.filter(function (call) {
                          return call.args[0] === 'generate';
                        }).length, 1, 'Data generated once');

                      case 12:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              }));

              return function (_x2) {
                return _ref2.apply(this, arguments);
              };
            }()); // https://app.assembla.com/spaces/bryntum/tickets/9112

            t.it('Should not crash for 1001 resources', /*#__PURE__*/function () {
              var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        _context2.next = 2;
                        return t.click('[data-ref=customButton]');

                      case 2:
                        t.chain({
                          click: '[data-ref=resourceCountField] input'
                        }, {
                          type: '1001[ENTER]',
                          clearExisting: true
                        }, {
                          waitFor: function waitFor() {
                            return scheduler.eventStore.count === 5005;
                          },
                          desc: 'Waiting for correct amount of events'
                        });

                      case 3:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              }));

              return function (_x3) {
                return _ref3.apply(this, arguments);
              };
            }());
            t.it('Should draw dependencies', function (t) {
              t.ok(scheduler.features.dependencies.disabled, 'Dependencies disabled');
              t.is(scheduler.dependencyStore.count, 0, 'No dependencies initially');
              t.isCalledOnce('updateProject', scheduler, 'Data generated once');
              t.chain({
                click: 'button:contains("Dependencies")'
              }, {
                waitForSelector: '.b-sch-dependency',
                desc: 'Dependency lines rendered'
              }, {
                click: 'button:contains("Dependencies")'
              }, {
                waitForSelectorNotFound: '.b-sch-dependency',
                desc: 'Dependency lines removed'
              }, {
                click: 'button:contains("Dependencies")'
              }, {
                waitForSelector: '.b-sch-dependency',
                desc: 'Dependency lines back'
              });
            });
            t.it('Should not crash for 10 resources', function (t) {
              t.chain({
                click: '[data-ref=resourceCountField] input'
              }, {
                type: '10[ENTER]',
                clearExisting: true
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        return _context3.abrupt("return", new Promise(function (resolve) {
                          scheduler.on({
                            projectChange: function projectChange(_ref5) {
                              var project = _ref5.project;
                              // Test should not throw before dataReady is fired
                              project.await('dataReady', false).then(function () {
                                return resolve();
                              });
                            }
                          });
                        }));

                      case 1:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3);
              })));
            }); // https://github.com/bryntum/support/issues/1487

            t.it('Should not leave old lines when replacing project', /*#__PURE__*/function () {
              var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
                return regeneratorRuntime.wrap(function _callee4$(_context4) {
                  while (1) {
                    switch (_context4.prev = _context4.next) {
                      case 0:
                        scheduler.features.dependencies.disabled = false;
                        scheduler.generateResources(10);
                        _context4.next = 4;
                        return scheduler.await('dependenciesDrawn', false);

                      case 4:
                        scheduler.generateResources(5);
                        _context4.next = 7;
                        return scheduler.await('dependenciesDrawn', false);

                      case 7:
                        t.selectorNotExists('polyline[depId="21"]', 'Old dependency not drawn');

                      case 8:
                      case "end":
                        return _context4.stop();
                    }
                  }
                }, _callee4);
              }));

              return function (_x4) {
                return _ref6.apply(this, arguments);
              };
            }());

          case 8:
          case "end":
            return _context5.stop();
        }
      }
    }, _callee5);
  }));

  return function (_x) {
    return _ref.apply(this, arguments);
  };
}());