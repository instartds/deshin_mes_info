var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    AssignmentStore = _bryntum$scheduler.AssignmentStore;
/* eslint-disable no-unused-vars */

var assignmentStore = new AssignmentStore({
  id: 'assignments'
});
var scheduler = new Scheduler({
  appendTo: 'container',
  startDate: new Date(2019, 0, 1, 6),
  endDate: new Date(2019, 0, 1, 20),
  viewPreset: 'hourAndDay',
  eventStyle: 'border',
  resourceImagePath: '../_shared/images/users/',
  columns: [{
    type: 'resourceInfo',
    text: 'Name',
    field: 'name',
    width: 130
  }, {
    text: 'City',
    field: 'city',
    width: 90
  }],
  features: {
    stripe: true,
    dependencies: true
  },
  assignmentStore: assignmentStore,
  crudManager: {
    assignmentStore: assignmentStore,
    transport: {
      load: {
        url: 'data/data.json'
      }
    },
    autoLoad: true
  }
});