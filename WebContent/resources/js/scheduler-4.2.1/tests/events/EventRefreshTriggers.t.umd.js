function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler, eventStore, resourceStore; // async beforeEach doesn't work in umd

  t.beforeEach( /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t, next) {
      var _scheduler;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler && scheduler.destroy();
              _context.next = 3;
              return t.getSchedulerAsync({
                resourceStore: t.getResourceStore2({}, 5),
                enableEventAnimations: false
              });

            case 3:
              scheduler = _context.sent;
              _scheduler = scheduler;
              eventStore = _scheduler.eventStore;
              resourceStore = _scheduler.resourceStore;
              eventStore.first.name = eventStore.first.cls = 'foo';
              eventStore.getAt(1).name = eventStore.getAt(1).cls = 'bar';
              next();

            case 10:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    }));

    return function (_x, _x2) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Should repaint correctly and release event divs if resource store is cleared', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              t.isntCalled('renderer', scheduler.currentOrientation, 'Resource store clear does not lay out any events');
              resourceStore.removeAll();
              _context2.next = 4;
              return t.waitForProjectReady(scheduler);

            case 4:
              t.selectorNotExists(scheduler.eventSelector, 'No event elements found');
              t.selectorNotExists('.b-sch-released', 'No released event elements found');

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
  t.it('Should repaint correctly if resource store is filtered', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var eventTopBefore;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              eventTopBefore = Rectangle.from(document.body.querySelector('.b-sch-event.bar')).y;
              t.isCalledNTimes('layoutResourceEvents', scheduler.currentOrientation, 0, 'Resource store filter lays out each event once');
              t.isCalledNTimes('renderer', scheduler.currentOrientation, eventStore.count - 1, 'Resource store filter renders each resource once'); // filter out first row, should repaint all below it (=== all in this case)

              resourceStore.filter(function (r) {
                return r.name !== 'Resource 1';
              });
              _context3.next = 6;
              return t.waitForProjectReady(scheduler);

            case 6:
              t.waitFor(function () {
                var eventTopAfterAdd = Rectangle.from(document.body.querySelector('.b-sch-event.bar')).y; // Second event will have moved upwards

                return eventTopAfterAdd < eventTopBefore;
              });

            case 7:
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
  t.it('Should repaint when adding a new resource', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var eventTopBefore;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              eventTopBefore = Rectangle.from(document.body.querySelector('.b-sch-event.foo')).y;
              _context4.next = 3;
              return t.waitForProjectReady(scheduler);

            case 3:
              eventStore.add({
                name: 'New Event',
                resourceId: 'newResource',
                startDate: scheduler.timeAxis.startDate,
                endDate: new Date(scheduler.timeAxis.startDate.valueOf() + 1000 * 60 * 60 * 24),
                cls: 'new-event'
              }); // #1 - Add

              t.isCalledNTimes('layoutResourceEvents', scheduler.currentOrientation, 1, 'Resource add only layouts the new resource'); // #1-6 - ResourceStore add
              // #7   - Project refresh

              t.isCalledNTimes('renderer', scheduler.currentOrientation, 7, 'Resource add reused layout of other resources');
              resourceStore.insert(0, {
                id: 'newResource',
                name: 'New'
              });
              t.chain({
                waitForProjectReady: scheduler
              }, {
                // Wait for the old first event to be pushed downwards because there is a new resource above
                waitFor: function waitFor() {
                  var eventTopAfterAdd = Rectangle.from(document.body.querySelector('.b-sch-event.foo')).y;
                  return eventTopAfterAdd > eventTopBefore;
                }
              }, {
                // Wait for the event assigned to the new resource must be at the same Y position that the old first event was at
                waitFor: function waitFor() {
                  var newEventRect = Rectangle.from(document.body.querySelector('.b-sch-event.new-event'));
                  return newEventRect.y === eventTopBefore;
                }
              });

            case 8:
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
  t.it('Should repaint when removing a resource', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var eventTopBefore;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              eventTopBefore = document.body.querySelector('[data-event-id="2"]').getBoundingClientRect().top; // The resourceModel.unassignAll() causes a layout as well as the following remove.

              t.isCalledNTimes('layoutResourceEvents', scheduler.currentOrientation, 0, 'No event layout needed');
              t.isCalledNTimes('renderer', scheduler.currentOrientation, eventStore.count - 1, 'Resources rendered');
              resourceStore.remove(resourceStore.first);
              t.waitFor(function () {
                var eventTopAfterRemove = document.body.querySelector('[data-event-id="2"]').getBoundingClientRect().top;
                return eventTopAfterRemove < eventTopBefore;
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
  t.it('Should repaint when adding a new event', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      var eventTopBefore;
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              eventTopBefore = Rectangle.from(document.body.querySelector('.b-sch-event.foo')).y;
              resourceStore.insert(0, {
                id: 'newResource',
                name: 'New'
              }); // Resource insertion and beforeEach event changes should not affect the layout count below, wait for them to
              // be finalized

              _context6.next = 4;
              return t.waitForProjectReady(scheduler);

            case 4:
              t.isCalledNTimes('layoutResourceEvents', scheduler.currentOrientation, 1, 'Only the new events resource is laid out');
              eventStore.add({
                name: 'New Event',
                resourceId: 'newResource',
                startDate: scheduler.timeAxis.startDate,
                endDate: new Date(scheduler.timeAxis.startDate.valueOf() + 1000 * 60 * 60 * 24),
                cls: 'new-event'
              });
              _context6.next = 8;
              return t.waitForProjectReady(scheduler);

            case 8:
              t.chain({
                // Wait for the old first event to be pushed downwards because there is a new resource above
                waitFor: function waitFor() {
                  var eventTopAfterAdd = Rectangle.from(document.body.querySelector('.b-sch-event.foo')).y;
                  return eventTopAfterAdd > eventTopBefore;
                }
              }, {
                // Wait for the event assigned to the new resource must be at the same Y position that the old first event was at
                waitFor: function waitFor() {
                  var newEventRect = Rectangle.from(document.body.querySelector('.b-sch-event.new-event'));
                  return newEventRect.y === eventTopBefore;
                }
              });

            case 9:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x7) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Should repaint and not crash when updating an event from nonexisting resourceId to valid one', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              scheduler.events = [{
                name: 'New Event',
                resourceId: 'blargh',
                startDate: scheduler.timeAxis.startDate,
                duration: 1
              }];
              t.chain({
                waitForProjectReady: scheduler
              }, {
                waitForSelectorNotFound: scheduler.unreleasedEventSelector
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7() {
                return regeneratorRuntime.wrap(function _callee7$(_context7) {
                  while (1) {
                    switch (_context7.prev = _context7.next) {
                      case 0:
                        eventStore.first.resourceId = resourceStore.first.id;
                        _context7.next = 3;
                        return scheduler.project.commitAsync();

                      case 3:
                      case "end":
                        return _context7.stop();
                    }
                  }
                }, _callee7);
              })), {
                waitForProjectReady: scheduler
              }, {
                waitForSelector: scheduler.unreleasedEventSelector
              });

            case 2:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x8) {
      return _ref7.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/6814

  t.it('Should move element when changing startDate within timeaxis but out of view', function (t) {
    scheduler.endDate = new Date(2011, 0, 20); //eventStore.first.setStartDate(new Date(2011, 0, 15), true);

    eventStore.first.startDate = new Date(2011, 0, 15);
    t.chain({
      waitForElementNotVisible: '[data-event-id="1"]'
    }, function () {
      t.pass('Element no longer visible');
    });
  }); // https://app.assembla.com/spaces/bryntum/tickets/7074

  t.it('Should remove all event elements when removing resource', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              eventStore.getAt(1).resourceId = 'r1';
              eventStore.getAt(2).resourceId = 'r1';
              _context9.next = 4;
              return t.waitForProjectReady(scheduler);

            case 4:
              resourceStore.first.remove();
              _context9.next = 7;
              return t.waitForProjectReady(scheduler);

            case 7:
              t.selectorNotExists('[data-event-id="1"]:not(.b-released)', 'First event gone');
              t.selectorNotExists('[data-event-id="2"]:not(.b-released)', 'Second event gone');
              t.selectorNotExists('[data-event-id="3"]:not(.b-released)', 'Third event gone');

            case 10:
            case "end":
              return _context9.stop();
          }
        }
      }, _callee9);
    }));

    return function (_x9) {
      return _ref9.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7072

  t.it('Should refresh UI after removing all events', function (t) {
    eventStore.removeAll();
    t.chain({
      waitForSelectorNotFound: scheduler.unreleasedEventSelector,
      desc: 'All event elements removed'
    });
  }); // https://app.assembla.com/spaces/bryntum/tickets/7224

  t.it('Should update elements when eventStore is filtered', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              eventStore.filter('name', 'bar');
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Single event element found after filtering');
              eventStore.clearFilters();
              t.selectorCountIs(scheduler.unreleasedEventSelector, 5, 'All event elements found after clearing filters');

            case 4:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x10) {
      return _ref10.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7224

  t.it('Should work with reapplyFilterOnAdd: false', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              eventStore.reapplyFilterOnAdd = false;
              eventStore.filter('name', 'bar');
              eventStore.add({
                name: 'extra',
                resourceId: 'r1',
                startDate: '2011-01-07',
                duration: 2
              });
              _context11.next = 5;
              return t.waitForProjectReady(scheduler);

            case 5:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 2, 'Two event elements found after add');

            case 6:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x11) {
      return _ref11.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/7224

  t.it('Should work with reapplyFilterOnAdd: true', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              eventStore.reapplyFilterOnAdd = true;
              eventStore.filter('name', 'bar');
              eventStore.add({
                name: 'extra',
                resourceId: 'r1',
                startDate: '2011-01-07',
                duration: 2
              });
              _context12.next = 5;
              return t.waitForProjectReady(scheduler);

            case 5:
              t.selectorCountIs(scheduler.unreleasedEventSelector, 1, 'Single event element found after add');

            case 6:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x12) {
      return _ref12.apply(this, arguments);
    };
  }()); // https://app.assembla.com/spaces/bryntum/tickets/8487

  t.it('Should reuse same element when changing id', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      var element;
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              element = document.querySelector(scheduler.eventSelector + '[data-event-id="1"]');
              eventStore.getAt(1).resourceId = 'r1';
              eventStore.first.id = 'BrandNewId';
              _context13.next = 5;
              return t.waitForProjectReady(scheduler);

            case 5:
              t.is(element.dataset.eventId, 'BrandNewId', 'Elements data-event-id updated');
              t.is(scheduler.getElementFromEventRecord(eventStore.first).parentElement, element, 'Same element used for the record');
              t.selectorCountIs(scheduler.eventSelector, 5, 'Correct total amount of event elements');
              t.selectorCountIs(scheduler.unreleasedEventSelector, 5, 'Correct amount of displayed event elements');

            case 9:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x13) {
      return _ref13.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/602

  t.it('Should redraw events on resource changes', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              t.it('Changing field that has no impact', function (t) {
                // No element changes
                t.firesOk(scheduler, {
                  renderEvent: 0,
                  releaseEvent: 0
                }); // Should get laid out

                t.isCalledNTimes('clearResources', scheduler.currentOrientation, 1, 'Cleared once');
                t.isCalledNTimes('clearAll', scheduler.currentOrientation, 0, 'Did not clear all');
                t.isCalledNTimes('layoutResourceEvents', scheduler.currentOrientation, 1, 'Only affected resource refreshed');
                resourceStore.first.name = 'Dude';
              });
              t.it('Changing field that has impact', function (t) {
                // Element should get updated
                t.firesOk(scheduler, {
                  renderEvent: 1,
                  releaseEvent: 0
                }); // Should get laid out

                t.isCalledNTimes('clearResources', scheduler.currentOrientation, 1, 'Cleared once');
                t.isCalledNTimes('clearAll', scheduler.currentOrientation, 0, 'Did not clear all');
                t.isCalledNTimes('layoutResourceEvents', scheduler.currentOrientation, 1, 'Only affected resource refreshed');
                resourceStore.first.eventColor = 'blue';
                t.selectorExists('[data-event-id="1"].b-sch-color-blue', 'Change applied to DOM');
              });

            case 2:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x14) {
      return _ref14.apply(this, arguments);
    };
  }());
  t.it('Adding events should increase row height', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      var heightBefore, countBefore, countAfter;
      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              heightBefore = scheduler.getRow(0).height, countBefore = document.querySelectorAll(scheduler.unreleasedEventSelector).length; // Add will rerender all events below

              t.willFireNTimes(scheduler, 'renderEvent', 6);
              scheduler.eventStore.add([scheduler.eventStore.first.copy(), scheduler.eventStore.first.copy()]);
              _context15.next = 5;
              return t.waitForProjectReady();

            case 5:
              countAfter = document.querySelectorAll(scheduler.unreleasedEventSelector).length;
              t.isGreater(scheduler.getRow(0).height, heightBefore, 'Height of row has increased');
              t.is(countAfter, countBefore + 2, 'Elements added');

            case 8:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x15) {
      return _ref15.apply(this, arguments);
    };
  }());
});