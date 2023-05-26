function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest( /*#__PURE__*/function () {
  var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee(t) {
    var eventStore, scheduler, resource, newEvent, newEvent2;
    return regeneratorRuntime.wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            eventStore = new EventStore();
            _context.next = 3;
            return t.getSchedulerAsync({
              mode: 'horizontal',
              eventStore: eventStore,
              dependencyViewConfig: {
                drawDependencies: false
              }
            });

          case 3:
            scheduler = _context.sent;
            resource = scheduler.resourceStore.first;
            newEvent = new EventModel({
              startDate: new Date(scheduler.startDate),
              endDate: new Date(scheduler.endDate),
              resourceId: resource.id
            });
            newEvent2 = new EventModel({
              startDate: new Date(scheduler.startDate),
              endDate: new Date(scheduler.endDate),
              resourceId: resource.id
            });
            t.selectorNotExists('.b-sch-event', 'No events initially');
            eventStore.add(newEvent);
            eventStore.add(newEvent2);
            _context.next = 12;
            return t.waitForProjectReady();

          case 12:
            t.ok(newEvent.hasGeneratedId, 'newEvent is phantom');
            t.ok(newEvent2.hasGeneratedId, 'newEvent2 is phantom');
            t.selectorExists('.b-sch-event', 'Add ok');
            eventStore.revertChanges();
            _context.next = 18;
            return t.waitForProjectReady();

          case 18:
            t.is(eventStore.count, 0, 'Store should be empty');
            t.selectorNotExists(scheduler.unreleasedEventSelector, 'Clear ok'); // TODO: Not working with engine
            // eventStore.add(newEvent);
            //
            // newEvent.cls = 'foo';
            //
            // await t.waitForProjectReady();
            //
            // t.selectorExists('.b-sch-event.foo', 'Update ok');
            //
            // eventStore.remove(newEvent);
            //
            // await t.waitForProjectReady();

          case 20:
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