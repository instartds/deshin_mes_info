StartTest(t => {

    const
        [topScheduler, bottomScheduler] = bryntum.queryAll('scheduler'),
        [topSplitter, bottomSplitter]   = document.querySelectorAll('.b-grid-body-container .b-grid-splitter:not(.b-hide-display)');

    t.it('sanity', t => {
        t.chain(
            { waitForSelector : '.b-sch-event' },

            () => {
                t.checkGridSanity(topScheduler);
                // t.checkGridSanity(bottomScheduler); // Sanity check not working with hidden headers
            }
        );
    });

    t.it('Width + collapsed state should be synced when changed programmatically', t => {
        const
            sameWidth  = () => t.samePx(t.rect(topScheduler.subGrids.locked.element).width, t.rect(bottomScheduler.subGrids.locked.element).width),
            checkWidth = (width) => [
                next => {
                    t.waitForGridEvents([
                        [topScheduler.subGrids.normal, 'resize'],
                        [bottomScheduler.subGrids.normal, 'resize']
                    ], next);

                    topScheduler.subGrids.locked.width = width;
                },
                { waitFor : () => bottomScheduler.subGrids.locked.element.offsetWidth === width, desc : `Bottom locked grid has correct width ${width}` }
            ];

        t.chain(
            // Wait for both schedulers to render events
            { waitForSelector : '[data-ref=top-scheduler] .b-sch-event' },
            { waitForSelector : '[data-ref=bottom-scheduler] .b-sch-event' },

            checkWidth(160),
            checkWidth(140),

            async() => topScheduler.subGrids.locked.collapse(),
            { waitFor : () => bottomScheduler.subGrids.locked.collapsed === true, desc : `Top locked grid is collapsed` },
            { waitFor : () => sameWidth(), desc : `Locked subgrids are synchronized` },
            { waitFor : 50, desc : `Wait for Subgid's afterinternalresize() event to be removed` },

            async() => topScheduler.subGrids.locked.expand(),
            { waitFor : () => bottomScheduler.subGrids.locked.collapsed === false, desc : `Bottom locked grid is expanded` },
            { waitFor : () => sameWidth(), desc : `Locked subgrids are synchronized` }
        );
    });

    t.it('Width + collapsed state should be synced using splitters', t => {
        const
            checkWidth    = (width) => [
                { waitFor : () => topScheduler.subGrids.locked.element.offsetWidth === width, desc : `Top locked grid has correct width ${width}` },
                { waitFor : () => bottomScheduler.subGrids.locked.element.offsetWidth === width, desc : `Bottom locked grid has correct width ${width}` }
            ],

            checkCollapse = (collapsed) => [
                { waitFor : () => topScheduler.subGrids.locked.collapsed === collapsed, desc : `Top locked grid is ${collapsed ? '' : 'not'} collapsed` },
                { waitFor : () => bottomScheduler.subGrids.locked.collapsed === collapsed, desc : `Bottom locked grid is ${collapsed ? '' : 'not'} collapsed` }
            ];

        t.chain(
            // Wait for both schedulers to render events
            { waitForSelector : '[data-ref=top-scheduler] .b-sch-event' },
            { waitForSelector : '[data-ref=bottom-scheduler] .b-sch-event' },

            { drag : topSplitter, by : [20, 0], desc : 'Resize top locked grid' },
            checkWidth(160),

            { drag : bottomSplitter, by : [-20, 0], offset : [0, '10%'], desc : 'Resize bottom locked grid' },
            checkWidth(140),

            { moveMouseTo : topSplitter },
            { click : '.b-icon-collapse-gridregion', desc : 'Collapse bottom locked grid' },
            checkCollapse(true),

            { moveMouseTo : bottomSplitter },
            { click : '[data-ref="bottom-scheduler"] .b-icon-expand-gridregion', desc : 'Expand bottom locked grid' },
            checkCollapse(false)
        );
    });

    t.it('Should be able to destroy a partner with no errors', t => {
        bottomScheduler.destroy();
    });

    t.it('ResizeObserver loop limit exceeded by monkeys', t => {
        t.chain(
            { rightclick : '.b-grid-splitter' },
            { doubleclick : [308, 395] }
        );
    });

});
