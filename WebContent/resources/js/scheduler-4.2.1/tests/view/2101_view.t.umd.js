function _typeof(obj) { "@babel/helpers - typeof"; if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { var hasNativeReflectConstruct = _isNativeReflectConstruct(); return function _createSuperInternal() { var Super = _getPrototypeOf(Derived), result; if (hasNativeReflectConstruct) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (_typeof(call) === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Boolean.prototype.valueOf.call(Reflect.construct(Boolean, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
  });
  t.it('Basic view functionality tests', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
      var newEvent;
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return t.getSchedulerAsync({
                emptyText: 'empty_schedule',
                eventRenderer: function eventRenderer(_ref2) {
                  var resourceRecord = _ref2.resourceRecord;
                  return resourceRecord.name;
                },
                animateRemovingRows: false
              });

            case 2:
              scheduler = _context.sent;
              // actually, a full render is triggered in case rows height change because of overlapping events
              // but since rendering only renders events in view it is really fast
              //t.wontFire(scheduler.rowManager, 'fullrender', 'full render should not be triggered after event is added');
              newEvent = new EventModel({
                startDate: scheduler.startDate,
                endDate: scheduler.endDate,
                cls: 'foo',
                resourceId: scheduler.resourceStore.first.id
              });
              scheduler.eventStore.add(newEvent);
              scheduler.resourceStore.first.name = 'BLARGH';
              _context.next = 8;
              return t.waitForProjectReady();

            case 8:
              t.contentLike(scheduler.getElementsFromEventRecord(newEvent)[0], 'BLARGH', 'Event row should be refreshed when resource is updated');
              newEvent.resourceId = 'BLARGH';
              _context.next = 12;
              return t.waitForProjectReady();

            case 12:
              // event animations are disabled in IE11 so when event resource is changed element is not getting removed with
              // a timeout but instantly. Element is removed eventually in normal browsers too, so we just wait for it to happen.
              // If at some point event stays rendered (e.g. cache logic change) just add condition for IE to still use
              // waitForSelectorNotFound
              t.waitForSelectorNotFound(':not(.b-released) > .b-sch-event.foo', function () {
                t.pass('Event removed from DOM after remove');
              });
              scheduler.resourceStore.remove(scheduler.resourceStore.first);
              _context.next = 16;
              return t.waitForProjectReady();

            case 16:
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
  t.it('Multiple events per resource', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      var MyEvent;
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              MyEvent = /*#__PURE__*/function (_EventModel) {
                _inherits(MyEvent, _EventModel);

                var _super = _createSuper(MyEvent);

                function MyEvent() {
                  _classCallCheck(this, MyEvent);

                  return _super.apply(this, arguments);
                }

                _createClass(MyEvent, null, [{
                  key: "fields",
                  get: function get() {
                    return [{
                      name: 'resourceId',
                      dataSource: 'resId'
                    }];
                  }
                }]);

                return MyEvent;
              }(EventModel);

              _context2.next = 3;
              return t.getSchedulerAsync({
                startDate: new Date(2018, 4, 14),
                endDate: new Date(2018, 4, 21),
                eventStore: {
                  modelClass: MyEvent,
                  data: [{
                    id: 1,
                    name: 'First',
                    startDate: '2018-05-15',
                    endDate: '2018-05-16',
                    resId: 'r1'
                  }, {
                    id: 2,
                    name: 'Second',
                    startDate: '2018-05-18',
                    endDate: '2018-05-19',
                    resId: 'r1'
                  }]
                }
              });

            case 3:
              scheduler = _context2.sent;
              t.waitForSelector('.b-sch-event:contains(Second)', function () {
                var eventEls = document.querySelectorAll('.b-sch-event');
                t.is(eventEls.length, 2, '2 events visible');
                t.is(eventEls[0].innerText.trim(), 'First');
                t.is(eventEls[1].innerText.trim(), 'Second');
              });

            case 5:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x2) {
      return _ref3.apply(this, arguments);
    };
  }());
  t.it('Removing a resource should unassign it from all its events', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var resource, events;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              _context3.next = 2;
              return t.getSchedulerAsync();

            case 2:
              scheduler = _context3.sent;
              resource = scheduler.resourceStore.first;
              events = resource.events;
              t.expect(events.length).toBe(1);
              events[0].name = 'FOO';
              scheduler.resourceStore.remove(resource);
              t.waitForElementNotVisible('.b-sch-event:contains(FOO)', function () {
                events = resource.events;
                t.expect(events.length).toBe(0);
                t.pass('Event unassigned and from DOM after remove');
              });

            case 9:
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
  t.it('Updating an event with no resource should not cause a crash', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var newEvent;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getSchedulerAsync({
                emptyText: 'empty_schedule'
              });

            case 2:
              scheduler = _context4.sent;
              newEvent = new EventModel({
                startDate: scheduler.startDate,
                endDate: scheduler.endDate,
                cls: 'foo'
              });
              scheduler.eventStore.add(newEvent);
              newEvent.name = 'FOO';
              _context4.next = 8;
              return t.waitForProjectReady();

            case 8:
              t.pass('No crash');

            case 9:
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
  t.it('Updating an event with mapped resourceId field should render event properly', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var MyEvent;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              MyEvent = /*#__PURE__*/function (_EventModel2) {
                _inherits(MyEvent, _EventModel2);

                var _super2 = _createSuper(MyEvent);

                function MyEvent() {
                  _classCallCheck(this, MyEvent);

                  return _super2.apply(this, arguments);
                }

                _createClass(MyEvent, null, [{
                  key: "fields",
                  get: function get() {
                    return [{
                      name: 'resourceId',
                      dataSource: 'resId'
                    }];
                  }
                }]);

                return MyEvent;
              }(EventModel);

              _context5.next = 3;
              return t.getSchedulerAsync({
                startDate: new Date(2018, 4, 14),
                endDate: new Date(2018, 4, 21),
                eventStore: {
                  modelClass: MyEvent,
                  data: [{
                    id: 1,
                    startDate: '2018-05-17',
                    endDate: '2018-05-18',
                    resId: 'r1'
                  }]
                }
              });

            case 3:
              scheduler = _context5.sent;
              t.waitForSelector('.b-sch-event', function () {
                var event = scheduler.eventStore.first; // update using batch

                event.beginBatch();
                event.resourceId = 'r2';
                event.endBatch();
                t.selectorCountIs('.b-sch-event', 1, 'Only 1 event visible'); // update without batch

                scheduler.eventStore.first.resourceId = 'r3';
                t.selectorCountIs('.b-sch-event', 1, 'Only 1 event visible');
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
  t.it('Basic API tests', /*#__PURE__*/function () {
    var _ref7 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getSchedulerAsync({
                startDate: new Date(2010, 1, 1),
                endDate: new Date(2010, 5, 1)
              });

            case 2:
              scheduler = _context6.sent;
              t.is(scheduler.getCoordinateFromDate(new Date(2010, 1, 1)), 0);
              t.is(scheduler.getCoordinateFromDate(new Date(2010, 0, 1)), -1);
              t.is(scheduler.getCoordinateFromDate(new Date(2020, 0, 1)), -1);
              t.is(scheduler.resolveResourceRecord(document.querySelector('.b-sch-timeaxis-cell')), scheduler.resourceStore.first, 'resolveResource horizontal');

            case 7:
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
  t.it('getCoordinateFromDate should work when scheduler is inside another DIV', /*#__PURE__*/function () {
    var _ref8 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee7(t) {
      return regeneratorRuntime.wrap(function _callee7$(_context7) {
        while (1) {
          switch (_context7.prev = _context7.next) {
            case 0:
              document.body.innerHTML = '<div id="ct" style="height: 400px;width:800px;position:relative;left:200px;"></div>';
              _context7.next = 3;
              return t.getSchedulerAsync({
                appendTo: document.getElementById('ct'),
                startDate: new Date(2010, 1, 1),
                endDate: new Date(2010, 5, 1),
                columns: [{
                  width: 100,
                  text: 'foo'
                }]
              });

            case 3:
              scheduler = _context7.sent;
              t.is(scheduler.timeAxisViewModel.tickSize, 100); // local schedule coordinates

              t.is(scheduler.getCoordinateFromDate(new Date(2010, 1, 1)), 0);
              t.isApprox(scheduler.getCoordinateFromDate(new Date(2010, 1, 2)), 0.5, 100);
              t.is(scheduler.getDateFromCoordinate(100, 'round', true), new Date(2010, 1, 2)); // coordinates relative to page
              // 200 = container offset,
              // 100 = locked grid column
              // 5 = splitter width
              // 100 = tickSize

              t.isApprox(scheduler.getCoordinateFromDate(new Date(2010, 1, 2), false), 200 + 100 + 5 + 100, 0.5);
              t.is(scheduler.getDateFromCoordinate(200 + 100 + 5 + 100, 'round', false), new Date(2010, 1, 2));

            case 10:
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
  t.it('Should fire "renderEvent" when an event gets updated in the DOM, should fire once for a single event', /*#__PURE__*/function () {
    var _ref9 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee8(t) {
      return regeneratorRuntime.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              scheduler = new Scheduler({
                appendTo: document.body,
                mode: 'horizontal',
                useInitialAnimation: false,
                startDate: new Date(2010, 1, 1),
                endDate: new Date(2010, 1, 3),
                resources: [{
                  id: 1
                }, {
                  id: 2
                }]
              });
              _context8.next = 3;
              return t.waitForProjectReady();

            case 3:
              t.diag('should fire once for a single event');
              scheduler.eventStore.data = [{
                resourceId: 1,
                startDate: new Date(2010, 1, 1),
                endDate: new Date(2010, 1, 2)
              }, {
                resourceId: 2,
                startDate: new Date(2010, 1, 1),
                endDate: new Date(2010, 1, 2)
              }];
              _context8.next = 7;
              return t.waitForProjectReady();

            case 7:
              t.firesOnce(scheduler, 'renderEvent');
              scheduler.eventStore.first.name = 'Foo';

            case 9:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8);
    }));

    return function (_x8) {
      return _ref9.apply(this, arguments);
    };
  }()); // https://www.assembla.com/spaces/bryntum/tickets/1827-investigate-locked-grid-view-ondatarefresh-unnecessary-call/details#

  t.it('Should refresh views once when data changes', /*#__PURE__*/function () {
    var _ref10 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee9(t) {
      return regeneratorRuntime.wrap(function _callee9$(_context9) {
        while (1) {
          switch (_context9.prev = _context9.next) {
            case 0:
              _context9.next = 2;
              return t.getSchedulerAsync();

            case 2:
              scheduler = _context9.sent;
              t.firesOnce(scheduler, 'beforeRenderRows');
              t.firesOnce(scheduler, 'renderRows');
              t.willFireNTimes(scheduler.rowManager, 'renderRow', scheduler.store.count);
              scheduler.store.sort('name', false);

            case 7:
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
  t.it('Should support different row heights', /*#__PURE__*/function () {
    var _ref11 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee10(t) {
      var cell, rowHeightIsCorrect;
      return regeneratorRuntime.wrap(function _callee10$(_context10) {
        while (1) {
          switch (_context10.prev = _context10.next) {
            case 0:
              rowHeightIsCorrect = function _rowHeightIsCorrect() {
                // Row height must be correct
                return cell.offsetHeight === scheduler.rowHeight;
              };

              _context10.next = 3;
              return t.getSchedulerAsync({
                rowHeight: 22,
                barMargin: 1,
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 10)
                }]
              });

            case 3:
              scheduler = _context10.sent;
              cell = document.querySelector('.b-grid-cell');
              t.chain({
                waitForSelector: '.b-sch-event'
              }, {
                waitFor: rowHeightIsCorrect
              }, function (next) {
                scheduler.rowHeight = 30;
                next();
              }, {
                waitFor: rowHeightIsCorrect
              }, function (next) {
                scheduler.rowHeight = 25;
                next();
              }, {
                waitFor: rowHeightIsCorrect
              });

            case 6:
            case "end":
              return _context10.stop();
          }
        }
      }, _callee10);
    }));

    return function (_x10) {
      return _ref11.apply(this, arguments);
    };
  }());
  t.it('Should always draw at least a 1px high bar even if barMargin/rowHeight combination is misconfigured', /*#__PURE__*/function () {
    var _ref12 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee11(t) {
      return regeneratorRuntime.wrap(function _callee11$(_context11) {
        while (1) {
          switch (_context11.prev = _context11.next) {
            case 0:
              _context11.next = 2;
              return t.getSchedulerAsync({
                rowHeight: 20,
                barMargin: 20,
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 10)
                }]
              });

            case 2:
              scheduler = _context11.sent;
              t.chain({
                waitForSelector: '.b-sch-event'
              }, function () {
                var eventEl = document.querySelector('.b-sch-event'),
                    foregroundEl = document.querySelector('.b-sch-foreground-canvas');
                t.isGreaterOrEqual(eventEl.offsetHeight, 1, 'Event element is rendered');
                t.isLessOrEqual(eventEl.getBoundingClientRect().top - foregroundEl.getBoundingClientRect().top, scheduler.rowHeight / 2, 'Event is placed in the top half of the row');
              });

            case 4:
            case "end":
              return _context11.stop();
          }
        }
      }, _callee11);
    }));

    return function (_x11) {
      return _ref12.apply(this, arguments);
    };
  }());
  t.it('should be able to resolve Resource from a Row element, Row child element or an Event element', /*#__PURE__*/function () {
    var _ref13 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee12(t) {
      var resource, row, rowEl, eventElement;
      return regeneratorRuntime.wrap(function _callee12$(_context12) {
        while (1) {
          switch (_context12.prev = _context12.next) {
            case 0:
              _context12.next = 2;
              return t.getSchedulerAsync({
                events: [{
                  id: 1,
                  resourceId: 'r1',
                  startDate: new Date(2011, 0, 6),
                  endDate: new Date(2011, 0, 10)
                }]
              });

            case 2:
              scheduler = _context12.sent;
              resource = scheduler.resourceStore.getById('r1'), row = scheduler.getRowFor(resource), rowEl = row.getElement('normal'), eventElement = document.querySelector('.b-sch-event');
              t.is(scheduler.resolveResourceRecord(eventElement), resource, 'Event element matched to resource record');
              t.is(scheduler.resolveResourceRecord(rowEl), resource, 'Row element matched to resource record');
              t.is(scheduler.resolveResourceRecord(rowEl.firstElementChild), resource, 'Row child element matched to resource record');

            case 7:
            case "end":
              return _context12.stop();
          }
        }
      }, _callee12);
    }));

    return function (_x12) {
      return _ref13.apply(this, arguments);
    };
  }());
  t.it('should support visibleDateRange', /*#__PURE__*/function () {
    var _ref14 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee13(t) {
      return regeneratorRuntime.wrap(function _callee13$(_context13) {
        while (1) {
          switch (_context13.prev = _context13.next) {
            case 0:
              document.body.innerHTML = '<div id="ct" style="height: 400px;width:800px;position:relative;left:200px;"></div>';
              _context13.next = 3;
              return t.getSchedulerAsync({
                appendTo: document.getElementById('ct'),
                startDate: new Date(2010, 1, 1),
                endDate: new Date(2010, 5, 1),
                width: 405,
                columns: [{
                  width: 100,
                  text: 'foo'
                }]
              });

            case 3:
              scheduler = _context13.sent;
              t.is(scheduler.visibleDateRange.startDate, new Date(2010, 1, 1), 'Correct visible start date');
              t.is(scheduler.visibleDateRange.endDate, new Date(2010, 1, 4), 'Correct visible end date');
              _context13.next = 8;
              return scheduler.scrollToDate(new Date(2010, 1, 5));

            case 8:
              t.is(scheduler.visibleDateRange.startDate, new Date(2010, 1, 3), 'Correct visible start date after scroll to Jan 5');
              t.is(scheduler.visibleDateRange.endDate, new Date(2010, 1, 6), 'Correct visible end date after scroll to Jan 5');

            case 10:
            case "end":
              return _context13.stop();
          }
        }
      }, _callee13);
    }));

    return function (_x13) {
      return _ref14.apply(this, arguments);
    };
  }());
  t.it('should update visibleDateRange after zoom', /*#__PURE__*/function () {
    var _ref15 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee14(t) {
      return regeneratorRuntime.wrap(function _callee14$(_context14) {
        while (1) {
          switch (_context14.prev = _context14.next) {
            case 0:
              document.body.innerHTML = '<div id="ct" style="height: 400px;width:800px;position:relative;left:200px;"></div>';
              _context14.next = 3;
              return t.getSchedulerAsync({
                appendTo: document.getElementById('ct'),
                viewPreset: 'weekAndDayLetter',
                startDate: new Date(2020, 5, 1),
                endDate: new Date(2020, 5, 7),
                weekStartDay: 1,
                width: 420,
                columns: [{
                  width: 100,
                  text: 'foo'
                }]
              });

            case 3:
              scheduler = _context14.sent;
              t.is(scheduler.visibleDateRange.startDate, new Date(2020, 5, 1), 'Correct visible start date');
              t.is(scheduler.visibleDateRange.endDate, new Date(2020, 5, 8), 'Correct visible end date');
              scheduler.viewPreset = {
                base: 'weekAndDayLetter',
                shiftUnit: 'day',
                // change one field to make timespan different
                options: {
                  startDate: new Date(2020, 5, 8),
                  endDate: new Date(2020, 5, 15)
                }
              };
              t.is(scheduler.visibleDateRange.startDate, new Date(2020, 5, 8), 'Correct visible start date');
              t.is(scheduler.visibleDateRange.endDate, new Date(2020, 5, 15), 'Correct visible end date');

            case 9:
            case "end":
              return _context14.stop();
          }
        }
      }, _callee14);
    }));

    return function (_x14) {
      return _ref15.apply(this, arguments);
    };
  }());
  t.it('Should not mark non-persistable events as dirty', /*#__PURE__*/function () {
    var _ref16 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee15(t) {
      var MyEvent, _scheduler, dirtyCls;

      return regeneratorRuntime.wrap(function _callee15$(_context15) {
        while (1) {
          switch (_context15.prev = _context15.next) {
            case 0:
              MyEvent = /*#__PURE__*/function (_EventModel3) {
                _inherits(MyEvent, _EventModel3);

                var _super3 = _createSuper(MyEvent);

                function MyEvent() {
                  _classCallCheck(this, MyEvent);

                  return _super3.apply(this, arguments);
                }

                _createClass(MyEvent, [{
                  key: "isPersistable",
                  get: function get() {
                    return this.id === 1;
                  }
                }]);

                return MyEvent;
              }(EventModel);

              _context15.next = 3;
              return t.getSchedulerAsync({
                eventStore: t.getEventStore({
                  modelClass: MyEvent,
                  data: [{
                    id: 1,
                    resourceId: 'r1',
                    startDate: new Date(2011, 0, 6),
                    endDate: new Date(2011, 0, 10)
                  }, {
                    id: 2,
                    resourceId: 'r1',
                    startDate: new Date(2011, 0, 6),
                    endDate: new Date(2011, 0, 10)
                  }]
                })
              });

            case 3:
              scheduler = _context15.sent;
              _scheduler = scheduler, dirtyCls = _scheduler.dirtyCls;
              scheduler.eventStore.first.cls = 'foo';
              scheduler.eventStore.last.cls = 'bar';
              _context15.next = 9;
              return t.waitForProjectReady();

            case 9:
              t.waitForSelector('.bar', function () {
                t.selectorExists("[data-event-id=1] .".concat(dirtyCls), 'persistable event got dirty class');
                t.selectorNotExists("[data-event-id=2] .".concat(dirtyCls), 'not persistable event hasn`t got dirty class');
              });

            case 10:
            case "end":
              return _context15.stop();
          }
        }
      }, _callee15);
    }));

    return function (_x15) {
      return _ref16.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/896

  t.it('Should not duplicate event when calling reassign with autoCommit:true ', /*#__PURE__*/function () {
    var _ref17 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee16(t) {
      return regeneratorRuntime.wrap(function _callee16$(_context16) {
        while (1) {
          switch (_context16.prev = _context16.next) {
            case 0:
              _context16.next = 2;
              return t.getSchedulerAsync({
                eventStore: t.getEventStore({
                  autoCommit: true,
                  data: [{
                    id: 1,
                    resourceId: 'r1',
                    startDate: new Date(2011, 0, 6),
                    duration: 2
                  }]
                })
              });

            case 2:
              scheduler = _context16.sent;
              scheduler.eventStore.first.reassign('r1', 'r2');
              t.selectorCountIs('.b-sch-event', 1);

            case 5:
            case "end":
              return _context16.stop();
          }
        }
      }, _callee16);
    }));

    return function (_x16) {
      return _ref17.apply(this, arguments);
    };
  }());
});