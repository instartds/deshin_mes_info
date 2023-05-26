StartTest(function (t) {
  var scheduler = bryntum.query('scheduler');
  t.it('sanity', function (t) {
    t.chain(function () {
      return t.checkGridSanity(scheduler);
    });
  });
  t.it('Should render events on all zoom levels', function (t) {
    t.chain({
      waitForRowsVisible: scheduler
    }, Array.from(Array(25)).map(function (a, i) {
      return [function (next) {
        scheduler.zoomLevel = i;
        next();
      }, {
        waitForSelector: scheduler.eventSelector + '.b-sch-color-lime:not(.b-sch-released)'
      }, function (next) {
        var element = document.querySelector(scheduler.eventSelector + '.b-sch-color-lime:not(.b-sch-released) .b-sch-event'),
            rect = Rectangle.from(element, document.body),
            view = Rectangle.from(document.querySelector('.b-grid-subgrid-normal'), document.body);
        t.ok(rect.intersect(view), 'Event in view at zoomLevel ' + i);
        next();
      }];
    }));
  });
});