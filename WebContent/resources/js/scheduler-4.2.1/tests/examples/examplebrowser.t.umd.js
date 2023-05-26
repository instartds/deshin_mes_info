StartTest(function (t) {
  var _t$getConfig = t.getConfig(),
      exampleName = _t$getConfig.exampleName,
      exampleTitle = _t$getConfig.exampleTitle,
      offlineExampleName = _t$getConfig.offlineExampleName,
      jumpSectionName = _t$getConfig.jumpSectionName,
      jumpExampleName = _t$getConfig.jumpExampleName,
      filterText = _t$getConfig.filterText,
      filterCount = _t$getConfig.filterCount;

  var document;
  t.setWindowSize(1024, 768);
  t.beforeEach(function (t, next) {
    document = t.global.document;
    t.waitForSelector('.example', next);
  });
  t.it('Should initially scroll section into view if provided in hash', function (t) {
    var href = t.global.location.href;
    t.chain({
      waitForPageLoad: null,
      trigger: function trigger() {
        return t.global.location.href = 'about:blank';
      },
      desc: "Clean the page"
    }, {
      waitForPageLoad: null,
      trigger: function trigger() {
        t.global.location.href = "".concat(href, "#example-").concat(exampleName);
      },
      desc: "Reload the page with hash"
    }, {
      waitForElementTop: "#b-example-".concat(exampleName)
    });
  });
  t.it('Rendering', function (t) {
    t.chain(function (next) {
      var example = document.querySelector("#b-example-".concat(exampleName));
      example.scrollIntoView();
      t.isGreater(document.querySelectorAll('.example').length, 3, 'A bunch of examples displayed');
      t.isGreater(document.querySelectorAll('h2').length, 1, 'A bunch of headers displayed');
      var link = example.href,
          valid = link.match("".concat(exampleName, "$")) || link.match("".concat(exampleName, "/bundle.htm$"));
      t.ok(valid, 'First link looks correct');
      var browserEl = document.getElementById('browser');
      t.ok(browserEl.scrollHeight > browserEl.clientHeight, 'Browser element is scrollable');
      next();
    }, {
      moveCursorTo: "#b-example-".concat(exampleName, " .tooltip")
    }, {
      waitForSelector: ".b-tooltip:contains(".concat(exampleTitle, ")"),
      desc: 'Example tip shown'
    });
  });
  t.it('Changing theme', function (t) {
    t.chain( // Items are lazy loaded
    {
      waitFor: function waitFor() {
        return t.global.shared.infoButton.menuItems;
      },
      desc: 'Info button items are loaded'
    }, // Theme defaults to material, by using ?theme=material on url
    {
      waitFor: function waitFor() {
        return document.querySelector("#b-example-".concat(exampleName, " img")).src.toLowerCase().match('thumb.material.png$');
      }
    }, // First item should not be a default theme since popup won't be hidden
    ['Classic-Dark', 'Classic', 'Classic-Light', 'Material', 'Stockholm'].map(function (theme) {
      return [{
        click: '[data-ref=infoButton]',
        desc: 'Click on the cog'
      }, {
        click: '[data-ref=themeCombo]',
        desc: 'Click on the theme combo'
      }, {
        click: ".b-list-item:contains(".concat(theme, ")"),
        desc: "Switching to ".concat(theme, " theme")
      }, {
        click: 'header',
        offset: ['90%', '50%']
      }, {
        waitForSelector: "#b-example-".concat(exampleName, " img[src=\"").concat(exampleName, "/meta/thumb.").concat(theme.toLowerCase(), ".png\"]"),
        desc: 'Correct thumb image for basic example'
      }];
    }));
  });
  t.it('Check thumbnail sizes', function (t) {
    var steps = [];
    document.querySelectorAll('.image [loading="lazy"]').forEach(function (element) {
      element.removeAttribute('loading');
    });
    document.querySelectorAll('.example').forEach(function (example) {
      steps.push({
        waitFor: function waitFor() {
          var img = document.querySelector("#".concat(example.id, " img")),
              rect = img.getBoundingClientRect();
          return t.samePx(rect.width, t.bowser.msie ? 256 : 275, 10) && t.samePx(rect.height, t.bowser.msie ? 192 : 206, 10);
        },
        desc: "Correct image size for: \"".concat(example.id, "\"")
      });
    });
    t.chain(steps);
  });
  t.it('Check tooltips for examples not available offline', function (t) {
    if (offlineExampleName) {
      t.chain({
        scrollIntoView: "#b-example-".concat(offlineExampleName)
      }, {
        waitForSelector: "#b-example-".concat(offlineExampleName, " i.b-fa-cog"),
        desc: 'Correct info icon used'
      }, {
        moveCursorTo: "#b-example-".concat(offlineExampleName, " .tooltip")
      }, {
        waitForSelector: '.b-tooltip-content:contains(This demo needs to be built before it can be viewed)',
        desc: 'Tooltip shown'
      }, {
        moveCursorTo: 'label.title',
        desc: 'Hiding tooltip to avoid aborting requests'
      }, {
        waitForSelectorNotFound: '.b-tooltip',
        desc: 'Tooltip hidden'
      });
    }
  });
  t.it('Should handle non existing theme ids gracefully', function (t) {
    var locationSearch; // old themes (plus extra one imitating just a bad value) mapping

    var themeNames = {
      dark: 'Classic-Dark',
      light: 'Classic-Light',
      default: 'Classic',
      foo: 'Stockholm'
    };
    t.chain({
      diag: 'Dropping theme forcing from URL'
    }, {
      waitForPageLoad: null,
      trigger: function trigger() {
        // location.search looks like "?theme=material" for this test
        // so we need to reset it to test localStorage provided theme
        locationSearch = t.global.location.search;
        t.global.location.search = '';
      }
    }, ['dark', 'light', 'default', 'foo'].map(function (theme) {
      return [{
        diag: "Trying ".concat(theme, " theme")
      }, {
        waitForPageLoad: null,
        trigger: function trigger() {
          // saving theme & reloading page
          localStorage.setItem('b-example-theme', theme);
          t.global.location.reload();
        }
      }, {
        click: '[data-ref=infoButton]:not(.b-disabled)',
        desc: 'Clicked info button'
      }, {
        click: '[data-ref=themeCombo]',
        desc: 'Clicked theme button to expand dropdown list'
      }, {
        waitForSelector: ".b-list-item.b-selected:contains(".concat(themeNames[theme], ")"),
        desc: 'Correct theme is selected'
      }, function (next) {
        t.is(t.global.document.querySelector('[data-ref=themeCombo] input').value, themeNames[theme], 'Correct theme field value');
        next();
      }];
    }), {
      diag: 'Restoring initial iframe URL back'
    }, {
      waitForPageLoad: null,
      trigger: function trigger() {
        return t.global.location.search = locationSearch;
      }
    });
  });
  t.it('Jump to section', function (t) {
    t.chain({
      waitForScroll: null
    }, {
      click: '[data-ref=jumpTo]',
      desc: 'Click Jump to'
    }, {
      click: ".b-list-item:textEquals(".concat(jumpSectionName, ")"),
      desc: "Select ".concat(jumpSectionName, " section")
    }, {
      waitForElementTop: "#b-example-".concat(jumpExampleName),
      desc: "Wait for Example ".concat(jumpExampleName, " to be on top")
    });
  });
  t.it('Filtering demos', function (t) {
    var count = t.query('.example').length;
    t.chain({
      type: "".concat(filterText, "[TAB] input"),
      target: '[data-ref=filterField] input',
      desc: "Filter by \"".concat(filterText, "\"")
    }, {
      waitFor: function waitFor() {
        return t.query('.example').length >= filterCount;
      },
      desc: 'Wait for 3 filtered examples'
    }, {
      type: '[ESC]',
      target: '[data-ref=filterField] input',
      desc: 'Clear filter'
    }, {
      waitFor: function waitFor() {
        return t.query('.example').length === count;
      },
      desc: 'Wait for all examples visible'
    });
  });
});