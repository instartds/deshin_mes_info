StartTest(function (t) {
  t.setWindowSize(1027, 768);
  t.it('Check each online example from example browser to have correct link back to all examples', function (t) {
    t.waitForSelector('.example', function () {
      var examples = Array.from(t.global.document.querySelectorAll('.example:not(.offline)')).map(function (el) {
        return {
          id: el.id.replace('b-example', 'example'),
          href: el.href
        };
      });
      examples.forEach(function (example) {
        t.it("Check example #".concat(example.id), function (t) {
          t.chain({
            waitForPageLoad: null,
            trigger: function trigger() {
              return t.global.location.href = 'about:blank';
            },
            desc: "Clean the page"
          }, {
            waitForSelectorNotFound: "#title"
          }, {
            waitForPageLoad: null,
            trigger: function trigger() {
              return t.global.location.href = example.href;
            },
            desc: "Navigate to example page ".concat(example.href)
          }, {
            waitForSelector: "#title"
          }, function () {
            var _title$href;

            var title = t.global.document.getElementById('title'),
                correct = "examples/#".concat(example.id);

            if (!(title !== null && title !== void 0 && (_title$href = title.href) !== null && _title$href !== void 0 && _title$href.endsWith(correct))) {
              t.fail("Wrong #title href: \"".concat(title.href, "\", Correct ends with: \"").concat(correct, "\""));
            }
          });
        });
      });
    });
  });
});