StartTest(t => {

    const {
        exampleName,
        exampleTitle,
        offlineExampleName,
        jumpSectionName,
        jumpExampleName,
        filterText,
        filterCount
    } = t.getConfig();

    let document;
    t.setWindowSize(1024, 768);

    t.beforeEach((t, next) => {
        document = t.global.document;
        t.waitForSelector('.example', next);
    });

    t.it('Should initially scroll section into view if provided in hash', t => {
        const href = t.global.location.href;
        t.chain(
            {
                waitForPageLoad : null,
                trigger         : () => t.global.location.href = 'about:blank',
                desc            : `Clean the page`
            },
            {
                waitForPageLoad : null,
                trigger         : () => {
                    t.global.location.href = `${href}#example-${exampleName}`;
                },
                desc : `Reload the page with hash`
            },
            { waitForElementTop : `#b-example-${exampleName}` }
        );
    });

    t.it('Rendering', t => {
        t.chain(
            next => {
                const example = document.querySelector(`#b-example-${exampleName}`);
                example.scrollIntoView();
                t.isGreater(document.querySelectorAll('.example').length, 3, 'A bunch of examples displayed');
                t.isGreater(document.querySelectorAll('h2').length, 1, 'A bunch of headers displayed');
                const
                    link  = example.href,
                    valid = link.match(`${exampleName}$`) || link.match(`${exampleName}/bundle.htm$`);
                t.ok(valid, 'First link looks correct');
                let browserEl = document.getElementById('browser');
                t.ok(browserEl.scrollHeight > browserEl.clientHeight, 'Browser element is scrollable');
                next();
            },
            { moveCursorTo : `#b-example-${exampleName} .tooltip` },
            { waitForSelector : `.b-tooltip:contains(${exampleTitle})`, desc : 'Example tip shown' }
        );
    });

    t.it('Changing theme', t => {
        t.chain(
            // Items are lazy loaded
            { waitFor : () => t.global.shared.infoButton.menuItems, desc : 'Info button items are loaded' },
            // Theme defaults to material, by using ?theme=material on url
            { waitFor : () => document.querySelector(`#b-example-${exampleName} img`).src.toLowerCase().match('thumb.material.png$') },
            // First item should not be a default theme since popup won't be hidden
            ['Classic-Dark', 'Classic', 'Classic-Light', 'Material', 'Stockholm'].map(theme => [
                { click : '[data-ref=infoButton]', desc : 'Click on the cog' },
                { click : '[data-ref=themeCombo]', desc : 'Click on the theme combo' },
                { click : `.b-list-item:contains(${theme})`, desc : `Switching to ${theme} theme` },
                { click : 'header', offset : ['90%', '50%'] },
                { waitForSelector : `#b-example-${exampleName} img[src="${exampleName}/meta/thumb.${theme.toLowerCase()}.png"]`, desc : 'Correct thumb image for basic example' }
            ])
        );
    });

    t.it('Check thumbnail sizes', t => {
        const steps = [];

        document.querySelectorAll('.image [loading="lazy"]').forEach(element => {
            element.removeAttribute('loading');
        });

        document.querySelectorAll('.example').forEach(example => {
            steps.push({
                waitFor : () => {
                    const
                        img  = document.querySelector(`#${example.id} img`),
                        rect = img.getBoundingClientRect();
                    return t.samePx(rect.width, t.bowser.msie ? 256 : 275, 10) && t.samePx(rect.height, t.bowser.msie ? 192 : 206, 10);
                },
                desc : `Correct image size for: "${example.id}"`
            });
        });
        t.chain(steps);
    });

    t.it('Check tooltips for examples not available offline', t => {
        if (offlineExampleName) {
            t.chain(
                { scrollIntoView : `#b-example-${offlineExampleName}` },
                { waitForSelector : `#b-example-${offlineExampleName} i.b-fa-cog`, desc : 'Correct info icon used' },
                { moveCursorTo : `#b-example-${offlineExampleName} .tooltip` },
                { waitForSelector : '.b-tooltip-content:contains(This demo needs to be built before it can be viewed)', desc : 'Tooltip shown' },
                { moveCursorTo : 'label.title', desc : 'Hiding tooltip to avoid aborting requests' },
                { waitForSelectorNotFound : '.b-tooltip', desc : 'Tooltip hidden' }
            );
        }
    });

    t.it('Should handle non existing theme ids gracefully', t => {
        let locationSearch;
        // old themes (plus extra one imitating just a bad value) mapping
        const themeNames = {
            dark    : 'Classic-Dark',
            light   : 'Classic-Light',
            default : 'Classic',
            foo     : 'Stockholm'
        };

        t.chain(
            { diag : 'Dropping theme forcing from URL' },
            {
                waitForPageLoad : null,
                trigger         : () => {
                    // location.search looks like "?theme=material" for this test
                    // so we need to reset it to test localStorage provided theme
                    locationSearch = t.global.location.search;
                    t.global.location.search = '';
                }
            },

            ['dark', 'light', 'default', 'foo'].map(theme => [
                { diag : `Trying ${theme} theme` },

                {
                    waitForPageLoad : null,
                    trigger         : () => {
                        // saving theme & reloading page
                        localStorage.setItem('b-example-theme', theme);
                        t.global.location.reload();
                    }
                },

                {
                    click : '[data-ref=infoButton]:not(.b-disabled)',
                    desc  : 'Clicked info button'
                },
                {
                    click : '[data-ref=themeCombo]',
                    desc  : 'Clicked theme button to expand dropdown list'
                },
                {
                    waitForSelector : `.b-list-item.b-selected:contains(${themeNames[theme]})`,
                    desc            : 'Correct theme is selected'
                },
                next => {
                    t.is(t.global.document.querySelector('[data-ref=themeCombo] input').value, themeNames[theme], 'Correct theme field value');
                    next();
                }
            ]),
            { diag : 'Restoring initial iframe URL back' },
            { waitForPageLoad : null, trigger : () => t.global.location.search = locationSearch }
        );
    });

    t.it('Jump to section', t => {
        t.chain(
            { waitForScroll : null },
            { click : '[data-ref=jumpTo]', desc : 'Click Jump to' },
            { click : `.b-list-item:textEquals(${jumpSectionName})`, desc : `Select ${jumpSectionName} section` },
            { waitForElementTop : `#b-example-${jumpExampleName}`, desc : `Wait for Example ${jumpExampleName} to be on top` }
        );
    });

    t.it('Filtering demos', t => {
        const count = t.query('.example').length;
        t.chain(
            { type : `${filterText}[TAB] input`, target : '[data-ref=filterField] input', desc : `Filter by "${filterText}"` },
            { waitFor : () => t.query('.example').length >= filterCount, desc : 'Wait for 3 filtered examples' },
            { type : '[ESC]', target : '[data-ref=filterField] input', desc : 'Clear filter' },
            { waitFor : () => t.query('.example').length === count, desc : 'Wait for all examples visible' }
        );
    });
});
