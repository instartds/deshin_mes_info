function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });
  t.mockUrl('loadurl', {
    delay: 100,
    responseText: JSON.stringify({
      success: true,
      resources: {
        rows: [{
          id: 'a'
        }]
      },
      events: {
        rows: [{
          id: 1,
          resourceId: 'a',
          startDate: '2018-02-01',
          endDate: '2018-03-01'
        }]
      }
    })
  });
  t.mockUrl('syncurl', {
    delay: 10,
    responseText: JSON.stringify({
      success: true,
      events: {
        rows: [{
          id: 11
        }]
      }
    })
  });
  t.mockUrl('syncfail', {
    delay: 10,
    responseText: JSON.stringify({
      success: false,
      message: 'failure'
    })
  });
  t.mockUrl('loadrejected', {
    responseText: JSON.stringify({
      success: true
    }),
    delay: 10,
    rejectPromise: true
  }); // https://github.com/bryntum/support/issues/314

  t.it('Mask should show error message and hide after a delay if response is unsuccessful', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                startDate: new Date(2018, 0, 30),
                endDate: new Date(2018, 2, 2),
                crudManager: {
                  autoLoad: false,
                  transport: {
                    sync: {
                      url: 'syncfail'
                    },
                    load: {
                      url: 'loadurl'
                    }
                  }
                }
              });
              _context.next = 3;
              return scheduler.crudManager.load().catch(function () {
                return t.fail('should not fail');
              });

            case 3:
              _context.next = 5;
              return t.waitForProjectReady(scheduler);

            case 5:
              scheduler.resourceStore.first.name = 'foo';
              _context.next = 8;
              return scheduler.crudManager.sync().catch(function () {
                return t.pass('expected fail');
              });

            case 8:
              t.chain({
                waitForSelector: '.b-mask .b-grid-load-failure',
                desc: 'Error message appeared'
              }, {
                waitForSelectorNotFound: '.b-mask',
                desc: 'Sync mask disappeared'
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
  }()); // https://github.com/bryntum/support/issues/553

  t.it('Mask should show error message and hide after a delay if fetch() fails and rejects promise with an Error', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      startDate: new Date(2018, 0, 30),
      endDate: new Date(2018, 2, 2),
      crudManager: {
        autoLoad: false,
        transport: {
          sync: {
            url: 'syncurl'
          },
          load: {
            url: 'loadrejected'
          }
        }
      }
    });
    t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.prev = 0;
              _context2.next = 3;
              return scheduler.crudManager.load();

            case 3:
              t.fail('load did not fail');
              _context2.next = 9;
              break;

            case 6:
              _context2.prev = 6;
              _context2.t0 = _context2["catch"](0);
              t.pass('load failed as expected');

            case 9:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2, null, [[0, 6]]);
    })), {
      waitForSelector: '.b-mask .b-grid-load-failure',
      desc: 'Error message appeared'
    }, {
      waitForSelectorNotFound: '.b-mask',
      desc: 'Sync mask disappeared'
    });
  });
  t.it('loadMask is shown when loading is triggered on scheduler construction', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              t.chain({
                waitForSelector: '.b-mask-content:contains(Loading)',
                desc: 'loadMask showed up',
                trigger: function trigger() {
                  scheduler = new Scheduler({
                    appendTo: document.body,
                    startDate: new Date(2018, 0, 30),
                    endDate: new Date(2018, 2, 2),
                    crudManager: {
                      autoLoad: true,
                      transport: {
                        load: {
                          url: 'loadurl'
                        }
                      }
                    },
                    loadMaskDefaults: {
                      showDelay: 0
                    }
                  });
                }
              }, {
                waitForSelectorNotFound: '.b-mask-content:contains(Loading)',
                desc: 'loadMask disappeared'
              });

            case 1:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x2) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('loadMask is shown when loading is triggered after scheduler construction', function (t) {
    var async = t.beginAsync();
    scheduler = new Scheduler({
      appendTo: document.body,
      startDate: new Date(2018, 0, 30),
      endDate: new Date(2018, 2, 2),
      crudManager: {
        autoLoad: false,
        transport: {
          sync: {
            url: 'syncurl'
          },
          load: {
            url: 'loadurl'
          }
        }
      }
    });
    scheduler.crudManager.load();
    t.chain({
      waitForSelector: '.b-mask-content:contains(Loading)',
      desc: 'loadMask showed up'
    }, {
      waitForSelectorNotFound: '.b-mask-content:contains(Loading)',
      desc: 'loadMask disappeared'
    }, function () {
      return t.endAsync(async);
    });
  });
  t.it('syncMask is shown when loading is triggered after scheduler construction', function (t) {
    var async = t.beginAsync();
    t.mockUrl('loadurl', {
      delay: 10,
      responseText: JSON.stringify({
        success: true,
        resources: {
          rows: [{
            id: 'a'
          }]
        },
        events: {
          rows: [{
            id: 1,
            resourceId: 'a',
            startDate: '2018-02-01',
            endDate: '2018-03-01'
          }]
        }
      })
    });
    t.mockUrl('syncurl', {
      delay: 2000,
      responseText: JSON.stringify({
        success: true,
        events: {
          rows: [{
            id: 11
          }]
        }
      })
    });
    scheduler = new Scheduler({
      appendTo: document.body,
      startDate: new Date(2018, 0, 30),
      endDate: new Date(2018, 2, 2),
      crudManager: {
        autoLoad: false,
        transport: {
          sync: {
            url: 'syncurl'
          },
          load: {
            url: 'loadurl'
          }
        }
      }
    });
    t.chain(function () {
      return scheduler.crudManager.load();
    }, {
      waitForProjectReady: scheduler
    }, function (next) {
      scheduler.resourceStore.first.name = 'foo';
      scheduler.crudManager.sync();
      next();
    }, {
      waitForSelector: '.b-mask-content:contains(Saving)',
      desc: 'syncMask showed up'
    }, {
      waitForSelectorNotFound: '.b-mask-content:contains(Saving)',
      desc: 'syncMask disappeared'
    }, function () {
      return t.endAsync(async);
    });
  });
  t.it('loadMask and syncMask are shown when showDelay is specified', function (t) {
    var async = t.beginAsync();
    t.mockUrl('loadurl', {
      delay: 2000,
      responseText: JSON.stringify({
        success: true,
        resources: {
          rows: [{
            id: 'a'
          }]
        },
        events: {
          rows: [{
            id: 1,
            resourceId: 'a',
            startDate: '2018-02-01',
            endDate: '2018-03-01'
          }]
        }
      })
    });
    t.mockUrl('syncurl', {
      delay: 2000,
      responseText: JSON.stringify({
        success: true,
        events: {
          rows: [{
            id: 11
          }]
        }
      })
    });
    scheduler = new Scheduler({
      appendTo: document.body,
      startDate: new Date(2018, 0, 30),
      endDate: new Date(2018, 2, 2),
      crudManager: {
        autoLoad: false,
        autoSync: false,
        transport: {
          sync: {
            url: 'syncurl'
          },
          load: {
            url: 'loadurl'
          }
        }
      },
      loadMask: {
        showDelay: 100
      },
      syncMask: {
        showDelay: 100
      }
    });
    t.chain(function (next) {
      scheduler.crudManager.load();
      next();
    }, {
      waitForSelector: '.b-mask-content:contains(Loading)',
      desc: 'loadMask showed up'
    }, {
      waitForSelectorNotFound: '.b-mask-content:contains(Loading)',
      desc: 'loadMask disappeared'
    }, {
      waitForProjectReady: scheduler
    }, function (next) {
      scheduler.resourceStore.first.name = 'foo';
      scheduler.crudManager.sync();
      next();
    }, {
      waitForSelector: '.b-mask-content:contains(Saving)',
      desc: 'syncMask showed up'
    }, {
      waitForSelectorNotFound: '.b-mask-content:contains(Saving)',
      desc: 'syncMask disappeared'
    }, function () {
      return t.endAsync(async);
    });
  });
  t.it('Should hide "No records to display" when loading and show when loaded empty data', function (t) {
    var async = t.beginAsync();
    t.mockUrl('loadurl', {
      delay: 10,
      responseText: JSON.stringify({
        success: true,
        resources: {
          rows: []
        },
        events: {
          rows: []
        }
      })
    });
    scheduler = new Scheduler({
      appendTo: document.body,
      startDate: new Date(2018, 0, 30),
      endDate: new Date(2018, 2, 2),
      crudManager: {
        autoLoad: false,
        transport: {
          load: {
            url: 'loadurl'
          },
          sync: {
            url: 'syncurl'
          }
        }
      }
    });
    t.selectorExists('.b-grid-empty', 'Scheduler has the b-grid-empty class before load');
    scheduler.crudManager.load().catch(function () {
      return t.fail('should not fail');
    }).then(function () {
      return t.pass('crud manager got loaded');
    });
    t.chain({
      waitForSelector: '.b-mask-content:contains(Loading)',
      desc: 'loadMask showed up'
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4() {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              return _context4.abrupt("return", t.selectorNotExists('.b-grid-empty', 'Scheduler has no b-grid-empty class when loading'));

            case 1:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    })), {
      waitForSelectorNotFound: '.b-mask-content:contains(Loading)',
      desc: 'loadMask is hidden'
    }, {
      waitForSelector: '.b-grid-empty',
      desc: 'Scheduler has b-grid-empty after loaded empty rows'
    }, function () {
      return t.endAsync(async);
    });
  });
});