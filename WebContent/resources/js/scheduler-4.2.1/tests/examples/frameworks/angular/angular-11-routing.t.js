StartTest(t => {
    t.it('Should not crash while routing', t => {
        t.chain(
            { waitForSelector : 'app-scheduler .b-sch-event' },
            { click : 'button:contains(Home)' },
            { waitForSelectorNotFound : 'app-scheduler .b-sch-event' },
            { waitForSelector : 'app-home' },
            { click : 'button:contains(Scheduler)' },
            { waitForSelectorNotFound : 'app-home' },
            { waitForSelector : 'app-scheduler .b-sch-event' }
        );
    });
});
