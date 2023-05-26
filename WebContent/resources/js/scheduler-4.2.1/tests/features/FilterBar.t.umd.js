function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest(function (t) {
  Object.assign(window, {
    Scheduler: Scheduler,
    EventStore: EventStore,
    ResourceStore: ResourceStore
  });
  var scheduler;
  t.beforeEach(function (t) {
    scheduler && scheduler.destroy();
  }); // Events disappear after vertical scroll
  // https://github.com/bryntum/support/issues/1087

  t.it('Should keep events visible after filter and vertical scroll', function (t) {
    var events = [],
        resources = [];

    for (var i = 1; i <= 50; i++) {
      resources.push({
        id: i,
        name: "Resource ".concat(i)
      });
      events.push({
        resourceId: i,
        name: "Event ".concat(i),
        startDate: "2020-06-29 ".concat(i % 2 ? '01:00:00' : '02:00'),
        duration: 4,
        durationUnit: 'h'
      });
    }

    scheduler = t.getScheduler({
      viewPreset: 'hourAndDay',
      height: 300,
      features: {
        filterBar: true,
        stripe: true
      },
      startDate: new Date(2020, 5, 29),
      endDate: new Date(2020, 5, 29, 8),
      columns: [{
        text: 'Name',
        field: 'name',
        width: 210 // Width value is picked up to have no horizontal scroll

      }],
      resources: resources,
      events: events
    });
    t.chain({
      waitForSelector: scheduler.unreleasedEventSelector
    }, /*#__PURE__*/_asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
      return regeneratorRuntime.wrap(function _callee$(_context) {
        while (1) {
          switch (_context.prev = _context.next) {
            case 0:
              _context.next = 2;
              return Promise.all([t.type('.b-filter-bar-field input', 'resource'), scheduler.resourceStore.await('filter', {
                checkLog: false
              })]);

            case 2:
              scheduler.scrollTop = 50;
              _context.next = 5;
              return scheduler.scrollable.await('scrollEnd', {
                checkLog: false
              });

            case 5:
              _context.next = 7;
              return t.waitFor({
                method: function method() {
                  return t.query(scheduler.unreleasedEventSelector).length >= 9;
                },
                description: 'Correct amount of events rendered'
              });

            case 7:
            case "end":
              return _context.stop();
          }
        }
      }, _callee);
    })));
  }); // https://github.com/bryntum/support/issues/2120

  t.it('Should have field name property available on filterable function parameter', function (t) {
    var propName;
    scheduler = t.getScheduler({
      features: {
        filterBar: true
      },
      columns: [{
        text: 'Name',
        field: 'name',
        filterable: function filterable(_ref2) {
          var property = _ref2.property;
          propName = property;
          return true;
        }
      }]
    });
    scheduler.store.filter({
      property: 'name',
      value: 'Mike'
    });
    t.is(propName, 'name', 'Field name property is available with correct value');
  });
});