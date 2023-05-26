StartTest(t => {
    const
        testConfig     = t.getConfig(),
        {
            webComponent,
            waitSelector
        }              = testConfig,
        selectorPrefix = webComponent && /webcomponent/.test(t.global.location.href) ? `${webComponent} ->` : '';

    // Use unique cookie session ID per test
    t.setRandomPHPSession();

    // Test is shared for Grid/Scheduler which use IE11 transpiling so it yet with chains
    t.chain(
        { waitForSelector : t.global.location.href.includes('websockets') ? '.b-scheduler' : (selectorPrefix + waitSelector) },
        t.smartMonkeys()
    );

});
