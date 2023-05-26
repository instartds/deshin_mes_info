StartTest(function (t) {
  var resourceStore, eventStore, crud;
  var testConfig = t.harness.getScriptDescriptor(t.url);

  var setup = function setup(fn, testConfig) {
    resourceStore = t.getResourceStore({
      storeId: 'resources',
      data: []
    });
    eventStore = t.getEventStore({
      storeId: 'events',
      data: [],
      resourceStore: resourceStore
    });
    crud = new CrudManager({
      resourceStore: resourceStore,
      eventStore: eventStore,
      transport: {
        load: Object.assign({
          method: 'GET',
          paramName: 'q'
        }, testConfig.load),
        sync: Object.assign({
          method: 'POST'
        }, testConfig.sync)
      },
      listeners: {
        loadfail: function loadfail() {
          t.fail('Loading failed');
        },
        syncfail: function syncfail() {
          t.fail('Persisting failed');
        }
      }
    });
    AjaxHelper.get(testConfig.resetUrl).then(fn, function () {
      return t.fail('Reset failed');
    }); // Ext.Ajax.request({
    //     url     : testConfig.resetUrl,
    //     success : fn,
    //     failure : () => { t.fail('Reset failed'); }
    // });
  };

  t.it('Should be possible to save some resources and events', function (t) {
    t.chain(function (next) {
      setup(next, testConfig);
    }, function (next) {
      var addedResources = resourceStore.add([{
        name: 'resource1'
      }, {
        name: 'resource2'
      }]);
      eventStore.add([{
        resourceId: addedResources[0].id,
        name: 'event1',
        startDate: new Date(2013, 0, 1),
        endDate: new Date(2013, 0, 15)
      }, {
        resourceId: addedResources[0].id,
        name: 'event2',
        startDate: new Date(2013, 0, 10),
        endDate: new Date(2013, 0, 12)
      }, {
        resourceId: addedResources[0].id,
        name: 'event3',
        startDate: new Date(2013, 0, 11),
        endDate: new Date(2013, 0, 12)
      }]);
      crud.sync().then(next, function () {
        t.fail('Sync failed');
      });
    }, function (next) {
      var resource1 = resourceStore.find(function (r) {
        return r.name === 'resource1';
      });
      t.ok(resource1.id, 'Resource resource1 has Id filled');
      var events = resource1.getEvents(eventStore);
      t.is(events.length, 3, 'Resource resource1 assigned to 3 events');
      t.ok(events[0].id, 'Event #0 has Id filled');
      t.ok(events[1].id, 'Event #1 has Id filled');
      t.is(events[0].resourceId, resource1.id, 'Event #0 has correct ResourceId');
      t.is(events[1].resourceId, resource1.id, 'Event #0 has correct ResourceId');
      crud.load().then(next, function () {
        t.fail('Load failed');
      });
    }, function (next) {
      t.is(resourceStore.count, 2, 'Correct number of resources loaded');
      t.is(eventStore.count, 3, 'Correct number of events loaded');
      var resource1 = resourceStore.findRecord('name', 'resource1');
      t.ok(resource1.id, 'Resource resource1 has Id filled');
      var events = resource1.getEvents(eventStore);
      t.is(events.length, 3, 'Resource resource1 assigned to 3 events');
      t.ok(events[0].id, 'Event #0 has Id filled');
      t.ok(events[1].id, 'Event #1 has Id filled');
      t.is(events[0].resourceId, resource1.id, 'Event #0 has correct ResourceId');
      t.is(events[1].resourceId, resource1.id, 'Event #0 has correct ResourceId');
      next();
    }, function (next) {
      var event1 = eventStore.findRecord('name', 'event1');
      var event2 = eventStore.findRecord('name', 'event2');
      var event3 = eventStore.findRecord('name', 'event3');
      var resource1 = resourceStore.findRecord('name', 'resource1');
      var resource2 = resourceStore.findRecord('name', 'resource2');
      var addedResources = resourceStore.add([{
        name: 'resource3'
      }]);
      event2.assign(addedResources[0]);
      resourceStore.remove(resource2);
      eventStore.remove(event3);
      event1.name = 'EVENT-1';
      resource1.name = 'RESOURCE-1';
      crud.sync().then(next, function () {
        t.fail('Sync failed');
      });
    }, function (next) {
      t.isDeeply(resourceStore.removed.values, [], 'No removed records');
      t.isDeeply(resourceStore.modified.values, [], 'No modified records');
      t.isDeeply(eventStore.removed.values, [], 'No removed records');
      t.isDeeply(eventStore.modified.values, [], 'No modified records');
      var event1 = eventStore.findRecord('name', 'EVENT-1');
      var event2 = eventStore.findRecord('name', 'event2');
      var event3 = eventStore.findRecord('name', 'event3');
      var resource1 = resourceStore.findRecord('name', 'RESOURCE-1');
      var resource2 = resourceStore.findRecord('name', 'resource2');
      var resource3 = resourceStore.findRecord('name', 'resource3');
      t.ok(event1, 'EVENT-1 found');
      t.ok(resource1, 'RESOURCE-1 found');
      t.notOk(event1.dirty, 'EVENT-1 is not dirty');
      t.notOk(resource1.dirty, 'RESOURCE-1 is not dirty');
      t.notOk(event3, 'event3 not found');
      t.notOk(resource2, 'resource2 not found');
      t.ok(resource3, 'resource3 found');
      t.ok(resource3.id, 'Resource resource3 has Id filled');
      t.isDeeply(resource3.getEvents(eventStore), [event2], 'Event #1 has resource3 assigned');
      t.is(event2.resourceId, resource3.id, 'Event #1 has correct ResourceId');
      crud.load().then(next, function () {
        t.fail('Load failed');
      });
    }, function (next) {
      t.is(resourceStore.count, 2, 'Correct number of resources loaded');
      t.is(eventStore.count, 2, 'Correct number of events loaded');
      var event1 = eventStore.findRecord('name', 'EVENT-1');
      var event2 = eventStore.findRecord('name', 'event2');
      var resource1 = resourceStore.findRecord('name', 'RESOURCE-1');
      var resource3 = resourceStore.findRecord('name', 'resource3');
      t.isDeeply(resource1.getEvents(eventStore), [event1], 'Event #0 has resource1 assigned');
      t.isDeeply(resource3.getEvents(eventStore), [event2], 'Event #1 has resource3 assigned');
      next();
    });
  });
  t.it('Prevents from persisiting outdated data', function (t) {
    var resourceStore2 = t.getResourceStore({
      data: []
    });
    var eventStore2 = t.getEventStore({
      data: [],
      resourceStore: resourceStore2
    });
    resourceStore2.eventStore = eventStore2;
    var crud2 = new CrudManager({
      resourceStore: {
        store: resourceStore2,
        storeId: 'resources'
      },
      eventStore: {
        store: eventStore2,
        storeId: 'events'
      },
      transport: {
        load: Object.assign({
          method: 'GET',
          paramName: 'q'
        }, testConfig.load),
        sync: Object.assign({
          method: 'POST'
        }, testConfig.sync)
      },
      listeners: {
        loadfail: function loadfail() {
          t.fail('Loading failed');
        }
      }
    });
    t.chain(function (next) {
      setup(next, testConfig);
    }, function (next) {
      crud.load().then(next, function () {
        t.fail('Load failed');
      });
    }, function (next) {
      crud2.load().then(next, function () {
        t.fail('Load failed');
      });
    }, function (next) {
      resourceStore.add([{
        name: 'resource1'
      }, {
        name: 'resource2'
      }]);
      crud.sync().then(next, function () {
        t.fail('Sync failed');
      });
    }, function (next) {
      resourceStore2.add([{
        name: 'resource3'
      }, {
        name: 'resource4'
      }]);
      crud2.sync().then(function () {
        t.fail('This sync should be failed');
        next();
      }, function () {
        t.pass('Sync successfuly failed');
        next();
      });
    }, function (next) {});
  });
});