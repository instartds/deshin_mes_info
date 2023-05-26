function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy(); // After scheduler destroy, all menuitems must also have been destroyed

    t.is(bryntum.queryAll('menuitem').length, 0, 'Menu items all destroyed');
  });
  var spy = t.spyOn(VersionHelper, 'deprecate').and.callFake(function () {});
  t.it('LEGACY: should work with a disabled dependencyEdit feature', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'dayAndWeek',
      features: {
        eventContextMenu: true,
        dependencies: {
          disabled: false
        },
        dependencyEdit: {
          disabled: true
        }
      }
    }, 3);
    t.chain({
      contextmenu: '.b-sch-event'
    }, function () {
      t.ok(scheduler.features.eventContextMenu.menu.isVisible, 'Event context menu is visible');
      t.expect(spy).toHaveBeenCalled(1);
      t.expect(spy).toHaveBeenCalledWith('Scheduler', '5.0.0', '`EventContextMenu` feature is deprecated, in favor of `EventMenu` feature. Please see https://bryntum.com/docs/scheduler/#Scheduler/guides/upgrades/3.1.0.md for more information.');
    });
  });
  t.it('LEGACY: Removing event from context menu by keyboard action should focus next event', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'dayAndWeek',
      features: {
        eventContextMenu: true
      }
    }, 3);
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
  });
  t.it('LEGACY: Should be able to add extra items to the menu', function (t) {
    var clicked = false;
    scheduler = t.getScheduler({
      viewPreset: 'dayAndWeek',
      features: {
        // Gets in the way in FF
        eventTooltip: false,
        eventContextMenu: {
          items: {
            extra: {
              text: 'Extra',
              icon: 'b-fa b-fa-fw b-fa-fish',
              onItem: function onItem() {
                clicked = true;
              }
            }
          }
        }
      }
    }, 3);
    t.chain({
      moveCursorTo: '[data-event-id="1"]'
    }, // Utility method to create steps to show contextmenu and click item.
    t.eventContextMenuSteps(scheduler, scheduler.eventStore.first, 'Extra'), function () {
      t.ok(clicked, 'Click registered');
    });
  });
  t.it('LEGACY: Should be able to process items shown for an event', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'dayAndWeek',
      features: {
        eventContextMenu: {
          items: {
            foo: {
              text: 'foo'
            }
          },
          processItems: function processItems(_ref) {
            var eventRecord = _ref.eventRecord,
                items = _ref.items;

            if (eventRecord === scheduler.eventStore.getAt(1)) {
              items.extra = {
                text: 'Extra'
              };
              t.is(ObjectHelper.getTruthyKeys(items).filter(function (ref) {
                return !items[ref].hidden;
              }).length, 6, '6 visible items (4 default, one extra on feature config, one added dynamically)');
            }

            if (eventRecord === scheduler.eventStore.getAt(2)) {
              return false;
            }
          }
        }
      }
    }, 3);
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
  });
  t.it('LEGACY: Should trigger eventContextMenuBeforeShow & eventContextMenuShow events', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'dayAndWeek',
      features: {
        eventContextMenu: true
      }
    }, 3);
    t.firesOk(scheduler, {
      eventContextMenuBeforeShow: 2,
      eventContextMenuShow: 1
    });
    t.chain({
      rightClick: '.b-sch-event'
    }, {
      waitForSelector: '.b-menu',
      desc: 'Menu shown'
    }, function (next) {
      scheduler.on('eventContextMenuBeforeShow', function () {
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
  });
  t.it('LEGACY: Should trigger eventContextMenuItem event', function (t) {
    scheduler = t.getScheduler({
      viewPreset: 'dayAndWeek',
      appendTo: document.body,
      features: {
        eventContextMenu: {
          items: {
            foo: {
              text: 'foo'
            }
          }
        }
      }
    });
    t.firesOk(scheduler, {
      eventContextMenuItem: 1
    });
    t.chain({
      rightClick: '.b-sch-event'
    }, {
      click: '.b-menuitem:textEquals(foo)'
    });
  });
  t.it('LEGACY: Should work with AssignmentStore', function (t) {
    var index = 0;
    scheduler = new Scheduler({
      appendTo: document.body,
      features: {
        eventContextMenu: {
          processItems: function processItems(_ref2) {
            var eventRecord = _ref2.eventRecord,
                assignmentRecord = _ref2.assignmentRecord,
                resourceRecord = _ref2.resourceRecord;
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
  });
  t.it('LEGACY: Should be possible to trigger menu using API', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventTooltip: false,
        eventContextMenu: true
      },
      startDate: new Date(2011, 0, 7),
      endDate: new Date(2011, 0, 10)
    });

    var menu = scheduler.features.eventContextMenu,
        getEvent = function getEvent(id) {
      return scheduler.eventStore.getById(id);
    }; // return;


    t.chain({
      waitForEventsToRender: null
    }, function (next) {
      var event = getEvent(1);
      menu.showContextMenuFor(event);
      t.selectorCountIs('.b-menuitem', 0, 'Menu was not opened because event1 is outside time axis');
      event = getEvent(4);
      t.waitForEvent(scheduler, 'eventcontextmenushow', next);
      menu.showContextMenuFor(event);
    }, function (next) {
      t.selectorCountIs('.b-menu', 1, 'Event context menu appears');
      var event = scheduler.getElementsFromEventRecord(getEvent(4))[0].getBoundingClientRect(),
          menuBox = document.querySelector('.b-menu').getBoundingClientRect();
      t.ok(event.left < menuBox.left && event.right > menuBox.left, 'Menu is aligned horizontally');
      t.ok(event.top < menuBox.top && event.bottom > menuBox.top, 'Menu is aligned vertically');
      next();
    });
  }); // https://app.assembla.com/spaces/bryntum/tickets/8720

  t.it('LEGACY: Should respect scheduler readOnly mode and do not show default items', function (t) {
    scheduler = t.getScheduler({
      readOnly: true,
      features: {
        eventContextMenu: {
          items: {
            test: {
              text: 'Foo'
            }
          }
        }
      }
    });
    t.chain({
      contextmenu: '.b-sch-event'
    }, {
      waitForSelectors: [['.b-menu .b-menuitem']]
    }, function () {
      t.selectorCountIs('.b-menuitem:not(.b-hidden)', 1, 'Only 1 item visible');
      t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Foo)', 'Extra item is there');
      t.selectorNotExists('.b-menuitem:not(.b-hidden) :textEquals(Edit event)', 'Edit item is NOT there');
      t.selectorNotExists('.b-menuitem:not(.b-hidden) :textEquals(Copy event)', 'Copy item is NOT there');
      t.selectorNotExists('.b-menuitem:not(.b-hidden) :textEquals(Cut event)', 'Cut item is NOT there');
      t.selectorNotExists('.b-menuitem:not(.b-hidden) :textEquals(Delete event)', 'Delete item is NOT there');
    });
  });
  t.it('LEGACY: Should respect scheduler readOnly mode which dynamically gets enabled and disabled', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventContextMenu: {
          items: {
            test: {
              text: 'Foo'
            }
          }
        }
      }
    });
    t.chain({
      contextmenu: '.b-sch-event'
    }, {
      waitForSelectors: [['.b-menu .b-menuitem']]
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
      waitForSelectors: [['.b-menu .b-menuitem']]
    }, function (next) {
      t.selectorCountIs('.b-menuitem:not(.b-hidden)', 1, 'Only 1 item visible');
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
      waitForSelectors: [['.b-menu .b-menuitem']]
    }, function () {
      t.selectorCountIs('.b-menuitem:not(.b-hidden)', 5, 'All items are visible');
      t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Foo)', 'Extra item is there');
      t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Edit event)', 'Edit item is there');
      t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Copy event)', 'Copy item is there');
      t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Cut event)', 'Cut item is there');
      t.selectorExists('.b-menuitem:not(.b-hidden) :textEquals(Delete event)', 'Delete item is there');
    });
  });
  t.it('LEGACY: Should handle contextMenuTriggerEvent and triggerEvent configs to show menu', function (t) {
    scheduler = t.getScheduler({
      contextMenuTriggerEvent: 'click',
      features: {
        eventEdit: false,
        eventContextMenu: {
          items: {
            test: {
              text: 'Foo'
            }
          }
        }
      }
    });
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
    _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler.features.eventContextMenu.triggerEvent = 'dblclick';

            case 1:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
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
    _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2() {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              scheduler.features.eventContextMenu.triggerEvent = 'contextmenu';

            case 1:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
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
  });
  t.it('LEGACY: Should activate event context menu by Space click', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventContextMenu: {
          items: {
            test: {
              text: 'Foo'
            }
          }
        }
      }
    });
    t.chain({
      click: '.b-sch-event'
    }, {
      type: ' '
    }, {
      waitForSelector: '.b-menu',
      desc: 'Menu visible'
    });
  });
  t.it('LEGACY: Should support disabling', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventContextMenu: true
      }
    });
    scheduler.features.eventContextMenu.disabled = true;
    t.chain({
      rightClick: '.b-sch-event'
    }, function (next) {
      t.selectorNotExists('.b-menu', 'Menu not shown');
      scheduler.features.eventContextMenu.disabled = false;
      next();
    }, {
      rightClick: '.b-sch-event'
    }, function () {
      t.selectorExists('.b-menu', 'Menu shown');
    });
  });
});