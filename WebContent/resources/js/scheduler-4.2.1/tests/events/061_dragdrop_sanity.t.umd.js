StartTest(function (t) {
  var scheduler = t.getScheduler({
    enableDragCreation: false,
    features: {
      eventDrag: {
        showTooltip: false
      }
    }
  }, 1);
  var origRegion, origEl;
  t.chain({
    waitForEventsToRender: null
  }, {
    click: '.b-sch-event'
  }, {
    waitFor: 400
  }, function (next) {
    t.is(scheduler.features.eventDrag.drag.context, null, 'Should not see any active drag context after a click');
    origEl = document.querySelector('.b-sch-event');
    origRegion = origEl.getBoundingClientRect();
    next();
  }, {
    drag: '.b-sch-event',
    by: [10, 0],
    dragOnly: true
  }, {
    moveCursorBy: [[-10, 0]]
  }, function (next) {
    origEl = document.querySelector('.b-sch-event');
    var dragRegion = document.querySelector('.b-dragging').getBoundingClientRect();
    t.is(origRegion.left, dragRegion.left, 'At drag start: Drag drop proxy should be aligned with original event');
    next();
  }, {
    moveCursorBy: [[10, 0]]
  }, function (next) {
    t.is(document.querySelector('.b-dragging').getBoundingClientRect().left, origRegion.left + 10, 'Drag drop proxy should move with mouse');
    next();
  }, {
    action: 'mouseUp'
  }, {
    click: '.b-sch-event'
  }, function () {
    t.notOk(document.querySelector('.b-dragprox'), 'Drag proxy cls removed');
  });
});