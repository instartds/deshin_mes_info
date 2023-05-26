function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy(); // After scheduler destroy, all menuitems must also have been destroyed

    t.is(bryntum.queryAll('menuitem').length, 0, 'Menu items all destroyed');
  });
  t.it('Should work with a disabled dependencyEdit feature', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
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

            case 2:
              scheduler = _context.sent;
              t.chain({
                contextmenu: '.b-sch-event'
              }, function () {
                return t.ok(scheduler.features.eventMenu.menu.isVisible, 'Event context menu is visible');
              });

            case 4:
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
  t.it('Removing event from context menu by keyboard action should focus next event', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                appendTo: document.body,
                features: {
                  eventMenu: true
                }
              }, 3);

            case 2:
              scheduler = _context2.sent;
              t.chain({
                contextmenu: '.b-sch-event'
              }, // Key down to the delete option.
              // Focus reversion only happens if using keyboard
              {
                type: '[DOWN]'
              }, {
                type: '[DOWN]'
              }, {
                type: '[DOWN]'
              }, {
                type: '[DOWN]'
              }, {
                type: ' '
              }, // Wait for next one to be focused
              {
                waitFor: function waitFor() {
                  return document.activeElement === scheduler.getElementFromEventRecord(scheduler.eventStore.first).parentNode;
                }
              }, // Then move on to last one
              {
                type: '[RIGHT]'
              }, function () {
                t.ok(document.activeElement.firstElementChild.classList.contains('event3'), 'Last event is focused');
              });

            case 4:
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
  t.it('Should be able to add extra items to the menu', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var clicked;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              clicked = false;
              _context3.next = 3;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                appendTo: document.body,
                features: {
                  // Gets in the way in FF
                  eventTooltip: false,
                  eventMenu: {
                    items: {
                      extra: {
                        text: 'Extra',
                        icon: 'b-fa .b-fa-fw .b-fa-fish',
                        onItem: function onItem() {
                          clicked = true;
                        }
                      }
                    }
                  }
                }
              }, 3);

            case 3:
              scheduler = _context3.sent;
              t.chain( // Utility method to create steps to show contextmenu and click item.
              t.eventContextMenuSteps(scheduler, scheduler.eventStore.first, 'Extra'), function () {
                t.ok(clicked, 'Click registered');
              });

            case 5:
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
  t.it('Should be able to process items shown for an event', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                appendTo: document.body,
                features: {
                  eventMenu: {
                    items: {
                      foo: {
                        text: 'foo'
                      }
                    },
                    processItems: function processItems(_ref5) {
                      var eventRecord = _ref5.eventRecord,
                          items = _ref5.items;

                      if (eventRecord === scheduler.eventStore.getAt(1)) {
                        items.extra = {
                          text: 'Extra'
                        };
                        t.is(ObjectHelper.getTruthyKeys(items).filter(function (ref) {
                          return !items[ref].hidden;
                        }).length, 6, '6 items (4 default, one extra on feature config, one added dynamically)');
                      }

                      if (eventRecord === scheduler.eventStore.getAt(2)) {
                        return false;
                      }
                    }
                  }
                }
              }, 3);

            case 2:
              scheduler = _context4.sent;
              t.chain({
                rightClick: '[data-event-id="2"]'
              }, function (next) {
                t.selectorExists('.b-menu');
                t.selectorExists(':textEquals(Extra)', 'Item found');
                next();
              }, {
                rightClick: '[data-event-id="1"]'
              }, function (next) {
                t.selectorNotExists(':textEquals(Extra)', 'Item not found');
                next();
              }, {
                click: '[data-event-id="3"]',
                desc: 'Clicking to hide menu'
              }, {
                waitForSelectorNotFound: '.b-menu',
                desc: 'Menu hidden'
              }, {
                rightClick: '[data-event-id="3"]'
              }, function () {
                t.selectorNotExists('.b-menu', 'No menu shown');
              });

            case 4:
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
  t.it('Should trigger eventMenuBeforeShow & eventMenuShow events', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              _context5.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                appendTo: document.body,
                features: {
                  eventMenu: true
                }
              });

            case 2:
              scheduler = _context5.sent;
              t.firesOk(scheduler, {
                eventMenuBeforeShow: 2,
                eventMenuShow: 1
              });
              t.chain({
                rightClick: '.b-sch-event'
              }, {
                waitForSelector: '.b-menu',
                desc: 'Menu shown'
              }, function (next) {
                scheduler.on('eventMenuBeforeShow', function () {
                  return false;
                });
                next();
              }, {
                click: '.b-sch-event'
              }, {
                waitForSelectorNotFound: '.b-menu',
                desc: 'Menu hidden on event click'
              }, {
                rightClick: '.b-sch-event'
              }, function () {
                return t.selectorNotExists('.b-menu');
              });

            case 5:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x5) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('LEGACY: Should trigger eventContextMenuBeforeShow & eventContextMenuShow events', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var spy;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              spy = t.spyOn(VersionHelper, 'deprecate').and.callFake(function () {});
              _context6.next = 3;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                appendTo: document.body,
                features: {
                  eventMenu: true
                }
              });

            case 3:
              scheduler = _context6.sent;
              t.firesOk(scheduler, {
                eventContextMenuBeforeShow: 1,
                eventContextMenuShow: 1
              });
              t.chain({
                rightClick: '.b-sch-event'
              }, function () {
                t.expect(spy).toHaveBeenCalled(2); // Fired at least once with the specified arguments:

                t.expect(spy).toHaveBeenCalledWith('Scheduler', '5.0.0', '`eventContextMenuBeforeShow` event is deprecated, in favor of `eventMenuBeforeShow` event. Please see https://bryntum.com/docs/scheduler/#Scheduler/guides/upgrades/3.1.0.md for more information.');
                t.expect(spy).toHaveBeenCalledWith('Scheduler', '5.0.0', '`eventContextMenuShow` event is deprecated, in favor of `eventMenuShow` event. Please see https://bryntum.com/docs/scheduler/#Scheduler/guides/upgrades/3.1.0.md for more information.');
              });

            case 6:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x6) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Should trigger eventMenuItem event', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              _context7.next = 2;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                appendTo: document.body,
                features: {
                  eventMenu: {
                    items: {
                      foo: {
                        text: 'foo'
                      }
                    }
                  }
                }
              });

            case 2:
              scheduler = _context7.sent;
              t.firesOk(scheduler, {
                eventMenuItem: 1
              });
              t.chain({
                rightClick: '.b-sch-event'
              }, {
                click: '.b-menuitem:not(.b-hidden) :textEquals(foo)'
              });

            case 5:
            case "end":
              return _context7.stop();
          }
        }
      }, _callee7);
    }));

    return function (_x7) {
      return _ref8.apply(this, arguments);
    };
  }());
  t.it('LEGACY: Should trigger eventContextMenuItem event', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      var spy;
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              spy = t.spyOn(VersionHelper, 'deprecate').and.callFake(function () {});
              _context8.next = 3;
              return t.getSchedulerAsync({
                viewPreset: 'dayAndWeek',
                appendTo: document.body,
                features: {
                  eventMenu: {
                    items: {
                      foo: {
                        text: 'foo'
                      }
                    }
                  }
                }
              });

            case 3:
              scheduler = _context8.sent;
              t.firesOk(scheduler, {
                eventContextMenuItem: 1
              });
              t.chain({
                rightClick: '.b-sch-event'
              }, {
                click: '.b-menuitem:not(.b-hidden) :textEquals(foo)'
              }, function () {
                t.expect(spy).toHaveBeenCalled(1);
                t.expect(spy).toHaveBeenCalledWith('Scheduler', '5.0.0', '`eventContextMenuItem` event is deprecated, in favor of `eventMenuItem` event. Please see https://bryntum.com/docs/scheduler/#Scheduler/guides/upgrades/3.1.0.md for more information.');
              });

            case 6:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x8) {
      return _ref9.apply(this, arguments);
    };
  }());
  t.it('Should work with AssignmentStore', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      var index;
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              index = 0;
              scheduler = new Scheduler({
                appendTo: document.body,
                features: {
                  eventMenu: {
                    processItems: function processItems(_ref11) {
                      var eventRecord = _ref11.eventRecord,
                          assignmentRecord = _ref11.assignmentRecord,
                          resourceRecord = _ref11.resourceRecord;
                      t.is(eventRecord, scheduler.eventStore.getAt(0), 'Correct event');
                      t.is(assignmentRecord, scheduler.assignmentStore.getAt(index), 'Correct resource');
                      t.is(resourceRecord, scheduler.resourceStore.getAt(index), 'Correct assignment');
                    }
                  }
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
                startDate: '2018-12-10'
              });
              t.chain({
                rightClick: '[data-assignment-id=a1]'
              }, function (next) {
                index = 1;
                next();
              }, {
                rightClick: '[data-assignment-id=a2]'
              });

            case 3:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x9) {
      return _ref10.apply(this, arguments);
    };
  }());
  t.it('Should be possible to trigger menu using API', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var menu, getEvent;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              _context10.next = 2;
              return t.getSchedulerAsync({
                appendTo: document.body,
                features: {
                  eventTooltip: false,
                  eventMenu: true
                },
                startDate: new Date(2011, 0, 7),
                endDate: new Date(2011, 0, 10)
              });

            case 2:
              scheduler = _context10.sent;
              menu = scheduler.features.eventMenu, getEvent = function getEvent(id) {
                return scheduler.eventStore.getById(id);
              }; // return;

              t.chain({
                waitForSelector: '.b-sch-event'
              }, function (next) {
                var event = getEvent(1);
                menu.showContextMenuFor(event);
                t.selectorCountIs('.b-menuitem', 0, 'Menu was not opened because event1 is outside time axis');
                event = getEvent(4);
                t.waitForEvent(scheduler, 'eventmenushow', next);
                menu.showContextMenuFor(event);
              }, function (next) {
                t.selectorCountIs('.b-menu', 1, 'Event context menu appears');
                var event = scheduler.getElementsFromEventRecord(getEvent(4))[0].getBoundingClientRect(),
                    menuBox = document.querySelector('.b-menu').getBoundingClientRect();
                t.ok(event.left < menuBox.left && event.right > menuBox.left, 'Menu is aligned horizontally');
                t.ok(event.top < menuBox.top && event.bottom > menuBox.top, 'Menu is aligned vertically');
                next();
              });

            case 5:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x10) {
      return _ref12.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8720

  t.it('Should respect scheduler readOnly mode and do not show default items', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return t.getSchedulerAsync({
                readOnly: true,
                features: {
                  eventMenu: {
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
                contextmenu: '.b-sch-event'
              }, {
                waitForSelector: '.b-menu .b-menuitem:not(.b-hidden)'
              }, function () {
                t.selectorCountIs('.b-menuitem:not(.b-hidden) ', 1, 'Only 1 item visible');
                t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Foo)', 'Extra item is there');
                t.selectorNotExists('.b-menuitem:not(.b-hidden) :textEquals(Edit event)', 'Edit item is NOT there');
                t.selectorNotExists('.b-menuitem:not(.b-hidden) :textEquals(Copy event)', 'Copy item is NOT there');
                t.selectorNotExists('.b-menuitem:not(.b-hidden) :textEquals(Cut event)', 'Cut item is NOT there');
                t.selectorNotExists('.b-menuitem:not(.b-hidden) :textEquals(Delete event)', 'Delete item is NOT there');
              });

            case 4:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x11) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('Should respect scheduler readOnly mode which dynamically gets enabled and disabled', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventMenu: {
                    items: {
                      test: {
                        text: 'Foo'
                      }
                    }
                  }
                }
              });

            case 2:
              scheduler = _context12.sent;
              t.chain({
                contextmenu: '.b-sch-event'
              }, {
                waitForSelectors: [['.b-menu .b-menuitem:not(.b-hidden) ']]
              }, function (next) {
                t.selectorCountIs('.b-menuitem:not(.b-hidden)', 5, 'All items are visible');
                t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Foo)', 'Extra item is there');
                t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Edit event)', 'Edit item is there');
                t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Copy event)', 'Copy item is there');
                t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Cut event)', 'Cut item is there');
                t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Delete event)', 'Delete item is there');
                next();
              }, {
                click: '.b-timeline-subgrid'
              }, {
                waitForSelectorNotFound: '.b-menu'
              }, function (next) {
                scheduler.readOnly = true;
                next();
              }, {
                contextmenu: '.b-sch-event'
              }, {
                waitForSelectors: [['.b-menu .b-menuitem:not(.b-hidden) ']]
              }, function (next) {
                t.selectorCountIs('.b-menuitem:not(.b-hidden) ', 1, 'Only 1 item visible');
                t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Foo)', 'Extra item is there');
                t.selectorNotExists('.b-menuitem:not(.b-hidden) :textEquals(Edit event)', 'Edit item is NOT there');
                t.selectorNotExists('.b-menuitem:not(.b-hidden) :textEquals(Copy event)', 'Copy item is NOT there');
                t.selectorNotExists('.b-menuitem:not(.b-hidden) :textEquals(Cut event)', 'Cut item is NOT there');
                t.selectorNotExists('.b-menuitem:not(.b-hidden) :textEquals(Delete event)', 'Delete item is NOT there');
                next();
              }, {
                click: '.b-timeline-subgrid'
              }, {
                waitForSelectorNotFound: '.b-menu'
              }, function (next) {
                scheduler.readOnly = false;
                next();
              }, {
                contextmenu: '.b-sch-event'
              }, {
                waitForSelectors: [['.b-menu .b-menuitem:not(.b-hidden) ']]
              }, function () {
                t.selectorCountIs('.b-menuitem:not(.b-hidden) ', 5, 'All items are visible');
                t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Foo)', 'Extra item is there');
                t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Edit event)', 'Edit item is there');
                t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Copy event)', 'Copy item is there');
                t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Cut event)', 'Cut item is there');
                t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Delete event)', 'Delete item is there');
              });

            case 4:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x12) {
      return _ref14.apply(this, arguments);
    };
  }());
  t.it('Should handle contextMenuTriggerEvent and triggerEvent configs to show menu', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              _context15.next = 2;
              return t.getSchedulerAsync({
                contextMenuTriggerEvent: 'click',
                features: {
                  eventEdit: false,
                  eventMenu: {
                    items: {
                      test: {
                        text: 'Foo'
                      }
                    }
                  }
                }
              });

            case 2:
              scheduler = _context15.sent;
              t.chain( // Click event
              {
                click: '.b-sch-event'
              }, {
                waitForSelector: '.b-menu',
                desc: 'Menu visible'
              }, {
                type: '[ESC]'
              }, {
                waitForSelectorNotFound: '.b-menu',
                desc: 'Menu hidden'
              },
              /*#__PURE__*/
              // DblClick event
              _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13() {
                return regeneratorRuntime.wrap(function _callee13$(_context13) {
                  while (1) {
                    switch (_context13.prev = _context13.next) {
                      case 0:
                        scheduler.features.eventMenu.triggerEvent = 'dblclick';

                      case 1:
                      case "end":
                        return _context13.stop();
                    }
                  }
                }, _callee13);
              })), {
                dblClick: '.b-sch-event'
              }, {
                waitForSelector: '.b-menu',
                desc: 'Menu visible'
              }, {
                type: '[ESC]'
              }, {
                waitForSelectorNotFound: '.b-menu',
                desc: 'Menu hidden'
              },
              /*#__PURE__*/
              // Contextmenu event
              _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14() {
                return regeneratorRuntime.wrap(function _callee14$(_context14) {
                  while (1) {
                    switch (_context14.prev = _context14.next) {
                      case 0:
                        scheduler.features.eventMenu.triggerEvent = 'contextmenu';

                      case 1:
                      case "end":
                        return _context14.stop();
                    }
                  }
                }, _callee14);
              })), {
                rightClick: '.b-sch-event'
              }, {
                waitForSelector: '.b-menu',
                desc: 'Menu visible'
              }, {
                type: '[ESC]'
              }, {
                waitForSelectorNotFound: '.b-menu',
                desc: 'Menu hidden'
              });

            case 4:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x13) {
      return _ref15.apply(this, arguments);
    };
  }());
  t.it('Should activate event context menu by Space click', /*#__PURE__*/function () {
    var _ref18 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventMenu: {
                    items: {
                      test: {
                        text: 'Foo'
                      }
                    }
                  }
                }
              });

            case 2:
              scheduler = _context16.sent;
              t.chain({
                click: '.b-sch-event'
              }, {
                type: ' '
              }, {
                waitForSelector: '.b-menu',
                desc: 'Menu visible'
              });

            case 4:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x14) {
      return _ref18.apply(this, arguments);
    };
  }());
  t.it('Should support disabling', /*#__PURE__*/function () {
    var _ref19 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee17(t) {
      return regeneratorRuntime.wrap(function _callee17$(_context17) {
        while (1) {
          switch (_context17.prev = _context17.next) {
            case 0:
              _context17.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventMenu: true
                }
              });

            case 2:
              scheduler = _context17.sent;
              scheduler.features.eventMenu.disabled = true;
              t.chain({
                rightClick: '.b-sch-event'
              }, function (next) {
                t.selectorNotExists('.b-menu', 'Menu not shown');
                scheduler.features.eventMenu.disabled = false;
                next();
              }, {
                rightClick: '.b-sch-event'
              }, function () {
                t.selectorExists('.b-menu', 'Menu shown');
              });

            case 5:
            case "end":
              return _context17.stop();
          }
        }
      }, _callee17);
    }));

    return function (_x15) {
      return _ref19.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2800

  t.it('Should delete all selected events ', /*#__PURE__*/function () {
    var _ref20 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee18(t) {
      return regeneratorRuntime.wrap(function _callee18$(_context18) {
        while (1) {
          switch (_context18.prev = _context18.next) {
            case 0:
              _context18.next = 2;
              return t.getScheduler({
                features: {
                  eventMenu: true
                }
              });

            case 2:
              scheduler = _context18.sent;
              scheduler.selectedEvents = scheduler.eventStore.records;
              t.chain({
                rightClick: '.b-sch-event'
              }, {
                click: '.b-menuitem:contains(Delete)'
              }, function () {
                t.selectorCountIs(scheduler.unreleasedEventSelector, 0, 'All events removed from DOM');
                t.is(scheduler.eventStore.count, 0, 'All events removed');
              });

            case 5:
            case "end":
              return _context18.stop();
          }
        }
      }, _callee18);
    }));

    return function (_x16) {
      return _ref20.apply(this, arguments);
    };
  }());
});