// eslint-disable-next-line no-unused-vars
window.introWidget = {
  type: 'scheduler',
  minHeight: 250,
  subGridConfigs: {
    locked: {
      width: '10em'
    }
  },
  readOnly: true,
  startDate: new Date(2021, 1, 14, 7),
  endDate: new Date(2021, 1, 14, 11, 30),
  viewPreset: 'hourAndDay',
  rowHeight: 50,
  columns: [{
    type: 'template',
    text: 'Name',
    field: 'name',
    cellCls: 'name',
    template: function template(data) {
      return "<img src=\"_shared/images/users/".concat(data.record.name.toLowerCase(), ".jpg\" alt=\"\"/><dl><dt>").concat(data.record.name, "</dt><dd>").concat(data.record.events.length, " task(s)</dd></dl>");
    },
    width: '10em'
  }],
  resources: [{
    id: 1,
    name: 'Angelo'
  }, {
    id: 2,
    name: 'Jong'
  }, {
    id: 3,
    name: 'Rob'
  }, {
    id: 4,
    name: 'Madison'
  }],
  events: [{
    id: 1,
    resourceId: 1,
    startDate: new Date(2021, 1, 14, 7, 30),
    endDate: new Date(2021, 1, 14, 9),
    name: 'Workout',
    eventColor: 'orange'
  }, {
    id: 2,
    resourceId: 2,
    startDate: new Date(2021, 1, 14, 8),
    endDate: new Date(2021, 1, 14, 10, 30),
    name: 'Client meeting',
    eventColor: 'blue'
  }, {
    id: 3,
    resourceId: 3,
    startDate: new Date(2021, 1, 14, 10),
    endDate: new Date(2021, 1, 14, 10),
    name: 'Coffee break'
  }, {
    id: 4,
    startDate: new Date(2021, 1, 14, 9),
    resourceId: 4,
    duration: 2,
    durationUnit: 'h',
    name: 'Product presentation',
    eventColor: 'purple'
  }]
};