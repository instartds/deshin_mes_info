// https://app.assembla.com/spaces/bryntum/tickets/8750
StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    scheduler && scheduler.destroy();
    scheduler = null;
  });

  var beforeEventAddHandler = function beforeEventAddHandler(_ref) {
    var source = _ref.source,
        eventRecord = _ref.eventRecord,
        resourceRecords = _ref.resourceRecords;
    this.ok(source instanceof Scheduler && eventRecord instanceof EventModel && resourceRecords instanceof Array, 'Correct event signature of `beforeeventadd`');
  };

  t.it('Event edit feature should fire beforeEventAdd event when Save button is clicked', function (t) {
    scheduler = t.getScheduler({
      features: {
        eventEdit: true
      }
    });
    scheduler.on({
      beforeeventadd: beforeEventAddHandler,
      thisObj: t
    });
    t.firesOnce(scheduler, 'beforeeventadd', 'beforeeventadd is fired once');
    var resource = scheduler.resourceStore.first;
    var event = new EventModel({
      name: 'Foo',
      startDate: new Date(2011, 0, 4),
      endDate: new Date(2011, 0, 5),
      resourceId: resource.id
    });
    t.chain({
      waitForEvent: [scheduler, 'beforeeventadd'],
      trigger: function trigger() {
        return scheduler.editEvent(event, resource);
      }
    }, {
      waitForSelector: '.b-eventeditor:not(.b-hidden)'
    }, function (next) {
      t.click('button:contains(Save)');
      next();
    }, {
      diag: 'Done!'
    });
  });
  t.it('Scheduler should not fire beforeEventAdd event on scheduledblclick if event edit feature exists before Save button is clicked', function (t) {
    scheduler = t.getScheduler({
      createEventOnDblClick: true,
      features: {
        eventEdit: true
      }
    });
    scheduler.on({
      beforeeventadd: beforeEventAddHandler,
      thisObj: t
    });
    t.isCalledOnce('onEventCreated', scheduler, 'onEventCreated hook is called once');
    t.firesOnce(scheduler, 'beforeeventadd', 'beforeeventadd is fired once');
    t.chain({
      waitForEventsToRender: null
    }, {
      waitForEvent: [scheduler, 'beforeeventadd'],
      trigger: {
        dblclick: '.b-sch-timeaxis-cell'
      }
    }, {
      waitFor: function waitFor() {
        var _scheduler$features$e;

        return (_scheduler$features$e = scheduler.features.eventEdit.editor) === null || _scheduler$features$e === void 0 ? void 0 : _scheduler$features$e.containsFocus;
      }
    }, {
      type: 'New test event'
    }, function (next) {
      t.click('button:contains(Save)');
      next();
    }, {
      diag: 'Done!'
    });
  });
  t.it('Scheduler should fire beforeEventAdd event on scheduledblclick if event edit feature does not exist', function (t) {
    scheduler = t.getScheduler({
      appendTo: document.body,
      onEventCreated: function onEventCreated(ev) {
        return ev.name = 'foo';
      },
      createEventOnDblClick: true,
      features: {
        eventEdit: false
      }
    });
    scheduler.on({
      beforeeventadd: beforeEventAddHandler,
      thisObj: t
    });
    t.isCalledOnce('onEventCreated', scheduler, 'onEventCreated hook is called once');
    t.firesOnce(scheduler, 'beforeeventadd', 'beforeeventadd is fired once');
    t.chain({
      dblclick: '.b-sch-timeaxis-cell'
    }, {
      waitForSelector: '.b-sch-event:textEquals(foo)'
    });
  });
  t.it('Scheduler should not fire beforeEventAdd event on dragcreate if event edit feature exists before Save button is clicked', function (t) {
    scheduler = t.getScheduler({
      appendTo: document.body,
      features: {
        eventEdit: true,
        eventDragCreate: true
      }
    });
    scheduler.on({
      beforeeventadd: beforeEventAddHandler,
      thisObj: t
    });
    t.isCalledOnce('onEventCreated', scheduler, 'onEventCreated hook is called once');
    t.firesOnce(scheduler, 'beforeeventadd', 'beforeeventadd is fired once');
    t.chain({
      waitForEvent: [scheduler, 'beforeeventadd'],
      trigger: {
        drag: '.b-sch-timeaxis-cell',
        fromOffset: [2, 2],
        by: [100, 0]
      }
    }, {
      waitFor: function waitFor() {
        var _scheduler$features$e2;

        return (_scheduler$features$e2 = scheduler.features.eventEdit.editor) === null || _scheduler$features$e2 === void 0 ? void 0 : _scheduler$features$e2.containsFocus;
      }
    }, {
      type: 'New test event'
    }, function (next) {
      t.click('button:contains(Save)');
      next();
    }, {
      diag: 'Done!'
    });
  });
  t.it('Scheduler should fire beforeEventAdd event on dragcreate if event edit feature does not exist', function (t) {
    scheduler = t.getScheduler({
      appendTo: document.body,
      onEventCreated: function onEventCreated(ev) {
        return ev.name = 'foo';
      },
      features: {
        eventEdit: false,
        eventDragCreate: true
      }
    });
    scheduler.on({
      beforeeventadd: beforeEventAddHandler,
      thisObj: t
    });
    t.isCalledOnce('onEventCreated', scheduler, 'onEventCreated hook is called once');
    t.firesOnce(scheduler, 'beforeeventadd', 'beforeeventadd is fired once');
    t.chain({
      drag: '.b-sch-timeaxis-cell',
      fromOffset: [2, 2],
      by: [100, 0]
    }, {
      waitForSelector: '.b-sch-event:textEquals(foo)'
    });
  });
});