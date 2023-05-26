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

StartTest( /*#__PURE__*/function () {
  var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
    var MyResource, myResourceFields, MyEvent, resourceStore, eventStore, project, event;
    return regeneratorRuntime.wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            t.ok(EventModel.fieldMap.startDate, 'Event#startDate');
            t.ok(EventModel.fieldMap.endDate, 'Event#endDate'); // Differs for core and basic engines

            t.isGreater(EventModel.$meta.fields.defs.length, 18, 'Event fields');

            MyResource = /*#__PURE__*/function (_ResourceModel) {
              _inherits(MyResource, _ResourceModel);

              var _super = _createSuper(MyResource);

              function MyResource() {
                _classCallCheck(this, MyResource);

                return _super.apply(this, arguments);
              }

              _createClass(MyResource, null, [{
                key: "fields",
                get: function get() {
                  return [{
                    name: 'id',
                    dataSource: 'myId'
                  }, {
                    name: 'name',
                    dataSource: 'myName'
                  }, {
                    name: 'customName',
                    dataSource: 'name'
                  }];
                }
              }]);

              return MyResource;
            }(ResourceModel);

            myResourceFields = MyResource.$meta.fields.defs; // Differs for core and basic engines

            t.isGreater(myResourceFields.length, 12, 'Correct total field count for resource');

            MyEvent = /*#__PURE__*/function (_EventModel) {
              _inherits(MyEvent, _EventModel);

              var _super2 = _createSuper(MyEvent);

              function MyEvent() {
                _classCallCheck(this, MyEvent);

                return _super2.apply(this, arguments);
              }

              _createClass(MyEvent, null, [{
                key: "fields",
                get: function get() {
                  // Should be ok for implementor to define their own fields with 'our' default names.
                  return [{
                    name: 'name',
                    dataSource: 'myName'
                  }, {
                    name: 'startDate',
                    dataSource: 'myStartDate',
                    type: 'date'
                  }, {
                    name: 'customStartDate',
                    dataSource: 'startDate',
                    type: 'date'
                  }, {
                    name: 'resourceId',
                    dataSource: 'myResourceId'
                  }];
                }
              }]);

              return MyEvent;
            }(EventModel);

            resourceStore = new ResourceStore({
              modelClass: MyResource,
              data: [{
                myId: 'c1',
                myName: 'Foo'
              }, {
                myId: 'c2',
                myName: 'Bar'
              }]
            });
            eventStore = new EventStore({
              modelClass: MyEvent,
              data: [{
                myResourceId: 'c1',
                myName: 'Linda',
                myStartDate: '2010-11-09',
                endDate: '2010-12-09'
              }, {
                myResourceId: 'c2',
                myName: 'Foo',
                myStartDate: '2010-11-09',
                endDate: '2010-12-09'
              }]
            }); // Tie them together

            project = new ProjectModel({
              eventStore: eventStore,
              resourceStore: resourceStore
            });
            _context.next = 12;
            return project.commitAsync();

          case 12:
            event = eventStore.first;
            t.is(event.data.myResourceId, 'c1', 'record.data.myResourceId');
            t.is(event.get('myResourceId'), 'c1', "record.get('myResourceId')");
            t.is(event.resourceId, 'c1', 'resource.resourceId');
            t.is(event.get('myStartDate'), new Date(2010, 10, 9), "record.get('myStartDate')");
            t.isDateEqual(event.startDate, new Date(2010, 10, 9), 'record.startDate');
            t.is(event.resource, resourceStore.first, 'event#resource located the resource from an event');
            t.is(resourceStore.first.events[0], eventStore.first, 'resource#events located the correct event'); // TODO: Mention in changelog that this is no longer valid
            //    t.is(resourceStore.first.get('myName'), 'Foo', 'Name found in resource Model fields');

            t.is(resourceStore.first.name, 'Foo', 'Name found in resource Model fields');
            eventStore.on('update', {
              fn: function fn(_ref2) {
                var record = _ref2.record;
                t.is(record.meta.modified.resourceId, 'c1', 'After "set", The model "modified" object contained the original resource value');
              },
              once: true
            });
            event.resource = 'c2';
            _context.next = 25;
            return project.commitAsync();

          case 25:
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