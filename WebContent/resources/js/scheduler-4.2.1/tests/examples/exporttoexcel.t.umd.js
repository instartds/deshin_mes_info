/*global zipcelx*/

/*eslint no-undef: "error"*/
StartTest(function (t) {
  var scheduler;
  t.it('sanity', function (t) {
    t.chain({
      waitForSelector: '.b-sch-foreground-canvas'
    }, function (next, el) {
      scheduler = bryntum.fromElement(el[0], 'scheduler');
      next();
    }, function () {
      t.checkGridSanity(scheduler);
      t.ok(scheduler.features.excelExporter, 'ExcelExporter feature is here');
      t.ok(zipcelx, 'Zipcelx library is here (global)');
    });
  });
  t.it('Export to Excel', function (t) {
    var spy = t.spyOn(scheduler.features.excelExporter, 'zipcelx');
    t.chain({
      click: '[data-ref=excelExportBtn1]'
    }, {
      click: '[data-ref=excelExportBtn2]'
    }, {
      click: '[data-ref=excelExportBtn3]'
    }, function () {
      t.expect(spy).toHaveBeenCalled(3);
    });
  });
});