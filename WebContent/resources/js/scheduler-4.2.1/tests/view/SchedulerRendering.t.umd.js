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
    var _scheduler;

    return (_scheduler = scheduler) === null || _scheduler === void 0 ? void 0 : _scheduler.destroy();
  });
  t.it('Should resume refresh when resource store is reduced', /*#__PURE__*/function () {
    var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
      return regeneratorRuntime.wrap(function _callee2$(_context2) {
        while (1) {
          switch (_context2.prev = _context2.next) {
            case 0:
              _context2.next = 2;
              return t.getSchedulerAsync({
                resourceStore: t.getResourceStore2({}, 100),
                eventStore: t.getEventStore({}, 100)
              });

            case 2:
              scheduler = _context2.sent;
              t.chain({
                waitForSelector: '.b-grid-row'
              }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        scheduler.suspendRefresh();
                        scheduler.endDate = new Date(2011, 0, 9);
                        scheduler.project = {
                          eventStore: {
                            useRawData: true,
                            data: [{
                              id: 1,
                              startDate: new Date(2011, 0, 5),
                              duration: 5
                            }]
                          },
                          resourceStore: {
                            useRawData: true,
                            data: [{
                              id: 1,
                              name: 'Foo'
                            }]
                          },
                          assignmentStore: {
                            useRawData: true,
                            data: [{
                              id: 1,
                              resource: 1,
                              event: 1
                            }]
                          }
                        };
                        scheduler.resumeRefresh(true); // Test should not throw before dataReady is fired

                        _context.next = 6;
                        return scheduler.project.await('dataReady', false);

                      case 6:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              })), {
                waitFor: function waitFor() {
                  return document.querySelectorAll('.b-grid-row').length === 2;
                }
              });

            case 4:
            case "end":
              return _context2.stop();
          }
        }
      }, _callee2);
    }));

    return function (_x) {
      return _ref.apply(this, arguments);
    };
  }());
  t.it('Should render event name when name field is defined with dataSource', /*#__PURE__*/function () {
    var _ref3 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee3(t) {
      var CustomEventModel;
      return regeneratorRuntime.wrap(function _callee3$(_context3) {
        while (1) {
          switch (_context3.prev = _context3.next) {
            case 0:
              CustomEventModel = /*#__PURE__*/function (_EventModel) {
                _inherits(CustomEventModel, _EventModel);

                var _super = _createSuper(CustomEventModel);

                function CustomEventModel() {
                  _classCallCheck(this, CustomEventModel);

                  return _super.apply(this, arguments);
                }

                _createClass(CustomEventModel, null, [{
                  key: "fields",
                  get: function get() {
                    return [{
                      name: 'name',
                      dataSource: 'desc'
                    }];
                  }
                }]);

                return CustomEventModel;
              }(EventModel);

              _context3.next = 3;
              return t.getScheduler({
                startDate: new Date(2017, 0, 1, 10),
                endDate: new Date(2017, 0, 1, 12),
                resources: [{
                  id: 'r1',
                  name: 'Mike'
                }],
                eventStore: {
                  modelClass: CustomEventModel,
                  data: [{
                    id: 1,
                    resourceId: 'r1',
                    startDate: new Date(2017, 0, 1, 10),
                    endDate: new Date(2017, 0, 1, 12),
                    desc: 'Other field'
                  }]
                }
              });

            case 3:
              scheduler = _context3.sent;
              _context3.next = 6;
              return t.waitForSelector('.b-sch-event:contains(Other field)');

            case 6:
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
  t.it('Should not flood assignmentStore changes when events are added', /*#__PURE__*/function () {
    var _ref4 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee4(t) {
      var eventStore;
      return regeneratorRuntime.wrap(function _callee4$(_context4) {
        while (1) {
          switch (_context4.prev = _context4.next) {
            case 0:
              _context4.next = 2;
              return t.getScheduler({
                events: [],
                resourceStore: t.getResourceStore2(null, 100)
              });

            case 2:
              scheduler = _context4.sent;
              t.firesOnce(scheduler.assignmentStore, 'change');
              eventStore = t.getEventStore(null, 1000);
              scheduler.eventStore.add(eventStore.toJSON());
              _context4.next = 8;
              return t.waitForSelector('.b-sch-event:contains(Assignment 1)');

            case 8:
            case "end":
              return _context4.stop();
          }
        }
      }, _callee4);
    }));

    return function (_x3) {
      return _ref4.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2386

  t.it('Events should not disappear when setting resources twice', /*#__PURE__*/function () {
    var _ref5 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee5(t) {
      var resources;
      return regeneratorRuntime.wrap(function _callee5$(_context5) {
        while (1) {
          switch (_context5.prev = _context5.next) {
            case 0:
              resources = [{
                id: 'r1',
                name: 'Mike'
              }, {
                id: 'r2',
                name: 'Linda'
              }, {
                id: 'r3',
                name: 'Don'
              }, {
                id: 'r4',
                name: 'Karen'
              }, {
                id: 'r5',
                name: 'Doug'
              }, {
                id: 'r6',
                name: 'Peter'
              }];
              _context5.next = 3;
              return t.getSchedulerAsync({
                resources: resources
              });

            case 3:
              scheduler = _context5.sent;
              scheduler.resources = resources;
              _context5.next = 7;
              return t.waitForSelector('[data-event-id=1]');

            case 7:
              t.elementIsVisible('[data-event-id=1]', 'Event is visible after set resources first time');
              scheduler.resources = resources;
              _context5.next = 11;
              return t.waitForSelector('[data-event-id=1]');

            case 11:
              t.elementIsVisible('[data-event-id=1]', 'Event is visible after set resources second time');

            case 12:
            case "end":
              return _context5.stop();
          }
        }
      }, _callee5);
    }));

    return function (_x4) {
      return _ref5.apply(this, arguments);
    };
  }()); // https://github.com/bryntum/support/issues/2935

  t.it('Should handle resuming refresh after dataset in scrolled Scheduler', /*#__PURE__*/function () {
    var _ref6 = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee6(t) {
      return regeneratorRuntime.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              _context6.next = 2;
              return t.getSchedulerAsync({
                resources: ArrayHelper.populate(100, function (i) {
                  return {
                    id: i + 1,
                    name: 'Resource ' + (i + 1)
                  };
                })
              });

            case 2:
              scheduler = _context6.sent;
              _context6.next = 5;
              return scheduler.scrollToBottom();

            case 5:
              scheduler.suspendRefresh();
              scheduler.resourceStore.data = [{
                id: 1,
                name: 'Resource 1'
              }];
              _context6.next = 9;
              return scheduler.resumeRefresh(true);

            case 9:
              t.is(scheduler.rowManager.rows.length, 1, 'RowManager has single row');
              t.is(scheduler.rowManager.topRow.top, 0, 'With correct position');
              t.selectorCountIs('[data-region=locked] .b-grid-row', 1, 'And only a single row in DOM');

            case 12:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6);
    }));

    return function (_x5) {
      return _ref6.apply(this, arguments);
    };
  }());
});