// Had to port this test to get imports right
StartTest(function (t) {
  Object.assign(window, {
    Scheduler: Scheduler,
    EventStore: EventStore,
    ResourceStore: ResourceStore,
    PresetManager: PresetManager
  });
  var grid;
  t.beforeEach(function (t) {
    return grid && grid.destroy();
  });
  t.it('Should trigger cell events', function (t) {
    grid = t.getGrid({
      features: {
        cellEdit: false
      }
    });
    t.firesOk({
      observable: grid,
      events: {
        cellClick: 3,
        cellDblClick: 1,
        cellContextMenu: 1,
        cellMouseOver: '>=1',
        cellMouseOut: '>=1'
      }
    });
    t.chain({
      click: '.b-grid-cell'
    }, {
      dblclick: '.b-grid-cell'
    }, {
      contextmenu: '.b-grid-cell'
    }, {
      moveMouseTo: '.b-grid-header'
    });
  });
});