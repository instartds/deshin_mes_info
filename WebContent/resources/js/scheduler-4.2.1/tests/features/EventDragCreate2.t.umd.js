function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    var _scheduler, _scheduler$destroy;

    (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : (_scheduler$destroy = _scheduler.destroy) === null || _scheduler$destroy === void 0 ? void 0 : _scheduler$destroy.call(_scheduler);
  }); // #8943 - https://app.assembla.com/spaces/bryntum/tickets/8943

  t.it('Should not crash after drag-create', function (t) {
    var eventDragged = false;
    scheduler = t.getScheduler({
      appendTo: document.body,
      resources: [{
        id: 'r1',
        name: 'Resource 1'
      }],
      events: [],
      features: {
        eventEdit: true
      },
      listeners: {
        eventDrag: function eventDrag() {
          eventDragged = true;
        }
      }
    });
    t.chain({
      drag: '.b-sch-timeaxis-cell',
      offset: [100, '50%'],
      by: [200, 0]
    }, {
      waitForSelector: '.b-eventeditor'
    }, {
      type: '123[ENTER]'
    }, {
      waitForSelectorNotFound: '.b-eventeditor'
    }, {
      drag: scheduler.eventSelector,
      by: [50, 0]
    }, function () {
      t.ok(eventDragged, 'Event dragged w/o issues');
    });
  }); // #8943 - https://app.assembla.com/spaces/bryntum/tickets/8943

  t.it('Should not crash after drag-create with Scheduler in multi-assignment mode', function (t) {
    var eventDragged = false;
    scheduler = t.getScheduler({
      appendTo: document.body,
      resources: [{
        id: 'r1',
        name: 'Resource 1'
      }],
      events: [{
        id: 'e1',
        name: '123',
        startDate: new Date(2011, 0, 5),
        endDate: new Date(2011, 0, 6)
      }],
      assignments: [{
        id: 'a1',
        eventId: 'e1',
        resourceId: 'r1'
      }],
      features: {
        eventEdit: true,
        eventTooltip: false
      },
      listeners: {
        eventDrag: function eventDrag() {
          eventDragged = true;
        }
      }
    });
    t.chain({
      drag: '.b-sch-timeaxis-cell',
      offset: [100, '50%'],
      by: [200, 0]
    }, {
      waitForSelector: '.b-eventeditor'
    }, {
      type: '123[ENTER]'
    }, {
      waitForSelectorNotFound: '.b-eventeditor'
    }, {
      drag: scheduler.eventSelector + ' .b-sch-dirty-new',
      by: [50, 0]
    }, function () {
      t.ok(eventDragged, 'Event dragged w/o issues');
    });
  }); // https://github.com/bryntum/support/issues/1376

  t.it('Should not get stuck after minimal drag create', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                events: []
              });

            case 2:
              scheduler = _context.sent;
              t.chain({
                drag: '.b-sch-timeaxis-cell',
                offset: [100, '50%'],
                by: [3, 0]
              }, function () {
                t.selectorExists('.b-sch-event-wrap', 'New event created');
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
  }()); // https://github.com/bryntum/support/issues/2056

  t.it('Should be possible to set resource id in beforeEventAdd handler', /*#__PURE__*/function () {
    var _ref2 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: true,
                  eventTooltip: false
                },
                events: []
              });

            case 2:
              scheduler = _context2.sent;
              scheduler.on({
                beforeEventAdd: function beforeEventAdd(_ref3) {
                  var eventRecord = _ref3.eventRecord,
                      resourceRecords = _ref3.resourceRecords;
                  eventRecord.resourceId = resourceRecords[0].id;
                }
              });
              _context2.next = 6;
              return t.dragBy('.b-sch-timeaxis-cell', [100, 0], null, null, null, null, [100, '50%']);

            case 6:
              _context2.next = 8;
              return t.type('.b-textfield input[name="name"]', 'Foo');

            case 8:
              _context2.next = 10;
              return t.click('button[data-ref="saveButton"]');

            case 10:
              _context2.next = 12;
              return t.waitForSelector('.b-sch-event:contains(Foo)');

            case 12:
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
  t.it('Should be possible to change resource field name', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getSchedulerAsync({
                features: {
                  eventEdit: {
                    editorConfig: {
                      items: {
                        resourceField: {
                          name: 'resourceId' // 'resource' is used by default

                        }
                      }
                    }
                  },
                  eventTooltip: false
                },
                events: []
              });

            case 2:
              scheduler = _context3.sent;
              _context3.next = 5;
              return t.dragBy('.b-sch-timeaxis-cell', [100, 0], null, null, null, null, [100, '50%']);

            case 5:
              _context3.next = 7;
              return t.type('.b-textfield input[name="name"]', 'Foo');

            case 7:
              _context3.next = 9;
              return t.click('button[data-ref="saveButton"]');

            case 9:
              _context3.next = 11;
              return t.waitForSelector('.b-sch-event:contains(Foo)');

            case 11:
            case "end":
              return _context3.stop();
          }
        }
      }, _callee3);
    }));

    return function (_x3) {
      return _ref4.apply(this, arguments);
    };
  }());
  t.it('Should ignore click on phantom event', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var livesOk;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                events: [],
                features: {
                  eventEdit: true
                }
              });

            case 2:
              scheduler = _context4.sent;
              livesOk = t.livesOkAsync('Click on temp event does not throw');
              _context4.next = 6;
              return t.dragBy({
                source: '.b-sch-timeaxis-cell',
                offset: [50, '50%'],
                delta: [100, 0]
              });

            case 6:
              _context4.next = 8;
              return t.waitForSelector(scheduler.unreleasedEventSelector);

            case 8:
              _context4.next = 10;
              return t.click('.b-sch-event');

            case 10:
              _context4.next = 12;
              return t.waitForSelectorNotFound(scheduler.unreleasedEventSelector);

            case 12:
              livesOk();

            case 13:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x4) {
      return _ref5.apply(this, arguments);
    };
  }());
});