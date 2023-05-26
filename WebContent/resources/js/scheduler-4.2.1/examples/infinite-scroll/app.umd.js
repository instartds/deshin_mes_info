var _bryntum$scheduler = bryntum.scheduler,
    Scheduler = _bryntum$scheduler.Scheduler,
    DateHelper = _bryntum$scheduler.DateHelper,
    RandomGenerator = _bryntum$scheduler.RandomGenerator,
    Toast = _bryntum$scheduler.Toast;
/* eslint-disable no-unused-vars */
//region Data

var rnd = new RandomGenerator(),
    // Import should always match class name, otherwise transpiled demos could not import the class
DH = DateHelper,
    today = DH.clearTime(new Date()),
    startDate = DH.add(today, -6, 'month'),
    endDate = DH.add(startDate, 1, 'year'),
    todayAt12 = DH.set(new Date(today), 'hour', 12);

function generateEvents() {
  var result = []; // Loop through every day for a year surrounding today.

  for (var eventId = 1, date = new Date(startDate); date < endDate; date.setDate(date.getDate() + 1)) {
    // Create 10 events at random times for random resources every day
    for (var i = 0; i < 10; i++) {
      result.push({
        id: eventId++,
        name: "Event ".concat(eventId),
        resourceId: "r".concat(i + 1),
        startDate: new Date(date.getFullYear(), date.getMonth(), date.getDate(), rnd.nextRandom(20)),
        duration: rnd.nextRandom(4) + 1,
        durationUnit: 'hour'
      });
    }
  }

  return result;
}

var resources = [{
  id: 'r1',
  name: 'Mike',
  eventColor: 'red'
}, {
  id: 'r2',
  name: 'Linda',
  eventColor: 'indigo'
}, {
  id: 'r3',
  name: 'Don',
  eventColor: 'lime'
}, {
  id: 'r4',
  name: 'Karen',
  eventColor: 'orange'
}, {
  id: 'r5',
  name: 'Doug',
  eventColor: 'teal'
}, {
  id: 'r6',
  name: 'Peter',
  eventColor: 'purple'
}, {
  id: 'r7',
  name: 'Sam',
  eventColor: 'yellow'
}, {
  id: 'r8',
  name: 'Melissa',
  eventColor: 'green'
}, {
  id: 'r9',
  name: 'John',
  eventColor: 'amber'
}, {
  id: 'r10',
  name: 'Ellen',
  eventColor: 'blue'
}],
    events = generateEvents(); //endregion

var scheduler = new Scheduler({
  tbar: {
    items: {
      scrollTo: {
        label: 'Scroll to date',
        inputWidth: '7em',
        width: 'auto',
        type: 'datefield',
        value: today,
        step: '1d',
        listeners: {
          change: function change(_ref) {
            var userAction = _ref.userAction,
                value = _ref.value;

            if (userAction) {
              scheduler.scrollToDate(DH.set(value, 'hour', 12), {
                block: 'center',
                animate: 500
              });
            }
          }
        },
        highlightExternalChange: false
      }
    }
  },
  // Start with today's date dead centre in the view
  visibleDate: {
    date: todayAt12,
    block: 'center'
  },
  listeners: {
    horizontalScroll: function horizontalScroll() {
      // Keep scrollTo date synced with the visible date
      this.widgetMap.scrollTo.value = this.timeAxis.floorDate(this.viewportCenterDate);
    }
  },
  // This allows the timeline to be scrolled infinitely in time.
  infiniteScroll: true,
  multiEventSelect: true,
  appendTo: 'container',
  resources: resources,
  events: events,
  viewPreset: 'hourAndDay',
  rowHeight: 50,
  barMargin: 5,
  columns: [{
    text: 'Name',
    field: 'name',
    width: 130
  }]
});
scheduler.eventStore.on({
  loadDateRange: function loadDateRange(e) {
    Toast.show("Need ".concat(DH.format(e.new.startDate, 'DD-MMM-YYYY'), " to ").concat(DH.format(e.new.endDate, 'DD-MMM-YYYY')));
  }
});