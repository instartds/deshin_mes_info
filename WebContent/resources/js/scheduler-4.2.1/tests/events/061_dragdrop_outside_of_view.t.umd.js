function asyncGeneratorStep(gen, resolve, reject, _next, _throw, key, arg) { try { var info = gen[key](arg); var value = info.value; } catch (error) { reject(error); return; } if (info.done) { resolve(value); } else { Promise.resolve(value).then(_next, _throw); } }

function _asyncToGenerator(fn) { return function () { var self = this, args = arguments; return new Promise(function (resolve, reject) { var gen = fn.apply(self, args); function _next(value) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "next", value); } function _throw(err) { asyncGeneratorStep(gen, resolve, reject, _next, _throw, "throw", err); } _next(undefined); }); }; }

StartTest( /*#__PURE__*/function () {
  var _ref = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee2(t) {
    var scheduler, tickSize, event, setup, _setup, testSteps;

    return regeneratorRuntime.wrap(function _callee2$(_context2) {
      while (1) {
        switch (_context2.prev = _context2.next) {
          case 0:
            _setup = function _setup3() {
              _setup = _asyncToGenerator( /*#__PURE__*/regeneratorRuntime.mark(function _callee() {
                var config,
                    _args = arguments;
                return regeneratorRuntime.wrap(function _callee$(_context) {
                  while (1) {
                    switch (_context.prev = _context.next) {
                      case 0:
                        config = _args.length > 0 && _args[0] !== undefined ? _args[0] : {};
                        if (scheduler) scheduler.destroy();
                        document.body.width = '800px';
                        scheduler = t.getScheduler(Object.assign({
                          startDate: new Date(2010, 0, 1),
                          endDate: new Date(2010, 2, 1),
                          events: [{
                            id: 1,
                            name: 'Test event',
                            resourceId: 'r1',
                            cls: 'event1',
                            startDate: new Date(2009, 11, 1),
                            endDate: new Date(2010, 3, 1)
                          }],
                          //resourceStore           : config.__tree ? t.getResourceTreeStore() : t.getResourceStore(),
                          resourceStore: t.getResourceStore(),
                          features: {
                            eventDrag: {
                              showTooltip: false
                            }
                          }
                        }, config));
                        _context.next = 6;
                        return t.waitForProjectReady(scheduler);

                      case 6:
                        event = scheduler.eventStore.first;
                        tickSize = scheduler.timeAxisViewModel.tickSize;

                      case 8:
                      case "end":
                        return _context.stop();
                    }
                  }
                }, _callee);
              }));
              return _setup.apply(this, arguments);
            };

            setup = function _setup2() {
              return _setup.apply(this, arguments);
            };

            testSteps = [// moving forward in time
            {
              drag: function drag() {
                var gridRectangle = Rectangle.from(scheduler.timeAxisSubGridElement),
                    eventRectangle = Rectangle.from(document.querySelector('.event1')),
                    center = gridRectangle.intersect(eventRectangle).center;
                return center.toArray();
              },
              by: function by() {
                return [tickSize, scheduler.rowHeight];
              }
            }, function (next) {
              t.isApprox(DateHelper.getDurationInUnit(event.meta.modified.startDate, event.startDate, scheduler.timeAxis.mainUnit), 1, 1, 'Event moved approximately on 1 unit');
              t.isApprox(DateHelper.getDurationInUnit(event.meta.modified.endDate, event.endDate, scheduler.timeAxis.mainUnit), 1, 1, 'Event moved approximately on 1 unit');
              t.is(event.resourceId, 'r2', 'Event has been re-assigned to another resource');
              next();
            }, // moving backward in time
            {
              drag: function drag() {
                var gridRectangle = Rectangle.from(scheduler.timeAxisSubGridElement),
                    eventRectangle = Rectangle.from(document.querySelector('.event1')),
                    center = gridRectangle.intersect(eventRectangle).center;
                return center.toArray();
              },
              by: function by() {
                return [-tickSize, -scheduler.rowHeight - 1];
              }
            }, function (next) {
              t.isApprox(DateHelper.getDurationInUnit(event.meta.modified.startDate, event.startDate, scheduler.timeAxis.mainUnit), -1, 1, 'Event moved approximately on 1 unit');
              t.isApprox(DateHelper.getDurationInUnit(event.meta.modified.endDate, event.endDate, scheduler.timeAxis.mainUnit), -1, 1, 'Event moved approximately on 1 unit');
              next();
            }, {
              waitFor: function waitFor() {
                return event.resourceId === 'r1';
              },
              desc: 'Event has been re-assigned to another resource'
            }]; // eof test steps

            _context2.next = 5;
            return setup();

          case 5:
            t.diag('Plain horizontal scheduler');
            t.chain(testSteps // TODO: PORT tree later

            /*,
              function(next) {
             t.diag('Tree scheduler');
             setup({ __tree : true });
             next()
             },
             testSteps*/
            );

          case 7:
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