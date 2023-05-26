function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && !scheduler.isDestroyed && scheduler.destroy(); // After scheduler destroy, all menuitems must also have been destroyed

    if (bryntum.queryAll('menuitem').length > 0) {
      t.is(bryntum.queryAll('menuitem').length, 0, 'Menu items all destroyed');
    }
  });
  Object.assign(window, {
    TimeAxisColumn: TimeAxisColumn
  });

  function getScheduler(_x) {
    return _getScheduler.apply(this, arguments);
  }

  function _getScheduler() {
    _getScheduler = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(config) {
      var scheduler;
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return t.getSchedulerAsync(config);

            case 2:
              scheduler = _context17.sent;
              return _context17.abrupt("return", scheduler);

            case 4:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));
    return _getScheduler.apply(this, arguments);
  }

  var spy = t.spyOn(VersionHelper, 'deprecate').and.callFake(function () {});
  t.it('LEGACY: Add event should work with EventEdit', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              spy.reset();
              _context.next = 3;
              return getScheduler({
                viewPreset: 'dayAndWeek',
                features: {
                  scheduleContextMenu: true,
                  eventMenu: true,
                  eventEdit: true
                }
              }, 1);

            case 3:
              scheduler = _context.sent;
              t.chain({
                rightClick: '.b-sch-timeaxis-cell',
                offset: [100, 60]
              }, {
                click: '.b-menu:textEquals(Add event)'
              }, {
                waitFor: function waitFor() {
                  return scheduler.features.eventEdit.editor.containsFocus;
                }
              }, {
                type: 'New test event'
              }, {
                click: 'button:textEquals(Save)'
              }, {
                waitForSelector: '.b-sch-dirty-new',
                desc: 'New event rendered'
              }, function () {
                t.is(scheduler.eventStore.last.startDate, new Date(2011, 0, 4), 'Start date correct');
                t.expect(spy).toHaveBeenCalled(1);
                t.expect(spy).toHaveBeenCalledWith('Scheduler', '5.0.0', '`ScheduleContextMenu` feature is deprecated, in favor of `ScheduleMenu` feature. Please see https://bryntum.com/docs/scheduler/#Scheduler/guides/upgrades/3.1.0.md for more information.');
              });

            case 5:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x2) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('LEGACY: Should disable Add event if no resources exist', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              if (!BrowserHelper.isIE11) {
                _context2.next = 2;
                break;
              }

              return _context2.abrupt("return");

            case 2:
              _context2.next = 4;
              return getScheduler({
                features: {
                  scheduleContextMenu: true
                },
                resources: []
              }, 0);

            case 4:
              scheduler = _context2.sent;
              t.chain({
                rightClick: '.b-grid-subgrid-normal',
                offset: [2, 2]
              }, {
                waitForSelector: '.b-menuitem.b-disabled:textEquals(Add event)'
              });

            case 6:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x3) {
      return _ref2.apply(this, arguments);
    };
  }());
  t.it('LEGACY: Add event should work with dependencyEdit disabled', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return getScheduler({
                viewPreset: 'dayAndWeek',
                features: {
                  scheduleContextMenu: true,
                  eventMenu: true,
                  eventEdit: true,
                  dependencies: {
                    disabled: false
                  },
                  dependencyEdit: {
                    disabled: true
                  }
                }
              }, 1);

            case 2:
              scheduler = _context3.sent;
              t.chain({
                rightClick: '.b-sch-timeaxis-cell',
                offset: [100, 60]
              }, {
                click: '.b-menu:textEquals(Add event)'
              }, {
                waitFor: function waitFor() {
                  return scheduler.features.eventEdit.editor.containsFocus;
                }
              }, {
                type: 'New test event'
              }, {
                click: 'button:textEquals(Save)'
              }, {
                waitForSelector: '.b-sch-dirty-new',
                desc: 'New event rendered'
              }, function () {
                t.is(scheduler.eventStore.last.startDate, new Date(2011, 0, 4), 'Start date correct');
              });

            case 4:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x4) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('LEGACY: Add event should work without EventEdit', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return getScheduler({
                viewPreset: 'dayAndWeek',
                features: {
                  scheduleContextMenu: true,
                  eventMenu: true,
                  eventEdit: false
                }
              }, 1);

            case 2:
              scheduler = _context4.sent;
              t.chain({
                rightClick: '.b-sch-timeaxis-cell',
                offset: [100, 60]
              }, {
                click: '.b-menu:textEquals(Add event)'
              }, {
                waitForSelector: '.b-sch-dirty-new',
                desc: 'New event rendered'
              }, function () {
                t.is(scheduler.eventStore.last.startDate, new Date(2011, 0, 4), 'Start date correct');
              });

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
  t.it('LEGACY: Should be able to add extra items to the menu', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var clicked;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              clicked = false;
              _context5.next = 3;
              return getScheduler({
                viewPreset: 'dayAndWeek',
                features: {
                  scheduleContextMenu: {
                    items: {
                      extra: {
                        text: 'Extra',
                        icon: 'b-fa b-fa-fw b-fa-sheep',
                        onItem: function onItem(_ref6) {
                          var date = _ref6.date,
                              resourceRecord = _ref6.resourceRecord;
                          t.is(date, new Date(2011, 0, 4), 'Date param correct');
                          t.is(resourceRecord, scheduler.resourceStore.getAt(1), 'Resource param correct');
                          clicked = true;
                        }
                      }
                    }
                  }
                }
              }, 3);

            case 3:
              scheduler = _context5.sent;
              t.chain({
                rightClick: '.b-sch-timeaxis-cell',
                offset: [100, 60]
              }, {
                click: ':textEquals(Extra)'
              }, function () {
                t.ok(clicked, 'Click registered');
              });

            case 5:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x6) {
      return _ref5.apply(this, arguments);
    };
  }());
  t.it('LEGACY: Should be able to process items shown for an event', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return getScheduler({
                viewPreset: 'dayAndWeek',
                features: {
                  scheduleContextMenu: {
                    processItems: function processItems(_ref8) {
                      var date = _ref8.date,
                          resourceRecord = _ref8.resourceRecord,
                          items = _ref8.items;

                      if (date < new Date(2011, 0, 4)) {
                        items.old = {
                          text: 'Old'
                        };
                      }

                      if (resourceRecord === scheduler.resourceStore.getAt(2)) {
                        return false;
                      }
                    }
                  }
                }
              }, 1);

            case 2:
              scheduler = _context6.sent;
              t.chain({
                rightClick: '.b-sch-timeaxis-cell',
                offset: [50, 60]
              }, function (next) {
                t.selectorExists('.b-menu');
                t.selectorExists(':textEquals(Old)', 'Item found');
                next();
              }, {
                rightClick: '.b-sch-timeaxis-cell',
                offset: [400, 60]
              }, function (next) {
                t.selectorNotExists(':textEquals(Old)', 'Item not found');
                next();
              }, {
                click: '.b-sch-timeaxis-cell',
                offset: [200, 60],
                desc: 'Clicking to hide menu'
              }, {
                waitForSelectorNotFound: '.b-menu',
                desc: 'Menu hidden'
              }, {
                rightClick: '[data-index="2"] .b-sch-timeaxis-cell',
                offset: [10, 10]
              }, function () {
                t.selectorNotExists('.b-menu', 'No menu shown');
              });

            case 4:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x7) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('LEGACY: Should trigger scheduleContextMenuBeforeShow & scheduleContextMenuShow events', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return getScheduler({
                viewPreset: 'dayAndWeek',
                features: {
                  scheduleContextMenu: true
                }
              }, 1);

            case 2:
              scheduler = _context7.sent;
              t.firesOk(scheduler, {
                scheduleContextMenuBeforeShow: 2,
                scheduleContextMenuShow: 1
              });
              t.chain({
                rightClick: '.b-sch-timeaxis-cell',
                offset: [50, 60]
              }, function (next) {
                scheduler.on('scheduleContextMenuBeforeShow', function () {
                  return false;
                });
                next();
              }, {
                click: '.b-sch-timeaxis-cell',
                offset: [50, 60]
              }, {
                waitForSelectorNotFound: '.b-menu',
                desc: 'Menu hidden'
              }, {
                rightClick: '.b-sch-timeaxis-cell',
                offset: [50, 60]
              }, function () {
                t.selectorNotExists('.b-menu');
              });

            case 5:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x8) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('LEGACY: Should trigger scheduleContextMenuItem event', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              _context8.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                features: {
                  scheduleContextMenu: {
                    items: {
                      foo: {
                        text: 'foo'
                      }
                    }
                  }
                }
              });

            case 2:
              scheduler = _context8.sent;
              t.firesOk(scheduler, {
                scheduleContextMenuItem: 1
              });
              t.chain({
                rightClick: '.b-sch-timeaxis-cell',
                offset: [50, 60]
              }, {
                click: '.b-menuitem:textEquals(foo)'
              });

            case 5:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x9) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('LEGACY: Should work with AssignmentStore', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      features: {
        scheduleContextMenu: true,
        eventEdit: false
      },
      assignments: [{
        id: 'a1',
        eventId: 'e1',
        resourceId: 'r1'
      }, {
        id: 'a2',
        eventId: 'e1',
        resourceId: 'r2'
      }],
      events: [{
        id: 'e1',
        startDate: '2018-12-14',
        duration: 8
      }],
      resources: [{
        id: 'r1'
      }, {
        id: 'r2'
      }],
      startDate: '2018-12-7'
    });
    t.chain({
      waitForProjectReady: scheduler
    }, {
      rightClick: '.b-sch-timeaxis-cell',
      offset: [150, 10]
    }, {
      click: '.b-menu:textEquals(Add event)'
    }, {
      waitForSelector: '.b-sch-dirty-new',
      desc: 'New event rendered'
    }, function () {
      t.is(scheduler.eventStore.last.startDate, DateHelper.clearTime(scheduler.getDateFromCoordinate(150)), 'Start date correct');
      t.is(scheduler.assignmentStore.count, 3, 'Correct number of assignments');
    });
  });
  t.it('LEGACY: Should open context menu when clicking outside of rows', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return getScheduler({
                features: {
                  scheduleContextMenu: true,
                  eventEdit: false
                }
              });

            case 2:
              scheduler = _context9.sent;
              t.chain({
                rightClick: '.b-timeline-subgrid'
              }, {
                waitForSelector: '.b-menuitem.b-disabled:textEquals(Add event)'
              });

            case 4:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x10) {
      return _ref11.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8720

  t.it('LEGACY: Should respect scheduler readOnly mode and do not show default items', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return getScheduler({
                readOnly: true,
                features: {
                  scheduleContextMenu: {
                    items: {
                      test: {
                        text: 'Foo'
                      }
                    }
                  }
                }
              });

            case 2:
              scheduler = _context10.sent;
              t.chain({
                contextmenu: '.b-timeline-subgrid'
              }, {
                waitForSelectors: [['.b-menu .b-menuitem']]
              }, function () {
                t.selectorCountIs('.b-menuitem', 1, 'Only 1 item visible');
                t.selectorExists('.b-menuitem :textEquals(Foo)', 'Extra item is there');
                t.selectorNotExists('.b-menuitem :textEquals(Add event)', 'Add item is NOT there');
              });

            case 4:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x11) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('LEGACY: Should respect scheduler readOnly mode which dynamically gets enabled and disabled', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return getScheduler({
                features: {
                  scheduleContextMenu: {
                    items: {
                      test: {
                        text: 'Foo'
                      }
                    }
                  }
                }
              });

            case 2:
              scheduler = _context11.sent;
              t.chain({
                contextmenu: '.b-timeline-subgrid'
              }, {
                waitForSelectors: [['.b-menu .b-menuitem']]
              }, function (next) {
                t.selectorCountIs('.b-menuitem', 2, 'All items visible');
                t.selectorExists('.b-menuitem :textEquals(Foo)', 'Extra item is there');
                t.selectorExists('.b-menuitem :textEquals(Add event)', 'Add item is there');
                next();
              }, {
                click: '.b-sch-event'
              }, {
                waitForSelectorNotFound: '.b-menu'
              }, function (next) {
                scheduler.readOnly = true;
                next();
              }, {
                contextmenu: '.b-timeline-subgrid'
              }, {
                waitForSelectors: [['.b-menu .b-menuitem']]
              }, function (next) {
                t.selectorCountIs('.b-menuitem', 1, 'Only 1 item visible');
                t.selectorExists('.b-menuitem :textEquals(Foo)', 'Extra item is there');
                t.selectorNotExists('.b-menuitem :textEquals(Add event)', 'Add item is NOT there');
                next();
              }, {
                click: '.b-sch-event'
              }, {
                waitForSelectorNotFound: '.b-menu'
              }, function (next) {
                scheduler.readOnly = false;
                next();
              }, {
                contextmenu: '.b-timeline-subgrid'
              }, {
                waitForSelectors: [['.b-menu .b-menuitem']]
              }, function () {
                t.selectorCountIs('.b-menuitem', 2, 'All items visible');
                t.selectorExists('.b-menuitem :textEquals(Foo)', 'Extra item is there');
                t.selectorExists('.b-menuitem :textEquals(Add event)', 'Add item is there');
              });

            case 4:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x12) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('LEGACY: Should handle contextMenuTriggerEvent and triggerEvent configs to show menu', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              _context14.next = 2;
              return getScheduler({
                contextMenuTriggerEvent: 'click',
                features: {
                  scheduleContextMenu: {
                    items: {
                      test: {
                        text: 'Foo'
                      }
                    }
                  }
                }
              });

            case 2:
              scheduler = _context14.sent;
              t.chain( // Click event
              {
                click: '.b-sch-timeaxis-cell'
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
              _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12() {
                return regeneratorRuntime.wrap(function _callee12$(_context12) {
                  while (1) {
                    switch (_context12.prev = _context12.next) {
                      case 0:
                        scheduler.features.scheduleContextMenu.triggerEvent = 'dblclick';

                      case 1:
                      case "end":
                        return _context12.stop();
                    }
                  }
                }, _callee12);
              })), {
                dblClick: '.b-sch-timeaxis-cell'
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
              _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13() {
                return regeneratorRuntime.wrap(function _callee13$(_context13) {
                  while (1) {
                    switch (_context13.prev = _context13.next) {
                      case 0:
                        scheduler.features.scheduleContextMenu.triggerEvent = 'contextmenu';

                      case 1:
                      case "end":
                        return _context13.stop();
                    }
                  }
                }, _callee13);
              })), {
                rightClick: '.b-sch-timeaxis-cell'
              }, {
                waitForSelector: '.b-menu',
                desc: 'Menu visible'
              }, {
                type: '[ESC]]'
              }, {
                waitForSelectorNotFound: '.b-menu',
                desc: 'Menu hidden'
              });

            case 4:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x13) {
      return _ref14.apply(this, arguments);
    };
  }());
  t.it('LEGACY: Should support disabling', /*#__PURE__*/function () {
    var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return getScheduler({
                features: {
                  scheduleContextMenu: true
                },
                events: []
              });

            case 2:
              scheduler = _context15.sent;
              scheduler.features.scheduleContextMenu.disabled = true;
              t.chain({
                rightClick: '.b-sch-timeaxis-cell'
              }, function (next) {
                t.selectorNotExists('.b-menu', 'No menu shown');
                scheduler.features.scheduleContextMenu.disabled = false;
                next();
              }, {
                rightClick: '.b-sch-timeaxis-cell'
              }, function () {
                t.selectorExists('.b-menu', 'Menu shown');
              });

            case 5:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x14) {
      return _ref17.apply(this, arguments);
    };
  }());
  t.it('LEGACY: Should not activate on special rows like grouping header or summary', /*#__PURE__*/function () {
    var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return getScheduler({
                features: {
                  scheduleContextMenu: true,
                  group: 'name'
                }
              });

            case 2:
              scheduler = _context16.sent;
              t.chain({
                rightClick: '.b-timeline-subgrid .b-group-row'
              }, function () {
                return t.selectorNotExists('.b-menu', 'No menu shown');
              });

            case 4:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x15) {
      return _ref18.apply(this, arguments);
    };
  }());
});