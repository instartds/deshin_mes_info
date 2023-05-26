function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest({
  defaultTimeout: 90000
}, function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });

  var getScheduler = function getScheduler(config) {
    return t.getScheduler(Object.assign({
      features: {
        eventDrag: true
      }
    }, config));
  };

  t.it('Should target resource row if center point of event bar is inside the row', function (t) {
    scheduler = getScheduler({
      rowHeight: 40,
      barMargin: 0,
      events: [{
        id: 1,
        resourceId: 'r1',
        startDate: new Date(2011, 0, 6),
        endDate: new Date(2011, 0, 10)
      }]
    });
    t.chain({
      drag: scheduler.eventSelector,
      by: [0, 30]
    }, function () {
      var evt = scheduler.eventStore.first;
      t.expect(evt.get('resourceId')).toBe('r2');
    });
  });
  t.it('Event tooltip should hide when drag drop starts', function (t) {
    scheduler = getScheduler({
      features: {
        eventTooltip: true,
        eventDrag: true
      },
      events: [{
        id: 1,
        resourceId: 'r1',
        startDate: new Date(2011, 0, 6),
        endDate: new Date(2011, 0, 7)
      }]
    });
    t.chain({
      moveCursorTo: [1, 1]
    }, {
      moveCursorTo: scheduler.eventSelector
    }, {
      waitForSelector: '.b-sch-event-tooltip'
    }, {
      drag: scheduler.eventSelector,
      by: [100, 0],
      dragOnly: true
    }, function (next) {
      t.selectorNotExists('.b-sch-event-tooltip', 'Event tooltip hidden when drag drop starts');
      next();
    }, {
      mouseUp: null
    });
  });
  t.it('Should move event to same resource as target event if dropped on an event', function (t) {
    scheduler = getScheduler({
      barMargin: 0,
      features: {
        eventTooltip: false,
        eventDrag: true
      },
      events: [{
        id: 1,
        name: 'one',
        resourceId: 'r1',
        startDate: new Date(2011, 0, 6),
        endDate: new Date(2011, 0, 7)
      }, {
        id: 2,
        name: 'two',
        resourceId: 'r2',
        startDate: new Date(2011, 0, 6),
        endDate: new Date(2011, 0, 7)
      }]
    });
    t.chain({
      drag: scheduler.eventSelector + ':contains(two)',
      to: scheduler.eventSelector + ':contains(one)'
    }, function () {
      t.expect(scheduler.eventStore.getById(2).resourceId).toBe('r1');
    });
  });
  t.it('Should not allow dragging if readOnly', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var box;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              scheduler = t.getScheduler({
                readOnly: true,
                features: {
                  eventEdit: true
                }
              });
              _context.next = 3;
              return t.waitForProjectReady();

            case 3:
              box = document.querySelector(scheduler.eventSelector).getBoundingClientRect();
              t.wontFire(scheduler, 'beforeeventdrag');
              t.wontFire(scheduler, 'eventdragstart');
              t.chain({
                drag: scheduler.eventSelector,
                by: [-10, 0]
              }, function (next, element) {
                var newBox = element.getBoundingClientRect();
                t.is(newBox.left, box.left, 'Event not moved when dragged');
              });

            case 7:
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
  t.it('Should be able to drag when using AssignmentStore', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      resources: [{
        id: 'r1',
        name: 'Mike'
      }, {
        id: 'r2',
        name: 'Linda'
      }],
      events: [{
        id: 1,
        startDate: new Date(2017, 0, 1, 10),
        endDate: new Date(2017, 0, 1, 12)
      }],
      assignments: [{
        resourceId: 'r1',
        eventId: 1
      }, {
        resourceId: 'r2',
        eventId: 1
      }],
      startDate: new Date(2017, 0, 1, 6),
      endDate: new Date(2017, 0, 1, 20),
      viewPreset: 'hourAndDay',
      enableEventAnimations: false
    });
    t.chain({
      drag: '[data-event-id="1"]',
      by: [65, 0]
    }, function () {
      t.is(scheduler.eventStore.first.startDate, new Date(2017, 0, 1, 11), 'startDate updated');

      var _Array$from = Array.from(document.querySelectorAll('[data-event-id="1"]')),
          _Array$from2 = _slicedToArray(_Array$from, 2),
          first = _Array$from2[0],
          second = _Array$from2[1];

      t.is(first.getBoundingClientRect().left, second.getBoundingClientRect().left, 'Both instances moved');
    });
  });
  t.it('Should be able to abort a drag when using AssignmentStore', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      resources: [{
        id: 'r1',
        name: 'Mike'
      }, {
        id: 'r2',
        name: 'Linda'
      }],
      events: [{
        id: 1,
        startDate: new Date(2017, 0, 1, 10),
        endDate: new Date(2017, 0, 1, 12)
      }],
      assignments: [{
        resourceId: 'r1',
        eventId: 1
      }, {
        resourceId: 'r2',
        eventId: 1
      }],
      startDate: new Date(2017, 0, 1, 6),
      endDate: new Date(2017, 0, 1, 20),
      viewPreset: 'hourAndDay',
      enableEventAnimations: false
    });
    t.wontFire(scheduler.eventStore, 'update');
    t.wontFire(scheduler.assignmentStore, 'update');
    t.chain({
      drag: '[data-event-id="1"]',
      by: [65, 0],
      dragOnly: true
    }, {
      type: '[ESC]'
    });
  });
  t.it('Should be able to reassign when using AssignmentStore', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      resources: [{
        id: 'r1',
        name: 'Mike'
      }, {
        id: 'r2',
        name: 'Linda'
      }, {
        id: 'r3',
        name: 'Jenny'
      }],
      events: [{
        id: 1,
        startDate: new Date(2017, 0, 1, 10),
        endDate: new Date(2017, 0, 1, 12)
      }],
      assignments: [{
        id: 1,
        resourceId: 'r1',
        eventId: 1
      }, {
        id: 2,
        resourceId: 'r2',
        eventId: 1
      }],
      startDate: new Date(2017, 0, 1, 6),
      endDate: new Date(2017, 0, 1, 20),
      viewPreset: 'hourAndDay',
      enableEventAnimations: false,
      eventRenderer: function eventRenderer(_ref2) {
        var eventRecord = _ref2.eventRecord,
            resourceRecord = _ref2.resourceRecord,
            renderData = _ref2.renderData;
        renderData.cls.add(resourceRecord.id);
        return eventRecord.id + resourceRecord.id;
      }
    });
    t.chain({
      drag: '[data-event-id="1"]',
      by: [0, 120]
    }, function () {
      t.isDeeply(scheduler.assignmentStore.map(function (r) {
        return r.resourceId;
      }), ['r3', 'r2'], 'Assignment updated');
      t.isGreater(document.querySelector('.r3').getBoundingClientRect().top, document.querySelector('.r2').getBoundingClientRect().bottom, 'Moved below');
    });
  }); // https://app.assembla.com/spaces/bryntum/tickets/8258

  t.it('Dragging event outside of timeline when using AssignmentStore', function (t) {
    scheduler = new Scheduler({
      appendTo: document.body,
      columns: [{
        text: 'name',
        field: 'name',
        locked: true
      }],
      resources: [{
        id: 'r1',
        name: 'Mike'
      }, {
        id: 'r2',
        name: 'Linda'
      }],
      events: [{
        id: 1,
        startDate: new Date(2017, 0, 1, 10),
        endDate: new Date(2017, 0, 1, 12)
      }],
      assignments: [{
        resourceId: 'r1',
        eventId: 1
      }, {
        resourceId: 'r2',
        eventId: 1
      }],
      startDate: new Date(2017, 0, 1, 6),
      endDate: new Date(2017, 0, 1, 20),
      viewPreset: 'hourAndDay',
      enableEventAnimations: false,
      features: {
        eventTooltip: false
      }
    });
    t.wontFire(scheduler.eventStore, 'update');
    t.wontFire(scheduler.assignmentStore, 'update');
    t.chain({
      drag: '[data-event-id="1"]',
      by: [-400, 0],
      dragOnly: true
    }, {
      type: '[ESC]'
    }, function () {
      t.pass('No error thrown');
    });
  });
  t.it('Dragging event to overlay splitter', function (t) {
    scheduler = t.getScheduler(); // The bug was because the elementFromPoint of the left end of the dragged
    // event was over the expanded, touchable splitter zone, so the resolveResource
    // could not ascertain the resource the event was being dragged over.
    // This class must be added to reproduce that scenario since we do not test on touch devices!

    scheduler.element.classList.add('b-touch');
    t.chain({
      drag: '[data-event-id=1]',
      by: [-99, 0]
    }, {
      drag: '[data-event-id=1]',
      by: [0, scheduler.rowHeight]
    }, // Should have been dragged down to the next resource row.
    function () {
      t.is(scheduler.eventStore.first.resourceId, 'r2', 'Drag to next row has succeeded');
    });
  });
  t.it('Should be able to drag event to before the start of the time axis', function (t) {
    scheduler = t.getScheduler();
    t.chain({
      drag: '[data-event-id=1]',
      by: [-250, 0]
    }, function () {
      t.is(scheduler.eventStore.first.startDate, new Date(2011, 0, 1, 12), 'startDate has changed');
    });
  }); // https://app.assembla.com/spaces/bryntum/tickets/6787

  t.it('Invalid drop should make no influence on event changing', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventEdit: true
      }
    });
    t.isFiredWithSignature(scheduler, 'afterEventDrop', function (_ref3) {
      var valid = _ref3.valid;
      return !valid;
    }, 'Drop operation must be invalid for this test');
    t.chain( // Make invalid drop by dragging outside the view
    function (next) {
      return t.dragTo('[data-event-id=1]', '.b-grid-cell', next, null, null, null, null, [-10, '50%']);
    }, // Open editor, change something in the event and save
    {
      dblclick: '[data-event-id=1]'
    }, {
      dblclick: '.b-eventeditor .b-textfield'
    }, {
      type: 'test',
      target: '.b-eventeditor .b-textfield input'
    }, {
      click: '.b-button.b-green'
    }, // Expect changes applied
    {
      waitForSelector: scheduler.eventSelector + ':contains(test)'
    }, // Click outside the event shouldn't lead to the failure
    {
      click: '.b-sch-header-row-main .b-sch-header-timeaxis-cell',
      desc: 'No exceptions expected'
    });
  }); // https://app.assembla.com/spaces/bryntum/tickets/5290/details

  t.it('Drop should include browser event', function (t) {
    var dropped = false;
    scheduler = t.getScheduler({
      listeners: {
        eventDrop: function eventDrop(_ref4) {
          var context = _ref4.context,
              event = _ref4.event;
          t.is(event.target.innerText.trim(), 'Assignment 2', 'Correct target element');
          t.is(context.targetEventRecord.id, 2, 'Correct target event record');
          t.is(context.newResource.id, 'r2', 'Correct target resource record');
          dropped = true;
        }
      }
    });
    t.chain({
      drag: '.event1',
      to: '.event2'
    }, {
      waitFor: function waitFor() {
        return dropped;
      }
    });
  });
  t.it('Should be able to invalidate drag in `beforeEventDropFinalize` listener', function (t) {
    var dropped = false;
    scheduler = t.getScheduler({
      listeners: {
        beforeEventDropFinalize: function beforeEventDropFinalize(_ref5) {
          var event = _ref5.event,
              context = _ref5.context;
          context.valid = false;
          t.is(event.target.innerText.trim(), 'Assignment 2', 'Correct target element');
          t.is(context.targetEventRecord.id, 2, 'Correct target event record');
          t.is(context.newResource.id, 'r2', 'Correct target resource record');
          dropped = true;
        }
      }
    });
    t.chain({
      drag: '.event1',
      to: '.event2'
    }, {
      waitFor: function waitFor() {
        return dropped;
      }
    });
  });
  t.it('Should show message and block drop if validator returns object with `valid` false', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventDrag: {
                    validatorFn: function validatorFn() {
                      return {
                        valid: false,
                        message: 'msg'
                      };
                    }
                  }
                },
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }]
              });

            case 2:
              scheduler = _context2.sent;
              t.wontFire(scheduler.eventStore, 'change');
              t.chain({
                drag: scheduler.eventSelector,
                by: [100, 0],
                dragOnly: true
              }, {
                waitForSelector: '.b-tooltip .b-sch-tip-message:textEquals(msg)'
              }, {
                mouseUp: null
              });

            case 5:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref6.apply(this, arguments);
    };
  }());
  t.it('Should not show message if validator returns object with `valid` true', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventDrag: {
                    validatorFn: function validatorFn(_ref8, event) {
                      var resourceRecord = _ref8.resourceRecord,
                          eventRecord = _ref8.eventRecord,
                          start = _ref8.start,
                          end = _ref8.end;
                      return {
                        valid: true
                      };
                    }
                  }
                },
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }]
              });

            case 2:
              scheduler = _context3.sent;
              t.firesOnce(scheduler.eventStore, 'change');
              t.chain({
                drag: scheduler.eventSelector,
                by: [100, 0],
                dragOnly: true
              }, {
                waitForSelector: '.b-tooltip .b-sch-tip-message:empty'
              }, {
                mouseUp: null
              });

            case 5:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref7.apply(this, arguments);
    };
  }());
  t.it('Should consider undefined return value as valid action', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventDrag: {
                    validatorFn: function validatorFn(_ref10, event) {
                      var resourceRecord = _ref10.resourceRecord,
                          eventRecord = _ref10.eventRecord,
                          start = _ref10.start,
                          end = _ref10.end;
                    }
                  }
                },
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 4),
                  endDate: new Date(2011, 0, 6)
                }]
              });

            case 2:
              scheduler = _context4.sent;
              t.firesOnce(scheduler.eventStore, 'change');
              t.chain({
                drag: scheduler.eventSelector,
                by: [100, 0]
              });

            case 5:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref9.apply(this, arguments);
    };
  }());
});