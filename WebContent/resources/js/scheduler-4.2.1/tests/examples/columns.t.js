StartTest(t => {

    t.it('Should support dragging right splitter', t => {
        const scheduler = window.scheduler;

        t.firesAtLeastNTimes(scheduler.timeAxisSubGrid, 'resize', 1);

        t.chain(
            { drag : '.b-grid-splitter[data-region=normal]', by : [-100, 0] }
        );
    });
});
