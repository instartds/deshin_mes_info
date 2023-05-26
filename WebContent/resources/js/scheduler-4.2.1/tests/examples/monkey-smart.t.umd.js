StartTest(function (t) {
  var testConfig = t.getConfig(),
      webComponent = testConfig.webComponent,
      waitSelector = testConfig.waitSelector,
      selectorPrefix = webComponent && /webcomponent/.test(t.global.location.href) ? "".concat(webComponent, " ->") : ''; // Use unique cookie session ID per test

  t.setRandomPHPSession(); // Test is shared for Grid/Scheduler which use IE11 transpiling so it yet with chains

  t.chain({
    waitForSelector: t.global.location.href.includes('websockets') ? '.b-scheduler' : selectorPrefix + waitSelector
  }, t.smartMonkeys());
});