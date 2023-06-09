StartTest(function (t) {
  var scheduler;
  t.beforeEach(function () {
    return scheduler && scheduler.destroy();
  });
  Object.assign(window, {
    Scheduler: Scheduler,
    TimeAxisColumn: TimeAxisColumn,
    EventStore: EventStore,
    ResourceStore: ResourceStore,
    DependencyStore: DependencyStore,
    PresetManager: PresetManager
  });
  t.it('Should not crash after changing columns and element is resized', function (t) {
    scheduler = t.getScheduler({
      startDate: new Date(2017, 0, 1),
      endDate: new Date(2017, 0, 3),
      viewPreset: 'hourAndDay',
      columns: [{
        text: 'Name',
        field: 'name',
        width: 130
      }]
    });
    var columns = [{
      text: 'Name',
      field: 'name',
      width: 130
    }];
    t.is(scheduler.subGrids.normal.columns.count, 1, 'TimeAxis present before removeAll');
    scheduler.subGrids.locked.columns.removeAll();
    t.is(scheduler.subGrids.locked.columns.count, 0, 'All locked columns removed');
    t.is(scheduler.subGrids.normal.columns.count, 1, 'TimeAxis still present');
    scheduler.subGrids.locked.columns.add(columns);
    scheduler.element.style.width = '600px';
  });
  t.it('Should not crash when changing columns and element is resized', function (t) {
    scheduler = t.getScheduler({
      startDate: new Date(2017, 0, 1),
      endDate: new Date(2017, 0, 3),
      viewPreset: 'hourAndDay',
      columns: [{
        text: 'Name',
        field: 'name',
        width: 130
      }]
    });
    var columns = [{
      text: 'Name',
      field: 'name',
      width: 130
    }];
    scheduler.subGrids.locked.columns.removeAll();
    scheduler.subGrids.locked.columns.add(columns);
    scheduler.subGrids.normal.scrollable.x = 100;
    t.pass('Scrolled without crash');
  });
});