function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _unsupportedIterableToArray(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

function _iterableToArrayLimit(arr, i) { var _i = arr && (typeof Symbol !== "undefined" && arr[Symbol.iterator] || arr["@@iterator"]); if (_i == null) return; var _arr = []; var _n = true; var _d = false; var _s, _e; try { for (_i = _i.call(arr); !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler1, scheduler2;
  t.beforeEach(function () {
    return Scheduler.destroy(scheduler1, scheduler2);
  }); // https://github.com/bryntum/bryntum-suite/issues/1158

  t.it('Should be able to share a CrudManager between two Schedulers', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var _scheduler1$resourceS, _scheduler1$resourceS2, newResource, _scheduler2$eventStor, _scheduler2$eventStor2, event1, event2;

      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              t.mockUrl('load', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'load',
                  events: {
                    rows: []
                  },
                  resources: {
                    rows: [{
                      id: 1,
                      name: 'Default'
                    }]
                  }
                })
              });
              scheduler1 = new Scheduler({
                cls: 'scheduler1',
                appendTo: document.body,
                width: 500,
                height: 300,
                startDate: new Date(2020, 2, 1),
                endDate: new Date(2020, 2, 8),
                enableEventAnimations: false,
                columns: [{
                  text: 'Name',
                  field: 'name'
                }],
                crudManager: {
                  transport: {
                    load: {
                      url: 'load'
                    },
                    sync: {
                      url: 'sync'
                    }
                  },
                  autoLoad: false,
                  autoSync: false
                }
              });
              scheduler2 = new Scheduler({
                cls: 'scheduler2',
                appendTo: document.body,
                width: 500,
                height: 300,
                startDate: new Date(2020, 2, 1),
                endDate: new Date(2020, 2, 8),
                enableEventAnimations: false,
                columns: [{
                  text: 'Name',
                  field: 'name'
                }],
                crudManager: scheduler1.crudManager
              });
              _context.next = 5;
              return scheduler1.crudManager.load();

            case 5:
              _scheduler1$resourceS = scheduler1.resourceStore.add({
                name: 'New resource'
              }), _scheduler1$resourceS2 = _slicedToArray(_scheduler1$resourceS, 1), newResource = _scheduler1$resourceS2[0], _scheduler2$eventStor = scheduler2.eventStore.add([{
                name: 'Event 1',
                resourceId: 1,
                startDate: '2020-03-01',
                endDate: '2020-03-03'
              }, {
                name: 'Event 2',
                resourceId: newResource.id,
                startDate: '2020-03-01',
                endDate: '2020-03-03'
              }]), _scheduler2$eventStor2 = _slicedToArray(_scheduler2$eventStor, 2), event1 = _scheduler2$eventStor2[0], event2 = _scheduler2$eventStor2[1];
              t.mockUrl('sync', {
                responseText: JSON.stringify({
                  success: true,
                  type: 'sync',
                  events: {
                    rows: [{
                      $PhantomId: event1.id,
                      id: 1
                    }, {
                      $PhantomId: event2.id,
                      id: 2,
                      resourceId: 2
                    }]
                  },
                  resources: {
                    rows: [{
                      $PhantomId: newResource.id,
                      id: 2
                    }]
                  }
                })
              });
              t.is(scheduler2.crudManager, scheduler2.crudManager, 'both schedulers use the same crud manager instance');
              t.is(scheduler2.crudManager.project, scheduler2.project, 'scheduler1.project refers to scheduler2.crudManager.project');
              t.is(scheduler1.crudManager.project, scheduler1.project, 'scheduler2.project refers to scheduler2.crudManager.project'); // Wait for first render to avoid stepping into rendering logic during debug

              _context.next = 12;
              return t.waitForSelector('[data-resource-id="1"]', '.scheduler1');

            case 12:
              _context.next = 14;
              return t.waitForSelector('[data-resource-id="1"]', '.scheduler2');

            case 14:
              _context.next = 16;
              return scheduler2.crudManager.sync();

            case 16:
              _context.next = 18;
              return t.waitForSelector('[data-event-id="1"]', '.scheduler1');

            case 18:
              _context.next = 20;
              return t.waitForSelector('[data-event-id="2"]', '.scheduler1');

            case 20:
              _context.next = 22;
              return t.waitForSelector('[data-event-id="1"]', '.scheduler2');

            case 22:
              _context.next = 24;
              return t.waitForSelector('[data-event-id="2"]', '.scheduler2');

            case 24:
              t.selectorCountIs('.b-sch-event', 4, 'No ghost event elements');
              t.selectorCountIs('.scheduler1 .b-sch-event', 2, 'No ghost event elements in scheduler1');
              t.selectorCountIs('.scheduler2 .b-sch-event', 2, 'No ghost event elements in scheduler2');
              t.is(scheduler1.getElementFromEventRecord(event1), document.querySelector('.scheduler1 [data-event-id="1"] .b-sch-event'), 'Event 1 element is resolved correctly');
              t.is(scheduler1.getElementFromEventRecord(event2), document.querySelector('.scheduler1 [data-event-id="2"] .b-sch-event'), 'Event 2 element is resolved correctly');
              t.is(scheduler2.getElementFromEventRecord(event1), document.querySelector('.scheduler2 [data-event-id="1"] .b-sch-event'), 'Event 1 element is resolved correctly');
              t.is(scheduler2.getElementFromEventRecord(event2), document.querySelector('.scheduler2 [data-event-id="2"] .b-sch-event'), 'Event 2 element is resolved correctly');

            case 31:
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
});