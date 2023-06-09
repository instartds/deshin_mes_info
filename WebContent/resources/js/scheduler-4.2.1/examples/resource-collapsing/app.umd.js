var Scheduler = bryntum.scheduler.Scheduler;
new Scheduler({
  appendTo: 'container',
  minHeight: '20em',
  barMargin: 1,
  rowHeight: 50,
  resourceImagePath: '../_shared/images/users/',
  eventStyle: 'colored',
  columnLines: false,
  startDate: new Date(2021, 5, 3, 8),
  endDate: new Date(2021, 5, 3, 18),
  viewPreset: 'hourAndDay',
  columns: [{
    type: 'resourceCollapse'
  }, {
    type: 'resourceInfo',
    text: 'Staff'
  }],
  crudManager: {
    autoLoad: true,
    transport: {
      load: {
        url: 'data/data.json'
      }
    }
  }
});