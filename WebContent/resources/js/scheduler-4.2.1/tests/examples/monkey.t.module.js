StartTest(t => {

    // Test setup
    const
        testConfig     = t.getConfig(),
        {
            webComponent,
            waitSelector,
            targetSelector,
            skipTargets,
            isPR
        }              = testConfig,
        selectorPrefix = webComponent && /webcomponent/.test(t.global.location.href) ? `${webComponent} ->` : '';

    // Use unique cookie session ID per test
    t.setRandomPHPSession();

    t.diag('Test PageURL: ' + t.scopeProvider.sourceURL);

    // monkeys should not wait for any scrolling
    t.waitForScrolling = false;
    t.waitForAnimations = next => next();

    t.waitForSelector(t.global.location.href.includes('websockets') ? '.b-scheduler' : (selectorPrefix + waitSelector), () => {
        !isPR && t.it('Crazy monkeys', t => {
            function getParams(asObject) {
                let ret = window.top.location.search.substr(1).split('&').filter(function(p) {
                    return p;
                });

                if (asObject) {
                    ret = ret.reduce(function(prev, curr) {
                        const p                        = curr.split('=');
                        prev[decodeURIComponent(p[0])] = decodeURIComponent(p[1]);
                        return prev;
                    }, {});
                }

                return ret;
            }

            window.top.setMonkeyActions = window.setMonkeyActions = function(actions) {
                const params = getParams();
                let i;

                for (i = 0; i < params.length; ++i) {
                    if (params[i].startsWith('monkeyActions=')) {
                        break;
                    }
                }

                params[i]                  = 'monkeyActions=' + encodeURIComponent(JSON.stringify(actions));
                window.top.location.search = '?' + params.join('&');
            };

            t.injectXSS();

            function test() {
                t.pass('Example rendered without exception');

                // Play external steps if provided in query string
                if (window.top.location.search.match('monkeyActions')) {
                    // TODO: what is the right thing here?
                    // t.forceTestVisible();

                    const params = getParams(true);
                    t.chain(JSON.parse(params.monkeyActions));
                }
                else {
                    t.monkeyTest({
                        target          : selectorPrefix + targetSelector,
                        skipTargets     : ['#fullscreen-button', '.b-skip-test', '.b-codeeditor', '.b-no-monkeys', '.b-print-button'].concat(skipTargets || []),
                        nbrInteractions : 10,
                        callback(actionLog) {
                            if (Boolean(t.nbrExceptions || t.failed)) {
                                t.fail('Wild rabid monkeys found error', 'Wild monkey actions: ' + JSON.stringify(window.monkeyActions));
                            }
                            window.monkeyActions = actionLog;
                        }
                    });
                }
            }

            if (document.querySelector('.x-messagebox')) {
                t.click('.x-messagebox .x-button', test);
            }
            else {
                test();
            }
        });
    });
});
