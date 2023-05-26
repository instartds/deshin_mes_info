StartTest(t => {

    let scheduler;

    t.beforeEach(t => scheduler?.destroy?.());

    t.it('Should align editor correctly when previous edit changed row height', async t => {
        await t.getSchedulerAsync({
            columns : [
                { field : 'rowHeight', text : 'Height' }
            ]
        });

        await t.doubleClick('.b-grid-cell');

        await t.type(null, '100[ENTER]');

        await t.waitForSelector('.b-cell-editor');

        t.isApproxPx(t.rect('.b-cell-editor').top, 146, 'Editor positioned correctly');
    });
});
