function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var resources = [{
    id: 1,
    name: 'Arcady'
  }],
      timeAxisSpy = t.spyOn(TimeAxis.prototype, 'construct').callThrough(),
      timeAxisVMSpy = t.spyOn(TimeAxisViewModel.prototype, 'construct').callThrough();
  var firstScheduler, secondScheduler, thirdScheduler;

  function setup() {
    return _setup.apply(this, arguments);
  }

  function _setup() {
    _setup = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11() {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              timeAxisSpy.reset();
              timeAxisVMSpy.reset();
              _context11.next = 4;
              return t.getSchedulerAsync({
                id: 'top-scheduler',
                appendTo: document.body,
                height: 200,
                columns: [{
                  text: 'Staff',
                  width: '10em',
                  field: 'name'
                }],
                resources: resources,
                startDate: new Date(2018, 0, 1, 6),
                endDate: new Date(2018, 0, 1, 20),
                viewPreset: 'minuteAndHour',
                style: 'margin-bottom:20px'
              });

            case 4:
              firstScheduler = _context11.sent;
              secondScheduler = new Scheduler({
                id: 'bottom-scheduler',
                appendTo: document.body,
                height: 200,
                partner: firstScheduler,
                hideHeaders: true,
                columns: [{
                  text: 'Staff',
                  width: '10em',
                  field: 'name'
                }],
                resourceStore: firstScheduler.resourceStore
              }); // Wait for resize listeners which happen on layout

              _context11.next = 8;
              return t.waitForAnimationFrame();

            case 8:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));
    return _setup.apply(this, arguments);
  }

  t.beforeEach(function () {
    firstScheduler && !firstScheduler.isDestroyed && firstScheduler.destroy();
    secondScheduler && !secondScheduler.isDestroyed && secondScheduler.destroy();
    thirdScheduler && !thirdScheduler.isDestroyed && thirdScheduler.destroy();
  });
  t.it('Scroll should be synced', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return setup();

            case 2:
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        firstScheduler.subGrids.normal.scrollable.x = 100;
                        _context.next = 3;
                        return secondScheduler.subGrids.normal.scrollable.await('scrollEnd', {
                          checkLog: false
                        });

                      case 3:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })), {
                waitFor: function waitFor() {
                  return t.samePx(secondScheduler.subGrids.normal.scrollable.x, 100);
                },
                desc: 'Bottom partner scroll is ok'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
                return regeneratorRuntime.wrap(function _callee2$(_context2) {
                  while (1) {
                    switch (_context2.prev = _context2.next) {
                      case 0:
                        secondScheduler.subGrids.normal.scrollable.x = 50;
                        _context2.next = 3;
                        return firstScheduler.subGrids.normal.header.scrollable.await('scrollEnd', {
                          checkLog: false
                        });

                      case 3:
                      case "end":
                        return _context2.stop();
                    }
                  }
                }, _callee2);
              })), {
                waitFor: function waitFor() {
                  return t.samePx(firstScheduler.subGrids.normal.scrollable.x, 50);
                },
                desc: 'Top partner scroll is ok'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3() {
                return regeneratorRuntime.wrap(function _callee3$(_context3) {
                  while (1) {
                    switch (_context3.prev = _context3.next) {
                      case 0:
                        // Should be able to destroy a partner with no errors
                        secondScheduler.destroy();
                        firstScheduler.subGrids.normal.scrollable.x = 100; // Wait for the scroll event to fire. Nothing should happen
                        // if the link has been broken property upon destruction

                        _context3.next = 4;
                        return firstScheduler.subGrids.normal.scrollable.await('scroll', {
                          checkLog: false
                        });

                      case 4:
                      case "end":
                        return _context3.stop();
                    }
                  }
                }, _callee3);
              })));

            case 3:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Width + collapsed state should be synced', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return setup();

            case 2:
              t.chain(function (next) {
                // All these events must occur before we can proceed to the next phase of the test
                t.waitForGridEvents([[firstScheduler.subGrids.locked, 'resize'], [firstScheduler.subGrids.normal, 'resize'], [secondScheduler.subGrids.locked, 'resize'], [secondScheduler.subGrids.normal, 'resize']], next);
                firstScheduler.subGrids.locked.width += 20;
              }, function (next) {
                t.is(secondScheduler.subGrids.locked.width, firstScheduler.subGrids.locked.width, 'Width sync #1'); // All these events must occur before we can proceed to the next phase of the test

                t.waitForGridEvents([[firstScheduler.subGrids.locked, 'resize'], [firstScheduler.subGrids.normal, 'resize'], [secondScheduler.subGrids.locked, 'resize'], [secondScheduler.subGrids.normal, 'resize']], next);
                secondScheduler.subGrids.locked.width += 20;
              }, function (next) {
                t.is(secondScheduler.subGrids.locked.width, firstScheduler.subGrids.locked.width, 'Width sync #2'); // All these events must occur before we can proceed to the next phase of the test

                t.waitForGridEvents([[firstScheduler.subGrids.locked, 'resize'], [firstScheduler.subGrids.normal, 'resize'], [secondScheduler.subGrids.locked, 'resize'], [secondScheduler.subGrids.normal, 'resize']], next);
                secondScheduler.subGrids.locked.collapse();
              }, // Check that collapse has happened in both grids.
              // Then check that we can destroy a partner with no errors
              function () {
                t.is(secondScheduler.subGrids.locked.collapsed, firstScheduler.subGrids.locked.collapsed, 'Collapse sync');
                t.ok(firstScheduler.subGrids.locked.collapsed, 'Top scheduler has collapsed the locked part');
                t.ok(secondScheduler.subGrids.locked.collapsed, 'Bottom scheduler has collapsed the locked part in synchrony'); // Should be able to destroy a partner with no errors

                secondScheduler.destroy();
              });

            case 3:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x2) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('Should support changing partnerships at runtime', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return setup();

            case 2:
              t.ok(firstScheduler.isPartneredWith(secondScheduler), 'Partnered');
              t.ok(secondScheduler.isPartneredWith(firstScheduler), 'Partnered');
              firstScheduler.removePartner(secondScheduler);
              t.notOk(firstScheduler.isPartneredWith(secondScheduler), 'Not Partnered');
              t.notOk(secondScheduler.isPartneredWith(firstScheduler), 'Not Partnered');
              firstScheduler.subGrids.normal.scrollable.x += 100; // wait some small amount to ensure no scrolling happens

              _context6.next = 10;
              return t.waitFor(100);

            case 10:
              t.is(secondScheduler.subGrids.normal.scrollable.x, 0, 'Bottom scroll not affected');
              firstScheduler.addPartner(secondScheduler);
              _context6.next = 14;
              return t.waitFor(function () {
                return secondScheduler.subGrids.normal.scrollable.x === 100;
              });

            case 14:
              t.ok(firstScheduler.isPartneredWith(secondScheduler), 'Partnered');
              t.ok(secondScheduler.isPartneredWith(firstScheduler), 'Partnered');
              t.pass('Re-partnered, scroll is synced');
              firstScheduler.removePartner(secondScheduler); // Now let's pair second to another scheduler

              thirdScheduler = new Scheduler({
                id: 'thirdScheduler',
                appendTo: document.body,
                height: 200,
                hideHeaders: true,
                columns: [{
                  text: 'Staff',
                  width: '10em',
                  field: 'name'
                }],
                resources: [{
                  name: 'Bengt'
                }]
              });
              thirdScheduler.addPartner(secondScheduler);
              t.notOk(firstScheduler.isPartneredWith(secondScheduler), '1st not partnered with 2nd');
              t.ok(thirdScheduler.isPartneredWith(secondScheduler), '3rd partnered with 2nd');
              secondScheduler.subGrids.normal.scrollable.x = 200;
              _context6.next = 25;
              return t.waitFor(function () {
                return thirdScheduler.subGrids.normal.scrollable.x === 200;
              });

            case 25:
              t.is(firstScheduler.subGrids.normal.scrollable.x, 100, 'First scheduler did not react');

            case 26:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x3) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Should sync all state after zoom', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var assertViewPresets;
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              assertViewPresets = function _assertViewPresets() {
                // Delete reference to scheduler from event to avoid traversing every property of scheduler
                delete firstScheduler.viewPreset.options.event.source;
                delete secondScheduler.viewPreset.options.event.source;
                t.is(firstScheduler.viewPreset, secondScheduler.viewPreset);
                t.is(firstScheduler.startDate, secondScheduler.startDate);
                t.is(firstScheduler.endDate, secondScheduler.endDate); // not using t.is here, because in IE11 it will start traversing every property and eventually result in error

                t.ok(firstScheduler.timeAxisViewModel === secondScheduler.timeAxisViewModel);
              };

              _context9.next = 3;
              return setup();

            case 3:
              assertViewPresets();
              t.is(firstScheduler.subGrids.normal.scrollable.x, secondScheduler.subGrids.normal.scrollable.x);
              t.chain( /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                return regeneratorRuntime.wrap(function _callee7$(_context7) {
                  while (1) {
                    switch (_context7.prev = _context7.next) {
                      case 0:
                        firstScheduler.zoomOut();
                        assertViewPresets();

                      case 2:
                      case "end":
                        return _context7.stop();
                    }
                  }
                }, _callee7);
              })), {
                waitFor: function waitFor() {
                  return firstScheduler.subGrids.normal.scrollable.x = secondScheduler.subGrids.normal.scrollable.x;
                }
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8() {
                return regeneratorRuntime.wrap(function _callee8$(_context8) {
                  while (1) {
                    switch (_context8.prev = _context8.next) {
                      case 0:
                        secondScheduler.zoomIn();
                        assertViewPresets();

                      case 2:
                      case "end":
                        return _context8.stop();
                    }
                  }
                }, _callee8);
              })), {
                waitFor: function waitFor() {
                  return firstScheduler.subGrids.normal.scrollable.x = secondScheduler.subGrids.normal.scrollable.x;
                }
              }, function () {
                t.expect(timeAxisSpy).toHaveBeenCalled(1);
                t.expect(timeAxisVMSpy).toHaveBeenCalled(1);
              });

            case 6:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x4) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Should properly update timeAxisViewModel when adding partner at runtime', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var config;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              config = {
                appendTo: document.body,
                height: 200,
                columns: [{
                  text: 'Staff',
                  width: '10em',
                  field: 'name'
                }],
                resources: resources,
                startDate: new Date(2018, 0, 1, 6),
                endDate: new Date(2018, 0, 1, 20),
                viewPreset: 'minuteAndHour',
                style: 'margin-bottom:20px'
              };
              firstScheduler = new Scheduler(Object.assign({
                id: 'firstScheduler'
              }, config));
              secondScheduler = new Scheduler(Object.assign({
                id: 'secondScheduler'
              }, config));
              secondScheduler.partner = firstScheduler;
              _context10.next = 6;
              return t.click('#secondScheduler .b-sch-header-timeaxis-cell');

            case 6:
              firstScheduler.zoomOut();
              t.is(secondScheduler.timeAxisColumn.width, firstScheduler.timeAxisColumn.width, 'Time axis column width is ok');

            case 8:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x5) {
      return _ref10.apply(this, arguments);
    };
  }());
});